%% LOADS DATA FOR ANALYZING DYKE

% By Frank Guldstrand 2020

clear vars; 

% % Identifying paths for data 
%path='FullData/'; % Text string path to data (keep it nice and clean)

files=struct2table(dir(path));  % cell with list of files in FullData directory
files=files(3:end,:);
files = natsortfiles(files.name);  % Use dependencey natsortfiles to sort

  
%% Data Loading

% Data contains sections (profiles) from move where we have the locations of
% contact identified
% data: col1 = x col2 = y col3 = z

for j=1:length(files) % loop over files starting from 3 because of dir
    if j==1
        disp(files{j})   
    end
    sections=dlmread([path,files{j}],'\t',1,0); 
    % read data with space as delimiter, remove first row, keep all
    % columns.
    [i]=sum(sections,1)==0;
    % This is to identify empty columns (not interesting). It sums up all
    % columns in sections and finds the columns which are equal to 0 and so
    % have no data.
    sections(:,i) = []; clear i
    % The empty columns are removed through the [] operations.
    data{j}=sections;  
    % Saves the data in a cell like structure because they is an unequal
    % number of intersections                 
    clear sections
end; clear j