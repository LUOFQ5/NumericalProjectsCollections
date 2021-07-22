
function ZK= Plane_Tri_Stiff_Matrix
% ����ṹ�ܸնȾ���
%���ú����� ���Ծ�����Plane_Elastic_Matrix,  ���ξ�����Plane_B_Matrix��
%���㵥Ԫ�նȾ�����װΪ�ܸնȾ���
%���������ܸնȾ���ZK(2*nd,2*nd )
global  pm  E  nv  t0  nd  ne  XY  EL
%ȫ�ֱ�������������,����ģ��,���ɱ�,��ȡ����������Ԫ����������ꡢ��Ԫ��Ϣ
ZK = zeros(2*nd,2*nd ) ;            % �ṹ���ܸնȾ���
D = Elastic_Matrix (pm, E, nv);        %���ú����ĵ��Ծ���E-����ģ����nv�����ɱ�
for ie=1:1:ne                                     %�Ե�Ԫѭ��
    [B,A] = Plane_B3_Matrix( ie) ;                    %���ú��������㵥Ԫie�ļ��ξ������
    S = D * B ;                                    %Ӧ������
    KE = t0*A*transpose(S)*B;                         %��Ԫ�նȾ���
    %  ����Ԫ�նȾ���KE���ɵ�����նȾ���ZK
    for r=1:1:3
        i0=2* EL(ie,r);
        m0 = 2*r ;
        for s=1:1:3
            j0=2* EL(ie,s);
            n0 =2*s;
            %����������r��s���Ӧ��2��2���󣬵��ӵ��ܸ���
            ZK([i0-1,i0],[j0-1,j0]) = ZK([i0-1,i0],[j0-1,j0]) + KE([m0-1,m0],[n0-1,n0]) ;
        end
    end
end
return






