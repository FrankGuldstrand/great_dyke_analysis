%% % % % Calculate Thickness (width) % % %

% By Frank Guldstrand 2020
% required outputs: thickness | nr of splits 

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
   Col 12 x4
   Col 13 y4
   .. additional coordinates 
%}
%%
% % Creating Variable Space
thickness=zeros(length(files),13); % create a column vector of zeros  
       
% NaN for identification of no split scenarioes
thickness(:,2)=NaN; % Secondary thickness
thickness(:,10:end)=NaN; % additional coordinates

% This allows maximum 3 coordinate pairs per dyke segment
nr_of_splits =zeros(length(files),2);
nr_of_splits(:,2)=1; % Sets largest segment. 1 standard

%%

for j=1:1:length(data)
    
    % Part Section Identification
    tmp=split(files{j},'Section'); % split file name to extract only "P#"
    tmp=split(tmp(1),'P'); 
    
    thickness(j,4)=str2double(tmp(2)); % Part Integer ID
    clear tmp
    
    tmp=split(files{j},'Section'); % split file name to extract only "S#"
    tmp=split(tmp(2),'_');
    tmp=split(tmp(2),'.');
    thickness(j,5)=str2double(tmp(1)); % Profile (section) Integer ID
    clear tmp
    
    coord=data{j}; % coordinates from data to be used
    
    nr_of_splits(j,1) = length(coord)-2;
    
    % create temp variable for calculation of length along line for sorting coordinates
    c=zeros(length(data{j}),1); 
    
    for m=1:length(c)
       c(m)= sqrt(coord(m,1)^2 + coord(m,2)^2);
       % Pythagoras find distance from origin
    end; clear m
        
        %sort by distance from origin
        [~,idx]=sortrows(c,1); % sort ascending
        clear c 
      
        
     % sorted coordinates   
     coord=coord(idx,:); clear idx
      
    l=mod(size(data{j}),2); % checks if there an even amount of coordinates
  
    %% EVEN Number of coordinates
    if l(1)==0 
       if nr_of_splits(j)==0 % ONLY ONE INTRUSION
            
           for i=1:2:length(data{j}) % go through pair 1 and pair 2    
                % Calculate width of dyke   
                xl=coord(i,1)-coord(i+1,1); % length in x
                yl=coord(i,2)-coord(i+1,2); % length in y
                cl=sqrt(xl^2 + yl^2); % WIDTH

                if i==1
                    thickness(j,1)=cl; %main thickness
                elseif i==3
                    thickness(j,2)=cl; %secondary thickness
                end
                clear cl xl yl 
           end

            %Store coordinates in order
            thickness(j,6:7)=[coord(1,1),coord(1,2)];
            thickness(j,8:9)=[coord(2,1),coord(2,2)];
            clear coord
        
        elseif nr_of_splits(j,1)==2 % TWO INTRUSIONS separated by gap
            
            % find largest difference between the sets of coordinates
            k=abs(diff(coord))==max(max(abs(diff(coord))));
            
             if sum(k(1,:))==1 % 1st pair of coordinates are main thickness
                nr_of_splits(j,2)=1; % store first set is largest 
                
                  for m=1:2:3   
                  xl=coord(m,1)-coord(m+1,1); % length in x
                  yl=coord(m,2)-coord(m+1,2); % length in y          
                  cl=sqrt(xl^2 + yl^2); % WIDTH

                  ord=[1,NaN,2];
                  thickness(j,ord(m))=cl; % store width calculations
                  clear cl xl yl 
                  end; clear m ord

                  % Store coordinates in regular order
                  thickness(j,6:7)=[coord(1,1),coord(1,2)];
                  thickness(j,8:9)=[coord(2,1),coord(2,2)];
                  thickness(j,10:11)=[coord(3,1),coord(3,2)];
                  thickness(j,12:13)=[coord(4,1),coord(4,2)];
          
             elseif sum(k(2,:))==1 % 2nd pair of coordinates are main thickness
                 
                 nr_of_splits(j,2)=2; % store 2nd set is largest
                   
                   xl=coord(2,1)-coord(3,1); % length in x
                   yl=coord(2,2)-coord(3,2); % length in y          
                   cl=sqrt(xl^2 + yl^2); % WIDTH

                   thickness(j,1)=cl; % store width calculations
                   clear cl xl yl 
                   
                      % Store coordinates in regular order
                      thickness(j,6:7)=[coord(1,1),coord(1,2)];
                      thickness(j,8:9)=[coord(2,1),coord(2,2)];
                      thickness(j,10:11)=[coord(3,1),coord(3,2)];
                      thickness(j,12:13)=[coord(4,1),coord(4,2)];
                    
                   % find secondary thickness
                   k_min=abs(diff(coord))==min(min(abs(diff(coord))));
                   k_tot=sum(k_min+k,2); % zeros is the variable we want
                   clear k_min 

                   if k_tot(1)==0
                   xl=coord(1,1)-coord(2,1); % length in x
                   yl=coord(1,2)-coord(2,2); % length in y          
                   cl=sqrt(xl^2 + yl^2); % WIDTH

                   thickness(j,2)=cl; % store width calculations
                   clear cl xl yl 
                   elseif k_tot(3)==0
                   
                   xl=coord(3,1)-coord(4,1); % length in x
                   yl=coord(3,2)-coord(4,2); % length in y          
                   cl=sqrt(xl^2 + yl^2); % WIDTH

                   thickness(j,2)=cl; % store width calculations
                   clear cl xl yl     
                                  
                   end
                   
                                
             elseif sum(k(3,:))==1 % 3rd pair of coordinates are main thickness
                 nr_of_splits(j,2)=3; % store 3rd set is largest

                  for m=3:-2:1   
                  xl=coord(m,1)-coord(m+1,1); % length in x
                  yl=coord(m,2)-coord(m+1,2); % length in y          
                  cl=sqrt(xl^2 + yl^2); % WIDTH

                  ord=[2,NaN,1];
                  thickness(j,ord(m))=cl; % store width calculations
                  clear cl xl yl 
                  end; clear m ord

                  % Store coordinates in regular order
                  thickness(j,6:7)=[coord(1,1),coord(1,2)];
                  thickness(j,8:9)=[coord(2,1),coord(2,2)];
                  thickness(j,10:11)=[coord(3,1),coord(3,2)];
                  thickness(j,12:13)=[coord(4,1),coord(4,2)];    

                 
             end; clear k
            
        end
    %% END EVEN
    %% ODD = 3 coordinates    
    elseif l(1)==1 
        %display(j) displays section numbers with three points
        
        % find largest difference between points to choose as main thickness.
        k=abs(diff(coord))==max(max(abs(diff(coord))));
       
        if sum(k(1,:))==1 % 1st set of coordinates are main thickness
          nr_of_splits(j,2)=1; % store first set is largest  
          
          for m=1:2   
          xl=coord(m,1)-coord(m+1,1); % length in x
          yl=coord(m,2)-coord(m+1,2); % length in y          
          cl=sqrt(xl^2 + yl^2); % WIDTH
          
          thickness(j,m)=cl; % store width calculations
          clear cl xl yl 
          end
          
          % Store coordinates in regular order
          thickness(j,6:7)=[coord(1,1),coord(1,2)];
          thickness(j,8:9)=[coord(2,1),coord(2,2)];
          thickness(j,10:11)=[coord(3,1),coord(3,2)];

        elseif sum(k(2,:))==1 % 2nd set of coordinates are main thickness
          nr_of_splits(j,2)=2; % store 2nd pair is largest
          for m=2:-1:1
          xl=coord(m,1)-coord(m+1,1); % length in x
          yl=coord(m,2)-coord(m+1,2); % length in y
          cl=sqrt(xl^2 + yl^2);
          
          ord=[2,1]; % order, ugly :(
          thickness(j,ord(m))=cl; % store width calculations
          clear cl xl yl
          end; clear m ord
          
          % Store coordinates in regular order
          thickness(j,6:7)=[coord(1,1),coord(1,2)];
          thickness(j,8:9)=[coord(2,1),coord(2,2)];
          thickness(j,10:11)=[coord(3,1),coord(3,2)];
%% END ODD         
        end
    end     
end
clearvars -except data thickness files path nr_of_splits