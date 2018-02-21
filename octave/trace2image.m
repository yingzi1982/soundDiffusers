#!/ichec/packages/octave/3.6.3/octave-3.6.3_build/bin/octave
function [image]=trace2image(trace,nt,range)

tstep = floor(rows(trace)/nt);

t = trace(1:tstep:end,1);
t = t-t(1);

trace = trace(1:tstep:end,2:end);
trace = trace/max(abs(trace(:)));

[RANGE T] = meshgrid(range,t);

image = reshape(trace,[],1);
RANGE = reshape(RANGE(:,:),[],1);
T = reshape(T(:,:),[],1);

image = [RANGE T image];
end
