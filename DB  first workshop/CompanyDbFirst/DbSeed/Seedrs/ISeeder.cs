using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DbSeed.Seedrs
{
    public interface ISeeder
    {
        IRandomGenerator RandomGenerator { get; }

        void Seed();
    }
}
