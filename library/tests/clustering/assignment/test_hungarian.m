function tests = test_hungarian
  tests = functiontests(localfunctions);
end

function test_7x7(testCase)
    A = [88 7   10  53  5   30  56
        75  69  80  70  53  81  57
        88  73  87  89  64  5   84
        18  98  1   14  25  5   29
        19  8   71  96  36  19  54
        94  88  7   87  17  36  24
        69  63  44  47  45  68  89
        ];
    expected_cost = 147;
    [matching, actual_cost] = spx.fast.hungarian(A);
    verifyEqual(testCase, expected_cost, actual_cost);
end

function test_6x6(testCase)
    A = [
        47 2   10  98  46  36
        39  59  58  70  52  6
        99  93  94  25  13  86
        91  3   27  44  95  43
        15  18  92  76  40  57
        88  34  83  29  19  24
    ];
    expected_cost = 76;
    [matching, actual_cost] = spx.fast.hungarian(A);
    verifyEqual(testCase, expected_cost, actual_cost);
end

function test_10x10_1(testCase)
    A = [
        34  59  70  72  71  47  38  26  52  56
        12  74  38  3   70  4   55  23  97  50
        63  69  14  46  30  48  75  75  49  33
        70  59  42  34  73  98  36  73  98  91
        10  50  42  90  2   54  76  84  50  94
        20  18  69  55  10  78  4   79  86  65
        90  53  49  68  8   96  16  88  24  48
        78  93  81  28  67  2   22  44  83  16
        75  10  5   72  43  67  86  27  84  62
        79  35  27  90  45  19  93  61  20  22
    ];
    expected_cost = 146;
    [matching, actual_cost] = spx.fast.hungarian(A);
    verifyEqual(testCase, expected_cost, actual_cost);
end

function test_10x10_2(testCase)
    A = [
        6   85  56  19  43  65  61  38  34  85
        64  61  28  25  12  98  5   13  6   67
        68  71  81  31  2   87  93  56  60  27
        38  80  95  6   72  56  71  91  33  58
        53  23  26  9   32  11  2   39  79  7
        31  30  28  72  60  4   85  86  19  59
        33  61  92  62  60  4   46  10  9   99
        83  83  12  70  70  84  85  99  28  21
        97  93  66  20  25  82  42  27  57  12
        76  98  8   33  43  8   29  20  4   40
    ];
    expected_cost = 84;
    [matching, actual_cost] = spx.fast.hungarian(A);
    verifyEqual(testCase, expected_cost, actual_cost);
end
