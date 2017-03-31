function [valid_features,valid_points] = detect_surf(I1)
   
    %��I1��������
    gray_pic = rgb2gray(I1);        %RGBͼת�Ҷ�ͼ
    points = detectSURFFeatures(gray_pic); %��surf������

    figure;             %�ڻҶ�ͼ�ϻ�surf������
    imshow(gray_pic); 
    hold on;
    points.plot;

    %ȡ��Ч�������㣬������Χ����Ϣ
    [valid_features, valid_points] = extractFeatures(gray_pic, points);
end
