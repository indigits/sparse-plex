
function [symbols, starts, durations] = dtmf_detector(signal, fs)
window_length = floor(fs * 50 / 1000);
overlap_length = floor(window_length / 2);
n_fft = 2^nextpow2(window_length);
% compute the spectrogram
[s, f, t] = spectrogram(signal,hamming(window_length),...
    overlap_length,n_fft, fs, 'yaxis',...
    'MinThreshold', -50, 'reassigned');
ps = abs(s);

[nf, nt] = size(s);
% symbols
all_symbols  = {'1','2','3','4','5','6','7','8','9','*','0','#'};
% there are 4 low frequencies
low_frequencies = [697 770 852 941];
% there are 4 high frequencies
high_frequencies = [1209 1336 1477];
all_frequencies = [low_frequencies high_frequencies];


% prepare an array of 12 elements for low frequencies of each tone
lows = repelem(low_frequencies, 3);
% prepare an array of 12 elements for high frequencies of each tone
highs = repmat(high_frequencies, 1, 4);

% pair them up
f_pairs = [lows; highs];

col_sums = sum(ps);
max_col_sum = max(col_sums);
threshold  = max_col_sum / 4;
t_indices = find(col_sums > threshold);

index_seq = zeros(size(t));
for i=t_indices
    % disp(t(i));
    % pick up the column at specified time
    ps_at_t = ps(:, i);
    [peak_values, peak_freqs] = findpeaks(ps_at_t, f, 'SortStr','descend', 'MinPeakHeight', max(ps_at_t) / 2);
    peak_freqs = round(peak_freqs');
    peak_freqs = nearest_frequencies(all_frequencies, peak_freqs);
    index = freq_to_symbol(peak_freqs);
    index_seq(i) = index;
end
% identify the starts of runs in the index sequence
% this excludes the first run and the index here is zero based
starts = find(diff(index_seq) ~= 0);
% identify the lengths of runs of same index
run_lengths = diff([0 starts numel(index_seq)]);
% include the first start
starts = [1 (starts + 1)];
% compress the index sequence to only the first index of each run
index_seq = index_seq(starts);
% only keep the non-zero indexes
symbol_locs = find(index_seq);
index_seq = index_seq(symbol_locs);
starts = starts(symbol_locs);
run_lengths = run_lengths(symbol_locs);
symbols = all_symbols(index_seq);
durations = t(starts + run_lengths - 1) - t(starts);
starts = t(starts);
function index = freq_to_symbol(peak_freqs)
    peak_freqs = sort(peak_freqs);
    low = peak_freqs(1);
    high = peak_freqs(2);
    index_1 = find(low_frequencies == low);
    index_2 = find(high_frequencies == high);
    index = (index_1 -1 ) * 3 + index_2;
end
end


function freq = nearest_frequency(all_frequencies, freq)
    differences = abs(all_frequencies - freq);
    [min_diff, loc] = min(differences);
    freq = all_frequencies(loc);
end

function frequencies = nearest_frequencies(all_frequencies, peak_freqs)
    frequencies = zeros(size(peak_freqs));
    for i=1:numel(peak_freqs)
        freq =  peak_freqs(i);
        differences = abs(all_frequencies - freq);
        [min_diff, loc] = min(differences);
        if min_diff < 15
            frequencies(i) = all_frequencies(loc);
        end
    end
end

