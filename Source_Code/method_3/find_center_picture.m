function [tforms] =find_center_picture(tforms,x_lim)
%   ���룺tforms��ԭtforms�������飬
%           x_lim��x���������
%
%	�������tforms��������
%
%	���ܣ����ݱ任���λ�ã��ҵ�λ�����ĵ�ͼƬ��
%       ��������ͼƬ����ţ���tform������б任��
%       ʹ���м��ͼ���䣬���ߵ�ͼ����м����ͶӰ�任��

    %ȡx����ֵ
    avgXLim = mean(x_lim, 2);    

    %ȡ��x�����˳��
    [~, idx] = sort(avgXLim);   

    %ȡ����ͼƬ�����
    centerIdx = floor((numel(tforms)+1)/2);

    %��������ͼƬ����ţ���tform������б任
    centerImageIdx = idx(centerIdx);
    Tinv = invert(tforms(centerImageIdx));

    %ÿ������������ͼƬtform������棬���������ͼƬ���䣬����ͼƬ������ͼƬ��
    %����任
    for i = 1:numel(tforms)
    tforms(i).T = Tinv.T * tforms(i).T;
    end
end