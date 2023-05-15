using System.IO;
using System.Collections.Generic;
using System;
using System.Linq;

namespace lab2
{
    public static class Task
    {
        public enum Alphabets// общедоступные алфавиты перечисления
        {
            Latin,
            Cyrillic,
            Binary
        }
        //общедоступная статическая двойная энтропия
        public static double EntropyOfAlphabet(Alphabets Alphabet, float errorProbability = 0)
        {
            string alphabet = "";
            string path = "";
            if (Alphabet == Alphabets.Latin)
            {
                alphabet = "qwertyuiopasdfghjklzxcvbnm";
                path = "latin.txt";
            }
            else if (Alphabet == Alphabets.Cyrillic)
            {
                path = "cyrillic.txt";
                alphabet = "йцукенгшщзхъфывапролджэячсмитьбю";
            }
            else if (Alphabet == Alphabets.Binary)
            {
                path = "binary.bin";
                alphabet = "01";
            }

            Dictionary<char, int> numberOfOccurrences = new Dictionary<char, int>();//встреча
            foreach (var ch in alphabet)
                numberOfOccurrences.Add(ch, 0);

            //подсчитываем кол-во встреч
            using (StreamReader sr = new StreamReader(path))
            {
                string text = sr.ReadToEnd();
                text = text.ToLower();//преабр в строчные
                foreach (var ch in text.Select((value, i) => new { i, value }))
                {
                    if (alphabet.Contains(ch.value))//Возвращает значение, указывающее, встречается ли указанная подстрока внутри этой строки.
                        numberOfOccurrences[ch.value]++;//если алфовит содорж значение ++
                    else
                        text.Remove(ch.i);
                }

                double answer = 0;
                foreach (var ch in alphabet)
                {
                    if (numberOfOccurrences[ch] != 0)//если колич повтор 0 то..
                    {
                        double P = (double)numberOfOccurrences[ch] / (double)text.Length * (1 - errorProbability);
                        answer += P * Math.Log2(P);
                    }
                }

                return -answer;
            }

        }

    }
}
