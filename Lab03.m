
clear all; close all;

% -------- CONST ----------
wall1_start = [60, 40];
wall1_end = [200, 40];
wall2_start = [70, 90];
wall2_end = [180, 90];

v_user = 20;

bs_position = [140, 50];
user_initial_position = [30, 10];

wx = 140;
wy = 50;

f = 3.6 * 10^9;
Pt = 36.99; % dbm 5W
refflection = 0.7;

signal = zeros(600);

observation_time = 6; % [s]
time_interval = 0.01; 

time_points = 0:time_interval:observation_time;
received_power = zeros(size(time_points));

H1 = 0;
H2 = 0;
H3 = 0;

%Calculating mirrored points
mirroredPoint1 = [bs_position(1), wall1_start(2) - bs_position(2)+ wall1_start(2)];
mirroredPoint2 = [bs_position(1), wall2_start(2) - bs_position(2)+ wall2_start(2)];

% -----------------------

for t = 1:numel(time_points)

    user_position = user_initial_position + [0, v_user * time_points(t)];

    H1 = 0;
    H2 = 0;
    H3 = 0;

    % Calc main H1
    if(user_position(2) < bs_position(2))
        isConnected = dwawektory(user_position(1), user_position(2), bs_position(1), bs_position(2), wall1_start(1), wall1_start(2), wall1_end(1), wall1_end(2));

        if(isConnected == -1)
            r1 = calcDistance(user_position(1), user_position(2), bs_position(1), bs_position(2));
            H1 = calcH(1, r1, f);
        end
    else
        isConnected = dwawektory(user_position(1), user_position(2), bs_position(1), bs_position(2), wall2_start(1), wall2_start(2), wall2_end(1), wall2_end(2));

        if(isConnected == -1)
            r1 = calcDistance(user_position(1), user_position(2), bs_position(1), bs_position(2));
            H1 = calcH(1, r1, f);
        end
    end

    %calc reflected signal 
    H2 = calculateMirrored(user_position, mirroredPoint1, wall1_start, wall1_end, wall2_start, wall2_end);
    H3 = calculateMirrored(user_position, mirroredPoint2, wall2_start, wall2_end, wall1_start, wall1_end);

    H = H1 + H2 + H3;

    if(H == 0) 
        H = 10*10^-9;
    end
    
    received_power(t) = Pt + 20 * log10(abs(H));
end


figure;
plot(time_points, received_power, "b", 'LineWidth', 0.1);
xlabel('Czas (s)');
ylabel('Moc sygnału odebranego (dBm)');
title('Moc sygnału odebranego przez użytkownika');
grid on;


% ---------- HELPERS -------

function H = calculateMirrored(user_position, mirroredPoint, wall1_start, wall1_end, wall2_start, wall2_end)

    H = 0;
    refflection = 0.7;
    f = 3.6 * 10^9;
    
    isConnectedMirroredPointWall = dwawektory(user_position(1), user_position(2), mirroredPoint(1), mirroredPoint(2), wall1_start(1), wall1_start(2), wall1_end(1), wall1_end(2));
    
    if(isConnectedMirroredPointWall == 1)

        % is crossed with second wall
        isCrossedWithSecondWall = dwawektory(user_position(1), user_position(2), mirroredPoint(1), mirroredPoint(2), wall2_start(1), wall2_start(2), wall2_end(1), wall2_end(2));
        if(isCrossedWithSecondWall == -1)

            r = calcDistance(user_position(1), user_position(2), mirroredPoint(1), mirroredPoint(2));
            H = calcH(refflection, r, f);
        end
    end

    return
end

function dist = calcDistance(xa, ya, xb, yb)
    dist = sqrt((xa - xb)^2 + (ya - yb)^2);
end

function H = calcH (R, r, f)
    c = 3 * 10^8;
    
    lambda = c / f;

    H = R * (lambda / (4 * pi * r)) * exp( (-j * 2 * pi * r) / lambda);
end




