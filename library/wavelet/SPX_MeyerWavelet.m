classdef SPX_MeyerWavelet
% Methods for implementing Meyer wavelets and corresponding transforms
% Remarks:
% 
% 
% 
%  Influenced by:
%  - WaveLab
%
%   TODO: This is incomplete. Come back later.
%
% 

methods(Static)


    function forward_transform()
    end

    function inverse_transform()
    end

    function coarse_coefficients()
    end

    function detail_coefficients()
    end

    function fine_coefficients()
    end

    function folded_x = fold(x, symmetry_points, polarity, window_type, degree)
        % Fold a vector onto itself using a specified window
        % 
        % Input:
        % - x:  input vector
        % - symmetry_points: symmetry points of the form [a, b]
        % - polarity: string specifying folding polarity
        %    mp -> (-, +)
        %    pm -> (+, -)
        %    mm -> (-, -)
        %    pp -> (+, +)
        % - window_type: string specifying window type
        %   m -> Mother Meyer wavelet window
        %   f -> Father Meyer wavelet window
        %   t -> Truncated  Mother Meyer wavelet window
        % - degree : degree of Meyer window

        pi_half = pi / 2;
        a = symmetry_points(1);
        b = symmetry_points(2);
        switch window_type
            case 'm'
                % e.g. let symmetry_points = (30, 60)
                eps    = floor(a/3);
                % eps = 10
                epsp   = a - eps - 1;
                % epsp = 30 - 10 - 1 = 19
                left_indices  = [ a-eps+1 : a ];
                % left_indices : 21-30
                left_mid_indices = [ a+2 : a+eps+1 ];
                % left_mid_indices : 32 - 41
                right_mid_indices = [ b-epsp+1 : b ];
                % right_mid_indices : 42 - 60
                right_indices = [ b+2 : b+epsp+1 ];
                % right_indices - 62 - 80
                window = SPX_MeyerWavelet.window(3*((left_indices-1)/b)-1,degree)
                lft  = x(left_indices).*sin(pi_half*window);
                window = SPX_MeyerWavelet.window(3*((left_mid_indices-1)/b)-1,degree);
                lmid = x(left_mid_indices).*sin(pi_half*window);
                window = SPX_MeyerWavelet.window((3/2)*((right_mid_indices-1)/b)-1,degree);
                rmid = x(right_mid_indices).*cos(pi_half*window);
                window = SPX_MeyerWavelet.window((3/2)*((right_indices-1)/b)-1,degree);
                rght = x(right_indices).*cos(pi_half*window);
            case 'f'
                body
            case 't'
                body
            otherwise
                error('unsupported window type');
        end

        switch polarity
            case 'mp'
                folded_x =  [ -fliplr(lft) fliplr(rght) 0 lmid rmid x(b+1) ];
            case 'pm'
                folded_x = [ 0 fliplr(lft) -fliplr(rght) x(a+1) lmid rmid];
            case 'pp'
                folded_x = [ x(n+a+1) lmid cntr rmid x(b+1) 0 fliplr(lft) zeros(1,length(cntrind)) fliplr(rght) 0 ];
            case 'mm'
                folded_x = 
            otherwise
                error('unsupported polarity');
        end

    end

    function unfold()
    end

    function window = window(abscissa, degree)
        % Auxiliary window function for Meyer wavelets
        xi = abscissa;
        if degree == 0
            window = xi;
        elseif degree == 1
            window = xi .^2 .* (3 - 2 .*xi) ;
        elseif degree == 2
            window = xi .^3 .* (10 - 15 .* xi + 6 .* xi .^2);
        elseif degree == 3
            window = xi.^4 .* ( 35 - 84 .* xi + 70 .* xi.^2 - 20 .* xi.^3);
        end
        neg_locations = find(xi <= 0);
        windowm_neg_locations = length(neg_locations);
        if windowm_neg_locations > 0
            window(neg_locations) = zeros(1,windowm_neg_locations);
        end
        one_plus_locations = find(xi >= 1);
        windowm_one_plus_locations = length(one_plus_locations);
        if windowm_one_plus_locations > 0
            window(one_plus_locations) = ones(1,windowm_one_plus_locations);
        end
    end



end

end
