function sout = truncate(s, t1, t2)
%TRUNCATE Truncates a signal within given time limits
%   Inputs: 
%   - s: Signal object
%   - t1: start time
%   - t2: end time

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

t = s.t(ind1:ind2);
y = s.y(ind1:ind2);
sout = SPlib.Signal(t, y);
        
end

