
clc
for i = 1:30
    X(i) = (rand()-0.5)*100;
end

for i = 1:30
    Y(i) = (rand()-0.5)*100;
end

for i = 1:30
    R(i) = X(i)*Y(i);
end

% InputX.txt
XHex = num2hex(X);
% InputY.txt
YHex = num2hex(Y);
% OutputR.txt
RHex = num2hex(R);
% end




