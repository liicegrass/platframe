title= ѹ������Delphi����

@ECHO   OFF  

:color ���������,��һλ������ɫ,�ڶ�λ�����ִ���ǰ��ɫ
color 0a

:ɾ��һ�ļ��У��������ļ��У������к�׺��Ϊ ָ������ ���ļ�
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
:ɾ��history�ļ�������ʱ�ļ�
::********** ע�� **********
::���������ļ����Ҳ�ɾ���ļ��м������ļ�
::�г���ǰĿ¼����Ŀ¼�а�����__history�����ļ��У�Ȼ��ɾ����
::dir /s /b /a:d �����оٵ�ǰĿ¼����Ŀ¼����/s Ҳ�о���Ŀ¼��/b ���ر�����Ϣ��ժҪ��/a ֻ�г�ָ�����Ե��ļ���d��ʾ�ļ��С���
::findstr /i "\\__history$" ���г���Ŀ¼���ҳ�ƥ�䡰\__history�����ļ��У���/i �����ִ�Сд��
::for /f "usebackq tokens=1* delims=/" %%a in ...do remdir /s /q %%a ɾ�����ҵ����ļ��С�(/s ɾ����Ŀ¼,/q ����Ҫȷ�ϣ�
::**********
::cd
for /f "usebackq tokens=1* delims=/" %%a in (`dir /s /b /a:d ^| findstr /i "\\__history$"`) do rmdir /s /q "%%a"
