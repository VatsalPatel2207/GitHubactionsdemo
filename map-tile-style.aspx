<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="map-tile-style.aspx.cs" Inherits="MyMapSolution.map_tile_style" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>custommaptilestylesHTML</title>
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

            <div id='myMap' style='width: 100vw; height: 100vh;'></div>
            <script type='text/javascript'>
                function loadMapScenario() {
                    var map = new Microsoft.Maps.Map(document.getElementById('myMap'), {
                        /* No need to set credentials if already passed in URL */
                        center: new Microsoft.Maps.Location(23.014411, 72.591842),
                        customMapStyle: {
                            elements: {
                                area: { fillColor: '#b6e591' },
                                water: { fillColor: '#75cff0' },
                                tollRoad: { fillColor: '#a964f4', strokeColor: '#a964f4' },
                                arterialRoad: { fillColor: '#ffffff', strokeColor: '#d7dae7' },
                                road: { fillColor: 'red', strokeColor: 'black' },
                                street: { fillColor: '#ffffff', strokeColor: '#ffffff' },
                                transit: { fillColor: '#000000' }
                            },
                            settings: {
                                landColor: '#efe9e1'
                            }
                        }
                    });

                }
            </script>
            <script type='text/javascript' src='https://www.bing.com/api/maps/mapcontrol?key=Aj0QaseEPBN2VnIZFY8FRwqQrOiXDKPgEQuO3aH1KcoDJLdgwEpSwt3Ikxj-OYsc&callback=loadMapScenario' async defer></script>
        </div>
    </form>
</body>
</html>
