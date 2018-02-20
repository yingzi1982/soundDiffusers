function [dout] = AGCgain(d,agc_gate);
%GAIN: Gain a group of traces.
%
%
%  IN   d(nt,nx+1):    traces
%       agc_gate  :    Length of the agc gate in secs
%       option  = 0  No normalization
%               = 1  Normalize each trace by amplitude
%               = 2  Normalize each trace by rms value

 option = 2;


 t = d(:,1);
 dt = t(2) - t(1);
 d = d(:,2:end);

 [nt,nx] = size(d);
 
  L = agc_gate(1)/dt+1;
  L = floor(L/2);
  %h = triang(2*L+1);
  h = hanning(2*L+1);

  for k = 1:nx
   aux =  d(:,k);
   e = aux.^2;
   rms = sqrt(conv2(e,h,'same'));
   epsi = 1.e-10*max(rms);
   op = rms./(rms.^2+epsi);
   dout(:,k) = d(:,k).*op;
   end

 if option==1;                % Normalize by amplitude 

   for k = 1:nx
    aux =  dout(:,k);
    amax = max(abs(aux));
    dout(:,k) = dout(:,k)/amax;
   end

 end

 if option==2;                % Normalize by rms 

   for k = 1:nx
    aux =  dout(:,k);
    amax =  sqrt(sum(aux.^2)/nt);
    dout(:,k) = dout(:,k)/amax;
   end
 dout = [t dout];

 end
