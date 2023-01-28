<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="calculate-distance.aspx.cs" Inherits="MyMapSolution.calculate_distance" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>distancebetweentwolocationsHTML</title>
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
        <div id='printoutPanel'></div>

        <div id='myMap' style='width: 100vw; height: 100vh;'></div>
        <script type='text/javascript'>
            function loadMapScenario() {
                var map = new Microsoft.Maps.Map(document.getElementById('myMap'), {});
                Microsoft.Maps.loadModule('Microsoft.Maps.SpatialMath', function () {
                    var pushpins = Microsoft.Maps.TestDataGenerator.getPushpins(2, map.getBounds());
                    map.entities.push(pushpins);
                    document.getElementById('printoutPanel').innerHTML = '<b>Distance between two pushpins in miles</b><br> '
                        + Microsoft.Maps.SpatialMath.getDistanceTo(pushpins[0].getLocation(), pushpins[1].getLocation(), Microsoft.Maps.SpatialMath.DistanceUnits.Miles);
                });

            }
        </script>
        <script type='text/javascript' src='https://www.bing.com/api/maps/mapcontrol?key=Aj0QaseEPBN2VnIZFY8FRwqQrOiXDKPgEQuO3aH1KcoDJLdgwEpSwt3Ikxj-OYsc&callback=loadMapScenario' async defer></script>

    </form>
</body>
</html>
