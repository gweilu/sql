@rem 设置连接符
set CONNECTION_STRING=aptslc/lc@APTS
@rem 设置此脚本所在文件夹保存的路径，注意末尾不要加'\'
set basedir=E:
@rem 设置备份文件保存的绝对路径，注意末尾不要加'\'
set dumpdir=E:\dumpdir

echo userid=%CONNECTION_STRING% > %basedir%\backup\meta.par

echo ROWS=n >> %basedir%\backup\meta.par

echo file=%dumpdir%\aptsmeta%date:~0,4%%date:~5,2%%date:~8,2%.dmp log=%dumpdir%\aptsmeta%date:~0,4%%date:~5,2%%date:~8,2%.log >> %basedir%\backup\meta.par

exp parfile=%basedir%\backup\meta.par
