#!/ichec/packages/octave/3.6.3/octave-3.6.3_build/bin/octave
function [randomField]=randomField2D(tomoType,seed,X,Z,correlationLength,meanVal,stdVal,hurstNumber)
%http://mgstat.sourceforge.net/
%http://sepwww.stanford.edu/public/docs/sep80/nizar2/paper_html/index.html
%3D Von Karman:normalized psdf = 1./((1 + K.^2).^(hurstNumber + 1.5))
%2D Von Karman:normalized psdf = 1./((1 + K.^2).^(hurstNumber + 1))
if nargin==7
  hurstNumber = 0.2;
end
if length(correlationLength) == 1
  correlationLength = [correlationLength correlationLength];
end

[nx nz] = size(permute(X,[2 1]));

dkx = 1/(max(X(:)) - min(X(:)));
dkz = 1/(max(Z(:)) - min(Z(:)));

if mod(nx,2) == 1 xinc = 1; nx = nx +xinc; else xinc = 0; end
if mod(nz,2) == 1 zinc = 1; nz = nz +zinc; else zinc = 0; end

kx = 2*pi*dkx*[-nx/2:1:nx/2-1];
kz = 2*pi*dkz*[-nz/2:1:nz/2-1];

[KX KZ] = meshgrid(kx,kz);

K = sqrt(KX.^2.*correlationLength(1).^2 + KZ.^2.*correlationLength(2).^2);

rand('seed',seed);
uniformRandomField = rand(size(K)) - 0.5;
%randn('seed',seed);
%uniformRandomField = randn(size(K));
switch lower(tomoType)
%case {'homogeneous','homo'}
%  psdf = zeros(size(K));

case {'gaussian','gauss'}
  psdf = exp(-(K.^2./4));

case {'exponential','exp'}
  psdf = 1./((1 + K.^2).^(1.5));

case {'vonkarman','von'}
  psdf = 1./((1 + K.^2).^(hurstNumber + 1));

otherwise
  error('Wrong media type!')
end

psdf = sqrt(psdf/max(psdf(:)));
randomField = real(ifft2(fftshift(fftshift(fft2(uniformRandomField)).*psdf)));

randomField = randomField(1:end-xinc,1:end-zinc);

randomField = stdVal*randomField/std(randomField(:));
randomField = meanVal + randomField - mean(randomField(:));
end
