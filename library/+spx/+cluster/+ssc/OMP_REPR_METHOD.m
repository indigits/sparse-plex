classdef OMP_REPR_METHOD
% method for computing OMP based representations
enumeration
    CLASSIC_OMP_C, BATCH_OMP_C, FLIPPED_OMP_MATLAB, BATCH_FLIPPED_OMP_MATLAB, BATCH_FLIPPED_OMP_C 
end
methods
function result = isClassicOMP_C(self)
    result = (self == spx.cluster.ssc.OMP_REPR_METHOD.CLASSIC_OMP_C);
end
function result = isBatchOMP_C(self)
    result = (self == spx.cluster.ssc.OMP_REPR_METHOD.BATCH_OMP_C);
end
function result = isFlippedOMP_MATLAB(self)
    result = (self == spx.cluster.ssc.OMP_REPR_METHOD.FLIPPED_OMP_MATLAB);
end
function result = isBatchFlippedOMP_MATLAB(self)
    result = (self == spx.cluster.ssc.OMP_REPR_METHOD.BATCH_FLIPPED_OMP_MATLAB);
end
function result = isBatchFlippedOMP_C(self)
    result = (self == spx.cluster.ssc.OMP_REPR_METHOD.BATCH_FLIPPED_OMP_C);
end
end
end