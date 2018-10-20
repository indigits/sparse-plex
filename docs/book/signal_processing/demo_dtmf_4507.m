clearvars;
close all;
clc;
rng default;

mf = spx.graphics.Figures;

mf.new_figure();
[signal, fs] = spx.dsp.dtmf({'4', '5', '0', '7'});
time = (0:(numel(signal) - 1)) / fs;
plot(1e3*time, signal);
xlabel('Time (ms)');
ylabel('Amplitude');
grid on;
saveas(gcf, 'images/dtmf_4507.png');

mf.new_figure();
envelope_signal = envelope(signal, 80,'rms');
plot(1e3*time, envelope_signal);
xlabel('Time (ms)');
ylabel('Amplitude');
grid on;
saveas(gcf, 'images/dtmf_4507_envelope.png');

mf.new_figure();
pulsewidth(envelope_signal,fs)
saveas(gcf, 'images/dtmf_4507_pulses.png');

mf.new_figure();
periodogram(signal, [], [], fs);
saveas(gcf, 'images/dtmf_4507_periodogram.png');


% find the power spectrum and corresponding frequencies
[pxx,f]=periodogram(signal,[],[],fs);

n_freqs = 5;
% Let's find the most important frequencies
% 'NPeaks', n_freqs
[peak_values, peak_freqs] = findpeaks(pxx, f, 'SortStr','descend', 'MinPeakHeight', max(pxx) / 10);
peak_freqs = round(peak_freqs');
% Let's also mark them on a plot
mf.new_figure();
findpeaks(pxx, f, 'SortStr','descend','MinPeakHeight', max(pxx) / 10);


mf.new_figure();
spectrogram(signal, [], [], [], fs, 'yaxis');
% restrict the y-axis between 500Hz to 1500 Hz.
ylim([0.5 1.5]);
saveas(gcf, 'images/dtmf_4507_spectrogram.png');

mf.new_figure();
window_length = floor(fs * 50 / 1000);
overlap_length = floor(window_length / 2);
n_fft = 2^nextpow2(window_length);
spectrogram(signal,hamming(window_length),overlap_length,n_fft, fs, 'yaxis');
ylim([0.5 1.5]);
saveas(gcf, 'images/dtmf_4507_spectrogram_50ms.png');

mf.new_figure();
overlap_length = floor(0.8 * window_length );
spectrogram(signal,hamming(window_length),overlap_length,n_fft, fs, 'yaxis', 'MinThreshold', -50);
ylim([0.5 1.5]);
saveas(gcf, 'images/dtmf_4507_spectrogram_50ms_40ms_50db.png');


mf.new_figure();
spectrogram(signal,hamming(window_length),overlap_length,n_fft, fs, 'yaxis', 'MinThreshold', -50, 'reassigned');
ylim([0.5 1.5]);
saveas(gcf, 'images/dtmf_4507_spectrogram_50ms_40ms_50db_reassigned.png');
