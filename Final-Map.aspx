<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Final-Map.aspx.cs" Inherits="MyMapSolution.Final_Map" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Final Page With Direction Color Change</title>
    <meta charset="utf-8" />
    <script type='text/javascript' src='https://www.bing.com/api/maps/mapcontrol?callback=GetMap'></script>
    <script type='text/javascript' src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.1.1.min.js"></script>
    <script src="https://d3js.org/d3.v4.min.js"></script>

    <script type="text/javascript">
        var map, sessionKey, directionsManagers = [], directionWaypointLayer, infobox;
        var MyKey = "Aj0QaseEPBN2VnIZFY8FRwqQrOiXDKPgEQuO3aH1KcoDJLdgwEpSwt3Ikxj-OYsc";
        var maxElevationSteps = 300;

        var CurrentLocation = "";
        var NewStartLocation = "";
        var StartLocation = "Current Location";

        var TotalDestination = 0;
        var MyAddressObj = [];
        var JourneyStatus = "Pending";
        var CompletePoint = 0;


        function GetCurrentLocation() {
            navigator.geolocation.getCurrentPosition(function (position) {
                var loc = new Microsoft.Maps.Location(
                    position.coords.latitude,
                    position.coords.longitude);

                CurrentLocation = loc;

                //-- Add Current Location In Array
                item1 = {}
                item1[0] = "Current Location";
                item1[1] = position.coords.latitude;
                item1[2] = position.coords.longitude;
                item1[3] = 0;
                item1[4] = "Current Location";
                item1[5] = 0;
                MyAddressObj.push(item1);

                //Add a pushpin at the user's location.
                var pin = new Microsoft.Maps.Pushpin(loc, {
                    icon: 'https://www.bingmapsportal.com/Content/images/poi_custom.png',
                    anchor: new Microsoft.Maps.Point(12, 39)
                });
                map.entities.push(pin);

                //Center the map on the user's location.
                map.setView({ center: loc });

                $("#myAddresses").fadeIn('slow');
            });
        }

        function GetMap() {
            map = new Microsoft.Maps.Map('#myMap', {
                credentials: MyKey
            });

            map.getCredentials(function (c) {
                sessionKey = c;
            });

            //Create a layer for managing custom waypoints.
            directionWaypointLayer = new Microsoft.Maps.Layer();

            //Add mouse events for showing instruction when hovering pins in directions waypoint layer.
            Microsoft.Maps.Events.addHandler(directionWaypointLayer, 'mouseover', showInstruction);
            Microsoft.Maps.Events.addHandler(directionWaypointLayer, 'mouseout', hideInstruction);

            map.layers.insert(directionWaypointLayer);

            //Create a reusable infobox.
            infobox = new Microsoft.Maps.Infobox(map.getCenter(), {
                showCloseButton: false,
                visible: false
            });
            infobox.setMap(map);

            //Load the directions and spatial math modules.
            Microsoft.Maps.loadModule(['Microsoft.Maps.Directions', 'Microsoft.Maps.SpatialMath'], function () {
                GetCurrentLocation();
            });
        }

        function showInstruction(e) {
            infobox.setOptions({
                location: e.target.getLocation(),
                description: e.target.metadata.description,
                offset: e.target.metadata.infoboxOffset,
                visible: true
            });
        }

        function hideInstruction() {
            infobox.setOptions({ visible: false });
        }

        function FillLocation() {
            if ($("#txtDestination").val() != "") {
                var Address = $("#txtDestination").val();
                TotalDestination++;
                var html = "";
                if ($("#tblLocations").html() == "") {
                    html += "<tr><td><b>Index</b></td ><td><b>Destination</b></td ></tr >";
                    $("#btnStartJourney").show();
                    $("#btnClearAddress").show();
                }
                html += "<tr><td>" + TotalDestination + "</td ><td>" + Address + "</td ></tr >";

                GetDistanceByAddress(Address, $("#ddlPriority").val());

                $("#tblLocations").append(html);
                $("#txtDestination").val('');
                $("#ddlPriority").val('1');
            }
        }

        function GetDistanceByAddress(LocationAddress, Priority) {
            var geocodeRequest = "http://dev.virtualearth.net/REST/v1/Locations?query=" + encodeURIComponent(LocationAddress) + "&jsonp=GeocodeCallback&key=" + MyKey;

            var xmlHttp = new XMLHttpRequest();
            xmlHttp.open("GET", geocodeRequest, false); // false for synchronous request
            xmlHttp.send(null);
            var response = xmlHttp.responseText;
            response = JSON.parse(response.replace("GeocodeCallback", "").replace("(", "").replace(")", ""));
            var GeoPoint = response.resourceSets[0].resources[0].geocodePoints[0].coordinates;

            debugger;
            var DistanceMile = "";
            var Location = new Microsoft.Maps.Location(GeoPoint[0], GeoPoint[1]);
            DistanceMile = Microsoft.Maps.SpatialMath.getDistanceTo(Location, CurrentLocation, Microsoft.Maps.SpatialMath.DistanceUnits.Miles);

            item1 = {}
            item1[0] = LocationAddress; // Destincation
            item1[1] = GeoPoint[0];
            item1[2] = GeoPoint[1];
            item1[3] = DistanceMile;
            item1[4] = StartLocation;
            item1[5] = parseFloat(Priority);
            MyAddressObj.push(item1);
        }

        function Clear() {
            $("#tblLocations").html('');
            $("#btnStartJourney").hide();
            $("#btnClearAddress").hide();
            TotalDestination = 0;
            $("#txtDestination").val('');
            MyAddressObj = [];
            $("#tblJourneyDetails").html('');
        }

        function StartJourney() {
            JourneyStatus = "Pending";
            $("#tblJourneyDetails").html('');
            //-- Make Addresses Order By Distance
            MyAddressObj[0][5] = (TotalDestination + 1);
            MyAddressObj.sort((a, b) => (b[5] - a[5] || a[3] - b[3]));

            //Load the directions module.
            Microsoft.Maps.loadModule('Microsoft.Maps.Directions', function () {
                var Status = "0";
                getRoute(MyAddressObj, Status);
            });

            JourneyStatus = "Start";
        }

        var waypointLabel = "ABCDEFGHIJKLMNOPQRSTYVWXYZ";
        var waypointCnt = 0;
        function getRoute(addresses, Status) {
            debugger;
            var dm = new Microsoft.Maps.Directions.DirectionsManager(map);
            directionsManagers.push(dm);

            dm.setRequestOptions({
                routeMode: Microsoft.Maps.Directions.RouteMode.driving
            });

            var color = "SkyBlue";
            var strokeThickness = "5";
            if (Status == "1") {
                color = "Green";
                strokeThickness = "7";
            }

            dm.setRenderOptions({
                autoUpdateMapView: false,
                drivingPolylineOptions: {
                    strokeColor: color,
                    strokeThickness: strokeThickness
                }
                , firstWaypointPushpinOptions: { visible: false },
                lastWaypointPushpinOptions: { visible: false },
                waypointPushpinOptions: { visible: false }
            });

            if (waypointCnt > 0) {
                waypointCnt--;
            }

            var wp = [];
            for (var i = 0; i < addresses.length; i++) {
                var NewAddress = addresses[i];
                var Address = NewAddress[0];
                var latitude = NewAddress[1];
                var longitude = NewAddress[2];
                var Distance = NewAddress[3];
                var StartLocation = NewAddress[4];
                var Location = new Microsoft.Maps.Location(latitude, longitude);

                //-- This case for when we are creating all addresses direction
                if (JourneyStatus == "Pending") {
                    var pin = new Microsoft.Maps.Pushpin(Location, {
                        icon: '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="52" height="49.4" viewBox="0 0 37 35" xml:space="preserve"><circle cx="32" cy="30" r="4" style="stroke-width:2;stroke:#ffffff;fill:#000000;"/><polygon style="fill:rgba(0,0,0,0.5)" points="18,1 32,30 18,18 18,1"/><rect x="2" y="2" width="15" height="15" style="stroke-width:2;stroke:#000000;fill:{color}"/><text x="9" y="13" style="font-size:11px;font-family:arial;fill:#ffffff;" text-anchor="middle">{text}</text></svg>',
                        anchor: new Microsoft.Maps.Point(42, 39),
                        color: "Blue",
                        text: waypointLabel[waypointCnt]    //Give waypoints a letter as a label.
                    });

                    //Store the instruction information in the metadata.
                    pin.metadata = {
                        description: Address,
                        infoboxOffset: new Microsoft.Maps.Point(-30, 25)
                    };

                    map.entities.push(pin);
                    dm.addWaypoint(new Microsoft.Maps.Directions.Waypoint({ location: Location }));
                    waypointCnt++;

                    if (i > 0) {
                        var Status = "Pending";
                        JourneyDetail(i, StartLocation, Address, Distance, Status);
                    }

                    wp.push(pin);
                }
                else {
                    //-- This case is for when we complete any destination
                    //var pin = new Microsoft.Maps.Pushpin(Location, {
                    //    icon: '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="52" height="49.4" viewBox="0 0 37 35" xml:space="preserve"><circle cx="32" cy="30" r="4" style="stroke-width:2;stroke:#ffffff;fill:#000000;"/><polygon style="fill:rgba(0,0,0,0.5)" points="18,1 32,30 18,18 18,1"/><rect x="2" y="2" width="15" height="15" style="stroke-width:2;stroke:#000000;fill:{color}"/><text x="9" y="13" style="font-size:11px;font-family:arial;fill:#ffffff;" text-anchor="middle">{text}</text></svg>',
                    //    anchor: new Microsoft.Maps.Point(42, 39),
                    //    color: "Green",
                    //    text: waypointLabel[waypointCnt]    //Give waypoints a letter as a label.
                    //});

                    ////Store the instruction information in the metadata.
                    //pin.metadata = {
                    //    description: Address,
                    //    infoboxOffset: new Microsoft.Maps.Point(-30, 25)
                    //};

                    //map.entities.push(pin);

                    dm.addWaypoint(new Microsoft.Maps.Directions.Waypoint({ location: Location }));

                    if (i == CompletePoint) {
                        break;
                    }
                }
            }

            wp.reverse();
            //Add the pins to the map. 
            directionWaypointLayer.add(wp);

            dm.calculateDirections();
        }

        function JourneyDetail(Index, StartPoint, EndPoint, Distance, Status) {
            var html = "";
            if ($("#tblJourneyDetails").html() == "") {
                html += "<tr><td>Index</td><td>Start Point</td><td>End Point</td><td>Distance</td><td style='width:85px;'>Status</td></tr>";
            }

            var StatusHtml = "<input id='cbStatus" + Index + "' type='checkbox' name='cbStatus" + Index + "' onclick='JourneyComplete(" + Index + ")' />"
                + "<label id='lblStatus" + Index + "' for= 'cbStatus" + Index + "' > Pending</label> ";

            html += "<tr>";
            html += "    <td>" + Index;
            html += "    </td>";
            html += "    <td>" + StartPoint;
            html += "    </td>";
            html += "    <td>" + EndPoint;
            html += "    </td>";
            html += "    <td>" + Math.round(Distance, 3);
            html += "    </td>";
            html += "    <td>" + StatusHtml;
            html += "    </td>";
            html += "</tr>";

            $("#tblJourneyDetails").append(html);
        }

        function JourneyComplete(index) {
            $("#lblStatus" + index)[0].innerText = "Completed";
            $("#lblStatus" + index).addClass("Done");
            $("#cbStatus" + index).css("display", "none");
            CompletePoint = index;
            getRoute(MyAddressObj, "1");
        }
    </script>
    <style type="text/css">
        .Done {
            color: green;
            font-weight: bold;
        }

        .MicrosoftMap .Infobox .infobox-body {
            padding-bottom: 4px;
            background: white;
            box-shadow: 0px 10px 16px grey;
        }

        .MicrosoftMap .Infobox.no-close.no-title .infobox-info {
            margin-right: auto;
            color: black;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div style="display: flex;">
            <div id="myMap" style="position: relative; width: 600px; height: 400px;"></div>
            <div id="myAddresses" style="position: relative; line-height: 25px; width: 600px; display: none;">
                <div style="border: 1px solid black; margin: 10px;">
                    <table style="width: 100%; padding: 10px;">
                        <tr>
                            <td valign="top">Destination
                            </td>
                            <td valign="top">
                                <textarea rows="2" cols="20" id="txtDestination" style="width: 430px;"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td>Priority
                            </td>
                            <td>
                                <select id="ddlPriority" style="width: 100px;">
                                    <option value="1">Normal</option>
                                    <option value="2">Medium</option>
                                    <option value="3">High</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <input id="btnAdd" type="button" value="Add" onclick="FillLocation()" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <table id="tblLocations" rules="all" style="border: 1px solid black; line-height: 20px;" cellspacing="4" cellpadding="5"></table>
                                <input id="btnStartJourney" type="button" style="display: none;" value="Start Journey" onclick="StartJourney()" />
                                <%--<input id="btnClearAddress" type="button" style="display: none;" value="Reset All" onclick="Clear()" />--%>
                            </td>
                        </tr>
                    </table>
                    <hr />
                    <div style="padding: 10px;">
                        <table id="tblJourneyDetails" rules="all" style="width: 100%; border: 1px solid black; line-height: 20px;" cellspacing="4" cellpadding="5">
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
