load mit200;

annotated_times = tm(ann);
beat =  diff(annotated_times);
heart_rate = mean(60./beat);
fprintf('Heart rate: %.2f\n', heart_rate);