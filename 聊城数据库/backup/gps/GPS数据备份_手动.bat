@rem �������ӷ�
set CONNECTION_STRING=aptslc/lc@APTS
@rem ���ô˽ű������ļ��б����·����ע��ĩβ��Ҫ��'\'
set basedir=E:
@rem ���ñ����ļ�����ľ���·����ע��ĩβ��Ҫ��'\'
set dumpdir=E:\dumpdir
@rem ������Ҫ���ݵ����ڣ���ʽΪ20160101
set part=20160101

echo userid=%CONNECTION_STRING% > %basedir%\backup\gps\gps.par

echo tables=BSVCBUSRUNDATALD5:P_%part% >> %basedir%\backup\gps\gps.par

type %basedir%\backup\gps\loader.txt >> %basedir%\backup\gps\gps.par

echo file=%dumpdir%\aptsgps%part%.dmp log=%dumpdir%\aptsgps%part%.log >> %basedir%\backup\gps\gps.par

exp parfile=%basedir%\backup\gps\gps.par