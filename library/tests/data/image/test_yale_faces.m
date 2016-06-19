function tests = test_yale_faces
  tests = functiontests(localfunctions);
end

function setupOnce(testCase)
    close all;
end

function teardownOnce(testCase)
    close all;
end

function test_basic(testCase)
    yf = spx.data.image.YaleFaces();
    yf.load();
    verifyEqual(testCase, yf.ImageHeight, 192);
    verifyEqual(testCase, yf.ImageWidth, 168);
    verifyEqual(testCase, yf.num_subjects, 38);
    verifyEqual(testCase, yf.num_total_images, 64*38);
    verifyEqual(testCase, yf.image_size, 192*168);
    yf.describe;
end

function test1(testCase)
    yf = spx.data.image.YaleFaces();
    yf.load();
    yf.describe();
    mf = spx.graphics.Figures();
    mf.new_figure('Example faces');
    canvas = yf.create_random_canvas();
    imshow(canvas);
    colormap(gray);
    axis image;
    axis off;

    yf.resize_all(42, 48);
    mf.new_figure('Subject 1');
    canvas = yf.create_subject_canvas(1);
    imshow(canvas);
    colormap(gray);
    axis image;
    axis off;
end