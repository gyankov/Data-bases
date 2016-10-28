using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdoNet
{
    class Program
    {
        static void Main(string[] args)
        {
            /* 1.Write a program that retrieves from the Northwind sample database 
            in MS SQL Server the number of rows in the Categories table. */
            CountCategories();

            /* 2.Write a program that retrieves the name and description of all categories in the Northwind DB. */
            GetNameAndDescriptionOfCategories();

            /* 3.Write a program that retrieves from the Northwind database all product 
             * categories and the names of the products in each category.
              Can you do this with a single SQL query (with table join)? */
            GetNameAndCategoryOfProduct();

            /* 4. Write a method that adds a new product in the products table in the Northwind database.
                Use a parameterized SQL command. */
            InsertProduct();
        }

        private static void InsertProduct()
        {
            SqlConnection dbCon = new SqlConnection("Server=.\\SQLEXPRESS; " + "Database=Northwind; Integrated Security=true");
            dbCon.Open();
            using (dbCon)
            {
                SqlCommand cmd = new SqlCommand("insert into Products(ProductName,Discontinued) values ('pesho', 1)", dbCon);
                SqlDataReader reader = cmd.ExecuteReader();
            }           
        }

        private static void GetNameAndCategoryOfProduct()
        {
            SqlConnection dbCon = new SqlConnection("Server=.\\SQLEXPRESS; " + "Database=Northwind; Integrated Security=true");
            dbCon.Open();
            using (dbCon)
            {
                SqlCommand cmd = new SqlCommand("select ProductName, CategoryName from Products p join Categories c on p.CategoryID = c.CategoryID", dbCon);
                SqlDataReader reader = cmd.ExecuteReader();

                using (reader)
                {
                    while (reader.Read())
                    {
                        string categoryName = (string)reader["CategoryName"];
                        string productName = (string)reader["ProductName"];
                        Console.WriteLine(productName +" : "+ categoryName);
                      
                    }

                }

            }
            Console.WriteLine();
        }

        private static void CountCategories()
        {
            SqlConnection dbCon = new SqlConnection("Server=.\\SQLEXPRESS; " + "Database=Northwind; Integrated Security=true");
            dbCon.Open();

            using (dbCon)
            {
                SqlCommand cmdCount = new SqlCommand("SELECT COUNT(*) FROM Categories", dbCon);
                int categoriesCount = (int)cmdCount.ExecuteScalar();
                Console.WriteLine("Categories count:"+ categoriesCount);
                Console.WriteLine();
            }
        }

        private static void GetNameAndDescriptionOfCategories()
        {
            SqlConnection dbCon = new SqlConnection("Server=.\\SQLEXPRESS; " + "Database=Northwind; Integrated Security=true");
            dbCon.Open();
            using (dbCon)
            {
                SqlCommand cmd = new SqlCommand("SELECT CategoryName, Description  FROM Categories", dbCon);
                SqlDataReader reader = cmd.ExecuteReader();

                using (reader)
                {
                    while (reader.Read())
                    {
                        string categoryName = (string)reader["CategoryName"];
                        string categoryDescription = (string)reader["Description"];
                        Console.WriteLine("Category name: " +categoryName+", category description: "+categoryDescription );
                    }

                }
                Console.WriteLine();

            }
        }
    }
}
