<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="calculate-distance-new.aspx.cs" Inherits="MyMapSolution.calculate_distance_new" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Drag Pushpin</title>
    <meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
    <style type='text/css'>
        body {
            margin: 0;
            padding: 0;
            overflow: hidden;
            font-family: 'Segoe UI',Helvetica,Arial,Sans-Serif;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div id='printoutPanel'></div>
        <div id='divLatitudeUp'></div>
        <div id='divLongitudeUp'></div>
        <div id='divDistance'></div>
        <div id='myMap'></div>
        <script type='text/javascript' src='https://www.bing.com/api/maps/mapcontrol?key=Aj0QaseEPBN2VnIZFY8FRwqQrOiXDKPgEQuO3aH1KcoDJLdgwEpSwt3Ikxj-OYsc&callback=loadMapScenario' async defer></script>

        <script type='text/javascript'>
            var zoomLevel = 10;
            var map;
            var vLatitude = "23.2156";
            var vLongitude = "72.6369";

            // Pushpin Dragend event.
            function pushPinDragEndEvent(id, e) {
                var point = new Microsoft.Maps.Point(e.getX(), e.getY());
                var loc = e.target.getLocation();;
                var location = new Microsoft.Maps.Location(loc.latitude, loc.longitude);
                if (id == "pushpinDragEnd") {
                    document.getElementById("divLatitudeUp").innerHTML = "Latitude : " + loc.latitude;
                    document.getElementById("divLongitudeUp").innerHTML = "Longitude : " + loc.longitude;
                    getDistanceBetweenLocations(location, new Microsoft.Maps.Location(vLatitude, vLongitude));
                    //getLayerBetweenLocations(location, new Microsoft.Maps.Location(vLatitude, vLongitude));
                }
            }

            function loadMapScenario() {
                var map = new Microsoft.Maps.Map(document.getElementById('myMap'), { zoom: zoomLevel });
                var center = map.getCenter();
                var Events = Microsoft.Maps.Events;
                var Location = Microsoft.Maps.Location;
                var Pushpin = Microsoft.Maps.Pushpin;
                var loc = new Location(center.latitude, center.longitude);

                var dragablePushpin = new Pushpin(loc, { color: '#00F', draggable: true });
                map = new Microsoft.Maps.Map(document.getElementById('myMap'), { center: loc, zoom: zoomLevel });
                Events.addHandler(dragablePushpin, 'dragend', function (e) { pushPinDragEndEvent('pushpinDragEnd', e); });
                map.entities.push(dragablePushpin);

                var pushpin = new Microsoft.Maps.Pushpin(new Location(vLatitude, vLongitude), {
                    icon: 'https://bingmapsisdk.blob.core.windows.net/isdksamples/defaultPushpin.png',
                    anchor: new Microsoft.Maps.Point(12, 39),
                });
                map.entities.push(pushpin);
                var viewBoundaries = Microsoft.Maps.LocationRect.fromLocations(pushpin.getLocation());
                map.setView({ bounds: viewBoundaries });
                map.setView({ zoom: 10 });

            }

            // Calculate distance between two locations.
            function getDistanceBetweenLocations(Location1, Location2) {
                Microsoft.Maps.loadModule('Microsoft.Maps.SpatialMath', function () {
                    var vDistance = Microsoft.Maps.SpatialMath.getDistanceTo(Location1, Location2, Microsoft.Maps.SpatialMath.DistanceUnits.Miles);
                    document.getElementById('divDistance').innerHTML = "Distance in Miles : " + vDistance;
                });
            }
        // function getLayerBetweenLocations(Location1, Location2) {
        //     var map = new Microsoft.Maps.Map(document.getElementById('myMap'), { zoom: zoomLevel });
        //     alert(map);
        //     Microsoft.Maps.loadModule('Microsoft.Maps.SpatialMath', function () {
        //             var locs = Microsoft.Maps.SpatialMath.getLocations(Location1,Location2, map.getBounds());
        //             alert(locs);
        //             for (var i = 0; i < locs.length; i++) {
        //                 map.entities.push(new Microsoft.Maps.Pushpin(locs[i]));
        //             }
        //             locs = Microsoft.Maps.SpatialMath.getCardinalSpline(locs);
        //             var spline = new Microsoft.Maps.Polyline(locs, { strokeThickness: 3 });
        //             map.entities.push(spline);
        //         });
        // }
        </script>
    </form>
</body>
</html>
