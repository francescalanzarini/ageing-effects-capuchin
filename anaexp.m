%% anaexp: main analysis for capuchin behavioral data

makestats  = 1;
makefigs   = 1;
printplots = 1;

% Choose experiment
experiment = 'Transitivity'; expr = 'tra';
% experiment = 'FoodTransitivity'; expr = 'ftr';
% experiment = 'TokenTransitivity'; expr = 'ttr';

disp(['Experiment: ',experiment])

% Load monkey list
monkeylist_read

sesscount = 0;
summary = cell(0);
relative_values.mean = [];
relative_values.stdv  = [];
relative_values.monk = {};

% Master table for all sessions
allSessionsTable = table();

for imon = 1:numel(monkeys)
    monkey = monkeys{imon};
    mnk    = mnks{imon};

    % Directory with session scripts
    dir_path = fullfile('...\', monkey);
    addpath(dir_path)

    % Load session list table
    sessions_table = load(['sessionlist_', mnk, '.mat']);
    fn = fieldnames(sessions_table);
    sessions_table = sessions_table.(fn{1}); % get the table
    sessions_table = sessions_table(strcmp(sessions_table.expr_code, expr), :);

    disp(['...Monkey: ', monkey])

    for isess = 1:height(sessions_table)
        clear parset

        % Construct session script filename
        day  = sessions_table.sessionDate{isess};
        num  = num2str(sessions_table.sessionNum(isess));
        session = [day num];
        filename = [mnk, session, '_', expr];

         % Run session script
        if exist(fullfile(dir_path,[filename,'.m']),'file')
            run(fullfile(dir_path, filename))
        else
            warning(['Session script not found: ', filename])
            continue
        end

        % Analyze session
        [psyphycell, table01, session_table] = eval(['analyze_', expr '(parset, makefigs, makestats);']);

        sesscount = sesscount + 1;

        % Flag extreme x0 sessions
        extremeX0 = max(abs(psyphycell(:,1))) >= log(20);

        % Fix A>B>C order if needed
        if psyphycell(1,1) + psyphycell(2,1) < 0
            psyphycell(2,1) = -psyphycell(2,1);
            psyphycell = psyphycell([3 2 1], :);
            disp(['fixed A B C order for session ', filename])
        end

        % Relative values
        relative_values.mean(sesscount,:) = [psyphycell(1,1), psyphycell(2,1), -psyphycell(3,1)];
        relative_values.stdv(sesscount,:)  = [psyphycell(1,2), psyphycell(2,2), psyphycell(3,2)];
        relative_values.monk{sesscount,1}  = mnk;

        % Append session_table with Monkey, Session, extremeX0 info
        session_table.Monkey    = {monkey};
        session_table.Session   = {session};
        session_table.ExtremeX0 = extremeX0;
        allSessionsTable = [allSessionsTable; session_table];

        % Figures
        if printplots && makefigs
            hf = gcf;
            if ~isempty(hf) && isvalid(hf)
                orient(hf,'landscape')
                set(hf,'PaperPositionMode','auto')

                pdffile = fullfile(dir_path, ['figures_', expr, '_', monkey, '_session_', filename, '.pdf']);
                print(hf,'-dpdf', pdffile)
                close(hf)
            end
        end
    end
end

% Output
if ~makestats, return; end

if ismember(expr,{'ftr','ttr', 'tra'})
    save(['summary_', expr], 'relative_values')
    % Save master table
    writetable(allSessionsTable, ['summary_', expr, '_all_sessions.csv'])
    save(['summary_', expr, '_all_sessions.mat'], 'allSessionsTable')
end
