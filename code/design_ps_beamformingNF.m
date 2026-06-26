function power_dBm = design_ps_beamformingNF(Nt, K, H, A_tgt, Gamma_lin, G_hat, sigma_n2)
% =========================================================================
% Chức năng: Tìm ma trận F cực tiểu hóa công suất sử dụng CVX (SDR)
% Đầu ra: Tổng công suất phát ở đơn vị dBm (hoặc NaN nếu không giải được)
% =========================================================================
    cvx_clear;
    
    cvx_begin sdp quiet
        cvx_solver mosek 
        
        % Khai báo mảng 3 chiều chứa K ma trận F
        variable F(Nt, Nt, K) hermitian
        
        % Hàm mục tiêu: Cực tiểu hóa tổng vết của tất cả ma trận F
        minimize(real(trace(sum(F,3))) )
        
        subject to
            % 1. Ràng buộc nửa xác định dương
            for k = 1:K 
                F(:,:,k) >= 0;
            end
            
            % 2. Ràng buộc SINR cho từng người dùng
            for k = 1:K 
                % công suất tín hiệu người dùng k
                sig_expect = real(trace(H(:,:,k) * F(:,:,k)));

                sig_inter = 0;
                for i = 1:K
                    if i ~= k
                        sig_inter = sig_inter + real(trace(H(:,:,k) * F(:,:,i)));
                    end
                end

                sig_expect - Gamma_lin * sig_inter >= Gamma_lin * sigma_n2;
            end
     
            % 3. Ràng buộc công suất cảm biến tại mục tiêu
            real(trace(A_tgt * sum(F,3) )) >= G_hat;
    cvx_end
    
    % Kiểm tra và trả về kết quả
    if contains(cvx_status, 'Solved') || contains(cvx_status, 'Inaccurate')
        power_dBm = 10 * log10(cvx_optval * 1000);
    else
        power_dBm = NaN;
    end
end