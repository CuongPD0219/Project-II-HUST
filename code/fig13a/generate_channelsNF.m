function [H, A_tgt] = generate_channelsNF(Nt, d, lam, pos_users, pos_tgt, P)
% =========================================================================
% Chức năng: Tạo ma trận kênh truyền trường gần (bao gồm LoS và NLoS)
% =========================================================================

    K = size(pos_users, 1);         % số người dùng
    H = zeros(Nt,Nt,K);             % ma trận kênh truyền của K người dùng

    % Hàm ẩn tính vector búp sóng đáp ứng a(r, theta) theo mô hình sóng cầu
    delta_n = (2*(1:Nt) - Nt - 1) / 2; 
    calc_a = @(r, theta_deg) exp(-1j * 2 * pi * ...
        (sqrt(r^2 + (delta_n * d).^2 - 2 * r * (delta_n * d) * sin(deg2rad(theta_deg))) - r) / lam).'ố

    % =========================================================
    %% Tạo kênh truyền cho từng user
    % ========================================================
    
    p_loss = sqrt(lam/(4*pi));
    for k = 1:K
        r_k = pos_users(k, 1); % Khoảng cách của người dùng thứ k
        
        % Tính biên độ suy hao không gian tự do (Free Space Path Loss Amplitude)
        PL_amp = p_loss / r_k * exp(-1j * 2 * pi *r_k);

        alpha_0 = PL_amp * (randn + 1j*randn)/sqrt(2); 
        a_LoS = calc_a(r_k, pos_users(k,2));
        
        h_NLoS = zeros(Nt, 1);
        for l = 1:P
            r_l = r_k + (rand-0.5)*2;      
            theta_l = pos_users(k,2) + (rand-0.5)*10; 
            
            % Tia NLoS cũng chịu suy hao 
            PL_amp_NLoS = p_loss / r_l * exp(-1j * 2 * pi *r_l);
            alpha_l = PL_amp_NLoS * (randn + 1j*randn)/sqrt(2); 
            
            h_NLoS = h_NLoS + alpha_l * calc_a(r_l, theta_l);
        end
        
        h_k = alpha_0 * a_LoS + sqrt(1/P) * h_NLoS;
        H(:,:,k) = h_k * h_k'; 
    end
    
    % =========================================================
    %% Ma trận cảm biến cho Mục tiêu (Radar Target)
    % =========================================================
    a_tgt = calc_a(pos_tgt(1), pos_tgt(2));
    A_tgt = a_tgt * a_tgt';
end