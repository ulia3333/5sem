using System;

namespace ЛР__6
{
    class Program
    {
        static void Main(string[] args)
        {

            string Xk = "101010101010101010101010101010101010101010101010101010101010101010101010101010101010";
            string Xr = "1000011";

            int k = Xk.Length;
            int r = 6;
            int n = 90;

            int error;

            int[] masXk = new int[k];
            StrInMas(masXk, Xk);

            int[] masXr = new int[Xr.Length];
            StrInMas(masXr, Xr);
            Console.WriteLine("___________________________________________________________");
            Console.WriteLine("Входная строка: " + Xk);
            Console.WriteLine("Порождающий полином: " + Xr);
            Console.WriteLine("k = {0}, r = {1}, n = {2}", k, r, n);
            Console.WriteLine("___________________________________________________________");

            int[,] generationMatrix = new int[k, n];
            CreateGenerationMatrix(generationMatrix, masXr, k, n);

            Console.WriteLine("\nПорождающая матрица");
            OutMatrix(generationMatrix, k, n);

            CreateCanonicalMatrix(generationMatrix, k, n);

            Console.WriteLine("\nКаноническая матрица");
            OutMatrix(generationMatrix, k, n);

            int[,] checkMatrix = new int[n, r];
            CreateCheckMatrix(checkMatrix, generationMatrix, k, n);

            Console.WriteLine("\nПроверочная матрица");
            OutMatrix(checkMatrix, n, r);
            6.2

            int[] masXn = new int[n];
            Shift(masXn, masXk, r);

            2.
            Console.WriteLine("\nДеление");
            SearchResidue(masXn, masXr);

            Console.WriteLine("Остаток (S-синдром):");
            OutMass(masXn);
            Console.WriteLine("\n");
            Console.WriteLine("Итоговая строка:");
            Shift(masXn, masXk, r);
            OutMass(masXn);
            Console.WriteLine();
            try
            {
                Console.WriteLine();
                Console.WriteLine("Для одной ошибки");
                var random = new Random();
                error = random.Next(0, Xk.Length);
                Console.WriteLine("Позиция ошибки:  " + error);
                if (masXn[error] == 1) masXn[error] = 0;
                else masXn[error] = 1;
            }
            catch { }

            Console.WriteLine("Ошибочная строка:");
            OutMass(masXn);
            SearchError(masXn, masXr, checkMatrix, r);

            try
            {
                Console.WriteLine();
                Console.WriteLine("Для двух ошибок");
                var random = new Random();
                error = random.Next(0, Xk.Length);
                Console.WriteLine("Место первой ошибки:  " + error);
                if (masXn[error] == 1) masXn[error] = 0;
                else masXn[error] = 1;

                var random2 = new Random();
                error = random2.Next(0, Xk.Length);
                Console.WriteLine("Место второй ошибки:  " + error);
                if (masXn[error] == 1) masXn[error] = 0;
                else masXn[error] = 1;
            }
            catch { }

            Console.WriteLine("Ошибочная строка:");
            OutMass(masXn);

            SearchError(masXn, masXr, checkMatrix, r);

        }

        public static int[] SearchError(int[] masXn, int[] masXr, int[,] checkMatrix, int r)
        {
            int n = masXn.Length;
            int k = n - r;

            int[] masXnSecond = new int[n];

            for (int i = 0; i < n; i++)
            {
                masXnSecond[i] = masXn[i];
            }

            Console.WriteLine("\nДеление");
            SearchResidue(masXnSecond, masXr);
            Console.WriteLine();
            Console.WriteLine("\n");
            Console.WriteLine("\nОстаток:");
            OutMass(masXnSecond);

            for (int i = 0; i < n; i++)
            {
                int coincidence = 0;
                for (int j = 0; j < r; j++)
                {
                    if (checkMatrix[i, j] == masXnSecond[k + j])
                    {
                        coincidence++;
                    }

                }
                if (coincidence == r)
                {
                    masXn[i] = (masXn[i] + 1) % 2;
                    break;
                }
            }
            Console.WriteLine("\nИсправленная строка:");
            OutMass(masXn);

            return masXn;
        }

        public static int[] SearchResidue(int[] masXn, int[] masXr)
        {
            int end = masXn.Length - masXr.Length + 1;

            for (int i = 0; i < end; i++)
            {
                if (masXn[i] == 1)
                {
                    AddingMasMod2(masXn, masXr, i);
                    OutMass(masXn);
                }
            }
            Console.WriteLine("\n");
            return masXn;
        }

        Сложение массивов по модулю 2 с опр.позиции
        public static int[] AddingMasMod2(int[] mas1, int[] mas2, int pos)
        {
            int end = pos + mas2.Length;

            for (int i = pos; i < end; i++)
            {
                mas1[i] = (mas1[i] + mas2[i - pos]) % 2;
            }
            return mas1;
        }

        Смещение на массива r
        public static int[] Shift(int[] shiftMas, int[] mas, int r)
        {

            for (int i = 0; i < mas.Length; i++)
            {

                shiftMas[i] = mas[i];
            }

            return shiftMas;
        }

        Преобразование сторки в массив
        public static int[] StrInMas(int[] mas, string str)
        {
            for (int i = 0; i < str.Length; i++)
            {
                if (str[i] == 49)
                    mas[i] = 1;
                else mas[i] = 0;
            }
            return mas;
        }

        Создание Порождающей матрицы
        static int[,] CreateGenerationMatrix(int[,] generationMatrix, int[] mas, int k, int n)
        {
            Заполняем первую строку в проверочной матрице
            for (int i = 0; i < n; i++)
            {
                if (i < mas.Length)
                {
                    generationMatrix[0, i] = mas[i];
                }
                else
                {
                    generationMatrix[0, i] = 0;
                }
            }

            Сдвигаем каждую строки вправо от предыдущей
            for (int i = 1; i < k; i++)
            {
                for (int j = 0; j < n - 1; j++)
                {
                    generationMatrix[i, j + 1] = generationMatrix[i - 1, j];
                }
                generationMatrix[i, 0] = generationMatrix[i - 1, n - 1];
            }



            return generationMatrix;
        }

        Приведение порождающей матрицы к каноническому виду
        static int[,] CreateCanonicalMatrix(int[,] generationMatrix, int k, int n)
        {
            Перебираем строки для преведению к каноническому виду
            for (int i = 0; i < k; i++)
            {
                int i2 = i + 1;
                Перебираем элементы строки, но только до k-элемента
                for (int j = i + 1; j < k; j++)
                {

                    если мы нашли единицу в строке, то...
                    if (generationMatrix[i, j] == 1)
                    {

                        перебираем этот столбец, пока не найдем единицу
                        for (; i2 < k; i2++)
                        {
                            bool repeat = false;
                            Если нашли, то складываем обе строки
                            if (generationMatrix[i2, j] == 1)
                            {
                                for (int j2 = j - 1; j2 > 0; j2--)
                                {
                                    Проверяем, есть ли до этой 1 еще 1, если есть то эту строку пропускаем
                                    if (generationMatrix[i2, j2] == 1)
                                    {
                                        repeat = true;
                                    }
                                }
                                if (repeat)
                                    continue;
                                Console.WriteLine(i + " " + i2);
                                AddingLinesMatrixMod2(generationMatrix, i, i2, n);
                                i2++;
                                break;
                            }
                        }
                    }
                }
            }

            return generationMatrix;
        }

        Преобразование канонической матрицы в проверочную
        static int[,] CreateCheckMatrix(int[,] checkMatrix, int[,] generationMatrix, int k, int n)
        {
            int r = n - k;

            for (int i = 0; i < k; i++)
            {
                for (int j = 0; j < r; j++)
                {
                    checkMatrix[i, j] = generationMatrix[i, k + j];
                }
            }

            for (int i = k; i < n; i++)
            {
                for (int j = 0; j < r; j++)
                {
                    if (j == i - k)
                    {
                        checkMatrix[i, j] = 1;
                    }
                    else
                    {
                        checkMatrix[i, j] = 0;
                    }
                }
            }

            return checkMatrix;
        }

        Сложение строк матрицы
        public static int[,] AddingLinesMatrixMod2(int[,] matrix, int str1, int str2, int lengthString)
        {
            Console.WriteLine(str1 + " и " + str2);
            for (int i = 0; i < lengthString; i++)
            {
                matrix[str1, i] = (matrix[str1, i] + matrix[str2, i]) % 2;
            }
            return matrix;
        }

        вывод матрицы
        public static void OutMatrix(int[,] matrix, int k, int n)
        {
            for (int i = 0; i < k; i++)
            {
                for (int j = 0; j < n; j++)
                {
                    Console.Write(matrix[i, j]);
                    if (j + 1 == k) Console.Write("|");
                }
                Console.WriteLine();
            }
        }

        вывод одномерного массива
        public static void OutMass(int[] mas)
        {
            Console.WriteLine();
            for (int i = 0; i < mas.Length; i++)
            {
                if (i == k) Console.Write("|");
                Console.Write(mas[i]);

            }
            Console.WriteLine("\n");
        }
    }
}




//using System;

//namespace ЛР__6
//{
//    class Program
//    {
//        static void Main(string[] args)
//        {

//            string Xk = "101010101010101010101010101010101010101010101010101010101010101010101010101010101010";
//            string Xr = "1000011";

//            int k = Xk.Length;
//            int r = 6;
//            int n = 90;

//            int error;

//            int[] masXk = new int[k];
//            StrInMas(masXk, Xk);

//            int[] masXr = new int[Xr.Length];
//            StrInMas(masXr, Xr);
//            Console.WriteLine("___________________________________________________________");
//            Console.WriteLine("Входная строка: " + Xk);
//            Console.WriteLine("Порождающий полином: " + Xr);
//            Console.WriteLine("k = {0}, r = {1}, n = {2}", k, r, n);
//            Console.WriteLine("___________________________________________________________");

//            int[,] generationMatrix = new int[k, n];
//            CreateGenerationMatrix(generationMatrix, masXr, k, n);

//            Console.WriteLine("\nПорождающая матрица");
//            OutMatrix(generationMatrix, k, n);

//            CreateCanonicalMatrix(generationMatrix, k, n);

//            Console.WriteLine("\nКаноническая матрица");
//            OutMatrix(generationMatrix, k, n);

//            int[,] checkMatrix = new int[n, r];
//            CreateCheckMatrix(checkMatrix, generationMatrix, k, n);

//            Console.WriteLine("\nПроверочная матрица");
//            OutMatrix(checkMatrix, n, r);
//            6.2

//            int[] masXn = new int[n];
//            Shift(masXn, masXk, r);

//            2.
//            Console.WriteLine("\nДеление");
//            SearchResidue(masXn, masXr);

//            Console.WriteLine("Остаток (S-синдром):");
//            OutMass(masXn);
//            Console.WriteLine("\n");
//            Console.WriteLine("Итоговая строка:");
//            Shift(masXn, masXk, r);
//            OutMass(masXn);
//            Console.WriteLine();
//            try
//            {
//                Console.WriteLine();
//                Console.WriteLine("Для одной ошибки");
//                var random = new Random();
//                error = random.Next(0, Xk.Length);
//                Console.WriteLine("Позиция ошибки:  " + error);
//                if (masXn[error] == 1) masXn[error] = 0;
//                else masXn[error] = 1;
//            }
//            catch { }

//            Console.WriteLine("Ошибочная строка:");
//            OutMass(masXn);
//            SearchError(masXn, masXr, checkMatrix, r);

//            try
//            {
//                Console.WriteLine();
//                Console.WriteLine("Для двух ошибок");
//                var random = new Random();
//                error = random.Next(0, Xk.Length);
//                Console.WriteLine("Место первой ошибки:  " + error);
//                if (masXn[error] == 1) masXn[error] = 0;
//                else masXn[error] = 1;

//                var random2 = new Random();
//                error = random2.Next(0, Xk.Length);
//                Console.WriteLine("Место второй ошибки:  " + error);
//                if (masXn[error] == 1) masXn[error] = 0;
//                else masXn[error] = 1;
//            }
//            catch { }

//            Console.WriteLine("Ошибочная строка:");
//            OutMass(masXn);

//            SearchError(masXn, masXr, checkMatrix, r);

//        }

//        public static int[] SearchError(int[] masXn, int[] masXr, int[,] checkMatrix, int r)
//        {
//            int n = masXn.Length;
//            int k = n - r;

//            int[] masXnSecond = new int[n];

//            for (int i = 0; i < n; i++)
//            {
//                masXnSecond[i] = masXn[i];
//            }

//            Console.WriteLine("\nДеление");
//            SearchResidue(masXnSecond, masXr);
//            Console.WriteLine();
//            Console.WriteLine("\n");
//            Console.WriteLine("\nОстаток:");
//            OutMass(masXnSecond);

//            for (int i = 0; i < n; i++)
//            {
//                int coincidence = 0;
//                for (int j = 0; j < r; j++)
//                {
//                    if (checkMatrix[i, j] == masXnSecond[k + j])
//                    {
//                        coincidence++;
//                    }

//                }
//                if (coincidence == r)
//                {
//                    masXn[i] = (masXn[i] + 1) % 2;
//                    break;
//                }
//            }
//            Console.WriteLine("\nИсправленная строка:");
//            OutMass(masXn);

//            return masXn;
//        }

//        public static int[] SearchResidue(int[] masXn, int[] masXr)
//        {
//            int end = masXn.Length - masXr.Length + 1;

//            for (int i = 0; i < end; i++)
//            {
//                if (masXn[i] == 1)
//                {
//                    AddingMasMod2(masXn, masXr, i);
//                    OutMass(masXn);
//                }
//            }
//            Console.WriteLine("\n");
//            return masXn;
//        }

//        Сложение массивов по модулю 2 с опр.позиции
//        public static int[] AddingMasMod2(int[] mas1, int[] mas2, int pos)
//        {
//            int end = pos + mas2.Length;

//            for (int i = pos; i < end; i++)
//            {
//                mas1[i] = (mas1[i] + mas2[i - pos]) % 2;
//            }
//            return mas1;
//        }

//        Смещение на массива r
//        public static int[] Shift(int[] shiftMas, int[] mas, int r)
//        {

//            for (int i = 0; i < mas.Length; i++)
//            {

//                shiftMas[i] = mas[i];
//            }

//            return shiftMas;
//        }

//        Преобразование сторки в массив
//        public static int[] StrInMas(int[] mas, string str)
//        {
//            for (int i = 0; i < str.Length; i++)
//            {
//                if (str[i] == 49)
//                    mas[i] = 1;
//                else mas[i] = 0;
//            }
//            return mas;
//        }

//        Создание Порождающей матрицы
//        static int[,] CreateGenerationMatrix(int[,] generationMatrix, int[] mas, int k, int n)
//        {
//            Заполняем первую строку в проверочной матрице
//            for (int i = 0; i < n; i++)
//            {
//                if (i < mas.Length)
//                {
//                    generationMatrix[0, i] = mas[i];
//                }
//                else
//                {
//                    generationMatrix[0, i] = 0;
//                }
//            }

//            Сдвигаем каждую строки вправо от предыдущей
//            for (int i = 1; i < k; i++)
//            {
//                for (int j = 0; j < n - 1; j++)
//                {
//                    generationMatrix[i, j + 1] = generationMatrix[i - 1, j];
//                }
//                generationMatrix[i, 0] = generationMatrix[i - 1, n - 1];
//            }



//            return generationMatrix;
//        }

//        Приведение порождающей матрицы к каноническому виду
//        static int[,] CreateCanonicalMatrix(int[,] generationMatrix, int k, int n)
//        {
//            Перебираем строки для преведению к каноническому виду
//            for (int i = 0; i < k; i++)
//            {
//                int i2 = i + 1;
//                Перебираем элементы строки, но только до k-элемента
//                for (int j = i + 1; j < k; j++)
//                {

//                    если мы нашли единицу в строке, то...
//                    if (generationMatrix[i, j] == 1)
//                    {

//                        перебираем этот столбец, пока не найдем единицу
//                        for (; i2 < k; i2++)
//                        {
//                            bool repeat = false;
//                            Если нашли, то складываем обе строки
//                            if (generationMatrix[i2, j] == 1)
//                            {
//                                for (int j2 = j - 1; j2 > 0; j2--)
//                                {
//                                    Проверяем, есть ли до этой 1 еще 1, если есть то эту строку пропускаем
//                                    if (generationMatrix[i2, j2] == 1)
//                                    {
//                                        repeat = true;
//                                    }
//                                }
//                                if (repeat)
//                                    continue;
//                                Console.WriteLine(i + " " + i2);
//                                AddingLinesMatrixMod2(generationMatrix, i, i2, n);
//                                i2++;
//                                break;
//                            }
//                        }
//                    }
//                }
//            }

//            return generationMatrix;
//        }

//        Преобразование канонической матрицы в проверочную
//        static int[,] CreateCheckMatrix(int[,] checkMatrix, int[,] generationMatrix, int k, int n)
//        {
//            int r = n - k;

//            for (int i = 0; i < k; i++)
//            {
//                for (int j = 0; j < r; j++)
//                {
//                    checkMatrix[i, j] = generationMatrix[i, k + j];
//                }
//            }

//            for (int i = k; i < n; i++)
//            {
//                for (int j = 0; j < r; j++)
//                {
//                    if (j == i - k)
//                    {
//                        checkMatrix[i, j] = 1;
//                    }
//                    else
//                    {
//                        checkMatrix[i, j] = 0;
//                    }
//                }
//            }

//            return checkMatrix;
//        }

//        Сложение строк матрицы
//        public static int[,] AddingLinesMatrixMod2(int[,] matrix, int str1, int str2, int lengthString)
//        {
//            Console.WriteLine(str1 + " и " + str2);
//            for (int i = 0; i < lengthString; i++)
//            {
//                matrix[str1, i] = (matrix[str1, i] + matrix[str2, i]) % 2;
//            }
//            return matrix;
//        }

//        вывод матрицы
//        public static void OutMatrix(int[,] matrix, int k, int n)
//        {
//            for (int i = 0; i < k; i++)
//            {
//                for (int j = 0; j < n; j++)
//                {
//                    Console.Write(matrix[i, j]);
//                    if (j + 1 == k) Console.Write("|");
//                }
//                Console.WriteLine();
//            }
//        }

//        вывод одномерного массива
//        public static void OutMass(int[] mas)
//        {
//            Console.WriteLine();
//            for (int i = 0; i < mas.Length; i++)
//            {
//                if (i == k) Console.Write("|");
//                Console.Write(mas[i]);

//            }
//            Console.WriteLine("\n");
//        }
//    }
//}

//using System;

//namespace ЛР__7
//{
//    class Program
//    {
//        static void Main(string[] args)
//        {
//            int lenghtK = 16; //Должна быть равна 2^n
//            int k = (int)(Math.Sqrt(lenghtK));
//            int r = HemmingLength(k);
//            int n = k + r;
//            int lenghtN = lenghtK + (r * k);

//            int[] masK = new int[lenghtK];
//            int[] masK2 = new int[lenghtK]; //сюда запишиться итоговая строка после всех манипуляций 
//            int[] masN = new int[lenghtK + (r * k)];
//            int[,] checkMatrix = new int[n, r];

//            int error;
//            int errorLenght;

//            GenerationRandMasMod2(masK);
//            Console.WriteLine("Входная строка: ");
//            OutMas(masK);

//            Console.WriteLine("\n\nПроверочная матрица: ");
//            checkMatrix = CheckMatrix(k);
//            OutMatrixInv(checkMatrix, n, r);

//            AddCheckBits(masK, masN, checkMatrix);
//            Console.WriteLine("\n\nСтрока с доб. проверочными битами: ");
//            OutMas(masN);

//            Alternation(masN, k);
//            Console.WriteLine("\nСтрока после перемежения: ");
//            OutMas(masN);

//            try
//            {
//                Console.WriteLine("\n\nВведите место ошибки");
//                error = Convert.ToInt32(Console.ReadLine());
//                Console.WriteLine("Введите длину ошибки");
//                errorLenght = Convert.ToInt32(Console.ReadLine());
//                for (int i = error; i < (error + errorLenght); i++)
//                {
//                    masN[i] = (masN[i] + 1) % 2;
//                }
//            }
//            catch { }

//            Console.WriteLine("\nСтрока с ошибками: ");
//            OutMas(masN);

//            ReAlternation(masN, k);
//            Console.WriteLine("\nСтрока после re:перемежения: ");
//            OutMas(masN);

//            SearchErrorLong(masN, checkMatrix, k);
//            Console.WriteLine("\n\nСтрока после исправления ошибок: ");
//            OutMas(masN);

//            RemoveCheckBits(masK2, masN, checkMatrix);
//            Console.WriteLine("\n\nСтрока после удаления проверочных бит: ");
//            OutMas(masK2);
//            Console.WriteLine("");
//            OutMas(masK);
//            Console.WriteLine("\nИсходная строка: ");

//        }

//        static int[] SearchErrorLong(int[] masN, int[,] checkMatrix, int k)
//        {
//            int r = HemmingLength(k);
//            int n = r + k;

//            for (int i = 0; i < k; i++)
//            {
//                int[] temp = new int[n];
//                for (int j = 0; j < n; j++)
//                {
//                    temp[j] = masN[(n * i) + j];
//                }
//                //Получение проверочных битов каждой строки
//                //Console.WriteLine("\nTemp");
//                SearchError(temp, checkMatrix, k);
//                //OutMas(temp);

//                //Запись строки в массив, для получения одной большой строки
//                for (int j = 0; j < n; j++)
//                {
//                    masN[i * n + j] = temp[j];
//                }

//            }

//            return masN;
//        }

//        static int[] RemoveCheckBits(int[] masK, int[] masN, int[,] checkMatrix)
//        {
//            int lenghtK = masK.Length; //Должна быть равна 2^n
//            int lenghtN = masN.Length;
//            int k = (int)(Math.Sqrt(lenghtK));
//            int r = HemmingLength(k);
//            int n = k + r;

//            int[,] matrix = new int[k, n];

//            //Разбиение массива на отдельные строки
//            for (int i = 0; i < k; i++)
//            {
//                int[] temp = new int[n];
//                for (int j = 0; j < n; j++)
//                {
//                    temp[j] = masN[(n * i) + j];
//                }

//                //Запись строки в массив, для получения одной большой строки
//                for (int j = 0; j < k; j++)
//                {
//                    masK[i * k + j] = temp[j];
//                }

//            }
//            return masK;
//        }

//        static int[] AddCheckBits(int[] masK, int[] masN, int[,] checkMatrix)
//        {
//            int lenghtK = masK.Length; //Должна быть равна 2^n
//            int lenghtN = masN.Length;
//            int k = (int)(Math.Sqrt(lenghtK));
//            int r = HemmingLength(k);
//            int n = k + r;

//            int[,] matrix = new int[k, n];

//            //Разбиение массива на отдельные строки
//            for (int i = 0; i < k; i++)
//            {
//                int[] temp = new int[n];
//                for (int j = 0; j < k; j++)
//                {
//                    temp[j] = masK[(k * i) + j];
//                }
//                //Получение проверочных битов каждой строки
//                Sindrom(checkMatrix, temp, k);
//                // Console.WriteLine("");
//                //OutMas(temp);

//                //Запись строки в массив, для получения одной большой строки
//                for (int j = 0; j < n; j++)
//                {
//                    masN[i * n + j] = temp[j];
//                }

//            }
//            return masN;
//        }

//        static int[] Alternation(int[] masN, int k)
//        {
//            int r = HemmingLength(k);
//            int n = k + r;

//            int[,] matrix = new int[k, n];
//            //Получение матрицы
//            for (int i = 0, m = 0; i < k; i++)
//            {
//                for (int j = 0; j < n; j++, m++)
//                {
//                    matrix[i, j] = masN[m];
//                }
//            }
//            Console.WriteLine("\n\nПолученая матрица");
//            OutMatrix(matrix, k, n);

//            //Перемежение
//            for (int i = 0, m = 0; i < n; i++)
//            {
//                for (int j = 0; j < k; j++, m++)
//                {
//                    masN[m] = matrix[j, i];
//                }
//            }

//            return masN;
//        }

//        static int[] ReAlternation(int[] masN, int k)
//        {
//            int r = HemmingLength(k);
//            int n = k + r;

//            int[,] matrix = new int[k, n];
//            //Получение матрицы
//            for (int j = 0, m = 0; j < n; j++)
//            {
//                for (int i = 0; i < k; i++, m++)
//                {
//                    matrix[i, j] = masN[m];
//                }
//            }
//            Console.WriteLine("\n\nПолученая матрица");
//            OutMatrix(matrix, k, n);

//            //RE:Перемежение
//            for (int j = 0, m = 0; j < k; j++)
//            {
//                for (int i = 0; i < n; i++, m++)
//                {
//                    masN[m] = matrix[j, i];
//                }
//            }

//            return masN;
//        }

//        static int[] GenerationRandMasMod2(int[] mas)
//        {
//            Random rnd = new Random();

//            for (int i = 0; i < mas.Length; i++)
//            {
//                mas[i] = rnd.Next(2);
//            }
//            return mas;
//        }


//        //Создание пров. матрицы
//        static int[,] CheckMatrix(int k)
//        {
//            int r = HemmingLength(k);
//            int n = r + k;
//            double rDouble = r - 1;
//            int rPow = (int)(Math.Pow(2, rDouble));

//            int[,] mas = new int[n, r];

//            int[,] combinations = new int[rPow, r];

//            for (int i = 0; i < rPow; i++)
//                for (int j = 0; j < r; j++)
//                    combinations[i, j] = 0;

//            //генератор бит.мн.
//            for (int segmentLenght = 0; segmentLenght < r - 2; segmentLenght++)
//            {
//                if (segmentLenght * r > k) break;

//                for (int i = 0; i < segmentLenght + 2; i++)
//                {
//                    combinations[segmentLenght * r, i] = 1;
//                }

//                for (int segmentPositin = 1; segmentPositin < r; segmentPositin++)
//                {
//                    for (int i = 0; i < r - 1; i++)
//                    {
//                        combinations[segmentLenght * r + segmentPositin, i + 1] = combinations[segmentLenght * r + segmentPositin - 1, i];
//                    }
//                    combinations[segmentLenght * r + segmentPositin, 0] = combinations[segmentLenght * r + segmentPositin - 1, r - 1];
//                }

//                if (segmentLenght == r - 3)
//                {
//                    for (int i = 0; i < r; i++)
//                    {
//                        combinations[rPow - 1, i] = 1;
//                    }
//                }
//            }



//            for (int i = 0; i < k; i++)
//                for (int j = 0; j < r; j++)
//                    mas[i, j] = combinations[i, j];

//            for (int i = 0; i < r; i++)
//                mas[i + k, i] = 1;

//            return mas;
//        }

//        //Поиск синдрома
//        static int[] Sindrom(int[,] CheckMatrix, int[] mas, int k)
//        {

//            int r = HemmingLength(k);
//            int n = r + k;
//            int[] sindrom = new int[r];



//            for (int i = 0, l = 0; i < r; i++, l = 0)
//            {
//                for (int j = 0; j < k; j++)
//                {
//                    if (CheckMatrix[j, i] == 1 && mas[j] == 1) l++;
//                    else sindrom[i] = 0;
//                }
//                if (l % 2 == 1) sindrom[i] = 1;
//                else sindrom[i] = 0;
//            }

//            for (int i = 0; i < r; i++)
//            {
//                mas[i + k] = sindrom[i];
//            }

//            return mas;
//        }

//        //Считаем r (кол-во пров. симв.)
//        static int HemmingLength(int k)
//        {
//            int r = (int)(Math.Log(k, 2) + 1.99f);
//            return r;
//        }

//        //Нахождение ошибок
//        static int[] SearchError(int[] mas, int[,] checkMatrix, int k)
//        {

//            int r = HemmingLength(k);
//            int n = r + k;

//            int[] beforeSindrom = new int[r];

//            //запоминаем проверочные биты
//            for (int i = k; i < n; i++)
//            {
//                beforeSindrom[i - k] = mas[i];
//            }

//            mas = Sindrom(checkMatrix, mas, k);

//            //Складываем синдром по модулю два
//            for (int i = k, j = 0; i < n; i++)
//            {
//                if (beforeSindrom[i - k].Equals(mas[i]))
//                {
//                    mas[i] = 0;

//                    j++;
//                    //если сумма по модулю два все пров. бит равна нулю
//                    if (j == r)
//                    {
//                        for (int l = k; l < n; l++)
//                        {
//                            mas[l] = beforeSindrom[l - k];
//                        }
//                        return mas;
//                    }
//                }
//                else
//                {
//                    mas[i] = 1;
//                }
//            }

//            for (int i = 0; i < n; i++)
//            {
//                int l = 0;
//                for (int j = 0; j < r; j++)
//                {
//                    if (checkMatrix[i, j].Equals(mas[j + k])) l++;
//                }
//                if (l == r)
//                {
//                    mas[i] = (mas[i] + 1) % 2;
//                }
//            }
//            //OutMas(mas);
//            mas = Sindrom(checkMatrix, mas, k);

//            return mas;
//        }

//        static void OutMas(int[] mas)
//        {
//            for (int i = 0; i < mas.Length; i++)
//            {
//                Console.Write(mas[i]);
//            }
//        }
//        //вывод матрицы
//        static void OutMatrix(int[,] matrix, int k, int n)
//        {
//            for (int i = 0; i < k; i++)
//            {
//                for (int j = 0; j < n; j++)
//                {
//                    Console.Write(matrix[i, j]);
//                    //if (j + 1 == k) Console.Write("|");
//                }
//                Console.WriteLine();
//            }
//        }

//        static void OutMatrixInv(int[,] matrix, int k, int n)
//        {
//            for (int j = 0; j < n; j++)
//            {
//                for (int i = 0; i < k; i++)
//                {
//                    Console.Write(matrix[i, j]);
//                }
//                Console.WriteLine();
//            }
//        }
//    }
//}