.. _sec:motion_segmentation:
 
Motion Segmentation
----------------------------------------------------

The theory of structure from motion and motion segmentation
has evolved over a set of papers 
:cite:`tomasi1991detection,tomasi1992shape,boult1991factorization,poelman1997paraperspective,gear1998multibody,costeira1998multibody,kanatani2001motion`. 
In this section, we review the essential ideas
from this series of work.

A typical image sequence 
(from a single camera shot)
may contain multiple objects moving
independently of each other.
In the simplest model, we can assume that images in a sequence
are views of a single moving object observed by a stationary camera or
a stationary object observed by a moving camera. Only rigid
motions are considered. In either case, the object is
moving with respect to the camera.
The *structure from motion* problem
focuses on recovering the (3D) shape and motion information
of the moving object. 
In the general case, there are multiple objects moving
independently. Thus, we also need to perform a
*motion segmentation* such that motions of 
different objects can be separated and (either
after or simultaneously) shape and motion of each object
can be inferred. 

This problem is typically solved in two stages. In the first
stage, a frame to frame correspondence problem is solved which
identifies 
a set of feature points whose coordinates can be tracked
over the sequence as the point moves from one position to 
other in the sequence.  
We obtain a set of
trajectories for these points over the frames in the video.
If there is a single moving object
or the scene is static and the observer is moving then 
all the feature points will belong to the same object.
Otherwise, we need to cluster these feature points to
different objects moving in different directions.
In the second stage, these trajectories are analyzed to group
the feature points into separate objects and recover the shape
and motion for individual objects. In this section we 
assume that the feature trajectories have been obtained
by an appropriate method. Our focus is to 
identify the moving objects and
obtain the
shape and motion information for each object from the
trajectories.

 
Modeling structure from motion for single object
""""""""""""""""""""""""""""""""""""""""""""""""""""""

We start with the simple model of a static camera
and a moving object. All feature point trajectories belong
to the moving object. Our objective is to demonstrate
that the subspace spanned by feature trajectories
of a single moving object is a low dimensional 
subspace.

Let the image sequence consist of :math:`F` frames denoted by
:math:`1 \leq f \leq F`. Let us assume that :math:`S` 
feature points of the moving object have been tracked
over this image sequence. Let :math:`(u_{fs}, v_{fs})` be the
image coordinates of the :math:`s`-th point in :math:`f`-th frame.
We form the feature trajectory vector for the :math:`s`-th
point by stacking its coordinates for the :math:`F` frames
vertically as


.. math::
    y_s = \begin{bmatrix} 
    u_{1s} & v_{1s} & u_{2s} & v_{2s} & \dots & 
    u_{Fs} & v_{Fs} 
    \end{bmatrix}^T. 

Putting together the feature trajectory vectors of :math:`S`
points in a single feature trajectory matrix, we obtain 


.. math::
    Y = \begin{bmatrix} y_1 & y_2 &\dots & y_S \end{bmatrix}.

This is the data matrix under consideration from which
the shape and motion of the object need to be inferred.

We need two coordinate systems. We use the camera
coordinate system as the world coordinate system
with the :math:`Z`-axis along the optical axis. The coordinates
of different points in the object are changing from
frame to frame in the world coordinate system as the object
is moving. We also establish a coordinate system within
the object with origin at the centroid of the feature points
such that the coordinates of individual points do not
change from frame to frame in the object coordinate system.
The (rigid) motion of the object is then modeled by the
translation (of the centroid) and rotation of its coordinate
system with respect to the world coordinate system. Let
:math:`(a_s, b_s, c_s)` be the coordinate of the :math:`s`-th point
in the object coordinate system. Then, the matrix


.. math:: 

    \begin{bmatrix}
    a_1 & a_2 & \dots & a_S\\
    b_1 & b_2 & \dots & b_S\\
    c_1 & c_2 & \dots & c_S\\
    \end{bmatrix}

represents the shape of the object (w.r.t. its centroid).

Let us choose an orthonormal basis in the object coordinate
system. Let :math:`d_f` be the position of the centroid and 
:math:`(i_f, j_f, k_f)` be the (orthonormal) basis vectors of 
the object coordinate system in the :math:`f`-th frame. Then,
the position of the :math:`s`-th point in the world coordinate
system in :math:`f`-th frame is given by


.. math::
    h_{fs} = d_f + a_s i_f + b_s j_f + c_s k_f.

Assuming orthographic projection and letting 
:math:`h_{fs} = (u_{fs}, v_{fs}, w_{fs})`, the image 
coordinates are obtained by chopping of the third component
:math:`w_{fs}`.
We define the rotation matrix for :math:`f`-th frame as 


.. math::
    R_f \triangleq \begin{bmatrix} i_f & j_f & k_f \end{bmatrix}
    = \begin{bmatrix} \underline{i}_f \\ \underline{j}_f 
    \\ \underline{k}_f \end{bmatrix}

where :math:`\underline{i}_f`, :math:`\underline{j}_f`, :math:`\underline{k}_f`
are the row vectors of :math:`R_f`. Let :math:`x_s = (a_s, b_s, c_s, 1)`
be the homogeneous coordinates of the :math:`s`-th point in object
coordinate system. We can write the homogeneous coordinates
in camera coordinate system as 


.. math::
    \begin{bmatrix}
    h_{fs}\\
    1
    \end{bmatrix}
    =
    \begin{bmatrix}
    R_f & d_f \\
    0_{1 \times 3} & 1
    \end{bmatrix}
    x_s.

If we write :math:`d_f = (d_{fi}, d_{fj}, d_{fk})`, then, the
data matrix :math:`Y` can be factorized as


.. math::
    Y = \begin{bmatrix}
    u_{11} & \dots & u_{1S}\\
    v_{11} & \dots & v_{1S}\\
    \vdots & \dots & \vdots \\
    \vdots & \dots & \vdots \\
    u_{F1} & \dots & u_{FS}\\
    v_{F1} & \dots & v_{FS}
    \end{bmatrix}
    =
    \left[ 
    \begin{array}{c|c}
    \underline{i}_1 & d_{1i}\\
    \underline{j}_1 & d_{1j}\\
    \vdots & \vdots \\ 
    \vdots & \vdots \\ 
    \underline{i}_F & d_{Fi}\\
    \underline{j}_F & d_{Fj}
    \end{array}
    \right]
    \begin{bmatrix}
    x_1 & \dots & x_S
    \end{bmatrix}.

We rewrite this as 


.. math::
    Y  = \mathbb{M} \mathbb{S}

where :math:`\mathbb{M}` represents the motion
information of the object and 
:math:`\mathbb{S}` 
\footnote{The last row of :math:`\mathbb{S}` as formulated
above consists of :math:`1`s.}
represents the shape information
of the object. 
This factorization is known as
the *Tomasi-Kanade factorization* of shape and motion
information of a moving object.
Note that :math:`\mathbb{M} \in \RR^{2F \times 4}` 
and :math:`\mathbb{S} \in \RR^{4 \times S}`. Thus
the rank of :math:`Y` is at most 4. 
Thus the feature trajectories
of the rigid motion of an object span an 
up to 4-dimensional
subspace of the trajectory space :math:`\RR^{2F}`. 
 
Solving the structure from motion problem
""""""""""""""""""""""""""""""""""""""""""""""""""""""

We digress a bit to understand how to perform the
factorization of :math:`Y` into :math:`\mathbb{M}` and :math:`\mathbb{S}`.
Using SVD, :math:`Y` can be decomposed as


.. math::
    Y = U \Sigma V^T.

Since :math:`Y` is at most rank :math:`4`, we keep only the 
first 4 singular values as 
:math:`\Sigma = \text{diag}(\sigma_1, \sigma_2, \sigma_3, \sigma_4)`. Matrices :math:`U \in \RR^{2F \times 4}` and :math:`V \in \RR^{S \times 4}` are the left and right singular matrices respectively.

There is no unique factorization of :math:`Y` in general. 
One simple factorization can be obtained by defining:


.. math::
    \widehat{\mathbb{M}} = U \Sigma^{\frac{1}{2}},
    \quad
    \widehat{\mathbb{S}} = \Sigma^{\frac{1}{2}} V^T.

But for any :math:`4 \times 4` invertible matrix :math:`A`, 


.. math::
    \mathbb{M} = \widehat{\mathbb{M}} A,
    \quad
    \mathbb{S} = A^{-1}\widehat{\mathbb{S}}

is also a possible solution since
:math:`\mathbb{M} \mathbb{S} = \widehat{\mathbb{M}} \widehat{\mathbb{S}} = Y`. 
Remember that :math:`\mathbb{M}` is not an arbitrary matrix
but represents the rigid motion of an object. There is 
considerable structure inside the motion matrix. These
structural constraints can be used to compute an appropriate
:math:`A` and thus obtain :math:`\mathbb{M}` from :math:`\widehat{\mathbb{M}}`.
To proceed further, let us break :math:`A` into two parts


.. math::
    A = \left[\begin{array}{c|c} A_R & a_t \end{array}\right]

where :math:`A_R \in \RR^{4 \times 3}` is the rotational
component and :math:`a_t \in \RR^4` is related to translation. 
We can now write:


.. math::
    \mathbb{M} = \left [ 
    \begin{array}{c|c}
    \widehat{\mathbb{M}} A_R & \widehat{\mathbb{M}} a_t 
    \end{array}
    \right]


**Rotational constraints** Recall that 
:math:`R_f` is a rotation matrix hence its rows are 
unit norm and orthogonal to each other.
Thus every row of :math:`\widehat{\mathbb{M}} A_R`
is unit norm and every pair of rows (for
a given frame) is orthogonal. This yields 
following constraints.


.. math::
    \widehat{m}_{2f-1} A_R A_R^T 
    \widehat{m}_{2f-1}^T = 1
    \quad 
    \widehat{m}_{2f} A_R A_R^T 
    \widehat{m}_{2f}^T = 1



.. math::
    \widehat{m}_{2f-1} A_R A_R^T 
    \widehat{m}_{2f}^T = 0

where :math:`\widehat{m}_k` are rows of
matrix :math:`\widehat{\mathbb{M}}` for
:math:`1 \leq f \leq F`. 
This over-constrained system can be solved for
the entries of :math:`A_R` using least squares techniques.

**Translational constraints**
Recall that the image of a centroid of a set of points
under an isometry (rigid motion) is the centroid 
of the images of the points under the same isometry.
The homogeneous coordinates of the centroid in the
object coordinate system are :math:`(0, 0, 0, 1)`. 
The coordinates of the centroid in image are
:math:`(\frac{1}{S} \sum_s {u_{f s}}, \frac{1}{S} \sum_s {v_{f s}} )`.
Putting back, we obtain


.. math::
    \frac{1}{S}
    \begin{bmatrix}
    \sum_s {u_{1 s}}\\
    \sum_s {v_{1 s}}\\
    \vdots\\
    \sum_s {u_{F s}}\\
    \sum_s {v_{F s}}\\
    \end{bmatrix}
    = \left [ 
    \begin{array}{c|c}
    \widehat{\mathbb{M}} A_R & \widehat{\mathbb{M}} a_t 
    \end{array}
    \right] 
    \begin{bmatrix}
    0 \\ 0 \\ 0 \\1
    \end{bmatrix} = \widehat{\mathbb{M}} a_t .

A least squares solution for :math:`a_t` is straight-forward.

 
Modeling motion for multiple objects
""""""""""""""""""""""""""""""""""""""""""""""""""""""

The generalization of modeling of motion of one object
to multiple objects is straight-forward. Let there be
:math:`K` objects in the scene moving independently. 
\footnote{Our realization of an object is a set of
feature points undergoing same rotation and translation
over a sequence of images. The notion of locality, color, 
connectivity etc. plays no role in this definition.
It is possible that two 
visually distinct objects are undergoing same rotation
and translation within a given image sequence. For the
purposes of inferring an object from its motion, these
two visually distinct object are treated as one.}
Let :math:`S_1, S_2, \dots, S_K` feature points be tracked
for objects :math:`1,2, \dots, K` respectively  for :math:`F` frames
with
:math:`S = \sum_k S_k`. Let these feature trajectories be
put in a data matrix :math:`Y \in \RR^{2F \times S}`.
In general, we don't know which feature point belongs
to which object and how many feature points are there
for each object. Of course there is at least one
feature point for each object (otherwise the object
isn't being tracked at all). We could permute the
columns of :math:`Y` via an (unknown) permutation :math:`\Gamma`
so that the feature points of each object are placed
contiguously giving us 


.. math::
    Y^* =  Y \Gamma = \begin{bmatrix}
    Y_1 & Y_2 & \dots & Y_K
    \end{bmatrix}.

Clearly, each submatrix :math:`Y_k` (:math:`1 \leq k \leq K`) 
which consists of feature trajectories of one object
spans an (up to) 4 dimensional subspace. 
Now, the problem
of *motion segmentation* is essentially separating
:math:`Y` into :math:`Y_k` which reduces to a standard
subspace clustering problem.

Let us dig a bit deeper to see how the motion shape
factorization identity changes for the multi-object
formulation. Each data submatrix :math:`Y_k` can be factorized
as 


.. math::
    Y_k = U_k \Sigma_k V_k^T = \mathbb{M}_k  \mathbb{S}_k
    = \widehat{\mathbb{M}}_k A_k A_k^{-1} \widehat{\mathbb{S}}_k.

:math:`Y^*` now has the canonical factorization:


.. math::
    Y^* = 
    \begin{bmatrix}
    \mathbb{M}_1 & \dots & \mathbb{M}_K
    \end{bmatrix}
    \begin{bmatrix}
    \mathbb{S}_1 & \dots & 0 \\
    \vdots & \ddots & \vdots\\
    0 & \dots & \mathbb{S}_K
    \end{bmatrix}.

If we further denote :


.. math::
    \mathbb{M} = \begin{bmatrix}
    \mathbb{M}_1 & \dots & \mathbb{M}_K
    \end{bmatrix}\\
    \widehat{\mathbb{M}} = \begin{bmatrix}
    \widehat{\mathbb{M}}_1 & \dots & \widehat{\mathbb{M}}_K
    \end{bmatrix}\\
    \mathbb{S} = \begin{bmatrix}
    \mathbb{S}_1 & \dots & 0 \\
    \vdots & \ddots & \vdots\\
    0 & \dots & \mathbb{S}_K
    \end{bmatrix}\\
    \widehat{\mathbb{S}} = \begin{bmatrix}
    \widehat{\mathbb{S}}_1 & \dots & 0 \\
    \vdots & \ddots & \vdots\\
    0 & \dots & \widehat{\mathbb{S}}_K
    \end{bmatrix}\\
    A = \begin{bmatrix}
    A_1 & \dots & 0 \\
    \vdots & \ddots & \vdots\\
    0 & \dots & A_K
    \end{bmatrix}\\
    U = \begin{bmatrix}
    U_1 & \dots & U_K
    \end{bmatrix}\\
    \Sigma = \begin{bmatrix}
    \Sigma_1 & \dots & 0 \\
    \vdots & \ddots & \vdots\\
    0 & \dots & \Sigma_K
    \end{bmatrix}\\
    V = \begin{bmatrix}
    V_1 & \dots & 0 \\
    \vdots & \ddots & \vdots\\
    0 & \dots & V_K
    \end{bmatrix},

then we obtain a factorization similar to the single
object case given by


.. math::
    Y^* = \mathbb{M} \mathbb{S} 
    =  \widehat{\mathbb{M}} A A^{-1}\widehat{\mathbb{S}}\\
    \mathbb{S}  = A^{-1}\widehat{\mathbb{S}} 
    = A^{-1} \Sigma^{\frac{1}{2}} V^T\\
    \mathbb{M} = \widehat{\mathbb{M}} A = U \Sigma^{\frac{1}{2}} A.

Thus, when the segmentation of :math:`Y` in terms of the unknown
permutation :math:`\Gamma` has been obtained, (sorted) data matrix 
:math:`Y^*` can be factorized into shape and motion components
as appropriate.

**Limitations**
Our discussion so far has established that 
feature trajectories for each moving object span a 4-dimensional
space. There are a number of reasons why this is only *approximately*
valid: perspective distortion of camera, tracking errors, and
pixel quantization. Thus, a subspace clustering algorithm
should allow for the presence of noise or corruption of data
in real life applications. 
