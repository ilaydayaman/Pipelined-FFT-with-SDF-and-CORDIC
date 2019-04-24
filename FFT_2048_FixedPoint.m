% Generation of coefficients
% FID = fopen('fft_coefficients.txt','w+');
% 
% for kn=0 : 1 : N/2 -1
%         w = exp(-i*2*pi*kn/N);
%         re=real(w);
%         im=imag(w);
%        fprintf(FID,'%f\n',re);
%        fprintf(FID,'%f\n',im);
% end
% fclose(FID);
% FFT points
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
    input_reg(q) = fft_input(q);
end

fclose('all');


% ********** FFT Parameters **********
WIDTH = N/2;
STAGE = 1;
s=1;
% ********** Stage 1 **********
w1 = 12;
f1 = 9;
% Butterfly real numbers
for a=1 : 1 : WIDTH 
    n1 = input_reg(2*a-1);
    n2 = fft_input(N+a*2-1);
    %fi(v,s,w,f)
    [stage1_output_re(a),stage1_output_re(a+WIDTH)] = my_butterfly(n1,n2);
    stage1_output_re(a) = fi(stage1_output_re(a),s,w1,f1);
    stage1_output_re(a+WIDTH) = fi(stage1_output_re(a+WIDTH),s,w1,f1);
end

% Butterfly imaginary numbers
for a=1 : 1 : WIDTH
    n1 = input_reg(2*a);
    n2 = fft_input(N+a*2);
    [stage1_output_im(a),stage1_output_im(a+WIDTH)] = my_butterfly(n1,n2);
    stage1_output_im(a) = fi(stage1_output_im(a),s,w1,f1);
    stage1_output_im(a+WIDTH) = fi(stage1_output_im(a+WIDTH),s,w1,f1);
end

% Multiplication
for a=1 : 1 : WIDTH
    temp = stage1_output_re(a+WIDTH);
    stage1_output_re(a+WIDTH) = stage1_output_re(a+WIDTH) * coeff_re(a) - stage1_output_im(a+WIDTH) * coeff_im(a);
    stage1_output_im(a+WIDTH) = temp * coeff_im(a) + stage1_output_im(a+WIDTH) * coeff_re(a);
    stage1_output_re(a+WIDTH) = fi(stage1_output_re(a+WIDTH),s,w1,f1);
    stage1_output_im(a+WIDTH) = fi(stage1_output_im(a+WIDTH),s,w1,f1);
end


% ********** Stage 2 **********
WIDTH = WIDTH/2;
STAGE = STAGE*2; %2
w2 = 13;
f2 = 10;
% *****************************
for b=1 : 1 : STAGE  
    for a=1 : 1 : WIDTH
        n1 = stage1_output_re(a+((b-1)*WIDTH*2));
        n2 = stage1_output_re(a+WIDTH+((b-1)*WIDTH*2));
        [stage2_output_re(a+((b-1)*WIDTH*2)),stage2_output_re(a+WIDTH+((b-1)*WIDTH*2))] = my_butterfly(n1,n2);
        stage2_output_re(a+((b-1)*WIDTH*2)) = fi(stage2_output_re(a+((b-1)*WIDTH*2)),s,w2,f2);
        stage2_output_re(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage2_output_re(a+WIDTH+((b-1)*WIDTH*2)),s,w2,f2);
    end

    for a=1 : 1 : WIDTH
        n1 = stage1_output_im(a+((b-1)*WIDTH*2));
        n2 = stage1_output_im(a+WIDTH+((b-1)*WIDTH*2));
        [stage2_output_im(a+((b-1)*WIDTH*2)),stage2_output_im(a+WIDTH+((b-1)*WIDTH*2))] = my_butterfly(n1,n2);
        stage2_output_im(a+((b-1)*WIDTH*2)) = fi(stage2_output_im(a+((b-1)*WIDTH*2)),s,w2,f2);
        stage2_output_im(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage2_output_im(a+WIDTH+((b-1)*WIDTH*2)),s,w2,f2);
    end   
end

% Multiplication
for b=1 : 1 : STAGE
    for a=1 : 1 : WIDTH
        temp = stage2_output_re(a+WIDTH+((b-1)*WIDTH*2));
        stage2_output_re(a+WIDTH+((b-1)*WIDTH*2)) = stage2_output_re(a+WIDTH+((b-1)*WIDTH*2)) * coeff_re(2*a-1) - stage2_output_im(a+WIDTH+((b-1)*WIDTH*2)) * coeff_im(2*a-1);
        stage2_output_im(a+WIDTH+((b-1)*WIDTH*2)) = temp * coeff_im(2*a-1) + stage2_output_im(a+WIDTH+((b-1)*WIDTH*2)) * coeff_re(2*a-1);
        stage2_output_re(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage2_output_re(a+WIDTH+((b-1)*WIDTH*2)),s,w2,f2);
        stage2_output_im(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage2_output_im(a+WIDTH+((b-1)*WIDTH*2)),s,w2,f2);
    end
end


% ********** Stage 3 **********
WIDTH = WIDTH/2; 
STAGE = STAGE*2; %4
w3 = 14;
f3 = 10;
% *****************************
for b=1 : 1 : STAGE  
    for a=1 : 1 : WIDTH
        n1 = stage2_output_re(a+((b-1)*WIDTH*2));
        n2 = stage2_output_re(a+WIDTH+((b-1)*WIDTH*2));
        [stage3_output_re(a+((b-1)*WIDTH*2)),stage3_output_re(a+WIDTH+((b-1)*WIDTH*2))] = my_butterfly(n1,n2);
        stage3_output_re(a+((b-1)*WIDTH*2)) = stage3_output_re(a+((b-1)*WIDTH*2));
        stage3_output_re(a+WIDTH+((b-1)*WIDTH*2)) = stage3_output_re(a+WIDTH+((b-1)*WIDTH*2));
    end

    for a=1 : 1 : WIDTH
        n1 = stage2_output_im(a+((b-1)*WIDTH*2));
        n2 = stage2_output_im(a+WIDTH+((b-1)*WIDTH*2));
        [stage3_output_im(a+((b-1)*WIDTH*2)),stage3_output_im(a+WIDTH+((b-1)*WIDTH*2))] = my_butterfly(n1,n2);
        stage3_output_im(a+((b-1)*WIDTH*2)) = fi(stage3_output_im(a+((b-1)*WIDTH*2)),s,w3,f3);
        stage3_output_im(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage3_output_im(a+WIDTH+((b-1)*WIDTH*2)),s,w3,f3);
    end   
end

% Multiplication
for b=1 : 1 : STAGE
    for a=1 : 1 : WIDTH
        temp = stage3_output_re(a+WIDTH+((b-1)*WIDTH*2));
        stage3_output_re(a+WIDTH+((b-1)*WIDTH*2)) = stage3_output_re(a+WIDTH+((b-1)*WIDTH*2)) * coeff_re((a-1)*STAGE + 1) - stage3_output_im(a+WIDTH+((b-1)*WIDTH*2)) * coeff_im((a-1)*STAGE + 1);
        stage3_output_im(a+WIDTH+((b-1)*WIDTH*2)) = temp * coeff_im((a-1)*STAGE + 1) + stage3_output_im(a+WIDTH+((b-1)*WIDTH*2)) * coeff_re((a-1)*STAGE + 1);
        stage3_output_re(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage3_output_re(a+WIDTH+((b-1)*WIDTH*2)),s,w3,f3);
        stage3_output_im(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage3_output_im(a+WIDTH+((b-1)*WIDTH*2)),s,w3,f3);
    end
end


% ********** Stage 4 **********
WIDTH = WIDTH/2;
STAGE = STAGE*2; %8
w4 = 14;
f4 = 9;
% *****************************
for b=1 : 1 : STAGE  
    for a=1 : 1 : WIDTH
        n1 = stage3_output_re(a+((b-1)*WIDTH*2));
        n2 = stage3_output_re(a+WIDTH+((b-1)*WIDTH*2));
        [stage4_output_re(a+((b-1)*WIDTH*2)),stage4_output_re(a+WIDTH+((b-1)*WIDTH*2))] = my_butterfly(n1,n2);
        stage4_output_re(a+((b-1)*WIDTH*2)) = fi(stage4_output_re(a+((b-1)*WIDTH*2)),s,w4,f4);
        stage4_output_re(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage4_output_re(a+WIDTH+((b-1)*WIDTH*2)),s,w4,f4);
    end

    for a=1 : 1 : WIDTH
        n1 = stage3_output_im(a+((b-1)*WIDTH*2));
        n2 = stage3_output_im(a+WIDTH+((b-1)*WIDTH*2));
        [stage4_output_im(a+((b-1)*WIDTH*2)),stage4_output_im(a+WIDTH+((b-1)*WIDTH*2))] = my_butterfly(n1,n2);
        stage4_output_im(a+((b-1)*WIDTH*2)) = fi(stage4_output_im(a+((b-1)*WIDTH*2)),s,w4,f4);
        stage4_output_im(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage4_output_im(a+WIDTH+((b-1)*WIDTH*2)),s,w4,f4);
    end   
end

% Multiplication
for b=1 : 1 : STAGE
    for a=1 : 1 : WIDTH
        temp = stage4_output_re(a+WIDTH+((b-1)*WIDTH*2));
        stage4_output_re(a+WIDTH+((b-1)*WIDTH*2)) = stage4_output_re(a+WIDTH+((b-1)*WIDTH*2)) * coeff_re((a-1)*STAGE + 1) - stage4_output_im(a+WIDTH+((b-1)*WIDTH*2)) * coeff_im((a-1)*STAGE + 1);
        stage4_output_im(a+WIDTH+((b-1)*WIDTH*2)) = temp * coeff_im((a-1)*STAGE + 1) + stage4_output_im(a+WIDTH+((b-1)*WIDTH*2)) * coeff_re((a-1)*STAGE + 1);
        stage4_output_re(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage4_output_re(a+WIDTH+((b-1)*WIDTH*2)),s,w4,f4);
        stage4_output_im(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage4_output_im(a+WIDTH+((b-1)*WIDTH*2)),s,w4,f4);
    end
end


% ********** Stage 5 **********
WIDTH = WIDTH/2;
STAGE = STAGE*2;
w5 = 14;
f5 = 9;
% *****************************
for b=1 : 1 : STAGE  
    for a=1 : 1 : WIDTH
        n1 = stage4_output_re(a+((b-1)*WIDTH*2));
        n2 = stage4_output_re(a+WIDTH+((b-1)*WIDTH*2));
        [stage5_output_re(a+((b-1)*WIDTH*2)),stage5_output_re(a+WIDTH+((b-1)*WIDTH*2))] = my_butterfly(n1,n2);
        stage5_output_re(a+((b-1)*WIDTH*2)) = fi(stage5_output_re(a+((b-1)*WIDTH*2)),s,w5,f5);
        stage5_output_re(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage5_output_re(a+WIDTH+((b-1)*WIDTH*2)),s,w5,f5);
    end

    for a=1 : 1 : WIDTH
        n1 = stage4_output_im(a+((b-1)*WIDTH*2));
        n2 = stage4_output_im(a+WIDTH+((b-1)*WIDTH*2));
        [stage5_output_im(a+((b-1)*WIDTH*2)),stage5_output_im(a+WIDTH+((b-1)*WIDTH*2))] = my_butterfly(n1,n2);
        stage5_output_im(a+((b-1)*WIDTH*2)) = fi(stage5_output_im(a+((b-1)*WIDTH*2)),s,w5,f5);
        stage5_output_im(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage5_output_im(a+WIDTH+((b-1)*WIDTH*2)),s,w5,f5);
    end   
end

% Multiplication
for b=1 : 1 : STAGE
    for a=1 : 1 : WIDTH
        temp = stage5_output_re(a+WIDTH+((b-1)*WIDTH*2));
        stage5_output_re(a+WIDTH+((b-1)*WIDTH*2)) = stage5_output_re(a+WIDTH+((b-1)*WIDTH*2)) * coeff_re((a-1)*STAGE + 1) - stage5_output_im(a+WIDTH+((b-1)*WIDTH*2)) * coeff_im((a-1)*STAGE + 1);
        stage5_output_im(a+WIDTH+((b-1)*WIDTH*2)) = temp * coeff_im((a-1)*STAGE + 1) + stage5_output_im(a+WIDTH+((b-1)*WIDTH*2)) * coeff_re((a-1)*STAGE + 1);
        stage5_output_re(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage5_output_re(a+WIDTH+((b-1)*WIDTH*2)),s,w5,f5);
        stage5_output_im(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage5_output_im(a+WIDTH+((b-1)*WIDTH*2)),s,w5,f5);
    end
end


% ********** Stage 6 **********
WIDTH = WIDTH/2;
STAGE = STAGE*2;
w6 = 14;
f6 = 8;
% *****************************
for b=1 : 1 : STAGE  
    for a=1 : 1 : WIDTH
        n1 = stage5_output_re(a+((b-1)*WIDTH*2));
        n2 = stage5_output_re(a+WIDTH+((b-1)*WIDTH*2));
        [stage6_output_re(a+((b-1)*WIDTH*2)),stage6_output_re(a+WIDTH+((b-1)*WIDTH*2))] = my_butterfly(n1,n2);
        stage6_output_re(a+((b-1)*WIDTH*2)) = fi(stage6_output_re(a+((b-1)*WIDTH*2)),s,w6,f6);
        stage6_output_re(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage6_output_re(a+WIDTH+((b-1)*WIDTH*2)),s,w6,f6);
    end

    for a=1 : 1 : WIDTH
        n1 = stage5_output_im(a+((b-1)*WIDTH*2));
        n2 = stage5_output_im(a+WIDTH+((b-1)*WIDTH*2));
        [stage6_output_im(a+((b-1)*WIDTH*2)),stage6_output_im(a+WIDTH+((b-1)*WIDTH*2))] = my_butterfly(n1,n2);
        stage6_output_im(a+((b-1)*WIDTH*2)) = fi(stage6_output_im(a+((b-1)*WIDTH*2)),s,w6,f6);
        stage6_output_im(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage6_output_im(a+WIDTH+((b-1)*WIDTH*2)),s,w6,f6);
    end   
end

% Multiplication
for b=1 : 1 : STAGE
    for a=1 : 1 : WIDTH
        temp = stage6_output_re(a+WIDTH+((b-1)*WIDTH*2));
        stage6_output_re(a+WIDTH+((b-1)*WIDTH*2)) = stage6_output_re(a+WIDTH+((b-1)*WIDTH*2)) * coeff_re((a-1)*STAGE + 1) - stage6_output_im(a+WIDTH+((b-1)*WIDTH*2)) * coeff_im((a-1)*STAGE + 1);
        stage6_output_im(a+WIDTH+((b-1)*WIDTH*2)) = temp * coeff_im((a-1)*STAGE + 1) + stage6_output_im(a+WIDTH+((b-1)*WIDTH*2)) * coeff_re((a-1)*STAGE + 1);
        stage6_output_re(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage6_output_re(a+WIDTH+((b-1)*WIDTH*2)),s,w6,f6);
        stage6_output_im(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage6_output_im(a+WIDTH+((b-1)*WIDTH*2)),s,w6,f6);
    end
end


% ********** Stage 7 **********
WIDTH = WIDTH/2;
STAGE = STAGE*2;
w7 = 14;
f7 = 7;
% *****************************
for b=1 : 1 : STAGE  
    for a=1 : 1 : WIDTH
        n1 = stage6_output_re(a+((b-1)*WIDTH*2));
        n2 = stage6_output_re(a+WIDTH+((b-1)*WIDTH*2));
        [stage7_output_re(a+((b-1)*WIDTH*2)),stage7_output_re(a+WIDTH+((b-1)*WIDTH*2))] = my_butterfly(n1,n2);
        stage7_output_re(a+((b-1)*WIDTH*2)) = fi(stage7_output_re(a+((b-1)*WIDTH*2)),s,w7,f7);
        stage7_output_re(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage7_output_re(a+WIDTH+((b-1)*WIDTH*2)),s,w7,f7);
    end

    for a=1 : 1 : WIDTH
        n1 = stage6_output_im(a+((b-1)*WIDTH*2));
        n2 = stage6_output_im(a+WIDTH+((b-1)*WIDTH*2));
        [stage7_output_im(a+((b-1)*WIDTH*2)),stage7_output_im(a+WIDTH+((b-1)*WIDTH*2))] = my_butterfly(n1,n2);
        stage7_output_im(a+((b-1)*WIDTH*2)) = fi(stage7_output_im(a+((b-1)*WIDTH*2)),s,w7,f7);
        stage7_output_im(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage7_output_im(a+WIDTH+((b-1)*WIDTH*2)),s,w7,f7);
    end   
end

% Multiplication
for b=1 : 1 : STAGE
    for a=1 : 1 : WIDTH
        temp = stage7_output_re(a+WIDTH+((b-1)*WIDTH*2));
        stage7_output_re(a+WIDTH+((b-1)*WIDTH*2)) = stage7_output_re(a+WIDTH+((b-1)*WIDTH*2)) * coeff_re((a-1)*STAGE + 1) - stage7_output_im(a+WIDTH+((b-1)*WIDTH*2)) * coeff_im((a-1)*STAGE + 1);
        stage7_output_im(a+WIDTH+((b-1)*WIDTH*2)) = temp * coeff_im((a-1)*STAGE + 1)+ stage7_output_im(a+WIDTH+((b-1)*WIDTH*2)) * coeff_re((a-1)*STAGE + 1);
        stage7_output_re(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage7_output_re(a+WIDTH+((b-1)*WIDTH*2)),s,w7,f7);
        stage7_output_im(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage7_output_im(a+WIDTH+((b-1)*WIDTH*2)),s,w7,f7);
    end
end

% ********** Stage 8 **********
WIDTH = WIDTH/2;
STAGE = STAGE*2;
w8 = 14;
f8 = 7;
% *****************************
for b=1 : 1 : STAGE  
    for a=1 : 1 : WIDTH
        n1 = stage7_output_re(a+((b-1)*WIDTH*2));
        n2 = stage7_output_re(a+WIDTH+((b-1)*WIDTH*2));
        [stage8_output_re(a+((b-1)*WIDTH*2)),stage8_output_re(a+WIDTH+((b-1)*WIDTH*2))] = my_butterfly(n1,n2);
        stage8_output_re(a+((b-1)*WIDTH*2)) = fi(stage8_output_re(a+((b-1)*WIDTH*2)),s,w8,f8);
        stage8_output_re(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage8_output_re(a+WIDTH+((b-1)*WIDTH*2)),s,w8,f8);
    end

    for a=1 : 1 : WIDTH
        n1 = stage7_output_im(a+((b-1)*WIDTH*2));
        n2 = stage7_output_im(a+WIDTH+((b-1)*WIDTH*2));
        [stage8_output_im(a+((b-1)*WIDTH*2)),stage8_output_im(a+WIDTH+((b-1)*WIDTH*2))] = my_butterfly(n1,n2);
        stage8_output_im(a+((b-1)*WIDTH*2)) = fi(stage8_output_im(a+((b-1)*WIDTH*2)),s,w8,f8);
        stage8_output_im(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage8_output_im(a+WIDTH+((b-1)*WIDTH*2)),s,w8,f8);
    end   
end

% Multiplication
for b=1 : 1 : STAGE
    for a=1 : 1 : WIDTH
        temp = stage8_output_re(a+WIDTH+((b-1)*WIDTH*2));
        stage8_output_re(a+WIDTH+((b-1)*WIDTH*2)) = stage8_output_re(a+WIDTH+((b-1)*WIDTH*2)) * coeff_re((a-1)*STAGE + 1) - stage8_output_im(a+WIDTH+((b-1)*WIDTH*2)) * coeff_im((a-1)*STAGE + 1);
        stage8_output_im(a+WIDTH+((b-1)*WIDTH*2)) = temp * coeff_im((a-1)*STAGE + 1) + stage8_output_im(a+WIDTH+((b-1)*WIDTH*2)) * coeff_re((a-1)*STAGE + 1);
        stage8_output_re(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage8_output_re(a+WIDTH+((b-1)*WIDTH*2)),s,w8,f8);
        stage8_output_im(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage8_output_im(a+WIDTH+((b-1)*WIDTH*2)),s,w8,f8);
    end
end

% ********** Stage 9 (2) **********
WIDTH = WIDTH/2;
STAGE = STAGE*2;
w9 = 14;
f9 = 7;
% *****************************
for b=1 : 1 : STAGE  
    for a=1 : 1 : WIDTH
        n1 = stage8_output_re(a+((b-1)*WIDTH*2));
        n2 = stage8_output_re(a+WIDTH+((b-1)*WIDTH*2));
        [stage9_output_re(a+((b-1)*WIDTH*2)),stage9_output_re(a+WIDTH+((b-1)*WIDTH*2))] = my_butterfly(n1,n2);
        stage9_output_re(a+((b-1)*WIDTH*2)) = fi(stage9_output_re(a+((b-1)*WIDTH*2)),s,w9,f9);
        stage9_output_re(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage9_output_re(a+WIDTH+((b-1)*WIDTH*2)),s,w9,f9);
    end

    for a=1 : 1 : WIDTH
        n1 = stage8_output_im(a+((b-1)*WIDTH*2));
        n2 = stage8_output_im(a+WIDTH+((b-1)*WIDTH*2));
        [stage9_output_im(a+((b-1)*WIDTH*2)),stage9_output_im(a+WIDTH+((b-1)*WIDTH*2))] = my_butterfly(n1,n2);
        stage9_output_im(a+((b-1)*WIDTH*2)) = fi(stage9_output_im(a+((b-1)*WIDTH*2)),s,w9,f9);
        stage9_output_im(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage9_output_im(a+WIDTH+((b-1)*WIDTH*2)),s,w9,f9);
    end   
end

% Multiplication
for b=1 : 1 : STAGE
    for a=1 : 1 : WIDTH
        temp = stage9_output_re(a+WIDTH+((b-1)*WIDTH*2));
        stage9_output_re(a+WIDTH+((b-1)*WIDTH*2)) = stage9_output_re(a+WIDTH+((b-1)*WIDTH*2)) * coeff_re((a-1)*STAGE + 1) - stage9_output_im(a+WIDTH+((b-1)*WIDTH*2)) * coeff_im((a-1)*STAGE + 1);
        stage9_output_im(a+WIDTH+((b-1)*WIDTH*2)) = temp * coeff_im((a-1)*STAGE + 1) + stage9_output_im(a+WIDTH+((b-1)*WIDTH*2)) * coeff_re((a-1)*STAGE + 1);
        stage9_output_re(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage9_output_re(a+WIDTH+((b-1)*WIDTH*2)),s,w9,f9);
        stage9_output_im(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage9_output_im(a+WIDTH+((b-1)*WIDTH*2)),s,w9,f9);
    end
end


% ********** Stage 10 (3) **********
WIDTH = WIDTH/2;
STAGE = STAGE*2;
w10 = 14;
f10 = 6;
% *****************************
for b=1 : 1 : STAGE  
    for a=1 : 1 : WIDTH
        n1 = stage9_output_re(a+((b-1)*WIDTH*2));
        n2 = stage9_output_re(a+WIDTH+((b-1)*WIDTH*2));
        [stage10_output_re(a+((b-1)*WIDTH*2)),stage10_output_re(a+WIDTH+((b-1)*WIDTH*2))] = my_butterfly(n1,n2);
        stage10_output_re(a+((b-1)*WIDTH*2)) = fi(stage10_output_re(a+((b-1)*WIDTH*2)),s,w10,f10);
        stage10_output_re(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage10_output_re(a+WIDTH+((b-1)*WIDTH*2)),s,w10,f10);
    end

    for a=1 : 1 : WIDTH
        n1 = stage9_output_im(a+((b-1)*WIDTH*2));
        n2 = stage9_output_im(a+WIDTH+((b-1)*WIDTH*2));
        [stage10_output_im(a+((b-1)*WIDTH*2)),stage10_output_im(a+WIDTH+((b-1)*WIDTH*2))] = my_butterfly(n1,n2);
        stage10_output_im(a+((b-1)*WIDTH*2)) = fi(stage10_output_im(a+((b-1)*WIDTH*2)),s,w10,f10);
        stage10_output_im(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage10_output_im(a+WIDTH+((b-1)*WIDTH*2)),s,w10,f10);
    end   
end

% Multiplication
for b=1 : 1 : STAGE
    for a=1 : 1 : WIDTH
        temp = stage10_output_re(a+WIDTH+((b-1)*WIDTH*2));
        stage10_output_re(a+WIDTH+((b-1)*WIDTH*2)) = stage10_output_re(a+WIDTH+((b-1)*WIDTH*2)) * coeff_re((a-1)*STAGE + 1) - stage10_output_im(a+WIDTH+((b-1)*WIDTH*2)) * coeff_im((a-1)*STAGE + 1);
        stage10_output_im(a+WIDTH+((b-1)*WIDTH*2)) = temp * coeff_im((a-1)*STAGE + 1) + stage10_output_im(a+WIDTH+((b-1)*WIDTH*2)) * coeff_re((a-1)*STAGE + 1);
        stage10_output_re(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage10_output_re(a+WIDTH+((b-1)*WIDTH*2)),s,w10,f10);
        stage10_output_im(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage10_output_im(a+WIDTH+((b-1)*WIDTH*2)),s,w10,f10);
    end
end


% ********** Stage 11 (4) **********
WIDTH = WIDTH/2;
STAGE = STAGE*2;
w11 = 12;
f11 = 4;
% *****************************
for b=1 : 1 : STAGE  
    for a=1 : 1 : WIDTH
        n1 = stage10_output_re(a+((b-1)*WIDTH*2));
        n2 = stage10_output_re(a+WIDTH+((b-1)*WIDTH*2));
        [stage11_output_re(a+((b-1)*WIDTH*2)),stage11_output_re(a+WIDTH+((b-1)*WIDTH*2))] = my_butterfly(n1,n2);
        stage11_output_re(a+((b-1)*WIDTH*2)) = fi(stage11_output_re(a+((b-1)*WIDTH*2)),s,w11,f11);
        stage11_output_re(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage11_output_re(a+WIDTH+((b-1)*WIDTH*2)),s,w11,f11);
    end

    for a=1 : 1 : WIDTH
        n1 = stage10_output_im(a+((b-1)*WIDTH*2));
        n2 = stage10_output_im(a+WIDTH+((b-1)*WIDTH*2));
        [stage11_output_im(a+((b-1)*WIDTH*2)),stage11_output_im(a+WIDTH+((b-1)*WIDTH*2))] = my_butterfly(n1,n2);
        stage11_output_im(a+((b-1)*WIDTH*2)) = fi(stage11_output_im(a+((b-1)*WIDTH*2)),s,w11,f11);
        stage11_output_im(a+WIDTH+((b-1)*WIDTH*2)) = fi(stage11_output_im(a+WIDTH+((b-1)*WIDTH*2)),s,w11,f11);
    end   
end
% 
% % Sorting bit-reversed output
% %for z=1 : 1 : N
% %    fft_output[z] = stage4_output_re
% %end


% FFT Reference
for a=1 : 1 : N
    input_complex(a) = fft_input(2*a-1)+1i*fft_input(2*a);
end
ref = fft(input_complex);
ref_inv = bitrevorder(ref);

ref_inv_re = real(ref_inv);
ref_inv_im = imag(ref_inv);
diff_re = ref_inv_re - stage11_output_re;
diff_im = ref_inv_im - stage11_output_im;
diff_re_procent = (diff_re./ref_inv_re)*100;

figure(1);
clf;
subplot(2,1,2);
plot(diff_re);
axis([0 2048 -0.5 0.5]);
title('Difference between floating and fixed point');
subplot(2,1,1);
plot(ref_inv_re,'k'), hold on;
plot(stage11_output_re,'--r');
axis([0 2048 -100 100]);
legend('Floatin point','Fixed point');
title('2048 point FFT real numbers');

figure(2);
clf;
subplot(2,1,2);
plot(diff_im);
axis([0 2048 -0.5 0.5]);
title('Difference between floating and fixed point');
subplot(2,1,1);
plot(ref_inv_im,'k'), hold on;
plot(stage11_output_im,'--r');
axis([0 2048 -100 100]);
legend('Floatin point','Fixed point');
title('2048 point FFT imaginary numbers');

figure(3)
plot(diff_re_procent);
axis([0 2048 -100 100]);
title('Deviation in % between floating and fixed point - real numbers');

% Butterfly Function
function [sum_out, sub_out] = my_butterfly(n1,n2)
    sum_out = n1+n2;
    sub_out = n1-n2;
end