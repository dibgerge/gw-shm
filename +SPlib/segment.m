function yseg = segment(r, window, ntaps)
%SEGMENT segments the signal into ntaps signal, each windowed by a given ntaps
%   Inputs: 
%    - r: type Signal object 
%    - window: two element vector: [start_time, window_size]
%    - ntaps: Number of segments

if isscalar(window)
    window = [r.starttime, window];
end

if nargin == 2
    nbin = floor(window(2)/r.Ts);
    ntaps = floor(r.N/nbin);
end

if ntaps*window(2) + window(1) > r.T
    error('Too many taps, or window too long.')
end


Nw = ceil(window(2)/r.Ts);
nskip = ceil(window(1)/r.Ts);
yseg = zeros(r.N, ntaps);

for i=1:ntaps
    nstart = nskip + (i-1)*Nw+1;
    nend = nstart + Nw-1;
    ytemp = r.y;
    ytemp(1:nstart-1) = 0;
    ytemp(nend:end) = 0;    
    w = [zeros(nstart-1,1); hann(Nw); zeros(length(r.y)-nend, 1)];
    yseg(:,i) = ytemp(:).*w(:);    
end

