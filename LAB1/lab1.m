M = 8;
N = 10^6;
SNR =  linspace(0,15,30);

seq = randi([0,M - 1],[1,N]);
z = dpskmod(seq, M);

for t = 1:length(SNR)
    for c = 1:length(seq)
        r(t, c) = z(c) + 0.5*(1/sqrt(SNR(t)))*(randn([1,1]) + 1i*randn([1,1]));
    end
end

for n = 1:length(SNR)
    x(n, :) = dpskdemod(r(n, :),M);
end

[number, ratio] = biterr(x, seq);

subplot(1,2,1);
plot(SNR, ratio, 'LineWidth', 2)
title('BER')

subplot(1,2,2); 
plot(SNR, number, 'LineWidth', 2)
title('Bit Error Number')
