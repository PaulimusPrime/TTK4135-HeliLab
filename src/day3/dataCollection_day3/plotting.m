
file = "Q15-05_5-05_R05";
title = "Q = diag[15,0.5,5,0.5] R=[0.5]";


plot_matFile(file + '.mat', [6], title, file)


function plot_matFile(file_path, rows, Title, save_as)
    % Load the .mat file
    data = load(file_path);
    
    % Extract the first numerical matrix with 7 rows
    fields = fieldnames(data);
    matrix = [];
    for i = 1:length(fields)
        if ismatrix(data.(fields{i})) && size(data.(fields{i}), 1) == 7
            matrix = data.(fields{i});
            break;
        end
    end
    
    if isempty(matrix)
        error('No valid 5-row matrix found in the .mat file.');
    end
    
    % Validate selected rows (excluding the first row, which is time)
    if any(rows < 2 | rows > 7)
        error('Invalid row selection. Choose rows between 2 and 5 (data rows).');
    end
    
    % Extract time and selected data rows
    time = matrix(1, :); % First row as time
    
    % Variable names corresponding to rows 2:7
    variable_names = {'Time','\lambda (travel)', 'r (travel rate)', 'p (pitch)', ...
                      "p' (pitch rate)", 'e (elevation)', "e' (elevation rate)"};
    
    delta_t = 0.25;
    
    t = 0:delta_t:delta_t*(140-1);
    % Create a plot
    figure;
    
    
    subplot(2,1,1);
    hold on;
    plot(time, matrix(2, :), 'r', 'DisplayName', variable_names{2}, 'LineWidth', 1.5);
    %plot(t,x1, 'r--',"LineWidth",1.5)
    hold off;
    
    xlabel('Time Steps');
    xlim([0,40])
    ylabel('Degrees');
    %ylim([-80,220]);
    title(Title + "- Travel");
    legend;
    grid on;
    
    subplot(2,1,2);
    hold on;
    plot(time, matrix(6, :), 'DisplayName', variable_names{6}, 'LineWidth', 1.5);
    %plot(t,x1, 'r--',"LineWidth",1.5)
    hold off;
    
    xlabel('Time Steps');
    xlim([0,40])
    ylabel('Degrees');
    ylim([-35,10]);
    title(Title + "- Travel");
    legend;
    grid on;
    
    %saveas(gcf, 'day2_' + save_as + '.png');
end