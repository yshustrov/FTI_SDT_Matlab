% SDT_test
clc;
clear;

P1 = 50*133; T1 = 298.15; 
%q1 = 'O2:2095 N2:7808 Ar:0.0093 CO2:0.0004';   % standard atmosphere composition
%q1 = 'CO2:1.0';
q1 = 'N2:1.0';
driven_mech = 'airNASA9ions.cti';

gas1 = Solution(driven_mech);
set(gas1,'Temperature',T1,'Pressure',P1,'MoleFractions',q1);

rho1 = density(gas1);
a1 = soundspeed_fr(gas1);
U1 = 5*a1;

%gas2 = PostShock_eq(U1, P1, T1, q1, driven_mech);
%gas5 = Solution(driven_mech);

%[p5,UR,gas5] = reflected_eq(gas1,gas2,gas5,U1);

Mmin = 2.0;
Mmax = 12.0;
Mdelta = 0.1;
  %  THIS VALUE MUST BE ADJUSTED IN SOME CASES, INCREASE IF NO SOLUTION, DECREASE IF PLOTTING RANGE TOO LARGE
Mspan = Mmin:Mdelta:Mmax;%linspace(1.2,12.0,0.2);
N=size(Mspan);
N(1)=[];
p21=zeros(1,N);
T21=zeros(1,N);
p51=zeros(1,N);
T51=zeros(1,N);
    for i = 1:N
       U1 = a1*Mspan(i);
       gas5 = Solution(driven_mech);
       set(gas5,'Temperature',T1,'Pressure',P1,'MoleFractions',q1);
       
       gas2 = PostShock_eq(U1, P1, T1, q1, driven_mech); 
       [p5,UR,gas5] = reflected_eq(gas1,gas2,gas5,U1);
       
       p21(i) = pressure(gas2)/P1;
       T21(i) = temperature(gas2)/T1;
       p51(i) = pressure(gas5)/P1;
       T51(i) = temperature(gas5)/T1;
    end
    
he1='M1';
he2='p2/p1';
he3='T2/T1';
he4='p5/p1';
he5='T5/T1';
he6='p4';
he7='t_rab';


fid=fopen('output_line_M_SDT.txt','w');
fprintf(fid,[he1 ' ' he2 ' ' he3 ' ' he4 ' ' he5 '\n']);
fprintf(fid, '%f %f %f %f %f \n', [Mspan; p21; T21; p51 ;T51]);
fclose(fid);
