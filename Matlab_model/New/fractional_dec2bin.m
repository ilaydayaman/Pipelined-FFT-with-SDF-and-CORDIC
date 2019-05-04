N = 2048;

% ********** Reading coefficients **********
FID = fopen('fft_coefficients.txt','r');
coefficients=fscanf(FID,'%f');
for q=1 : 1 : N/2
   coeff_re(q) = coefficients(2*q-1);
   coeff_im(q) = coefficients(2*q);
end

%figure(1), clf;
%plot(coeff_re,coeff_im);

% ********** Converting coefficient real part to binary **********
FID1 = fopen('fft_coefficients_binary_real.txt','w+');
%FID2 = fopen('fft_coefficients_binary_imag.txt','w+');
nbits = 10; % 12 bit words, 10 bits for fractions, 1 bit for signed, 1 bit for integer
for i=1 : 1 : N/8
    if (coeff_re(i)==1)
        fprintf(FID1,'regfileReg(%u) <= "010000000000";\n',i-1);
    else
        binary_10bit = dec2bin(round(coeff_re(i)*2^nbits),nbits);
        fprintf(FID1,'regfileReg(%u) <= "00%s";\n',i-1,binary_10bit);
    end
end

% ********** Converting coefficient imaginary part to binary **********
FID2 = fopen('fft_coefficients_binary_imag.txt','w+');
nbits = 10; % 12 bit words, 10 bits for fractions, 1 bit for signed, 1 bit for integer
for i=1 : 1 : N/8
    temp = abs(coeff_im(i));
    if (temp==0)
        fprintf(FID2,'regfileReg(%u) <= "000000000000";\n',i-1);
    else
        binary_10bit = dec2bin(round(temp*2^nbits),nbits);
        fprintf(FID2,'regfileReg(%u) <= "10%s";\n',i-1,binary_10bit);
    end
end
%-------------------------------------------------------------------------------------


% ********** Reading inputs **********
FID3 = fopen('fft_inputs_fixed.txt','r');
coefficients=fscanf(FID3,'%f');
for q=1 : 1 : N
   input_re(q) = coefficients(2*q-1);
   input_im(q) = coefficients(2*q);
end

% ********** Converting inputs real part to binary **********
FID4 = fopen('fft_inputs_binary_real.txt','w+');
for i=1 : 1 : N
   if (input_re(i)<0)
       temp = abs(input_re(i));
       binary_10bit = dec2bin(round(temp*2^nbits),nbits);
       fprintf(FID4,'10%s\n',binary_10bit);
   elseif (input_re(i)==0)
       fprintf(FID4,'000000000000\n');
   else
       binary_10bit = dec2bin(round(input_re(i)*2^nbits),nbits);
       fprintf(FID4,'00%s\n',binary_10bit);
   end   
end

% ********** Converting inputs imaginary part to binary **********
FID5 = fopen('fft_inputs_binary_imaginary.txt','w+');
for i=1 : 1 : N
   if (input_im(i)<0)
       temp = abs(input_im(i));
       binary_10bit = dec2bin(round(temp*2^nbits),nbits);
       fprintf(FID5,'10%s\n',binary_10bit);
   elseif (input_im(i)==0)
       fprintf(FID5,'000000000000\n');
   else
       binary_10bit = dec2bin(round(input_im(i)*2^nbits),nbits);
       fprintf(FID5,'00%s\n',binary_10bit);
   end   
end