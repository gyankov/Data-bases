using DbSeed.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DbSeed.Seedrs
{
    public class DepartmentsSeeder : ISeeder
    {
        private const int NumberOfDepartments = 100;
        public DepartmentsSeeder(IRandomGenerator randomGenerator)
        {
            this.RandomGenerator = randomGenerator;
        }
        public IRandomGenerator RandomGenerator
        {
            get; private set;
        }

        public void Seed()
        {
            var db = new CompanyEntities();

            for (int i = 0; i < NumberOfDepartments; i++)
            {
                var departmentToBeAdded = new Department
                {
                    Name = this.RandomGenerator.GetRandomString(10, 50)
                };

                db.Departments.Add(departmentToBeAdded);
            }

            db.SaveChanges();
        }
    }
}
