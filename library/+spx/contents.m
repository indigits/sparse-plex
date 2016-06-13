function contents()
    % Lists contents of spx package
    root = fileparts(which('spx.locate'));
    process_dir(root, 'spx')
end


function process_dir(directory, package_name)
    packages =  dir([directory, filesep '+*']);
    mat_files =  dir([directory, filesep '*.m']);
    for i=1:numel(packages)
        subpackage = packages(i);
        name = subpackage.name;
        subpackage_name = name(2:end);
        subpackage_dir = [directory filesep name];
        fullname = [package_name, '.', subpackage_name];
        fprintf('%s:\t\tpackage\n', fullname);
        process_dir(subpackage_dir, fullname);
    end
    for i=1:numel(mat_files)
        mat_file = mat_files(i);
        mat_file_name = mat_file.name;
        [~, mat_file_base_name, ~] = fileparts(mat_file_name);
        mat_resource = [package_name '.' mat_file_base_name];
        r = exist(mat_resource);
        if r == 8
            fprintf('%s:\t\tclass\n', mat_resource);
            M = methods( mat_resource, '-full');
            flags = strncmpi(M, 'Static ', 7);
            for j=1:numel(M)
                if flags(j) == 0
                    continue;
                end
                meth = M{j};
                fprintf('\t%s\n', meth(8:end));
            end
        end
    end
end
