using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MyMapSolution
{
    public partial class testingnew : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            TestApi();
        }

        public void TestApi()
        {
            string EventDispatchURL = "https://hub-dev.tgcmag.com/api/process/events/dispatch";
            string BearerToken = "28edc322fbf9ed0d9762c653d0f67e29114dc579dcb5fbb04d0c7f526192a5f5";
            string Requester = "dax";

            string RequestData = "";
            RequestData = "{'email': 'testing@gmail.com','system': 'dax','external_id': '7e47c13f-2cf2-ec11-bb3d-00224825e879'}";

            RequestData = RequestData.Replace("'", "\"");
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            WebRequest request = WebRequest.Create(EventDispatchURL);
            request.Headers.Add("Authorization", "Bearer " + BearerToken);
            request.Headers.Add("Requester", Requester);
            byte[] bytes;
            bytes = System.Text.Encoding.ASCII.GetBytes(RequestData.ToString());
            request.Method = "POST";
            request.ContentType = "application/json";
            Stream datastream = request.GetRequestStream();
            StreamWriter sw = new StreamWriter(datastream);
            sw.Write(RequestData);
            sw.Close();
            datastream.Close();

            HttpWebResponse response = (HttpWebResponse)request.GetResponse();
            if (response.StatusCode == HttpStatusCode.OK)
            {
                Stream responseStream = response.GetResponseStream();
                string responseStr = new StreamReader(responseStream).ReadToEnd();
            }

        }
    }
}