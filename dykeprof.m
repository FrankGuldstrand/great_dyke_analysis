%% Analyzing the thickness of the Great Dyke in the mapped sections 

% By Frank Guldstrand 2019
clear vars; clc; close all

load_data % loads data in separate script
calculate_thickness % calculates the thickness of sections
section_distance % calculates distance perpendicular to sections from NE section

uniq=unique(thickness(:,9)); % Unique profile sections
cmapcustom=rand(length(uniq),3); % Random colormap for different sections
%% THICKNESS ARRAY INFO %%
%{
   Column 1 main thickness
   Column 2 secondary thickness
   Column 3:6 sets of x,y coordinates for the sections to calculate
   distance
   Column 7 section distance from northeastern section
   Column 8 section id within profile
   Column 9 Identifier according to which part it is rom P1=1...
%}

%% % % %  Sorting according to distance  and round % % %

    thickness=sortrows(thickness,7);
    % sorts according to distance from starting section
    thickness(:,7)=round(thickness(:,7));
    % rounds the distance to integers 
    % thickness(:,3:6)=[]; % Removes column with coordinates
    % Removes the column with coordinates

%% Big plot
% histogram (1)
% width plot (2)
% Section distance plot (3)
% plot of dyke outline (4)

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
 
 
        for j=1:1:length(files) % go through all files
            hold on
            for i= 1:1:length(data{j}) % for the full amount of coordinates in Data
          
                plot([data{j}(i,1)],[data{j}(i,2)],'.','Color',cmapcustom(thickness(j,9),1:3)) % Dyke Outline
            end
            
            % Plot of Sections
            plot([thickness(j,3),thickness(j,5)],[thickness(j,4),thickness(j,6)],'k'); 
            
            %if isnan(thickness(j,2)) ==0
            %   plot([thickness(j,3),thickness(j,5)],[thickness(j,4),thickness(j,6)],'k'); 
            %end
            
            if j==1
            str=['P',num2str(thickness(j,9)),'S',num2str(thickness(j,8))];   
            text(thickness(j,3),thickness(j,4),str,'FontSize',10,'Color','Magenta')
            elseif mod(j,5)==0
            str=['P',num2str(thickness(j,9)),'S',num2str(thickness(j,8))];   
            text(thickness(j,3),thickness(j,4),str,'FontSize',10,'Color','Magenta')
            end
     
        end
        grid on; box on; axis equal
        title('dyke outline')

        clearvars -except thickness files data lsid nr_of_splits path cmapcustom
%% LARGE FIGURE OUTLINE %%
 figure(3) % Plot of Dyke Outline and Sections
        for j=1:1:length(files) % go through all files
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
    tmp1=diff(thickness(:,7)) < 1; 
    % find the sections which are on the same position, makes vector 1 element shorter
    
    tmp2=logical([0;tmp1]);
    % add 0 at start of vector to make it as long as as thickness
    
    tmp3=logical([tmp1;0]);
    % add 0 at end of vector to make it as long as as thickness
    
    overlap=logical(tmp2+tmp3); 
    % add the two vectors to get full overlap
    % use this to test:
    % plot(overlap); hold on; plot(thickness(:,7)./max(thickness(:,7)))

    
    clear tmp1 tmp2 tmp3
    % Remove Overlap
    thicktmp=thickness; % create temp vector of thickness
    thicktmp(overlap,1)=NaN; % all overlap thicknesses are made NaNs
    thicktmp(overlap,7)=NaN; % all overlap distances are made NaNs



uniq=unique(thickness(:,9));
cmapcustom=rand(length(uniq),3); % Random colormap for different sections


avethick=zeros(1,length(uniq)); % storing variable for average thicknesses


figure
for i =1:length(uniq)

idx=thickness(:,9)==uniq(i); % Selection of section to plot

avethick(i)=nanmean(thicktmp(idx,1)); % Calculate thickness of section without Overlap

hold on
% Plots sections
plot(thickness(idx,7),thickness(idx,1),'color',cmapcustom(i,1:3),'LineWidth',2)

% Plots average thickness of Sections
plot([min(thicktmp(idx,7)), max(thicktmp(idx,7))],[avethick(i), avethick(i)],'.-k','LineWidth',1)


end
xlim([0,thickness(end,7)])
ylabel('thickness (m)')
xlabel('distance (m)')
grid on; box on
