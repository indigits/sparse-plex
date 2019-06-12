Coding Guidelines
========================


Exceptions
------------------

* throw std::logic_error("Sparsity: too large.");
    * throw std::invalid_argument("Must be a full numeric matrix")
    * throw std::length_error("Column number beyond range.");
    * throw std::domain_error("")
    * throw std::out_of_range("")
* throw std::runtime_error("")
    * throw std::overflow_error("")
    * throw std::underflow_error("")
    * throw std::overflow_error("")



Verbosity
--------------------------

* 0: No output
* 1: Input parameters and output values
* 2: First level iteration numbers and iteration results.
* 3: Intermediate values inside first level iterations.
* 4: Second level iteration numbers and iteration results.
* 5: Intermediate values inside second level iterations.
* 6: Anything.


Tips and Tricks
----------------------

Pausing ::

    mexEvalString("pause(.001);");
