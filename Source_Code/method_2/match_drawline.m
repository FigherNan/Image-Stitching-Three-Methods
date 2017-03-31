function match_drawline( I1, match_pt1, I2, match_pt2 )  
%   ���룺 ͼƬI1��I1�е�ƥ���match_pt1
%          ͼƬI2��I2�е�ƥ���match_pt2  
%	����� �ǵ㴢������Result���ǵ���cnt
%
%	���ܣ����� ͼƬI1�Ľǵ�ͽǵ���
%
 
    [x1, y1]=size(I1);  
    [x2, y2]=size(I2);  
    x = max(x1,x2);  
    Img = zeros(x,y1+y2);  
    Img(1:x1,1:y1)=I1;  
    Img(1:x2,y1+1:y2+y1)=I2;  
    figure;imshow(uint8(Img));  
    for n=1:length(match_pt1)  
        hold on;  
        plot(match_pt1(n,2),match_pt1(n,1),'r+');  
        plot(y1+match_pt2(n,2),match_pt2(n,1),'r+');  
        S=[match_pt1(n,2),y1+match_pt2(n,2)];  
        T=[match_pt1(n,1),match_pt2(n,1)];  
        line(S,T);  
    end  
    title( '�ǵ�ƥ��');
    legend( 'Matched points 1','Matched points 2');
    hold off;  
end  