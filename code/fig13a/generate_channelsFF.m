function [H_FF, A_tgt_FF] = generate_channelsFF(Nt, d, lam, pos_users, pos_tgt, P)
% =========================================================================
% Chức năng: Tạo ma trận kênh truyền trường gần (bao gồm LoS và NLoS)
% =========================================================================

    K = size(pos_users, 1);         % so người dùng
    H_FF = zeros(Nt,Nt,K);             % ma trận kênh truyền của K người dùng

    % Hàm ẩn tính vector búp sóng đáp ứng a(r, theta) theo mô hình sóng
    % phẳng
    delta_n = (2*(1:Nt) - Nt - 1) / 2; 
    calc_a = @(theta_deg) exp(-1j * 2 * pi * (delta_n * d) * sin(deg2rad(theta_deg)) / lam ).';

    % =========================================================
    %% Tạo kênh truyền cho từng user
    % ========================================================
    for k = 1:K
        r_k = pos_users(k, 1); % Khoảng cách của người dùng thứ k
        theta_k = pos_users(k,2); %hướng truyền của người dùng thứ k
        
        % Tính biên độ suy hao không gian tự do (Free Space Path Loss Amplitude)
        PL_amp = lam/(2*r_k); 

        alpha_0 = PL_amp * (randn + 1j*randn)/sqrt(2);  
        a_LoS = calc_a(theta_k);
        
        h_NLoS = zeros(Nt, 1);
        for l = 1:P
            r_l = r_k + (rand-0.5)*2;      
            theta_l = pos_users(k,2) + (rand-0.5)*10; 
            
            % Tia NLoS cũng chịu suy hao tương tự, hoặc cao hơn 
            PL_amp_NLoS = lam/(2 *r_l);
            alpha_l = PL_amp_NLoS * (randn + 1j*randn)/sqrt(2); 
            
            h_NLoS = h_NLoS + alpha_l * calc_a(theta_l);
        end
        
        h_k = alpha_0 * a_LoS + sqrt(1/P) * h_NLoS;
        H_FF(:,:,k) = h_k * h_k'; 
    end
    
    % =========================================================
    %% Ma trận cảm biến cho Mục tiêu (Radar Target)
    % =========================================================
    a_tgt = calc_a(pos_tgt(2));
    A_tgt_FF = a_tgt * a_tgt';
end