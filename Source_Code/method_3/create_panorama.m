function [panorama_pic] =create_panorama(tforms,imageSize,x_lim,y_lim,I1,I2,I3)
%   ���룺 I1,I2,I3������RGBͼƬ��
%           tforms����Ӧ��tforms��������
%           x_lim��x��������ƣ�
%           y_lim��y���������
%           
%	����� panorama_pic��ȫ��ͼ
%
%	���ܣ�����tforms����ͶӰ�任������ȫ��ͼ
%       



    %��任֮�������С������
    x_Min = min([1; x_lim(:)]);
    x_Max = max([imageSize(2); x_lim(:)]);

    yMin = min([1; y_lim(:)]);
    yMax = max([imageSize(1); y_lim(:)]);

    %ȡȫ��ͼ�ĳ���
    width  = round(x_Max - x_Min);
    height = round(yMax - yMin);

    %�����յ�ȫ��ͼ����ȡĬ��ֵ
    panorama_pic = zeros([height width 3], 'like', I1);
    blender_pic = vision.AlphaBlender('Operation', 'Binary mask', ...
        'MaskSource', 'Input port');

    % ����ȫ��ͼ��2D�ο�ͼ
    xLimits = [x_Min x_Max];
    yLimits = [yMin yMax];
    perspective = imref2d([height width], xLimits, yLimits);

    %��ʼ����ȫ��ͼ�����ڶ�RGBͼ���в���
    I1 = imread('1.jpg');
    % I1���б任
    warped_pic = imwarp(I1, tforms(1), 'OutputView', perspective);

    % ����һ��mask,��������
    warped_mask = imwarp(ones(size(I1(:,:,1))), tforms(1), 'OutputView', perspective);

    % ���ɶ�ֵͼ��
    warped_mask = warped_mask >= 1;

    
    % ��ת�����ͼ�񸲸���ȫ��ͼ��
    panorama_pic = step(blender_pic, panorama_pic, warped_pic, warped_mask);
    
     I2 = imread('2.jpg');
     for i=1:3
         I2(:,:,i)=I2(:,:,i)+10;
     end
    
    % I2���б任
    warped_pic = imwarp(I2, tforms(2), 'OutputView', perspective);

    % ����һ��mask,��������
    warped_mask = imwarp(ones(size(I2(:,:,1))), tforms(2), 'OutputView', perspective);

    % ���ɶ�ֵͼ��
    warped_mask = warped_mask >= 1;

    % ��ת�����ͼ�񸲸���ȫ��ͼ��
    panorama_pic = step(blender_pic, panorama_pic, warped_pic, warped_mask);
    
     I3 = imread('3.jpg');
     for i=1:3
         I3(:,:,i)=I3(:,:,i)+15;
     end
     % I3���б任
    warped_pic = imwarp(I3, tforms(3), 'OutputView', perspective);
      

    warped_mask = imwarp(ones(size(I1(:,:,1))), tforms(3), 'OutputView', perspective);

    % ����һ��mask,��������
    warped_mask = warped_mask >= 1;

    % ��ת�����ͼ�񸲸���ȫ��ͼ��
    panorama_pic = step(blender_pic, panorama_pic, warped_pic, warped_mask);
end



