@rem /*************************************************************/
@rem 此处为获取上个月日期的语句，请勿修改！！！
setlocal enabledelayedexpansion
@rem 假设系统日期格式为yyyy-mm-dd
set "y=%date:~0,4%"
set "m=%date:~5,2%"
set /a "m=1!m!-101, m=m+(^!m)*12"
rem 上月是否2月或小月
set /a "f=^!(m-2), s=^!(m-4)|^!(m-6)|^!(m-9)|^!(m-11)"
rem 今年是否闰年
set /a "leap=^!(y%%4) & ^!^!(y%%100) | ^!(y%%400)"
rem 上月有!d!天
set /a "d=f*(28+leap)+s*30+(^!f&^!s)*31"
set /a "y1=y-^!(m-12)"
set "m=0!m!"
set "m=!m:~-2!"
set "d=0!d!"
set "d=!d:~-2!"
set DstDate=!y1!!m!
set part=%DstDate%
@rem /*************************************************************/

@rem 设置连接符
set CONNECTION_STRING=aptslc/lc@APTS
@rem 设置此脚本所在文件夹保存的路径，注意末尾不要加'\'
set basedir=E:
@rem 设置备份文件保存的绝对路径，注意末尾不要加'\'
set dumpdir=E:\dumpdir

echo userid=%CONNECTION_STRING% > %basedir%\backup\log\log.par

echo tables=(DBLOGSEQ:P_%part%,FDISDISPATCHLOG:P_%part%,FDISLOGFORHANDLELD:P_%part%,FDISDISCMDRECGD:P_%part%) >> %basedir%\backup\log\log.par

type %basedir%\backup\log\loader.txt >> %basedir%\backup\log\log.par

echo file=%dumpdir%\aptslog%part%.dmp log=%dumpdir%\aptslog%part%.log >> %basedir%\backup\log\log.par

exp parfile=%basedir%\backup\log\log.par
