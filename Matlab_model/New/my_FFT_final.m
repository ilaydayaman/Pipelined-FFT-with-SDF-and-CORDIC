function [mult_out_re, mult_out_im] = my_FFT_final(coefficients, input_re,input_im, N)

s = 1;
% ********** File operation **********
% Reading coefficients
for q=1 : 1 : N/2
   coeff_re(q) = coefficients(2*q-1);
   coeff_im(q) = coefficients(2*q);
end 

% ********** FFT Parameters **********
WIDTH = N/2;
% ********** INITIALIZE **********
T = '0';
S = '1';

coeff_re_temp = coeff_re;
coeff_im_temp = coeff_im;

% ********** STAGE 1 **********
 w1 = 12; % word length
 f1 = 9; % fraction length
 w2 = 12; % word length after mult
 f2 = 9; % fraction length
 
% inputs should be reversed when putting into registers 
% since FIFO approach is used
for q = 1 : 1 : WIDTH
    R_re(q) = input_re(WIDTH - q +1);
    R_im(q) = input_im(WIDTH - q +1);
end 

for i=1 : 1 : N
    if( i < ( N - WIDTH ) + 1)
        serial_in_re = input_re( i + WIDTH);
        serial_in_im = input_im( i + WIDTH);
    else 
        serial_in_re = 0;
        serial_in_im = 0;
    end
    
    [bf_sum_re(i),bf_sub_re(i)] = my_butterfly(R_re(WIDTH),serial_in_re);
    [bf_sum_im(i),bf_sub_im(i)] = my_butterfly(R_im(WIDTH),serial_in_im);
    
    % fixed point implementation
    bf_sum_re_1_f(i) = fi(bf_sum_re(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sum_im_1_f(i) = fi(bf_sum_im(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sub_re_1_f(i) = fi(bf_sub_re(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sub_im_1_f(i) = fi(bf_sub_im(i),s,w1,f1,'RoundingMethod', 'Floor');

    % Testing for rouding error
%     bf_sum_re_1_f(i) = bf_sum_re(i)
%     bf_sum_im_1_f(i) = bf_sum_im(i);
%     bf_sub_re_1_f(i) = bf_sub_re(i);
%     bf_sub_im_1_f(i) = bf_sub_im(i);
    
    if( T == '1' )
        Register_in_re = serial_in_re;
        Register_in_im = serial_in_im;
    else 
        Register_in_re = bf_sub_re_1_f(i);
        Register_in_im = bf_sub_im_1_f(i);
    end 
    
    if( S == '0' )
        mult_in_re = R_re(WIDTH);
        mult_in_im = R_im(WIDTH);
        mult_out_re1_f(i) = mult_in_re * coeff_re_temp(i-WIDTH);
        mult_out_re2_f(i) = mult_in_im * coeff_im_temp(i-WIDTH);
        mult_out_1_re(i) = fi(mult_out_re1_f(i),s,w2,f2,'RoundingMethod', 'Floor') - fi(mult_out_re2_f(i),s,w2,f2,'RoundingMethod', 'Floor');
        %mult_out_1_re(i) = fi(mult_out_re_f(i),s,w2,f2,'RoundingMethod', 'Floor');
        mult_out_im1_f(i) = mult_in_im * coeff_re_temp(i-WIDTH);
        mult_out_im2_f(i) = mult_in_re * coeff_im_temp(i-WIDTH);
        mult_out_1_im(i) = fi(mult_out_im1_f(i),s,w2,f2,'RoundingMethod', 'Floor') + fi(mult_out_im2_f(i),s,w2,f2,'RoundingMethod', 'Floor');
    else 
        mult_in_re = bf_sum_re_1_f(i);
        mult_in_im = bf_sum_im_1_f(i);
        mult_out_1_re(i) = mult_in_re;
        mult_out_1_im(i) = mult_in_im;
    end 
    
    for j = WIDTH - 1: -1: 1
        R_re(j+1) = R_re(j);
        R_im(j+1) = R_im(j);
    end 
    
    R_re(1) = Register_in_re;
    R_im(1) = Register_in_im;
    
    if( mod(i,WIDTH) == 0 )
        if(T == '0')
            T = '1';
        else 
            T = '0';
        end 
        
        if(S == '0')
            S = '1';
        else 
            S = '0';
        end 
    end
   
   %Testing for rouding error
   %mult_out_1_re_f(i) = fi(mult_out_1_re(i),s,w1,f1)
   %mult_out_1_im_f(i) = fi(mult_out_1_im(i),s,w1,f1);
end

% Converting to binary

state1_output = mult_out_1_re;
FID10 = fopen('fft_stage1output_binary.txt','w+');
FID11 = fopen('fft_stage1output.txt','w+');
n = f2; % number of fractinonal bits
for i = 1 : 1 : 2048    
    fprintf(FID11,'%.9f\n',state1_output(i));
    if (state1_output(i)<0)
       temp = abs(state1_output(i));
       temp2 = dec2bin(round(temp*2^n),n);
       temp3 = pad(temp2,12,'left','0');
       temp4 = not(temp3-'0');
       temp5 = num2str(temp4);
       binary_nbit = dec2bin(bin2dec(temp5)+bin2dec('1'));
       fprintf(FID10,'%s\n',binary_nbit);
   elseif (state1_output(i)==0)
       fprintf(FID10,'000000000000\n');
    elseif (state1_output(i)<1)
       binary_nbit = dec2bin(round(state1_output(i)*2^n),n);
       fprintf(FID10,'000%s\n',binary_nbit);
   else
       binary_nbit = dec2bin(round(state1_output(i)*2^n),n);
       fprintf(FID10,'00%s\n',binary_nbit);
   end    
end
fclose(FID10);
fclose(FID11);
%plot(state1_output);

state1_output = mult_out_1_im;
FID10 = fopen('fft_stage1output_binary_imaginary.txt','w+');
FID11 = fopen('fft_stage1output_imaginary.txt','w+');
n = f2; % number of fractinonal bits
for i = 1 : 1 : 2048    
    fprintf(FID11,'%.10f\n',state1_output(i));
    if (state1_output(i)<0)
       temp = abs(state1_output(i));
       temp2 = dec2bin(round(temp*2^n),n);
       temp3 = pad(temp2,12,'left','0');
       temp4 = not(temp3-'0');
       temp5 = num2str(temp4);
       binary_nbit = dec2bin(bin2dec(temp5)+bin2dec('1'));
       fprintf(FID10,'%s\n',binary_nbit);
   elseif (state1_output(i)==0)
       fprintf(FID10,'000000000000\n');
   else
       temp = dec2bin(round(state1_output(i)*2^n),n);
       binary_nbit = pad(temp,12,'left','0');
       fprintf(FID10,'%s\n',binary_nbit);
   end    
end
fclose(FID10);
fclose(FID11);

% % ********** STAGE 2 **********
w1 = 13; % word length
f1 = 9; % fraction length
w2 = 13; % word length after mult
f2 = 9; % fraction length

WIDTH = WIDTH/2;
INDEX = 1;

for i = 1 : 1: WIDTH
    R_re(i) = mult_out_1_re(WIDTH - i +1);
    R_im(i) = mult_out_1_im(WIDTH - i +1);
    coeff_re_temp(i) = coeff_re_temp(2*i-1);
    coeff_im_temp(i) = coeff_im_temp(2*i-1);
end 

for i=1 : 1 : N
    if( i < ( N - WIDTH ) + 1 )
        serial_in_re = mult_out_1_re( i + WIDTH);
        serial_in_im = mult_out_1_im( i + WIDTH);
    else 
        serial_in_re = 0;
        serial_in_im = 0;
    end
    [bf_sum_re(i),bf_sub_re(i)] = my_butterfly(R_re(WIDTH),serial_in_re);
    [bf_sum_im(i),bf_sub_im(i)] = my_butterfly(R_im(WIDTH),serial_in_im);
    
    % fixed point implementation
    bf_sum_re_2_f(i) = fi(bf_sum_re(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sum_im_2_f(i) = fi(bf_sum_im(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sub_re_2_f(i) = fi(bf_sub_re(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sub_im_2_f(i) = fi(bf_sub_im(i),s,w1,f1,'RoundingMethod', 'Floor');
    
    if( T == '1' )
        Register_in_re = serial_in_re;
        Register_in_im = serial_in_im;
    else 
        Register_in_re = bf_sub_re_2_f(i);
        Register_in_im = bf_sub_im_2_f(i);
    end 
   
    if(INDEX > WIDTH)
        INDEX = INDEX - WIDTH;
    end  
    
    if( S == '0' )
        mult_in_re = R_re(WIDTH);
        mult_in_im = R_im(WIDTH);
%         mult_out_re_f(i) = mult_in_re * coeff_re_temp(INDEX) -  mult_in_im * coeff_im_temp(INDEX);
%         mult_out_2_re(i) = fi(mult_out_re_f(i),s,w2,f2,'RoundingMethod', 'Floor');
%         mult_out_im_f(i) = mult_in_im * coeff_re_temp(INDEX) +  mult_in_re * coeff_im_temp(INDEX);
%         mult_out_2_im(i) = fi(mult_out_im_f(i),s,w2,f2,'RoundingMethod', 'Floor');
        mult_out_re1_f(i) = mult_in_re * coeff_re_temp(INDEX);
        mult_out_re2_f(i) = mult_in_im * coeff_im_temp(INDEX);
        mult_out_2_re(i) = fi(mult_out_re1_f(i),s,w2,f2,'RoundingMethod', 'Floor') - fi(mult_out_re2_f(i),s,w2,f2,'RoundingMethod', 'Floor');
        mult_out_im1_f(i) = mult_in_im * coeff_re_temp(INDEX);
        mult_out_im2_f(i) = mult_in_re * coeff_im_temp(INDEX);
        mult_out_2_im(i) = fi(mult_out_im1_f(i),s,w2,f2,'RoundingMethod', 'Floor') + fi(mult_out_im2_f(i),s,w2,f2,'RoundingMethod', 'Floor');
    else 
        mult_in_re = bf_sum_re_2_f(i);
        mult_in_im = bf_sum_im_2_f(i);
        mult_out_2_re(i) = mult_in_re;
        mult_out_2_im(i) = mult_in_im;
    end 

    INDEX = INDEX +1;

    if( mod(i,WIDTH) == 0 )
        if(T == '0')
            T = '1';
        else 
            T = '0';
        end 

        if(S == '0')
            S = '1';
        else 
            S = '0';
        end 
    end   

    if(WIDTH>1)
        for j = WIDTH-1  : -1 : 1
            R_re(j+1) = R_re(j);
            R_im(j+1) = R_im(j);
        end 
    end 

R_re(1) = Register_in_re;
R_im(1) = Register_in_im;

end
    
% Converting to binary
state2_output = mult_out_2_re;
FID10 = fopen('fft_stage2output_binary.txt','w+');
FID11 = fopen('fft_stage2output.txt','w+');
n = f2; % number of fractinonal bits
for i = 1 : 1 : 2048    
    fprintf(FID11,'%.10f\n',state2_output(i));
    if (state2_output(i)<0)
       temp = abs(state2_output(i));
       temp2 = dec2bin(round(temp*2^n),n);
       temp3 = pad(temp2,13,'left','0');
       temp4 = not(temp3-'0');
       temp5 = num2str(temp4);
       binary_nbit = dec2bin(bin2dec(temp5)+bin2dec('1'));
       fprintf(FID10,'%s\n',binary_nbit);
   elseif (state2_output(i)==0)
       fprintf(FID10,'0000000000000\n');
    elseif (state2_output(i)<1)
       binary_nbit = dec2bin(round(state2_output(i)*2^n),n);
       fprintf(FID10,'0000%s\n',binary_nbit);
    elseif (state2_output(i)<2)
       binary_nbit = dec2bin(round(state2_output(i)*2^n),n);
       fprintf(FID10,'000%s\n',binary_nbit);
   else
       binary_nbit = dec2bin(round(state2_output(i)*2^n),n);
       fprintf(FID10,'00%s\n',binary_nbit);
   end    
end
fclose(FID10);
fclose(FID11);

state_output = mult_out_2_im;
FID10 = fopen('fft_stage2output_binary_imaginary.txt','w+');
FID11 = fopen('fft_stage2output_imaginary.txt','w+');
n = f2; % number of fractinonal bits
for i = 1 : 1 : 2048    
    fprintf(FID11,'%.10f\n',state_output(i));
    if (state_output(i)<0)
       temp = abs(state_output(i));
       temp2 = dec2bin(round(temp*2^n),n);
       temp3 = pad(temp2,13,'left','0');
       temp4 = not(temp3-'0');
       temp5 = num2str(temp4);
       binary_nbit = dec2bin(bin2dec(temp5)+bin2dec('1'));
       fprintf(FID10,'%s\n',binary_nbit);
   elseif (state_output(i)==0)
       fprintf(FID10,'0000000000000\n');
   else
       temp = dec2bin(round(state_output(i)*2^n),n);
       binary_nbit = pad(temp,13,'left','0');
       fprintf(FID10,'%s\n',binary_nbit);
   end    
end
fclose(FID10);
fclose(FID11);


% ********** STAGE 3 **********
w1 = 14; % word length
f1 = 9; % fraction length
w2 = 14; % word length after mult
f2 = 9; % fraction length

WIDTH = WIDTH/2;
INDEX = 1;

for i = 1 : 1: WIDTH
    R_re(i) = mult_out_2_re(WIDTH - i +1);
    R_im(i) = mult_out_2_im(WIDTH - i +1);
    coeff_re_temp(i) = coeff_re_temp(2*i-1);
    coeff_im_temp(i) = coeff_im_temp(2*i-1);
end 

for i=1 : 1 : N
    if( i < ( N - WIDTH ) + 1 )
        serial_in_re = mult_out_2_re( i + WIDTH);
        serial_in_im = mult_out_2_im( i + WIDTH);
    else 
        serial_in_re = 0;
        serial_in_im = 0;
    end
    [bf_sum_re(i),bf_sub_re(i)] = my_butterfly(R_re(WIDTH),serial_in_re);
    [bf_sum_im(i),bf_sub_im(i)] = my_butterfly(R_im(WIDTH),serial_in_im);
    
    % fixed point implementation
    bf_sum_re_3_f(i) = fi(bf_sum_re(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sum_im_3_f(i) = fi(bf_sum_im(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sub_re_3_f(i) = fi(bf_sub_re(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sub_im_3_f(i) = fi(bf_sub_im(i),s,w1,f1,'RoundingMethod', 'Floor');
    
    if( T == '1' )
        Register_in_re = serial_in_re;
        Register_in_im = serial_in_im;
    else 
        Register_in_re = bf_sub_re_3_f(i);
        Register_in_im = bf_sub_im_3_f(i);
    end 
   
    if(INDEX > WIDTH)
        INDEX = INDEX - WIDTH;
    end  
    
    if( S == '0' )
        mult_in_re = R_re(WIDTH);
        mult_in_im = R_im(WIDTH);
        mult_out_re1_f(i) = mult_in_re * coeff_re_temp(INDEX);
        mult_out_re2_f(i) = mult_in_im * coeff_im_temp(INDEX);
        mult_out_3_re(i) = fi(mult_out_re1_f(i),s,w2,f2,'RoundingMethod', 'Floor') - fi(mult_out_re2_f(i),s,w2,f2,'RoundingMethod', 'Floor');
        mult_out_im1_f(i) = mult_in_im * coeff_re_temp(INDEX);
        mult_out_im2_f(i) = mult_in_re * coeff_im_temp(INDEX);
        mult_out_3_im(i) = fi(mult_out_im1_f(i),s,w2,f2,'RoundingMethod', 'Floor') + fi(mult_out_im2_f(i),s,w2,f2,'RoundingMethod', 'Floor');
    
    else 
        mult_in_re = bf_sum_re_3_f(i);
        mult_in_im = bf_sum_im_3_f(i);
        mult_out_3_re(i) = mult_in_re;
        mult_out_3_im(i) = mult_in_im;
    end 

    INDEX = INDEX +1;

    if( mod(i,WIDTH) == 0 )
        if(T == '0')
            T = '1';
        else 
            T = '0';
        end 

        if(S == '0')
            S = '1';
        else 
            S = '0';
        end 
    end   

    if(WIDTH>1)
        for j = WIDTH-1  : -1 : 1
            R_re(j+1) = R_re(j);
            R_im(j+1) = R_im(j);
        end 
    end 

R_re(1) = Register_in_re;
R_im(1) = Register_in_im;
end

% Converting to binary
state3_output = mult_out_3_re;
FID10 = fopen('fft_stage3output_binary.txt','w+');
FID11 = fopen('fft_stage3output.txt','w+');
n = f2; % number of fractinonal bits
for i = 1 : 1 : 2048    
    fprintf(FID11,'%.10f\n',state3_output(i));
    if (state3_output(i)<0)
       temp = abs(state3_output(i));
       temp2 = dec2bin(round(temp*2^n),n);
       temp3 = pad(temp2,14,'left','0');
       temp4 = not(temp3-'0');
       temp5 = num2str(temp4);
       binary_nbit = dec2bin(bin2dec(temp5)+bin2dec('1'));
       fprintf(FID10,'%s\n',binary_nbit);
   elseif (state3_output(i)==0)
       fprintf(FID10,'00000000000000\n');
   else
       temp = dec2bin(round(state3_output(i)*2^n),n);
       binary_nbit = pad(temp,14,'left','0');
       fprintf(FID10,'%s\n',binary_nbit);
   end    
end
fclose(FID10);
fclose(FID11);

state_output = mult_out_3_im;
FID10 = fopen('fft_stage3output_binary_imaginary.txt','w+');
FID11 = fopen('fft_stage3output_imaginary.txt','w+');
n = f2; % number of fractinonal bits
for i = 1 : 1 : 2048    
    fprintf(FID11,'%.10f\n',state_output(i));
    if (state_output(i)<0)
       temp = abs(state_output(i));
       temp2 = dec2bin(round(temp*2^n),n);
       temp3 = pad(temp2,14,'left','0');
       temp4 = not(temp3-'0');
       temp5 = num2str(temp4);
       binary_nbit = dec2bin(bin2dec(temp5)+bin2dec('1'));
       fprintf(FID10,'%s\n',binary_nbit);
   elseif (state_output(i)==0)
       fprintf(FID10,'00000000000000\n');
   else
       temp = dec2bin(round(state_output(i)*2^n),n);
       binary_nbit = pad(temp,14,'left','0');
       fprintf(FID10,'%s\n',binary_nbit);
   end    
end
fclose(FID10);
fclose(FID11);



% % ********** STAGE 4 **********
w1 = 14; % word length
f1 = 8; % fraction length
w2 = 14; % word length after mult
f2 = 8; % fraction length

WIDTH = WIDTH/2;
INDEX = 1;

for i = 1 : 1: WIDTH
    R_re(i) = mult_out_3_re(WIDTH - i +1);
    R_im(i) = mult_out_3_im(WIDTH - i +1);
    coeff_re_temp(i) = coeff_re_temp(2*i-1);
    coeff_im_temp(i) = coeff_im_temp(2*i-1);
end 

for i=1 : 1 : N
    if( i < ( N - WIDTH ) + 1 )
        serial_in_re = mult_out_3_re( i + WIDTH);
        serial_in_im = mult_out_3_im( i + WIDTH);
    else 
        serial_in_re = 0;
        serial_in_im = 0;
    end
    [bf_sum_re(i),bf_sub_re(i)] = my_butterfly(R_re(WIDTH),serial_in_re);
    [bf_sum_im(i),bf_sub_im(i)] = my_butterfly(R_im(WIDTH),serial_in_im);

    % fixed point implementation
    bf_sum_re_4_f(i) = fi(bf_sum_re(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sum_im_4_f(i) = fi(bf_sum_im(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sub_re_4_f(i) = fi(bf_sub_re(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sub_im_4_f(i) = fi(bf_sub_im(i),s,w1,f1,'RoundingMethod', 'Floor');
    
    if( T == '1' )
        Register_in_re = serial_in_re;
        Register_in_im = serial_in_im;
    else 
        Register_in_re = bf_sub_re_4_f(i);
        Register_in_im = bf_sub_im_4_f(i);
    end 
   
    if(INDEX > WIDTH)
        INDEX = INDEX - WIDTH;
    end  
    
    if( S == '0' )
        mult_in_re = R_re(WIDTH);
        mult_in_im = R_im(WIDTH);
        mult_out_re1_f(i) = mult_in_re * coeff_re_temp(INDEX);
        mult_out_re2_f(i) = mult_in_im * coeff_im_temp(INDEX);
        mult_out_4_re(i) = fi(mult_out_re1_f(i),s,w2,f2,'RoundingMethod', 'Floor') - fi(mult_out_re2_f(i),s,w2,f2,'RoundingMethod', 'Floor');
        mult_out_im1_f(i) = mult_in_im * coeff_re_temp(INDEX);
        mult_out_im2_f(i) = mult_in_re * coeff_im_temp(INDEX);
        mult_out_4_im(i) = fi(mult_out_im1_f(i),s,w2,f2,'RoundingMethod', 'Floor') + fi(mult_out_im2_f(i),s,w2,f2,'RoundingMethod', 'Floor');
    else 
        mult_in_re = bf_sum_re_4_f(i);
        mult_in_im = bf_sum_im_4_f(i);
        mult_out_4_re(i) = mult_in_re;
        mult_out_4_im(i) = mult_in_im;
    end 

    INDEX = INDEX +1;

    if( mod(i,WIDTH) == 0 )
        if(T == '0')
            T = '1';
        else 
            T = '0';
        end 

        if(S == '0')
            S = '1';
        else 
            S = '0';
        end 
    end   

    if(WIDTH>1)
        for j = WIDTH-1  : -1 : 1
            R_re(j+1) = R_re(j);
            R_im(j+1) = R_im(j);
        end 
    end 

R_re(1) = Register_in_re;
R_im(1) = Register_in_im;
end

% Converting to binary
state_output = mult_out_4_re;
FID10 = fopen('fft_stage4output_binary.txt','w+');
FID11 = fopen('fft_stage4output.txt','w+');
n = f2; % number of fractinonal bits
for i = 1 : 1 : 2048    
    fprintf(FID11,'%.10f\n',state_output(i));
    if (state_output(i)<0)
       temp = abs(state_output(i));
       temp2 = dec2bin(round(temp*2^n),n);
       temp3 = pad(temp2,14,'left','0');
       temp4 = not(temp3-'0');
       temp5 = num2str(temp4);
       binary_nbit = dec2bin(bin2dec(temp5)+bin2dec('1'));
       fprintf(FID10,'%s\n',binary_nbit);
   elseif (state_output(i)==0)
       fprintf(FID10,'00000000000000\n');
   else
       temp = dec2bin(round(state_output(i)*2^n),n);
       binary_nbit = pad(temp,14,'left','0');
       fprintf(FID10,'%s\n',binary_nbit);
   end    
end
fclose(FID10);
fclose(FID11);

state_output = mult_out_4_im;
FID10 = fopen('fft_stage4output_binary_imaginary.txt','w+');
FID11 = fopen('fft_stage4output_imaginary.txt','w+');
n = f2; % number of fractinonal bits
for i = 1 : 1 : 2048    
    fprintf(FID11,'%.10f\n',state_output(i));
    if (state_output(i)<0)
       temp = abs(state_output(i));
       temp2 = dec2bin(round(temp*2^n),n);
       temp3 = pad(temp2,14,'left','0');
       temp4 = not(temp3-'0');
       temp5 = num2str(temp4);
       binary_nbit = dec2bin(bin2dec(temp5)+bin2dec('1'));
       fprintf(FID10,'%s\n',binary_nbit);
   elseif (state_output(i)==0)
       fprintf(FID10,'00000000000000\n');
   else
       temp = dec2bin(round(state_output(i)*2^n),n);
       binary_nbit = pad(temp,14,'left','0');
       fprintf(FID10,'%s\n',binary_nbit);
   end    
end
fclose(FID10);
fclose(FID11);

% ********** STAGE 5 **********
w1 = 15; % word length
f1 = 8; % fraction length
w2 = 15; % word length after mult
f2 = 8; % fraction length

WIDTH = WIDTH/2;
INDEX = 1;

for i = 1 : 1: WIDTH
    R_re(i) = mult_out_4_re(WIDTH - i +1);
    R_im(i) = mult_out_4_im(WIDTH - i +1);
    coeff_re_temp(i) = coeff_re_temp(2*i-1);
    coeff_im_temp(i) = coeff_im_temp(2*i-1);
end 

for i=1 : 1 : N
    if( i < ( N - WIDTH ) + 1 )
        serial_in_re = mult_out_4_re( i + WIDTH);
        serial_in_im = mult_out_4_im( i + WIDTH);
    else 
        serial_in_re = 0;
        serial_in_im = 0;
    end
    [bf_sum_re(i),bf_sub_re(i)] = my_butterfly(R_re(WIDTH),serial_in_re);
    [bf_sum_im(i),bf_sub_im(i)] = my_butterfly(R_im(WIDTH),serial_in_im);

    % fixed point implementation
    bf_sum_re_5_f(i) = fi(bf_sum_re(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sum_im_5_f(i) = fi(bf_sum_im(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sub_re_5_f(i) = fi(bf_sub_re(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sub_im_5_f(i) = fi(bf_sub_im(i),s,w1,f1,'RoundingMethod', 'Floor');
    
    if( T == '1' )
        Register_in_re = serial_in_re;
        Register_in_im = serial_in_im;
    else 
        Register_in_re = bf_sub_re_5_f(i);
        Register_in_im = bf_sub_im_5_f(i);
    end 
   
    if(INDEX > WIDTH)
        INDEX = INDEX - WIDTH;
    end  
    
    if( S == '0' )
        mult_in_re = R_re(WIDTH);
        mult_in_im = R_im(WIDTH);
        mult_out_re1_f(i) = mult_in_re * coeff_re_temp(INDEX);
        mult_out_re2_f(i) = mult_in_im * coeff_im_temp(INDEX);
        mult_out_5_re(i) = fi(mult_out_re1_f(i),s,w2,f2,'RoundingMethod', 'Floor') - fi(mult_out_re2_f(i),s,w2,f2,'RoundingMethod', 'Floor');
        mult_out_im1_f(i) = mult_in_im * coeff_re_temp(INDEX);
        mult_out_im2_f(i) = mult_in_re * coeff_im_temp(INDEX);
        mult_out_5_im(i) = fi(mult_out_im1_f(i),s,w2,f2,'RoundingMethod', 'Floor') + fi(mult_out_im2_f(i),s,w2,f2,'RoundingMethod', 'Floor');
    else 
        mult_in_re = bf_sum_re_5_f(i);
        mult_in_im = bf_sum_im_5_f(i);
        mult_out_5_re(i) = mult_in_re;
        mult_out_5_im(i) = mult_in_im;
    end 

    INDEX = INDEX +1;

    if( mod(i,WIDTH) == 0 )
        if(T == '0')
            T = '1';
        else 
            T = '0';
        end 

        if(S == '0')
            S = '1';
        else 
            S = '0';
        end 
    end   

    if(WIDTH>1)
        for j = WIDTH-1  : -1 : 1
            R_re(j+1) = R_re(j);
            R_im(j+1) = R_im(j);
        end 
    end 

R_re(1) = Register_in_re;
R_im(1) = Register_in_im;
end

% Converting to binary
state_output = mult_out_5_re;
FID10 = fopen('fft_stage5output_binary.txt','w+');
FID11 = fopen('fft_stage5output.txt','w+');
n = f2; % number of fractinonal bits
for i = 1 : 1 : 2048    
    fprintf(FID11,'%.10f\n',state_output(i));
    if (state_output(i)<0)
       temp = abs(state_output(i));
       temp2 = dec2bin(round(temp*2^n),n);
       temp3 = pad(temp2,15,'left','0');
       temp4 = not(temp3-'0');
       temp5 = num2str(temp4);
       binary_nbit = dec2bin(bin2dec(temp5)+bin2dec('1'));
       fprintf(FID10,'%s\n',binary_nbit);
   elseif (state_output(i)==0)
       fprintf(FID10,'000000000000000\n');
   else
       temp = dec2bin(round(state_output(i)*2^n),n);
       binary_nbit = pad(temp,15,'left','0');
       fprintf(FID10,'%s\n',binary_nbit);
   end    
end
fclose(FID10);
fclose(FID11);

state_output = mult_out_5_im;
FID10 = fopen('fft_stage5output_binary_imaginary.txt','w+');
FID11 = fopen('fft_stage5output_imaginary.txt','w+');
n = f2; % number of fractinonal bits
for i = 1 : 1 : 2048    
    fprintf(FID11,'%.10f\n',state_output(i));
    if (state_output(i)<0)
       temp = abs(state_output(i));
       temp2 = dec2bin(round(temp*2^n),n);
       temp3 = pad(temp2,15,'left','0');
       temp4 = not(temp3-'0');
       temp5 = num2str(temp4);
       binary_nbit = dec2bin(bin2dec(temp5)+bin2dec('1'));
       fprintf(FID10,'%s\n',binary_nbit);
   elseif (state_output(i)==0)
       fprintf(FID10,'000000000000000\n');
   else
       temp = dec2bin(round(state_output(i)*2^n),n);
       binary_nbit = pad(temp,15,'left','0');
       fprintf(FID10,'%s\n',binary_nbit);
   end    
end
fclose(FID10);
fclose(FID11);

% ********** STAGE 6 **********
w1 = 15; % word length
f1 = 7; % fraction length
w2 = 15; % word length after mult
f2 = 7; % fraction length

WIDTH = WIDTH/2;
INDEX = 1;

for i = 1 : 1: WIDTH
    R_re(i) = mult_out_5_re(WIDTH - i +1);
    R_im(i) = mult_out_5_im(WIDTH - i +1);
    coeff_re_temp(i) = coeff_re_temp(2*i-1);
    coeff_im_temp(i) = coeff_im_temp(2*i-1);
end 

for i=1 : 1 : N
    if( i < ( N - WIDTH ) + 1 )
        serial_in_re = mult_out_5_re( i + WIDTH);
        serial_in_im = mult_out_5_im( i + WIDTH);
    else 
        serial_in_re = 0;
        serial_in_im = 0;
    end
    [bf_sum_re(i),bf_sub_re(i)] = my_butterfly(R_re(WIDTH),serial_in_re);
    [bf_sum_im(i),bf_sub_im(i)] = my_butterfly(R_im(WIDTH),serial_in_im); 
    
    % fixed point implementation
    bf_sum_re_6_f(i) = fi(bf_sum_re(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sum_im_6_f(i) = fi(bf_sum_im(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sub_re_6_f(i) = fi(bf_sub_re(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sub_im_6_f(i) = fi(bf_sub_im(i),s,w1,f1,'RoundingMethod', 'Floor');
    
    if( T == '1' )
        Register_in_re = serial_in_re;
        Register_in_im = serial_in_im;
    else 
        Register_in_re = bf_sub_re_6_f(i);
        Register_in_im = bf_sub_im_6_f(i);
    end 
   
    if(INDEX > WIDTH)
        INDEX = INDEX - WIDTH;
    end  
    
    if( S == '0' )
        mult_in_re = R_re(WIDTH);
        mult_in_im = R_im(WIDTH);
        mult_out_re1_f(i) = mult_in_re * coeff_re_temp(INDEX);
        mult_out_re2_f(i) = mult_in_im * coeff_im_temp(INDEX);
        mult_out_6_re(i) = fi(mult_out_re1_f(i),s,w2,f2,'RoundingMethod', 'Floor') - fi(mult_out_re2_f(i),s,w2,f2,'RoundingMethod', 'Floor');
        mult_out_im1_f(i) = mult_in_im * coeff_re_temp(INDEX);
        mult_out_im2_f(i) = mult_in_re * coeff_im_temp(INDEX);
        mult_out_6_im(i) = fi(mult_out_im1_f(i),s,w2,f2,'RoundingMethod', 'Floor') + fi(mult_out_im2_f(i),s,w2,f2,'RoundingMethod', 'Floor');
    else 
        mult_in_re = bf_sum_re_6_f(i);
        mult_in_im = bf_sum_im_6_f(i);
        mult_out_6_re(i) = mult_in_re;
        mult_out_6_im(i) = mult_in_im;
    end 

    INDEX = INDEX +1;

    if( mod(i,WIDTH) == 0 )
        if(T == '0')
            T = '1';
        else 
            T = '0';
        end 

        if(S == '0')
            S = '1';
        else 
            S = '0';
        end 
    end   

    if(WIDTH>1)
        for j = WIDTH-1  : -1 : 1
            R_re(j+1) = R_re(j);
            R_im(j+1) = R_im(j);
        end 
    end 

R_re(1) = Register_in_re;
R_im(1) = Register_in_im;
end

% Converting to binary
state_output = mult_out_6_re;
FID10 = fopen('fft_stage6output_binary.txt','w+');
FID11 = fopen('fft_stage6output.txt','w+');
n = f2; % number of fractinonal bits
for i = 1 : 1 : 2048    
    fprintf(FID11,'%.10f\n',state_output(i));
    if (state_output(i)<0)
       temp = abs(state_output(i));
       temp2 = dec2bin(round(temp*2^n),n);
       temp3 = pad(temp2,15,'left','0');
       temp4 = not(temp3-'0');
       temp5 = num2str(temp4);
       binary_nbit = dec2bin(bin2dec(temp5)+bin2dec('1'));
       fprintf(FID10,'%s\n',binary_nbit);
   elseif (state_output(i)==0)
       fprintf(FID10,'000000000000000\n');
   else
       temp = dec2bin(round(state_output(i)*2^n),n);
       binary_nbit = pad(temp,15,'left','0');
       fprintf(FID10,'%s\n',binary_nbit);
   end    
end
fclose(FID10);
fclose(FID11);

state_output = mult_out_6_im;
FID10 = fopen('fft_stage6output_binary_imaginary.txt','w+');
FID11 = fopen('fft_stage6output_imaginary.txt','w+');
n = f2; % number of fractinonal bits
for i = 1 : 1 : 2048    
    fprintf(FID11,'%.10f\n',state_output(i));
    if (state_output(i)<0)
       temp = abs(state_output(i));
       temp2 = dec2bin(round(temp*2^n),n);
       temp3 = pad(temp2,15,'left','0');
       temp4 = not(temp3-'0');
       temp5 = num2str(temp4);
       binary_nbit = dec2bin(bin2dec(temp5)+bin2dec('1'));
       fprintf(FID10,'%s\n',binary_nbit);
   elseif (state_output(i)==0)
       fprintf(FID10,'000000000000000\n');
   else
       temp = dec2bin(round(state_output(i)*2^n),n);
       binary_nbit = pad(temp,15,'left','0');
       fprintf(FID10,'%s\n',binary_nbit);
   end    
end
fclose(FID10);
fclose(FID11);

% % ********** STAGE 7 **********
w1 = 16; % word length
f1 = 7; % fraction length
w2 = 16; % word length after mult
f2 = 7; % fraction length

WIDTH = WIDTH/2;
INDEX = 1;

for i = 1 : 1: WIDTH
    R_re(i) = mult_out_6_re(WIDTH - i +1);
    R_im(i) = mult_out_6_im(WIDTH - i +1);
    coeff_re_temp(i) = coeff_re_temp(2*i-1);
    coeff_im_temp(i) = coeff_im_temp(2*i-1);
end 

for i=1 : 1 : N
    if( i < ( N - WIDTH ) + 1 )
        serial_in_re = mult_out_6_re( i + WIDTH);
        serial_in_im = mult_out_6_im( i + WIDTH);
    else 
        serial_in_re = 0;
        serial_in_im = 0;
    end
    [bf_sum_re(i),bf_sub_re(i)] = my_butterfly(R_re(WIDTH),serial_in_re);
    [bf_sum_im(i),bf_sub_im(i)] = my_butterfly(R_im(WIDTH),serial_in_im);
    
    % fixed point implementation
    bf_sum_re_7_f(i) = fi(bf_sum_re(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sum_im_7_f(i) = fi(bf_sum_im(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sub_re_7_f(i) = fi(bf_sub_re(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sub_im_7_f(i) = fi(bf_sub_im(i),s,w1,f1,'RoundingMethod', 'Floor');
    
    if( T == '1' )
        Register_in_re = serial_in_re;
        Register_in_im = serial_in_im;
    else 
        Register_in_re = bf_sub_re_7_f(i);
        Register_in_im = bf_sub_im_7_f(i);
    end 
   
    if(INDEX > WIDTH)
        INDEX = INDEX - WIDTH;
    end  
    
    if( S == '0' )
        mult_in_re = R_re(WIDTH);
        mult_in_im = R_im(WIDTH);
        mult_out_re1_f(i) = mult_in_re * coeff_re_temp(INDEX);
        mult_out_re2_f(i) = mult_in_im * coeff_im_temp(INDEX);
        mult_out_7_re(i) = fi(mult_out_re1_f(i),s,w2,f2,'RoundingMethod', 'Floor') - fi(mult_out_re2_f(i),s,w2,f2,'RoundingMethod', 'Floor');
        mult_out_im1_f(i) = mult_in_im * coeff_re_temp(INDEX);
        mult_out_im2_f(i) = mult_in_re * coeff_im_temp(INDEX);
        mult_out_7_im(i) = fi(mult_out_im1_f(i),s,w2,f2,'RoundingMethod', 'Floor') + fi(mult_out_im2_f(i),s,w2,f2,'RoundingMethod', 'Floor');
    else 
        mult_in_re = bf_sum_re_7_f(i);
        mult_in_im = bf_sum_im_7_f(i);
        mult_out_7_re(i) = mult_in_re;
        mult_out_7_im(i) = mult_in_im;
    end 

    INDEX = INDEX +1;

    if( mod(i,WIDTH) == 0 )
        if(T == '0')
            T = '1';
        else 
            T = '0';
        end 

        if(S == '0')
            S = '1';
        else 
            S = '0';
        end 
    end   

    if(WIDTH>1)
        for j = WIDTH-1  : -1 : 1
            R_re(j+1) = R_re(j);
            R_im(j+1) = R_im(j);
        end 
    end 

R_re(1) = Register_in_re;
R_im(1) = Register_in_im;
end

% Converting to binary
state_output = mult_out_7_re;
FID10 = fopen('fft_stage7output_binary.txt','w+');
FID11 = fopen('fft_stage7output.txt','w+');
n = f2; % number of fractinonal bits
for i = 1 : 1 : 2048    
    fprintf(FID11,'%.10f\n',state_output(i));
    if (state_output(i)<0)
       temp = abs(state_output(i));
       temp2 = dec2bin(round(temp*2^n),n);
       temp3 = pad(temp2,16,'left','0');
       temp4 = not(temp3-'0');
       temp5 = num2str(temp4);
       binary_nbit = dec2bin(bin2dec(temp5)+bin2dec('1'));
       fprintf(FID10,'%s\n',binary_nbit);
   elseif (state_output(i)==0)
       fprintf(FID10,'0000000000000000\n');
   else
       temp = dec2bin(round(state_output(i)*2^n),n);
       binary_nbit = pad(temp,16,'left','0');
       fprintf(FID10,'%s\n',binary_nbit);
   end    
end
fclose(FID10);
fclose(FID11);

state_output = mult_out_7_im;
FID10 = fopen('fft_stage7output_binary_imaginary.txt','w+');
FID11 = fopen('fft_stage7output_imaginary.txt','w+');
n = f2; % number of fractinonal bits
for i = 1 : 1 : 2048    
    fprintf(FID11,'%.10f\n',state_output(i));
    if (state_output(i)<0)
       temp = abs(state_output(i));
       temp2 = dec2bin(round(temp*2^n),n);
       temp3 = pad(temp2,16,'left','0');
       temp4 = not(temp3-'0');
       temp5 = num2str(temp4);
       binary_nbit = dec2bin(bin2dec(temp5)+bin2dec('1'));
       fprintf(FID10,'%s\n',binary_nbit);
   elseif (state_output(i)==0)
       fprintf(FID10,'0000000000000000\n');
   else
       temp = dec2bin(round(state_output(i)*2^n),n);
       binary_nbit = pad(temp,16,'left','0');
       fprintf(FID10,'%s\n',binary_nbit);
   end    
end
fclose(FID10);
fclose(FID11);

% ********** STAGE 8 **********
w1 = 16; % word length
f1 = 6; % fraction length
w2 = 16; % word length after mult
f2 = 6; % fraction length

WIDTH = WIDTH/2;
INDEX = 1;

for i = 1 : 1: WIDTH
    R_re(i) = mult_out_7_re(WIDTH - i +1);
    R_im(i) = mult_out_7_im(WIDTH - i +1);
    coeff_re_temp(i) = coeff_re_temp(2*i-1);
    coeff_im_temp(i) = coeff_im_temp(2*i-1);
end 

for i=1 : 1 : N
    if( i < ( N - WIDTH ) + 1 )
        serial_in_re = mult_out_7_re( i + WIDTH);
        serial_in_im = mult_out_7_im( i + WIDTH);
    else 
        serial_in_re = 0;
        serial_in_im = 0;
    end
    [bf_sum_re(i),bf_sub_re(i)] = my_butterfly(R_re(WIDTH),serial_in_re);
    [bf_sum_im(i),bf_sub_im(i)] = my_butterfly(R_im(WIDTH),serial_in_im);
    
    % fixed point implementation
    bf_sum_re_8_f(i) = fi(bf_sum_re(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sum_im_8_f(i) = fi(bf_sum_im(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sub_re_8_f(i) = fi(bf_sub_re(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sub_im_8_f(i) = fi(bf_sub_im(i),s,w1,f1,'RoundingMethod', 'Floor');
    
    if( T == '1' )
        Register_in_re = serial_in_re;
        Register_in_im = serial_in_im;
    else 
        Register_in_re = bf_sub_re_8_f(i);
        Register_in_im = bf_sub_im_8_f(i);
    end 
   
    if(INDEX > WIDTH)
        INDEX = INDEX - WIDTH;
    end  
    
    if( S == '0' )
        mult_in_re = R_re(WIDTH);
        mult_in_im = R_im(WIDTH);
        mult_out_re1_f(i) = mult_in_re * coeff_re_temp(INDEX);
        mult_out_re2_f(i) = mult_in_im * coeff_im_temp(INDEX);
        mult_out_8_re(i) = fi(mult_out_re1_f(i),s,w2,f2,'RoundingMethod', 'Floor') - fi(mult_out_re2_f(i),s,w2,f2,'RoundingMethod', 'Floor');
        mult_out_im1_f(i) = mult_in_im * coeff_re_temp(INDEX);
        mult_out_im2_f(i) = mult_in_re * coeff_im_temp(INDEX);
        mult_out_8_im(i) = fi(mult_out_im1_f(i),s,w2,f2,'RoundingMethod', 'Floor') + fi(mult_out_im2_f(i),s,w2,f2,'RoundingMethod', 'Floor');
    else 
        mult_in_re = bf_sum_re_8_f(i);
        mult_in_im = bf_sum_im_8_f(i);
        mult_out_8_re(i) = mult_in_re;
        mult_out_8_im(i) = mult_in_im;
    end 

    INDEX = INDEX +1;

    if( mod(i,WIDTH) == 0 )
        if(T == '0')
            T = '1';
        else 
            T = '0';
        end 

        if(S == '0')
            S = '1';
        else 
            S = '0';
        end 
    end   

    if(WIDTH>1)
        for j = WIDTH-1  : -1 : 1
            R_re(j+1) = R_re(j);
            R_im(j+1) = R_im(j);
        end 
    end 

R_re(1) = Register_in_re;
R_im(1) = Register_in_im;
end

% Converting to binary
state_output = mult_out_8_re;
FID10 = fopen('fft_stage8output_binary.txt','w+');
FID11 = fopen('fft_stage8output.txt','w+');
n = f2; % number of fractinonal bits
for i = 1 : 1 : 2048    
    fprintf(FID11,'%.10f\n',state_output(i));
    if (state_output(i)<0)
       temp = abs(state_output(i));
       temp2 = dec2bin(round(temp*2^n),n);
       temp3 = pad(temp2,16,'left','0');
       temp4 = not(temp3-'0');
       temp5 = num2str(temp4);
       binary_nbit = dec2bin(bin2dec(temp5)+bin2dec('1'));
       fprintf(FID10,'%s\n',binary_nbit);
   elseif (state_output(i)==0)
       fprintf(FID10,'0000000000000000\n');
   else
       temp = dec2bin(round(state_output(i)*2^n),n);
       binary_nbit = pad(temp,16,'left','0');
       fprintf(FID10,'%s\n',binary_nbit);
   end    
end
fclose(FID10);
fclose(FID11);

state_output = mult_out_8_im;
FID10 = fopen('fft_stage8output_binary_imaginary.txt','w+');
FID11 = fopen('fft_stage8output_imaginary.txt','w+');
n = f2; % number of fractinonal bits
for i = 1 : 1 : 2048    
    fprintf(FID11,'%.10f\n',state_output(i));
    if (state_output(i)<0)
       temp = abs(state_output(i));
       temp2 = dec2bin(round(temp*2^n),n);
       temp3 = pad(temp2,16,'left','0');
       temp4 = not(temp3-'0');
       temp5 = num2str(temp4);
       binary_nbit = dec2bin(bin2dec(temp5)+bin2dec('1'));
       fprintf(FID10,'%s\n',binary_nbit);
   elseif (state_output(i)==0)
       fprintf(FID10,'0000000000000000\n');
   else
       temp = dec2bin(round(state_output(i)*2^n),n);
       binary_nbit = pad(temp,16,'left','0');
       fprintf(FID10,'%s\n',binary_nbit);
   end    
end
fclose(FID10);
fclose(FID11);

% ********** STAGE 9 **********
w1 = 16; % word length
f1 = 6; % fraction length
w2 = 16; % word length after mult
f2 = 6; % fraction length

WIDTH = WIDTH/2;
INDEX = 1;

for i = 1 : 1: WIDTH
    R_re(i) = mult_out_8_re(WIDTH - i +1);
    R_im(i) = mult_out_8_im(WIDTH - i +1);
    coeff_re_temp(i) = coeff_re_temp(2*i-1);
    coeff_im_temp(i) = coeff_im_temp(2*i-1);
end 

for i=1 : 1 : N
    if( i < ( N - WIDTH ) + 1 )
        serial_in_re = mult_out_8_re( i + WIDTH);
        serial_in_im = mult_out_8_im( i + WIDTH);
    else 
        serial_in_re = 0;
        serial_in_im = 0;
    end
    [bf_sum_re(i),bf_sub_re(i)] = my_butterfly(R_re(WIDTH),serial_in_re);
    [bf_sum_im(i),bf_sub_im(i)] = my_butterfly(R_im(WIDTH),serial_in_im);
    
    % fixed point implementation
    bf_sum_re_9_f(i) = fi(bf_sum_re(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sum_im_9_f(i) = fi(bf_sum_im(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sub_re_9_f(i) = fi(bf_sub_re(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sub_im_9_f(i) = fi(bf_sub_im(i),s,w1,f1,'RoundingMethod', 'Floor');
    
    if( T == '1' )
        Register_in_re = serial_in_re;
        Register_in_im = serial_in_im;
    else 
        Register_in_re = bf_sub_re_9_f(i);
        Register_in_im = bf_sub_im_9_f(i);
    end 
   
    if(INDEX > WIDTH)
        INDEX = INDEX - WIDTH;
    end  
    
    if( S == '0' )
        mult_in_re = R_re(WIDTH);
        mult_in_im = R_im(WIDTH);
        mult_out_re1_f(i) = mult_in_re * coeff_re_temp(INDEX);
        mult_out_re2_f(i) = mult_in_im * coeff_im_temp(INDEX);
        mult_out_9_re(i) = fi(mult_out_re1_f(i),s,w2,f2,'RoundingMethod', 'Floor') - fi(mult_out_re2_f(i),s,w2,f2,'RoundingMethod', 'Floor');
        mult_out_im1_f(i) = mult_in_im * coeff_re_temp(INDEX);
        mult_out_im2_f(i) = mult_in_re * coeff_im_temp(INDEX);
        mult_out_9_im(i) = fi(mult_out_im1_f(i),s,w2,f2,'RoundingMethod', 'Floor') + fi(mult_out_im2_f(i),s,w2,f2,'RoundingMethod', 'Floor');
    else 
        mult_in_re = bf_sum_re_9_f(i);
        mult_in_im = bf_sum_im_9_f(i);
        mult_out_9_re(i) = mult_in_re;
        mult_out_9_im(i) = mult_in_im;
    end 

    INDEX = INDEX +1;

    if( mod(i,WIDTH) == 0 )
        if(T == '0')
            T = '1';
        else 
            T = '0';
        end 

        if(S == '0')
            S = '1';
        else 
            S = '0';
        end 
    end   

    if(WIDTH>1)
        for j = WIDTH-1  : -1 : 1
            R_re(j+1) = R_re(j);
            R_im(j+1) = R_im(j);
        end 
    end 

R_re(1) = Register_in_re;
R_im(1) = Register_in_im;
end

% Converting to binary
state_output = mult_out_9_re;
FID10 = fopen('fft_stage9output_binary.txt','w+');
FID11 = fopen('fft_stage9output.txt','w+');
n = f2; % number of fractinonal bits
for i = 1 : 1 : 2048    
    fprintf(FID11,'%.10f\n',state_output(i));
    if (state_output(i)<0)
       temp = abs(state_output(i));
       temp2 = dec2bin(round(temp*2^n),n);
       temp3 = pad(temp2,16,'left','0');
       temp4 = not(temp3-'0');
       temp5 = num2str(temp4);
       binary_nbit = dec2bin(bin2dec(temp5)+bin2dec('1'));
       fprintf(FID10,'%s\n',binary_nbit);
   elseif (state_output(i)==0)
       fprintf(FID10,'0000000000000000\n');
   else
       temp = dec2bin(round(state_output(i)*2^n),n);
       binary_nbit = pad(temp,16,'left','0');
       fprintf(FID10,'%s\n',binary_nbit);
   end    
end
fclose(FID10);
fclose(FID11);

state_output = mult_out_9_im;
FID10 = fopen('fft_stage9output_binary_imaginary.txt','w+');
FID11 = fopen('fft_stage9output_imaginary.txt','w+');
n = f2; % number of fractinonal bits
for i = 1 : 1 : 2048    
    fprintf(FID11,'%.10f\n',state_output(i));
    if (state_output(i)<0)
       temp = abs(state_output(i));
       temp2 = dec2bin(round(temp*2^n),n);
       temp3 = pad(temp2,16,'left','0');
       temp4 = not(temp3-'0');
       temp5 = num2str(temp4);
       binary_nbit = dec2bin(bin2dec(temp5)+bin2dec('1'));
       fprintf(FID10,'%s\n',binary_nbit);
   elseif (state_output(i)==0)
       fprintf(FID10,'0000000000000000\n');
   else
       temp = dec2bin(round(state_output(i)*2^n),n);
       binary_nbit = pad(temp,16,'left','0');
       fprintf(FID10,'%s\n',binary_nbit);
   end    
end
fclose(FID10);
fclose(FID11);

% ********** STAGE 10 **********
w1 = 16; % word length
f1 = 5; % fraction length
w2 = 16; % word length after mult
f2 = 5; % fraction length

WIDTH = WIDTH/2;
INDEX = 1;

for i = 1 : 1: WIDTH
    R_re(i) = mult_out_9_re(WIDTH - i +1);
    R_im(i) = mult_out_9_im(WIDTH - i +1);
    coeff_re_temp(i) = coeff_re_temp(2*i-1);
    coeff_im_temp(i) = coeff_im_temp(2*i-1);
end 

for i=1 : 1 : N
    if( i < ( N - WIDTH ) + 1 )
        serial_in_re = mult_out_9_re( i + WIDTH);
        serial_in_im = mult_out_9_im( i + WIDTH);
    else 
        serial_in_re = 0;
        serial_in_im = 0;
    end
    [bf_sum_re(i),bf_sub_re(i)] = my_butterfly(R_re(WIDTH),serial_in_re);
    [bf_sum_im(i),bf_sub_im(i)] = my_butterfly(R_im(WIDTH),serial_in_im);
    
    % fixed point implementation
    bf_sum_re_10_f(i) = fi(bf_sum_re(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sum_im_10_f(i) = fi(bf_sum_im(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sub_re_10_f(i) = fi(bf_sub_re(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sub_im_10_f(i) = fi(bf_sub_im(i),s,w1,f1,'RoundingMethod', 'Floor');
    
    if( T == '1' )
        Register_in_re = serial_in_re;
        Register_in_im = serial_in_im;
    else 
        Register_in_re = bf_sub_re_10_f(i);
        Register_in_im = bf_sub_im_10_f(i);
    end 
   
    if(INDEX > WIDTH)
        INDEX = INDEX - WIDTH;
    end  
    
    if( S == '0' )
        mult_in_re = R_re(WIDTH);
        mult_in_im = R_im(WIDTH);
        mult_out_re1_f(i) = mult_in_re * coeff_re_temp(INDEX);
        mult_out_re2_f(i) = mult_in_im * coeff_im_temp(INDEX);
        mult_out_10_re(i) = fi(mult_out_re1_f(i),s,w2,f2,'RoundingMethod', 'Floor') - fi(mult_out_re2_f(i),s,w2,f2,'RoundingMethod', 'Floor');
        mult_out_im1_f(i) = mult_in_im * coeff_re_temp(INDEX);
        mult_out_im2_f(i) = mult_in_re * coeff_im_temp(INDEX);
        mult_out_10_im(i) = fi(mult_out_im1_f(i),s,w2,f2,'RoundingMethod', 'Floor') + fi(mult_out_im2_f(i),s,w2,f2,'RoundingMethod', 'Floor');
    else 
        mult_in_re = bf_sum_re_10_f(i);
        mult_in_im = bf_sum_im_10_f(i);
        mult_out_10_re(i) = mult_in_re;
        mult_out_10_im(i) = mult_in_im;
    end 

    INDEX = INDEX +1;

    if( mod(i,WIDTH) == 0 )
        if(T == '0')
            T = '1';
        else 
            T = '0';
        end 

        if(S == '0')
            S = '1';
        else 
            S = '0';
        end 
    end   

    if(WIDTH>1)
        for j = WIDTH-1  : -1 : 1
            R_re(j+1) = R_re(j);
            R_im(j+1) = R_im(j);
        end 
    end 

R_re(1) = Register_in_re;
R_im(1) = Register_in_im;
end

% Converting to binary
state_output = mult_out_10_re;
FID10 = fopen('fft_stage10output_binary.txt','w+');
FID11 = fopen('fft_stage10output.txt','w+');
n = f2; % number of fractinonal bits
for i = 1 : 1 : 2048    
    fprintf(FID11,'%.10f\n',state_output(i));
    if (state_output(i)<0)
       temp = abs(state_output(i));
       temp2 = dec2bin(round(temp*2^n),n);
       temp3 = pad(temp2,16,'left','0');
       temp4 = not(temp3-'0');
       temp5 = num2str(temp4);
       binary_nbit = dec2bin(bin2dec(temp5)+bin2dec('1'));
       fprintf(FID10,'%s\n',binary_nbit);
   elseif (state_output(i)==0)
       fprintf(FID10,'0000000000000000\n');
   else
       temp = dec2bin(round(state_output(i)*2^n),n);
       binary_nbit = pad(temp,16,'left','0');
       fprintf(FID10,'%s\n',binary_nbit);
   end    
end
fclose(FID10);
fclose(FID11);

state_output = mult_out_10_im;
FID10 = fopen('fft_stage10output_binary_imaginary.txt','w+');
FID11 = fopen('fft_stage10output_imaginary.txt','w+');
n = f2; % number of fractinonal bits
for i = 1 : 1 : 2048    
    fprintf(FID11,'%.10f\n',state_output(i));
    if (state_output(i)<0)
       temp = abs(state_output(i));
       temp2 = dec2bin(round(temp*2^n),n);
       temp3 = pad(temp2,16,'left','0');
       temp4 = not(temp3-'0');
       temp5 = num2str(temp4);
       binary_nbit = dec2bin(bin2dec(temp5)+bin2dec('1'));
       fprintf(FID10,'%s\n',binary_nbit);
   elseif (state_output(i)==0)
       fprintf(FID10,'0000000000000000\n');
   else
       temp = dec2bin(round(state_output(i)*2^n),n);
       binary_nbit = pad(temp,16,'left','0');
       fprintf(FID10,'%s\n',binary_nbit);
   end    
end
fclose(FID10);
fclose(FID11);

% ********** STAGE 11 **********
w1 = 12; % word length
f1 = 4; % fraction length
w2 = 12; % word length after mult
f2 = 4; % fraction length

WIDTH = WIDTH/2;
INDEX = 1;

for i = 1 : 1: WIDTH
    R_re(i) = mult_out_10_re(WIDTH - i +1);
    R_im(i) = mult_out_10_im(WIDTH - i +1);
    coeff_re_temp(i) = coeff_re_temp(2*i-1);
    coeff_im_temp(i) = coeff_im_temp(2*i-1);
end 

for i=1 : 1 : N
    if( i < ( N - WIDTH ) + 1 )
        serial_in_re = mult_out_10_re( i + WIDTH);
        serial_in_im = mult_out_10_im( i + WIDTH);
    else 
        serial_in_re = 0;
        serial_in_im = 0;
    end
    [bf_sum_re(i),bf_sub_re(i)] = my_butterfly(R_re(WIDTH),serial_in_re);
    [bf_sum_im(i),bf_sub_im(i)] = my_butterfly(R_im(WIDTH),serial_in_im);
    
    % fixed point implementation
    bf_sum_re_11_f(i) = fi(bf_sum_re(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sum_im_11_f(i) = fi(bf_sum_im(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sub_re_11_f(i) = fi(bf_sub_re(i),s,w1,f1,'RoundingMethod', 'Floor');
    bf_sub_im_11_f(i) = fi(bf_sub_im(i),s,w1,f1,'RoundingMethod', 'Floor');
    
    if( T == '1' )
        Register_in_re = serial_in_re;
        Register_in_im = serial_in_im;
    else 
        Register_in_re = bf_sub_re_11_f(i);
        Register_in_im = bf_sub_im_11_f(i);
    end 
   
    if(INDEX > WIDTH)
        INDEX = INDEX - WIDTH;
    end  
    
    if( S == '0' )
        mult_in_re = R_re(WIDTH);
        mult_in_im = R_im(WIDTH);
        mult_out_re1_f(i) = mult_in_re * coeff_re_temp(INDEX);
        mult_out_re2_f(i) = mult_in_im * coeff_im_temp(INDEX);
        mult_out_re(i) = fi(mult_out_re1_f(i),s,w2,f2,'RoundingMethod', 'Floor') - fi(mult_out_re2_f(i),s,w2,f2,'RoundingMethod', 'Floor');
        mult_out_im1_f(i) = mult_in_im * coeff_re_temp(INDEX);
        mult_out_im2_f(i) = mult_in_re * coeff_im_temp(INDEX);
        mult_out_im(i) = fi(mult_out_im1_f(i),s,w2,f2,'RoundingMethod', 'Floor') + fi(mult_out_im2_f(i),s,w2,f2,'RoundingMethod', 'Floor');
    else 
        mult_in_re = bf_sum_re_11_f(i);
        mult_in_im = bf_sum_im_11_f(i);
        mult_out_re(i) = mult_in_re;
        mult_out_im(i) = mult_in_im;
    end 

    INDEX = INDEX +1;

    if( mod(i,WIDTH) == 0 )
        if(T == '0')
            T = '1';
        else 
            T = '0';
        end 

        if(S == '0')
            S = '1';
        else 
            S = '0';
        end 
    end   

    if(WIDTH>1)
        for j = WIDTH-1  : -1 : 1
            R_re(j+1) = R_re(j);
            R_im(j+1) = R_im(j);
        end 
    end 

R_re(1) = Register_in_re;
R_im(1) = Register_in_im;

end

FID3 = fopen('fft_outputs.txt','w+');

for kn=1 : 1 : N
       fprintf(FID3,'%.4f\n',mult_out_re(kn));
       fprintf(FID3,'%.4f\n',mult_out_im(kn));
end
fclose(FID3);


% Converting to binary
state_output = mult_out_re;
FID10 = fopen('fft_stage11output_binary.txt','w+');
FID11 = fopen('fft_stage11output.txt','w+');
n = f2; % number of fractinonal bits
for i = 1 : 1 : 2048    
    fprintf(FID11,'%.4f\n',state_output(i));
    if (state_output(i)<0)
       temp = abs(state_output(i));
       temp2 = dec2bin(round(temp*2^n),n);
       temp3 = pad(temp2,12,'left','0');
       temp4 = not(temp3-'0');
       temp5 = num2str(temp4);
       binary_nbit = dec2bin(bin2dec(temp5)+bin2dec('1'));
       fprintf(FID10,'%s\n',binary_nbit);
   elseif (state_output(i)==0)
       fprintf(FID10,'000000000000\n');
   else
       temp = dec2bin(round(state_output(i)*2^n),n);
       binary_nbit = pad(temp,12,'left','0');
       fprintf(FID10,'%s\n',binary_nbit);
   end    
end
fclose(FID10);
fclose(FID11);

state_output = mult_out_im;
FID10 = fopen('fft_stage11output_binary_imaginary.txt','w+');
FID11 = fopen('fft_stage11output_imaginary.txt','w+');
n = f2; % number of fractinonal bits
for i = 1 : 1 : 2048    
    fprintf(FID11,'%.4f\n',state_output(i));
    if (state_output(i)<0)
       temp = abs(state_output(i));
       temp2 = dec2bin(round(temp*2^n),n);
       temp3 = pad(temp2,12,'left','0');
       temp4 = not(temp3-'0');
       temp5 = num2str(temp4);
       binary_nbit = dec2bin(bin2dec(temp5)+bin2dec('1'));
       fprintf(FID10,'%s\n',binary_nbit);
   elseif (state_output(i)==0)
       fprintf(FID10,'000000000000\n');
   else
       temp = dec2bin(round(state_output(i)*2^n),n);
       binary_nbit = pad(temp,12,'left','0');
       fprintf(FID10,'%s\n',binary_nbit);
   end    
end
fclose(FID10);
fclose(FID11);

end


% Butterfly Function
function [sum_out, sub_out] = my_butterfly(n1,n2)
    sum_out = n1+n2;
    sub_out = n1-n2;
end
