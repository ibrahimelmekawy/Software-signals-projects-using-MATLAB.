L=1000;
N=1;
h = randn(L,N) + 1i*randn(L,N);
power_profile = exp(-0.5*[0:L-1].^2)';
power_profile = repmat(power_profile,1,N);
h = abs(h).*power_profile;

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
H_inv = inv(H);
BER_temp = [];
Eb = 1;
No = [1 0.5 0.1 0.05 0.01 0.005 0.001];
L=1000;
N=1;
h = randn(L,N) + 1i*randn(L,N);
power_profile = exp(-0.5*[0:L-1])';
power_profile = repmat(power_profile,1,N);
h = abs(h).*power_profile;

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
H_inv = inv(H);
BER_temp = [];
Eb = 1;
No = [1 0.5 0.1 0.05 0.01 0.005 0.001];
BER = [];
for nn = No
    N = sqrt(nn/2)*randn(L,1);
    for i = 1:10        %we will calculate the BER 10 times for each noise
        valid_vals = setdiff(-1:1, 0);
        x = valid_vals( randi(length(valid_vals), L, 1) ); %stream of bits transmitted
        
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