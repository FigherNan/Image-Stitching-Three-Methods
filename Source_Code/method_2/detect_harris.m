function [ result,cnt] = detect_harris( I1,threshold )  
%   ���룺 ͼƬI1��ѡȡ�ǵ����ֵthreshold��һ��ȡ0.01~0.05
%           
%	����� �ǵ㴢������Result���ǵ���cnt
%
%	���ܣ����� ͼƬI1�Ľǵ�ͽǵ���
%


%R=det(M)-k.*tr(M).^2 ���������k=0.04~0.06 ����ȡk=0.04  
[m,n]=size(I1);  
origin_img=I1;  
img_double=double(I1);  
h=[-2 -1 0 1 2];  
%����ͼ������f(x,y)�ڵ�(x,y)�����ݶ�
Ix=filter2(h,img_double);  % x������ݶ�  
Iy=filter2(h',img_double); % y������ݶ�



%��������ؾ���
Ixx=Ix.^2;  
Iyy=Iy.^2;  
Ixy=Ix.*Iy; 

Gauss=fspecial('gaussian',[7 7],2);  %��˹����,���ڴ�С7*7,sigma=2  
Ixx=filter2(Gauss,Ixx);  
Iyy=filter2(Gauss,Iyy);  
Ixy=filter2(Gauss,Ixy);  

%�������M
k=0.06;                 
Mdet=Ixx.*Iyy-Ixy.^2;   
Mtr=Ixx+Iyy;          
R=Mdet-k.*Mtr.^2;  


%�̶���ֵ����R(i, j) > Tʱ�����ж�Ϊ��ѡ�ǵ�
T=threshold*max(R(:));  
result=zeros(m,n);  
  
%�ں�ѡ�ǵ��н��оֲ��Ǽ���ֵ����
cnt=0;  
for i=2:m-1  
    for j=2:n-1  
        %���ڴ�С3*3�ľֲ��Ǽ���ֵ����
       if (R(i, j) > T &&...
           R(i, j) > R(i-1, j-1) && R(i, j) > R(i-1, j) && R(i, j) > R(i-1, j+1) &&...
           R(i, j) > R(i, j-1) &&  R(i, j) > R(i, j+1) &&...
           R(i, j) > R(i+1, j-1) && R(i, j) > R(i+1, j) && R(i, j) > R(i+1, j+1))  
            %result������Ϊ1�ļ�Ϊ�ǵ�
            result(i,j)=1;  
            %ͳ�ƽǵ���
            cnt=cnt+1;  
        end;  
    end;  
end;  

end 