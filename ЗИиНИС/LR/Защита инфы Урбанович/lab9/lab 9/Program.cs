
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace lab9
{
    public class ShannonFanoSymbol
    {

        public char symbol;
        public int count;
        public double viorite;
        public string code;
        public ShannonFanoSymbol(char sim, int count, double vior, string code)
        {
            this.viorite = vior;
            this.symbol = sim;
            this.count = count;
            this.code = code;
        }
        public static List<ShannonFanoSymbol> AddSymbols(List<ShannonFanoSymbol> symbols, string line)
        {
            foreach (var character in line)
            {
                if (symbols.Find(x => x.symbol == character) == null)
                {
                    symbols.Add(new ShannonFanoSymbol(character, 1, 0.0, ""));
                }
                else
                {
                    symbols.Where(x => x.symbol == character).ToList().ForEach(x => x.count++);
                }
            }
            return symbols;
        }
        public static void Show(List<ShannonFanoSymbol> symbols)
        {
            foreach (var symbol in symbols)
            {

                Console.Write("Символ: {0}  Кол-во: {1}  ", symbol.symbol, symbol.count);
                if (symbol.viorite != 0)
                {
                    Console.Write("Вероятность: {0}", symbol.viorite);
                }
                if (symbol.code != "")
                {
                    Console.Write("  Код: {0}", symbol.code);
                }
                Console.WriteLine();
            }
            Console.WriteLine();
        }


    }
    class Program
    {

        static void Main(string[] args)
        {


            List<ShannonFanoSymbol> symbols = new List<ShannonFanoSymbol>();

            using (StreamReader stream = new StreamReader(@"D:\5sem\ЗИиНИС\LR\Защита инфы Урбанович\lab9\latin.txt", Encoding.Default))
            {
                string messagef;
                while ((messagef = stream.ReadLine()) != null)
                {
                    symbols = ShannonFanoSymbol.AddSymbols(symbols, messagef);
                }
            }

            Console.WriteLine();
            Console.WriteLine("На основе данных, полученных в лабораторной работе № 2");
            Console.WriteLine("Таблица символов: ");
            Console.WriteLine();

            ShannonFanoSymbol.Show(symbols);

            double symbolssum = symbols.Sum(x => x.count);
            Console.WriteLine("Сумма всех символов текста на латинском языке: " + symbolssum);

            for (int i = 0; i < symbols.Count; i++)
            {
                symbols[i].viorite = symbols[i].count / symbolssum;
            }
            Console.WriteLine("Сумма вероятностей всех символов таблицы: " + (symbols.Sum(x => x.viorite)));
            Console.WriteLine();


            symbols = symbols.OrderByDescending(x => x.viorite).ToList();
            ShannonFanoSymbol.Show(symbols);

            Console.WriteLine();
            Console.WriteLine("Таблица с кодом для каждого символа: ");
            Console.WriteLine();


            symbols = AddCodes(symbols);
            foreach (var symbol in symbols)
            {
                symbol.code = symbol.code.Remove(symbol.code.Length - 1, 1);
            }
            ShannonFanoSymbol.Show(symbols);

            string blockofFIO = "Grintsevich Julia Sergeevna";
            string decodingOfFIO = "";
            foreach (var charFIO in blockofFIO)
            {
                decodingOfFIO += (symbols.Where(x => x.symbol == charFIO).FirstOrDefault()).code;
            }
            Console.WriteLine("Исходное сообщение: ");
            Console.WriteLine(blockofFIO);
            Console.WriteLine("Сообщение после кодировки: ");
            Console.WriteLine(decodingOfFIO);
            Console.WriteLine("Количество битов в кодах ASCII:  " + blockofFIO.Count() * 8);
            Console.WriteLine("Количество битов по таблице Шеннон-Фано: " + decodingOfFIO.Count());

            Console.WriteLine("_____________________________________________");
            Console.WriteLine();
            Console.WriteLine("Декодирование: ");
            Console.WriteLine();


            string Encoded = "";
            string FIOdecoded = "";
            for (int i = 0; i < decodingOfFIO.Count(); i++)
            {
                Encoded += decodingOfFIO[i];
                if (symbols.Find(x => x.code == Encoded) != null)
                {
                    FIOdecoded += symbols.Find(x => x.code == Encoded).symbol;
                    Encoded = "";
                }
            }
            Console.WriteLine(FIOdecoded);

            Console.WriteLine("_____________________________________________");
            Console.WriteLine();

            Console.WriteLine("Динамически, на основе анализа сжимаемого сообщения: ");
            Console.WriteLine();


            symbols.Clear();

            string message = "Grintsevich";
            symbols = ShannonFanoSymbol.AddSymbols(symbols, message);
            ShannonFanoSymbol.Show(symbols);

            symbolssum = symbols.Sum(x => x.count);
            Console.WriteLine("Сумма всех символов текста на латинском языке: " + symbolssum);

            for (int i = 0; i < symbols.Count; i++)
            {
                symbols[i].viorite = symbols[i].count / symbolssum;
            }
            Console.WriteLine("Сумма вероятностей всех символов таблицы: " + (symbols.Sum(x => x.viorite)));

            Console.WriteLine();

            symbols = symbols.OrderByDescending(x => x.viorite).ToList();
            ShannonFanoSymbol.Show(symbols);

            Console.WriteLine();
            Console.WriteLine("Таблица с кодом для каждого символа: ");
            Console.WriteLine();

            symbols = AddCodes(symbols);
            foreach (var symbol in symbols)
            {
                symbol.code = symbol.code.Remove(symbol.code.Length - 1, 1);
            }

            ShannonFanoSymbol.Show(symbols);

            blockofFIO = "Grintsevich Altr";
            decodingOfFIO = "";
            foreach (var charFIO in blockofFIO)
            {
                decodingOfFIO += (symbols.Where(x => x.symbol == charFIO).First()).code;
            }
            Console.WriteLine("Исходное сообщение: ");
            Console.WriteLine(blockofFIO);
            Console.WriteLine("Сообщение после кодировки: ");
            Console.WriteLine(decodingOfFIO);
            Console.WriteLine("Количество битов в кодах ASCII:  " + blockofFIO.Count() * 8);
            Console.WriteLine("Количество битов по таблице Шеннон-Фано: " + decodingOfFIO.Count());

            Console.WriteLine("____________________________________");
            Console.WriteLine();
            Console.WriteLine("Декодирование");


            Encoded = "";
            FIOdecoded = "";
            for (int i = 0; i < decodingOfFIO.Count(); i++)
            {
                Encoded += decodingOfFIO[i];
                if (symbols.Find(x => x.code == Encoded) != null)
                {
                    FIOdecoded += symbols.Find(x => x.code == Encoded).symbol;
                    Encoded = "";
                }
            }
            Console.WriteLine(FIOdecoded);

            Console.ReadLine();
        }

        public static List<ShannonFanoSymbol> AddCodes(List<ShannonFanoSymbol> symbols)
        {
            int counter = 0;
            double probability = 0.0;
            List<ShannonFanoSymbol> first = new List<ShannonFanoSymbol>();
            List<ShannonFanoSymbol> second = new List<ShannonFanoSymbol>();

            while (probability < (symbols.Sum(x => x.viorite) / 2))
            {
                probability += symbols[counter].viorite;
                counter++;
            }
            for (int i = 0; i < counter; i++)
            {
                symbols[i].code += "0";
                first.Add(symbols[i]);
            }
            for (int i = counter; i < symbols.Count; i++)
            {
                symbols[i].code += "1";
                second.Add(symbols[i]);
            }
            if (symbols.Count > 1)
            {
                first = AddCodes(first);
                second = AddCodes(second);

                first.AddRange(second);

                symbols = first;
            }

            return symbols;
        }
    }
}