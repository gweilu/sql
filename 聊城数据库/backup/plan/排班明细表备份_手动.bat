@rem 设置连接符
set CONNECTION_STRING=aptslc/lc@APTS
@rem 设置此脚本所在文件夹保存的路径，注意末尾不要加'\'
set basedir=E:
@rem 设置备份文件保存的绝对路径，注意末尾不要加'\'
set dumpdir=E:\dumpdir
@rem 设置需要备份的月份，格式为201601
set part=201601

echo userid=%CONNECTION_STRING% > %basedir%\backup\plan\plan.par

echo tables=(FDISDISPLANLD:P_%part%,FDISBUSRUNRECGD:P_%part%) >> %basedir%\backup\plan\plan.par

type %basedir%\backup\plan\loader.txt >> %basedir%\backup\plan\plan.par

echo file=%dumpdir%\aptsplan%part%.dmp log=%dumpdir%\aptsplan%part%.log >> %basedir%\backup\plan\plan.par

exp parfile=%basedir%\backup\plan\plan.par