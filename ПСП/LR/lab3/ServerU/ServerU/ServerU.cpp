#define _WINSOCK_DEPRECATED_NO_WARNINGS

#include <string>
#include <iostream>
#include "Winsock2.h" //заголовок WS2_32.dll
#pragma comment(lib, "WS2_32.lib") //экспорт WS2_32.dll
#include "Error.h"
#include <ctime>

using namespace std;

int main()
{
	WSADATA wsaData;
	SOCKET sS; //дескриптор сокета

	SOCKADDR_IN serv; //параметры сокета sS
	serv.sin_family = AF_INET; //используется IP-адресация
	serv.sin_port = htons(2000); //порт 2000
	//serv.sin_addr.s_addr = INADDR_ANY;
	serv.sin_addr.s_addr = INADDR_ANY;


	SOCKET cS; //сокет для обмена данными с клиентом
	SOCKADDR_IN clnt; //параметры сокета клиента
	memset(&clnt, 0, sizeof(clnt)); //обнулить память
	int lclnt = sizeof(clnt); //размер SOCKADDR_IN

	char ibuf[50]; //буфер ввода
	int libuf = 0; //количество принятых байт
	int lobuf = 0; //количество отправленных байт

	int count = 0;

	clock_t start, stop;
	try
	{
		if (WSAStartup(MAKEWORD(2, 0), &wsaData) != 0)
			throw SetErrorMsgText("Startup: ", WSAGetLastError());
		while (true)
		{
			if ((sS = socket(AF_INET, SOCK_DGRAM, NULL)) == INVALID_SOCKET)
				throw SetErrorMsgText("socket: ", WSAGetLastError());

			if (bind(sS, (LPSOCKADDR)&serv, sizeof(serv)) == SOCKET_ERROR)
				throw SetErrorMsgText("bind: ", WSAGetLastError());
			cout << "Server IP-address: " << inet_ntoa(serv.sin_addr) << endl;

			do
			{
				//InetNtop(AF_INET, &(clnt.sin_addr), str, INET_ADDRSTRLEN);

				cout << "IP-address: " << inet_ntoa(clnt.sin_addr) << endl;

				start = clock();
				while (true)
				{
					//Sleep(10);
					if ((libuf = recvfrom(sS, ibuf, sizeof(ibuf), NULL, (sockaddr*)&clnt, &lclnt)) == SOCKET_ERROR)
						throw SetErrorMsgText("recvfrom: ", WSAGetLastError());
					if ((lobuf = sendto(sS, ibuf, strlen(ibuf) + 1, NULL, (sockaddr*)&clnt, sizeof(clnt))) == SOCKET_ERROR)
						throw SetErrorMsgText("sendto: ", WSAGetLastError());
					if (strcmp(ibuf, "") == 0)
						break;
					count++;
					cout << ibuf << endl;
				}
				stop = clock();
				cout << "Time for sendto and recvfrom: " << (double)((stop - start) / CLK_TCK) << endl;
				cout << "Messages: " << count << endl;
				count = 0;

			} while (true);

		}

		if (closesocket(sS) == SOCKET_ERROR)
			throw SetErrorMsgText("closesocket: ", WSAGetLastError());

		if (WSACleanup() == SOCKET_ERROR)
			throw SetErrorMsgText("Cleanup: ", WSAGetLastError());
	}
	catch (string errorMsgText)
	{
		cout << endl << errorMsgText << endl;
	}

	system("pause");
	return 0;
}