function x_square = GenerateSquarePulses(t_axis,T_sq,E_bit,fs,x_bits,type)

Ts = 1/fs;
N = length(t_axis);


N_sq = round(T_sq/Ts);
one_square = zeros(1,N_sq);
if type == 1
    A = sqrt(2*E_bit / N_sq); 
    one_square = A + one_square;    
else
    alpha = 0.5;
    W = 1/T_sq;
    n = 102400 - 1;
    t_axis_sh = ((-(n-1)/2):((n-1)/2))*Ts;
    one_raised_cos = sinc(2*W*t_axis_sh).*cos(2*pi*alpha*W*t_axis_sh)./(1-(4*alpha*W*t_axis).^2);
end
x_square = zeros(1, N);

for i = 1:length(x_bits)          
    if type == 1
        if x_bits(i) == 1
            x_square((i-1)*N_sq +1:i*N_sq) = x_square((i-1)*N_sq +1:i*N_sq) + one_square;
        end
    else
        if x_bits(i) == 1
            x_square = x_square + circshift(one_raised_cos' , N_sq*(i-1))';
        else
            x_square = x_square - circshift(one_raised_cos' , N_sq*(i-1))';
        end
    end
end
     
end