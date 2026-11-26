# 文件共享系统（Linux C + Socket + SQLite）

一个基于 TCP Socket 的多用户「网络硬盘」：服务端用 SQLite 保存账号与操作历史，客户端可注册、登录、查看文件列表、上传、下载、查询历史记录。

## 文件结构

| 文件 | 说明 |
| --- | --- |
| `server.c` | 服务端：监听 **9999** 端口，每个客户端连接单独开一个线程处理 |
| `client.c` | 客户端：命令行交互，登录后进入命令菜单 |

## 通信协议

两端共用同一个结构体 `struct net_info` 直接收发，靠 `type` 字段区分命令：

| type | 含义 |
| --- | --- |
| 1 | 注册 |
| 2 | 登录 |
| 3 | 文件列表 |
| 4 | 下载文件 |
| 5 | 上传文件 |
| 6 | 查询历史记录 |

结构体内含 `len` / `offset` / `total_len` 三个字段，用于分包传输和**断点续传**（例如文件传到 2000 字节断开，下次从 2000 字节继续）。

## 数据库

服务端启动时打开 `netdisk.db`，用到两张表：

```sql
CREATE TABLE user_info(userid text, passwd text);
CREATE TABLE hist_info(userid text, info text, datetime text);
```

> 代码里**没有自动建表**，首次运行前需要自己建库建表（上方 SQL 存成脚本后用 `sqlite3 netdisk.db < init.sql` 导入即可）。

## 编译

Linux 环境，需要 `libsqlite3-dev`：

```bash
sudo apt install libsqlite3-dev
gcc server.c -o server -lsqlite3 -lpthread
gcc client.c -o client -lpthread
```

## 运行

```bash
./server        # 先启动服务端
./client        # 另开终端启动客户端
```

## 说明

- 本项目为 Linux 环境下的课程设计/学习代码，用到了 `sys/socket.h`、`pthread`、`sqlite3` 等 POSIX 接口，**不能在 Windows 上直接编译**（Windows 下需 WSL 或 MinGW+WinSock 端口改造）。
- SQL 语句为字符串拼接实现，未做参数化，存在 SQL 注入风险，仅作学习用途，不要直接用于生产环境。
