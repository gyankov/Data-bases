using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Linq;
using System.Xml.Schema;
using System.Xml.Xsl;

namespace XML_Processing
{
    class XmlOperations
    {
        static void Main(string[] args)
        {
            var url = "../../XML/catalogue.xml";

            //Task 2
            ExtractArtistDomParser(url);

            //Task 3
            ExtractArtistXPath(url);

            //Task 4
            DeleteExpensiveAlbum(url);

            //Task 5
            GetSongTitleXmlReader(url);

            //Task 6
            GetSongTitleLINQ(url);

            //Task 7
            CreatePersonFromTXT();

            //Task 8
            CreateAlbumXml(url);

            //Task 9
            TraverseDirAndWriteInXmlUsingXmlWritter();

            //task 10
            TraverseXDocument();

            //task 11
            GetPriceForAlbums(url);

            //task 12
            GetPriceForAlbumsFiveYearsAgoLINQ(url);

            //task 14
            ApplyXslt(url);



        }

        private static void ExtractArtistDomParser(string url)
        {
            var doc = new XmlDocument();
            doc.Load(url);

            XmlNode root = doc.DocumentElement;

            var artists = new HashSet<string>();

            foreach (XmlNode item in root)
            {
                foreach (XmlNode element in item.ChildNodes)
                {
                    if (element.Name == "artist")
                    {
                        artists.Add(element.InnerText.Trim());
                    }
                }
            }

            Print(artists);
        }

        private static void ExtractArtistXPath(string url)
        {
            var doc = new XmlDocument();
            doc.Load(url);
            string xPath = "/catalogue/album/artist";
            XmlNodeList artistList = doc.SelectNodes(xPath);
            var artists = new HashSet<string>();

            foreach (XmlNode item in artistList)
            {
                artists.Add(item.InnerText.Trim());
            }
            Print(artists);
        }

        private static void DeleteExpensiveAlbum(string url)
        {
            var doc = new XmlDocument();
            doc.Load(url);
            string xPath = "/catalogue/album/price";
            var root = doc.DocumentElement;
            XmlNodeList artistList = doc.SelectNodes(xPath);

            foreach (XmlNode item in artistList)
            {

                var price = int.Parse(item.InnerText);

                if (price > 20)
                {
                    root.RemoveChild(item.ParentNode);
                }

            }

            doc.Save(url);

        }

        private static void GetSongTitleXmlReader(string url)
        {
            using (XmlReader reader = XmlReader.Create(url))
            {
                while (reader.Read())
                {
                    if (reader.NodeType == XmlNodeType.Element && reader.Name == "song")
                    {
                        XmlReader subtree = reader.ReadSubtree();
                        while (subtree.Read())
                        {
                            if (subtree.NodeType == XmlNodeType.Element && reader.Name == "title")
                            {
                                Console.WriteLine(subtree.ReadInnerXml().Trim());
                            }
                        }
                    }
                }
            }
        }

        private static void GetSongTitleLINQ(string url)
        {
            XDocument doc = XDocument.Load(url);
            var allSongs = from album in doc.Descendants("album")
                           from songs in doc.Descendants("songs")
                           from song in doc.Descendants("song")
                           from title in doc.Descendants("title")
                           select new
                           {
                               Title = title.Value
                           };
            Console.WriteLine();
            foreach (var item in allSongs)
            {
                Console.WriteLine(item.Title.Trim());
            }
        }

        private static void CreatePersonFromTXT()
        {
            var url = "../../XML/Person.txt";
            string[] data = File.ReadAllLines(url);
            XElement root = new XElement("persons");
            XElement person = new XElement("person");
            person.Add(new XElement("name", data[0]));
            person.Add(new XElement("address", data[1]));
            person.Add(new XElement("phone", data[2]));

            root.Save("../../XML/Person.xml");

        }

        private static void CreateAlbumXml(string url)
        {
            using (XmlReader reader = XmlReader.Create(url))
            {
                using (var writer = new XmlTextWriter("../../XML/album.xml", Encoding.Default))
                {
                    writer.Formatting = Formatting.Indented;
                    writer.IndentChar = '\t';
                    writer.Indentation = 1;

                    writer.WriteStartDocument();
                    writer.WriteStartElement("albums");
                    while (reader.Read())
                    {
                        if (reader.NodeType == XmlNodeType.Element && reader.Name == "album")
                        {
                            XmlReader subtree = reader.ReadSubtree();
                            while (subtree.Read())
                            {
                                if (subtree.NodeType == XmlNodeType.Element && subtree.Name == "name")
                                {
                                    writer.WriteElementString("name", subtree.ReadInnerXml());
                                }
                                else if (subtree.NodeType == XmlNodeType.Element && subtree.Name == "artist")
                                {
                                    writer.WriteElementString("artist", subtree.ReadInnerXml());
                                }
                            }

                        }
                    }

                    writer.WriteEndDocument();
                }
            }
        }

        private static void TraverseDirAndWriteInXmlUsingXmlWritter()
        {
            string path = @"../../XML";

            using (XmlTextWriter writer = new XmlTextWriter("../../XML/dir.xml", Encoding.UTF8))
            {
                writer.Formatting = Formatting.Indented;
                writer.IndentChar = ' ';
                writer.Indentation = 4;

                string dekstopPath = Environment.GetFolderPath(Environment.SpecialFolder.Desktop);
                writer.WriteStartDocument();
                writer.WriteStartElement("root");

                foreach (var directory in Directory.GetDirectories(path))
                {
                    writer.WriteStartElement("dir");
                    writer.WriteAttributeString("path", directory);
                    writer.WriteEndElement();
                }

                foreach (var file in Directory.GetFiles(path))
                {
                    writer.WriteStartElement("file");
                    writer.WriteAttributeString("name", Path.GetFileNameWithoutExtension(file));
                    writer.WriteAttributeString("ext", Path.GetExtension(file));
                    writer.WriteEndElement();
                }

                writer.WriteEndDocument();
            }            
        }

        private static void TraverseXDocument()
        {
            string path = @"../../XML";
            var rootDir = Traverse(path);
            rootDir.Save("../../XML/dirXDocument.xml");

        }

        private static XElement Traverse(string dir)
        {
            var element = new XElement("dir", new XAttribute("path", dir));

            foreach (var directory in Directory.GetDirectories(dir))
            {
                element.Add(Traverse(directory));

            }

            foreach (var file in Directory.GetFiles(dir))
            {
                element.Add(new XElement("file",
                     new XAttribute("name", Path.GetFileNameWithoutExtension(file)),
                     new XAttribute("ext", Path.GetExtension(file))));
            }

            return element;
        }

        private static void GetPriceForAlbums(string url)
        {
            var doc = new XmlDocument();
            doc.Load(url);
            string xPath = "/catalogue/album[year<=2011]/price";
            var albums = doc.SelectNodes(xPath);
            Console.WriteLine("Albums older than 5 years");

            foreach (XmlNode item in albums)
            {
                Console.WriteLine(item.InnerText);
            }
        }

        private static void GetPriceForAlbumsFiveYearsAgoLINQ(string url)
        {
            var document = XDocument.Load(url);

            var filtered = from album in document.Descendants("album")
                           where int.Parse(album.Element("year").Value) < 2011
                           select album.Element("price").Value;

            Print(filtered);

        }

        private static void ApplyXslt(string url)
        {
            var xsltUrl = @"../../XML/style.xslt";
            XslCompiledTransform xslt = new XslCompiledTransform();
            xslt.Load(xsltUrl);
            xslt.Transform(url, "../../XML/catalog.html");
        }
        
        private static void ValiateXml(string url)
        {
            var xdoc = XDocument.Load(url);
            var schemas = new XmlSchemaSet();
            schemas.Add("catalogue-academy-com:music", @"../../../XML/schema.xsd");

            xdoc.Validate(schemas, null);
        }

        private static void Print(IEnumerable<string> collection)
        {
            foreach (var item in collection)
            {
                Console.WriteLine(item);
            }
            Console.WriteLine();
        }
    }

}