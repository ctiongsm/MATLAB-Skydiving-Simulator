%Skydiving Simulation

clc
close all
clear all

%% User Information

prompt = {'Enter Starting Jump Height in ft: ','Enter your height in inches: ','Enter your weight in kg: '};
dlg_title = 'Skydiving Simulation User Jump Info';
num_lines = 1;
defans = {'15000','70','70'};
answer = inputdlg(prompt,dlg_title,num_lines,defans);

h=str2num(answer{1})*0.3048; %Jump Height in m
height=str2num(answer{1});
jh=str2num(answer{2})*0.0254; %Jumper's Height in m
m=str2num(answer{3}); %Jumper's Weight in kg

prompt2 = {'Enter Parachute Release Height: '};
dlg_title2 = 'Parachute Info';
num_lines2=1;
defaultans2 = {'5000'};
answer2 = inputdlg(prompt2,dlg_title2,num_lines2,defaultans2);
pheight=str2num(answer2{1});
ph=str2num(answer2{1})*0.3048;

% make sure user pulls parachute at 5000 ft
if ph < 1524;
h = msgbox('Pulled the parachute too low. Serious Injury is possible. Enter value over 5000 ft','Error');
disp(h);
end

%% Constants and Equations for Jumper

g=9.8; %Gravity m/s^2
A=jh*0.4572; %ft^2 SA of human
c=1.2; % Drag coefficient of a human

%% Conditional Variables

%Conditional Air Densities kg/m^3
if (h > 0 ) && (h <= 1524)
p= 1.1865;
elseif (h >1524) && (h <3048)
p=0.95815;
elseif (h >3048) && (h<4572)
else
p=0.6061;
end



%% Initial Jump > Terminal V1

ydis1=0;
vo=0;
%vt=sqrt((2*m*g)/(c*p*A)); %solving for terminal
t1=0;
y1=[];
yd1=[];

for t=1:10000
vt1=vo+g*t;
vo=vt1;
ydis1=ydis1+(vt1*t);
t1=t1+1;
y1=[y1,vt1];
yd1=[yd1,ydis1];
if vt1>=sqrt((2*m*g)/(c*p*A))
break
end
end


%% Part 2 (Terminal Velocity to Pulling the Parachute
           
           ydis2=h-ydis1-ph;
           t2=ydis2/vt1;
           
           %% Constants for parachute
           
           Cd=1.75; %given drag coefficient of parachute
           SA= 135*(0.3048)^2; %given surface area of parachute m^2
           
           %% Part 3 Parachute to 2nd terminal Velocity
           
           ydis3=0;
           vo2=0;
           %vtp=sqrt((2*m*g)/(Cd*0.8225*SA)); %solving for terminal
           t3=0;
           y3=[];
           yd3=[];
           
           for t=1:1000
           vt2=vo2+g*t;
           vo2=vt2;
           ydis3=ydis3+(vt2*t);
           t3=t3+1;
           y3=[y3,vt2];
           yd3=[yd3,ydis3];
           if vt2>=sqrt((2*m*g)/(Cd*0.8225*SA))
           break
           end
           end
           te=t2+t3;
           
           %% Part 4
           
           ydis4=h-ydis1-ydis2-ydis3;
           t4=ydis4/vt2;
           %% Plotting
           
           Ttotal=t1+t2+t3+t4;
           Tmins=floor(Ttotal/60);
           Tsecs=((Ttotal/60)-Tmins)*100;
           x1=linspace(0,t1,3);
           x2=linspace(t1,t2,3);
           y2=[vt1 vt1 vt1];
           x3=linspace(t2,te,3);
           y3=[y3 y3 y3];
           x4=linspace(te,t4,3);
           y4=[vt2 vt2 vt2];
           
           figure('Name','Velocity vs. Time') %velocity time graph
           plot(x1,y1,'g-',x2,y2,'r--',x3,y3,'b',x4,y4,'m-','LineWidth',2)
           xlim([0 150])
           title('Velocity vs. Time')
           xlabel('Time')
           ylabel('Velocity')
           legend('vt1','vt2','vt3','vt4','Location','northeast')
           hold on
           
           tx1=linspace(0,t1,3);
           py1=[h-yd1];
           tx2=linspace(t1,t2,3);
           py2=linspace(h-ydis1,ydis2,3);
           tx3=linspace(t2,te,3);
           py3=linspace(ydis2,h-ydis2,3);
           tx4=linspace(te,t4,3);
           py4=linspace(h-ydis2,0,3);
           
           % figure('Name','Position vs. Time') %position time graph
           % plot(tx1,py1,'c-',tx2,py2,'r--',tx3,py3,'b',tx4,py4,'k-','LineWidth',2)
           % title('Position vs. Time')
           % xlabel('Time')
           % ylabel('Position')
           % legend('ydis1','ydis2','ydis3','ydis4','Location','south')
           
           
           %% animation
           
           figure('Name','Position vs. Time Animation')
           xlabel('Position')
           ylabel('Time')
           title('Position v. Time')
           for i=1:length(tx4)
           for i=1:length(tx1)
           plot(tx1(i),py1(i),'ro--')
           hold on
           pause(2)
           end
           
           for i=length(tx1):length(tx2)
           plot(tx2(i),py2(i),'ro')
           hold on
           pause(2)
           end
           
           for i=length(tx2):length(tx3)
           plot(tx3(i),py3(i),'ro--')
           hold on
           pause(2)
           end
           
           for i=length(tx3):length(tx4)
           plot(tx4(i),py4(i),'ro')
           hold on
           pause(2)
           end
           break
           end
           %% Output
           fprintf('During this jump from %d feet, the parachute is pulled at %d feet, it would take the user %d minutes and %d seconds to land', height, pheight,Tmins,Tsecs)
