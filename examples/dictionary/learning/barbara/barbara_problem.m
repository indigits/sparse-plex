function [ problem ] = barbara_problem( )
%sBARBARATEST Prepares the test s of learning dictionary from
% Barbara image
s.image = spx.data.standard_images.barbara_gray_512x512;
% Block size
s.blkSize = 8;
% Number of atoms in dictionary
s.D = 121;
% Signal dimension
s.N = s.blkSize * s.blkSize;
% Let us create all the patches from image
s.patches = im2col(s.image, [s.blkSize, s.blkSize], 'sliding');
% Select 10 % of patches as training patches
s.training_patches = s.patches(:, 1:10:end);
% Let us construct a 1D-DCT matrix of size 8x11.
dr = sqrt(s.D);
DCT=zeros(s.blkSize,dr);
for k=0:1:dr-1,
    is = 0:1:s.blkSize-1;
    % Create one column
    col=cos(is'*k*pi/dr);
    if k>0
        col=col-mean(col); 
    end;
    DCT(:,k+1)=col/norm(col);
end;
% We create our initial dictionary as a 64x121 size
s.initial_dictionary = kron(DCT, DCT);
s.DCT = DCT;
% We return the setup
problem = s;
end

