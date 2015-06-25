Data Sets
===========================

.. highlight:: matlab



Yale Faces Database
-----------------------------------


Loading the faces::

    yf = SPX_YaleFaces();
    yf.load();


Number of subjects::

    ns = yf.num_subjects();


Images to load per subject::

    ni = yf.ImagesToLoadPerSubject;

Images of a particular subject::

    Y = yf.get_subject_images(i);


Resized images of a particular subject::

    Y = yf.get_subject_images_resized(i)

Total images::

    yf.num_total_images()

Size of image in pixels::

    yf.image_size()

Image by global index across all subjects::

    yf.get_image_by_glob_idx(index)

Resize all images in buffer::

    yf.resize_all(width, height)
    yf.resize_all(42, 48);


Describe the contents of the database::

    yf.describe()


Create a canvas of images randomly chosen from all subjects::

    canvas = yf.create_random_canvas();
    imshow(canvas);
    colormap(gray);
    axis image;
    axis off;


Creating a canvas for a particular subject::

    yf.resize_all(42, 48);
    canvas = yf.create_subject_canvas(1);
    imshow(canvas);
    colormap(gray);
    axis image;
    axis off;



Pick ten random images from each subject::

    images = yf.training_set_a()