	@echo off
	chcp 65001
	title IP Change Program by KimWang09
	mode con cols=65 lines=15
	color 47
	setlocal


goto :CheckUAC

::관리자 권한 취득하기
	:CheckUAC
		::관리자 권한 체크
		>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
		if '%errorlevel%' NEQ '0' (
			goto :UACAccess
		) else ( 
			goto :Done 
		)
	:UACAccess
		cls
		echo.
		echo --- 관리자 권한이 없습니다. ---
		echo "ENTER"키(또는 "예" 버튼)를 눌러 관리자 권한을 취득 합니다...
		echo [참고 : 관리자 권한이 없기때문에 한번더 실행됩니다.]
		timeout 5 >nul
		::pause >nul
		
		::관리자 권한 주기위해 VBS파일을 생성
		echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
		echo UAC.ShellExecute "cmd", "/c """"%~f0"" """ + Wscript.Arguments.Item(0) + """ ""%user%""""", "%CD%", "runas", 1 >> "%temp%\getadmin.vbs"
		"%temp%\getadmin.vbs" "%file%"

		::관리자 권한 완료후 VBS파일 삭제
		del "%temp%\getadmin.vbs"
		exit /b
	:Done
		set /p str=자신의 IP를 입력해주세요:

		:_Start
		cls
		echo.
		echo.
		echo  1. Static Wi-Fi IP
		echo.
		echo  2. DHCP Wi-Fi IP
		echo.
		echo  3. Static Internet IP
		echo.
		echo  4. DHCP Internet IP
		echo.
		echo  5. EXIT
		echo.
		echo.
		set /p num=실행할 기능을 선택해주세요:
		if "%num%"=="1" goto _s_IP
		if "%num%"=="2" goto _d_IP
		if "%num%"=="3" _s_Internet_IP
		if "%num%"=="4" _d_Internet_IP
		if "%num%"=="5" goto _EXIT
		goto _Start

		:_s_IP
		netsh interface ip set address "Wi-Fi" static %str% 255.255.255.0 10.129.58.1 0
		netsh interface ip set dns "Wi-Fi" static 211.182.233.2 primary
		netsh interface ip add dns "Wi-Fi" 168.126.63.1 index=2
		goto _End

		:_d_IP
		netsh -c int ip set address "Wi-Fi" dhcp
		netsh -c int ip set dns "Wi-Fi" dhcp
		goto _End

		:_s_Internet_IP
		netsh interface ip set address "이더넷" static %str% 255.255.255.0 10.129.58.1 0
		netsh interface ip set dns "이더넷" static 211.182.233.2 primary
		netsh interface ip add dns "이더넷" 168.126.63.1 index=2
		goto_End

		:_d_Internet_IP
		netsh -c int ip set address "이더넷" dhcp
		netsh -c int ip set dns "이더넷" dhcp
		goto _End

		:_End
		echo.
		echo.
		echo.
		echo.
		echo.
		echo.
		echo IP변경이 완료되었습니다!
		echo.
		echo.
		echo.
		echo.
		echo.
		echo.
		pause > nul
		goto _Start

		:_EXIT
		chcp 949
		exit