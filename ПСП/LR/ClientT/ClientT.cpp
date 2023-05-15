// ClientT.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

//#define _WINSOCK_DEPRECATED_NO_WARNINGS
#include "pch.h"
#include <iostream>
#include "Winsock2.h"
#include <string>
#include "WS2tcpip.h"
#pragma comment(lib, "WS2_32.lib")

using namespace std;

string GetErrorMsgText(int code);
string SetErrorMsgText(string msgText, int code);

int main()
{
	setlocale(LC_ALL, "rus");
	SOCKET cC;
	WSADATA wsaData;
	
	try {
		// -- инициализировать библиотеку WS2_32.DLL
		if (WSAStartup(MAKEWORD(2, 0), &wsaData) != 0)
			throw SetErrorMsgText("Startup: ", WSAGetLastError());
		// -- создать сокет
		if ((cC = socket(AF_INET, SOCK_STREAM, NULL)) == INVALID_SOCKET)
			throw  SetErrorMsgText("socket:", WSAGetLastError());



		SOCKADDR_IN serv;	// параметры  сокета сервера
		serv.sin_family = AF_INET;	// используется IP-адресация
		serv.sin_port = htons(3000);	//TCP - порт Server
		inet_pton(AF_INET, "127.0.0.1", &(serv.sin_addr)); // адрес сервера
		// -- установить соединение с сокетом
		if ((connect(cC, (sockaddr*)&serv, sizeof(serv))) == SOCKET_ERROR)
			throw  SetErrorMsgText("connect:", WSAGetLastError());

		char ibuf[50], //буфер ввода 
			obuf[50] = "Hello from client";  //буфер вывода
		int  libuf = 0, //количество принятых байт
			lobuf = 0;  //количество отправленных байт

		char b[] = "Hello from client ";

		int count;
		cout << "Введите количество сообщений" << endl;
		cin >> count;


		for (int i = 0; i < count; i++)
		{
			// -- отправить данные по установленному каналу
			if (SOCKET_ERROR == send(cC, obuf, sizeof(obuf), NULL))
			{
				cout << "Send : " << GetLastError() << endl;;
			}
			// -- принять данные по установленному каналу
			if (SOCKET_ERROR == recv(cC, ibuf, sizeof(ibuf), NULL))
			{
				cout << "Recv : " << GetLastError() << endl;
			}

			cout << (i + 1) << " Serv: " << ibuf << endl;
		}
		// -- отправить данные по установленному каналу
		if (SOCKET_ERROR == send(cC, "CLOSE", sizeof("CLOSE"), NULL))
		{
			cout << "send exit : " << GetLastError() << endl;
		}
		// -- закрыть существующий сокет
		if (closesocket(cC) == SOCKET_ERROR)
			throw  SetErrorMsgText("closesocket:", WSAGetLastError());

		if (WSACleanup() == SOCKET_ERROR)
			throw SetErrorMsgText("Cleanup: ", WSAGetLastError());
	}
	catch (string errorMsgText)
	{
		cout << endl << errorMsgText;

	}
	system("pause");
	return 0;
}

string GetErrorMsgText(int code)
{
	string msgText;
	switch (code)
	{
	case WSAEINTR: msgText = "Function interrupted";
		break;
	case WSAEACCES: msgText = "Permission denied";
		break;
	case WSAEFAULT: msgText = "Wrong address";
		break;
	case WSASYSCALLFAILURE: msgText = "System call abort";
		break;
	default: msgText = "***ERROR***";
		break;
	}

	return msgText;
}


string SetErrorMsgText(string msgText, int code)
{
	return msgText + GetErrorMsgText(code);
}