% ����ʱ�����ȴ�find_center_picture��detect_surf��create_panorama
%               imfreqfilt, imggaussflpf�����ͷ�ļ�
%               ���ر�����method.m���ļ�
%               �����ͼ���С������������

% *************************
% image sitching method_3
% *************************

% ��ʼ��ͶӰ�任�Ķ�������tforn
tforms(3) = projective2d(eye(3));

% ��ȡ��һ��ͼ��
I1 = imread('1.jpg');

% �ҵ�һ��ͼ���surf��Ч���������Ч����
[valid_features,valid_points] = detect_surf(I1);


% ��������I2
    
% �Ȱ�I1�������������Ϣ������
points_pre = valid_points; 
features_pre = valid_features;
% ��ȡI2
I2 = imread('2.jpg');

% �ҵڶ���ͼ���surf��Ч���������Ч����
[valid_features,valid_points] = detect_surf(I2);

% ��I1��I2�����ƴ�,������indexPairs������,���һ��ΪI2��index���ڶ���ΪI2��index
index_match = matchFeatures(valid_features, features_pre, 'Unique', true);

matched_valid_points = valid_points(index_match(:,1), :);
matched_points_pre = points_pre(index_match(:,2), :);
    
%imshow��ѡ��ƥ����
figure; 
ax = axes;
showMatchedFeatures(I2, I1, matched_valid_points, matched_points_pre,...
    'montage', 'Parent',ax);
title(ax, 'Candidate point matches betweem I1 and I2');
legend(ax, 'Matched points 1','Matched points 2');
    
%�����I2��I1��tform����
tforms(2) = estimateGeometricTransform(matched_valid_points, matched_points_pre,...
    'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);

% ���� tforms(2).T
tforms(2).T = tforms(1).T * tforms(2).T;

    
%��������I3
        
%�Ȱ�I2�������������Ϣ������
points_pre = valid_points; 
features_pre = valid_features;

% ��ȡI3
I3 = imread('3.jpg');


% �ҵ�����ͼ���surf��Ч���������Ч����
[valid_features,valid_points] = detect_surf(I3);

%��I1��I2�����ƴ�,������index_match����������,���һ��ΪI2��index���ڶ���ΪI2��index
index_match = matchFeatures(valid_features, features_pre, 'Unique', true);
matched_valid_points = valid_points(index_match(:,1), :);
matched_points_pre = points_pre(index_match(:,2), :);
    
%imshow��ѡ��ƥ����
figure; 
ax = axes;
showMatchedFeatures(I3, I2, matched_valid_points, matched_points_pre,...
        'montage', 'Parent',ax);
title(ax, 'Candidate point matches betweem I2 and I3');
legend(ax, 'Matched points 1','Matched points 2');
    
%�����I2��I1��tform����
tforms(3) = estimateGeometricTransform(matched_valid_points, matched_points_pre,...
        'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);

% ���� tforms(3).T
tforms(3).T = tforms(2).T * tforms(3).T;


imageSize = size(I1);  %����ͼ���С��ͬ



% ����ͶӰ�任֮��ÿ��ͼ�ķ�Χ
for i = 1:3
    [x_lim(i,:), y_lim(i,:)] = outputLimits(tforms(i), [1 imageSize(2)], [1 imageSize(1)]);
end

% �Զ��ҵ��м��ͼƬ�������µ�tforms
tforms = find_center_picture(tforms,x_lim);

% ����ȫ��ͼ
panorama_pic = create_panorama(tforms,imageSize,x_lim,y_lim,I1,I2,I3);

figure;
imshow(panorama_pic);
impixelinfo;
for i=1:3
    % ��˹������Ƶ���ͨ�˲��������ͼ��⻬��
    
    % ����sigma=200�ĸ�˹����
    ff = creat_gauss(panorama_pic(:,:,i),200);
    
    % Ƶ���ͨ�˲�
    out = lowpass_freq_filt(panorama_pic(:,:,i), ff);
    panorama_pic(:,:,i)=out;
end

figure;
imshow(panorama_pic);
impixelinfo;