using DbSeed.Data;
using DbSeed.Seedrs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DbSeed
{
    class Startup
    {
        static void Main()
        {
            var rg = new RandomGenerator();
            //var depSeeder = new DepartmentsSeeder(rg);
            //depSeeder.Seed();

            //var projSeeder = new ProjectSeeder(rg);
            //projSeeder.Seed();

            //var emSeeder = new EmployeeSeeder(rg);
            //emSeeder.Seed();

            var repSeeder = new ReportsSeeder(rg);
            repSeeder.Seed();
        }
    }
}
