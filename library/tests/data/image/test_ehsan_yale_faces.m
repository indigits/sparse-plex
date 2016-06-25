function tests = test_ehsan_yale_faces
  tests = functiontests(localfunctions);
end

function setupOnce(testCase)
    close all;
end

function teardownOnce(testCase)
    close all;
end

function test_basic(testCase)
    yf = spx.data.image.EhsanYaleFaces();
    verifyEqual(testCase, yf.image_height, 48);
    verifyEqual(testCase, yf.image_width, 42);
    verifyEqual(testCase, yf.num_subjects, 38);
    verifyEqual(testCase, yf.num_faces_per_subject, 64);
    verifyEqual(testCase, yf.num_total_faces, 64*38);
end

function test1(testCase)
    yf = spx.data.image.EhsanYaleFaces();
    mf = spx.graphics.Figures();
    mf.new_figure('Example faces');
    canvas = yf.create_random_canvas(5, 5);
    imshow(canvas);
    colormap(gray);
    axis image;
    axis off;
    pause(.2);
end