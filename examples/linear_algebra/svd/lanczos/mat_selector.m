function A = mat_selector()
switch 3
    case 1
        A = mat_ex_1();
    case 2
        A = mmread('abb313.mtx');
    case 3
        A = mmread('illc1850.mtx');
    otherwise
        error('Select matrix');
end
end
