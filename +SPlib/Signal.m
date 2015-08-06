classdef Signal < handle
    %UTSIGNAL provides operations needed for computing parameters from ultrasonic signals
    %Properties: 
    %  t: the time vector. Time should be in seconds. 
    %  y: the measured ultrasound signal. Units are arbitrary.

    
    properties(Access=public)
        y = [];         % the main UT time domin signal
        t = [];         % the time vector corresponding to the signal        
    end
    
    properties(Dependent=true, SetAccess=private, GetAccess=public)
        yenv;           % signal envelop
        ydb;            % signal in dB
        ny;             % normalized signal
        yenvdb;         % signal envelop in dB
        nyenv;          % normalized signal envelop 
        nydb;           % normalized signal in dB
        nyenvdb;        % normalized signal envelop in dB
        Ts;             % sampling time
        Fs;             % sampling rate
        T;              % total signal time
        N;              % number of samples
        starttime;
    end   
    
    methods
        %__________________________________________________________________%
        function this = Signal(t, y)
            this.y = y(:);            
            if ((length(t) ~= length(y)) && ~isscalar(t))
                error(['t and y should have the same length, or t ' ...
                'should be a scalar representing the sampling rate.']);            
            end
            
            if isscalar(t)
                this.t = (0:length(y)-1)*t;
            else
                this.t = t(:);
            end
        end
                       
                                       
        
        %__________________________________________________________________%
        function r = plus(A, B)                                              
            % truncate the start
            if A.t(1) > B.t(1)
                ind = find(B.t > A.t(1), 1);
                B.truncate(ind, 'start');
            elseif A.t(1) < B.t(1)
                ind = find(A.t > B.t(1), 1);
                A.truncate(ind, 'start');
            end
            
            % truncate the end
            if A.t(end) > B.t(end)
                ind = find(A.t > B.t(end), 1);
                A.truncate(ind, 'end');
            elseif A.t(end) < B.t(end)
                ind = find(B.t > A.t(end), 1);
                B.truncate(ind, 'end');
            end
            
            % align the two signals            
            if A.Ts > B.Ts          
                t = A.t;
            else
                t = B.t;
            end
            y1 = interp1(A.t, A.y, t, 'spline');
            y2 = interp1(B.t, B.y, t, 'spline');
            r = UTlib.utsignal(t, (y1 + y2)/2);
        end
        
        %__________________________________________________________________%
        function r = minus(A, B)                                              
            % truncate the start
            if A.t(1) > B.t(1)
                ind = find(B.t > A.t(1), 1);
                B.truncate(ind, 'start');
            elseif A.t(1) < B.t(1)
                ind = find(A.t > B.t(1), 1);
                A.truncate(ind, 'start');
            end
            
            % truncate the end
            if A.t(end) > B.t(end)
                ind = find(A.t > B.t(end), 1);
                A.truncate(ind, 'end');
            elseif A.t(end) < B.t(end)
                ind = find(B.t > A.t(end), 1);
                B.truncate(ind, 'end');
            end
            
            % align the two signals            
            if A.Ts > B.Ts          
                t = A.t;
            else
                t = B.t;
            end
            y1 = interp1(A.t, A.y, t, 'spline');
            y2 = interp1(B.t, B.y, t, 'spline');
            r = UTlib.utsignal(t, (y1 - y2)/2);
        end
              
                
        %__________________________________________________________________%
        %% ---- setting and getting properties
        function yenv = get.yenv(this)
            yenv = abs(hilbert(this.y));
        end
        
        function ydb = get.ydb(this)
            ydb = 20*log10(this.y);
        end
        
        function ny = get.ny(this)
            ny = this.y/max(abs(this.y));
        end        
        
        function yenvdb = get.yenvdb(this)
            yenvdb = 20*log10(this.yenv);
        end
        
        function nyenv = get.nyenv(this)
            nyenv = abs(hilbert(this.y/max(abs(this.y))));
        end
        
        function nydb = get.nydb(this)
            nydb = 20*log10(this.y/max(abs(this.y)));
        end
        
        function nyenvdb = get.nyenvdb(this)
            nyenvdb = 20*log10(this.nyenv);
        end        
        
        function Ts = get.Ts(this)
            Ts = mean(diff(this.t));
        end 
        
        function Fs = get.Fs(this)
            Fs = 1/this.Ts;
        end  
        
        function T = get.T(this)
            T = this.t(end) - this.t(1);
        end
        
        function N = get.N(this)
            N = length(this.t);
        end
        
        function starttime = get.starttime(this)
            starttime = this.t(1);
        end
    end    
    
    methods(Access=protected)      
        %__________________________________________________________________%
        function options = setoptions(~, options, args)
            optionNames = fieldnames(options);
            nArgs = length(args);

            if round(nArgs/2)~=nArgs/2
                error('propertyName/propertyValue pairs are required.')
            end
            for pair = reshape(args,2,[])
                if any(strncmp(pair{1}, optionNames, length(pair{1})))
                    options.(pair{1}) = pair{2};
                else
                    error('%s is not a recognized parameter name.', pair{1})
                end
            end                    
        end
        
        %__________________________________________________________________%        
        function inprox = proximityCheck(~, pts, dist)
            %assume 'pts' is monotonic vector
            inprox = {};
            i = 1;
            n = 1;
            while i < length(pts)
                d = abs(pts(i:end)  - pts(i));
                ind = find(d < dist);
                ind = reshape(ind, 1, []);

                if length(ind) > 1
                    inprox{n} = i-1+ind; 
                    i = ind(end)+i;    
                    n = n+1;
                else
                    i = i + 1;
                end        
            end
        end
        
    end    
end

