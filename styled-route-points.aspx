﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="styled-route-points.aspx.cs" Inherits="MyMapSolution.styled_route_points" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta charset="utf-8" />
    <script type='text/javascript'>
        var map, infobox, directionsManager, directionWaypointLayer;

        function GetMap() {
            map = new Microsoft.Maps.Map('#myMap', {});

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

            //Load the directions module.
            Microsoft.Maps.loadModule('Microsoft.Maps.Directions', function () {
                //Create an instance of the directions manager.
                directionsManager = new Microsoft.Maps.Directions.DirectionsManager(map);
                directionsManager.setRequestOptions({
                    routeMode: Microsoft.Maps.Directions.RouteMode.driving
                });

                //Create waypoints to route between.
                directionsManager.addWaypoint(new Microsoft.Maps.Directions.Waypoint({ address: 'Thaltej Ahmedabad' }));
                directionsManager.addWaypoint(new Microsoft.Maps.Directions.Waypoint({ address: 'Bapu Nagar Ahmedabad' }));
                directionsManager.addWaypoint(new Microsoft.Maps.Directions.Waypoint({ address: 'Ranip Ahmedabad' }));

                //Hide all default waypoint pushpins
                directionsManager.setRenderOptions({
                    firstWaypointPushpinOptions: { visible: false },
                    lastWaypointPushpinOptions: { visible: false },
                    waypointPushpinOptions: { visible: false }
                });

                Microsoft.Maps.Events.addHandler(directionsManager, 'directionsUpdated', directionsUpdated);

                //Calculate directions.
                directionsManager.calculateDirections();
            });
        }

        function directionsUpdated(e) {
            directionWaypointLayer.clear();

            if (e.route && e.route.length > 0) {
                var route = e.route[0];

                var waypointCnt = 0;
                var stepCount = 0;

                var waypointLabel = "ABCDEFGHIJKLMNOPQRSTYVWXYZ";

                var wp = [];
                var step;
                var isWaypoint;
                var waypointColor;

                debugger;
                for (var i = 0; i < route.routeLegs.length; i++) {
                    for (var j = 0; j < route.routeLegs[i].itineraryItems.length; j++) {
                        stepCount++;
                        isWaypoint = true;

                        step = route.routeLegs[i].itineraryItems[j];

                        if (j == 0) {
                            if (i == 0) {
                                //Start Endpoint, make it green.
                                waypointColor = '#008f09';
                            } else {
                                //Midpoint Waypoint, make it gray,
                                waypointColor = '#737373';
                            }
                        } else if (i == route.routeLegs.length - 1 && j == route.routeLegs[i].itineraryItems.length - 1) {
                            //End waypoint, make it red.
                            waypointColor = '#d60000';

                        } else {
                            //Instruction step
                            isWaypoint = false;
                        }

                        if (isWaypoint) {
                            pin = new Microsoft.Maps.Pushpin(step.coordinate, {
                                icon: '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="52" height="49.4" viewBox="0 0 37 35" xml:space="preserve"><circle cx="32" cy="30" r="4" style="stroke-width:2;stroke:#ffffff;fill:#000000;"/><polygon style="fill:rgba(0,0,0,0.5)" points="18,1 32,30 18,18 18,1"/><rect x="2" y="2" width="15" height="15" style="stroke-width:2;stroke:#000000;fill:{color}"/><text x="9" y="13" style="font-size:11px;font-family:arial;fill:#ffffff;" text-anchor="middle">{text}</text></svg>',
                                anchor: new Microsoft.Maps.Point(42, 39),
                                color: waypointColor,
                                text: waypointLabel[waypointCnt]    //Give waypoints a letter as a label.
                            });

                            //Store the instruction information in the metadata.
                            pin.metadata = {
                                description: step.formattedText,
                                infoboxOffset: new Microsoft.Maps.Point(-30, 25)
                            };

                            waypointCnt++;
                        } else {
                            //Instruction step, make it a red circle with its instruction index.
                            //pin = new Microsoft.Maps.Pushpin(step.coordinate, {
                            //    icon: '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="18" height="17" viewBox="0 0 36 34" xml:space="preserve"><circle cx="16" cy="16" r="14" style="fill:{color}" /><text x="16" y="21" style="font-size:16px;font-family:arial;fill:#ffffff;" text-anchor="middle">{text}</text></svg>',
                            //    anchor: new Microsoft.Maps.Point(9, 9),
                            //    color: '#d60000',
                            //    text: stepCount + ''
                            //});

                            //Store the instruction information in the metadata.
                            pin.metadata = {
                                description: step.formattedText,
                                infoboxOffset: new Microsoft.Maps.Point(0, 0)
                            };
                        }

                        wp.push(pin);
                    }
                }

                //Reverse the order of the pins so that when rendered the last waypoints in the route are on top.
                wp.reverse();

                //Add the pins to the map. 
                directionWaypointLayer.add(wp);
            }
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
