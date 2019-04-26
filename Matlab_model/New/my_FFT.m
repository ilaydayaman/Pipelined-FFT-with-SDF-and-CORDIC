function [mult_out_re, mult_out_im] = my_FFT(coefficients, input_re,input_im, N)

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
    bf_sum_re_1_f(i) = fi(bf_sum_re(i),s,w1,f1);
    bf_sum_im_1_f(i) = fi(bf_sum_im(i),s,w1,f1);
    bf_sub_re_1_f(i) = fi(bf_sub_re(i),s,w1,f1);
    bf_sub_im_1_f(i) = fi(bf_sub_im(i),s,w1,f1);
    
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
        mult_out_re_f(i) = mult_in_re * coeff_re_temp(i-WIDTH) -  mult_in_im * coeff_im_temp(i-WIDTH);
        mult_out_1_re(i) = fi(mult_out_re_f(i),s,w2,f2);
        mult_out_im_f(i) = mult_in_im * coeff_re_temp(i-WIDTH) +  mult_in_re * coeff_im_temp(i-WIDTH);
        mult_out_1_im(i) = fi(mult_out_im_f(i),s,w2,f2);
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
    
end

state1_output = mult_out_1_re;

%plot(state1_output);

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
    bf_sum_re_2_f(i) = fi(bf_sum_re(i),s,w1,f1);
    bf_sum_im_2_f(i) = fi(bf_sum_im(i),s,w1,f1);
    bf_sub_re_2_f(i) = fi(bf_sub_re(i),s,w1,f1);
    bf_sub_im_2_f(i) = fi(bf_sub_im(i),s,w1,f1);
    
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
        mult_out_re_f(i) = mult_in_re * coeff_re_temp(INDEX) -  mult_in_im * coeff_im_temp(INDEX);
        mult_out_2_re(i) = fi(mult_out_re_f(i),s,w2,f2);
        mult_out_im_f(i) = mult_in_im * coeff_re_temp(INDEX) +  mult_in_re * coeff_im_temp(INDEX);
        mult_out_2_im(i) = fi(mult_out_im_f(i),s,w2,f2);
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
    
% mult_out_re

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
    bf_sum_re_3_f(i) = fi(bf_sum_re(i),s,w1,f1);
    bf_sum_im_3_f(i) = fi(bf_sum_im(i),s,w1,f1);
    bf_sub_re_3_f(i) = fi(bf_sub_re(i),s,w1,f1);
    bf_sub_im_3_f(i) = fi(bf_sub_im(i),s,w1,f1);
    
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
        mult_out_re_f(i) = mult_in_re * coeff_re_temp(INDEX) -  mult_in_im * coeff_im_temp(INDEX);
        mult_out_3_re(i) = fi(mult_out_re_f(i),s,w1,f1);
        mult_out_im_f(i) = mult_in_im * coeff_re_temp(INDEX) +  mult_in_re * coeff_im_temp(INDEX);
        mult_out_3_im(i) = fi(mult_out_im_f(i),s,w1,f1);
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
    bf_sum_re_4_f(i) = fi(bf_sum_re(i),s,w1,f1);
    bf_sum_im_4_f(i) = fi(bf_sum_im(i),s,w1,f1);
    bf_sub_re_4_f(i) = fi(bf_sub_re(i),s,w1,f1);
    bf_sub_im_4_f(i) = fi(bf_sub_im(i),s,w1,f1);
    
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
        mult_out_re_f(i) = mult_in_re * coeff_re_temp(INDEX) -  mult_in_im * coeff_im_temp(INDEX);
        mult_out_4_re(i) = fi(mult_out_re_f(i),s,w1,f1);
        mult_out_im_f(i) = mult_in_im * coeff_re_temp(INDEX) +  mult_in_re * coeff_im_temp(INDEX);
        mult_out_4_im(i) = fi(mult_out_im_f(i),s,w1,f1);
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
    bf_sum_re_5_f(i) = fi(bf_sum_re(i),s,w1,f1);
    bf_sum_im_5_f(i) = fi(bf_sum_im(i),s,w1,f1);
    bf_sub_re_5_f(i) = fi(bf_sub_re(i),s,w1,f1);
    bf_sub_im_5_f(i) = fi(bf_sub_im(i),s,w1,f1);
    
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
        mult_out_re_f(i) = mult_in_re * coeff_re_temp(INDEX) -  mult_in_im * coeff_im_temp(INDEX);
        mult_out_5_re(i) = fi(mult_out_re_f(i),s,w1,f1);
        mult_out_im_f(i) = mult_in_im * coeff_re_temp(INDEX) +  mult_in_re * coeff_im_temp(INDEX);
        mult_out_5_im(i) = fi(mult_out_im_f(i),s,w1,f1);
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
    bf_sum_re_6_f(i) = fi(bf_sum_re(i),s,w1,f1);
    bf_sum_im_6_f(i) = fi(bf_sum_im(i),s,w1,f1);
    bf_sub_re_6_f(i) = fi(bf_sub_re(i),s,w1,f1);
    bf_sub_im_6_f(i) = fi(bf_sub_im(i),s,w1,f1);
    
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
        mult_out_re_f(i) = mult_in_re * coeff_re_temp(INDEX) -  mult_in_im * coeff_im_temp(INDEX);
        mult_out_6_re(i) = fi(mult_out_re_f(i),s,w1,f1);
        mult_out_im_f(i) = mult_in_im * coeff_re_temp(INDEX) +  mult_in_re * coeff_im_temp(INDEX);
        mult_out_6_im(i) = fi(mult_out_im_f(i),s,w1,f1);
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
    bf_sum_re_7_f(i) = fi(bf_sum_re(i),s,w1,f1);
    bf_sum_im_7_f(i) = fi(bf_sum_im(i),s,w1,f1);
    bf_sub_re_7_f(i) = fi(bf_sub_re(i),s,w1,f1);
    bf_sub_im_7_f(i) = fi(bf_sub_im(i),s,w1,f1);
    
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
        mult_out_re_f(i) = mult_in_re * coeff_re_temp(INDEX) -  mult_in_im * coeff_im_temp(INDEX);
        mult_out_7_re(i) = fi(mult_out_re_f(i),s,w1,f1);
        mult_out_im_f(i) = mult_in_im * coeff_re_temp(INDEX) +  mult_in_re * coeff_im_temp(INDEX);
        mult_out_7_im(i) = fi(mult_out_im_f(i),s,w1,f1);
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
    bf_sum_re_8_f(i) = fi(bf_sum_re(i),s,w1,f1);
    bf_sum_im_8_f(i) = fi(bf_sum_im(i),s,w1,f1);
    bf_sub_re_8_f(i) = fi(bf_sub_re(i),s,w1,f1);
    bf_sub_im_8_f(i) = fi(bf_sub_im(i),s,w1,f1);
    
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
        mult_out_re_f(i) = mult_in_re * coeff_re_temp(INDEX) -  mult_in_im * coeff_im_temp(INDEX);
        mult_out_8_re(i) = fi(mult_out_re_f(i),s,w1,f1);
        mult_out_im_f(i) = mult_in_im * coeff_re_temp(INDEX) +  mult_in_re * coeff_im_temp(INDEX);
        mult_out_8_im(i) = fi(mult_out_im_f(i),s,w1,f1);
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
    bf_sum_re_9_f(i) = fi(bf_sum_re(i),s,w1,f1);
    bf_sum_im_9_f(i) = fi(bf_sum_im(i),s,w1,f1);
    bf_sub_re_9_f(i) = fi(bf_sub_re(i),s,w1,f1);
    bf_sub_im_9_f(i) = fi(bf_sub_im(i),s,w1,f1);
    
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
        mult_out_re_f(i) = mult_in_re * coeff_re_temp(INDEX) -  mult_in_im * coeff_im_temp(INDEX);
        mult_out_9_re(i) = fi(mult_out_re_f(i),s,w1,f1);
        mult_out_im_f(i) = mult_in_im * coeff_re_temp(INDEX) +  mult_in_re * coeff_im_temp(INDEX);
        mult_out_9_im(i) = fi(mult_out_im_f(i),s,w1,f1);
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
    bf_sum_re_10_f(i) = fi(bf_sum_re(i),s,w1,f1);
    bf_sum_im_10_f(i) = fi(bf_sum_im(i),s,w1,f1);
    bf_sub_re_10_f(i) = fi(bf_sub_re(i),s,w1,f1);
    bf_sub_im_10_f(i) = fi(bf_sub_im(i),s,w1,f1);
    
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
        mult_out_re_f(i) = mult_in_re * coeff_re_temp(INDEX) -  mult_in_im * coeff_im_temp(INDEX);
        mult_out_10_re(i) = fi(mult_out_re_f(i),s,w1,f1);
        mult_out_im_f(i) = mult_in_im * coeff_re_temp(INDEX) +  mult_in_re * coeff_im_temp(INDEX);
        mult_out_10_im(i) = fi(mult_out_im_f(i),s,w1,f1);
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
    bf_sum_re_11_f(i) = fi(bf_sum_re(i),s,w1,f1);
    bf_sum_im_11_f(i) = fi(bf_sum_im(i),s,w1,f1);
    bf_sub_re_11_f(i) = fi(bf_sub_re(i),s,w1,f1);
    bf_sub_im_11_f(i) = fi(bf_sub_im(i),s,w1,f1);
    
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
        mult_out_re_f(i) = mult_in_re * coeff_re_temp(INDEX) -  mult_in_im * coeff_im_temp(INDEX);
        mult_out_re(i) = fi(mult_out_re_f(i),s,w1,f1);
        mult_out_im_f(i) = mult_in_im * coeff_re_temp(INDEX) +  mult_in_re * coeff_im_temp(INDEX);
        mult_out_im(i) = fi(mult_out_im_f(i),s,w1,f1);
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

end 
