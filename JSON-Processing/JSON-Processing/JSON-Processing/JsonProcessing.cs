using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace JSON_Processing
{
    class JsonProcessing
    {
        public static object JsonConvert { get; set; }
        static void Main(string[] args)
        {
            var rssUrl = @"https://www.youtube.com/feeds/videos.xml?channel_id=UCLC-vbm7OWvpbqzXaoAMGGw";
            var client = new WebClient();
            var downloadUrl = @"../../data.xml";

            client.DownloadFile(rssUrl, downloadUrl);

            var parseUrl = @"../../data.json";

            var doc = new XmlDocument();
            doc.Load(downloadUrl);

            string jsonText = Newtonsoft.Json.JsonConvert.SerializeXmlNode(doc);
            File.WriteAllText(parseUrl, jsonText);

            var jsonObj = JObject.Parse(jsonText);

            var videos = jsonObj["feed"]["entry"]
                .Select(entry => Newtonsoft.Json.JsonConvert.DeserializeObject<Video>(entry.ToString()));

            foreach (var item in videos)
            {
                Console.WriteLine(item.Title);
            }
        }
    }
}
