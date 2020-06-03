%% % % % Calculate Thickness (width) % % %

% By Frank Guldstrand 2020
% required outputs: thickness | nr of splits | lsid

%% THICKNESS ARRAY INFO %%
%{
   Column 1 main thickness
   Column 2 secondary thickness
   Column 3:6 sets of x,y coordinates for the sections to calculate
   distance
   Column 7 section spaceing from northeastern section
   Column 8 section id within profile
   Column 9 Identifier according to which part it is rom P1=1...
%}

%%
% % Creating Variable Space
thickness=zeros(length(files),9); % create a column vector of zeros  
                             
thickness(:,2)=NaN; 
% column to store split dyke thickness, NaN for identification

% This allows maximum 3 sections per dyke segment
nr_of_splits =zeros(length(files),1);

for j=1:1:length(files)
    
    % Part Section Identification
    tmp=split(files{j},'Section'); % split file name to extract only "P#"
    tmp=split(tmp(1),'P'); 
    
    thickness(j,9)=str2double(tmp(2)); % put numerical identifiger accortind to part
    clear tmp    
    tmp=split(files{j},'Section'); % split file name to extract only "P#"
    tmp=split(tmp(2),'_');
    tmp=split(tmp(2),'.');
    thickness(j,8)=str2double(tmp(1)); % ID of section
    clear tmp
    
    coord=data{j}; % coordinates from data to be used
    nr_of_splits(j) = length(coord);
    
    c=zeros(length(data{j}),1); % create temp variable
    for m=1:length(c)
       c(m)= sqrt(coord(m,1)^2 + coord(m,2)^2);
       % Pythagoras find distance from origin
    end; clear m
        [~,idx]=sortrows(c,-1); % sort descending
        clear c 
        %sort by distance from origin
        
     coord=coord(idx,:); clear idx
     % sorted coordinates
    
    l=mod(size(data{j}),2); % checks if there an even amount of coordinates
  
    if l(1)==0 % EVEN    
       for i=1:2:length(data{j}) % go through pair 1 and pair 2    
            % Calcualte width of dyke   
            xl=coord(i,1)-coord(i+1,1); % length in x
            yl=coord(i,2)-coord(i+1,2); % length in y
            cl=sqrt(xl^2 + yl^2); % WIDTH
            if i==1
                thickness(j,1)=cl; %main thickness
            elseif i==3
                thickness(j,2)=cl; %Thickness if split occurs
            end
            clear cl xl yl 
       end
          
        %Get upper coordinate of section
        thickness(j,3:4)=[coord(1,1),coord(1,2)];
        thickness(j,5:6)=[coord(2,1),coord(2,2)];  
        clear coord
       
    elseif l(1)==1 % ODD = 3 coordinates
        %display(j) displays section numbers with three points
        k=abs(diff(data{j}))==max(max(abs(diff(data{j}))));
        % finds largest difference between points to choose as thickness.
        if k(1,1)==1
          xl=data{j}(1,1)-data{j}(2,1); % length in x
          yl=data{j}(1,2)-data{j}(2,2); % length in y
          cl=sqrt(xl^2 + yl^2); % WIDTH
          thickness(j,1)=cl;

          thickness(j,3:4)=[data{j}(1,1),data{j}(1,2)];
          thickness(j,5:6)=[data{j}(2,1),data{j}(2,2)];
          clear cl xl yl 
        elseif k(2,1)==1
          xl=data{j}(2,1)-data{j}(3,1); % length in x
          yl=data{j}(2,2)-data{j}(3,2); % length in y
          cl=sqrt(xl^2 + yl^2);
          thickness(j,1)=cl;

          thickness(j,3:4)=[data{j}(2,1),data{j}(2,2)];
          thickness(j,5:6)=[data{j}(3,1),data{j}(3,2)];
          clear cl xl yl

        end
    end
       
end
clearvars -except data thickness files path lsid nr_of_splits