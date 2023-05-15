using System;
using System.IO;
using System.Collections.Generic;
using System;


namespace lab2
{
    class Program
    {
        static void Main(string[] args)
        {
            
            //First task
            Console.WriteLine("Энтропия алфавитов");
            Console.WriteLine("Кириллица: " + Task.EntropyOfAlphabet(Task.Alphabets.Cyrillic));
            Console.WriteLine("Латинский: " + Task.EntropyOfAlphabet(Task.Alphabets.Latin));

            //Second task
            Console.WriteLine("Бинарный: " + Task.EntropyOfAlphabet(Task.Alphabets.Binary));
            Console.WriteLine();

            //Third task
            Console.WriteLine("Количество информации в моем полном имени (латиницей): " + (Task.EntropyOfAlphabet(Task.Alphabets.Latin) * "КохнюкАлександраСергеевна".Length));
            Console.WriteLine("Количество информации в моем полном имени (ASCII): " +
                (Task.EntropyOfAlphabet(Task.Alphabets.Binary) *
                 System.Text.Encoding.Unicode.GetBytes("КохнюкАлександраСергеевна").Length));

            //Fourth task
            Console.WriteLine("Количество информации в моем полном имени (ASCII, вероятность ошибки 0.1): " +
                (Task.EntropyOfAlphabet(Task.Alphabets.Binary, 0.1f) *
                 System.Text.Encoding.Unicode.GetBytes("Kohnyuk Aleksandra Sergeevnah").Length));
            Console.WriteLine("Количество информации в моем полном имени (ASCII, вероятность ошибки 0.5)6 " +
                (Task.EntropyOfAlphabet(Task.Alphabets.Binary, 0.5f) *
                 System.Text.Encoding.Unicode.GetBytes("Kohnyuk Aleksandra Sergeevna").Length));
            Console.WriteLine("Количество информации в моем полном имени (ASCII, вероятность ошибки 1): " +
                (Double.IsNaN(Task.EntropyOfAlphabet(Task.Alphabets.Binary, 1f)) ? 0 : Task.EntropyOfAlphabet(Task.Alphabets.Binary, 1f) *
                 System.Text.Encoding.Unicode.GetBytes("Kohnyuk Aleksandra Sergeevna").Length));



        }
    }
}