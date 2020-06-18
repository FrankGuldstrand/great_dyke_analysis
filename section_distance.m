%% % % % Calculate Thickness (width) % % %

% By Frank Guldstrand 2020
% required outputs: data | thickness | files | path | nr_of_splits

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
%% % % % Calculate Section Distance % % %
    
    start=1;
    
    x1=thickness(start,6); % (add 2) Start SECTION 274 in northeastern part of dyke
    y1=thickness(start,7); % Start SECTION 274 in northeastern part of dyke
    
    for i=1:1:length(thickness)
    if i ~=start        
    %Point 1 to Point 2
    xl=thickness(i,6)-x1; % length in x
    yl=thickness(i,7)-y1; % length in y
    a=sqrt(xl^2 + yl^2);
    
    %Point 1 to Point 3
    xl=thickness(i,8)-x1; % length in x
    yl=thickness(i,9)-y1; % length in y
    b=sqrt(xl^2 + yl^2);
    
    %Get width from array Point 2 to Point 3
    c=thickness(i,1);
    
    gamma=acosd((c^2-a^2-b^2)/(-2*a*b)); % angle at origin coordinate between a & b
    
    thickness(i,3)=a*b*sind(gamma)/c; % thickness
    
        else
        end
    end
clearvars -except data thickness files path nr_of_splits