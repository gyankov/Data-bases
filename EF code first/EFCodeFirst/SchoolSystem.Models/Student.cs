using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolSystem.Models
{
    public class Student
    {
        private ICollection<Course> courses;
        private ICollection<Homework> homeworks;
        public Student()
        {
            this.Courses = new HashSet<Course>();
            this.Homeworks = new HashSet<Homework>();

        }
        
        public int Id { get; set; }
        [Required]

        public string Name { get; set; }       
        
        public string Number { get; set; }

        public virtual ICollection<Course> Courses
        {
            get { return courses;}

            set { courses = value;}
        }

        internal virtual ICollection<Homework> Homeworks
        {
            get{return homeworks;}

            set{homeworks = value;}
        }
    }
}
