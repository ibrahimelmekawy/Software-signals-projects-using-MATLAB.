L=1000;
N=1;
% How to use:
%
% h = MultipathChannel(L) - generates a vector h of length Lx1 containing L
% channel coefficients for the L paths
% h = MultipathChannel(L) - generates a matrix h of dimention LxN, where
% each column corresponds to L channel coefficients for L paths

h = randn(L,N) + 1i*randn(L,N);

power_profile = (1/sqrt(2*pi))*exp(-0.5*[0:L-1])';

power_profile = repmat(power_profile,1,N);

h = abs(h).*power_profile;

rN = rand(1, L);            %Generating a random Sequence
rBinary = round(rN);        %round Sequence  

Fc = 2;                     %Carrier Frequency
Fs = 4;                     %Sampling Frequency 
Tb = 1/Fc;                  % Bit rate time 
t = 0:1/Fs:(1-1/Fs);
xC = cos(2*pi*t);           %Carrier Wave

                     
Eb = 1;                     % Eb = 1
Eb_N0dB = 0 : 2 : 14;      
Eb_N0 = 10.^(Eb_N0dB/10);              
nVar = (Eb)./ Eb_N0;       

bitStream = [];
carrierSignal = [];
i = 1;

while(i<=L)
    if(rBinary(i)== 1)
        bitStream = [bitStream ones(1,length(xC))];
    else
        bitStream = [bitStream zeros(1,length(xC))];
    end
    carrierSignal = [carrierSignal xC];
    i = i+1;
end
bits = 2*(bitStream-0.5);
plot(bits);
xlim([0 300]); ylim([-1.2 1.2]);

H = zeros(L,L);
last_ind = 1;
z = 1;
for n = 1:L
    for k = last_ind:-1:1
        H(n,z) = h(k);
        z = z +1;
    end
    z = 1;
    last_ind = last_ind + 1;
end
H_inv = inv(H);     %recieved
BER = [];
for nn = No
    N = sqrt(nn/2)*randn(L,1);
    for i = 1:100        %we will calculate the BER 10 times for each noise
        x = bits(1:length(H));
        y = H*x' + N;        %recieved
        x_rec = H_inv*y;     %recieved bits plus noise
        D = zeros(size(x_rec));
        for k = 1:L
            if x_rec(k) <= 0
                D(k)= -1 ;
            else
                D(k) = 1;
            end
        end
        
        n = 0;
        for k = 1:L
            if D(k) ~= x(k)
                n = n + 1;
            end
        end
        
        
        BER_temp = [BER_temp n/L];
    end
    BER = [BER mean(BER_temp)];
    BER_temp = [];
end

plot(Eb./No , BER)
xlim([0 100])


