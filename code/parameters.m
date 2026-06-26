% =========================================================================
% Tên file: parameters.m
% Chức năng: Khởi tạo tất cả các tham số cho hệ thống ISAC trường gần
% =========================================================================

%% 1. Cấu hình mảng Anten
Nt = 256;                        % Số lượng anten phát
fc = 30e9;                       % Tần số mang: 30 GHz
c = 3e8;                         % Tốc độ ánh sáng (m/s)
lam = c / fc;                    % Bước sóng
d = lam / 2;                     % Khoảng cách giữa các anten

%% 2. Tọa độ (khoảng cách r tính bằng mét, góc theta tính bằng độ)
pos_users_K2 = [5.0, 0.0 ; 15.0, 0.0];            
pos_users_K4 = [5.0, 0.0 ; 10.0, 0.0; 15.0, 0.0; 20.0, 0.0]; 
pos_tgt = [5.0, 60.0];           % Mục tiêu cảm biến: 5m, 60 độ

%% 3. Tham số kênh truyền đa đường (Multipath)
P = 2;                           % Số lượng đường NLoS (scattering paths)

%% 4. Tham số Tối ưu hóa (QoS Constraints) Fig 13b
Gamma_dB = 15;                   % Ngưỡng yêu cầu SINR cho truyền thông (dB)
Gamma_lin = 10^(Gamma_dB / 10);  % Chuyển đổi dB sang thang đo tuyến tính
G_hat_list = 50:25:200;          % Mảng ngưỡng công suất yêu cầu tại mục tiêu (G_hat) cho cảm biến
sigma_n2 = 1e-7;                 % Phương sai nhiễu nền giả định

%% 5. Tham số Tối ưu hóa (QoS Constraints) Fig 13a
Gamma_dB_list = 0: 4: 36 ;                   % Ngưỡng yêu cầu SINR cho truyền thông (dB)
G_hat = 100;                                % Mảng ngưỡng công suất yêu cầu tại mục tiêu (G_hat) cho cảm biến
sigma_n3 = 2e-9; 