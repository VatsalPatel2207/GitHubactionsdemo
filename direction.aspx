<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="direction.aspx.cs" Inherits="MyMapSolution.direction" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>directionsevent_directionsupdatedHTML</title>
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

        <div id='myMap' style="position: relative; width: 600px; height: 400px;"></div>
        <script type='text/javascript'>
            var map;

            function GetCurrentLocation() {
                debugger;

                navigator.geolocation.getCurrentPosition(function (position) {
                    var loc = new Microsoft.Maps.Location(
                        position.coords.latitude,
                        position.coords.longitude);

                    CurrentLocation = loc;

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

            function loadMapScenario() {
                map = new Microsoft.Maps.Map(document.getElementById('myMap'), {
                    /* No need to set credentials if already passed in URL */
                    //center: new Microsoft.Maps.Location(47.606209, -122.332071),
                    //zoom: 12
                });
                Microsoft.Maps.loadModule('Microsoft.Maps.Directions', function () {
                    GetCurrentLocation();

                    debugger;
                    var directionsManager = new Microsoft.Maps.Directions.DirectionsManager(map);
                    // Set Route Mode to driving
                    directionsManager.setRequestOptions({ routeMode: Microsoft.Maps.Directions.RouteMode.driving });
                    var waypoint1 = new Microsoft.Maps.Directions.Waypoint({ address: 'Seattle', location: new Microsoft.Maps.Location(23.062183380126953, 72.4969711303711) });
                    var waypoint2 = new Microsoft.Maps.Directions.Waypoint({ address: 'Seattle', location: new Microsoft.Maps.Location(23.03266143798828, 72.6294937133789) });
                    directionsManager.addWaypoint(waypoint1);
                    directionsManager.addWaypoint(waypoint2);
                    //Microsoft.Maps.Events.addHandler(directionsManager, 'directionsUpdated', function () {
                    //    document.getElementById('printoutPanel').innerHTML = 'Directions updated event fired!!!';
                    //});
                    directionsManager.calculateDirections();
                });

            }
        </script>
        <script type='text/javascript' src='https://www.bing.com/api/maps/mapcontrol?key=Aj0QaseEPBN2VnIZFY8FRwqQrOiXDKPgEQuO3aH1KcoDJLdgwEpSwt3Ikxj-OYsc&callback=loadMapScenario' async defer></script>
    </form>
</body>
</html>
