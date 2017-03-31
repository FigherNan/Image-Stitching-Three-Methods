function [ match_pt1,match_pt2 ] = harris_match( I1_gray,I2_gray,I1_Harris,I2_Harris,I1_cnt,I2_cnt) 
%   ���룺 I1_gray��ͼƬI1��
%           I2_gray��ͼƬI2��
%           I1_Harris��ͼƬI1�Ľǵ����
%           I2_Harris��ͼƬI2�Ľǵ����
%           I1_cnt��I1�Ľǵ�����
%           I2_cnt��I2�Ľǵ�����
%           
%	����� match_pt1��I1��ƥ��ǵ��x,y��
%           match_pt2��I2��ƥ��ǵ��x,y��
%
%	���ܣ�ƥ��I1��I2�Ľǵ�
%

%ȡ��harris�ǵ�
[r1,c1]=find(I1_Harris==1);  
[r2,c2]=find(I2_Harris==1);  
point1=[r1 c1];  
point2=[r2 c2];
temp_point2=zeros(size(point1));  

%����ncc����
ncc=zeros(I1_cnt,I2_cnt); 

k=5;  

%����߽�
I1_extend = pic_extend(I1_gray,k);  
I2_extend = pic_extend(I2_gray,k);  
  
%����
for i=1:I1_cnt  
    p = point1(i,1)+k;
    q = point1(i,2)+k;  
    
    %����I1�ǵ���Χ11*11�Ĵ�
    windows1 = I1_extend(p-5:p+5,q-5:q+5);   
    for j=1:I2_cnt  
        m = point2(j,1)+k;
        n = point2(j,2)+k;   
        
         %����I2�ǵ���Χ11*11�Ĵ�
        windows2 = I2_extend(m-5:m+5,n-5:n+5);
        
        %�����һ������������ƶ�
        ncc(i,j) = ncc_caculate(windows1,windows2); 
        
    end     
    
    % ncc_max��ÿһ�е����ֵ
    ncc_max=max(ncc(i,:));   
    [r,c]=find(ncc(i,:)==ncc_max); 
    ncc(ncc==ncc_max)=0;  
    ncc_now=max(ncc(i,:));
    
    % ncc_max��ÿһ�е����ֵ
    threshold=double(ncc_now/ncc_max); 
    
    if threshold<0.8 
      % ��С��0.8��ƥ��
      temp_point2(i,:)=point2(c,:);    
    else  
      % �����Ϊ0
      temp_point2(i,:)=0;  
    end;         
end;  

% ƥ���ܵ���
cnt_match=numel(temp_point2,temp_point2~=0)/2;  

% ����ƥ�����
match_pt1=zeros(cnt_match,2);  
match_pt2=zeros(cnt_match,2);  
j=1;  

% �洢ƥ����
for i=1:I1_cnt  
    if((temp_point2(i,1)~=0)&&(point1(i,1)~=0))  
        match_pt2(j,:)=temp_point2(i,:);          
        match_pt1(j,:)=point1(i,:);  
        j=j+1;      
    end;  
end;  
end  