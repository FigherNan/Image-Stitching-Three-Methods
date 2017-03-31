% ����ʱ�����ȴ�transfer_caculate
%                imfreqfilt, imggaussflpf�����������ļ�

% *************************
% image sitching method_1
% *************************

clear all;
clc;

I1=imread('1.jpg');
I2=imread('2.jpg');
I3=imread('3.jpg');
imageSize = size(I1);

% ͨ��cpselectѡȡ��������
movingPoints=[1.552500000000000e+02,1.747500000000000e+02;1.967500000000000e+02,1.722500000000000e+02;2.332500000000000e+02,3.227500000000000e+02;1.702500000000000e+02,3.172500000000000e+02];
fixedPoints=[18.250000000000000,1.757500000000000e+02;62.750000000000000,1.762500000000000e+02;88.749999999999990,3.302500000000000e+02;25.250000000000000,3.302500000000000e+02];
fixedPoints1=[1.842500000000000e+02,1.517499999999999e+02;2.157500000000000e+02,1.522500000000000e+02;2.162500000000000e+02,3.292500000000000e+02;2.802500000000000e+02,3.282500000000000e+02];
movingPoints1=[25.250000000000000,1.207500000000000e+02;60.250000000000000,1.267500000000000e+02;38.750000000000000,3.047500000000000e+02;1.022500000000000e+02,2.997500000000000e+02];
%  cpselect(I3,I2);
%  cpselect(I1,I2);

% ͨ�������㣬����I1��I2��ͶӰ�任������3*3�ı任����T1
T1 = transfer_caculate(movingPoints, fixedPoints);

% ͨ�������㣬����I1��I2��ͶӰ�任������3*3�ı任����T3
T3 = transfer_caculate(movingPoints1, fixedPoints1);

% ��ʼ��ͶӰ�任�Ķ�������tforn
tforms(3) = projective2d(eye(3));

% T=maketform('projective',T1);   %ͶӰ����
% [I X Y]=imtransform(I1,T);     %ͶӰ
% figure;
% imshow(I);

%�ñ任����ֵtform����
tforms(1).T=T1;
tforms(3).T=T3;


%���¼���任֮�������
for i = 1:numel(tforms)
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(2)], [1 imageSize(1)]);
end

%��任֮�������С������
xMin = min([1; xlim(:)]);
xMax = max([imageSize(2); xlim(:)]);

yMin = min([1; ylim(:)]);
yMax = max([imageSize(1); ylim(:)]);

%ȡȫ��ͼ�ĳ���
width  = round(xMax - xMin);
height = round(yMax - yMin);

%�����յ�ȫ��ͼ����ȡĬ��ֵ
panorama = zeros([height width 3], 'like', I1);
blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');

% ����ȫ��ͼ��2D�ο�ͼ
x_limits = [xMin xMax];
y_limits = [yMin yMax];
perspective = imref2d([height width], x_limits, y_limits);
I1 = imread('1.jpg');
   % I1���б任
pic_I1 = imwarp(I1, tforms(1), 'OutputView', perspective);
I2 = imread('2.jpg');

   % I2���б任
pic_I2 = imwarp(I2, tforms(2), 'OutputView', perspective);
I3 = imread('3.jpg');
  % I3���б任
pic_I3 = imwarp(I3, tforms(3), 'OutputView', perspective);


mask_A = ones([height width]);
mask_B = ones([height width]);
mask_C = ones([height width]);
mask_D = ones([height width]);

% �Թ��ɲ��ֽ��н��䴦������I1+I2
for i = 206:376
    mask_A(:,i) = ones(height,1)*((376-i)/170);      
    mask_B(:,i) = ones(height,1)-mask_A(:,i);         
end

for i = 1 : 3
    panorama_I1(:,:,i) = double(pic_I1(:,:,i)).*mask_A;
    panorama_I2(:,:,i) = double(pic_I2(:,:,i)).*mask_B;
end
res1 = uint8(panorama_I1+panorama_I2);    
    

for i = 360:507
    mask_C(:,i) = ones(height,1)*((i-360)/147);
    mask_D(:,i) = ones(height,1)-mask_C(:,i);
end   

for i = 1 : 3
    panorama_I1_I2(:,:,i) = double(res1(:,:,i)).*mask_D;
    panorama_I3(:,:,i) = double(pic_I3(:,:,i)).*mask_C;
end

panorama=uint8(panorama_I1_I2+panorama_I3); 

figure;
imshow(panorama);
title('ȫ��ͼ');





for i=1:3
    % ��˹������Ƶ���ͨ�˲��������ͼ��⻬��
    
    % ����sigma=200�ĸ�˹����
    ff = creat_gauss(panorama(:,:,i),150);
    
    % Ƶ���ͨ�˲�
    out = lowpass_freq_filt(panorama(:,:,i), ff);
    panorama(:,:,i)=out;
end

figure;
imshow(panorama);
title('Ƶ���ͨ�˲����ȫ��ͼ');