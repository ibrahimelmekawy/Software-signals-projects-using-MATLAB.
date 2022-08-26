%%%%%%%%%%%%part 1 %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fs = 5e6;                       % Sampling rate (samples per sec)
Ts = 1/fs;                      % Sampling time
N = 102400 - 1;                 % Total number of samples
t_axis = (0:N-1)*Ts;            % Time axis (the same during the entire experiment)
t_axis_sh = ((-(N-1)/2):((N-1)/2))*Ts;
f_axis = -fs/2:fs/N:fs/2-1/N;   % Frequency axis (the same during the entire experiment)

% Generate one square pulse with the following parameters
Energy_per_bit = 50.5;             % The total energy of all samples constituting the square pulse
B = 100*10^3;
T_sq = 2/B;
N_sq = round(T_sq/Ts);          %N_sq = 100

%generating one pulse
x_bits = 1;
x_square = GenerateSquarePulses(t_axis,T_sq,Energy_per_bit,fs,x_bits,1);

figure
subplot(2,1,1)

plot(t_axis,x_square,'linewidth',2)
grid on
xlim([0 T_sq*1.2])
xlabel('Time','linewidth',2)
ylabel('Square pulse','linewidth',2)

X_squareF = (1/fs)*abs(fftshift(fft(x_square)));


subplot(2,1,2)
plot(f_axis,abs(X_squareF),'linewidth',2)
title('Square in freq','linewidth',10)
grid on
xlim([-1/T_sq 1/T_sq]*5)
xlabel('Frequency','linewidth',2)
ylabel('Frequency ressponse magnitude','linewidth',2)
subplot(2,1,1)
title('A square pulse in time and frequency domains','linewidth',10)

%creating the channel

channelf = rectpuls(f_axis , 2*B);
channel = ifft(ifftshift(channelf));
figure
subplot(2,1,1)
plot(f_axis,abs(channelf),'linewidth',2)
title('Channel in Frequency','linewidth',10)
xlim([-1/T_sq 1/T_sq]*5)
subplot(2,1,2)
plot(t_axis,channel,'linewidth',2)
title('Channel in Time','linewidth',10)
xlim([0 T_sq*1.2])

%passing the pulse to the channel
temp = conv(x_square , channel);
y = temp(:,1:length(t_axis));
figure
grid on
plot(t_axis,y,'linewidth',2)
title('Recieved pulse in Time','linewidth',10)
xlim([0 T_sq*2])
yf = (1/fs)*abs(fftshift(fft(y)));
figure
plot(f_axis,yf,'linewidth',2)
title('Recieved pulse in Frequency','linewidth',10)
xlim([-1/T_sq 1/T_sq]*5)

%creating two separate pulses

x_bits = 1;
x_square1 = GenerateSquarePulses(t_axis,T_sq,Energy_per_bit,fs,x_bits,1);

x_bits = [0 1];
x_square2 = GenerateSquarePulses(t_axis,T_sq,Energy_per_bit,fs,x_bits,1);
figure
plot(t_axis,x_square1,t_axis,x_square2 , 'linewidth',2)
xlim([0 T_sq*2.4])

%passing the two pulses to the channel

temp = conv(x_square1 , channel);
y1 = temp(:,1:length(t_axis));
yf1 = (1/fs)*abs(fftshift(fft(y1)));

temp = conv(x_square2 , channel);
y2 = temp(:,1:length(t_axis));
yf2 = (1/fs)*abs(fftshift(fft(y2)));

figure
grid on
plot(t_axis,y1,t_axis,y2,t_axis ,(y1+y2),'linewidth',2)
title('Recieved pulse in Time','linewidth',10)
xlim([0 T_sq*3])

figure
plot(f_axis,yf1 , f_axis,yf2 , f_axis , yf1+yf2 ,'linewidth',2)
title('Recieved pulse in Frequency','linewidth',10)
xlim([-1/T_sq 1/T_sq]*5)



%raised cosine

x_bits = [1 1 0 1 0 1];
x = GenerateSquarePulses(t_axis_sh,T_sq,Energy_per_bit,fs,x_bits,2);
Xf = (1/fs)*abs(fftshift(fft(x)));
figure
plot(t_axis_sh,x , 'linewidth',2)
xlim([-T_sq*2 T_sq*6])
title('Transmitted signal in Time with Rasied Cosine','linewidth',10)
grid on


%passing through channel
temp = conv(x , channel);
y1 = temp(:,1:length(t_axis));
figure
plot(t_axis_sh, y1 , 'linewidth',2)
xlim([-T_sq*2 T_sq*6])
title('Recievied signal in Time with Rasied Cosine','linewidth',10)
grid on

