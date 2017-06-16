#NoTrayIcon
#Region ;**** 参数创建于 ACNWrapper_GUI ****
#AutoIt3Wrapper_icon=resources/icons/万能GHOT备份恢复.ico
#AutoIt3Wrapper_outfile=/dist/万能GHOT备份恢复.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=运行参数  /yjbf 静默设置备份  /yjhf 静默设置恢复 /dos 静默设置手工GHOST  /cancel 取消已有的设置
#AutoIt3Wrapper_Res_Description=一键备份恢复程序
#AutoIt3Wrapper_Res_Fileversion=0.9.1.22
#AutoIt3Wrapper_Res_LegalCopyright=JS
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Res_Icon_Add=resources/icons/bf.ico
#AutoIt3Wrapper_Res_Icon_Add=resources/icons/hf.ico
#EndRegion ;**** 参数创建于 ACNWrapper_GUI ****
#include <GUIConstants.au3>
#include <Sound.au3>
#include <ComboConstants.au3>

;==============================初始化变量==============================
Dim $Music
Dim $ColorEgg

;==============================读取虚拟内存位置==============================
$PagingFiles = StringSplit(RegRead("HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Session Manager\Memory Management", "PagingFiles"), " ")
$PagingFilesPath = ""
For $Var = 1 To $PagingFiles[0]
	$PagingFiles[$Var] = $PagingFiles[$Var] & " "
Next
For $Var = 1 To $PagingFiles[0] - 2
	$PagingFilesPath = $PagingFilesPath & $PagingFiles[$Var]
Next
$PagingFilesPath = StringLeft($PagingFilesPath, StringLen($PagingFilesPath) - 1)

;==============================读取参数==============================
If $CmdLine[0] >= 1 Then
	If $CmdLine[1] = "/yjbf" Then
		_GHOST("备份", "", '-nousb -clone,mode=pdump,src=1:1,dst=1:2\Ghost\windows.gho -z1 -sure -rb ', 0, 0, 0)
		Exit
	EndIf
	
	If $CmdLine[1] = "/yjhf" Then
		If FileExists("d:\GHOST\windows.gho") = 0 Then
			MsgBox(262160, "万能GHOT备份恢复", "找不到d:\GHOST\windows.gho  " & Chr(13) & "请保证GHO文件在d:\GHOST\ ，两秒后会自动关闭", 2)
			Exit
		EndIf
		_GHOST("恢复", "", '-nousb -clone,mode=pload,src=1:2\Ghost\windows.gho:1,dst=1:1 -sure -rb ', 0, 0, 0)
		Exit
	EndIf
	
	If $CmdLine[1] = "/dos" Then
		_GHOST("进入DOS GHOST手工操作", "", "", 0, 0, 0)
		Exit
	EndIf
	
	If $CmdLine[1] = "/cancel" Then
		If FileExists("c:\JS\boot.bak") = 1 Then
			FileSetAttrib("C:\boot.ini", "-RSH")
			FileCopy("c:\JS\boot.bak", "c:\boot.ini", 9)
			FileSetAttrib("C:\boot.ini", "+RSH")
			If FileExists ( "c:\JS\menu.bak" )=1 Then  FileCopy("c:\JS\menu.bak", "C:\menu.lst", 9)
			FileSetAttrib("C:\jsgh", "-RSH")
			FileDelete("c:\jsgh")
			DirRemove("c:\JS", 1)
		Else
			MsgBox(262160, "万能GHOT备份恢复", "没有发现任何请求! 两秒后自动关闭", 2)
		EndIf
		Exit
	EndIf
EndIf

;==============================创建界面==============================
$GUI = GUICreate("万能GHOT备份恢复", 400, 330, -1, -1)
GUISetFont(9, 400)
FileInstall("resources\logo.gif", @TempDir & "\")
$ColorEgg1 = GUICtrlCreatePic(@TempDir & "\logo.gif", 0, 0, 0, 0)
GUICtrlSetCursor(-1, 0)
FileDelete(@TempDir & "\logo.gif")
FileInstall("resources\music.mid", @TempDir & "\")

$Tab = GUICtrlCreateTab(5, 80, 390, 227)

;==============================第一分页==============================
$Tab_1 = GUICtrlCreateTabItem("说明")
GUICtrlCreateGroup("", 15, 100, 370, 200)
GUICtrlCreateLabel("    欢迎使用万能GHOST!" & Chr(13) & Chr(13) & "    一键备份：系统将会自动重启进入DOS运行ghost备份C盘到d:\ghost\windows.gho，备份完后自动重启，正常进入桌面。" & Chr(13) & "    一键恢复：系统将会自动重启进入DOS运行ghost恢复C盘从d:\ghost\windows.gho，恢复完后自动重启，正常进入桌面。" & Chr(13) & Chr(13) & "    手工操作：手工操作提供更自由的选项,备份/恢复更自由!" & Chr(13) & Chr(13) & "    本程序支持FAT32、NTFS分区、双硬盘!", 35, 115, 345, 120)
$Cancel = GUICtrlCreateButton("撤销请求", 50, 250, 300, 30)
$YJBF = GUICtrlCreateButton("一键备份", 25, 250, 100, 30)
$YJHF = GUICtrlCreateButton("一键恢复", 150, 250, 100, 30)
$DOS = GUICtrlCreateButton("GHOST手工操作", 275, 250, 100, 30)

;==============================第二分页==============================
$Tab_2 = GUICtrlCreateTabItem("备份")

GUICtrlCreateGroup("备份分区：", 20, 110, 130, 50)
$Tab_2_Combo_1 = GUICtrlCreateCombo("", 85, 105, 50, 20, $CBS_DROPDOWNLIST)
$Disk = DriveGetDrive("FIXED")
If Not @error Then
	For $Var = 1 To $Disk[0]
		GUICtrlSetData($Tab_2_Combo_1, $Disk[$Var], "c:")
	Next
EndIf
$Tab_2_Combo_1_Disk = GUICtrlRead($Tab_2_Combo_1)
$Tab_2_Label_1 = GUICtrlCreateLabel("C盘已用空间:" & Round((DriveSpaceTotal("c:") - DriveSpaceFree("c:")) / 1024, 2) & "G", 30, 130, 120, 20)
$Tab_2_Label_2 = GUICtrlCreateLabel("D盘可用空间:" & Round(DriveSpaceFree("d:\") / 1024, 2) & "G", 30, 145, 120, 20)

GUICtrlCreateGroup("备份选项：", 165, 110, 120, 50)
$Tab_2_Combo_2 = GUICtrlCreateCombo("", 175, 130, 100, 17, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "不压缩  |快速压缩|高压缩  |最高压缩", "快速压缩")

GUICtrlCreateGroup("GHO文件路径：", 20, 165, 350, 45)
If DriveSpaceFree('d:') <> 0 Then
	$Tab_2_Input_1 = GUICtrlCreateInput('D:\ghost\WIN' & StringRight(@YEAR, 2) & @MON & @MDAY & '.GHO', 30, 185, 250, 17)
Else
	$Tab_2_Input_1 = GUICtrlCreateInput('', 30, 185, 250, 17)
EndIf
$Tab_2_Button_1 = GUICtrlCreateButton("选择", 290, 185, 50, 20)
$Tab_2_Input_1_Info = GUICtrlRead($Tab_2_Input_1)
GUICtrlCreateGroup("高级选项：", 25, 215, 335, 55)
$Tab_2_Checkbox_1 = GUICtrlCreateCheckbox("自定义GHOST核心", 130, 225, 110, 17)
$Tab_2_Checkbox_2 = GUICtrlCreateCheckbox("隐藏GHO文件", 255, 225, 90, 17)
$Tab_2_Input_2 = GUICtrlCreateInput("", 35, 245, 250, 17)
$Tab_2_Input_2_Info = GUICtrlRead($Tab_2_Input_2)
GUICtrlSetState($Tab_2_Input_2, $GUI_HIDE)
$Tab_2_Button_2 = GUICtrlCreateButton("选择", 300, 243, 50, 20)
GUICtrlSetState($Tab_2_Button_2, $GUI_HIDE)

FileInstall("resources\bf.gif", @TempDir & "\")
GUICtrlCreatePic(@TempDir & "\bf.gif", 300, 115, 0, 0)
FileDelete(@TempDir & "\bf.gif")

$Tab_2_Button_3 = GUICtrlCreateButton("确定", 50, 278, 300, 22)

;==============================第三分页==============================
$Tab_3 = GUICtrlCreateTabItem("恢复")

GUICtrlCreateGroup("恢复分区：", 20, 110, 130, 50)
$Tab_3_Combo_1 = GUICtrlCreateCombo("", 85, 105, 50, 20, $CBS_DROPDOWNLIST)
$Disk = DriveGetDrive("FIXED")
If Not @error Then
	For $Var = 1 To $Disk[0]
		GUICtrlSetData(-1, $Disk[$Var], "c:")
	Next
EndIf
$Tab_3_Combo_1_Disk = GUICtrlRead($Tab_3_Combo_1)
$Tab_3_Label_1 = GUICtrlCreateLabel("C盘全部空间:" & Round(DriveSpaceTotal("c:") / 1024, 2) & "G", 30, 130, 120, 20)
$Tab_3_Label_2 = GUICtrlCreateLabel('', 30, 145, 120, 20)

GUICtrlCreateGroup("GHO文件路径：", 20, 165, 350, 45)
$Tab_3_Input_1 = GUICtrlCreateInput("", 30, 185, 250, 17)
$Tab_3_Input_1_Info = GUICtrlRead($Tab_3_Input_1)
$Tab_3_Button_1 = GUICtrlCreateButton("选择", 290, 185, 50, 20)

GUICtrlCreateGroup("高级选项：", 25, 215, 335, 55)
$Tab_3_Checkbox_1 = GUICtrlCreateCheckbox("自定义GHOST核心", 130, 225, 110, 17)
$Tab_3_Checkbox_2 = GUICtrlCreateCheckbox("忽略 CRC 错误", 255, 225, 95, 17)
$Tab_3_Input_2 = GUICtrlCreateInput("", 35, 245, 250, 17)
GUICtrlSetState($Tab_3_Input_2, $GUI_HIDE)
$Tab_3_Button_2 = GUICtrlCreateButton("选择", 300, 243, 50, 20)
GUICtrlSetState($Tab_3_Button_2, $GUI_HIDE)

FileInstall("resources\hf.gif", "c:\")
GUICtrlCreatePic("c:\hf.gif", 300, 115, 0, 0)
FileDelete("c:\hf.gif")

$Tab_3_Button_3 = GUICtrlCreateButton("确定", 50, 278, 300, 22)
GUICtrlSetState(-1, $GUI_DISABLE)

;==============================第四分页==============================
$Tab_4 = GUICtrlCreateTabItem("关于")
GUICtrlCreateGroup("", 15, 100, 370, 200)
GUICtrlCreateGroup("", 110, 130, 200, 140)
$ColorEgg2 = GUICtrlCreateLabel("软件名称：万能GHOST", 120, 150,120, 20)
GUICtrlSetCursor(-1, 0)
GUICtrlSetColor(-1, 0x008080)
GUICtrlCreateLabel("程序制作：JS", 120, 170, 93, 20)
GUICtrlCreateLabel("完成日期：2009年1月22日", 120, 190, 140, 20)
GUICtrlCreateLabel("内置GHOST版本：V11.5.0.2113", 120, 210, 180, 20)
$mailto = GUICtrlCreateLabel("Email：297259024@qq.com", 120, 230, 138, 20)
GUICtrlSetCursor(-1, 0)
GUICtrlSetColor(-1, 0x0000FF)
GUICtrlCreateLabel("鸣谢：DONGHAI、YlmF、Skyfree", 120, 250, 200, 13)
GUICtrlSetColor(-1, 0xFF0000)

GUICtrlCreateTabItem("") ;==>结束分页标志

If FileExists("c:\jsgh") = 1 Then
	GUICtrlSetState($YJBF, $GUI_HIDE)
	GUICtrlSetState($YJHF, $GUI_HIDE)
	GUICtrlSetState($DOS, $GUI_HIDE)
	GUICtrlSetState($Tab_2_Button_3, $GUI_HIDE)
	GUICtrlSetState($Tab_3_Button_3, $GUI_HIDE)
	GUICtrlSetState($Cancel, $GUI_SHOW)
Else
	GUICtrlSetState($Cancel, $GUI_HIDE)
EndIf

$SpaceFree = Round(DriveSpaceFree("D:\") / 1, 3)
GUICtrlCreateLabel("D盘可用空间:" & $SpaceFree & "M", 250, 315, 150, 17)

GUISetState(@SW_SHOW)


While 1
	
	If $Tab_2_Input_1_Info <> GUICtrlRead($Tab_2_Input_1) Then
		$Tab_2_Input_1_Info = GUICtrlRead($Tab_2_Input_1)
		GUICtrlSetState($Tab_2_Button_3, $GUI_DISABLE)
		If DriveSpaceFree(StringLeft(GUICtrlRead($Tab_2_Input_1), 2)) <> 0 Then
			GUICtrlSetData($Tab_2_Label_2, StringUpper(StringLeft(GUICtrlRead($Tab_2_Input_1), 1)) & "盘可用空间:" & Round(DriveSpaceFree(StringLeft(GUICtrlRead($Tab_2_Input_1), 2)) / 1024, 2) & "G")
			If StringRight(GUICtrlRead($Tab_2_Input_1), 4) = ".GHO" Then GUICtrlSetState($Tab_2_Button_3, $GUI_ENABLE)
		EndIf
	EndIf
	If $Tab_3_Input_1_Info <> GUICtrlRead($Tab_3_Input_1) Then
		$Tab_3_Input_1_Info = GUICtrlRead($Tab_3_Input_1)
		GUICtrlSetState($Tab_3_Button_3, $GUI_DISABLE)
		GUICtrlSetData($Tab_3_Label_2, '')
		If StringRight(GUICtrlRead($Tab_3_Input_1), 4) = ".GHO" Then
			If FileGetSize(GUICtrlRead($Tab_3_Input_1)) <> 0 Then
				GUICtrlSetData($Tab_3_Label_2, '文件大小:' & Round(FileGetSize(GUICtrlRead($Tab_3_Input_1)) / 1048576, 2) & "M")
				GUICtrlSetState($Tab_3_Button_3, $GUI_ENABLE)
			EndIf
		EndIf
	EndIf
	
	$msg = GUIGetMsg()
	
	Select
		
		
		;========================================第一分页执行命令========================================
		
		Case $msg = $YJBF ;一键备份
			_GHOST("备份", "    此命令将使系统重启并进入DOS用GHOST  " & Chr(13) & "备份C盘到d:\GHOST\windows.gho。D盘格式  " & Chr(13) & "既可以是 FAT32也可以是NTFS。", '-nousb -clone,mode=pdump,src=1:1,dst=1:2\Ghost\windows.gho -z1 -sure -rb ', 1, 1, 1)
		Case $msg = $YJHF ;一键恢复
			_GHOST("恢复", "    此命令将使系统重启并进入DOS用GHOST  " & Chr(13) & "恢复C盘从d:\GHOST\windows.gho。" & Chr(13) & "    此命令将会把您放在C盘的数据清空!!!", '-nousb -clone,mode=pload,src=1:2\Ghost\windows.gho:1,dst=1:1 -sure -rb ', 1, 1, 1)
		Case $msg = $DOS ;GHOST手工操作
			_GHOST("进入DOS GHOST手工操作", "    此命令将使系统重启并进入DOS启动GHOST  " & Chr(13) & "进行手工操作。", "", 1, 1, 1)
			
		Case $msg = $Cancel ;GHOST手工操作
			FileSetAttrib("C:\boot.ini", "-RSH")
			FileCopy("c:\JS\boot.bak", "c:\boot.ini", 9)
			FileSetAttrib("C:\boot.ini", "+RSH")
			If FileExists ( "c:\JS\menu.bak" )=1 Then  FileCopy("c:\JS\menu.bak", "C:\menu.lst", 9)
			FileSetAttrib("C:\jsgh", "-RSH")
			FileDelete("c:\jsgh")
			DirRemove("c:\JS", 1)
			GUICtrlSetState($Cancel, $GUI_HIDE)
			GUICtrlSetState($YJBF, $GUI_SHOW)
			GUICtrlSetState($YJHF, $GUI_SHOW)
			GUICtrlSetState($DOS, $GUI_SHOW)
			GUICtrlSetState($Tab_2_Button_3, $GUI_SHOW)
			GUICtrlSetState($Tab_3_Button_3, $GUI_SHOW)
			MsgBox(64, "万能GHOT备份恢复", "撤销完成! ")
			
			
			;========================================第二分页执行命令========================================

		Case $msg = $Tab_2_Combo_1 ;选择备份磁盘
			If GUICtrlRead($Tab_2_Combo_1) <> StringLeft(GUICtrlRead($Tab_2_Input_1), 2) Then
				GUICtrlSetData($Tab_2_Label_1, StringUpper(StringLeft(GUICtrlRead($Tab_2_Combo_1), 1)) & "盘已用空间:" & Round((DriveSpaceTotal(GUICtrlRead($Tab_2_Combo_1)) - DriveSpaceFree(GUICtrlRead($Tab_2_Combo_1))) / 1024, 2) & "G")
				$Tab_2_Combo_1_Disk = GUICtrlRead($Tab_2_Combo_1)
			Else
				GUICtrlSetData($Tab_2_Combo_1, $Tab_2_Combo_1_Disk, $Tab_2_Combo_1_Disk)
				MsgBox(48, '万能GHOT备份恢复', '您选择需要备份的分区与保存 Ghost 镜像文件' & Chr(13) & '所在分区相同! 请重新选择需要备份的分区。')
			EndIf
			
		Case $msg = $Tab_2_Button_1 ;手工选择备份文件位置
			$Tab_2_Path = FileSaveDialog("选择GHO映像文件", @ScriptDir, "GHO映像文件(*.gho)", 18, "")
			If StringRight($Tab_2_Path, 4) = ".gho" Then
				GUICtrlSetData($Tab_2_Input_1, $Tab_2_Path)
				GUICtrlSetData($Tab_2_Label_2, StringLeft(GUICtrlRead($Tab_2_Input_1), 2) & "可用空间:" & Round(DriveSpaceFree(StringLeft(GUICtrlRead($Tab_2_Input_1), 2)) / 1024, 2) & "G")
			EndIf
			
		Case $msg = $Tab_2_Checkbox_1 ;自定义GHOST程序开关
			If GUICtrlRead($Tab_2_Checkbox_1) = $GUI_CHECKED Then ;自定义GHOST程序
				GUICtrlSetState($Tab_2_Input_2, $GUI_SHOW)
				GUICtrlSetState($Tab_2_Button_2, $GUI_SHOW)
			ElseIf GUICtrlRead($Tab_2_Checkbox_1) = $GUI_UNCHECKED Then ;不自定义GHOST程序
				GUICtrlSetState($Tab_2_Input_2, $GUI_HIDE)
				GUICtrlSetState($Tab_2_Button_2, $GUI_HIDE)
			EndIf
		Case $msg = $Tab_2_Button_2 ;手工选择GHOST文件位置
			$Tab_2_GHOST_Path = FileOpenDialog("选择GHOST程序", @ScriptDir, "EXE可执行文件(*.exe)", 3, "ghost.exe")
			If StringRight($Tab_2_GHOST_Path, 4) = ".exe" Then GUICtrlSetData($Tab_2_Input_2, $Tab_2_GHOST_Path)
			
			;==============================自定义备份==============================
		Case $msg = $Tab_2_Button_3
			SplashTextOn("请稍候", Chr(13) & "正在准备……", 250, 50, 10, 10, 2, 10)
			
			FileInstall("resources\disk.exe", @TempDir & "\") ;读取扇区信息
			Run(@ComSpec & ' /c "' & @TempDir & '\disk.exe"', "", @SW_HIDE)
			WinWaitActive("分区扇区对应", "")
			$BFDisk = StringSplit(ControlGetText("分区扇区对应", "", "ThunderRT6TextBox1"), Chr(13))
			ProcessClose("DISK.exe")
			FileDelete(@TempDir & "\DISK.exe")
			
			For $Var = 1 To $BFDisk[0] Step 1 ;读取扇区信息
				If StringInStr($BFDisk[$Var], StringLeft(GUICtrlRead($Tab_2_Combo_1), 1), 0) <> 0 Then
					$Tab_2_Sector = 'src=' & StringMid($BFDisk[$Var], 12)
				EndIf
			Next
			
			For $Var = 1 To $BFDisk[0] Step 1 ;读取备份位置
				If StringInStr($BFDisk[$Var], StringLeft(GUICtrlRead($Tab_2_Input_1), 1), 0) <> 0 Then
					$Tab_2_Path = 'dst=' & StringMid($BFDisk[$Var], 13) & StringMid(GUICtrlRead($Tab_2_Input_1), 3)
				EndIf
			Next
			
			If GUICtrlRead($Tab_2_Combo_2) = "不压缩  " Then ;读取压缩率
				$Tab_2_Compress = " "
			ElseIf GUICtrlRead($Tab_2_Combo_2) = "快速压缩" Then
				$Tab_2_Compress = " -z1"
			ElseIf GUICtrlRead($Tab_2_Combo_2) = "高压缩  " Then
				$Tab_2_Compress = " -z2"
			ElseIf GUICtrlRead($Tab_2_Combo_2) = "最高压缩" Then
				$Tab_2_Compress = " -z9"
			EndIf


			If GUICtrlRead($Tab_2_Checkbox_2) = $GUI_CHECKED Then ;是否隐藏
				$Tab_2_File_Hide = "attrib +h " & GUICtrlRead($Tab_2_Input_1)
			Else
				$Tab_2_File_Hide = ""
			EndIf
			
			_GHOST("备份", "", "Ghost.exe -nousb -clone,mode=pdump," & $Tab_2_Sector & "," & $Tab_2_Path & $Tab_2_Compress & " -sure -rb" & @CRLF & $Tab_2_File_Hide & @CRLF, 0, 1, 1)
			
			If GUICtrlRead($Tab_2_Checkbox_1) = $GUI_CHECKED Then ;是否使用自定义GHOST程序
				$Tab_2_Button_3Var1 = GUICtrlRead($Tab_2_Input_2)
				If FileExists($Tab_2_Button_3Var1) = 1 Then FileCopy($Tab_2_Button_3Var1, "c:\JS\GHOST.EXE", 9)
			EndIf
			
			
			;========================================第三分页执行命令========================================
			
		Case $msg = $Tab_3_Combo_1 ;选择恢复磁盘
			If GUICtrlRead($Tab_3_Combo_1) <> StringLeft(GUICtrlRead($Tab_3_Input_1), 2) Then
				GUICtrlSetData($Tab_3_Label_1, StringUpper(StringLeft(GUICtrlRead($Tab_3_Combo_1), 1)) & "盘全部空间:" & Round(DriveSpaceTotal(GUICtrlRead($Tab_3_Combo_1)) / 1024, 2) & "G")
				$Tab_3_Combo_1_Disk = GUICtrlRead($Tab_3_Combo_1)
			Else
				GUICtrlSetData($Tab_3_Combo_1, $Tab_3_Combo_1_Disk, $Tab_3_Combo_1_Disk)
				MsgBox(48, '万能GHOT备份恢复', '您选择 Ghost 镜像文件所在分区与需要还原的' & Chr(13) & '分区相同! 请重新选择 Ghost 镜像文件。')
			EndIf

		Case $msg = $Tab_3_Button_1 ;手工选择恢复文件位置
			$Tab_3_Path = FileOpenDialog("选择GHO映像文件", @ScriptDir, "GHO映像文件(*.gho)|所有文件(*.*)", 3, "windows.gho")
			GUICtrlSetData($Tab_3_Label_2, '')
			If StringRight($Tab_3_Path, 4) = ".GHO" Then
				If FileGetSize($Tab_3_Path) <> 0 Then
					GUICtrlSetData($Tab_3_Input_1, $Tab_3_Path)
					GUICtrlSetData($Tab_3_Label_2, '文件大小:' & Round(FileGetSize(GUICtrlRead($Tab_3_Input_1)) / 1048576, 2) & "M")
				EndIf
			EndIf

		Case $msg = $Tab_3_Checkbox_1 ;自定义GHOST程序开关
			If GUICtrlRead($Tab_3_Checkbox_1) = $GUI_CHECKED Then ;自定义GHOST程序
				GUICtrlSetState($Tab_3_Input_2, $GUI_SHOW)
				GUICtrlSetState($Tab_3_Button_2, $GUI_SHOW)
			ElseIf GUICtrlRead($Tab_3_Checkbox_1) = $GUI_UNCHECKED Then ;不自定义GHOST程序
				GUICtrlSetState($Tab_3_Input_2, $GUI_HIDE)
				GUICtrlSetState($Tab_3_Button_2, $GUI_HIDE)
			EndIf
		Case $msg = $Tab_3_Button_2 ;手工选择GHOST文件位置
			$Tab_3_GHOST_Path = FileOpenDialog("选择GHOST程序", @ScriptDir, "EXE可执行文件(*.exe)|所有文件(*.*)", 3, "ghost.exe")
			If StringRight($Tab_3_GHOST_Path, 4) = ".exe" Then GUICtrlSetData($Tab_3_Input_2, $Tab_3_GHOST_Path)

			;==============================自定义恢复==============================
		Case $msg = $Tab_3_Button_3
			SplashTextOn("请稍候", Chr(13) & "正在准备……", 250, 50, 10, 10, 2, 10)
			
			FileInstall("resources\disk.exe", @TempDir & "\")
			Run(@ComSpec & ' /c "' & @TempDir & '\disk.exe"', "", @SW_HIDE)
			WinWaitActive("分区扇区对应", "")
			$HFDisk = StringSplit(ControlGetText("分区扇区对应", "", "ThunderRT6TextBox1"), Chr(13))
			ProcessClose("DISK.exe")
			FileDelete(@TempDir & "\DISK.exe")
			
			For $Var = 1 To $HFDisk[0] Step 1 ;读取扇区信息
				If StringInStr($HFDisk[$Var], StringLeft(GUICtrlRead($Tab_3_Combo_1), 1), 0) <> 0 Then
					$Tab_3_Sector = 'dst=' & StringMid($HFDisk[$Var], 12)
				EndIf
			Next
			
			For $Var = 1 To $HFDisk[0] Step 1 ;读取恢复位置
				If StringInStr($HFDisk[$Var], StringLeft(GUICtrlRead($Tab_3_Input_1), 1), 0) <> 0 Then
					$Tab_3_Path = 'src=' & StringMid($HFDisk[$Var], 13) & StringMid(GUICtrlRead($Tab_3_Input_1), 3)
				EndIf
			Next
			
			If GUICtrlRead($Tab_3_Checkbox_2) = $GUI_CHECKED Then ;是否忽略CRC错误
				$Tab_3_Neglect = "-crcignore"
			Else
				$Tab_3_Neglect = ""
			EndIf
			
			_GHOST("恢复", "", "-nousb -clone,mode=pload," & $Tab_3_Path & ":1," & $Tab_3_Sector & " -sure -rb " & $Tab_3_Neglect, 0, 1, 1)
			
			If GUICtrlRead($Tab_3_Checkbox_1) = $GUI_CHECKED Then ;是否使用自定义GHOST程序
				$Tab_3_GHOST_Path = GUICtrlRead($Tab_3_Input_2)
				If FileExists($Tab_3_GHOST_Path) = 1 Then FileCopy($Tab_3_GHOST_Path, "c:\JS\GHOST.EXE", 8)
			EndIf
			
			
			;========================================其他执行命令========================================
			
			;==============================彩蛋开关==============================
		Case $msg = $ColorEgg1
			$ColorEgg = 1
		Case $msg = $ColorEgg2
			If $ColorEgg = 1 Then
				$ColorEgg = 0
				$Music = _SoundOpen(@TempDir & "\music.mid")
				_SoundPlay($Music, 0)
			EndIf
			
		Case $msg = $Tab
			If GUICtrlRead($Tab) <> 3 Then _SoundStop($Music)
		Case $msg = $mailto
			Run(@ComSpec & " /c " & 'start mailto:297259024@qq.com?subject=关于JS万能GHOST', "", @SW_HIDE)
		Case $msg = $GUI_EVENT_CLOSE
			_SoundClose($Music)
			FileDelete(@TempDir & "\music.mid")
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $GUI, "int", 100, "long", 0x00090000)
			Exit
	EndSelect
WEnd

Func _Tab_2_Input_1()

EndFunc   ;==>_Tab_2_Input_1

Func _Tab_3_Input_1()

EndFunc   ;==>_Tab_3_Input_1



Func _GHOST($Purpose, $Explain, $CmdLine, $Msbox_1, $Msbox_2, $Button)
	If $Msbox_1 = 1 Then
		$GHCon = MsgBox(262433, '万能GHOT备份恢复', $Explain)
	Else
		$GHCon = 1
	EndIf
	
	If $GHCon = 1 Then
		SplashTextOn("万能GHOT备份恢复", Chr(13) & "正在准备……", 250, 50, 10, 10, 2, 10)
		;==============================设置引导==============================
		DirCreate("c:\JS\")
		FileSetAttrib("C:\boot.ini", "-RSH")
		FileCopy("C:\boot.ini", "c:\JS\boot.bak", 8)
		IniWrite("c:\boot.ini", "boot loader", "timeout", "1")
		IniWrite("c:\boot.ini", "boot loader", "default", "c:\jsgh")
		IniWrite("c:\boot.ini", "operating systems", "c:\jsgh", "JS万能GHOST")
		If FileExists ( "C:\menu.lst" )=1 Then  
		FileCopy("C:\menu.lst", "c:\JS\menu.bak", 8)
		FileSetAttrib("C:\menu.lst", "-RSH")
		FileDelete ( "C:\menu.lst" )
		EndIf
		FileInstall("resources\JSGH", "c:\")
		FileInstall("resources\JSGH.img", "c:\JS\")
		FileInstall("resources\Ghost.exe", "c:\JS\")
		;==============================设置批处理==============================
		$BFGhostIni = FileOpen("c:\js\ghost.bat", 10)
		FileWrite($BFGhostIni, '' & @CRLF & '@echo off' & @CRLF)
		FileWrite($BFGhostIni, 'attrib -r -s -h "' & $PagingFilesPath & '">nul' & @CRLF & 'Del "' & $PagingFilesPath & '">nul' & @CRLF)
		FileWrite($BFGhostIni, 'xmsman -c>nul' & @CRLF)
		FileWrite($BFGhostIni, 'attrib -r -s -h "c:\boot.ini">nul' & @CRLF & 'copy "c:\JS\boot.bak" "c:\boot.ini">nul' & @CRLF & 'attrib +r +s +h "c:\boot.ini">nul' & @CRLF)
		FileWrite($BFGhostIni, 'Ghost.exe ' & $CmdLine & @CRLF)
		FileWrite($BFGhostIni, 'restart')
		FileClose($BFGhostIni)
		DirCreate("d:\Ghost\")
		FileInstall("resources\Ghost.exe", "d:\Ghost\Ghost.exe")
		Sleep(500)
		
		If $Msbox_2 = 1 Then
			$ShutCon = MsgBox(36, '万能GHOT备份恢复', $Purpose & '前的准备已完成，要立即重启吗?')
		Else
			$ShutCon = 0
		EndIf

		If $Button = 1 Then
			GUICtrlSetState($YJBF, $GUI_HIDE)
			GUICtrlSetState($YJHF, $GUI_HIDE)
			GUICtrlSetState($DOS, $GUI_HIDE)
			GUICtrlSetState($Cancel, $GUI_SHOW)
			GUICtrlSetState($Tab_2_Button_3, $GUI_HIDE)
			GUICtrlSetState($Tab_3_Button_3, $GUI_HIDE)
		EndIf

		SplashOff()
		If $ShutCon = 6 Then
			SplashTextOn("万能GHOT备份恢复", Chr(13) & "正在重启……", 250, 50, 10, 10, 2, 10)
			Shutdown(6)
		EndIf
	EndIf
EndFunc   ;==>_GHOST