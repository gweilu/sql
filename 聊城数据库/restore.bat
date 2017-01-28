@echo off
@rem 设置连接符
set CONNECTION_STRING=aptslc/lc@APTS
@rem 设置要恢复的文件的绝对路径及文件名
set refile=E:\dumpdir\aptsgps20160101.dmp

imp %CONNECTION_STRING% file=%refile% log=%refile%.log full=y recordlength=65535 buffer=104857600 ignore=y skip_unusable_indexes=y