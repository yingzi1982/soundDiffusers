function [y] = gauspuls(t, fc, bw )
  if nargin<1, print_usage; end
  if fc < 0 , error("fc must be positive"); end
  if bw <= 0, error("bw must be stricltly positive"); end

  fv = -(bw.^2.*fc.^2)/(8.*log(10.^(-6/20)));
  tv = 1/(4.*pi.^2.*fv);
  y = exp(-t.*t/(2.*tv)).*cos(2.*pi.*fc.*t);
endfunction
