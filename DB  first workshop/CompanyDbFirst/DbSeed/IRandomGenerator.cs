using System;

namespace DbSeed
{
    public interface IRandomGenerator
    {
        DateTime GetRandomDate(DateTime? after = default(DateTime?), DateTime? before = default(DateTime?));
        int GetRandomNumber(int min = 0, int max = 1073741823);
        string GetRandomString(int minLength = 0, int maxLength = 1073741823);
    }
}