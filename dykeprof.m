%% Analyzing the thickness of the Great Dyke in the mapped sections 

% By Frank Guldstrand 2019
clear vars; clc; close all

load_data % loads data in separate script
calculate_thickness % calculates the thickness of sections output = thickness
section_distance % calculates distance perpendicular to sections from NE section

uniq=unique(thickness(:,4)); % Unique profile sections
cmapcustom=rand(length(uniq),3); % Random colormap for different sections

 %  Sorting according to distance and round % % %
    
 % sorts according to distance from starting section
    %thickness=sortrows(thickness,3);
    
    % rounds the distance to integers 
    %thickness(:,3)=round(thickness(:,3));
    
    % Removes the column with coordinates
    % thickness(:,3:6)=[]; % Removes column with coordinates
%% THICKNESS ARRAY INFO %%
%{
   Col  1 main thickness
   Col  2 secondary thickness
   Col  3 Perpendicular distance of profile from NE (length)
   Col  4 Part ID Integer
   Col  5 Profile ID w/i Part Integer
   Col  6 x1
   Col  7 y1
   Col  8 x2
   Col  9 y2
   Col 10 x3
   Col 11 y3 
   .. additional coordinates 
%}
%% Big plot
% histogram (1)
% width plot (2)
% Section distance plot (3)
% plot of dyke outline (4)

figure
subplot(2,2,1) % Multi-Plot

    % Bins for histogram according Freedman-Diaconis rule for entire dyke
    nrbins_main=round(2*iqr(thickness(:,1))/(length(thickness(:,1))^(-1/3))); 
    
    idx=~isnan(thickness(:,2));
    nrbins_sec=round(2*iqr(thickness(idx,2))/(length(thickness(idx,2))^(-1/3)));
    
    [counts1, binCenters1] = hist(thickness(:,1),nrbins_main); % counts and bins
    [counts2, binCenters2] = hist(thickness(idx,2),nrbins_sec); % counts and bins
    %[counts3, binCenters3] = hist(h3,nrbins);
    
    bar(binCenters1, counts1,'b');   hold on; % Main Thickness
    bar(binCenters2, counts2,'r'); % Secondary Thickness
    %bar(binCenters3, counts3, 'b-');
    ylabel('Nr Samples')
    grid on; box on;
    title('thickness histogram')
    xlabel('width (m)')
    
subplot(2,2,2) % Plot of Width
    hold on
    plot(thickness(:,3),thickness(:,1),'x') % Plot of width and distance
    plot(thickness(:,3),movmean(thickness(:,1),10),'k') % Plot of moving mean
    xlim([0 thickness(end,3)])
    %ylim([0 max(thickness(:,1))])
    grid on; box on
    ylabel('width (m)')
    xlabel('distance (m)')
    title('thickness vs length (m)')

 subplot(2,2,3) % Plot of Section Distance
         hold on
         plot(thickness(:,3),'-');
         title('section distance')
         grid on
         %axis equal
         box on
         ylabel('distance (m)')
         ylim([0 max(thickness(:,3))])
         xlim([0 length(thickness)])
         
 subplot(2,2,4) % Plot of Dyke Outline and Sections
        for j=1:1:length(files) % go through all files
            hold on
            
            for i= 1:1:length(data{j}) % for the length of coordinates in Data
                plot([data{j}(i,1)],[data{j}(i,2)],'.','Color',cmapcustom(thickness(j,4),1:3),'MarkerSize',12) % Dyke Outline
            end
            
            if nr_of_splits(j,2)==1 % No split
            plot([thickness(j,6),thickness(j,8)],[thickness(j,7),thickness(j,9)],'k'); 
            elseif nr_of_splits(j,2)==2 % split
            plot([thickness(j,6),thickness(j,8)],[thickness(j,7),thickness(j,9)],'k'); 
            plot([thickness(j,8),thickness(j,10)],[thickness(j,9),thickness(j,11)],'k'); 
            end
            
            % ADD PART ID AND SECTION ID
            if j==1
            str=['P',num2str(thickness(j,4)),'S',num2str(thickness(j,5))];   
            text(thickness(j,6),thickness(j,7),str,'FontSize',10,'Color','Magenta')
            
            elseif mod(j,50)==0 % Sets increment for ID-text in plot
            str=['P',num2str(thickness(j,4)),'S',num2str(thickness(j,5))];   
            text(thickness(j,6),thickness(j,7),str,'FontSize',10,'Color','Magenta')
            end 
        end
        grid on; box on; axis equal
        title('dyke outline')

        clearvars -except thickness files data lsid nr_of_splits path cmapcustom
%% LARGE FIGURE OUTLINE %%
 figure(3) % Plot of Dyke Outline and Sections

        for j=1:1:length(files) % go through all files
            hold on
            
            for i= 1:1:length(data{j}) % for the length of coordinates in Data
                plot([data{j}(i,1)],[data{j}(i,2)],'.','Color',cmapcustom(thickness(j,4),1:3),'MarkerSize',12) % Dyke Outline
            end
            
            if nr_of_splits(j,2)==1 % No split
            plot([thickness(j,6),thickness(j,8)],[thickness(j,7),thickness(j,9)],'k'); 
            elseif nr_of_splits(j,2)==2 % split
            plot([thickness(j,6),thickness(j,8)],[thickness(j,7),thickness(j,9)],'k'); 
            plot([thickness(j,8),thickness(j,10)],[thickness(j,9),thickness(j,11)],'k'); 
            end
            
            % ADD PART ID AND SECTION ID
            if j==1
            str=['P',num2str(thickness(j,4)),'S',num2str(thickness(j,5))];   
            text(thickness(j,6),thickness(j,7),str,'FontSize',10,'Color','Magenta')
            
            elseif mod(j,50)==0 % Sets increment for ID-text in plot
            str=['P',num2str(thickness(j,4)),'S',num2str(thickness(j,5))];   
            text(thickness(j,6),thickness(j,7),str,'FontSize',10,'Color','Magenta')
            end 
        end
        grid on; box on; axis equal
        title('dyke outline')
%% REMOVE OVERLAP AREAS OR Identify different Sections
    % Overlap identification
    tmp1=diff(thickness(:,3)) < 1; 
    % find the sections which are on the same position, makes vector 1 element shorter
    
    tmp2=logical([0;tmp1]);
    % add 0 at start of vector to make it as long as as thickness
    
    tmp3=logical([tmp1;0]);
    % add 0 at end of vector to make it as long as as thickness
    overlap=logical(tmp2+tmp3); 
    % add the two vectors to get full overlap
    % use this to test:
    plot(overlap); hold on; plot(thickness(:,3)./max(thickness(:,3)))
    
    clear tmp1 tmp2 tmp3
    % Remove Overlap
    thicktmp=thickness(:,1:5); % create temp vector of thickness
    thicktmp(overlap,1)=NaN; % all overlap thicknesses are made NaNs
    thicktmp(overlap,3)=NaN; % all overlap distances are made NaNs

%uniq=unique(thickness(:,9)); 
%cmapcustom=rand(length(uniq),3); % Random colormap for different sections

avethick=zeros(1,length(uniq)); % storing variable for average thicknesses
figure
for i =1:length(uniq)

idx=thickness(:,4)==uniq(i); % Selection of section to plot

avethick(i)=nanmean(thicktmp(idx,1)); % Calculate thickness of section without Overlap

hold on
% Plots sections
plot(thickness(idx,3),thickness(idx,1),'color',cmapcustom(i,1:3),'LineWidth',2)

% Plots average thickness of Sections
plot([min(thicktmp(idx,3)), max(thicktmp(idx,3))],[avethick(i), avethick(i)],'.-k','LineWidth',1)

end
xlim([0,thickness(end,3)])
ylabel('thickness (m)')
xlabel('distance (m)')
grid on; box on
