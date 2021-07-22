

 	function Stress_nd = Plane_Tri_Strees(file_out,U)
 	%  ��ԪӦ����������Ӧ����MisesӦ��
 	%  ���������U----�ܵĽ��λ�������� file_out���ַ������洢���������ļ���
 	% ���������Ƶ�ƽ����Ľ��Ӧ����������Ӧ����MisesӦ��
 	 global pm E nv t0  lou nd ne ng nj    XY EL    BC  QJ    
 	%ȫ�ֱ��������������Ԫ����������ꡢ��Ԫ��Ϣ �����Ծ��� 
 	     fid=fopen(file_out,'at');                %�򿪲�׷�Ӵ洢Ӧ�����������ļ�   
 	    %���㵥ԪӦ��
 	  Stress = zeros(ne,6);         
 	  AA=zeros(ne,1);              
 	   ES=zeros(3,1);              
 	   De=zeros(6,1);             
 	fprintf(fid,'\n          ��ԪӦ�������� \n') ;  
 	fprintf(fid,'\n Element    sigx        sigy         tau         sig1         sig3         Mises \n'); 
 	  D = Elastic_Matrix (pm, E, nv);
 	 for ie=1:1:ne
 	      for r=1:1:3                               
 	       i0=2* EL(ie,r);r2=2*r;
 	       De([r2-1,r2],1)=U([i0-1,i0],1); 
 	      end
 	
 	   [B, A] =  Plane_B3_Matrix( ie);           
 	   AA(ie,1)=A;
 	   S = D * B ;                                    
 	   ES=S*De  ;                      
 	   Stress(ie,1:3)=ES(1:3,1);                        
 	    Sig12 = Main_Strees(ES(1,1),ES(2,1),ES(3,1)); 
 	     Stress(ie,4:6) = Sig12(1:3);                      
 	   fprintf(fid,[repmat('%5d ', 1, 1) repmat('% 4f ',1,6)],ie, Stress(ie,:));  
 	  fprintf(fid,' \n');  
 	 end  
 	  fprintf(fid,' \n  Ӧ�����ͳ�Ʒ��� \n'); 
 	  s_Max=max(Stress);
 	  fprintf(fid,[repmat('%s ', 1, 1) repmat('% 4f ',1,6)],'���ֵ', s_Max);     %���Ӧ�������������ֵ
 	  fprintf(fid,' \n'); 
 	   s_Min=min(Stress);
 	  fprintf(fid,[repmat('%s ', 1, 1) repmat('% 4f ',1,6)],'��Сֵ', s_Min);     %���Ӧ������������Сֵ
 	  fprintf(fid,' \n'); 
 	 
 	  %�����ƽ���Ӧ�������²��ֿɵ��ú���Node_Stress(Stress��AA)ʵ��
 	fprintf(fid,'\n          �ƽ��Ӧ�������� \n')  ; 
 	fprintf(fid,'Node    sigx        sigy         tau         sig1         sig3         Mises \n'); 
 	 Stress_nd = zeros(nd,6 ) ;           
 	   for  i=1:1:nd                                
 	     Sd = zeros( 1, 3 ) ;                        
 	     A_tol = 0 ;
 	   for ie=1:1:ne
 	     for k=1:1:3
 	        if EL(ie,k) == i                    
 	           Sd = Sd + Stress(ie, 1:3 ) * AA(ie); 
 	           A_tol = A_tol + AA(ie);
 	        end
 	      end
 	    end
 	      Stress_nd(i,1:3) = Sd / A_tol ;             
 	      Sig12 = Main_Strees(Stress_nd(i,1),Stress_nd(i,2),Stress_nd(i,3));
 	      Stress_nd(i,4:6) = Sig12(1:3);                             
 	     fprintf(fid,[repmat('%5i ', 1, 1) repmat('% 4f ',1,6)],i,Stress_nd(i,:));
 	     fprintf(fid,' \n');
 	   end
 	      fprintf(fid,' \n  �Ƶ�ƽ��Ӧ�����ͳ�Ʒ��� \n');
 	     s_Max=max(Stress_nd);
 	  fprintf(fid,[repmat('%s ', 1, 1) repmat('% 4f ',1,6)],'���ֵ', s_Max);     %���Ӧ�������������ֵ
 	  fprintf(fid,' \n'); 
 	  s_Min=min(Stress_nd);
 	  fprintf(fid,[repmat('%s ', 1, 1) repmat('% 4f ',1,6)],'��Сֵ', s_Min);     %���Ӧ������������Сֵ
 	  fprintf(fid,' \n');
 	 
 	fclose all;
 	return









