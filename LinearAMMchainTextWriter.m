%% Text file writer
% creates a text file/inp file from MATLAB which is then run in ANSYS APDL
strTitle='LinearAMMchain.txt';
fileID = fopen(strTitle,'w');
% dont forget to change the last line when you change this title
%-----------------------------------------------
%% Future Improvements and plans
% - assign variables for elements so changing between types and real
% constants is easy af.

%-----------------------------------------------
%% Intro comments and time stamp
dt = datestr(now,'mmmm dd, yyyy HH:MM:SS AM');
strIntro='! Script to examine the response for a linear mass-spring system\n! Conor MacDonald ';
fprintf(fileID,strcat(strIntro,dt));
%-----------------------------------------------
%% Clear up and start Proprocessor
strFIN='\n\nFINI\n/clear,all\n! Start the preprocessor\n/prep7\n';
fprintf(fileID,strFIN);
%-----------------------------------------------
%% Parameters and Modelling
% Parameters and loop to create the model
% stiffness, mass, number of cells, length, etc
m1=0.1; 
m2=0.5*m1;
k1=1000;
k2=k1/3.125;
L=40; %length between unit cells (cell is two masses)
l=L/2; %length within each cell
%-------------------------------------
n=1; %number of cells, so we need 2xn number of nodes
%-------------------------------------
ival=0; %initial value for node generation
fval=2*n; %final value for end of node chain
%-------------------------------------
% frequency range for harmonic analysis
ivalHarm=0; %initial freq
fvalHarm=100;  %final freq
subsN=10000; %number of substeps in analysis
%-------------------------------------
strPAR=('\n! Define parameters\nm1=%f\nm2=%f\nk1=%f\nk2=%f\nL=%f\nl=%f\nn=%f !number of cells\nival=%f\nfval=%f\n');
fprintf(fileID,strPAR,m1,m2,k1,k2,L,l,n,ival,fval);
%-----------------------------------------------
% Define the mass element, element type 1
strMAS=('\n! Define the mass element\nET,1,MASS21\nKEYOPT,1,3,4\nR,1,m1\n');
fprintf(fileID,strMAS);
% Define mass 2, element 4
fprintf(fileID,'\n! Define the mass element\nET,4,MASS21\nKEYOPT,1,3,4\nR,4,m2\n');
%-----------------------------------------------
% Define the linear spring element, element type 2
%keyopts, real constants, declare element type
fprintf(fileID,'\n! Define the linear spring element\nET,2,COMBIN14\nKEYOPT,2,3,2\nR,2,k1\n');
%-----------------------------------------------
% Define the secondary linear spring element, element type 3
%keyopts, real constants, declare element type
fprintf(fileID,'\n! Define the linear spring element\nET,3,COMBIN14\nKEYOPT,2,3,2\nR,3,k2\n');
%-----------------------------------------------
% Define mass 2, element 4
fprintf(fileID,'\n! Define the mass element\nET,4,MASS21\nKEYOPT,1,3,4\nR,4,m2\n');

%-----------------------------------------------
%% Node Generation

% Outline the DO loop to create 'n' amount of nodes
fprintf(fileID,'\n! Define a DO loop using the command\n!*DO, counter, InitialVAL, FinalVAL, INCrement\n');
fprintf(fileID,'\n*DO,II,%d,fval,1 ! For I = %d to %d:\n',ival,ival,fval);
% Define the node command line
% we aren't concerend with rotation so we just need the longitudinal value
fprintf(fileID,'\n! Define the nodes using the command\n! N, NODE, X, Y, Z, THXY, THYZ, THZX\n');
fprintf(fileID,'\nposx=II*l		! calculate nodal position with spacing, =%d\n',l);
% define the node(s) and end the do loop
fprintf(fileID,'\nN,II+1,posx,0,0			! define the node\n*ENDDO\n');
% fprintf(fileID,'\nN,II+2,posx+l,0,0\n*ENDDO\n');
% define first node
% fprintf(fileID,'\n\nN,1,0,0,0     !Define first node at 0,0');
fprintf(fileID,'\n! Now that all the nodes are defined\n! One can define the elements that link them together\n');
%-----------------------------------------------
% link springs together (linear springs - primary mass to secondary mass)
fprintf(fileID,'\nTYPE,3! Change the element type to 3 (spring element)\nREAL,3! Change to real set 3 for the spring\n');
fprintf(fileID,'\n!*DO, Par, IVAL, FVAL, INC\n*DO, II,2,%d, 2\n',fval);
% element is defined by connectivity to two nodes, I and J
fprintf(fileID,'\nE,II,II+1\n*ENDDO\n');
%-----------------------------------------------
% link springs together (linear springs - primary mass to primary mass)
fprintf(fileID,'\nTYPE,2! Change the element type to 2 (spring element)\nREAL,2! Change to real set 2 for the spring\n');
fprintf(fileID,'\nE,1,2\n');
% setout another DO loop
fprintf(fileID,'\n!*DO, Par, IVAL, FVAL, INC\n*DO, II,2,%d, 2\n',fval-2);
% element is defined by connectivity to two nodes, I and J
fprintf(fileID,'\nE,II,II+2\n*ENDDO\n');
%-----------------------------------------------
% place masses on each node=
fprintf(fileID,'\nTYPE,1! Change the element type to 1 (mass element)\nREAL,1! Change to real set 1 for the mass\n');
% setout another DO loop
fprintf(fileID,'\n!*DO, Par, IVAL, FVAL, INC\n*DO, II,%d ,%d, 2\n',ival+2,fval);
% element is defined by connectivity to two nodes, I and J
fprintf(fileID,'\nE,II\n*ENDDO\n');
% Change masses to secondary mass
fprintf(fileID,'\nTYPE,4! Change the element type to 4 (mass element)\nREAL,4! Change to real set 4 for the mass\n');
fprintf(fileID,'\n!*DO, Par, IVAL, FVAL, INC\n*DO, II,%d ,%d, 2\n',ival+3,fval+1);
fprintf(fileID,'\nE,II\n*ENDDO\n');
%-----------------------------------------------
%% Loads: Define the excitation force on node#1

% Force of 1 applied on the first node
% prepare for harmonic or transient analysis
% fprintf(fileID,'\n! define the excitation force on Node #1, in the X direction\n! F, NODE, Lab, VALUE, VALUE2, NEND, NINC');
% fprintf(fileID,'\n! Specifies force loads at nodes.');
% fprintf(fileID,'\nF,1,FX,1');
%-----------------------------------------------
% Constrain the other end of the chain
fprintf(fileID,'\n! Constrain the first node, which is numbered %d\n! D, Node, Lab, VALUE, VALUE2, NEND, NINC, Lab2, Lab3, Lab4, Lab5, Lab6',ival+1);
fprintf(fileID,'\n! Defines degree-of-freedom constraints at nodes.');
fprintf(fileID,'\nD,%d,UX,0\n',ival+1);
%-----------------------------------------------
fprintf(fileID,'\nFINI\n');

%% Analysis
% fprintf(fileID,'!*\nANTYPE,4\n!*\nTRNOPT,FULL \nLUMPM,0 \n!*  \nNSUBST,80000,80000,80000\n');
% fprintf(fileID,'OUTRES,ERASE\nOUTRES,NSOL,ALL \nTIME,100\n');
%-----------------------------------------------
% Model process has been completed
%% Solution of system
% setup the solution process
% fprintf(fileID,'\n/SOLU     ! Start the solution process\n');
% fprintf(fileID,'\nANTYPE, HARMIC   ! Use Harmonic Analysis\n');
% fprintf(fileID,'!Setup the solution process\n!*\n!*\nHROPT,FULL\nHROUT,ON\nLUMPM,1\n!*\nEQSLV, ,0,\nPSTRES,0\n!*\n!*\nOUTPR,ALL,ALL,\n');
% fprintf(fileID,'HARFRQ,%d,%d,',ivalHarm,fvalHarm);
% fprintf(fileID,'\nNSUBST,%d,\nKBC,0\n!*\nSAVE\n',subsN);
% %-----------------------------------------------
% %solve the system
% fprintf(fileID,'\nSOLVE\n');
%-----------------------------------------------
%% Analysis/PostProcessing
%-----------------------------------------------
% Not working great last time. Might have to do it manually from here. 
%-----------------------------------------------
% Plot the graph of the response of first and last node in the chain
% fprintf(fileID,'\n! Plot the graph of the response of first and last node in the chain');
% fprintf(fileID,'\n/POST26\nFILE,''file'',''rst'',''.''\nNUMVAR,200\n!SOLU,191,NCMIT\n');
% fprintf(fileID,'\n!STORE,MERGE\nPLCPLX,0\nPRCPLX,1\n!*\n');
% fprintf(fileID,'\n! Define results set 2, to be the UX displacement of Node #1\n! and give it a text label UX_1 to print on the graph\n');
% fprintf(fileID,'NSOL,2,1,U,X, UX_1,\nNSOL,3,chainlen+1,U,X, UX_end,\nXVAR,1	! Define the x label to be the frequency (set 1)\n');
% fprintf(fileID,'PLVAR,2,3');


%% End
% Copy text file contents to ANSYS' input file format, .inp
fclose(fileID);
fileID2 = fopen('APDL_AMM_linearChain.inp' ,'w');
copyfile LinearAMMchain.txt APDL_AMM_linearChain.inp



