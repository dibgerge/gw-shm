function sout = window(s, t1, t2, type)
%WINDOW Windows a signal for given start and end time
%   Inputs:
%   - s : Signal Object
%   - t1: start time
%   - t2: end time
%   - type: window type
%            'rect' : rectangular window
%            'hann' : Hanning window

if nargin == 3
    type = 'rect';
end

if isempty(t1)
   ind1 = 1;
else
    ind1 = find(s.t >= t1, 1);
end

if isempty(t2)
    ind2 = s.N;
else
    ind2 = find(s.t >= t2, 1);
end
Nw = ind2-ind1-1;

y = s.y;
y(1:ind1) = 0;
y(ind2:end) = 0;

if strcmpi(type,  'rect')
    wind = ones(Nw, 1);
elseif strcmpi(type, 'hann')
    wind = hann(Nw);
end

wind  = [zeros(ind1,1); wind; zeros(s.N-ind2+1, 1)];
sout = SPlib.Signal(s.t, y.*wind);

end

