%% BY Frank Guldstrand 2019

clear all; clc; close all

path='FullData/'; % Text string path to data (keep it nice and clean)
files=struct2table(dir(path));  
files = natsortfiles(files.name);  

ls={'P1';'P2';'P3';'P4';'P5';'P6';'P7';'P8'}; % ADD P# according to nr of segments
lsid=[1:length(ls)];           % that are exported from Move
                  
% % Creating Variable Space
thickness=zeros(length(files)-2,9); % creat a column vector of zeros the 
                                    % the length of the number of files
thickness(:,2)=NaN; 
% column to store split dyke thickness, NaN for identification

% Data Loading

for j=3:1:length(files) % loop over files starting from because of dir
    sections=dlmread([path,files{j}],'\t',1,0); 
    % read data with space as deliminter, remove first row, keep all
    % columns.
    [i]=sum(sections,1)==0;
    % This is to identify empty columns (not interesting). It sums up all
    % columns in sections and finds the columns which are equal to 0 and so
    % have no data.
    sections(:,i) = [];
    % The empty columns are removed through the [] operations.
    data{j-2}=sections; 
    % Saves the data in a cell like structure because they are of unequal
    % length                 

%     clear sections
end

% data col1 x data col2 y data col3 z
%%
% % % Calculate Thickness (width) % % %

for j=1:1:length(files)-2
    %IF  ADD CORRECTON FOR MULTIPLE VALUES %%
    thickness(j,8)=j+2;
    coord=sortrows(data{j},1,'descend'); % SORTS ON X COORDINATES smallest-biggest
    % Does not work if section may be curving or is aligned with Y
    
    % Part Section Identification
    tmp=strsplit(files{j+2},'S'); % split file name to extract only "P#"
    tmp=strcmp(ls,tmp{1}); % compare "P#" to ls 
    thickness(j,9)=lsid(tmp); clear tmp % put numerical identifiger accortind to part
    
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
clearvars -except data thickness files path ls

% % % Calculate Section Distance % % %

    x1=thickness(21,3); % (add 2) Start SECTION 274 in northeastern part of dyke
    y1=thickness(21,4); % Start SECTION 274 in northeastern part of dyke
    
    for i=1:1:length(thickness)
        if i ~=21
    %Point 1 to Point 2
    xl=thickness(i,3)-x1; % length in x
    yl=thickness(i,4)-y1; % length in y
    a=sqrt(xl^2 + yl^2);
    %Point 1 to Point 3
    xl=thickness(i,5)-x1; % length in x
    yl=thickness(i,6)-y1; % length in y
    b=sqrt(xl^2 + yl^2);
    %Point 2 to Point 3
    c=thickness(i,1);
    
    gamma=acosd((c^2-a^2-b^2)/(-2*a*b)); % angle at origin coordinate between a & b
    
    thickness(i,7)=a*b*sind(gamma)/c; % thickness
    
        else
        end
    end
clearvars -except data thickness files path ls
% % %  Sorting according to distance  and round % % %

    thickness=sortrows(thickness,7);
    % sorts according to distance from starting section
    thickness(:,7)=round(thickness(:,7));
    % rounds the distance to integers 
    % thickness(:,3:6)=[]; % Removes column with coordinates
    % Removes the column with coordinates
%% THICKNESS ARRAY INFO %%
%{
   Column 1 main thickness
   Column 2 secondary thickness
   Column 3:6 sets of x,y coordinates for the sections to calculate
   distance
   Column 7 section spaceing from northeastern section
   Column 8 section name from "files"
   Column 9 Identifier according to which part it is rom P1=1...
%}

%% histogram

figure
subplot(2,2,1) % Width Histogram

    nrbins=30; % Bins for histogram
    [counts1, binCenters1] = hist(thickness(:,1),nrbins); % counts and bins
    [counts2, binCenters2] = hist(thickness(:,2),nrbins); % counts and bins
    %[counts3, binCenters3] = hist(h3,nrbins);
    bar(binCenters1, counts1,'b');   hold on; % histogram plot 
    bar(binCenters1, counts2,'r'); % histogram splits
    %bar(binCenters3, counts3, 'b-');
    ylabel('width (m)')
    grid on; box on;
    title('thickness histogram')
    xlabel('thickness (m)')
    
subplot(2,2,2) % Plot of Width
    hold on
    plot(thickness(:,7),thickness(:,1),'x') % Plot of width and distance
    plot(thickness(:,7),movmean(thickness(:,1),10),'k') % Plot of moving mean
    xlim([0 thickness(end,7)])
    %ylim([0 max(thickness(:,1))])
    grid on; box on
    ylabel('width (m)')
    xlabel('distance (m)')
    title('thickness vs length (m)')

 subplot(2,2,3) % Plot of Section Distance
         hold on
         plot(thickness(:,7),'-');
         title('section distance')
         grid on
         %axis equal
         box on
         ylabel('distance (m)')
         ylim([0 max(thickness(:,7))])
         xlim([0 length(thickness)])
         
 subplot(2,2,4) % Plot of Dyke Outline and Sections
        for j=1:1:length(files)-2 % go through all files
            hold on
            for i= 1:1:length(data{j}) % for the full amount of coordinates in Data
                plot([data{j}(i,1)],[data{j}(i,2)],'r.') % Dyke Outline
            end
            plot([thickness(j,3),thickness(j,5)],[thickness(j,4),thickness(j,6)],'k')
            % Plot of Sections
        end
        grid on; box on; axis equal
        title('dyke outline')

        clearvars -except thickness files data ls
%% LARGE FIGURE OUTLINE %%
 figure(3) % Plot of Dyke Outline and Sections
        for j=1:1:length(files)-2 % go through all files
            hold on
            for i= 1:1:length(data{j}) % for the full amount of coordinates in Data
                plot([data{j}(i,1)],[data{j}(i,2)],'r.') % Dyke Outline
            end
            plot([thickness(j,3),thickness(j,5)],[thickness(j,4),thickness(j,6)],'k')
            % Plot of Sections
        end
        grid on; box on; axis equal
        title('dyke outline')
%% REMOVE OVERLAP AREAS OR Identify different Sections
    % Overlap identification
    tmp1=diff(thickness(:,7))==0; % find the sections which are on the same position, makes vector 1 element shorter
    tmp2=logical([0;tmp1]); % add 0 at start of vector to make it as long as as thickness
    tmp3=logical([tmp1;0]); % add 0 at end of vector to make it as long as as thickness
    overlap=logical(tmp2+tmp3); % add the two vectors to get full overlap
    clear tmp1 tmp2 tmp3
    % Remove Overlap
    thicktmp=thickness; % create temp vector of thickness
    thicktmp(overlap,1)=NaN; % all overlap thicknesses are made NaNs
    thicktmp(overlap,7)=NaN; % all overlap distances are made NaNs

avethick=zeros(1,length(ls)); % storing variable for average thicknesses

cmapcustom=rand(length(ls),3); % Random colormap for different sections
figure
for i =1:1:length(ls)
idx=thickness(:,9)==i; % Selection of section to plot

avethick(i)=nanmean(thicktmp(idx,1)); % Calculate thickness of section without Overlap

hold on
plot(thickness(idx,7),thickness(idx,1),'color',cmapcustom(i,1:3),'LineWidth',2)
% Plots sections
plot([min(thicktmp(idx,7)), max(thicktmp(idx,7))],[avethick(i), avethick(i)],'.-k','LineWidth',1)
% Plots average thickness of Sections
ylabel('thickness (m)')
xlabel('distance (m)')
end
xlim([0,thickness(end,7)])
grid on; box on
