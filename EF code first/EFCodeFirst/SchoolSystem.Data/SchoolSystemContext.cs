﻿using SchoolSystem.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolSystem.Data
{
   public class SchoolSystemContext : DbContext
    {
        public SchoolSystemContext() :base("SchoolSystemDatabase")
        {

        }
        public virtual IDbSet<Student>Students{ get; set;}

        public virtual IDbSet<Course> Courses { get; set; }

        public virtual IDbSet<Homework> Homeworks { get; set; }
    }
}
