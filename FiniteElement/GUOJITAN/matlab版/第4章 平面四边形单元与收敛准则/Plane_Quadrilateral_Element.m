

function  Plane_Quadrilateral_Element
% ������Ϊ�����ĵ�Ȳ�Ԫ���ƽ�����⣬���������ص������������������Էֲ����������µı��κ�Ӧ������������洢���ļ���
%�������洢�ڣ� sddcy_RES.txt
% ����5�����ܺ���������Ԫģ�����ݡ�����ṹ�ܸա��غ��������������Ԫ���̡�����Ӧ��
%  [file_in,file_out] = File_Name ;  %�����ļ���������������ļ���
file_out='Q4dengcanyuan_RES.txt'
Plane_Quad4_Model;              % ��������Ԫģ�����ݲ�ͼ����ʾ
%    Plane_Q4_Modle_Figure;                 %��ʾ����Ԫģ��ͼ�Σ��Ա��ڼ��
ZK= Plane_Quad_4_Stiff_Matrix;            %����ṹ�ܸ�
ZQ= Plane_Quad_4_Load_Matrix;          %�����ܵ��غ�����
U= Solve_1_Model(file_out,2,ZK,ZQ);     %�������Ԫ���̣��õ����λ�ƣ����浽�ļ�������
Stress_nd = Quadrilateral_Strees(file_out, U);        %Ӧ���������������������浽�ļ���
%  Plane_Quad_4_Post_Contour(U,Stress_nd );         %����ģ�飬��ʾ����ͼ����ͬӦ����������ͼ
fclose all;
end












