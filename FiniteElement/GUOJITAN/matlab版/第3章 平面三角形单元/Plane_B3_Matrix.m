

function [B, A] =  Plane_B3_Matrix( ie)
%  ���㵥Ԫ���ξ���B�����A
%  �������:ie ----  ��Ԫ��,
%  �����������ξ���B�������ε�Ԫ���A
global  XY  EL       %ȫ�ֱ�����������ꡢ��Ԫ��Ϣ
i=EL(ie,1);j=EL(ie,2);m=EL(ie,3);       %��Ԫ��3�����
bi = XY(j,2) - XY(m,2);
bj = XY(m,2) - XY(i,2);
bm = XY(i,2) - XY(j,2);
ci = XY(m,1) - XY(j,1);
cj = XY(i,1) - XY(m,1);
cm = XY(j,1) - XY(i,1);
A = (bj * cm - bm * cj )/2;            %��Ԫ���
B = [bi  0  bj  0  bm  0 ;               %���ξ���
    0   ci  0  cj  0  cm ;
    ci  bi  cj  bj  cm  bm]/(2*A);
return

