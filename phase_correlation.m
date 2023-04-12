function [offset_y, offset_x] = phase_correlation(im1, im2)
% Calculate the sub-pixel offset between two images using phase correlation
% Inputs:
%   - im1: first image
%   - im2: second image
% Outputs:
%   - offset_y: vertical offset
%   - offset_x: horizontal offset

% Calculate the Fourier transform of the two images
F1 = fft2(im1);
F2 = fft2(im2);

% Calculate the cross-power spectrum
R = F1.*conj(F2) ./ abs(F1 .* F2);

% Calculate the phase correlation
r = real(ifft2(R));
[peak_y, peak_x] = find(r == max(r(:)), 1);

% Calculate the sub-pixel offset

offset_y = peak_y - size(im1, 1) / 2 - 1;
offset_x = peak_x - size(im1, 2) / 2 - 1;

end

