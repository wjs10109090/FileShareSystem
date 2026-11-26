# 文件共享系统 —— 服务端 / 客户端
# 用法：make          编译 server 与 client
#       make clean    清理产物

CC      = gcc
CFLAGS  = -Wall -O2
LDLIBS  = -lpthread -lsqlite3

all: server client

server: server.c
	$(CC) $(CFLAGS) -o $@ $< $(LDLIBS)

client: client.c
	$(CC) $(CFLAGS) -o $@ $< -lpthread

clean:
	rm -f server client

.PHONY: all clean
