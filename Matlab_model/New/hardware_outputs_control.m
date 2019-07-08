 N = 2048;
 s = 1;
 w1 = 12;
 f1 = 4;

% Reading inputs
hardware_out_re_int  = importdata('fft_outputs_real.txt');
hardware_out_re_char = num2str(hardware_out_re_int);
hardware_out_re      = bin2dec(hardware_out_re_char);

for  a= 1 : 1 : N
    if (hardware_out_re(a) > 2048)
        hardware_out_re(a) = hardware_out_re(a) - 4096;
    end 
end  

% Reading inputs
hardware_out_im_int  = importdata('fft_outputs_imaginary.txt');
hardware_out_im_char = num2str(hardware_out_im_int);
hardware_out_im      = bin2dec(hardware_out_im_char);

for  a=1 : 1 : N
    if (hardware_out_im(a) > 2048)
        hardware_out_im(a) = hardware_out_im(a) - 4096;
    end 
end 

% FFT Reference
fft_input_re_ref_1 = importdata('fft_stage11output_binary.txt');
fft_input_re_ref_2 = num2str(fft_input_re_ref_1);
mult_out_re      = bin2dec(fft_input_re_ref_2);

for  a=1 : 1 : N
    if (mult_out_re(a) > 2048)
        mult_out_re(a) = mult_out_re(a) - 4096;
    end 
end 

fft_input_im_ref_1 = importdata('fft_stage11output_binary_imaginary.txt');
fft_input_im_ref_2 = num2str(fft_input_im_ref_1);
mult_out_im      = bin2dec(fft_input_im_ref_2);

for  a=1 : 1 : N
    if (mult_out_im(a) > 2048)
        mult_out_im(a) = mult_out_im(a) - 4096;
    end 
end

% hardware_out_re_ref = hardware_out_re(2049:4096);
% hardware_out_im_ref = hardware_out_im(2049:4096);


diff_re =  hardware_out_re(1:2048)-mult_out_re;
diff_im =  hardware_out_im(1:2048)-mult_out_im;
% diff_re = mult_out_re - hardware_out_re_ref;
% diff_im = mult_out_im - hardware_out_im_ref;

% ranges of axis 
r1 = -2000;
r2 = 2000;
r3 = -10;
r4 = 10;

figure(5);
clf;
subplot(2,1,2);
plot(diff_re);
axis([0 N r3 r4]);
title('Difference between Hardware and Matlab Models');
subplot(2,1,1);
plot(mult_out_re,'k'), hold on;
plot(hardware_out_re,'--r');
axis([0 N r1 r2]);
legend('Matlab','Hardware');
title('2048 point FFT real numbers');

figure(6);
clf;
subplot(2,1,2);
plot(diff_im);
axis([0 N r3 r4]);
title('Difference between Hardware and Matlab Models');
subplot(2,1,1);
plot(mult_out_im,'k'), hold on;
plot(hardware_out_im,'--r');
axis([0 N r1 r2]);
legend('Matlab','Hardware');
title('2048 point FFT imaginary numbers');

% state_output = ref_inv_re;
% FID1 = fopen('fft_reference_output_real.txt','w+');
% FID2 = fopen('fft_reference_output_binary_real.txt','w+');
% n = f1; % number of fractinonal bits
% for i = 1 : 1 : 2048    
%     fprintf(FID1,'%.10f\n',state_output(i));
%     if (state_output(i)<0)
%        temp = abs(state_output(i));
%        temp2 = dec2bin(round(temp*2^n),n);
%        temp3 = pad(temp2,12,'left','0');
%        temp4 = not(temp3-'0');
%        temp5 = num2str(temp4);
%        binary_nbit = dec2bin(bin2dec(temp5)+bin2dec('1'));
%        fprintf(FID2,'%s\n',binary_nbit);
%    elseif (state_output(i)==0)
%        fprintf(FID2,'000000000000\n');
%    else
%        temp = dec2bin(round(state_output(i)*2^n),n);
%        binary_nbit = pad(temp,12,'left','0');
%        fprintf(FID2,'%s\n',binary_nbit);
%    end    
% end
% fclose(FID1);
% fclose(FID2);
% 
% state_output = ref_inv_im;
% FID3 = fopen('fft_reference_output_imag.txt','w+');
% FID4 = fopen('fft_reference_output_binary_imag.txt','w+');
% n = f1; % number of fractinonal bits
% for i = 1 : 1 : 2048    
%     fprintf(FID3,'%.10f\n',state_output(i));
%     if (state_output(i)<0)
%        temp = abs(state_output(i));
%        temp2 = dec2bin(round(temp*2^n),n);
%        temp3 = pad(temp2,12,'left','0');
%        temp4 = not(temp3-'0');
%        temp5 = num2str(temp4);
%        binary_nbit = dec2bin(bin2dec(temp5)+bin2dec('1'));
%        fprintf(FID4,'%s\n',binary_nbit);
%    elseif (state_output(i)==0)
%        fprintf(FID4,'000000000000\n');
%    else
%        temp = dec2bin(round(state_output(i)*2^n),n);
%        binary_nbit = pad(temp,12,'left','0');
%        fprintf(FID4,'%s\n',binary_nbit);
%    end    
% end
% fclose(FID3);
% fclose(FID4);

% % Reading inputs
% fft_output_re_int = importdata('fft_reference_output_binary_real.txt');
% fft_output_re_char = num2str(fft_output_re_int);
% fft_output_re = bin2dec(fft_output_re_char);
% % 
% % Reading inputs
% fft_output_im_int = importdata('fft_reference_output_binary_imag.txt');
% fft_output_im_char = num2str(fft_output_im_int);
% fft_output_im = bin2dec(fft_output_im_char);
% 