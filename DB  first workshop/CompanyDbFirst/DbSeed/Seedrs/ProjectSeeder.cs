using DbSeed.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DbSeed.Seedrs
{
   public class ProjectSeeder : ISeeder
    {
        private const int NumberOfProjects = 1000;
        public ProjectSeeder(IRandomGenerator randomGenerator)
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

            for (int i = 0; i < NumberOfProjects; i++)
            {
                var departmentToBeAdded = new Project
                {
                    Name = this.RandomGenerator.GetRandomString(10, 50)
                };

                if (i % 100 == 0)
                {
                    db.SaveChanges();
                    db = new CompanyEntities();
                }

                db.Projects.Add(departmentToBeAdded);
            }

            db.SaveChanges();
        }
    }
}
