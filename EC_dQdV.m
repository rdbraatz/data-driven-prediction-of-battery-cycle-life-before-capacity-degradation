function [V, dQdV]=EC_dQdV_KAS(Q, Ewe, Q_scale, step)
% Peter Attia

% If not specified, set default step size
if nargin == 3
    step = 0.004; %step size is in V, i.e. this is a 4 mV step size
end

% Pre-initialization
numV = numel(Ewe);
i=1;
k=1;

Q = Q./Q_scale;

while i<numV
    diff=0;
    j=1;
    while diff<step && (i+j)<(numel(Ewe)-1)
        diff=abs(Ewe(i+j)-Ewe(i));
        j=j+1;
    end
    dV(k)=Ewe(i+j)-Ewe(i);
    %V(k)=mean([Ewe(i),Ewe(i+j)]);
    V(k) = Ewe(i); %forward difference
    dQ(k)=Q(i+j)-Q(i);
    %i=i+j;
    i=i+1; %try looking at every measurement
    k=k+1;
end

[~, index] = min(V);
V = [V(1:index) V(index+2:end)];
dQ = [dQ(1:index) dQ(index+2:end)];
dV = [dV(1:index) dV(index+2:end)];
dQdV = dQ./dV;

% Remove leading 0's and NaN's
NaNindex = find(dQdV~=0 & ~isnan(dQdV),1);

V = V(NaNindex:end);
dQdV = dQdV(NaNindex:end);

end