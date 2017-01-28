@rem 设置连接符
set CONNECTION_STRING=aptslc/lc@APTS
@rem 设置此脚本所在文件夹保存的路径，注意末尾不要加'\'
set basedir=E:
@rem 设置备份文件保存的绝对路径，注意末尾不要加'\'
set dumpdir=E:\dumpdir
@rem 设置需要备份的月份，格式为201601
set part=201601

echo userid=%CONNECTION_STRING% > %basedir%\backup\log\log.par

echo tables=(DBLOGSEQ:P_%part%,FDISDISPATCHLOG:P_%part%,FDISLOGFORHANDLELD:P_%part%,FDISDISCMDRECGD:P_%part%) >> %basedir%\backup\log\log.par

type %basedir%\backup\log\loader.txt >> %basedir%\backup\log\log.par

echo file=%dumpdir%\aptslog%part%.dmp log=%dumpdir%\aptslog%part%.log >> %basedir%\backup\log\log.par

exp parfile=%basedir%\backup\log\log.par