<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="change-route-color.aspx.cs" Inherits="MyMapSolution.change_route_color" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta charset="utf-8" />
    <script type='text/javascript'>
        var map, directionsManagers = [];

        function GetMap() {
            map = new Microsoft.Maps.Map('#myMap', {
                //center: new Microsoft.Maps.Location(47.7, -122.14),
                zoom: 10
            });

            //Load the directions module.
            Microsoft.Maps.loadModule('Microsoft.Maps.Directions', function () {
                //Generate some routes.
                //getRoute('Seattle, WA', 'Bellevue, WA', 'red');
                //getRoute('Kirkland, WA', 'Bothell , WA', 'blue');
                //getRoute('Woodinville, WA', 'Duval, WA', 'green');

                var Address = "";
                var Status = "0";

                Status = "1";
                /*Address = "Thaltej Ahmedabad|Bapu Nagar Ahmedabad";*/
                Address = "23.05300815983288-72.50105545511077|23.056386947631836-72.51205444335938";
                getRoute(Address, Status);

                Status = "0";
                Address = "23.056386947631836-72.51205444335938|23.031923294067383-72.50606536865234";
                getRoute(Address, Status);
            });
        }

        var waypointLabel = "ABCDEFGHIJKLMNOPQRSTYVWXYZ";
        var waypointCnt = 0;
        function getRoute(address, Status) {
            debugger;
            var dm = new Microsoft.Maps.Directions.DirectionsManager(map);
            directionsManagers.push(dm);

            dm.setRequestOptions({
                routeMode: Microsoft.Maps.Directions.RouteMode.driving
            });

            var color = "Blue";
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

            for (var i = 0; i < address.split('|').length; i++) {
                var NewAddress = address.split('|')[i].split('-');
                var latitude = NewAddress[0];
                var longitude = NewAddress[1];
                var Location = new Microsoft.Maps.Location(latitude, longitude);

                //var infobox = new Microsoft.Maps.Infobox(Location, { title: waypointLabel[waypointCnt], description: 'Seattle ' + waypointLabel[waypointCnt] });
                //infobox.setMap(map);


                //var pin = new Microsoft.Maps.Pushpin(Location, {
                //    icon: 'https://www.bingmapsportal.com/Content/images/poi_custom.png',
                //    anchor: new Microsoft.Maps.Point(12, 39)
                //});

                var pin = "";

                pin = new Microsoft.Maps.Pushpin(Location, {
                    icon: '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="52" height="49.4" viewBox="0 0 37 35" xml:space="preserve"><circle cx="32" cy="30" r="4" style="stroke-width:2;stroke:#ffffff;fill:#000000;"/><polygon style="fill:rgba(0,0,0,0.5)" points="18,1 32,30 18,18 18,1"/><rect x="2" y="2" width="15" height="15" style="stroke-width:2;stroke:#000000;fill:{color}"/><text x="9" y="13" style="font-size:11px;font-family:arial;fill:#ffffff;" text-anchor="middle">{text}</text></svg>',
                    anchor: new Microsoft.Maps.Point(42, 39),
                    color: "Green",
                    text: waypointLabel[waypointCnt]    //Give waypoints a letter as a label.
                });

                //Store the instruction information in the metadata.
                pin.metadata = {
                    //description: step.formattedText,
                    infoboxOffset: new Microsoft.Maps.Point(-30, 25)
                };

                map.entities.push(pin);


                dm.addWaypoint(new Microsoft.Maps.Directions.Waypoint({ location: Location }));

                waypointCnt++;
            }

            dm.calculateDirections();
        }
    </script>
    <script type='text/javascript' src='https://www.bing.com/api/maps/mapcontrol?callback=GetMap&key=Aj0QaseEPBN2VnIZFY8FRwqQrOiXDKPgEQuO3aH1KcoDJLdgwEpSwt3Ikxj-OYsc' async defer></script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div id="myMap" style="position: relative; width: 800px; height: 600px;"></div>
        </div>
    </form>
</body>
</html>
