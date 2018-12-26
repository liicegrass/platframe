title= 压缩备份Delphi工程

@ECHO   OFF  

:color 后面的数字,第一位代表背景色,第二位的数字代表前景色
color 0a

:删除一文件夹（包含子文件夹）中所有后缀名为 指定类型 的文件
cd   %pathName% 
del /S *.~* 
del /s *.dof
del /s *.ddp
del /s *.dcu
del /S *.hpp
del /S *.mps
del /S *.mpt
del /S *.bak
del /s *.local
del /s *.identcache
del /s *.skincfg
:删除history文件夹中临时文件
::********** 注释 **********
::用批处理文件查找并删除文件夹及其下文件
::列出当前目录和子目录中包含“__history”的文件夹，然后删除。
::dir /s /b /a:d 用于列举当前目录和子目录。（/s 也列举子目录，/b 隐藏标题信息或摘要，/a 只列出指定属性的文件，d表示文件夹。）
::findstr /i "\\__history$" 在列出的目录中找出匹配“\__history”的文件夹，（/i 不区分大小写）
::for /f "usebackq tokens=1* delims=/" %%a in ...do remdir /s /q %%a 删除所找到的文件夹。(/s 删除子目录,/q 不需要确认）
::**********
::cd
for /f "usebackq tokens=1* delims=/" %%a in (`dir /s /b /a:d ^| findstr /i "\\__history$"`) do rmdir /s /q "%%a"
