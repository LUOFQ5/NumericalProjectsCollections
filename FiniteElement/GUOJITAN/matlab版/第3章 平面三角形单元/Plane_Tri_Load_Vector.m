

function ZQ= Plane_Tri_Load_Vector
%����ƽ��������������ĵ�Ч����غɣ�����װ�����غ�������
%��������ʽ�������������������ȵ���������㼯���������Էֲ��ķ�������б��������
%�����������غ�����ZQ
global  t0  lou  nd  ne  nj   nt  XY  EL  TL QJ
%ȫ�ֱ����� t0,lou --��ȡ��ܶȣ� nd ne ng nj nt--�����,��Ԫ��,Լ������,����������,����������
%  XY��EL��TL��QJ--���飺 �ڵ����ꡢ��Ԫ��Ϣ������������ֵ����������Ϣ
global  mx md QMD QMX
%   ���������ģ��������߶������н��������������������ֵ�����ε����˽�㼰��������
ZQ = zeros(2*nd,1 ) ;      % �ṹ�����غ�����

%step1�����������ĵ�Ч����غɣ�����װ���ܵ��غ�������
if lou~=0  |    nt>0                %�ܶȲ�Ϊ0���������ʱ�����������������ĵ�Ч����غ�
    for ie=1:1:ne
        i=EL(ie,1);j=EL(ie,2);m=EL(ie,3);
        xi=XY(i,1);xj=XY(j,1);xm=XY(m,1);
        yi=XY(i,2);yj=XY(j,2);ym= XY(m,2);
        A = (xi*(yj-ym) + xj*(ym-yi) + xm*(yi-yj))/2;
        if lou~=0                               %��������
            qy = - A*t0*lou/3;
            for s=1:1:3
                i0= 2*EL(ie,s);
                ZQ(i0,1) = ZQ(i0,1) + qy;
            end
        end
        if  nt>0                                %��������
            it0=EL(ie,4);
            Qx=TL(it0,:)*A*t0/3;
            for s=1:1:3
                i0= 2*EL(ie,s);
                ZQ(i0-1,1) = ZQ(i0-1,1) +  Qx(1);
                ZQ(i0,1) = ZQ(i0,1) +  Qx(2);
            end
        end
    end
end

% step2������㼯������װ���ܵ��غ�������
if nj>0
    for s=1:1:nj
        i0=2*QJ(s,1);
        ZQ(i0-1,1) = ZQ(i0-1,1) + QJ(s,2);
        ZQ(i0,1) = ZQ(i0,1) + QJ(s,3);
    end
end
% step3���������Էֲ�ѹ���ĵ�Ч����غɣ�����װ���ܵ��غ�������
if  mx>0
    mx1=0;mx2=0;mx3=0;
    index = (QMX(:,3) ==1);         %���������࣬�з����������õı߽�
    if  ~isnan(index)
        QMX1=QMX(index,:);
        [mx1,m0]=size(QMX1);              %�����������ñ߽������
        row_index =( QMD(:,2) ==1);          %���������Ľ��
        if ~isnan(row_index)
            QMD1=QMD(row_index,:);
            [md1,m0]=size(QMD1);               %�з�������ֵ�Ľ������
        else
            disp('�������ݴ��ڴ���ȱ�ٷ��������Ľ��ֵ')
        end
    end
    index = (QMX(:,3) ==2);              %�������������õı߽�
    if  ~isnan(index)
        QMX2=QMX(index,:);
        [mx2,m0]=size(QMX2);               %�����������ñ߽������
        row_index =( QMD(:,2) ==2);             %��������
        if ~isnan(row_index)
            QMD2=QMD(row_index,:);
            [md2,m0]=size(QMD2);               %����������ֵ�Ľ������
        else
            disp('�������ݴ��ڴ���ȱ�����������Ľ��ֵ')
        end
    end
    
    index = (QMX(:,3) ==3);               %���������������ʾ��б������
    if  ~isnan(index)
        QMX3=QMX(index,:);
        [mx3,m0]=size(QMX3);               %���������������ʾб������������
        row_index =( QMD(:,2) ==3);           %�����������ʾ��б������
        if ~isnan(row_index)
            QMD3=QMD(row_index,:);
            [md3,m0]=size(QMD3);          %��б����������������ֵ�Ľ������
        else
            disp('�������ݴ��ڴ���ȱ��������������ʾ�Ľ��ֵ')
        end
    end
    
    if  mx1>0
        for s=1:1:mx1
            i1=QMX1(s,1);i2= QMX1(s,2);
            [Q1,Q2]=Equivalent_Nodal_Force_Surface(i1,i2,md1,QMD1,1);
            ZQ([2*i1-1,2*i1],1) =  ZQ([2*i1-1,2*i1],1) + Q1;
            ZQ([2*i2-1,2*i2],1) =  ZQ([2*i2-1,2*i2],1) + Q2;
        end
    end
    
    if  mx2>0
        for s=1:1:mx2
            i1=QMX2(s,1);i2= QMX2(s,2);
            [Q1,Q2]=Equivalent_Nodal_Force_Surface(i1,i2,md2,QMD2,2);
            ZQ([2*i1-1,2*i1],1) =  ZQ([2*i1-1,2*i1],1) + Q1;
            ZQ([2*i2-1,2*i2],1) =  ZQ([2*i2-1,2*i2],1) + Q2;
        end
    end
    
    if  mx3>0                   % nx3----��б�����Էֲ����������߶θ���
        for s=1:1:mx3
            i1=QMX3(s,1);i2= QMX3(s,2);
            [Q1,Q2]=Equivalent_Nodal_Force_Surface(i1,i2,md3,QMD3,3);
            ZQ([2*i1-1,2*i1],1) =  ZQ([2*i1-1,2*i1],1) + Q1;
            ZQ([2*i2-1,2*i2],1) =  ZQ([2*i2-1,2*i2],1) + Q2;
        end
    end
end
return


