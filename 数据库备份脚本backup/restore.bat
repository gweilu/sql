@echo off
@rem �������ӷ�
set CONNECTION_STRING=aptslc/lc@APTS
@rem ����Ҫ�ָ����ļ��ľ���·�����ļ���
set refile=E:\dumpdir\aptsgps20160101.dmp

imp %CONNECTION_STRING% file=%refile% log=%refile%.log full=y recordlength=65535 buffer=104857600 ignore=y skip_unusable_indexes=y