using DbSeed.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DbSeed.Seedrs
{
   public class EmployeeSeeder : ISeeder
    {
        private const int NumberOfEmployees = 5000;
        public EmployeeSeeder(IRandomGenerator randomGenerator)
        {
            this.RandomGenerator = randomGenerator;
        }
        public IRandomGenerator RandomGenerator
        {
            get;private set;
        }

        public void Seed()
        {
            var db = new CompanyEntities();
            var depIds = db.Departments.Select(x => x.Id).ToList();
            var managersCount = NumberOfEmployees / 100 * 5;

            for (int i = 0; i < managersCount; i++)
            {
                var managerToAdd = new Employee
                {
                    DepartmentId = depIds[this.RandomGenerator.GetRandomNumber(0, depIds.Count-1)],
                    First_name = this.RandomGenerator.GetRandomString(5, 20),
                    Last_name = this.RandomGenerator.GetRandomString(5, 20),
                    Year_salary = this.RandomGenerator.GetRandomNumber(50000, 200000),
                    ManagerId = null

                };

                db.Employees.Add(managerToAdd);

                if (i % 100 == 0)
                {
                    db.SaveChanges();
                    db = new CompanyEntities();
                }
            }

            db.SaveChanges();
            db = new CompanyEntities();
            var managersIds = db.Employees.Where(x=> x.ManagerId == null).Select(x=> x.Id).ToList();

            for (int i = 0; i <NumberOfEmployees - managersCount; i++)
            {
                var employeeToAdd = new Employee
                {
                    DepartmentId = depIds[this.RandomGenerator.GetRandomNumber(0, depIds.Count-1)],
                    First_name = this.RandomGenerator.GetRandomString(5, 20),
                    Last_name = this.RandomGenerator.GetRandomString(5, 20),
                    Year_salary = this.RandomGenerator.GetRandomNumber(50000, 200000),
                    ManagerId = managersIds[this.RandomGenerator.GetRandomNumber(0,managersIds.Count-1)]

                };

                db.Employees.Add(employeeToAdd);

                if (i % 100 == 0)
                {
                    db.SaveChanges();
                    db = new CompanyEntities();
                }
            }

            db.SaveChanges();
        }
    }
}
