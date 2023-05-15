#include "LZ.hpp"
#include <iostream>
#include <conio.h>
#include <ctime>
#include <Windows.h>

int main(int argc, char* argv[])
{
	setlocale(LC_CTYPE, "Ru");

	SetConsoleCP(1251);// установка кодовой страницы win-cp 1251 в поток ввода
	SetConsoleOutputCP(1251); // установка кодовой страницы win-cp 1251 в поток вывода

	std::cout << "10 Лаба: Гринцевич ЮС" << std::endl;

	//создание окружения рабочих каталогов
	std::filesystem::path rootPath = std::filesystem::current_path();
	// создадим каталоги единожды - заранее
	//std::filesystem::create_directory(rootPath / "Source");
	//std::filesystem::create_directory(rootPath / "Packed");
	//std::filesystem::create_directory(rootPath / "Unpacked");

	clock_t start, finish; // отметки времени старта и завершения каждого теста
	double et1 = 0, et2 = 0; //время выполнения каждого теста в секундах

	/*std::filesystem::path inPath(argv[1]);
	std::filesystem::path outPath(argv[2]);*/
	std::string argument = argv[3];

	LZ77 result(10, 8);

	// Сжатие - флаг compress
	if (argument == "c")
	{
		std::filesystem::path srcPath(rootPath / "Source" / argv[1]);
		std::filesystem::path pckgPath(rootPath / "Packed" / argv[2]);

		start = clock();
		result.pack(srcPath, pckgPath);
		finish = clock();
		et1 = (double)(finish - start) / CLOCKS_PER_SEC;
		std::cout << std::endl << "Сжатие заняло " << et1 << " миллисекунд. " << std::endl;
	}

	// Распаковка - флаг decompress
	else if (argument == "d")
	{
		std::filesystem::path pckgPath(rootPath / "Packed" / argv[1]);
		std::filesystem::path unpckgPath(rootPath / "Unpacked" / argv[2]);

		start = clock();
		result.unpack(pckgPath, unpckgPath);
		finish = clock();
		et2 = (double)(finish - start) / CLOCKS_PER_SEC;
		std::cout << std::endl << "Распаковка заняла " << et2 << " миллисекунд. " << std::endl;
	}

	else std::cout << "Ошибочная параметризация" << std::endl;
}
	