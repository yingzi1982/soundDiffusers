#!/ichec/packages/octave/3.6.3/octave-3.6.3_build/bin/octave
function [randomField]=randomField1D(tomoType,seed,x,correlationLength,meanVal,stdVal,hurstNumber)
if nargin==6
  hurstNumber = 0.1;
end

[nx ] = length(x);

dkx = 1/(max(x(:)) - min(x(:)));

if mod(nx,2) == 1 xinc = 1; nx = nx +xinc; else xinc = 0; end

kx = transpose(2*pi*dkx*[-nx/2:1:nx/2-1]);


k = sqrt(kx.^2.*correlationLength.^2);

rand('seed',seed);
uniformRandomField = rand(size(k)) - 0.5;
%randn('seed',seed);
%uniformRandomField = randn(size(K));
switch lower(tomoType)
%case {'homogeneous','homo'}
%  psdf = zeros(size(K));

case {'gaussian','gauss'}
  psdf = exp(-(k.^2./4));

case {'exponential','exp'}
  psdf = 1./((1 + k.^2).^(1.5));

case {'vonkarman','von'}
  psdf = 1./((1 + k.^2).^(hurstNumber + 1));

otherwise
  error('Wrong media type!')
end

psdf = sqrt(psdf/max(psdf(:)));
randomField = real(ifft(fftshift(fftshift(fft(uniformRandomField)).*psdf)));

randomField = randomField(1:end-xinc);

randomField = stdVal*randomField/std(randomField(:));
randomField = meanVal + randomField - mean(randomField(:));
end
