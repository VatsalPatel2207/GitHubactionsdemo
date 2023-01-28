<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="location-tooltip.aspx.cs" Inherits="MyMapSolution.location_tooltip" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>adddefaultinfoboxHTML</title>
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
                        center: new Microsoft.Maps.Location(47.60357, -122.32945)
                    });
                    var center = map.getCenter();
                    var infobox = new Microsoft.Maps.Infobox(center, { title: 'Map Center', description: 'Seattle' });
                    infobox.setMap(map);

                }
            </script>
            <script type='text/javascript' src='https://www.bing.com/api/maps/mapcontrol?key=Aj0QaseEPBN2VnIZFY8FRwqQrOiXDKPgEQuO3aH1KcoDJLdgwEpSwt3Ikxj-OYsc&callback=loadMapScenario' async defer></script>
        </div>
    </form>
</body>
</html>
