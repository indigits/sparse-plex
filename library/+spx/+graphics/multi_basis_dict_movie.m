function multi_basis_dict_movie(output_file, Phi, nb_atoms, subdict_names)
    video_file = VideoWriter(output_file, 'MPEG-4');
    newVid.FrameRate = 10;
    open(video_file);
    % signal space dimension and number of atoms
    [N, D] = size (Phi);
    % number of subdictionaries
    ns = numel(nb_atoms);
    atom_counter = 0;
    if nargin < 4
        subdict_names  = {};
    end
    for sd=1:ns
        sd_atoms = nb_atoms(sd);
        if nargin >= 4
            subdict_name = subdict_names{sd};
        else
            subdict_name = sprintf('subdict: %d', sd);
        end
        for i=1:sd_atoms
            atom_counter = atom_counter + 1;
            atom = Phi(:, atom_counter);
            max_val = max(abs(atom));
            plot(atom,'k','linewidth',2);
            grid on
            xlim([1 N]);
            ylim([-max_val, max_val]);
            title(sprintf('%s: atom %d', subdict_name, i));
            frame = getframe(gcf);
            writeVideo(video_file,frame);
            pause(0.05);
        end
    end
    close(video_file);
end
