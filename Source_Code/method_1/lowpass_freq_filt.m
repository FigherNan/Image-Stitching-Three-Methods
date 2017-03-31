function out = lowpass_freq_filt(I,ff)
%   ���룺I��ԭͼ��
%          ff��Ƶ���˲���
%
%	�����out����ͨ�˲�����ͼ��
%
%	���ܣ���˹������Ƶ���ͨ�˲��������ͼ��⻬��

    f = fft2(double(I));

    s = fftshift(f);
    out = s.*ff;
    out = ifftshift(out);
    out = ifft2(out);
    out = real(out);
    %out = out/max(out(:));
end