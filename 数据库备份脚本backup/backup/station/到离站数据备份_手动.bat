@rem �������ӷ�
set CONNECTION_STRING=aptslc/lc@APTS
@rem ���ô˽ű������ļ��б����·����ע��ĩβ��Ҫ��'\'
set basedir=E:
@rem ���ñ����ļ�����ľ���·����ע��ĩβ��Ҫ��'\'
set dumpdir=E:\dumpdir
@rem ������Ҫ���ݵ��·ݣ���ʽΪ201601
set part=201601

echo userid=%CONNECTION_STRING% > %basedir%\backup\station\station.par

echo tables=BSVCBUSARRLFTLD5:P_%part% >> %basedir%\backup\station\station.par

type %basedir%\backup\station\loader.txt >> %basedir%\backup\station\station.par

echo file=%dumpdir%\aptsstation%part%.dmp log=%dumpdir%\aptsstation%part%.log >> %basedir%\backup\station\station.par

exp parfile=%basedir%\backup\station\station.par