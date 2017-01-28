@rem 设置连接符
set CONNECTION_STRING=aptslc/lc@APTS
@rem 设置此脚本所在文件夹保存的路径，注意末尾不要加'\'
set basedir=E:
@rem 设置备份文件保存的绝对路径，注意末尾不要加'\'
set dumpdir=E:\dumpdir
@rem 设置需要备份的月份，格式为201601
set part=201601

echo userid=%CONNECTION_STRING% > %basedir%\backup\station\station.par

echo tables=BSVCBUSARRLFTLD5:P_%part% >> %basedir%\backup\station\station.par

type %basedir%\backup\station\loader.txt >> %basedir%\backup\station\station.par

echo file=%dumpdir%\aptsstation%part%.dmp log=%dumpdir%\aptsstation%part%.log >> %basedir%\backup\station\station.par

exp parfile=%basedir%\backup\station\station.par