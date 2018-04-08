load('bin/mnist_speed_test.mat');
RSLT.repr_gain =  RSLT.m1_repr ./ RSLT.m2_repr ;
RSLT.total_gain = RSLT.m1_total ./ RSLT.m2_total;
RSLT = varfun(@mean,RSLT, 'GroupingVariables','num_samples_per_digit');
RSLT.GroupCount = [];
RSLT.Properties.VariableDescriptions{'mean_repr_gain'} = 'Gain (OMP)';
RSLT.Properties.VariableDescriptions{'mean_total_gain'} = 'Gain (SSC)';
RSLT
%spx.io.latex.printDataTable(RSLT)
