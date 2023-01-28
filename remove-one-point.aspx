<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="remove-one-point.aspx.cs" Inherits="MyMapSolution.remove_one_point" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>directionsremovewaypointHTML</title>
    <meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
    <style type='text/css'>
        body {
            margin: 0;
            padding: 0;
            overflow: hidden;
            font-family: 'Segoe UI',Helvetica,Arial,Sans-Serif
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div id='printoutPanel'></div>
            <input type="button" onclick="Clear()" value="Click" />
            <div id='myMap' style='width: 80vw; height: 80vh;'></div>
            <script type='text/javascript'>
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
                        //MyAddressObj.push(item1);

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

                var map = "";
                var directionsManager = "";
                function loadMapScenario() {
                    map = new Microsoft.Maps.Map(document.getElementById('myMap'), {
                        /* No need to set credentials if already passed in URL */
                        //center: new Microsoft.Maps.Location(23.05302443046435, 72.50106237523453),
                        zoom: 12
                    });
                    Microsoft.Maps.loadModule('Microsoft.Maps.Directions', function () {
                        directionsManager = new Microsoft.Maps.Directions.DirectionsManager(map);
                        // Set Route Mode to driving
                        directionsManager.setRequestOptions({ routeMode: Microsoft.Maps.Directions.RouteMode.driving });
                        var waypoint1 = new Microsoft.Maps.Directions.Waypoint({ location: new Microsoft.Maps.Location(23.0530670625, 72.50111525) });
                        var waypoint2 = new Microsoft.Maps.Directions.Waypoint({ location: new Microsoft.Maps.Location(23.0582952, 72.5128364) });
                        var waypoint3 = new Microsoft.Maps.Directions.Waypoint({ location: new Microsoft.Maps.Location(23.0219696500022, 72.505805299984) });
                        directionsManager.addWaypoint(waypoint1);
                        directionsManager.addWaypoint(waypoint2);
                        directionsManager.addWaypoint(waypoint3);
                        // Set the element in which the itinerary will be rendered
                        //directionsManager.setRenderOptions({ itineraryContainer: document.getElementById('printoutPanel') });
                        directionsManager.calculateDirections();
                        //Microsoft.Maps.Events.addHandler(directionsManager, 'directionsUpdated', function () {
                        //    window.setTimeout(function () {
                        //        directionsManager.clearAll();
                        //        document.getElementById('printoutPanel').innerHTML = 'Directions cleared (Waypoints cleared, map/itinerary cleared, request and render options reset to default values)';
                        //    }, 6000);
                        //});
                        GetCurrentLocation();
                        //GetNew();
                    });
                }

                function Clear() {
                    map = new Microsoft.Maps.Map(document.getElementById('myMap'), {
                        /* No need to set credentials if already passed in URL */
                        //center: new Microsoft.Maps.Location(23.05302443046435, 72.50106237523453),
                        zoom: 12
                    });
                    Microsoft.Maps.loadModule('Microsoft.Maps.Directions', function () {
                        directionsManager = new Microsoft.Maps.Directions.DirectionsManager(map);
                        directionsManager.calculateDirections();
                        Microsoft.Maps.Events.addHandler(directionsManager, 'directionsUpdated', function () {
                            directionsManager.clearAll();
                        });
                        GetNew();
                    });
                }

                var waypointLabel = "ABCDEFGHIJKLMNOPQRSTYVWXYZ";
                var waypointCnt = 0;
                function GetNew() {
                    map = new Microsoft.Maps.Map(document.getElementById('myMap'), {
                        /* No need to set credentials if already passed in URL */
                        //center: new Microsoft.Maps.Location(23.05302443046435, 72.50106237523453),
                        zoom: 12
                    });
                    Microsoft.Maps.loadModule('Microsoft.Maps.Directions', function () {
                        directionsManager = new Microsoft.Maps.Directions.DirectionsManager(map);
                        // Set Route Mode to driving
                        directionsManager.setRequestOptions({ routeMode: Microsoft.Maps.Directions.RouteMode.driving });
                        var waypoint1 = new Microsoft.Maps.Directions.Waypoint({ location: new Microsoft.Maps.Location(23.0530670625, 72.50111525) });
                        var waypoint2 = new Microsoft.Maps.Directions.Waypoint({ location: new Microsoft.Maps.Location(23.0582952, 72.5128364) });
                        directionsManager.addWaypoint(waypoint1);
                        directionsManager.addWaypoint(waypoint2);
                        directionsManager.calculateDirections();
                    });
                }
            </script>
            <script type='text/javascript' src='https://www.bing.com/api/maps/mapcontrol?key=Aj0QaseEPBN2VnIZFY8FRwqQrOiXDKPgEQuO3aH1KcoDJLdgwEpSwt3Ikxj-OYsc&callback=loadMapScenario' async defer></script>

        </div>
    </form>
</body>
</html>
