-- 文件共享系统 —— 数据库结构
-- 用法：先建库再导入
--   sqlite3 netdisk.db < schema.sql
--
-- 说明：服务端代码（server.c）里不会自动建表，第一次运行前必须执行本脚本，
--       否则注册 / 登录 / 历史记录都会因为「no such table」失败。

PRAGMA encoding = 'UTF-8';

-- 用户表：注册与登录
CREATE TABLE IF NOT EXISTS user_info (
    userid  TEXT PRIMARY KEY,
    passwd  TEXT
);

-- 操作历史表：服务端每完成一次注册/登录/上传/下载都会插入一条
CREATE TABLE IF NOT EXISTS hist_info (
    userid   TEXT,
    info     TEXT,
    datetime TEXT
);
