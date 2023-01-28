<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="make-direction.aspx.cs" Inherits="MyMapSolution.make_direction" %>

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
        var MyAddressObj = [];

        var Address = "Thaltej Ahmedabad|Bapu Nagar Ahmedabad|Ranip Ahmedabad".split('|');

        function GetLocationOrderBy() {

            var PrimaryLocation = "";
            for (var i = 0; i < Address.length; i++) {
                var LocationAddress = Address[i];

                var geocodeRequest = "http://dev.virtualearth.net/REST/v1/Locations?query=" + encodeURIComponent(LocationAddress) + "&jsonp=GeocodeCallback&key=" + MyKey;

                var xmlHttp = new XMLHttpRequest();
                xmlHttp.open("GET", geocodeRequest, false); // false for synchronous request
                xmlHttp.send(null);
                var response = xmlHttp.responseText;
                response = JSON.parse(response.replace("GeocodeCallback", "").replace("(", "").replace(")", ""));
                var GeoPoint = response.resourceSets[0].resources[0].geocodePoints[0].coordinates;

                debugger;
                var DistanceMile = "";
                if (PrimaryLocation == "") {
                    var Location = new Microsoft.Maps.Location(GeoPoint[0], GeoPoint[1]);
                    PrimaryLocation = Location;
                }
                else {
                    var Location = new Microsoft.Maps.Location(GeoPoint[0], GeoPoint[1]);

                    DistanceMile = Microsoft.Maps.SpatialMath.getDistanceTo(Location, PrimaryLocation, Microsoft.Maps.SpatialMath.DistanceUnits.Miles);
                }

                item1 = {}
                item1[0] = LocationAddress;
                item1[1] = Math.round(DistanceMile, 0);
                MyAddressObj.push(item1);
            }

            MyAddressObj.sort(function (a, b) {
                return a[1] - b[1]
            });
        }

        function GetCurrentLocation() {
            debugger;

            navigator.geolocation.getCurrentPosition(function (position) {
                var loc = new Microsoft.Maps.Location(
                    position.coords.latitude,
                    position.coords.longitude);

                CurrentLocation = loc;

                //Add a pushpin at the user's location.
                var pin = new Microsoft.Maps.Pushpin(loc);
                map.entities.push(pin);

                //Center the map on the user's location.
                map.setView({ center: loc });
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

                GetLocationOrderBy();

                //Create an instance of the directions manager.
                directionsManager = new Microsoft.Maps.Directions.DirectionsManager(map);
                directionsManager.setRequestOptions({
                    routeMode: Microsoft.Maps.Directions.RouteMode.driving
                });

                $("#myAddresses").html('');
                for (var i = 0; i < MyAddressObj.length; i++) {
                    var location = new Microsoft.Maps.Directions.Waypoint({ address: MyAddressObj[i][0] });
                    directionsManager.addWaypoint(location);

                    MakeHTML(MyAddressObj[i][0], MyAddressObj[i][1])
                }

                //Add an event handler to the directions manager.
                Microsoft.Maps.Events.addHandler(directionsManager, 'directionsUpdated', directionsUpdated);

                //Calculate directions.
                directionsManager.calculateDirections();

            });
        }

        function MakeHTML(LocationAddress, LocationMiles) {
            var Html = "";
            if ($("#myAddresses").html() == "") {
                Html += "<div style='width:50%;float:left;font-weight:bold;padd'>Location</div>";
                Html += "<div style='width:50%;float:left;font-weight:bold;'>Distance (Miles)</div>";

                Html += "<div style='width:50%;float:left;'>" + LocationAddress + "</div>";
                Html += "<div style='width:50%;float:left;'>Your Location</div>";
            }
            else {
                Html += "<div style='width:50%;float:left;'>" + LocationAddress + "</div>";
                Html += "<div style='width:50%;float:left;'>" + LocationMiles + " Miles</div>";
            }
            $("#myAddresses").append(Html);
        }

        function directionsUpdated(e) {

            //Get the current route index.
            var routeIdx = directionsManager.getRequestOptions().routeIndex;

            var route = e.route[routeIdx];

            var locs = [];
            var distances = [0];
            var incrementer = 1;

            //If there are too many locations, the URL to the elevation service will be too long for the browser.
            //For simplicity skip every n'th location.
            if (route.routePath.length > maxElevationSteps) {
                incrementer = Math.ceil(route.routePath.length / maxElevationSteps);
            }

            debugger;
            var distance = 0;
            var loc = route.routePath[0];

            for (var i = 1; i < route.routePath.length; i += incrementer) {
                //Calculate the current distance along the route path.
                distance += Microsoft.Maps.SpatialMath.getDistanceTo(loc, route.routePath[i], Microsoft.Maps.SpatialMath.DistanceUnits.Miles);
                distances.push(distance);

                //Add the current location to the location array.
                loc = route.routePath[i];
                locs.push(loc);
            }

            //NewTest(route);
        }

        function NewTest(route) {
            var pushpin = new Microsoft.Maps.Pushpin(new Microsoft.Maps.Location(23.062266, 72.497202), { title: 'sample text' });
            var polyline = new Microsoft.Maps.Polyline([
                new Microsoft.Maps.Location(23.060972, 72.497518),
                new Microsoft.Maps.Location(23.056033, 72.506039),
                new Microsoft.Maps.Location(23.058598, 72.519831),
                new Microsoft.Maps.Location(23.069945, 72.523265),
                new Microsoft.Maps.Location(23.093939, 72.530282),
                new Microsoft.Maps.Location(23.098653, 72.531489),
                new Microsoft.Maps.Location(23.07054, 72.559799),
                new Microsoft.Maps.Location(23.07446, 72.564631),
                new Microsoft.Maps.Location(23.075973, 72.564694)], { strokeColor: 'red', strokeThickness: 5 });
            var layer = new Microsoft.Maps.Layer();
            layer.add([pushpin, polyline]);
            map.layers.insert(layer);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div style="display: flex;">
            <div id="myMap" style="position: relative; width: 600px; height: 400px;"></div>
            <div id="myAddresses" style="position: relative; line-height: 25px; border: 1px solid black; margin: 10px; width: 500px;"></div>
        </div>
    </form>
</body>
</html>
