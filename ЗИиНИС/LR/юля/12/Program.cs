using System;

namespace TwelvethLab
{
    internal class Program
    {
        public static bool IsPrime(int number)
        {
            for (int i = 2; i < number; i++)
            {
                if (number % i == 0)
                    return false;
            }
            return true;
        }
        static int GCD(int a, int b)
        {
            while (b != 0)
            {
                var t = b;
                b = a % b;
                a = t;
            }   
            return a;
        }
        static void Main(string[] args)
        {
            
            Console.Write("Prime numbers = ");
            int count = 0;
            for (int i = 521; i <= 553; i++)
            {
                if (IsPrime(i))
                {
                    Console.Write($"{i} ");
                    count++;
                }
            }
            Console.WriteLine("\nAmount = {0}",count);
            Console.Write("\nType m ");
            int count2 = 0;
            for (int i = 2; i <= 553; i++)
            {
                if (IsPrime(i))
                {
                    Console.Write($"{i} ");
                    count2++;
                }
            }
            Console.WriteLine("\nAmount = {0}", count2);
            double inter = 553/Math.Log(553);
            Console.WriteLine(inter);
            Console.Write("\nType a ");
            int a = Convert.ToInt32(Console.ReadLine());
            Console.Write("Type b ");
            int b = Convert.ToInt32(Console.ReadLine());
            Console.WriteLine("Greatest common divisor of numbers {0} and {1} is {2}",a,b,GCD(a,b));
            Console.ReadLine();
            
        }
    }
}
