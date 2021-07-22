

function [Q1,Q2]=Equivalent_Nodal_Force_Surface(i1,i2,dd,QD,kd)
%�������Էֲ��������߽��϶�����������Ч�غ�
%��������i1,i2�߽�������ţ�dd,QD�������Ľ����������ֵ���ݣ�
% kd�������ʹ��ţ�1��������������2��������������3��������������ʾ������
%����ֵ����������������Ч�غɴ�С��2��������2*1��
global  t0  XY                 %t0��񣬽������
Q1=zeros(2,1); Q2=zeros(2,1);
if kd<3
    qi=0; qj=0;                    %��������������������������
    for t=1:dd                        %dd���������Ľ�����
        if QD(t,1)==i1
            qi= QD(t,3);                 %��ȡ��Ӧ�߶� 1#��������ֵ
        elseif QD(t,1)==i2
            qj= QD(t,3);                %��ȡ��Ӧ�߶� 1#��������ֵ
        end
    end
else
    qi=zeros(2,1); qj=zeros(2,1);         %���������������������������
    for t=1:dd
        if QD(t,1)==i1
            qi(1:2,1)= QD(t,3:4);                % 1#��������������������
        elseif QD(t,1)==i2
            qj(1:2,1)= QD(t,3:4);               % 1#��������������������
        end
    end
end
p1= t0* (2*qi+qj)/6;
p2= t0* (qi+2*qj)/6;
ax=XY(i2,1)-XY(i1,1); ay=XY(i2,2)-XY(i1,2);
switch kd
    case 1                            %��������
        BL=[-ay; ax];
    case 2                            %��������
        BL=[ax; ay];
    case 3                            %б������
        BL=sqrt(ax*ax+ay*ay);
end
Q1= p1*BL;        % 1#���ĵ�Ч�غ�
Q2= p2*BL;        % 2#���ĵ�Ч�غ�
return



