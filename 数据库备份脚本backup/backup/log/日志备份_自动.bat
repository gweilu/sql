@rem /*************************************************************/
@rem �˴�Ϊ��ȡ�ϸ������ڵ���䣬�����޸ģ�����
setlocal enabledelayedexpansion
@rem ����ϵͳ���ڸ�ʽΪyyyy-mm-dd
set "y=%date:~0,4%"
set "m=%date:~5,2%"
set /a "m=1!m!-101, m=m+(^!m)*12"
rem �����Ƿ�2�»�С��
set /a "f=^!(m-2), s=^!(m-4)|^!(m-6)|^!(m-9)|^!(m-11)"
rem �����Ƿ�����
set /a "leap=^!(y%%4) & ^!^!(y%%100) | ^!(y%%400)"
rem ������!d!��
set /a "d=f*(28+leap)+s*30+(^!f&^!s)*31"
set /a "y1=y-^!(m-12)"
set "m=0!m!"
set "m=!m:~-2!"
set "d=0!d!"
set "d=!d:~-2!"
set DstDate=!y1!!m!
set part=%DstDate%
@rem /*************************************************************/

@rem �������ӷ�
set CONNECTION_STRING=aptslc/lc@APTS
@rem ���ô˽ű������ļ��б����·����ע��ĩβ��Ҫ��'\'
set basedir=E:
@rem ���ñ����ļ�����ľ���·����ע��ĩβ��Ҫ��'\'
set dumpdir=E:\dumpdir

echo userid=%CONNECTION_STRING% > %basedir%\backup\log\log.par

echo tables=(DBLOGSEQ:P_%part%,FDISDISPATCHLOG:P_%part%,FDISLOGFORHANDLELD:P_%part%,FDISDISCMDRECGD:P_%part%) >> %basedir%\backup\log\log.par

type %basedir%\backup\log\loader.txt >> %basedir%\backup\log\log.par

echo file=%dumpdir%\aptslog%part%.dmp log=%dumpdir%\aptslog%part%.log >> %basedir%\backup\log\log.par

exp parfile=%basedir%\backup\log\log.par
