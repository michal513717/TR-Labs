close all; clear all;

aerial1 = [100, -0.0125];
aerial2 = [100, 0.0125];

u1 = [50, 70];
u2 = [160, 50];

ap = [100, 0];

f = 6 * 10^9; % [Hz]

Pt = 0.005 / 4;
noise = -125;
c = 3*10^8;
lambda = c / f;

U1SNR = calcLab4_1(u1, aerial1, aerial2, lambda, Pt, noise),
U2SNR = calcLab4_1(u2, aerial1, aerial2, lambda, Pt, noise),

function SNR = calcLab4_1(userPos, aerialFirstPos, aerialSecondPos, lambda, Pt, noise)
    
    distaneBetweenUserAndAerial1 = dist(userPos(1), userPos(2), aerialFirstPos(1), aerialFirstPos(2));
    distaneBetweenUserAndAerial2 = dist(userPos(1), userPos(2), aerialSecondPos(1), aerialSecondPos(2));
    
    differenceBetweenAerialsU1 = abs(distaneBetweenUserAndAerial1 - distaneBetweenUserAndAerial2);
    
    phaseU1 = calcPhase(differenceBetweenAerialsU1, lambda);
    
    if(distaneBetweenUserAndAerial1 > distaneBetweenUserAndAerial2)
        H1 = calcH(lambda, distaneBetweenUserAndAerial1, phaseU1);
        H2 = calcH(lambda, distaneBetweenUserAndAerial2, 0);
    else
        H1 = calcH(lambda, distaneBetweenUserAndAerial1, 0);
        H2 = calcH(lambda, distaneBetweenUserAndAerial2, phaseU1);
    end
    
    Pr = calcPr(Pt, H1 + H2);
    
    SNR = calcSNR(Pr, noise);
end

function phase = calcPhase(dist, lambda)
    phase = rem(dist, lambda) / lambda * 2 * pi;
end

function h = calcH(lambda, r, phase)
    if(phase ~= 0)
        h = (lambda / (4 * pi *r)) * exp(-1i * ((2 * pi *r)/lambda)) * exp(-1i * phase) * exp(-1i * pi);
    else
        h = (lambda / (4 * pi *r)) * exp(-1i * ((2 * pi *r)/lambda));
    end
end

function Pr = calcPr(Pt, H)
    Pr = 10*log10(Pt) + 20*log10(abs(H));
end

function SNR = calcSNR(Pr, noise)
    SNR = Pr - noise;
end

function r = dist(x1, y1, x2, y2)
    r = sqrt((x1 - x2)^2 + (y1 - y2)^2);
end
