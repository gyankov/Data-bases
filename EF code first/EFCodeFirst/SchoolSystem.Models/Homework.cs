using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolSystem.Models
{
   public    class Homework
    {
        public int Id { get; set; }
        [Required]

        public string  Content { get; set; }

        [Display(Name = "Time sent")]
        public DateTime TimeSent { get; set; }
     

        public virtual int CourseId { get; set; }

        public virtual Course Course { get; set; }
       

        public virtual int StudentId { get; set; }

        public virtual Student Student { get; set; }
    }
}
