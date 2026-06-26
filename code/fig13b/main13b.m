
clear; clc; close all;
cvx_clear;

%% 1. Tải các tham số hệ thống
run('parameters.m');
fprintf('Đã tải tham số hệ thống. Ngưỡng SINR = %d dB.\n', Gamma_dB);

%% 2. Khởi tạo lưu trữ
power_K2 = zeros(1, length(G_hat_list));
power_K2_FF = zeros(1, length(G_hat_list));
power_K4 = zeros(1, length(G_hat_list));
power_K4_FF = zeros(1, length(G_hat_list));

%% 3. Chạy vòng lặp cho K = 2
fprintf('--- Bắt đầu mô phỏng cho K = 2 ---\n');
[H_K2, A_tgt] = generate_channelsNF(Nt,d, lam, pos_users_K2, pos_tgt, P);
for idx = 1:length(G_hat_list)
    G_hat = G_hat_list(idx);

    % Gọi hàm giải bài toán tối ưu
    power_dBm = design_ps_beamformingNF(Nt,2, H_K2, A_tgt, Gamma_lin, G_hat, sigma_n2);

    % Lưu và in kết quả
    power_K2(idx) = power_dBm;
    if ~isnan(power_dBm)
        fprintf('G_hat = %3d | Công suất = %.2f dBm\n', G_hat, power_dBm);
    else
        fprintf('G_hat = %3d | Không tìm được lời giải (Infeasible)\n', G_hat);
    end
end

%% 4. Chạy vòng lặp cho K = 2 FF
fprintf('--- Bắt đầu mô phỏng cho K = 2 FF---\n');
[H_K2_FF, A_tgt_FF] = generate_channelsFF(Nt,d, lam, pos_users_K2, pos_tgt, P);
for idx = 1:length(G_hat_list)
    G_hat = G_hat_list(idx);

    % Gọi hàm giải bài toán tối ưu
    power_dBm = design_ps_beamformingFF(Nt,2, H_K2_FF, A_tgt_FF, Gamma_lin, G_hat, sigma_n2);

    % Lưu và in kết quả
    power_K2_FF(idx) = power_dBm;
    if ~isnan(power_dBm)
        fprintf('G_hat = %3d | Công suất = %.2f dBm\n', G_hat, power_dBm);
    else
        fprintf('G_hat = %3d | Không tìm được lời giải (Infeasible)\n', G_hat);
    end
end



%% 5. Chạy vòng lặp cho K = 4
fprintf('--- Bắt đầu mô phỏng cho K = 4 ---\n');
[H_K4, A_tgt] = generate_channelsNF(Nt,d, lam, pos_users_K4, pos_tgt, P);
for idx = 1:length(G_hat_list)
    G_hat = G_hat_list(idx);

    % Gọi hàm giải bài toán tối ưu
    power_dBm = design_ps_beamformingNF(Nt,4, H_K4, A_tgt, Gamma_lin, G_hat, sigma_n2);

    % Lưu và in kết quả
    power_K4(idx) = power_dBm;
    if ~isnan(power_dBm)
        fprintf('G_hat = %3d | Công suất = %.2f dBm\n', G_hat, power_dBm);
    else
        fprintf('G_hat = %3d | Không tìm được lời giải (Infeasible)\n', G_hat);
    end
end

%% 6. Chạy vòng lặp cho K = 4 FF
fprintf('--- Bắt đầu mô phỏng cho K = 4 FF ---\n');
[H_K4_FF, A_tgt_FF] = generate_channelsFF(Nt,d, lam, pos_users_K4, pos_tgt, P);
for idx = 1:length(G_hat_list)
    G_hat = G_hat_list(idx);

    % Gọi hàm giải bài toán tối ưu
    power_dBm = design_ps_beamformingFF(Nt,4, H_K4_FF, A_tgt_FF, Gamma_lin, G_hat, sigma_n2);

    % Lưu và in kết quả
    power_K4_FF(idx) = power_dBm;
    if ~isnan(power_dBm)
        fprintf('G_hat = %3d | Công suất = %.2f dBm\n', G_hat, power_dBm);
    else
        fprintf('G_hat = %3d | Không tìm được lời giải (Infeasible)\n', G_hat);
    end
end



%% 7. Trực quan hóa kết quả (Vẽ đồ thị)
figure('Color', 'w', 'Position', [100, 100, 700, 500]); % Tạo cửa sổ hình nền trắng, kích thước vừa phải
hold on; % Bật chế độ giữ hình để vẽ chồng nhiều đường

% 1. NFBF K=2: Màu xanh dương (b), marker tròn (o)
plot(G_hat_list, power_K2, '-ob', 'LineWidth', 2, 'MarkerSize', 8, ...
    'DisplayName', 'NFBF K=2'); 

% 2. NFBF K=4: Màu vàng, marker tròn (o)
% Sử dụng mã màu '#EDB120' (Vàng cam - màu vàng chuẩn và dễ nhìn nhất của MATLAB)
plot(G_hat_list, power_K4, '-o', 'Color', '#EDB120', 'MarkerFaceColor', '#EDB120', ...
    'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'NFBF K=4');

% 3. FFBF K=2: Màu đỏ (r), marker vuông (s - square)
plot(G_hat_list, power_K2_FF, '-sr', 'LineWidth', 2, 'MarkerSize', 8, ...
    'DisplayName', 'Existing FFBF K=2');

% 4. FFBF K=4: Màu tím, marker vuông (s)
% Sử dụng mã màu '#7E2F8E' (Màu tím đậm chuẩn của MATLAB)
plot(G_hat_list, power_K4_FF, '-s', 'Color', '#7E2F8E', 'MarkerFaceColor', '#7E2F8E', ...
    'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Existing FFBF K=4');

% --- Căn chỉnh giao diện đồ thị ---
title('So sánh công suất phát trên từng hệ thống với \Gamma = 15 dB', ...
      'Interpreter', 'tex', ...
      'FontSize', 14);
xlabel('$\hat{G}$ ', 'Interpreter', 'latex', 'FontSize', 12);
ylabel('Công suất tổng (dBm)', 'FontSize', 12);

% Hiển thị chú thích (Legend) ở góc trên bên trái
legend('Location', 'northwest', 'FontSize', 11);

set(gca,'XTick',[50 75 100 125 150 175 200]);

% Bật lưới nét đứt cho dễ khớp tọa độ
grid on;
set(gca, 'GridLineStyle', '--', 'FontSize', 11);

% ==========================================
% KHUNG PHÓNG TO (INSET PLOT)
% ==========================================

% 1. Tạo một khung tọa độ mới (axes) đè lên hình hiện tại
% Các tham số [Left, Bottom, Width, Height] tính theo tỉ lệ từ 0 đến 1 của cửa sổ
ax_inset = axes('Position', [0.55, 0.25, 0.3, 0.25]);
hold(ax_inset, 'on'); % Khóa hold riêng cho khung phụ
box(ax_inset, 'on');

% 2. ÉP MATLAB VẼ VÀO ĐÚNG KHUNG PHỤ (Thêm ax_inset vào đầu lệnh plot)
plot(ax_inset, G_hat_list, power_K2, '-ob', 'LineWidth', 2, 'MarkerSize', 8); 
plot(ax_inset, G_hat_list, power_K4, '-o', 'Color', '#EDB120', 'MarkerFaceColor', '#EDB120', 'LineWidth', 2, 'MarkerSize', 8);
plot(ax_inset, G_hat_list, power_K2_FF, '-sr', 'LineWidth', 2, 'MarkerSize', 8);
plot(ax_inset, G_hat_list, power_K4_FF, '-s', 'Color', '#7E2F8E', 'MarkerFaceColor', '#7E2F8E', 'LineWidth', 2, 'MarkerSize', 8);

% 3. ÉP MATLAB CHỈ CẮT CÚP TRÊN KHUNG PHỤ (Thêm ax_inset vào xlim, ylim)
xlim(ax_inset, [99.5, 100.5]); 
ylim(ax_inset, [25.9, 26.05]); 

% Thiết lập lưới và nhãn (Tick)
set(ax_inset, 'XTick', [99.5, 100, 100.5], 'YTick', [25.9, 25.95, 26.0]);
grid(ax_inset, 'on');

% ==========================================
% MŨI TÊN CHỈ DẪN (ANNOTATION)
% ==========================================
% Vòng elip: [x_center, y_center, width, height]
annotation('ellipse', [0.37, 0.55, 0.04, 0.06], 'LineWidth', 1.5);

% Mũi tên: [x_start, x_end], [y_start, y_end]
% Kéo từ x=0.39 (cạnh elip) đến x=0.55 (cạnh khung inset)
annotation('arrow', [0.39, 0.55], [0.52, 0.40], 'LineWidth', 1.5, 'HeadStyle', 'vback2');

fprintf('Hoàn thành mô phỏng!\n');


%% 8 hiển thị kết quả
fprintf('............|| NNBF với K = 2 || NNBF với K = 4 || FFBF với K =2  || FFBF với K = 4 ||\n');
for idx = 1:length(G_hat_list)
    fprintf('G_hat = %d  ||   %.3f dBm   ||   %.3f dBm   ||   %.3f dBm   ||   %.3f dBm   ||\n', G_hat_list(idx), power_K2(idx), ...
        power_K4(idx) , power_K2_FF(idx), power_K4_FF(idx)); 
end