

 	function  Sig12 = Main_Strees(a1,a2,a3) 
 	%������Ӧ����MisesӦ��
 	%��������3��Ӧ������---sigmx��sigmy��tauxy
 	%���������һ��Ӧ�����ڶ���Ӧ����MisesӦ��
 	   b=sqrt((a1- a2)^2 + 4* a3^2 )/2;  
 	   Sig12(1) = (a1+a2)/2+b;                      %��һ��Ӧ��
 	   Sig12(2) = (a1+a2)/2-b;                        %�ڶ���Ӧ��
 	   Sig12(3) = sqrt(a1^2 + a2^2 -a1*a2 +3*a3^2);    % MisesӦ����
 	  return










