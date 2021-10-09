%% Building C/A 1 and 2
SR1 = ones(1,10);    % Creating main shift register 1 
SR2 = ones(1,10);    % Creating main shift register 2

CA_code1 = []; CA_code2 = [];

for i = 1:1023                   % Iterating through each of the chips
    update_1 = xor(SR1(3), SR1(10));
    update_2 = xor(SR2(2), xor(SR2(3), xor(SR2(6), xor(SR2(8), xor(SR2(9), SR2(10))))));
    CA_code1(i) = xor( SR1(10), (xor(SR2(3) ,SR2(8))) );
    CA_code2(i) = xor( SR1(10), (xor(SR2(2) ,SR2(6))) );
    SR1 = circshift(SR1 , 1);
    SR2 = circshift(SR2 , 1);
    SR1(1) = update_1;
    SR2(1) = update_2; 
end
%% Plot first figure
autocorrelation1 = zeros(1,1023);
autocorrelation2 = zeros(1,1023);
crosscorrelation = zeros(1,1023);

for i = 1:1023
    if (CA_code1(i) == 0) 
        CA_code1(i) = -1;
    end
    
    if (CA_code2(i) == 0) 
        CA_code2(i) = -1;
    end
end

for shift = 0:1022
    %correlation for code 1
    CA_code1_shifted = circshift(CA_code1, shift);
    autocorrelation1(shift+1) = CA_code1*CA_code1_shifted';
        
    %correlation for code 2
    CA_code2_shifted = circshift(CA_code2, shift);
    autocorrelation2(shift+1) = CA_code2*CA_code2_shifted';
    
    %cross correlation
    crosscorrelation(shift+1) = CA_code2*CA_code1_shifted';
end  
%% Plot correlations
figure
plot(autocorrelation1,'linewidth',2)
title('1023 chip Gold code (3/8) autocorrelation')
xlabel('shifts');ylabel('value of correlations');

figure
plot(autocorrelation2,'linewidth',2)
title('1023 chip Gold code (2/6) autocorrelation');
xlabel('shifts');ylabel('value of correlations');
%% Plot Cross correlation
figure
plot(crosscorrelation,'linewidth',2)
title('crosscorrelation of C/A code For phase tap (2,6) and phase tap (3,8)')
xlabel('shifts','linewidth',2)
ylabel('crosscorrelation','linewidth',2)
%% End of code %%