file = "Q-5-03-01-15-30-10_R-05-05";
title = "Q = diag(5,0.3,0.1,15,30,10), R = diag(0.5,0.5)";

plot_matFile(file + '.mat', [2,4,5,6], title, file)


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
        error('No valid 7-row matrix found in the .mat file.');
    end
    
    % Validate selected rows (excluding the first row, which is time)
    if any(rows < 2 | rows > 7)
        error('Invalid row selection. Choose rows between 2 and 7 (data rows).');
    end
    
    % Extract time and selected data rows
    time = matrix(1, :); % First row as time
    
    % Variable names corresponding to rows 2:7
    variable_names = {'\lambda (travel)', 'r (travel rate)', 'p (pitch)', ...
                      "p' (pitch rate)", 'e (elevation)', "e' (elevation rate)"};
    
    % Create a plot
    figure;
    hold on;
    for i = rows
        plot(time, matrix(i, :), 'DisplayName', variable_names{i-1}, 'LineWidth', 2);
    end
    hold off;
    
    xlabel('Time Steps');
    xlim([0,25])
    ylabel('Value');
    ylim([-2.5,3.5])
    title(Title);
    legend;
    grid on;
    saveas(gcf, 'day4_' + save_as + '.png');
end
