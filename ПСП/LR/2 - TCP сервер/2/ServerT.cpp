// ServerT.cpp : This file contains the 'main' function. Program execution begins and ends there.
//
#define _CRT_SECURE_NO_WARNINGS
#define _WINSOCK_DEPRECATED_NO_WARNINGS

#include "pch.h"
#include <iostream>
#include <string>
#include "Winsock2.h"
#pragma comment(lib, "Ws2_32.lib")
#include <ctime>


using namespace std;

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


int main()
{
	setlocale(LC_ALL, "rus");
	cout << "Начало работы Сервера" << endl;
	cout << "Ждем соединение" << endl;
	int i = 0;	//number of client
	WSADATA ws;
	SOCKET s;       // серверный сокет
	SOCKET c;
	char ibuf[50];	//буфер ввода для сообщения клиента
	char obuf[50] = "Hello from client";	//буфер вывода
	int t;

	try {
		// -- инициализировать библиотеку WS2_32.DLL
		if (FAILED(WSAStartup(MAKEWORD(1, 1), &ws)))
		{
			cout << "Socket: " << WSAGetLastError() << endl;
		}
		// --создать сокет
		if (INVALID_SOCKET == (s = socket(AF_INET, SOCK_STREAM, 0)))
		{
			cout << "Socket: " << WSAGetLastError() << endl;
		}

		sockaddr_in c_adr;	//client port
		sockaddr_in s_adr;	//server port
		{
			// -- преобразовать  u_short в формат TCP/IP 
			s_adr.sin_port = htons(2000);
			// -- преобразовать символьное представление  IPv4-адреса  в формат TCP/IP  
			s_adr.sin_addr.s_addr = inet_addr("127.0.0.1");
			/*s_adr.sin_addr.S_un.S_addr = inet_addr("127.0.0.1");*/
			s_adr.sin_family = AF_INET;
		}

		if (SOCKET_ERROR == (bind(s, (LPSOCKADDR)&s_adr, sizeof(s_adr))))
		{
			cout << "Bind: " << WSAGetLastError() << endl;
		}

		// -- переключить сокет в режим прослушивания
		if (SOCKET_ERROR == listen(s, 2))
		{
			cout << "Listen: " << WSAGetLastError << endl;
		}

		while (true)
		{
			int lcInt = sizeof(c_adr);
			// -- разрешить подключение к сокету
			if (INVALID_SOCKET == (c = accept(s, (sockaddr*)&c_adr, &lcInt)))
			{
				cout << "accept: " << WSAGetLastError() << endl;
			}

			cout << "         Клиент подключился: " << endl;
			cout << "Адрес клиента :          " << inet_ntoa(c_adr.sin_addr) << " : " << htons(c_adr.sin_port) << endl << endl << endl << endl << endl;

			while (true)
			{
                // -- принять данные по установленному каналу
				if (SOCKET_ERROR == recv(c, ibuf, sizeof(ibuf), NULL))
				{
					cout << "Recv: " << WSAGetLastError() << endl;
					break;
				}

				cout << i << " Client : " << ibuf << endl;
				i++;

				if (!strcmp(ibuf, "CLOSE")) { break; }
				// -- отправить данные по установленному каналу
				if (SOCKET_ERROR == send(c, obuf, strlen(obuf) + 1, NULL))
				{
					cout << "Send: " << WSAGetLastError() << endl;
					break;
				}
			}
			i = 0;
			cout << "\t\tКлиент отключился: " << endl;
		}
		// -- закрыть существующий  сокет 
		if (closesocket(c) == SOCKET_ERROR)
		{
			throw SetErrorMsgText("closesocket: ", WSAGetLastError());
		}
		// -- завершить работу с библиотекой WS2_32.DLL
		if (WSACleanup() == SOCKET_ERROR)
		{
			throw SetErrorMsgText("Cleanup: ", WSAGetLastError());
		}
	}
	catch (string errorMsgText)
	{
		cout << endl << errorMsgText;
	}

	return 0;
}