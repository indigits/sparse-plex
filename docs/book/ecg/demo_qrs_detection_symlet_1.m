close all;
clearvars;
clc;

duration = 100;
x = spx.ecg.synthetic.simple_multiple(360, duration);
tm = (1:numel(x) ) / 360;
figure;
plot(tm, x);
xlabel('Time (sec)');
ylabel('Amplitude');
grid on;

% Compute the 5-level undecimated decomposition of signal
wt = modwt(x,5);
% Space for keeping the thresholded decomposition 
wtrec = zeros(size(wt));
% Keep the 4-th and 5-th level decompositions of wt
wtrec(4:5,:) = wt(4:5,:);
% Reconstruct the signal
y = imodwt(wtrec,'sym4');

figure;
plot(tm, y);
xlabel('Time (sec)');
ylabel('Amplitude');
grid on;

% nonlinear square transformation
y = y.^2;

% We find the peaks which must be at least
% 150 msec apart and have a height of at least 0.35
[qrspeaks,locs] = findpeaks(y,tm,'MinPeakHeight',0.35,...
    'MinPeakDistance',0.150);
% Plot the signal along with the peaks.
figure;
plot(tm,y)
hold on
plot(locs,qrspeaks,'ro')
xlabel('Seconds');


heart_rate = spx.ecg.heartrate(locs);
fprintf('Heart rate: %.2f beats per minute\n', heart_rate);