function heart_rate = heartrate(r_peak_times)
    % r_peak_times are the times where r peaks are observed
    beat =  diff(r_peak_times);
    heart_rate = mean(60./beat);
end
