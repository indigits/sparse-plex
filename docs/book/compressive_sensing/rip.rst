Recovery in presence of measurement noise
===================================================
 
Measurement vector in the presence of noise is given by

.. math::
    	 y =\Phi x + e

where  :math:`e`  is the measurement noise or error.
:math:`\| e \|_2`  is the  :math:`l_2`  size of measurement error.

Recovery error as usual is given by

.. math::
    	\| \Delta (y) - x \|_2 = \| \Delta (\Phi x + e) - x \|_2 


**Stability**  of a recovery algorithm is characterized by comparing variation of recovery error w.r.t. measurement error.

NSP is both necessary and sufficient for establishing guarantees of the form:

.. math:: 

    	\| \Delta (\Phi x) - x \|_2 \leq C \frac{\sigma_K (x)_1}{\sqrt{K}}


These guarantees do not account for presence of noise during measurement. 
We need stronger conditions for handling noise.
The restricted isometry property for sensing matrices comes to our rescue.

 
Restricted isometry property
----------------------------------------------------

A matrix  :math:`\Phi`  satisfies the 
**restricted isometry property**  (RIP) of order  :math:`K`  
if there exists  :math:`\delta_K \in (0,1)`  such that

.. math::
    :label: eq:ripbound

    	(1- \delta_K) \| x \|^2_2 \leq \| \Phi x \|^2_2 \leq (1 + \delta_K) \| x \|^2_2  

holds for all  :math:`x \in \Sigma_K = \{ x : \| x\|_0 \leq K \}` . 


*  If a matrix satisfies RIP of order  :math:`K` , then we can see 
   that it  *approximately*  preserves 
   the size of a  :math:`K`-sparse vector.
*  If a matrix satisfies RIP of order  :math:`2K` , 
   then we can see that it   *approximately*  preserves the 
   distance between any two  :math:`K`-sparse vectors 
   since difference vectors would be  :math:`2K`  sparse. 
*  We say that the matrix is  *nearly orthonormal*  for sparse vectors.
*  If a matrix satisfies RIP of order  :math:`K`  with a constant  
   :math:`\delta_K` , it automatically satisfies
   RIP of any order  :math:`K' < K`  with a constant  
   :math:`\delta_{K'} \leq \delta_{K}` .


Stability
----------------------------------------------------

Informally, a recovery algorithm is stable if recovery error is 
small in the presence of small measurement error.

Is RIP necessary and sufficient for sparse signal recovery from noisy measurements? 

Let us look at the necessary part. 
We will define a notion of stability of the recovery algorithm.

.. _def:recovery_algorithm_stability:

.. definition:: 

    .. index:: Stability of recovery algorithm

    Let  :math:`\Phi : \RR^N \rightarrow \RR^M`  be a sensing matrix 
    and  :math:`\Delta : \RR^M \rightarrow \RR^N`  
    be a recovery algorithm.
    We say that the pair  :math:`(\Phi, \Delta)`  is 
    :math:`C`-stable  if for any  :math:`x \in \Sigma_K` 
    and any  :math:`e \in \RR^M`  we have that
    
    .. math::
        	\| \Delta(\Phi x + e) - x\|_2  \leq C \| e\|_2. 
    

*  Error is added to the measurements.
*  LHS is  :math:`l_2`  norm of recovery error.
*  RHS consists of scaling of the  :math:`l_2`  norm 
   of measurement error.
*  The definition says that recovery error is bounded by 
   a multiple of the measurement error.
*  Thus, adding a small amount of measurement noise 
   shouldn't be causing arbitrarily large recovery error.

It turns out that  :math:`C`-stability requires  
:math:`\Phi`  to satisfy RIP.

.. _thm:stability_requires_rip:

.. theorem:: 

    If a pair  :math:`(\Phi, \Delta)`  is  :math:`C`-stable then
        
    .. math::
        		
            \frac{1}{C} \| x\|_2 \leq \| \Phi x  \|_2   
    
    for all  :math:`x \in \Sigma_{2K}` .

.. proof:: 
    
    Any  :math:`x \in \Sigma_{2K}`  can be written 
    in the form of  :math:`x  = y - z`  where
    :math:`y, z \in \Sigma_K` .
    
    So let  :math:`x \in \Sigma_{2K}` . 
    Split it in the form of  :math:`x = y -z`  
    with  :math:`y, z \in \Sigma_{K}` .
    
    Define
    	
    .. math:: 
    
        	e_y = \frac{\Phi (z - y)}{2} \quad \text{and} \quad e_z = \frac{\Phi (y - z)}{2}
       
    Thus
    	
    .. math:: 
    
        	e_y - e_z = \Phi (z - y) \implies \Phi y + e_y = \Phi z + e_z
    
    We have
    
    .. math:: 
    
        	\Phi y + e_y = \Phi z + e_z = \frac{\Phi (y + z)}{2}.
    
    
    Also, we have
    
    .. math:: 
    
        	\| e_y \|_2 = \| e_z \|_2 = \frac{\| \Phi (y - z) \|_2}{2} = \frac{\| \Phi x \|_2}{2}
    
    Let 
    	
    .. math:: 
    
        	y' = \Delta (\Phi y + e_y) = \Delta (\Phi z + e_z)
    
    Since  :math:`(\Phi, \Delta)`  is  :math:`C`-stable, hence we have
    
    .. math:: 
    
        	\| y'- y\|_2  \leq C \| e_y\|_2. 
    
    also
    
    .. math:: 
    
        	\| y'- z\|_2  \leq C \| e_z\|_2. 
    
    Using the triangle inequality
    
    .. math:: 
    
        	\| x \|_2 &= \| y - z\|_2  = \| y - y' + y' - z \|_2\\ 
        	&\leq \| y - y' \|_2 + \| y' - z\|_2\\
        	&\leq  C \| e_y \|_2 + C \| e_z \|_2 
        	= C (\| e_y \|_2 + \| e_z \|_2)
        	= C \| \Phi x \|_2
    
    Thus we have  :math:`\forall x \in \Sigma_{2K}`  
    
    .. math:: 
    
        		\frac{1}{C}\| x \|_2 \leq \| \Phi x \|_2 

This theorem gives us the lower bound for RIP property of 
order  :math:`2K`  in :eq:`eq:ripbound` with 
:math:`\delta_{2K} = 1 - \frac{1}{C^2}`  as a 
necessary condition for  :math:`C`-stable recovery algorithms.

Note that smaller the constant  :math:`C` , lower is the bound on 
recovery error (w.r.t. measurement error). 
But as  :math:`C \to 1` ,  :math:`\delta_{2K} \to 0`, 
thus reducing the impact of measurement noise requires
sensing matrix  :math:`\Phi`  to be designed with 
tighter RIP constraints.

:math:`C`-stability doesn't require an upper bound on the RIP property 
in  :eq:`eq:ripbound`.

It turns out that If  :math:`\Phi`  satisfies RIP, 
then this is also sufficient for a variety of algorithms 
to be able to successfully recover
a sparse signal from noisy measurements. We will discuss this later.

 
Measurement bounds
----------------------------------------------------

As stated in previous section, for a  :math:`(\Phi, \Delta)`  
pair to be  :math:`C`-stable we require that
:math:`\Phi`  satisfies RIP of order  :math:`2K`  with a constant  
:math:`\delta_{2K}`. 

Let us ignore  :math:`\delta_{2K}`  for the time being and look at 
relationship between  :math:`M` ,  :math:`N` and  :math:`K`.

We have a sensing matrix  :math:`\Phi`  of size 
:math:`M\times N`  and expect it to provide RIP of order  :math:`2K` . 

How many measurements  :math:`M`  are necessary? 

We will assume that  :math:`K < N / 2`. 
This assumption is valid for approximately sparse signals.

Before we start figuring out the bounds, let us develop a special subset of  
:math:`\Sigma_K`  sets.

Consider the set 

.. math::

      U = \{ x \in \{0, +1, -1\}^N : \| x\|_0 = K  \}   


Some explanation: By  :math:`A^N`  we mean  
:math:`A \times A \times \dots \times A`  i.e. 
:math:`N`  times Cartesian product of  :math:`A` .

When we say  :math:`\| x\|_0 = K` , we mean that only  :math:`K`  terms 
in each member of  :math:`U`  can be non-zero 
(i.e.  :math:`-1`  or  :math:`+1` ).

So  :math:`U`  is a set of signal vectors  
:math:`x`  of length  :math:`N`  where each sample takes values 
from  :math:`\{0, +1, -1\}`  and
number of allowed non-zero samples is fixed at  :math:`K` .

An example below explains it further. 

.. example::  U  for  N=6  and  K=2
    
    Each vector in  :math:`U`  will have 6 elements out of which  :math:`2`  
    can be non zero.
    There are  :math:`\binom{6}{2}`  ways of choosing the non-zero elements. 
    Some of those sets are listed below as examples:
    
    .. math:: 
    
        &(+1,+1,0,0,0,0)\\
        &(+1,-1,0,0,0,0)\\
        &(0,-1,0,+1,0,0)\\
        &(0,-1,0,+1,0,0)\\
        &(0,0,0,0,-1,+1)\\
        &(0,0,-1,-1,0,0)  

:math:`U` is a grid in the union of subspaces :math:`\Sigma_K`. 


Revisiting

.. math:: 

      U = \{ x \in \{0, +1, -1\}^N : \| x\|_0 = K  \}   


It's now obvious that

.. math::
    \| x \|_2^2 = K \quad \forall x \in U.

Since there are  :math:`\binom{N}{K}`  ways of choosing  :math:`K`  non-zero elements and each non zero element can take 
either of the two values  :math:`+1`  or  :math:`-1` , hence the cardinality of
set  :math:`U`  is given by:

.. math::
    |U| = \binom{N}{K} 2^K

By definition 

.. math::
      U \subset \Sigma_K.

Further Let  :math:`x, y \in U` .  

Then  :math:`x - y`  will have a maximum of  :math:`2K`  non-zero elements. 
The non-zero elements would have values
:math:`\in \{-2,-1,1,2\}` .

Thus  :math:`\| x - y \|_0 = R \leq 2K`.

Further, :math:`\| x - y \|_2^2 \geq R`.

Hence

.. math::
      \| x - y \|_0 \leq \| x - y \|_2^2 \quad \forall x, y \in U.

We now state a lemma which will help us in getting to the bounds.

.. _lem:rip_bound_X_lemma:

.. lemma:: 
    
    Let  :math:`K`  and  :math:`N`  satisfying  :math:`K < \frac{N}{2}`  be given.
    There exists a set  :math:`X \subset \Sigma_K` such that 
    for any  :math:`x \in X`  we have  :math:`\| x \|_2 \leq \sqrt{K}`
    and for any  :math:`x, y \in X`  with  :math:`x \neq y` ,
    
    .. math::
          \| x - y \|_2 \geq \sqrt{\frac{K}{2}}.
    
    and 
    
    .. math::
          \ln | X | \geq \frac{K}{2} \ln \left( \frac{N}{K} \right) .

The lemma establishes the existence of a set in the union of 
subspaces :math:`\Sigma_K` within a sphere of radius
:math:`\sqrt{K}` whose points are sufficiently apart and
whose size is sufficiently large.

.. proof:: 

    
    We just need to find one set  :math:`X`  which satisfies the requirements of this lemma.
    We have to construct a set  :math:`X`  such that
    
    
    *   :math:`\| x \|_2 \leq \sqrt{K}  \quad \forall x \in X.` 
    *   :math:`\| x - y \|_2 \geq \sqrt{\frac{K}{2}} \quad \forall x, y \in X.` 
    *   :math:`\ln | X | \geq \frac{K}{2} \ln \left( \frac{N}{K} \right)`  or equivalently  :math:`|X| \geq \left( \frac{N}{K} \right)^{\frac{K}{2}}` .
    
    
    
    
    We will construct  :math:`X`  by picking vectors from  :math:`U` . Thus  :math:`X \subset U` .
    
    Since  :math:`x \in X \subset U`  hence   :math:`\| x \|_2 = \sqrt{K} \leq \sqrt{K} \quad \forall x \in X` .
    
    Consider any fixed  :math:`x \in U` .
    
    How many elements  :math:`y`  are there in  :math:`U`  such that  :math:`\|x - y\|_2^2 < \frac{K}{2}`  ?
    
    Define 
    
    
    .. math::
        U_x^2 = \left \{ y \in U : \|x - y\|_2^2  < \frac{K}{2} \right \} 
    
    
    Clearly by requirements in the lemma, if  :math:`x \in X`  then  :math:`U_x^2 \cap X = \phi` . i.e. no vector
    in  :math:`U_x^2`  belongs to  :math:`X` .
    
    How many elements are there in   :math:`U_x^2` ? 

    Let us find an upper bound.
    :math:`\forall x, y \in U`  we have  :math:`\|x - y\|_0  \leq \|x - y\|_2^2` .
    
    
    If  :math:`x`  and  :math:`y`  differ in  :math:`\frac{K}{2}`  or more places, 
    then naturally :math:`\|x - y\|_2^2 \geq \frac{K}{2}` .
    
    Hence if  :math:`\|x - y\|_2^2 < \frac{K}{2}`  then  :math:`\|x - y\|_0 < \frac{K}{2}`  hence  :math:`\|x - y\|_0 \leq \frac{K}{2}`  for any  :math:`x, y \in U_x^2` .
    
    
    So define
    
    
    .. math::
        U_x^0 = \left \{ y \in U : \|x - y\|_0 \leq \frac{K}{2}  \right \}  
    
    
    We have 
    
    
    .. math::
        U_x^2 \subseteq U_x^0
    
    
    Thus we have an upper bound given by
    
    
    .. math::
        | U_x^2 | \leq 
        | U_x^0 |.
    
    
    Let us look at  :math:`U_x^0`  carefully. 
    
    We can choose  :math:`\frac{K}{2}`  indices where  :math:`x`  and  :math:`y`   *may*  differ
    in  :math:`\binom{N}{\frac{K}{2}}`  ways.
    
    At each of these  :math:`\frac{K}{2}`  indices,  :math:`y_i`  can take value as one of  :math:`(0, +1, -1)` .
    
    Thus We have an upper bound
    
    
    .. math::
        | U_x^2 | \leq 
        | U_x^0 | \leq
        \binom {N}{\frac{K}{2}} 3^{\frac{K}{2}}.
    
    
    We now describe an iterative process for building  :math:`X`  from vectors in  :math:`U` .
    
    Say we have added  :math:`j`  vectors to  :math:`X`  namely  :math:`x_1, x_2,\dots, x_j` . 
    
    Then  
    
    
    .. math:: 
    
        (U^2_{x_1} \cup U^2_{x_2} \cup \dots  \cup U^2_{x_j}) \cap X = \phi
    
    
    Number of vectors in  :math:`U^2_{x_1} \cup U^2_{x_2} \cup \dots  \cup U^2_{x_j}` 
    is bounded by  :math:`j \binom {N}{ \frac{K}{2}} 3^{\frac{K}{2}}` .
    
    Thus we have at least 
    
    
    .. math::
        \binom{N}{K} 2^K - j \binom {N}{ \frac{K}{2}} 3^{\frac{K}{2}}  
    
    vectors left in  :math:`U`  to choose from for adding in  :math:`X` .
    
    We can keep adding vectors to  :math:`X`  till there are no more suitable vectors left.
    
    So we can construct a set of size  :math:`|X|`  provided
    
    
    .. math::
        :label: eq:measure_bound_x_size
    
        |X| \binom {N}{ \frac{K}{2}} 3^{\frac{K}{2}} \leq \binom{N}{K} 2^K
    
    
    Now
      
    
    .. math:: 
    
          \frac{\binom{N}{K}}{\binom{N}{\frac{K}{2}}} 
          = \frac
            {\left ( \frac{K}{2} \right ) !  \left (N  - \frac{K}{2} \right ) ! }
            {K! (N-K)!}
          = \prod_{i=1}^{\frac{K}{2}}  \frac{N - K + i}{ K/ 2 + i}
    
    
    Note that  :math:`\frac{N - K + i}{ K/ 2 + i}`  is a decreasing function of  :math:`i` .
    
    Its minimum value is achieved for  :math:`i=\frac{K}{2}`  as  :math:`(\frac{N}{K} - \frac{1}{2})` .
    
    So we have
    
    
    .. math:: 
    
          &\frac{N - K + i}{ K/ 2 + i} \geq \frac{N}{K} - \frac{1}{2}\\
          &\implies \prod_{i=1}^{\frac{K}{2}}  \frac{N - K + i}{ K/ 2 + i}  \geq  \left ( \frac{N}{K} - \frac{1}{2} \right )^{\frac{K}{2}}\\
          &\implies \frac{\binom{N}{K}}{\binom{N}{\frac{K}{2}}} \geq \left ( \frac{N}{K} - \frac{1}{2} \right )^{\frac{K}{2}}
    
    
    Rephrasing :eq:`eq:measure_bound_x_size` we have
    
    .. math::
        |X| \left( \frac{3}{4} \right )^{\frac{K}{2}} \leq   \frac{\binom{N}{K}}{\binom{N}{\frac{K}{2}}}
    
    
    So if
      
    .. math:: 
    
          |X| \left( \frac{3}{4} \right ) ^{\frac{K}{2}}  \leq \left ( \frac{N}{K} - \frac{1}{2} \right )^{\frac{K}{2}}
    
    
    then :eq:`eq:measure_bound_x_size` will be satisfied.
    
    Now it is given that  :math:`K < \frac{N}{2}` . So we have:
    
    .. math:: 
    
        & K < \frac{N}{2}\\
        &\implies \frac{N}{K} > 2\\
        &\implies \frac{N}{4K} > \frac{1}{2}\\
        &\implies \frac{N}{K} - \frac{N}{4K} < \frac{N}{K} - \frac{1}{2}\\
        &\implies \frac{3N}{4K} < \frac{N}{K} - \frac{1}{2}\\
        &\implies \left( \frac{3N}{4K} \right) ^ {\frac{K}{2}}< \left ( \frac{N}{K} - \frac{1}{2} \right )^{\frac{K}{2}}\\
    
    
    Thus we have
    
    .. math::
        \left( \frac{N}{K} \right) ^ {\frac{K}{2}}   \left( \frac{3}{4} \right) ^ {\frac{K}{2}}  < \frac{\binom{N}{K}}{\binom{N}{\frac{K}{2}}}
     
    Choose
    
    .. math::
          |X| = \left( \frac{N}{K} \right) ^ {\frac{K}{2}} 
    
    
    Clearly, this value of  :math:`|X|`  satisfies 
    :eq:`eq:measure_bound_x_size`. 
    Hence  :math:`X`  can have
    at least these many elements. Thus
    
    .. math:: 
    
          &|X| \geq \left( \frac{N}{K} \right) ^ {\frac{K}{2}}\\
          &\implies \ln |X| \geq \frac{K}{2} \ln \left( \frac{N}{K} \right) 
    
    
    which completes the proof.


We can now establish following bound on the required number of 
measurements to satisfy RIP.

At this moment, we won't worry about exact value of  
:math:`\delta_{2K}` . We will just assume that
:math:`\delta_{2K}`  is small in range  :math:`(0, \frac{1}{2}]` .


.. _thm:rip_measurement_bound:

.. theorem:: 
    
    Let  :math:`\Phi`  be an  :math:`M \times N`  matrix that satisfies RIP of order  :math:`2K`  with constant  :math:`\delta_{2K} \in (0, \frac{1}{2}]` .
    Then

    .. math::
          M \geq C K \ln \left ( \frac{N}{K} \right ) 

    where  :math:`C = \frac{1}{2 \ln (\sqrt{24} + 1)} \approx 0.28173` .
    

.. proof:: 
    
    Since  :math:`\Phi`  satisfies RIP of order  :math:`2K`  we have

    .. math:: 
    
          & (1  - \delta_{2K}) \| x \|^2_2 \leq \| \Phi x \|^2_2 \leq (1 + \delta_{2K}) \| x\|^2_2  \quad \forall x \in \Sigma_{2K}.\\
          & \implies (1  - \delta_{2K}) \| x - y \|^2_2 \leq \| \Phi x -  \Phi y\|^2_2 \leq (1 + \delta_{2K}) \| x - y\|^2_2  \quad \forall x, y \in \Sigma_K.
    
    Also

    .. math::
          \delta_{2K} \leq \frac{1}{2} \implies 1 - \delta_{2K} > \frac{1}{2} \text{ and }  1 + \delta_{2K} \leq \frac{3}{2}
    
    Consider the set  :math:`X \subset U \subset \Sigma_K`  developed in  
    :ref:`above <lem:rip_bound_X_lemma>`.
    
    We have

    .. math:: 
    
        &\| x - y\|^2_2 \geq  \frac{K}{2} \quad \forall x, y \in X\\
        &\implies (1  - \delta_{2K}) \| x - y \|^2_2 \geq  \frac{K}{4}\\
        &\implies \| \Phi x -  \Phi y\|^2_2 \geq  \frac{K}{4}\\
        &\implies \| \Phi x -  \Phi y\|_2 \geq  \sqrt{\frac{K}{4}} \quad \forall x, y \in X

    Also

    .. math:: 
    
        &\| \Phi x \|^2_2 \leq (1 + \delta_{2K}) \| x\|^2_2 \leq  \frac{3}{2}  \| x\|^2_2 \quad \forall x \in X \subset \Sigma_K \subset \Sigma_{2K}\\
        &\implies \| \Phi x \|_2 \leq \sqrt {\frac{3}{2}}  \| x\|_2  \leq \sqrt {\frac{3K}{2}} \quad \forall x \in X.
        
    since  :math:`\| x\|_2 \leq \sqrt{K} \quad \forall x \in X` .
     
    So we have a lower bound:
    
    .. math::
        :label: eq:rip_lower_bound_x
    
        \| \Phi x -  \Phi y\|_2 \geq  \sqrt{\frac{K}{4}} \quad \forall x, y \in X.

    and an upper bound:
    
    .. math::
        :label: eq:rip_upper_bound_x
    
        \| \Phi x \|_2 \leq \sqrt {\frac{3K}{2}} \quad \forall x \in X.
    
    What do these bounds mean? Let us start with the lower bound.
    :math:`\Phi x`  and  :math:`\Phi y`  are projections of  
    :math:`x`  and  :math:`y`  in  :math:`\RR^M`  (measurement space).
    
    Construct  :math:`l_2`  balls of radius
    :math:`\sqrt{\frac{K}{4}} / 2= \sqrt{\frac{K}{16}}`  in  
    :math:`\RR^M`  around  :math:`\Phi x`  and  :math:`\Phi y` .
    
    Lower bound says that these balls are disjoint. Since  :math:`x, y`  are arbitrary, this applies to every  :math:`x \in X`.
    
    Upper bound tells us that all vectors  :math:`\Phi x`  
    lie in a ball of radius  :math:`\sqrt {\frac{3K}{2}}`
    around origin in  :math:`\RR^M` .
    
    Thus, the set of all balls lies within a larger ball of radius
    :math:`\sqrt {\frac{3K}{2}} + \sqrt{\frac{K}{16}}`
    around origin in  :math:`\RR^M` .
    
    So we require that the volume of the larger ball MUST be greater 
    than the sum of volumes of  :math:`|X|`  individual balls. 
    
    Since volume of an  :math:`l_2`  ball of radius  :math:`r`
    is proportional to  :math:`r^M` , we have: 
     
    .. math:: 
    
        &\left ( \sqrt {\frac{3K}{2}} + \sqrt{\frac{K}{16}}    \right )^M \geq |X| . \left ( \sqrt{\frac{K}{16}} \right )^M\\. 
        & \implies (\sqrt {24} + 1)^M \geq  |X| \\
        & \implies  M \geq \frac{\ln |X| }{\ln (\sqrt {24} + 1) }
        
    Again from  :ref:`above <lem:rip_bound_X_lemma>` we have

    .. math:: 
    
          \ln |X| \geq \frac{K}{2} \ln \left ( \frac{N}{K} \right ).
        
    Putting back we get

    .. math:: 
    
         M \geq \frac{\frac{K}{2} \ln \left ( \frac{N}{K} \right ) }{\ln (\sqrt {24} + 1) }
        
    which establishes a lower bound on the number of measurements  :math:`M` .
    

.. example:: Lower bounds on M  for RIP of order  2K 
    
    #.   :math:`N=1000, K=100 \implies M \geq 65` .
    #.   :math:`N=1000, K=200 \implies M \geq 91` .
    #.   :math:`N=1000, K=400 \implies M \geq 104` .
    
Some remarks are in order:

*  The theorem only establishes a necessary lower bound on  :math:`M` . 
   It doesn't mean that if we choose an  :math:`M`  larger
   than the lower bound then  :math:`\Phi`  will have RIP of order  
   :math:`2K`  with any constant  
   :math:`\delta_{2K} \in (0, \frac{1}{2}]` .
*  The restriction  :math:`\delta_{2K} \leq \frac{1}{2}`
   is arbitrary and is made for convenience. 
   In general, we can work with
   :math:`0 < \delta_{2K} \leq \delta_{\text{max}} < 1`
   and develop the bounds accordingly.
*  This result fails to capture dependence of  
   :math:`M`  on the RIP constant  :math:`\delta_{2K}` directly. 
   *Johnson-Lindenstrauss lemma*  helps us resolve this 
   which concerns embeddings of finite sets of points in
   low-dimensional spaces.
*  We haven't made significant efforts to optimize the constants. 
   Still they are quite reasonable.


