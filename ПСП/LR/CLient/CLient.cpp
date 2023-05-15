#include <iostream>
#define _WINSOCK_DEPRECATED_NO_WARNINGS 1
#include "Winsock2.h"
#include <string>
#include "WSAErrors.h"
#pragma comment(lib, "WS2_32.lib")

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
		SOCKET clientSocket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
		if (clientSocket == INVALID_SOCKET) {
			throw SetErrorMsgText("socket Error:", WSAGetLastError());
		}
		else {
			SOCKADDR_IN serverAddres;
			serverAddres.sin_family = AF_INET;
			serverAddres.sin_port = htons(2000);
			serverAddres.sin_addr.s_addr = inet_addr("127.0.0.1");
			int N = 0;
			std::cout << "Введите кол-во сообщений\n";
			std::cin >> N;
			char* inputBuf;
			char outputBuf[1000];
			int lenInput = 0,
				lenOutput = 0;
			int addLen = sizeof(serverAddres);
			int i = 1;
			std::string msg = std::string("Hello from ClientU");
			inputBuf = (char*)msg.c_str();
			if ((lenInput = sendto(clientSocket, inputBuf, strlen(inputBuf) + 1, NULL, (sockaddr*)&serverAddres, sizeof(serverAddres))) == SOCKET_ERROR)
				throw SetErrorMsgText("sendto Error:", WSAGetLastError());
			if ((lenOutput = recvfrom(clientSocket, outputBuf, sizeof(outputBuf), NULL, (sockaddr*)&serverAddres, &addLen)) == SOCKET_ERROR)
				throw SetErrorMsgText("recvfrom Error:", WSAGetLastError());
			std::cout << "Сообщение успешно отправленно и получен ответ от сервера\n";
			/*
			while (i <= N) {
				std::string input = "Hello from Client " + std::to_string(i);
				inputBuf = (char*)input.c_str();
				if ((lenInput = sendto(clientSocket, inputBuf, strlen(inputBuf) + 1, NULL, (sockaddr*)&serverAddres, sizeof(serverAddres))) == SOCKET_ERROR)
					throw SetErrorMsgText("sendto Error:", WSAGetLastError());
				if ((lenOutput = recvfrom(clientSocket, outputBuf, sizeof(outputBuf), NULL, (sockaddr*)&serverAddres, &addLen)) == SOCKET_ERROR)
					throw SetErrorMsgText("recvfrom Error:", WSAGetLastError());
				std::string out = outputBuf;
				out = out.substr(strlen("Hello from Client "));
				i = std::stoi(out) + 1;
			}
			*/
			while (i <= N) {
				std::string msg = (std::string("Отправленный для обработки сервером пакет №") + std::to_string(i) + "/" + std::to_string(N));
				inputBuf = (char*)msg.c_str();
				if ((lenInput = sendto(clientSocket, inputBuf, msg.length() + 1, NULL, (sockaddr*)&serverAddres, sizeof(serverAddres))) == SOCKET_ERROR)
					throw SetErrorMsgText("send Error:", WSAGetLastError());
				i++;
			}
			msg = std::string("/disconnect");
			inputBuf = (char*)msg.c_str();
			if ((lenInput = sendto(clientSocket, inputBuf, strlen(inputBuf) + 1, NULL, (sockaddr*)&serverAddres, sizeof(serverAddres))) == SOCKET_ERROR)
				throw SetErrorMsgText("send Error:", WSAGetLastError());
			int iTimeout = 1000;
			if (setsockopt(clientSocket,
				SOL_SOCKET,
				SO_RCVTIMEO,
				(const char*)&iTimeout,
				sizeof(iTimeout)) == SOCKET_ERROR) {
				throw SetErrorMsgText("setSockTimeout Error:", WSAGetLastError());
			}
			int countGood = 0;
			i = 1;
			lenOutput = recvfrom(clientSocket, outputBuf, sizeof(outputBuf), NULL, (sockaddr*)&serverAddres, &addLen);
			while (i <= N) {
				if ((lenOutput = recvfrom(clientSocket, outputBuf, sizeof(outputBuf), NULL, (sockaddr*)&serverAddres, &addLen)) != SOCKET_ERROR) {
					if (std::string(outputBuf) == "/disconnect")break;
					countGood++;
				}
				i++;
			}
			std::cout << "Потеряно пакетов: " << N - countGood << '\n';

			if (closesocket(clientSocket) == SOCKET_ERROR)
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