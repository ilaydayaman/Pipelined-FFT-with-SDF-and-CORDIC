 N = 2048;
 s = 1;
 w1 = 12;
 f1 = 9;
 
% Reding fft coefficients 
FID = fopen('fft_coefficients.txt','r');
coefficients=fscanf(FID,'%f');
% Reading inputs
FID1 = fopen('fft_inputs_fixed.txt','r');
fft_input=fscanf(FID1,'%f');

fclose('all');

for q = 1 : 1 : N
    fft_input_re(q) = fft_input(2*q-1);
    fft_input_im(q) = fft_input(2*q);
end

[mult_out_re, mult_out_im] = my_FFT_3(coefficients, fft_input_re,fft_input_im, N);

% FFT Reference
for a=1 : 1 : N
    input_complex(a) = fft_input_re(a)+1i*fft_input_im(a);
end
ref = fft(input_complex);
ref_inv = bitrevorder(ref);

ref_inv_re = real(ref_inv);
ref_inv_im = imag(ref_inv);
diff_re = ref_inv_re - mult_out_re;
diff_im = ref_inv_im - mult_out_im;
diff_re_procent = (diff_re./ref_inv_re)*100;

% ranges of axis 
r1 = -130;
r2 = 130;

figure(1);
clf;
subplot(2,1,2);
plot(diff_re);
axis([0 N -2 2]);
title('Difference between floating and fixed point');
subplot(2,1,1);
plot(ref_inv_re,'k'), hold on;
plot(mult_out_re,'--r');
axis([0 N r1 r2]);
legend('Floatin point','Fixed point');
title('2048 point FFT real numbers');

figure(2);
clf;
subplot(2,1,2);
plot(diff_im);
axis([0 N -2 2]);
title('Difference between floating and fixed point');
subplot(2,1,1);
plot(ref_inv_im,'k'), hold on;
plot(mult_out_im,'--r');
axis([0 N r1 r2]);
legend('Floatin point','Fixed point');
title('2048 point FFT imaginary numbers');
 
 
% % IFFT Stages
% for a=1 : 1 : N
%     ifft_input_complex(a) = mult_out_re(a)+1i*mult_out_im(a);
% end
%  ref_inv = bitrevorder(ifft_input_complex);
%  
%  ifft_input_re = real(ref_inv);
%  ifft_input_im = imag(ref_inv);
%  
% FID3 = fopen('fft_input_ifft.txt','w+');
% 
% for kn=1 : 1 : N
%        fprintf(FID3,'%.4f\n',ifft_input_re(kn));
%        fprintf(FID3,'%.4f\n',ifft_input_im(kn));
% end
% fclose(FID3);
% 
% % change im->re and re->im and divide to N
%  ifft_input_re_rv = ifft_input_im/2048;
%  ifft_input_im_rv = ifft_input_re/2048;
%  
%  [ifft_output_re, ifft_output_im] = my_FFT(coefficients, ifft_input_re_rv,ifft_input_im_rv, N);
%  
%  for a=1 : 1 : N
%     ifft_output_complex(a) = ifft_output_im(a)+1i*ifft_output_re(a);
% end
% 
%  ref_inv_bitrevorder = bitrevorder(ifft_output_complex);
%  
%  ref_inv_re = real(ref_inv_bitrevorder);
%  ref_inv_im = imag(ref_inv_bitrevorder);
%  
%  diff_re = ref_inv_re - fft_input_re;
%  diff_im = ref_inv_im - fft_input_im;
%  
% % ranges of axis 
% r1 = -1;
% r2 = 1;
% 
% figure(3);
% clf;
% subplot(2,1,2);
% plot(diff_re);
% axis([0 N -0.2 0.2]);
% title('Difference given inputs and output of the IFFT');
% subplot(2,1,1);
% plot(ref_inv_re,'k'), hold on;
% plot(fft_input_re,'--r');
% axis([0 N r1 r2]);
% legend('Output of the IFFT','Given Inputs');
% title('2048 point IFFT real numbers');
% 
% figure(4);
% clf;
% subplot(2,1,2);
% plot(diff_im);
% axis([0 N -0.2 0.2]);
% title('Difference between given inputs and output of the IFFT');
% subplot(2,1,1);
% plot(ref_inv_im,'k'), hold on;
% plot(fft_input_im,'--r');
% axis([0 N r1 r2]);
% legend('Output of the IFFT','Given Inputs');
% title('2048 point IFFT imaginary numbers');