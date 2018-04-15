function [TRACE]=trace2envelope(trace,nt)
pkg load signal

resample = floor(rows(trace)/nt);

t = trace(:,1);
t = t-t(1);

trace = trace(:,2:end);

TRACE = abs(hilbert(trace));
TRACE = TRACE/max(abs(TRACE(:)));

t = t(1:resample:end);
TRACE = TRACE(1:resample:end,:);

TRACE = [t TRACE;flipud([t -TRACE])];

pkg unload signal
end
