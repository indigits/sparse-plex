function tests = test_standard_images
  tests = functiontests(localfunctions);
end

function setupOnce(testCase)
    figure;
end
function teardownOnce(testCase)
    close;
end

function test_barbara(testCase)
    image = spx.data.standard_images.barbara_gray_512x512();
    imshow(uint8(image));
    pause(.1);
end

function test_cameraman(testCase)
    image = spx.data.standard_images.cameraman_gray_512x512();
    imshow(uint8(image));
    pause(.1);
end

function test_lake(testCase)
    image = spx.data.standard_images.lake_gray_512x512();
    imshow(uint8(image));
    pause(.1);
end

