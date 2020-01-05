clear all
%Project 3
%Hypothesis Testing Applied to Segregating A & B Students
%Adesoji Bello

syms s
thresh = 1.5;       %Threshold 
P_A = 0.4;          %Probability of A
P_B = 0.6;          %Probability of B
scores = [0:1:20];       %Range of scores
counts = [0:1:100];

%% 
%Section A

fx_A1 =  piecewise(s>= 0 & s <=8, 0.01, s >= 9 & s <=19, 0.01*s - 0.07, s==20,0.14); 
fx_B = piecewise(s>= 0 & s <=1, 0.01, s >= 2 & s <=5, 0.02, s>5 & s<11,0.01*s - 0.03...
    , s>= 11 & s <=15, 0.08, s>15 & s<=20, 0.23 - 0.01*s);

%Convolve Vector A
fx_Aval = eval(subs(fx_A1,s, scores));
fx2a = conv(fx_Aval,fx_Aval);
fx3a = conv(fx2a, fx_Aval);
fx4a = conv(fx3a, fx_Aval);
fx_A = conv(fx4a, fx_Aval)';                   %PMF of total points for Student A



%Convolve Vector B
fx_Bval = eval(subs(fx_B,s, scores));
fx2b = conv(fx_Bval,fx_Bval);
fx3b = conv(fx2b, fx_Bval);
fx4b = conv(fx3b, fx_Bval);
fx_B = conv(fx4b, fx_Bval);                      %PMF of total points for Student B


figure(1)
plot (counts,fx_A,'linewidth',2)
hold on
title('PMF of Student A & Student B for Long Questions ')
xlabel('scores')
ylabel('Probability of scores')

plot (counts,fx_B,'linewidth',2)
hold off
grid on
xlabel('scores')
ylabel('Probability of scores')
legend('Student A', 'Student B')


%Estimation of Decision Region
for i=0:1:100
    
    if (fx_A(i+1)/fx_B(i+1)) < thresh
        DecB(i+1) = find(fx_A==fx_A(i+1)) -1;
        
    else
        continue;
    end
end

DecA = [max(DecB)+1:100];


DecB_val = fx_B(1: max(DecB)+1);
DecA_val = fx_A(min(DecA)+1:end);
countB = counts(1:max(DecB)+1);
countA = counts(min(DecA)+1:end);


%Probability of awarding grade A when Student deserves grade B
m = length (DecA);

Pb_AnB = 0;
for i = 0:1:100
    
    for j = 1:1:m
        if i == DecA(j)
        Pb_AnB = Pb_AnB + fx_B(i+1);
        break;
        else
            continue;
        end
        
    end
    
   p = Pb_AnB; 
end
disp('The Probability of a Student getting A instead of B for Section A is :');
Pb_AnB = p

%Probability of awarding grade B when Student deserves grade A
m = length (DecB);

Pb_BnA = 0;
for i = 0:1:100
    
    for j = 1:1:m
        if i == DecB(j)
        Pb_BnA = Pb_BnA + fx_A(i+1);
        else
            continue;
        end
        
    end
    
   k = Pb_BnA; 
end
disp('The Probability of a Student getting B instead of A for section A is :');
Pb_BnA = k

Pb_error = (Pb_BnA*P_A) + (Pb_AnB * P_B);
disp('The Probability of error for longer questions is :');
Pb_error
%%
%Section B
%Hypothesis results verification via statistics
% %Estimation of Probability of Student A with Grade B Vice Versa
N = 10000;
yk = [];
q = length(DecB);
 for i = 1:1:N
    random_number = randsample(counts,1,true,fx_A);
     for j =1:1:q
    
        if random_number == DecB(j)
            yk = [yk random_number];
            break;
        else
            continue;
        end
    
    end

 end
 p = length(yk)/N;
disp('The Probability of a Student getting Grade B instead of A for 10000 samples of Section B is :');
Pb_AnB = p
 
xk = [];
q = length(DecA);
 for i = 1:1:N
    random_number = randsample(counts,1,true,fx_B);
     for j =1:1:q
    
        if random_number == DecA(j)
            xk = [xk random_number];
            break;
        else
            continue;
        end
    
    end

 end
 v = length(xk)/N;
disp('The Probability of a Student getting Grade A instead of B for 10000 samples of Section B is :');
Pb_AnB = v

Pbl_error = (Pb_BnA*P_A) + (Pb_AnB * P_B);
disp('The Probability of error for longer questions with 10000 samples is :');
Pbl_error

%%
%
%SECTION C (HARDER QUESTIONS)

fx_Ahard =  piecewise(s>= 0 & s <=4, 0.02, s >4 & s <12, 0.01*s - 0.02, s>=12 & s<=13,0.1...
    ,s >13 & s <=17, -0.02*s + 0.36,s==18, 0.02, s>=19 & s<=20,0.01);
fx_Bhard = piecewise(s>= 0 & s <=1, 0.03, s >= 2 & s <=6, 0.01*s +0.02, s>=7 & s<=8,0.08...
    , s>= 9 & s <=17, 0.18-0.01*s, s>=18 & s<=20, 0.01);

fx_Ah = eval(subs(fx_Ahard,s, scores));
fx2ha = conv(fx_Ah,fx_Ah);
fx3ha = conv(fx2ha, fx_Ah);
fx4ha = conv(fx3ha, fx_Ah);
fx_Ah = conv(fx4ha, fx_Ah)';                   %PMF of total points for Student A

%Convolve Vector B
fx_Bh = eval(subs(fx_Bhard,s, scores));
fx2hb = conv(fx_Bh,fx_Bh);
fx3hb = conv(fx2hb, fx_Bh);
fx4hb = conv(fx3hb, fx_Bh);
fx_Bh = conv(fx4hb, fx_Bh);                      %PMF of total points for Student B

figure(2)
plot (counts,fx_Ah,'linewidth',2)
hold on
title('PMF for Student A and Student B with Harder Questions')
xlabel('scores')
ylabel('Probability of scores')
plot (counts,fx_Bh,'linewidth',2)
grid on
hold off
legend('Student A', 'Student B')

%Estimation of Decision Region for Harder Questions
DecBh = [];
DecAh = []; 
for i=0:1:100
    
    if (fx_Ah(i+1)/fx_Bh(i+1)) > thresh
        DecAh = [DecAh (find(fx_Ah==fx_Ah(i+1)) -1)];
        continue;
    else
         DecBh = [DecBh (find(fx_Bh==fx_Bh(i+1)) -1)];
    end
end

%Probability of awarding grade A given he deserves grade B

m = length (DecAh);

Pb_AnB = 0;
for i = 0:1:100
    
    for j = 1:1:m
        if i == DecAh(j)
        Pb_AnB = Pb_AnB + fx_Bh(i+1);
        break;
        else
            continue;
        end
        
    end
    
   p = Pb_AnB; 
end
disp('The Probability of a Student getting A instead of B given harder questions is :');
Pb_AnB = p
% 
%Probability of awarding grade B given he scored grade A
m = length (DecBh);

Pb_BnA = 0;
for i = 0:1:100
    
    for j = 1:1:m
        if i == DecBh(j)
        Pb_BnA = Pb_BnA + fx_Ah(i+1);
        else
            continue;
        end
        
    end
    
   k = Pb_BnA; 
end
disp('The Probability of a Student getting B in lieu of A given harder questions is :');
Pb_BnA = k

Pbh_error = (Pb_BnA*P_A) + (Pb_AnB * P_B);
disp('The Probability of error for harder questions is :');
Pbh_error

%%
%Section D (SHORTER QUESTIONS)
fx_Ashort =  piecewise(s>= 0 & s <=6, 0, s >=7 & s <=10, 0.01, s>=11 & s<14,0.02*s - 0.20...
    ,s >=14 & s <=22, 0.08, s>=23 & s<=25,0.52 - 0.02*s);
fx_Bshort = piecewise(s==0, 0, s >= 1 & s <=6, 0.01, s>=7 & s<11,0.01*s - 0.05...
    , s>= 11 & s <=21, 0.06, s>21 & s<=25, 0.27-0.01*s);
scoress = [0:1:25]; 
fx_As = eval(subs(fx_Ashort,s, scoress));
fx2sa = conv(fx_As,fx_As);
fx3sa = conv(fx2sa, fx_As);
fx_As = conv(fx3sa, fx_As);                      %PMF of total points for Student A

%Convolve Vector B
fx_Bs = eval(subs(fx_Bshort,s, scoress));
fx2sb = conv(fx_Bs,fx_Bs);
fx3sb = conv(fx2sb, fx_Bs);
fx_Bs = conv(fx3sb, fx_Bs);                      %PMF of total points for Student B

% 
figure(3)
plot (counts,fx_As,'linewidth',2)
hold on
title('PMF for Student A and Student B with Shorter Questions')
xlabel('scores')
ylabel('Probability of scores')

plot (counts,fx_Bs,'linewidth',2)
hold off
grid on
legend('Student A', 'Student B') 

%Estimation of Decision Region for Shorter Questions
DecBs = [];
DecAs = []; 
for i=0:1:100
    
    if (fx_As(i+1)/fx_Bs(i+1)) > thresh
        DecAs = [DecAs (find(fx_As==fx_As(i+1)) -1)];
        continue;
    else
        DecBs = [DecBs (find(fx_Bs==fx_Bs(i+1)) -1)];
    end
end

%Probability of awarding grade A given he scored grade B for shorter Questions

m = length (DecAs);

Pb_AnB = 0;
for i = 0:1:100
    
    for j = 1:1:m
        if i == DecAs(j)
        Pb_AnB = Pb_AnB + fx_Bs(i+1);
        break;
        else
            continue;
        end
        
    end
    
   p = Pb_AnB; 
end
disp('The Probability of a Student getting A instead of B given shorter questions is :');
Pb_AnB = p

%Probability of awarding grade B given he scored grade A
m = length (DecBs);

Pb_BnA = 0;
for i = 0:1:100
    
    for j = 1:1:m
        if i == DecBs(j)
        Pb_BnA = Pb_BnA + fx_As(i+1);
        else
            continue;
        end
        
    end
    
   k = Pb_BnA; 
end
disp('The Probability of a Student getting B in lieu of A given a shorter questions is :');
Pb_BnA = k

Pbs_error = (Pb_BnA*P_A) + (Pb_AnB * P_B);
disp('The Probability of error for shorter questions is :');
Pbs_error