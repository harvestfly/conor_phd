%% Script to run the other scripts in this folder over a weekend
% each script takes about 24 hrs to run and I'm doing 3 of them so the need
% to run for a weekend.

% each script should have the results and figure saved. 
% the figure is saved because all of the useful data is in that figure,
% which can be extracted for later use.
close 
clear 

% %% Run 2U 5_Frequencies code with error handling capabilities
% a=1;    %flag for successful iteration 
% try 
%     Trans_AMM_2unitCell_WeaklyNL_FiveFrequencies    % no need to add the .m at the end of it
% catch ME
%     warning('Problem using the 2U Five Freq simulation. Sending email.')
% %     exception = MException.last.message;
%     a=0;
%     msgtext = getReport(ME);
%     sendolmail('conor.macdonald@adelaide.edu.au','2U Five Freq simulation failed',...
%     ['2U failed due to ' msgtext newline ' -----------:End message:--------']);
% end
% % loop to determine if "a" is still true
% if a==1
%     sendolmail('conor.macdonald@adelaide.edu.au','2U FiveFreq simulation complete',...
%     '2U FiveFreq is complete with no errors');
% else
%     
% end
% 
% close all 
% clear all
% %% Run 2U system code with error handling capabilities
% b=1;    %flag for successful iteration 
% try 
%     NL_MIM_2U_SweptSine    % no need to add the .m at the end of it
% 
% catch ME
%     warning('Problem using the 2U simulation. Sending email.')
% %     exception = MException.last;
%     b=0;
%     msgtext = getReport(ME);
%     sendolmail('conor.macdonald@adelaide.edu.au','2U simulation failed',...
%     ['2U failed due to ' msgtext newline ' -----------:End message:--------']);
% 
% end
% figureFile2='U:\_PhD\Matlab\Git\Models\MDOF Metamaterial Models\SweptSine\WeekendSimulationCode\2UweaklyNL.fig';
% %loop for flag checking
% if b==1
%     sendolmail('conor.macdonald@adelaide.edu.au','2U simulation complete',...
%     '2U simulation with figure',{figureFile2});
% else
% end
% 
% close all 
% clear all
%% Run 5U system code
c=1;    %flag for successful iteration 
try 
    NL_MIM_5U_SweptSine    % no need to add the .m at the end of it
catch ME
    warning('Problem using the 5U simulation. Sending email.')
%     exception = MException.last;
    c=0;
    msgtext = getReport(ME);
    sendolmail('conor.macdonald@adelaide.edu.au','5U simulation failed',...
    ['5U failed due to ' msgtext newline ' -----------:End message:--------']);
end

figureFile5='U:\_PhD\Matlab\Git\Models\MDOF Metamaterial Models\SweptSine\WeekendSimulationCode\5UweaklyNL.fig';
%loop for flag checking
if c==1
       sendolmail('conor.macdonald@adelaide.edu.au','5U simulation complete',...
           '5U simulation with figure',{figureFile5});
else
end


close all 
clear all
%% Run 10U system code
d=1;
try 
    NL_MIM_10U_SweptSine    % no need to add the .m at the end of it

catch ME
    warning('Problem using the 10U simulation. Sending email.')
%     exception = MException.last;
    d=0;
    msgtext = getReport(ME);
    sendolmail('conor.macdonald@adelaide.edu.au','10U simulation failed',...
    ['10U failed due to ' msgtext newline ' -----------:End message:--------']);
end
figureFile10='U:\_PhD\Matlab\Git\Models\MDOF Metamaterial Models\SweptSine\WeekendSimulationCode\10UweaklyNL.fig';

if d==1
    sendolmail('conor.macdonald@adelaide.edu.au','10U simulation complete',...
    '10U simulation with figure',{figureFile10});
else
end

close all 
clear all