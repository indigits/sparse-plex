classdef SPX_DictionaryComparison

methods(Static)

        function result = matching_atoms_ratio(original, new, options)
            % Returns distance betweeen two dictionaries
            % in terms of how many atoms from the original
            % dictionary could be 
            % found in the new dictionary
            % Assumes that all atoms in dictionary are normalized.
            % Works well if the dictionaries have low coherence.
            distance_threshold=0.01;
            if nargin > 2
                if isfield(options, 'distance_threshold')
                    distance_threshold = options.distance_threshold;
                end
            end
            % Number of atoms which could be 
            % identified properly
            atomsFound=0;
            % We compute inner product of each
            % atom in one dictionary with all
            % atoms in other dictionary
            innerProducts =abs(original'*new);
            % Find the number of atoms in original dictionary
            numAtoms = size(original,2);
            for i=1:1:numAtoms
                %  Trying to find a match for the i-th atom in original dictionary.
                % We find its highest inner product
                % with atoms in new dictionary
                max_similarity = max(innerProducts(i,:));
                % The distance is 1  - max_similarity
                min_distance =1- max_similarity;
                % If distance is less than the threshold
                % then the atom has been found.
                match_found = (min_distance<distance_threshold);
                atomsFound=atomsFound + match_found;
            end;
            % Find the ratio of found atoms with total atoms
            result= atomsFound/numAtoms;
        end
        


end

end
