<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="make-direction-current-location-2.aspx.cs" Inherits="MyMapSolution.make_direction_current_location_2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta charset="utf-8" />
    <script type='text/javascript' src='https://www.bing.com/api/maps/mapcontrol?callback=GetMap'></script>
    <script type='text/javascript' src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.1.1.min.js"></script>
    <script src="https://d3js.org/d3.v4.min.js"></script>
    <script type='text/javascript'>

        var map, sessionKey;
        var MyKey = "Aj0QaseEPBN2VnIZFY8FRwqQrOiXDKPgEQuO3aH1KcoDJLdgwEpSwt3Ikxj-OYsc";
        var maxElevationSteps = 300;

        var CurrentLocation = "";
        var NewStartLocation = "";
        var StartLocation = "Current Location";

        var TotalDestination = 0;
        var MyAddressObj = [];
        var CompleteAnyJourneyStatus = 0;

        function GetCurrentLocation() {
            debugger;

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
                MyAddressObj.push(item1);

                //Add a pushpin at the user's location.
                var pin = new Microsoft.Maps.Pushpin(loc, {
                    icon: 'https://www.bingmapsportal.com/Content/images/poi_custom.png',
                    anchor: new Microsoft.Maps.Point(12, 39)
                });
                map.entities.push(pin);

                //Center the map on the user's location.
                map.setView({ center: loc });
                debugger;
                //var infoboxTemplate = '<div id="infoboxText" style="background-color:White; border-style:solid; border-width:medium; border-color:DarkOrange; min-height:50px; width: 100px;">' +
                //    '<b id="infoboxTitle" style="position: absolute; top: 10px; left: 10px; width: 120px;">Current Location</b>' +
                //    '</div>';
                //var center = map.getCenter();
                //var infobox = new Microsoft.Maps.Infobox(center, { htmlContent: infoboxTemplate });
                //infobox.setMap(map);
            });
        }

        function GetMap() {
            map = new Microsoft.Maps.Map('#myMap', {
                credentials: MyKey
            });

            map.getCredentials(function (c) {
                sessionKey = c;
            });

            //Load the directions and spatial math modules.
            Microsoft.Maps.loadModule(['Microsoft.Maps.Directions', 'Microsoft.Maps.SpatialMath'], function () {
                GetCurrentLocation();
            });
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

                GetDistanceByAddress(Address);

                $("#tblLocations").append(html);
                $("#txtDestination").val('');
            }
        }

        function GetDistanceByAddress(LocationAddress) {
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
            $("#tblJourneyDetails").html('');
            //-- Make Addresses Order By Distance
            MyAddressObj.sort(function (a, b) {
                return a[3] - b[3]
            });

            Microsoft.Maps.loadModule('Microsoft.Maps.Directions', function () {

                debugger;
                directionsManager = new Microsoft.Maps.Directions.DirectionsManager(map);
                // Set Route Mode to driving
                directionsManager.setRequestOptions({ routeMode: Microsoft.Maps.Directions.RouteMode.driving });

                for (var i = 0; i < MyAddressObj.length; i++) {
                    var Address = MyAddressObj[i][0];
                    var latitude = MyAddressObj[i][1];
                    var longitude = MyAddressObj[i][2];
                    var Distance = MyAddressObj[i][3];
                    var StartLocation = MyAddressObj[i][4];
                    var waypoint1 = new Microsoft.Maps.Directions.Waypoint({location: new Microsoft.Maps.Location(latitude, longitude) });
                    directionsManager.addWaypoint(waypoint1);

                    if (i > 0) {
                        var Status = "Pending";
                        JourneyDetail(i, StartLocation, Address, Distance, Status);
                    }
                }

                if (CompleteAnyJourneyStatus == 1) {
                    Microsoft.Maps.Events.addHandler(directionsManager, 'directionsUpdated', function () {
                        debugger;
                        var routeIdx = directionsManager.getRequestOptions().routeIndex;

                        CompleteStep(directionsManager);
                    });
                }

                //Microsoft.Maps.Events.addHandler(directionsManager, 'directionsUpdated', directionsUpdated);
                directionsManager.calculateDirections();

            });
        }

        function JourneyDetail(Index, StartPoint, EndPoint, Distance, Status) {
            var html = "";
            if ($("#tblJourneyDetails").html() == "") {
                html += "<tr><td>Index</td><td>Start Point</td><td>End Point</td><td>Distance</td><td>Status</td></tr>";
            }

            html += "<tr>";
            html += "    <td>" + Index;
            html += "    </td>";
            html += "    <td>" + StartPoint;
            html += "    </td>";
            html += "    <td>" + EndPoint;
            html += "    </td>";
            html += "    <td>" + Math.round(Distance, 3);
            html += "    </td>";
            html += "    <td>" + Status;
            html += "    </td>";
            html += "</tr>";

            $("#tblJourneyDetails").append(html);
        }

        function Complete() {
            CompleteAnyJourneyStatus = 1;
            StartJourney();
        }

        var Temp1 = [];
        var Temp2 = [];
        function CompleteStep(directionsManager) {
            debugger;
            var Data = directionsManager.getRouteResult()[0].routePath;
            Temp1 = Data;
            //var pushpin = new Microsoft.Maps.Pushpin(new Microsoft.Maps.Location(23.044023, 72.508711));
            var polyline = new Microsoft.Maps.Polyline(Data, { strokeColor: 'red', strokeThickness: 7 });
            //var polyline = Testing();

            var layer = new Microsoft.Maps.Layer();
            //layer.add([pushpin, polyline]);
            layer.add([polyline]);
            map.layers.insert(layer);
        }

        var AllPoints = [];
        function GetDestinationPointsData(directionsManager) {
            debugger;
            var Data = directionsManager.getRouteResult()[0].routePath;

            item = {}
            item[0] = Data;
            AllPoints.push(item);
        }

        function Testing1(directionsManager) {
            debugger;
            var Data = directionsManager.getRouteResult()[0].routePath;

            item = {}
            item[0] = Data;
            AllPoints.push(item);
        }

        function Testing() {
            var polyline = new Microsoft.Maps.Polyline([
                new Microsoft.Maps.Location(23.05311, 72.500947),
                new Microsoft.Maps.Location(23.052025, 72.500006),
                new Microsoft.Maps.Location(23.053842, 72.501591),
                new Microsoft.Maps.Location(23.058167, 72.511279),
                new Microsoft.Maps.Location(23.055631, 72.511196),
                new Microsoft.Maps.Location(23.055661, 72.512083)
                //new Microsoft.Maps.Location(23.052925, 72.500762),
                //new Microsoft.Maps.Location(23.052024, 72.500006),
                //new Microsoft.Maps.Location(23.052044, 72.499966),
                //new Microsoft.Maps.Location(23.052589, 72.500355),
                //new Microsoft.Maps.Location(23.053842, 72.50159),
                //new Microsoft.Maps.Location(23.053916, 72.501649),
                //new Microsoft.Maps.Location(23.054359, 72.502135),
                //new Microsoft.Maps.Location(23.054854, 72.503056)

            ], { strokeColor: 'red', strokeThickness: 5 });

            return polyline;
        }

        function directionsUpdated(e) {

            //Get the current route index.
            var routeIdx = directionsManager.getRequestOptions().routeIndex;

            var route = e.route[routeIdx];
            var pushpin = "";
            var Data = [];
            for (var i = 0; i < route.routeLegs[0].itineraryItems.length; i++) {
                item = {}
                item[0] = route.routeLegs[0].itineraryItems[i].coordinate; // Destincation
                Data.push(item);
            }
            Temp2 = Data;
            //var pushpin = new Microsoft.Maps.Pushpin(new Microsoft.Maps.Location(Data[0][0].latitude, Data[0][0].longitude));
            var polyline = new Microsoft.Maps.Polyline(Data, { strokeColor: 'red', strokeThickness: 5 });

            var layer = new Microsoft.Maps.Layer();
            layer.add([polyline]);
            map.layers.insert(layer);
        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div style="display: flex;">
            <div id="myMap" style="position: relative; width: 600px; height: 400px;"></div>
            <div id="myAddresses" style="position: relative; line-height: 25px; border: 1px solid black; margin: 10px; width: 500px;">
                <div>
                    <table>
                        <tr>
                            <td>Destination
                            </td>
                            <td>
                                <input id="txtDestination" type="text" />
                            </td>
                            <td>
                                <input id="btnAdd" type="button" value="Add" onclick="FillLocation()" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <table id="tblLocations" rules="all" style="border: 1px solid black; line-height: 20px;" cellspacing="4" cellpadding="5"></table>
                                <input id="btnStartJourney" type="button" style="display: none;" value="Start Journey" onclick="StartJourney()" />
                                <input id="btnClearAddress" type="button" style="display: none;" value="Reset All" onclick="Clear()" />
                            </td>
                        </tr>
                    </table>
                    <hr />
                    <table id="tblJourneyDetails" rules="all" style="border: 1px solid black; line-height: 20px;" cellspacing="4" cellpadding="5">
                    </table>
                    <input id="btnTest" type="button" value="Test" onclick="Complete()" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
