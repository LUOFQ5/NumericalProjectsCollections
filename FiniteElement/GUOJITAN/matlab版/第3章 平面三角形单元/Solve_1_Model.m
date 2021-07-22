

function U= Solve_1_Model(file_out,ndim,ZK,ZQ)
%  �����á�1����������Ԫ���̣��õ��ܵĽ��λ������
% ���������file_out,������ģ���ļ���Ӧ��txt����������ļ���
% ndim-������ά��: ƽ�����⡪2, ��Գ����⡪2 , �ռ����⡪3��
% ZK----�ܸգ� ZQ----���غ�����
%  ����ֵ���ܵĽ��λ������
global  pm  nd ne ng  BC   %ȫ�ֱ���pm���������ԣ�nd�����������ng��Լ��������BC���顪�߽�����
U=zeros(ndim*nd,1);
[n1 n2]=size(BC);
for r=1:1:ng
    i0= ndim *(BC(r,1)-1) + BC(r,2);
    ZK(i0,:) =  0 ;  ZK(:,i0) =  0 ;
    ZK(i0,i0) =  1.0 ;
    ZQ(i0,1)=  0;
    if  n2==3   &  BC(r,3)~=0      % ������λ��Ϊ����ֵ
        ZQ(i0,1)= BC(r,3) ;
    end
end
disp('�����������Ԫ���̣����Ժ�......')
U = ZK\ZQ ;
ty={'ƽ��Ӧ������','ƽ��Ӧ������','��Գ�����','�ռ�����'};
fid=fopen(file_out,'wt');
fprintf(fid,'         ����Ԫ������ \n');
fprintf(fid,' �������ԣ�%s,   ���������%i��   ��Ԫ������%i \n',ty{pm},nd,ne);
fprintf(fid,'    ���λ�Ƽ����� \n') ;               % �趨������ļ�
fprintf(fid,'\n    Node        Ux          Uy     \n') ;
for j=1:1:nd                                  %�����λ�Ƽ������洢���ļ�
    fprintf(fid,'\n %8i%20.6e%20.6e\n',j, U(2*j-1,1),U(2*j,1));       
end
return











