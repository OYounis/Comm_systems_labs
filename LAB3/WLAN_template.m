clc; clear all; close all;
%% Initialization
Frames = 1000; %Number of Frames
fft_size = 128; %FFT Size (Number of subcarriers)
M = 16; K = log2(M); %16-QAM Modulation
delta = 312.5*10^(3); %Carrier Separation
delay_spread = 0.2*10^(-6); %Delay Spread
SNRdb = 0:3:30; %SNR Range in dB
delay_spread_max = delay_spread*fft_size*delta; %Number of paths
msg_size_bits = K*fft_size;
msg_size_symbols = msg_size_bits/K;
BER = zeros(length(SNRdb),Frames);
BER_avg = zeros(length(SNRdb),1);
%%
i = 1;
k = 1;
%%
for i = 1:length(SNRdb)
for k = 1:Frames
%% Message Generation
msg_bits=randi([0,1],msg_size_symbols,K);
msg = bi2de(msg_bits,'left-msb')';
%% QAM Modulation 
msg_mod = qammod(msg, M, "UnitAveragePower", true);
%% IFFT
msg_ofdm = sqrt(fft_size) * ifft(msg_mod);
%% ADD Cyclic Prefix
CP = msg_ofdm(end-31:end);
msg_CP = [CP msg_ofdm];
%% Channel (fading + noise)
[fadedSamples, gain] =ApplyFading(msg_CP,1,delay_spread_max);
msg_rx=awgn(fadedSamples,SNRdb(i),'measured');
%% Cyclic prefix removal 
msg_rx_CP = msg_rx(33:end-7);
%% Freq domain equalization
msg_rx_fft = fft(msg_rx_CP)/sqrt(fft_size);
msg_eq = msg_rx_fft ./ fft(gain,128);
%% QAM Demodulation
msg_demod = qamdemod(msg_eq, M,"UnitAveragePower", true);
msg_demod_bits = de2bi(msg_demod,'left-msb');
%% BER calculation
[~,BER(i,k)] = biterr(msg_demod_bits,msg_bits);
BER_avg(i) = sum(BER(i,:))./Frames;
end
end
%% Plotting BER vs. SNR
figure
semilogy(SNRdb,BER_avg)
title('BER vs. SNR for 16-QAM with fading');
xlabel('SNR(dB)')
ylabel('BER')
grid on