using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SchoolSystem.Data;
using SchoolSystem.Models;
using System.Data.Entity;
using SchoolSystem.Data.Migrations;

namespace SchoolSystem.ConsoleClient
{
   public class Startup
    {
        public static void Main(string[] args)
        {
            Database.SetInitializer(new MigrateDatabaseToLatestVersion<SchoolSystemContext, Configuration>());
            using (var db = new SchoolSystemContext())
            {
                var student = new Student { Name = "gosho", Number = "its not a fucking null" };

                db.Students.Add(student);

                ImportStudents(db);
                ImportCourses(db);
                ImportHomeworks(db);
                db.SaveChanges();
                Console.WriteLine(db.Students.Count());
                Console.WriteLine(db.Homeworks.Count());
                Console.WriteLine(db.Courses.Count());
            }
        }

        private static void ImportStudents(SchoolSystemContext db)
        {
         
                for (int i = 0; i < 100; i++)
                {
                    var student = new Student
                    {
                        Name = RandomGenerator.GetRandomString(1,10),
                        Number = RandomGenerator.GetRandomString(1,10)

                    };
                    db.Students.Add(student);
     
            }
        }

        private static void ImportCourses(SchoolSystemContext db)
        {
            
                for (int i = 0; i < 100; i++)
                {
                    var course = new Course
                    {
                        Description = RandomGenerator.GetRandomString(1,10),
                        Name = RandomGenerator.GetRandomString(1,10),
                        Materials = RandomGenerator.GetRandomString(1,10)
                    };
                    db.Courses.Add(course);
            
            }
        }

        private static void ImportHomeworks(SchoolSystemContext db)
        {
            
                for (int i = 0; i < 100; i++)
                {
                var homework = new Homework
                {
                    CourseId = db.Courses.Select(x => x.Id).FirstOrDefault(),
                    StudentId = db.Students.Select(x => x.Id).FirstOrDefault(),
                        TimeSent = RandomGenerator.GetRandomDate(),
                        Content = RandomGenerator.GetRandomString(1,12)
                    };
                    db.Homeworks.Add(homework);
            }
        }
    }
}
