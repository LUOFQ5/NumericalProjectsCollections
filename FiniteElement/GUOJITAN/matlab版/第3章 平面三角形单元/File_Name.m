

 
	function [file_in , file_out] = File_Name
	  %�����ļ���������ԭʼ�����ļ�·�����ļ���������ͬ·�����Զ����ɻ����ж�������ļ���
	  %��鵽�Զ����ɵ�����ļ����Ѵ��ڣ������Ѹ��ǻ��½��ļ�����Ҳ���޸��ļ�·����
	  [filename, path_str] = uigetfile( '../*.xls;*.xlsx;*.txt',' ѡ������Ԫģ�������ļ�')
    [s,name_str,ext_str] = fileparts( filename );
	    file_in =fullfile( path_str, filename ) ;
	    ext_str_out = '.txt' ; 
	  file_out = fullfile( path_str, [name_str, ext_str_out] )     
	      % �������ļ��Ƿ����
   while  exist( file_out ) ~= 0 
	      ss=strcat('�Ᵽ����������ļ�����',file_out,' �Ѵ��ڣ��Ƿ񸲸ǣ�');
       button=questdlg(ss,'�Ƿ񸲸������ļ���','����','�½�','�½�');
     if button == '�½�'
	          [name_str,path_str]=uiputfile( '../*.txt',' ��������Ԫ�������ļ���')
        file_out = fullfile( path_str,name_str )
     elseif button == '����'
        return
    end 
 end
return
