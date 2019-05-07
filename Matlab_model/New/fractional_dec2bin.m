N = 2048;

% ********** Reading inputs **********
FID3 = fopen('fft_inputs_fixed.txt','r');
coefficients=fscanf(FID3,'%f');
for q=1 : 1 : N
   input_re(q) = coefficients(2*q-1);
   input_im(q) = coefficients(2*q);
end

n = 11; % number of fractinonal bits
% ********** Converting inputs real part to binary **********
FID4 = fopen('fft_inputs_binary_real.txt','w+');
for i=1 : 1 : N
   if (input_re(i)<0)
       temp = abs(input_re(i));
       binary_nbit = dec2bin(round(temp*2^n),n);
       fprintf(FID4,'1%s\n',binary_nbit);
   elseif (input_re(i)==0)
       fprintf(FID4,'000000000000\n');
   else
       binary_nbit = dec2bin(round(input_re(i)*2^n),n);
       fprintf(FID4,'0%s\n',binary_nbit);
   end   
end

% ********** Converting inputs imaginary part to binary **********
FID5 = fopen('fft_inputs_binary_imaginary.txt','w+');
for i=1 : 1 : N
   if (input_im(i)<0)
       temp = abs(input_im(i));
       binary_nbit = dec2bin(round(temp*2^n),n);
       fprintf(FID5,'1%s\n',binary_nbit);
   elseif (input_im(i)==0)
       fprintf(FID5,'000000000000\n');
   else
       binary_nbit = dec2bin(round(input_im(i)*2^n),n);
       fprintf(FID5,'0%s\n',binary_nbit);
   end   
end
%-------------------------------------------------------------------------------------


% ********** Reading coefficients **********
FID = fopen('fft_coefficients.txt','r');
coefficients=fscanf(FID,'%f');
for q=1 : 1 : N/2
   coeff_re(q) = coefficients(2*q-1);
   coeff_im(q) = coefficients(2*q);
end

%figure(1), clf;
%plot(coeff_re,coeff_im);

% '''''''''' Stage 1 '''''''''''''''''''''''''''''''''''''''''''''
% ********** Converting coefficient real part to binary **********
FID1 = fopen('stage_1_fft_coefficients_binary_real.txt','w+');
nbits = 10; % 12 bit words, 10 bits for fractions, 1 bit for signed, 1 bit for integer
for i=1 : 1 : N/8
    if (coeff_re(i)==1)
        fprintf(FID1,'regfileReg1(%u) <= "010000000000";\n',i-1);
    else
        binary_10bit = dec2bin(round(coeff_re(i)*2^nbits),nbits);
        fprintf(FID1,'regfileReg1(%u) <= "00%s";\n',i-1,binary_10bit);
    end
end

% ********** Converting coefficient imaginary part to binary **********
FID2 = fopen('stage_1_fft_coefficients_binary_imag.txt','w+');
nbits = 10; % 12 bit words, 10 bits for fractions, 1 bit for signed, 1 bit for integer
for i=1 : 1 : N/8
    temp = abs(coeff_im(i));
    if (temp==0)
        fprintf(FID2,'regfileReg2(%u) <= "000000000000";\n',i-1);
    else
        binary_10bit = dec2bin(round(temp*2^nbits),nbits);
        fprintf(FID2,'regfileReg2(%u) <= "10%s";\n',i-1,binary_10bit);
    end
end

% '''''''''' Stage 2 '''''''''''''''''''''''''''''''''''''''''''''
% ********** Converting coefficient real part to binary **********
FID12 = fopen('stage_2_fft_coefficients_binary_real.txt','w+');
nbits = 10; % 12 bit words, 10 bits for fractions, 1 bit for signed, 1 bit for integer
for i=1 : 2 : N/8
    if (coeff_re(i)==1)
        fprintf(FID12,'regfileReg1(%u) <= "010000000000";\n',i-((i+1)/2));
    else
        binary_10bit = dec2bin(round(coeff_re(i)*2^nbits),nbits);
        fprintf(FID12,'regfileReg1(%u) <= "00%s";\n',i-((i+1)/2),binary_10bit);
    end
end

% ********** Converting coefficient imaginary part to binary **********
FID22 = fopen('stage_2_fft_coefficients_binary_imag.txt','w+');
nbits = 10; % 12 bit words, 10 bits for fractions, 1 bit for signed, 1 bit for integer
for i=1 : 2 : N/8
    temp = abs(coeff_im(i));
    if (temp==0)
        fprintf(FID22,'regfileReg2(%u) <= "000000000000";\n',i-((i+1)/2));
    else
        binary_10bit = dec2bin(round(temp*2^nbits),nbits);
        fprintf(FID22,'regfileReg2(%u) <= "10%s";\n',i-((i+1)/2),binary_10bit);
    end
end

% '''''''''' Stage 3 '''''''''''''''''''''''''''''''''''''''''''''
% ********** Converting coefficient real part to binary **********
FID13 = fopen('stage_3_fft_coefficients_binary_real.txt','w+');
nbits = 10; % 12 bit words, 10 bits for fractions, 1 bit for signed, 1 bit for integer
a = 0;
for i=1 : 4 : N/8
    if (coeff_re(i)==1)
        fprintf(FID13,'regfileReg1(%u) <= "010000000000";\n',a);
    else
        binary_10bit = dec2bin(round(coeff_re(i)*2^nbits),nbits);
        fprintf(FID13,'regfileReg1(%u) <= "00%s";\n',a,binary_10bit);
    end
    a = a+1;
end

% ********** Converting coefficient imaginary part to binary **********
FID23 = fopen('stage_3_fft_coefficients_binary_imag.txt','w+');
nbits = 10; % 12 bit words, 10 bits for fractions, 1 bit for signed, 1 bit for integer
a = 0;
for i=1 : 4 : N/8
    temp = abs(coeff_im(i));
    if (temp==0)
        fprintf(FID23,'regfileReg2(%u) <= "000000000000";\n',a);
    else
        binary_10bit = dec2bin(round(temp*2^nbits),nbits);
        fprintf(FID23,'regfileReg2(%u) <= "10%s";\n',a,binary_10bit);
    end
    a = a+1;
end


% '''''''''' Stage 4 '''''''''''''''''''''''''''''''''''''''''''''
% ********** Converting coefficient real part to binary **********
FID14 = fopen('stage_4_fft_coefficients_binary_real.txt','w+');
nbits = 10; % 12 bit words, 10 bits for fractions, 1 bit for signed, 1 bit for integer
a = 0;
for i=1 : 8 : N/8
    if (coeff_re(i)==1)
        fprintf(FID14,'regfileReg1(%u) <= "010000000000";\n',a);
    else
        binary_10bit = dec2bin(round(coeff_re(i)*2^nbits),nbits);
        fprintf(FID14,'regfileReg1(%u) <= "00%s";\n',a,binary_10bit);
    end
    a = a+1;
end

% ********** Converting coefficient imaginary part to binary **********
FID24 = fopen('stage_4_fft_coefficients_binary_imag.txt','w+');
nbits = 10; % 12 bit words, 10 bits for fractions, 1 bit for signed, 1 bit for integer
a = 0;
for i=1 : 8 : N/8
    temp = abs(coeff_im(i));
    if (temp==0)
        fprintf(FID24,'regfileReg2(%u) <= "000000000000";\n',a);
    else
        binary_10bit = dec2bin(round(temp*2^nbits),nbits);
        fprintf(FID24,'regfileReg2(%u) <= "10%s";\n',a,binary_10bit);
    end
    a = a+1;
end


% '''''''''' Stage 5 '''''''''''''''''''''''''''''''''''''''''''''
% ********** Converting coefficient real part to binary **********
FID15 = fopen('stage_5_fft_coefficients_binary_real.txt','w+');
nbits = 10; % 12 bit words, 10 bits for fractions, 1 bit for signed, 1 bit for integer
a = 0;
for i=1 : 16 : N/8
    if (coeff_re(i)==1)
        fprintf(FID15,'regfileReg1(%u) <= "010000000000";\n',a);
    else
        binary_10bit = dec2bin(round(coeff_re(i)*2^nbits),nbits);
        fprintf(FID15,'regfileReg1(%u) <= "00%s";\n',a,binary_10bit);
    end
    a = a+1;
end

% ********** Converting coefficient imaginary part to binary **********
FID25 = fopen('stage_5_fft_coefficients_binary_imag.txt','w+');
nbits = 10; % 12 bit words, 10 bits for fractions, 1 bit for signed, 1 bit for integer
a = 0;
for i=1 : 16 : N/8
    temp = abs(coeff_im(i));
    if (temp==0)
        fprintf(FID25,'regfileReg2(%u) <= "000000000000";\n',a);
    else
        binary_10bit = dec2bin(round(temp*2^nbits),nbits);
        fprintf(FID25,'regfileReg2(%u) <= "10%s";\n',a,binary_10bit);
    end
    a = a+1;
end


% '''''''''' Stage 6 '''''''''''''''''''''''''''''''''''''''''''''
% ********** Converting coefficient real part to binary **********
FID16 = fopen('stage_6_fft_coefficients_binary_real.txt','w+');
nbits = 10; % 12 bit words, 10 bits for fractions, 1 bit for signed, 1 bit for integer
a = 0;
for i=1 : 32 : N/8
    if (coeff_re(i)==1)
        fprintf(FID16,'regfileReg1(%u) <= "010000000000";\n',a);
    else
        binary_10bit = dec2bin(round(coeff_re(i)*2^nbits),nbits);
        fprintf(FID16,'regfileReg1(%u) <= "00%s";\n',a,binary_10bit);
    end
    a = a+1;
end

% ********** Converting coefficient imaginary part to binary **********
FID26 = fopen('stage_6_fft_coefficients_binary_imag.txt','w+');
nbits = 10; % 12 bit words, 10 bits for fractions, 1 bit for signed, 1 bit for integer
a = 0;
for i=1 : 32 : N/8
    temp = abs(coeff_im(i));
    if (temp==0)
        fprintf(FID26,'regfileReg2(%u) <= "000000000000";\n',a);
    else
        binary_10bit = dec2bin(round(temp*2^nbits),nbits);
        fprintf(FID26,'regfileReg2(%u) <= "10%s";\n',a,binary_10bit);
    end
    a = a+1;
end


% '''''''''' Stage 7 '''''''''''''''''''''''''''''''''''''''''''''
% ********** Converting coefficient real part to binary **********
FID17 = fopen('stage_7_fft_coefficients_binary_real.txt','w+');
nbits = 10; % 12 bit words, 10 bits for fractions, 1 bit for signed, 1 bit for integer
a = 0;
for i=1 : 64 : N/8
    if (coeff_re(i)==1)
        fprintf(FID17,'regfileReg1(%u) <= "010000000000";\n',a);
    else
        binary_10bit = dec2bin(round(coeff_re(i)*2^nbits),nbits);
        fprintf(FID17,'regfileReg1(%u) <= "00%s";\n',a,binary_10bit);
    end
    a = a+1;
end

% ********** Converting coefficient imaginary part to binary **********
FID27 = fopen('stage_7_fft_coefficients_binary_imag.txt','w+');
nbits = 10; % 12 bit words, 10 bits for fractions, 1 bit for signed, 1 bit for integer
a = 0;
for i=1 : 64 : N/8
    temp = abs(coeff_im(i));
    if (temp==0)
        fprintf(FID27,'regfileReg2(%u) <= "000000000000";\n',a);
    else
        binary_10bit = dec2bin(round(temp*2^nbits),nbits);
        fprintf(FID27,'regfileReg2(%u) <= "10%s";\n',a,binary_10bit);
    end
    a = a+1;
end


% '''''''''' Stage 8 '''''''''''''''''''''''''''''''''''''''''''''
% ********** Converting coefficient real part to binary **********
FID18 = fopen('stage_8_fft_coefficients_binary_real.txt','w+');
nbits = 10; % 12 bit words, 10 bits for fractions, 1 bit for signed, 1 bit for integer
a = 0;
for i=1 : 128 : N/8
    if (coeff_re(i)==1)
        fprintf(FID18,'regfileReg1(%u) <= "010000000000";\n',a);
    else
        binary_10bit = dec2bin(round(coeff_re(i)*2^nbits),nbits);
        fprintf(FID18,'regfileReg1(%u) <= "00%s";\n',a,binary_10bit);
    end
    a = a+1;
end

% ********** Converting coefficient imaginary part to binary **********
FID28 = fopen('stage_8_fft_coefficients_binary_imag.txt','w+');
nbits = 10; % 12 bit words, 10 bits for fractions, 1 bit for signed, 1 bit for integer
a = 0;
for i=1 : 128 : N/8
    temp = abs(coeff_im(i));
    if (temp==0)
        fprintf(FID28,'regfileReg2(%u) <= "000000000000";\n',a);
    else
        binary_10bit = dec2bin(round(temp*2^nbits),nbits);
        fprintf(FID28,'regfileReg2(%u) <= "10%s";\n',a,binary_10bit);
    end
    a = a+1;
end

% '''''''''' Stage 9 '''''''''''''''''''''''''''''''''''''''''''''
% ********** Converting coefficient real part to binary **********
FID19 = fopen('stage_9_fft_coefficients_binary_real.txt','w+');
nbits = 10; % 12 bit words, 10 bits for fractions, 1 bit for signed, 1 bit for integer
a = 0;
for i=1 : 256 : N/8
    if (coeff_re(i)==1)
        fprintf(FID19,'regfileReg1(%u) <= "010000000000";\n',a);
    else
        binary_10bit = dec2bin(round(coeff_re(i)*2^nbits),nbits);
        fprintf(FID19,'regfileReg1(%u) <= "00%s";\n',a,binary_10bit);
    end
    a = a+1;
end

% ********** Converting coefficient imaginary part to binary **********
FID29 = fopen('stage_9_fft_coefficients_binary_imag.txt','w+');
nbits = 10; % 12 bit words, 10 bits for fractions, 1 bit for signed, 1 bit for integer
a = 0;
for i=1 : 256 : N/8
    temp = abs(coeff_im(i));
    if (temp==0)
        fprintf(FID29,'regfileReg2(%u) <= "000000000000";\n',a);
    else
        binary_10bit = dec2bin(round(temp*2^nbits),nbits);
        fprintf(FID29,'regfileReg2(%u) <= "10%s";\n',a,binary_10bit);
    end
    a = a+1;
end

fclose('all');