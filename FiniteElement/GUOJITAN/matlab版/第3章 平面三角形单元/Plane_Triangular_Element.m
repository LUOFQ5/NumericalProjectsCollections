

function  Plane_Triangular_Element
% ������Ϊ�������������ε�Ԫ���ƽ�����⣬���������ص��������������Լ�
%���Էֲ����������µı��κ�Ӧ������������洢���ļ���
%�������洢�ڣ� sjx_RES.txt
% ����5�����ܺ���������Ԫģ�����ݡ�����ṹ�ܸա��غ��������������Ԫ���̡�����Ӧ��
%   [file_in,file_out] = File_Name      %�����ļ���������������ļ���
file_out='sjx_RES.txt'
Plane_Tri_Model_Data  ;                 %����Ԫģ������
%   Plane_Tri_Modle_Figure;             %��ʾ����Ԫģ��ͼ�Σ��Ա��ڼ��
ZK= Plane_Tri_Stiff_Matrix              %����ṹ�ܸ�
ZQ= Plane_Tri_Load_Vector                %�����ܵ��غ�����
U= Solve_1_Model(file_out,2,ZK,ZQ);     %�������Ԫ���̣��õ����λ�ƣ����浽�ļ�������
Stress_nd=Plane_Tri_Strees(file_out,U);   %Ӧ�������������������浽�ļ����������Ƶ�ƽ��Ӧ��
%    Plane_Tri_Post_Contour(U,Stress_nd );     %����ģ�飬��ʾ����ͼ����ͬӦ����������ͼ
fclose all;
end
