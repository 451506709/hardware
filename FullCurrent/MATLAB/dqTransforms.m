t = 0:0.001:1;
w = 4 * pi;
theta = 45*pi/180;

Ia = cos(w*t);
Ib = cos(w*t-2*pi/3);
Ic = cos(w*t-4*pi/3);

subplot(331);
plot(t,Ia,t,Ib,t,Ic);
legend('Ia','Ib','Ic');

Ialpha = Ia;
Ibeta = Ia/sqrt(3) + 2*Ib/sqrt(3);

%Ialpha = ((2.0/3.0) * Ia) - ((1.0/3.0) * Ib) - ((1.0/3.0) * Ic);
%Ibeta  = ((1.0/sqrt(3.0)) * Ib) - ((1.0/sqrt(3.0)) * Ic);

subplot(334);
plot(t,Ialpha,t,Ibeta);
legend('I\alpha','I\beta');

sinTheta = sin(theta);
cosTheta = cos(theta);

Id =  Ialpha * cosTheta + Ibeta * sinTheta;
Iq = -Ialpha * sinTheta + Ibeta * cosTheta;

subplot(337);
plot(t,Id,t,Iq);
legend('Id','Iq');

%{
float errord = IdRef - Id;
float errorq = IqRef - Iq;

IAccumD = limitf32( (errord * KI * DT + IAccumD), 0.43f, -0.43f);
IAccumQ = limitf32( (errorq * KI * DT + IAccumQ), 0.9f, -0.9f);

float Vd = limitf32( errord * KP + IAccumD, 0.43f, -0.43f );
float Vq = limitf32( errorq * KP + IAccumQ, 0.9f, -0.9f );
%}

Vd = Id;
Vq = Iq;

subplot(338);
plot(t,Vd,t,Vq);
legend('Vd','Vq');

Valpha = Vd * cosTheta - Vq * sinTheta;
Vbeta =  Vd * sinTheta + Vq * cosTheta;

subplot(335);
plot(t,Valpha,t,Vbeta);
legend('V\alpha','V\beta');

Va = Valpha;
Vb = -Valpha * 0.5 + sqrt(3.0)/2.0 * Vbeta;
Vc = -Valpha * 0.5 - sqrt(3.0)/2.0 * Vbeta;

subplot(332);
plot(t,Va,t,Vb,t,Vc);
legend('Va','Vb','Vc');

Va = Va*0.5;
Vb = Vb*0.5;
Vc = Vc*0.5;

Vk = (( max([Va; Vb; Vc])' + min([Va; Vb; Vc])' ) * 0.5);

V1 = (Va - Vk')+0.5;
V2 = (Vb - Vk')+0.5;
V3 = (Vc - Vk')+0.5;
Vk = Vk + 0.5; 
subplot(333);
plot(t,V1,t,V2,t,V3,t,Vk);
legend('V1','V2','V3','Vk')

subplot(336);
plot(t,Ia+Ib+Ic);


