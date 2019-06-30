function test_func_handle_pair()
clc;
close all;
clearvars;
make mex_demo_func_handle.cpp; 

A = magic(6);
A = [
1 1 1  1 0
2 2 2  2 1
-1 -1 -1 -1 -1
1 0 1 0 -2]

    function y = forward(x)
        y = A *x;
    end
    function y = backward(x)
        x
        y = (x' * A)'
    end

%input.A = @(x) A * x;
input.A = @forward;
input.At = @backward;
input.M = size(A, 1);
input.N = size(A, 2);
mex_demo_func_handle(input);

end

