using Moq;
using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityFramework
{
    [TestFixture]
   public  class Tests
    {
        [Test]
      public static void TestInstertingCustomer()
        {
            var db = new Mock<NorthwindEntities>();
            var customer = new Mock<Customer>();
            db.SetupGet(x => x.Customers).Returns(It.IsAny<System.Data.Entity.DbSet<Customer>>());
            EF.InsertCustomer(customer.Object, db.Object);

            db.Verify(x => x.Customers.Add(It.IsAny<Customer>()), Times.Once);
            //imposibruuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu
        }
    }
}
