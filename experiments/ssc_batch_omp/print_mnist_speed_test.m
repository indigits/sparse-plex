load('bin/mnist_speed_test.mat');
RSLT.total_gain = RSLT.m1_total ./ RSLT.m2_total;
RSLT.repr_gain =  RSLT.m1_repr ./ RSLT.m2_repr ;
RSLT = varfun(@mean,RSLT, 'GroupingVariables','num_samples_per_digit');
RSLT.GroupCount = [];
RSLT.Properties.VariableDescriptions{'num_samples_per_digit'} = 'Images Per Digit';
RSLT.Properties.VariableDescriptions{'mean_m1_total'} = 'SSC-OMP (M1)';
RSLT.Properties.VariableDescriptions{'mean_m1_repr'} = 'OMP (M1)';
RSLT.Properties.VariableDescriptions{'mean_m2_total'} = 'SSC-OMP (M2)';
RSLT.Properties.VariableDescriptions{'mean_m2_repr'} = 'OMP (M2)';
RSLT.Properties.VariableDescriptions{'mean_total_gain'} = 'Gain (SSC)';
RSLT.Properties.VariableDescriptions{'mean_repr_gain'} = 'Gain (OMP)';
RSLT
spx.io.rst.print_data_table(RSLT)


