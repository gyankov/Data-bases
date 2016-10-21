using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApplication1
{
    class Program
    {
        static void Main(string[] args)
        {
            var connection = new SqlConnection("Server=DESKTOP-FKGSRGQ\\SQLEXPRESS; Database=Northwind; Integrated Security=true");
            connection.Open();
            Console.WriteLine("opened");
            connection.Close();

        }
    }
}
