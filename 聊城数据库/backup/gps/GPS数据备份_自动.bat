@rem �����뱸�ݼ���ǰ������
set input=2

@rem /*************************************************************/
@rem �˴�Ϊ��ȡN��ǰ���ڵ���䣬�����޸ģ�����
cls
set day=%date%
set days=0
echo.&echo.
set input=2
setlocal enabledelayedexpansion
:: ��ȡ����
for /f "tokens=1-3 delims=-/. " %%i in ("%day%") do (
    set /a sy=%%i, sm=100%%j %% 100, sd=100%%k %% 100
)
set /a sd-=input
if %sd% leq 0 call :count
cls&echo.&echo.
set sm=0%sm%
set sd=0%sd%
set part=%sy%%sm:~-2%%sd:~-2%
@rem echo %input% ��ǰ�������ǣ�%part%
goto Main
:count
set /a sm-=1
if !sm! equ 0 set /a sm=12, sy-=1
call :days
set /a sd+=days
if %sd% leq 0 goto count
:days
:: ��ȡָ���·ݵ�������
set /a leap="^!(sy %% 4) & ^!(^!(sy %% 100)) | ^!(sy %% 400)"
set /a max=28+leap
for /f "tokens=%sm%" %%i in ("31 %max% 31 30 31 30 31 31 30 31 30 31") do set days=%%i
@rem /*************************************************************/

:Main
@rem �������ӷ�
set CONNECTION_STRING=aptslc/lc@APTS
@rem ���ô˽ű������ļ��б����·����ע��ĩβ��Ҫ��'\'
set basedir=E:
@rem ���ñ����ļ�����ľ���·����ע��ĩβ��Ҫ��'\'
set dumpdir=E:\dumpdir

echo userid=%CONNECTION_STRING% > %basedir%\backup\gps\gps.par

echo tables=BSVCBUSRUNDATALD5:P_%part% >> %basedir%\backup\gps\gps.par

type %basedir%\backup\gps\loader.txt >> %basedir%\backup\gps\gps.par

echo file=%dumpdir%\aptsgps%part%.dmp log=%dumpdir%\aptsgps%part%.log >> %basedir%\backup\gps\gps.par

exp parfile=%basedir%\backup\gps\gps.par