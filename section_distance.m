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
%% % % % Calculate Section Distance % % %
    
    start=1;
    
    x1=thickness(start,3); % (add 2) Start SECTION 274 in northeastern part of dyke
    y1=thickness(start,4); % Start SECTION 274 in northeastern part of dyke
    
    for i=1:1:length(thickness)
        if i ~=start
            
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
clearvars -except data thickness files path lsid nr_of_splits