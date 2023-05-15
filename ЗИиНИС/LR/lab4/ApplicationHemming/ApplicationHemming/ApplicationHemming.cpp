
//1. На основе информационного сообщения, представленного символами английского алфавитов, служебными символами и цифрами, содержащегося в некотором текстовом файле,
//   сформировать информационное сообщение в двоичном виде; длина сообщения в бинарном виде должна быть не менее 16 символов.

//2. Для полученного информационного слова построить проверочную матрицу Хемминга (значение минимального кодового расстояния согласовать с преподавателем - положим, dmin = 3).

//3. Используя построенную матрицу, вычислить избыточные символы (слово Xr).

//4. Принять исходное слово со следующим числом ошибок : 0, 1, 2. Позиция ошибки определяется (генерируется) случайным образом.

//5. Для полученного слова Yn = Yk, Yr, используя уже известную проверочную матрицу Хемминга, вновь вычислить избыточные символы (обозначим их Yr’).

//6. Вычислить и проанализировать синдром. В случае, если анализ синдрома показал, что информационное сообщение было передано с ошибкой (или 2 ошибками), 
//   сгенерировать унарный вектор ошибки Еn = е1, е2, …, еn и исправить одиночную ошибку; проанализировать ситуацию при возникновении ошибки в 2 битах.

// Файл анализируемой информации (а соответственно и интерфейс приложения) должен содержать исходное информационное сообщение, 
// значения величин k, r, n, проверочную матрицу Хемминга Hn, k, слово Xn, Xr, Yn, Yr, Yr’, синдром S, вектор ошибки Еn.
// Программа не должна быть чувствительна к длине информационного сообщения.

#include <iostream>
#include <conio.h>
#include <ctime>

using namespace std;

char* printBits(size_t const, void const * const, char*);
int fact (int);
int binom(int, int);
void HemmingMatrix(int, int);
void IMatrix(int, int, int);
char * GetXr(int, int, char *, char *);
char * GetYn(int, char *, char *);
char * GetYr(int, int, char *, char *);
char * GetSyndrome(char *, char *, char *);


FILE * f;
const char msg_file_path[] = "D:\\5sem\\ЗИиНИС\\LR\\lab4\\message.txt";


//

char **A = NULL; // указатель на двумерный динамический массив - поддержка реализации проверочной матрицы Хемминга

char **I = NULL;// указатель на двумерный динамический массив - поддержка реализации матрицы I

int main()
{
	srand((unsigned)time(NULL));  //генерируем при каждом запуске программы новые числа

	setlocale(LC_CTYPE, "Ru");

	cout << endl << "лабораторная работа №4 Гринцевич Юлии" << endl;

	// 1. 

	errno = 0;
	f = fopen(msg_file_path, "r+b");
	if (f == NULL)
	{
		cout << endl << "Ошибка открытия файла для чтения: " << errno << endl;
	}

	// берем размер файла
	fseek(f, 0L, SEEK_END);
	long file_sz = ftell(f);

	// возвращаемся в начало файла
	fseek(f, 0L, SEEK_SET);

	// размещаем в динамической памяти буфер для содержания данных файла
	unsigned char * flbuff = new unsigned char[file_sz];

	// считываем все данные файла
	size_t elem_readed = fread(flbuff, file_sz, 1, f);

	if (elem_readed*file_sz != file_sz) cout << endl << "Не все данные файла прочитаны" << endl;
	else cout << endl << "Данные из файла успешно прочитаны (" << file_sz << " байт)" << endl;

	cout << endl << "Исходное сообщение из текстового файла: " << endl << endl;
	
	char * binbuff = new char [file_sz * 8 + 1];
	memset(binbuff, 0, file_sz * 8 + 1);

	printBits(file_sz, flbuff, binbuff);
	printf(binbuff);

	cout << endl;

	// 2. 
	int k = strlen(binbuff), 
		r = log2(k) + 1,
		n = k + r;

	cout << endl << "k = " << k << endl;
	cout << endl << "r = " << r << endl;
	cout << endl << "n = " << n << endl;

	A = new char * [r * sizeof(char *)];
	for (int i = 0; i < r; i++) {
		A[i] = new char [k * sizeof(char)];
	}

	// инициализируем символами '0'
	for (int i = 0; i < r; i++)
		for (int j = 0; j < k; j++) 
			A[i][j] = '0' ;

	HemmingMatrix(k, r);

	// вывод проверочной матрицы Хемминга

	cout << endl << "Проверочная матрица Хемминга: " << endl;
	for (int i = 0; i < r; i++)
	{
		for (int j = 0; j < k; j++) cout << A[i][j];

		cout << endl;

	}

	// получение и вывод матрицы I

	I = new char *[r * sizeof(char *)];
	for (int i = 0; i < r; i++) {
		I[i] = new char[r * sizeof(char)];
	}

	IMatrix(k, r, n);

	cout << endl << "Подматрица I: " << endl;
	for (int i = 0; i < r; i++)
	{
		for (int j = 0; j < r; j++) cout << I[i][j];

		cout << endl;

	}

	// 3.
	char * XrBuff = new char[r+1]; // результирующий буфер избыточных кодов
	memset(XrBuff, 0, r+1);
	GetXr(r, k, binbuff, XrBuff);
	cout << endl << "Последовательность избыточных символов: " << XrBuff;

	// 4.

	char * Y0_buff = new char[k + 1],
		 * Y1_buff = new char[k + 1],
		 * Y2_buff = new char[k + 1] ;

	memset(Y0_buff, 0, k + 1);
	memset(Y1_buff, 0, k + 1);
	memset(Y2_buff, 0, k + 1);

	// нет ошибок
	GetYn(0, binbuff, Y0_buff);
	// одна ошибка
	GetYn(1, binbuff, Y1_buff);
	// две ошибки
	GetYn(2, binbuff, Y2_buff);
	cout << endl << "Переданное сообщение :               " << binbuff;
	cout << endl << "---------------------------------------------------------------------------------------------------------------------------------------------------------------------";
	cout << endl << "Принято сообщение без ошибок :       " << Y0_buff;
	cout << endl << "Принято сообщение с одной ошибкой :  " << Y1_buff;
	cout << endl << "Принято сообщение с двумя ошибками : " << Y2_buff;

	// 5.

	// для принятых сообщений - избыточность:
	char * Yr0Buff = new char[r + 1]; // результирующий буфер избыточных кодов для принятого сообщения без ошибки
	memset(Yr0Buff, 0, r + 1);
	GetYr(r, k, Y0_buff, Yr0Buff);

	char * Yr1Buff = new char[r + 1]; // результирующий буфер избыточных кодов для принятого сообщения с одной ошибкой
	memset(Yr1Buff, 0, r + 1);
	GetYr(r, k, Y1_buff, Yr1Buff);

	char * Yr2Buff = new char[r + 1]; // результирующий буфер избыточных кодов для принятого сообщения с двумя ошибками
	memset(Yr2Buff, 0, r + 1);
	GetYr(r, k, Y2_buff, Yr2Buff);

	cout << endl << "Последовательность избыточных символов для принятого сообщения без ошибки: " << Yr0Buff;
	cout << endl << "Последовательность избыточных символов для принятого сообщения с одной ошибкой: " << Yr1Buff;
	cout << endl << "Последовательность избыточных символов для принятого сообщения с двумя ошибками: " << Yr2Buff;

	// 6.

	//вычислим синдром

	char * Syndrome_0 = new char[r + 1];
	memset(Syndrome_0, 0, r + 1);
	GetSyndrome(XrBuff, Yr0Buff, Syndrome_0);

	char * Syndrome_1= new char[r + 1];
	memset(Syndrome_1, 0, r + 1);
	GetSyndrome(XrBuff, Yr1Buff, Syndrome_1);

	char * Syndrome_2 = new char[r + 1];
	memset(Syndrome_2, 0, r + 1);
	GetSyndrome(XrBuff, Yr2Buff, Syndrome_2);

	cout << endl << "Синдром для принятого сообщения без ошибки: " << Syndrome_0;
	cout << endl << "Синдром для принятого сообщения с одной ошибкой: " << Syndrome_1;
	cout << endl << "Синдром для принятого сообщения с двумя ошибками: " << Syndrome_2;

	// рассмотрим и скорректируем случай с одной ошибкой!

	int  err_idx = 0; // номер столбца матрицы Хемминга, значение которого совпадает с синдромом

	for (int i = 0; i < k; i++)
	{
		bool compare_res = true;

		for (int j = 0; j < r; j++)
		{

		compare_res = compare_res && (A[j][i] == Syndrome_1[j]);

		}

		if (compare_res) {
		
			err_idx = i;

			break;

		}

	}

	cout << endl << "Для случая с одной ошибкой - ошибка в " << (err_idx + 1) << " бите";

	char * E = new char[n+1];
	memset(E, '0', n);
	E[n] = '\0';
	E[err_idx] = '1';

	cout << endl << n << " - разрядный вектор ошибки " << E << endl;

	// откорректируем сообщение, в котором обнаружена одна ошибка - XOR сообщения с ошибкой и вектора ошибки

	char * XCorrected = new char[k + 1];
	memset(XCorrected,0,k+1);

	for (int i = 0; i < k; i++)
	{
		int Yn = Y1_buff[i] == '0' ? 0 : 1;
		int En = E[i] == '0' ? 0 : 1;

		int xor_res = Yn ^ En;

		XCorrected[i] = xor_res == 0 ? '0' : '1';

	}

	cout << endl << "СКОРРЕКТИРОВАННОЕ СООБЩЕНИЕ : " << XCorrected << endl;


	// высвобождаем ранее выделенную динамическую память

	delete[] binbuff; binbuff = NULL;
	delete[] flbuff; flbuff = NULL;

	delete[] XrBuff; XrBuff = NULL;

	delete[] Y0_buff; Y0_buff = NULL;

	delete[] Y1_buff; Y1_buff = NULL;

	delete[] Y2_buff; Y2_buff = NULL;

	delete[] Yr0Buff; Yr0Buff = NULL;
	delete[] Yr1Buff; Yr1Buff = NULL;
	delete[] Yr2Buff; Yr2Buff = NULL;

	delete[] Syndrome_0; Syndrome_0 = NULL;
	delete[] Syndrome_1; Syndrome_1 = NULL;
	delete[] Syndrome_2; Syndrome_2 = NULL;

	delete[] XCorrected; XCorrected = NULL;

	fclose(f); 

	cout << endl << "Нажмите любую клавишу для завершения работы программы...";
	_getch();

	return 0;
}

char * printBits(size_t const size, void const * const ptr, char * binbuff)
{
	unsigned char *b = (unsigned char*)ptr;
	unsigned char bit;
	int i, j;

	for (i = 0; i < size; i++)
	{
		for (j = 7; j >= 0; j--)
		{
			bit = (b[i] >> j) & 1;
			sprintf(binbuff+i*8+7-j, "%u", bit);			
		}
	}
	puts("");

	return binbuff;
}

void HemmingMatrix(int k, int r)
{

		unsigned long num = 1;		

		int wt = 2;

		int count = 0;

		int columnid = 0; 

		char * buf = new char [r + 1];

		while (true) { // num <= pow(2,r) && columnid < k

		memset(buf, 0, r + 1);

		_ultoa(num, buf, 2);     //представление натурального числа в двоичной системе счисления
		int len = strlen(buf); //переменная len хранит длину полученной двоичной последовательности

		//переменная len хранит длину полученной двоичной последовательности
		int sum = 0; //переменная, используемая для вычисления веса полученной двоичной последовательности (двоичного представления натурального числа)
		for (int i = 0; i < len; i++)
		{
			if (buf[i] == '1')
				sum++; //при встрече в двоичном представлении числа символа '1' счетчик sum увеличивается на 1
		}

		if (sum == wt) //если вес числа в двоичном представлении равен текущему весу (первоначально wt=2)
		{
			count++; //тогда число комбинаций, подходящих для заполнения столбцов матрицы Ak,r, увеличивается на 1
			columnid++; // индекс столбца для занесения значение

			if (len < r) //если длина полученной двоичной последовательности меньше r, происходит увеличение ее на (r - длина последовательности) нулей
			{
				char * buf1 = new char[r+1];
				memset(buf1,'0', r);
				buf1[r] = '\0';

				memcpy(buf1 + r - len, buf, len);
				memcpy(buf, buf1, r);

				delete[]buf1; buf1 = NULL;
			}

			for (int i = 0; i < r; i++) {
				//заполнение столбца матрицы Ak,r
				A[i][columnid-1] = buf[i];
			}

			if (count == binom(wt, r)) {

				count = 0;
				num = 0;
				wt++;

			}
		} // sum == wt
	
		num++;
	
		if (num > pow(2, r) || columnid > k) break;

		}

	    delete[] buf; buf = NULL;
}

void IMatrix(int k, int r, int n)
{
	for (int i = 0; i < r; i++)
	{
		for (int j = 0; j < r; j++)
		{
			if (i==j) I[i][j] = '1';
			else I[i][j] = '0';
		}
	}
}

char * GetXr(int r, int k, char * buff, char * XrBuff)
{

	for (int i = 0; i < r; i++)
	{
		int row_res = 0; 

		for (int j = 0; j < k; j++)
		{
			int Aij = A[i][j] == '0' ? 0 : 1;
			int Xj = buff[j] == '0' ? 0 : 1;			

			 row_res = row_res ^ (Aij * Xj);
		}

		XrBuff[i] = row_res == 0 ? '0' : '1';
	}

	return XrBuff;
}

char * GetYn(int n, char * buff, char * Yn_buff)
{

	memcpy(Yn_buff, buff, strlen(buff));

	switch (n)
	{
	case 0: // нет ошибок
	break;

	case 1: // одна ошибка
	{
		int err_pos = rand() % (strlen(buff) - 1);
		if (buff[err_pos] == '0') Yn_buff[err_pos] = '1';
		else Yn_buff[err_pos] = '0';
	}
	break;

	case 2: // две ошибки
	{
		int err_pos1 = rand() % (strlen(buff) - 1);
		if (buff[err_pos1] == '0') Yn_buff[err_pos1] = '1';
		else Yn_buff[err_pos1] = '0';

		int err_pos2 = rand() % (strlen(buff) - 1);
		if (buff[err_pos2] == '0') Yn_buff[err_pos2] = '1';
		else Yn_buff[err_pos2] = '0';
	}
	break;

	default :

	break;
	} // switch


	return Yn_buff;
}

char * GetYr(int r, int k, char * Yn_buff, char * YrBuff)
{

	for (int i = 0; i < r; i++)
	{
		int row_res = 0;

		for (int j = 0; j < k; j++)
		{
			int Aij = A[i][j] == '0' ? 0 : 1;
			int Yj = Yn_buff[j] == '0' ? 0 : 1;

			row_res = row_res ^ (Aij * Yj);
		}

		YrBuff[i] = row_res == 0 ? '0' : '1';
	}

	return YrBuff;
}

int fact (int n) 
{
	//функция вычисляет факториал натурального числа n

	int answer; //переменная, которая будет хранить значение факториала n

	if (n == 1) return 1; //1 (1!=1)
		
	answer = fact(n - 1) * n; //рекурсивное обращение функции к самой себе
	
	return answer; 
}

int binom (int wt, int r) 
{
	//функция вычисления бинома Ньютона
	//позволяет вычислить количество различных комбинаций из нулей и единиц, которые мы можем получить при заданных значениях r и wt
	//wt - вес столбца проверчной матрицы, r - количество проверочных символов

	int C = fact(r) / (fact(wt)*fact(r - wt));

	return C; 
}

char * GetSyndrome(char * Yrbuf, char * YrNbufcalc, char * Syndrome)
{
	//
	

	for (int i = 0; i < strlen(Yrbuf); i++)
	{
		int Yr = Yrbuf[i] == '0' ? 0 : 1;
		int YrNCalc = YrNbufcalc[i] == '0' ? 0 : 1;

		int xor_res = Yr ^ YrNCalc;

		Syndrome[i] = xor_res == 0 ? '0' : '1';

	}

	return Syndrome;
}