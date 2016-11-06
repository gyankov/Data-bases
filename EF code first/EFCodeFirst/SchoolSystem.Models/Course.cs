using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolSystem.Models
{
    public class Course
    {
        private ICollection<Student> students;
        private ICollection<Homework> homeworks;
        public Course()
        {
            this.Students = new HashSet<Student>();
            this.Homeworks = new HashSet<Homework>();
        }
        public int Id { get; set; }

        [Required]
        public string Name { get; set; }

        [Required]
        public string Description { get; set; }
        [Required]

        public string Materials { get; set; }

        public virtual ICollection<Student> Students
        {
            get { return students; }

            set { students = value; }
        }

        public virtual ICollection<Homework> Homeworks
        {
            get { return homeworks; }

            set { homeworks = value; }
        }
    }
}
