
clear; clc; close all;
cvx_clear;

%% 1. Tải các tham số hệ thống
run('parameters.m');
fprintf('Đã tải tham số hệ thống. Ngưỡng SINR = %d dB.\n', Gamma_dB);

%% 2. Khởi tạo lưu trữ
power_K2 = zeros(1, length(Gamma_dB_list));
power_K2_FF = zeros(1, length(Gamma_dB_list));
power_K4 = zeros(1, length(Gamma_dB_list));
power_K4_FF = zeros(1, length(Gamma_dB_list));

%% 3. Chạy vòng lặp cho K = 2
fprintf('--- Bắt đầu mô phỏng cho K = 2 ---\n');
[H_K2, A_tgt] = generate_channelsNF(Nt,d, lam, pos_users_K2, pos_tgt, P);
for idx = 1:length(Gamma_dB_list)
    G_thresh = 10^(Gamma_dB_list(idx)/10);

    % Gọi hàm giải bài toán tối ưu
    power_dBm = design_ps_beamformingNF(Nt,2, H_K2, A_tgt, G_thresh, G_hat, sigma_n3);

    % Lưu và in kết quả
    power_K2(idx) = power_dBm;
    if ~isnan(power_dBm)
        fprintf('G_threshold = %3d | Công suất = %.2f dBm\n', Gamma_dB_list(idx), power_dBm);
    else
        fprintf('G_threshold = %3d | Không tìm được lời giải (Infeasible)\n', Gamma_dB_list(idx));
    end
end

%% 4. Chạy vòng lặp cho K = 2 FF
fprintf('--- Bắt đầu mô phỏng cho K = 2 FF---\n');
[H_K2, A_tgt] = generate_channelsFF(Nt,d, lam, pos_users_K2, pos_tgt, P);
for idx = 1:length(Gamma_dB_list)
    G_thresh = 10^(Gamma_dB_list(idx)/10);

    % Gọi hàm giải bài toán tối ưu
    power_dBm = design_ps_beamformingFF(Nt,2, H_K2, A_tgt, G_thresh, G_hat, sigma_n3);

    % Lưu và in kết quả
    power_K2_FF(idx) = power_dBm;
    if ~isnan(power_dBm)
        fprintf('G_threshold = %3d | Công suất = %.2f dBm\n', Gamma_dB_list(idx), power_dBm);
    else
        fprintf('G_threshold = %3d | Không tìm được lời giải (Infeasible)\n', Gamma_dB_list(idx));
    end
end



%% 5. Chạy vòng lặp cho K = 4
fprintf('--- Bắt đầu mô phỏng cho K = 4 ---\n');
rng(25);
[H_K4, A_tgt] = generate_channelsNF(Nt,d, lam, pos_users_K4, pos_tgt, P);
for idx = 1:length(Gamma_dB_list)
    G_thresh = 10^(Gamma_dB_list(idx)/10);

    % Gọi hàm giải bài toán tối ưu
    power_dBm = design_ps_beamformingNF(Nt,4, H_K4, A_tgt, G_thresh, G_hat, sigma_n3);

    % Lưu và in kết quả
    power_K4(idx) = power_dBm;
    if ~isnan(power_dBm)
        fprintf('G_threshold = %3d | Công suất = %.2f dBm\n', Gamma_dB_list(idx), power_dBm);
    else
        fprintf('G_threshold = %3d | Không tìm được lời giải (Infeasible)\n', Gamma_dB_list(idx));
    end
end

%% 6. Chạy vòng lặp cho K = 4 FF
fprintf('--- Bắt đầu mô phỏng cho K = 4 FF ---\n');
rng(25);
[H_K4, A_tgt] = generate_channelsFF(Nt,d, lam, pos_users_K4, pos_tgt, P);
for idx = 1:length(Gamma_dB_list)
    G_thresh = 10^(Gamma_dB_list(idx)/10);

    % Gọi hàm giải bài toán tối ưu
    power_dBm = design_ps_beamformingFF(Nt,4, H_K4, A_tgt, G_thresh, G_hat, sigma_n3);

    % Lưu và in kết quả
    power_K4_FF(idx) = power_dBm;
    if ~isnan(power_dBm)
        fprintf('G_threshold = %3d | Công suất = %.2f dBm\n', Gamma_dB_list(idx), power_dBm);
    else
        fprintf('G_threshold = %3d | Không tìm được lời giải (Infeasible)\n', Gamma_dB_list(idx));
    end
end



%% 7. Trực quan hóa kết quả (Vẽ đồ thị)
figure('Color', 'w', 'Position', [100, 100, 700, 500]); % Tạo cửa sổ hình nền trắng, kích thước vừa phải
hold on; % Bật chế độ giữ hình để vẽ chồng nhiều đường

% 1. NFBF K=2: Màu xanh dương (b), marker tròn (o)
plot(Gamma_dB_list, power_K2, '-ob', 'LineWidth', 2, 'MarkerSize', 8, ...
    'DisplayName', 'NFBF K=2'); 

% 2. NFBF K=4: Màu vàng, marker tròn (o)
% Sử dụng mã màu '#EDB120' (Vàng cam - màu vàng chuẩn và dễ nhìn nhất của MATLAB)
plot(Gamma_dB_list, power_K4, '-o', 'Color', '#EDB120', 'MarkerFaceColor', '#EDB120', ...
    'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'NFBF K=4');

% 3. FFBF K=2: Màu đỏ (r), marker vuông (s - square)
plot(Gamma_dB_list, power_K2_FF, '-sr', 'LineWidth', 2, 'MarkerSize', 8, ...
    'DisplayName', 'Existing FFBF K=2');

% 4. FFBF K=4: Màu tím, marker vuông (s)
% Sử dụng mã màu '#7E2F8E' (Màu tím đậm chuẩn của MATLAB)
plot(Gamma_dB_list, power_K4_FF, '-s', 'Color', '#7E2F8E', 'MarkerFaceColor', '#7E2F8E', ...
    'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Existing FFBF K=4');

% --- Căn chỉnh giao diện đồ thị ---
title('So sánh công suất phát trên từng hệ thống với Ĝ = 100', 'FontSize', 14);
xlabel('\Gamma (dB) ', 'FontSize', 12);
ylabel('Công suất tổng (dBm)', 'FontSize', 12);

% Hiển thị chú thích (Legend) ở góc trên bên trái
legend('Location', 'northwest', 'FontSize', 11);

% Bật lưới nét đứt cho dễ gióng tọa độ
grid on;
set(gca, 'GridLineStyle', '--', 'FontSize', 11);

fprintf('Hoàn thành mô phỏng!\n');


%% 8 hiển thị kết quả
fprintf('....................|| NNBF với K = 2 || NNBF với K = 4 || FFBF với K =2  || FFBF với K = 4 ||\n');
for idx = 1:length(Gamma_dB_list)
    fprintf('G_threshold = %3d dB||   %.3f dBm   ||   %.3f dBm   ||   %.3f dBm   ||   %.3f dBm   ||\n', Gamma_dB_list(idx), power_K2(idx), ...
        power_K4(idx) , power_K2_FF(idx), power_K4_FF(idx)); 
end
