using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityFramework
{
    class NorthwindTwin
    {
        // 6.Create a database called NorthwindTwin with the same structure as Northwind using the features from DbContext.
      //  Find for the API for schema generation in MSDN or in Google.
        public static void Create()
        {
            var ctx = new NorthwindEntities();
            ctx.Database.CreateIfNotExists();
        }
    }
}
