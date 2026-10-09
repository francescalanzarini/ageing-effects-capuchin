function [sessions] = sessionlistread(monkey,experiment)

filename = ['...\sessionlist_',monkey,'.m'];
fid = fopen(filename,'r');

if fid==-1 
   error('** error (sessionlistread) opening file %s; message: %s ', filename, msg);
end

lineday = {};
ssnum   = {};
ssflag  = {};

i = 0;
while ~feof(fid)
    line = strtrim(fgetl(fid)); % remove spaces
    if isempty(line), continue; end

    i = i+1;
    parts = strsplit(line);   % divide
    if numel(parts) >= 3
        lineday{i,1} = parts{1};   % day
        ssnum{i,1}   = parts{2};   % session number 
        ssflag{i,1}  = parts{3};
    end
end
fclose(fid);

% only sessions matching with experiment
ind = strcmp(ssflag, experiment);
sessions = [lineday(ind), ssnum(ind)];

end
