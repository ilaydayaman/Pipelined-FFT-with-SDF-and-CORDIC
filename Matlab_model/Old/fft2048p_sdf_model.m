clear all;
clc;

N = 2048;

% ********** File operation **********
% Reading coefficients
FID = fopen('fft_coefficients.txt','r');
coefficients=fscanf(FID,'%f');
for q=1 : 1 : N/2
   coeff_re(q) = coefficients(2*q-1);
   coeff_im(q) = coefficients(2*q);
end 

% Reading inputs
FID2 = fopen('fft_inputs.txt','r');
fft_input=fscanf(FID2,'%f');
for q = 1 : 1 : N
    input_re(q) = fft_input(2*q-1);
    input_im(q) = fft_input(2*q);
end

fclose('all');

% ********** FFT Parameters **********
WIDTH = N/2;
% ********** INITIALIZE **********
T = '0';
S = '1';

coeff_re_temp = coeff_re;
coeff_im_temp = coeff_im;

% inputs should be reversed when putting into registers 
% since FIFO approach is used
for q = 1 : 1 : WIDTH
    R_re(q) = input_re(WIDTH - q +1);
    R_im(q) = input_im(WIDTH - q +1);
end 

% ********** STAGE 1 **********
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
    
    if( T == '1' )
        Register_in_re = serial_in_re;
        Register_in_im = serial_in_im;
    else 
        Register_in_re = bf_sub_re(i);
        Register_in_im = bf_sub_im(i);
    end 
    
    if( S == '0' )
        mult_in_re = R_re(WIDTH);
        mult_in_im = R_im(WIDTH);
        mult_out_re(i) = mult_in_re * coeff_re_temp(i-WIDTH) -  mult_in_im * coeff_im_temp(i-WIDTH);
        mult_out_im(i) = mult_in_im * coeff_re_temp(i-WIDTH) +  mult_in_re * coeff_im_temp(i-WIDTH);
    else 
        mult_in_re = bf_sum_re(i);
        mult_in_im = bf_sum_im(i);
        mult_out_re(i) = mult_in_re;
        mult_out_im(i) = mult_in_im;
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
    
end

 while (WIDTH > 1)
    WIDTH = WIDTH/2;
    INDEX = 1;
    %do the assignments for parellel effect 
    for i = 1 : 1: WIDTH
        R_re(i) = mult_out_re(WIDTH - i +1);
        R_im(i) = mult_out_im(WIDTH - i +1);
        coeff_re_temp(i) = coeff_re_temp(2*i-1);
        coeff_im_temp(i) = coeff_im_temp(2*i-1);
    end 
    
    for i=1 : 1 : N
        if( i < ( N - WIDTH ) + 1 )
            serial_in_re = mult_out_re( i + WIDTH);
            serial_in_im = mult_out_im( i + WIDTH);
        else 
            serial_in_re = 0;
            serial_in_im = 0;
        end
        [bf_sum_re(i),bf_sub_re(i)] = my_butterfly(R_re(WIDTH),serial_in_re);
        [bf_sum_im(i),bf_sub_im(i)] = my_butterfly(R_im(WIDTH),serial_in_im);

        if( T == '1' )
            Register_in_re = serial_in_re;
            Register_in_im = serial_in_im;
        else 
            Register_in_re = bf_sub_re(i);
            Register_in_im = bf_sub_im(i);
        end 
        
        if(INDEX > WIDTH)
            INDEX = INDEX - WIDTH;
        end     
        
        if( S == '0' )
            mult_in_re = R_re(WIDTH);
            mult_in_im = R_im(WIDTH);
            mult_out_re(i) = mult_in_re * coeff_re_temp(INDEX) -  mult_in_im * coeff_im_temp(INDEX);
            mult_out_im(i) = mult_in_im * coeff_re_temp(INDEX) +  mult_in_re * coeff_im_temp(INDEX);
        else 
            mult_in_re = bf_sum_re(i);
            mult_in_im = bf_sum_im(i);
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
    
 end       

% FFT Reference
for a=1 : 1 : N
    input_complex(a) = fft_input(2*a-1)+1i*fft_input(2*a);
end
ref = fft(input_complex);
ref_inv = bitrevorder(ref);

ref_inv_re = real(ref_inv);
ref_inv_im = imag(ref_inv);
diff_re = ref_inv_re - mult_out_re;
diff_im = ref_inv_im - mult_out_im;
diff_re_procent = (diff_re./ref_inv_re)*100;

figure(1);
clf;
subplot(2,1,2);
plot(diff_re);
axis([0 N -0.5 0.5]);
title('Difference between floating and fixed point');
subplot(2,1,1);
plot(ref_inv_re,'k'), hold on;
plot(mult_out_re,'--r');
axis([0 N -100 100]);
legend('Floatin point','Fixed point');
title('2048 point FFT real numbers');

figure(2);
clf;
subplot(2,1,2);
plot(diff_im);
axis([0 N -0.5 0.5]);
title('Difference between floating and fixed point');
subplot(2,1,1);
plot(ref_inv_im,'k'), hold on;
plot(mult_out_im,'--r');
axis([0 N -100 100]);
legend('Floatin point','Fixed point');
title('2048 point FFT imaginary numbers');


% Butterfly Function
function [sum_out, sub_out] = my_butterfly(n1,n2)
    sum_out = n1+n2;
    sub_out = n1-n2;
end