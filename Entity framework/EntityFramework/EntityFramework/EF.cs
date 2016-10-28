using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityFramework
{
    class EF
    {
        static void Main(string[] args)
        {
            // 1.Using the Visual Studio Entity Framework designer create a DbContext for the Northwind database
            using (var db = new NorthwindEntities())
            {
                var customer = new Customer()
                {
                    CompanyName = "Qkata firma",
                    CustomerID = "PPAPP"
                };
                TwoContexts();
                // InsertCustomer(customer, db);
                // ModifyCustomer(db);
                //  DeleteCustomer(customer.CustomerID, db);
            }
        }
        //2.Create a DAO class with static methods which provide functionality for inserting, modifying and deleting customers.
        public static void InsertCustomer(Customer customer, NorthwindEntities db)
        {
            db.Customers.Add(customer);
            db.SaveChanges();
        }

        public static void ModifyCustomer(NorthwindEntities db)
        {
            var customer =
                db.Customers
                .Where(x => x.CustomerID == "PPAPP")
                .FirstOrDefault();

            customer.CompanyName = "Gosho Goshov";
            db.SaveChanges();

        }

        public static void DeleteCustomer(string customerID, NorthwindEntities db)
        {
            var customer =
                db.Customers
                .Where(x => x.CustomerID == customerID)
                .FirstOrDefault();

            db.Customers.Remove(customer);
            db.SaveChanges();
        }

        // 3.Write a method that finds all customers who have orders
        //made in 1997 and shipped to Canada.

        public static void AllCustomersWithOrdersBefore1997(NorthwindEntities db)
        {
            var customers =
                db.Customers
                .Where(x =>
                x.Orders.Where(y =>
                    y.OrderDate.Value.Year == new DateTime(1997, 1, 1).Year &&
                    y.ShipCountry == "Canada")
                .Count() > 0).ToList();
        }

        // 4.Implement previous by using native SQL query and executing it through the DbContext.
        public static void AllCustomersWithOrdersBefore1997Sql(NorthwindEntities db)
        {
            var customers =
                db.Customers.SqlQuery
                (@"USE Northwind
                   SELECT * FROM Customers C
                   JOIN Orders O
                   ON O.CustomerID = C.CustomerID
                   WHERE YEAR(O.OrderDate) = 1997 AND O.ShipCountry = 'Canada' ")
                   .ToList();

        }

        //5.Write a method that finds all the sales by specified region and period (start / end dates).

        public static void SalesSpecifiedByRegionAndPeriod(NorthwindEntities db, string region, DateTime start, DateTime end)
        {
            var sales = db.Orders
                .Where(x => x.ShipRegion == region
                    && x.ShippedDate.Value.Year >= start.Year &&
                    x.ShippedDate.Value.Year <= end.Ticks)
                .ToList();
        }

        //7.Try to open two different data contexts and perform concurrent changes on the same records.
        public static void TwoContexts()
        {
            using (var dbOne = new NorthwindEntities())
            {
                using (var dbTwo = new NorthwindEntities())
                {
                    var pesho = dbOne.Customers.FirstOrDefault();
                    var gosho = dbTwo.Customers.FirstOrDefault();

                    pesho.ContactName = "Pesho";
                    gosho.ContactName = "Gosho";

                    dbOne.SaveChanges();
                    dbTwo.SaveChanges();
                }
            }
        }

    }
}
