@rem 设置连接符
set CONNECTION_STRING=aptslc/lc@APTS
@rem 设置此脚本所在文件夹保存的路径，注意末尾不要加'\'
set basedir=E:
@rem 设置备份文件保存的绝对路径，注意末尾不要加'\'
set dumpdir=E:\dumpdir
@rem 设置需要备份的日期，格式为20160101
set part=20160101

echo userid=%CONNECTION_STRING% > %basedir%\backup\gps\gps.par

echo tables=BSVCBUSRUNDATALD5:P_%part% >> %basedir%\backup\gps\gps.par

type %basedir%\backup\gps\loader.txt >> %basedir%\backup\gps\gps.par

echo file=%dumpdir%\aptsgps%part%.dmp log=%dumpdir%\aptsgps%part%.log >> %basedir%\backup\gps\gps.par

exp parfile=%basedir%\backup\gps\gps.par