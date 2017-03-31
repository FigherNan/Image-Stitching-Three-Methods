function [ ncc ] = ncc_caculate(windows1,windows2 )  
%   ���룺 ��(i,j)����������11*11�Ĵ���windows1,windows2
%           
%	����� ��(i,j)�Ĺ�һ������������ƶ�ncc
%
%	���ܣ������һ������������ƶ�
%

    %��ȥƽ��ֵ
    N1=windows1-mean(windows1(:));  
    
    %��ȥƽ��ֵ
    N2=windows2-mean(windows2(:));  
    
    %�������
    M1=sum(sum(N1.*N2));  
    
    %�����ĸ
    M2=sqrt(sum(sum(N1.^2))*sum(sum(N1.^2)));  
    
    %���һ�����ƶ�
    ncc=abs(M1/M2);    
      
end  