function [Q_out, dVdQ]=EC_dVdQ_KAS(Q, Ewe, Q_scale, step)
% Peter Attia

% If not specified, set default step size
if nargin == 3
    step = 0.01;
end

% Pre-initialization
numQ = numel(Q);
i=1;
k=1;

% Stardardize Q to be % of final value
Q = Q./Q_scale;
Q_out = zeros(size(Q));
Q = flipud(Q);

while i<numQ
    diff=0;
    j=1;
    while diff<step && (i+j)<(numel(Q)-1)
        diff=abs(Q(i+j)-Q(i));
        j=j+1;
    end
    dQ(k)=Q(i+j)-Q(i);
    %Q_out(k)=mean([Q(i),Q(i+j)]);
    Q_out(k) = Q(i); %forward difference
    dV(k)=Ewe(i+j)-Ewe(i);
    %i=i+j;
    i=i+1; %try looking at every measurement
    k=k+1;
end

% [~, index] = min(Q_out);
% Q_out = [Q_out(1:index) Q_out(index+2:end)];
% dQ = [dQ(1:index) dQ(index+2:end)];
% dV = [dV(1:index) dV(index+2:end)];
dVdQ = dV./dQ;

% Remove leading 0's and NaN's
% NaNindex = find(dVdQ~=0 & ~isnan(dVdQ),1);
% 
% Q_out = Q_out(NaNindex:end);
% dVdQ = dVdQ(NaNindex:end);

end