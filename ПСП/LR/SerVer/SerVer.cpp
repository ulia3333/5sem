#include <iostream>
#define _WINSOCK_DEPRECATED_NO_WARNINGS 1
#include "Winsock2.h"
#include "WSAErrors.h"
#pragma comment(lib, "WS2_32.lib")

void MessagingWithClient(SOCKET server, bool* online) {
	SOCKADDR_IN from;
	memset(&from, 0, sizeof(from)); // обнулить память
	int lfrom = sizeof(from);
	char bfrom[1000];
	int recvLen = 0;
	if (recvLen = recvfrom(server, bfrom, sizeof(bfrom), NULL, (sockaddr*)&from, &lfrom) == SOCKET_ERROR) {
		throw SetErrorMsgText("recvfrom Error:", WSAGetLastError());
	}
	clock_t start = clock();
	while (true) {
		if (std::string(bfrom) == "/disconnect")break;
		if (std::string(bfrom) == "/close") { *online = false; break; }
		std::cout << "Принято от " << inet_ntoa(from.sin_addr) << ":" << htons(from.sin_port) <<
			" : " << bfrom << std::endl;
		std::string input = std::string(bfrom);
		if ((sendto(server, bfrom, strlen(bfrom) + 1, NULL, (sockaddr*)&from, sizeof(from))) == SOCKET_ERROR)
			throw SetErrorMsgText("send Error:", WSAGetLastError());
		if (recvLen = recvfrom(server, bfrom, sizeof(bfrom), NULL, (sockaddr*)&from, &lfrom) == SOCKET_ERROR) {
			throw SetErrorMsgText("recvfrom Error:", WSAGetLastError());
		}
	}
	std::cout << "Время обмена с " << inet_ntoa(from.sin_addr) << ":" << htons(from.sin_port) << " : " << (clock() - start) / (double)CLOCKS_PER_SEC << "сек" << std::endl;
}
int main()
{
	setlocale(LC_ALL, "Russian");
	WSADATA wsaData;
	try
	{
		//Инициализируем динамическую библиотеку
		if (WSAStartup(MAKEWORD(2, 0), &wsaData) != 0)
			throw SetErrorMsgText("Startup Error:", WSAGetLastError());
		//Создаём сокет и начинаем работу
		SOCKET serverSocket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
		if (serverSocket == INVALID_SOCKET) {
			throw SetErrorMsgText("socket Error:", WSAGetLastError());
		}
		else {
			bool serverOnline = true;
			SOCKADDR_IN serverAddres;
			serverAddres.sin_family = AF_INET;
			serverAddres.sin_port = htons(2000);
			serverAddres.sin_addr.s_addr = INADDR_ANY;
			if (bind(serverSocket, (LPSOCKADDR)&serverAddres, sizeof(serverAddres)) == SOCKET_ERROR)
				throw SetErrorMsgText("bind Error:", WSAGetLastError());
			std::cout << "Сервер работает на " << inet_ntoa(serverAddres.sin_addr) << ":" << htons(serverAddres.sin_port) << std::endl;
			while (serverOnline) {
				/*try {
					SOCKADDR_IN from;
					memset(&from, 0, sizeof(from)); // обнулить память
					int lfrom = sizeof(from);
					char bfrom[1000];
					int recvLen = 0;
					if (recvLen = recvfrom(serverSocket, bfrom, sizeof(bfrom), NULL, (sockaddr*)&from, &lfrom) == SOCKET_ERROR) {
						throw SetErrorMsgText("recvfrom Error:", WSAGetLastError());
					}
					if (std::string(bfrom) != "stop") {
						std::cout << "\nОтвет от " << inet_ntoa(from.sin_addr) << ":" << htons(from.sin_port) << " : ";
						std::cout << std::string(bfrom).substr(recvLen) << std::endl;
					}
					if ((sendto(serverSocket, bfrom, strlen(bfrom) + 1, NULL, (sockaddr*)&from, sizeof(from))) == SOCKET_ERROR)
						throw SetErrorMsgText("send Error:", WSAGetLastError());
				}
				catch (std::string errorMsgText)
				{
				}*/
				MessagingWithClient(serverSocket, &serverOnline);
			}

			if (closesocket(serverSocket) == SOCKET_ERROR)
				throw SetErrorMsgText("closesocket Error:", WSAGetLastError());
		}
		//Завершаем работу с библиотекой WS2_32.DDL
		if (WSACleanup() == SOCKET_ERROR)
			throw SetErrorMsgText("Cleanup Error:", WSAGetLastError());
	}
	catch (std::string errorMsgText)
	{
		std::cout << std::endl << errorMsgText;
	}
}