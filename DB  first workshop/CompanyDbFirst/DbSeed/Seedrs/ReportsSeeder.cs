using DbSeed.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DbSeed.Seedrs
{
    class ReportsSeeder : ISeeder
    {
        private const int NumberOfReports = 250000;
        public ReportsSeeder(IRandomGenerator randomGenerator)
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
            var emplyeesIds = db.Employees.Select(x => x.Id).ToList();
            db.Configuration.AutoDetectChangesEnabled = false;
            db.Configuration.ValidateOnSaveEnabled = false;

            for (int i = 0; i < NumberOfReports; i++)
            {
                var reportToBeAdded = new Report
                {
                    EmployeeId = emplyeesIds[this.RandomGenerator.GetRandomNumber(0, emplyeesIds.Count - 1)],
                    Report_time = this.RandomGenerator.GetRandomDate()
                };

                if (i % 100 == 0)
                {                   
                    db.SaveChanges();                   
                    db = new CompanyEntities();
                    db.Configuration.AutoDetectChangesEnabled = false;
                    db.Configuration.ValidateOnSaveEnabled = false;
                }

                db.Reports.Add(reportToBeAdded);
            }

            db.SaveChanges();
            db.Configuration.AutoDetectChangesEnabled = true;
            db.Configuration.ValidateOnSaveEnabled = true;
        }
    }
}
