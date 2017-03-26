function varargout = UI(varargin)

% Begin initialization code - DO NOT EDIT
inputString = '';
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UI_OpeningFcn, ...
                   'gui_OutputFcn',  @UI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before UI is made visible.
function UI_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;


% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = UI_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
set(handles.test,'Max',90);
set(handles.analysis,'Max',100);


% Get input sequence
function test_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of test as text
%        str2double(get(hObject,'String')) returns contents of test as a double


% --- Executes during object creation, after setting all properties.
function test_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in submit.
function submit_Callback(hObject, eventdata, handles)
% Given Input Sequence
inputString = get(handles.test,'String');

%Load data from file
exonDataFile = fopen('exonSequence', 'r');
exonDataTranspose = textscan(exonDataFile, '%s', 'Delimiter', '\n');
exonData = transpose(exonDataTranspose);
fclose(exonDataFile);

DNAData = fastaread('DNASequence');

O = 4;
Q = 28;

prior0 = [0.0; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];

transmat0 = [0.0, 1, 0, 0, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0;
             0.0, 0.9, 0.1, 0, 0, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0;
             0.0, 0, 0.0, 1, 0, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0; 
             0.0, 0, 0.0, 0.0, 1, 0, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0; 
             0.0, 0, 0.0, 0.0, 0.0, 1, 0, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0; 
             0.0, 0.1, 0.0, 0, 0, 0, 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0; 
             0.0, 0.1, 0.0, 0, 0, 0, 0.0, 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0; 
             0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0; 
             0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0,0.0, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0; 
             0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0; 
             0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0.0, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0; 
             0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0.0, 0.9, 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0; 
             0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0.0, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0;   
             0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0;      
             0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0.0, 0.0, 0.0, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0;    
             0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0.0, 0.0, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0;   
             0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0.0, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0;   
             0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0;   
             0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0;   
             0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0.0, 0.0, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0;   
             0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0.0, 0.0, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0;   
             0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0.0, 1, 0.0, 0.0, 0.0, 0.0, 0.0;   
             0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 1, 0.0, 0.0, 0.0, 0.0;   
             0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0.0, 0.0, 0.0, 1, 0.0, 0.0, 0.0;   
             0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0.0, 0.0, 0.9, 0.0, 0.0;   
             0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0.0, 0.9, 0.0;   
             0.0, 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0.1;   
             0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        
% Converts the DNA sequences into number A -> 1, C -> 2, G -> 3, T -> 4
row = 515;
CSequence = zeros(416, 40000);
CSequence(:) = 5;

testCSequence = zeros(101, 40000);
testCSequence(:) = 5;

m = 1;
n = 1;

for i = 1:row
    tempSequence = DNAData(i).Sequence;
    mySequence = zeros(size(tempSequence));
    
    mySequence(tempSequence == 'A') = 1;
    mySequence(tempSequence == 'C') = 2;
    mySequence(tempSequence == 'G') = 3;
    mySequence(tempSequence == 'T') = 4;
    mySequence(tempSequence == 'a') = 1;
    mySequence(tempSequence == 'c') = 2;
    mySequence(tempSequence == 'g') = 3;
    mySequence(tempSequence == 't') = 4;

    jao = mySequence(:);
    pakhi = jao';
    pakhi = round(pakhi);
    
    [r, c] = size(pakhi);

    if(i <= 100)
        for j = 1:c
            testCSequence(m, j) = pakhi(1, j); 
        end
        m = m + 1;
    end 
    
    if(i > 100)
        for j = 1:c
            CSequence(n, j) = pakhi(1, j);
        end
        n = n + 1;
    end  
end


%Transition and Emission probability Calculation
DNAInfo = CSequence;
transTrack = double(zeros(25, 25));
exonTrack = double(zeros(570, 5));
countTrans = double(zeros(size(1, 25)));
totalTrans = double(zeros(size(1, 25)));
totalLength = 0;
totalTransition = 0;

% Emission probability storage
emissionProbability = double(zeros(28, 4));

% Transition probability storage
transitionProbability = double(zeros(28, 28));

for i = 101:row
    exon = exonData{1}{i};
    S = char(exon);
    C = split(S);
    C = C';
    [r, c] = size(C);
    
    tempSequence = DNAData(i).Sequence;
    [a, b] = size(tempSequence);
    
%   Total Sequence length calculation required for Emission probability
    totalLength = totalLength + b;
    
    exonTrack(i, 1) = (c-1)/2;
    exonLength = 0;
    intronLength = 0;
    
    for j=2:2:c 
        n = str2num(char(C(1, j)));
        m = str2num(char(C(1, j+1)));
        
        if(j == 2)
            exonTrack(i, 4) = n - 1;
        end
        
        if(j+1 == c)
            exonLength = exonLength + (m - n + 1);
            exonTrack(i, 5) = b - m;
        else
            k = str2num(char(C(1, j+1)));
            exonLength = exonLength + (m - n + 1);
            intronLength = intronLength + (k - m - 1);
        end
    end
    
    exonTrack(i, 2) = exonLength;
    exonTrack(i, 3) = intronLength;
%    ____________________________________________________________________________________________________

%     Transition probability Information Gain
%     For state E
    exon = (exonLength - 4) * exonTrack(i, 1);
    
%     For state I
    intron = (intronLength - 20) * (exonTrack(i, 1) - 1);
    
%     For all other state 
    probabilityAll = exonTrack(i, 1);
    
%     For start and end state
    probabilitySE = 0;
    
    transitionProbability(2, 2) = exon * 0.9;
    transitionProbability(2, 3) = probabilityAll * 0.1;
    transitionProbability(14, 14) = intron * 0.9;
    transitionProbability(14, 15) = probabilityAll * 0.1;
    
    for p = 3:11
        transitionProbability(p, p+1) = probabilityAll;
    end
    
    for p = 13:26
        transitionProbability(p, p+1) = probabilityAll;
    end
    transitionProbability(27, 2) = probabilityAll * 0.9;
    transitionProbability(27, 28) = probabilityAll * 0.1;
  
%     ___________________________________________________________________________________________________
    
%     Emission Probability Information Gain
    
        for j=2:2:c
            n = str2num(char(C(1, j)));
            m = str2num(char(C(1, j+1)));
            
%           Count for state E
            for k=n:m-4
                emissionProbability(2, CSequence(i-100, k)) = emissionProbability(2, CSequence(i-100, k)) + 1;
            end
            
%           Count for state a, b, c, M
            emissionProbability(3, CSequence(i-100, m-3)) = emissionProbability(3, CSequence(i-100, m-3)) + 1; 
            emissionProbability(4, CSequence(i-100, m-2)) = emissionProbability(4, CSequence(i-100, m-2)) + 1; 
            emissionProbability(5, CSequence(i-100, m-1)) = emissionProbability(5, CSequence(i-100, m-1)) + 1; 
            emissionProbability(6, CSequence(i-100, m)) = emissionProbability(6, CSequence(i-100, m)) + 1; 
            
            if(j+2 <= c & str2num(char(C(1, j+2))) <= b)
                forIntron = str2num(char(C(1, j+2)));
                
%           Count for state G, T, O, P, Q
                emissionProbability(7, CSequence(i-100, m+1)) = emissionProbability(7, CSequence(i-100, m+1)) + 1; 
                emissionProbability(8, CSequence(i-100, m+2)) = emissionProbability(8, CSequence(i-100, m+2)) + 1; 
                emissionProbability(9, CSequence(i-100, m+3)) = emissionProbability(9, CSequence(i-100, m+3)) + 1; 
                emissionProbability(10, CSequence(i-100, m+4)) = emissionProbability(10, CSequence(i-100, m+4)) + 1; 
                emissionProbability(11, CSequence(i-100, m+5)) = emissionProbability(11, CSequence(i-100, m+5)) + 1; 
                
%           Count for Intron
                 for k=m+6:forIntron-16
                    emissionProbability(12, CSequence(i-100, k)) = emissionProbability(12, CSequence(i-100, k)) + 1;
                 end
                 
%           Count for B, D, F, H, K, L, N, R, U, V, W, X, Y, A, G
                emissionProbability(13, CSequence(i-100, forIntron-15)) = emissionProbability(13, CSequence(i-100, forIntron-15)) + 1; 
                emissionProbability(14, CSequence(i-100, forIntron-14)) = emissionProbability(14, CSequence(i-100, forIntron-14)) + 1; 
                emissionProbability(15, CSequence(i-100, forIntron-13)) = emissionProbability(15, CSequence(i-100, forIntron-13)) + 1; 
                emissionProbability(16, CSequence(i-100, forIntron-12)) = emissionProbability(16, CSequence(i-100, forIntron-12)) + 1; 
                emissionProbability(17, CSequence(i-100, forIntron-11)) = emissionProbability(17, CSequence(i-100, forIntron-11)) + 1;
                emissionProbability(18, CSequence(i-100, forIntron-10)) = emissionProbability(18, CSequence(i-100, forIntron-10)) + 1; 
                emissionProbability(19, CSequence(i-100, forIntron-9)) = emissionProbability(19, CSequence(i-100, forIntron-9)) + 1; 
                emissionProbability(20, CSequence(i-100, forIntron-8)) = emissionProbability(20, CSequence(i-100, forIntron-8)) + 1; 
                emissionProbability(21, CSequence(i-100, forIntron-7)) = emissionProbability(21, CSequence(i-100, forIntron-7)) + 1; 
                emissionProbability(22, CSequence(i-100, forIntron-6)) = emissionProbability(22, CSequence(i-100, forIntron-6)) + 1; 
                emissionProbability(23, CSequence(i-100, forIntron-5)) = emissionProbability(23, CSequence(i-100, forIntron-5)) + 1; 
                emissionProbability(24, CSequence(i-100, forIntron-4)) = emissionProbability(24, CSequence(i-100, forIntron-4)) + 1; 
                emissionProbability(25, CSequence(i-100, forIntron-3)) = emissionProbability(25, CSequence(i-100, forIntron-3)) + 1; 
                emissionProbability(26, CSequence(i-100, forIntron-2)) = emissionProbability(26, CSequence(i-100, forIntron-2)) + 1; 
                emissionProbability(27, CSequence(i-100, forIntron-1)) = emissionProbability(27, CSequence(i-100, forIntron-1)) + 1;     
            end     
        end
end


% Emission Probability Calculation

for i = 2:27
    sum = 0;
    for j = 1:4
        sum = sum + emissionProbability(i, j);
    end
    emissionProbability(i, 1) = emissionProbability(i, 1)/sum;
    emissionProbability(i, 2) = emissionProbability(i, 2)/sum;
    emissionProbability(i, 3) = emissionProbability(i, 3)/sum;
    emissionProbability(i, 4) = emissionProbability(i, 4)/sum;
end

 obsmat0 = emissionProbability;

% Transition Probability Calculation

for i = 2:27
    sum = 0;
    for j = 1:28
        sum = sum + transitionProbability(i, j);
    end
    
    for j = 1:28
        if(transitionProbability(i, j) > 0)
            transitionProbability(i, j) = transitionProbability(i, j)/sum;
        end
    end
end

transmat0 = transitionProbability

% Accuracy Calculation
accuracyCalculation = zeros(101, 2);
accuracySum = 0;

for i = 1:100
    [r, c] = size(DNAData(i).Sequence);
    
    exon = exonData{1}{i};
    S = char(exon);
    C = split(S);
    C = C';
    [a, b] = size(C);
    
    valueToTest = testCSequence(i, 1:c);
    B = multinomial_prob(valueToTest, obsmat0);
    [path] = viterbi_path(prior0, transmat0, B);

    for j = 3:2:b-1
       index = exon(1, j);
       if(path(1, index + 1) == 7 & path(1, index + 2) == 8)
           accuracyCalculation(i, 1) = accuracyCalculation(i, 1) + 1;
       else
           accuracyCalculation(i, 2) = accuracyCalculation(i, 2) + 1;
       end
    end
    
    accuracy  = accuracyCalculation(i, 1)/(accuracyCalculation(i, 1) + accuracyCalculation(i, 2));
    accuracyCalculation(i, 1) = accuracy;
    accuracySum = accuracySum + accuracyCalculation(i, 1);
end

accuracySum * 100

% Viterbi path generation for a given sequence

[r, c] = size(inputString);
refinedSequence = zeros(size(1, c));

for i = 1:c
    refinedSequence(inputString == 'A') = 1;
    refinedSequence(inputString == 'C') = 2;
    refinedSequence(inputString == 'G') = 3;
    refinedSequence(inputString == 'T') = 4;
end

% refinedSequence

valueToTest = refinedSequence;
B = multinomial_prob(valueToTest, obsmat0);
[path] = viterbi_path(prior0, transmat0, B);

% Formatted output generation

[s, t] = size(path);

Sequence = zeros(1, length(path));
Sequence(path == 1) = 'S';
Sequence(path == 2) = 'E';
Sequence(path == 3) = 'a';
Sequence(path == 4) = 'b';
Sequence(path == 5) = 'c';
Sequence(path == 6) = 'M';
Sequence(path == 7) = 'G';
Sequence(path == 8) = 'T';
Sequence(path == 9) = 'O';
Sequence(path == 10) = 'P';
Sequence(path == 11) = 'Q';
Sequence(path == 12) = 'I';
Sequence(path == 13) = 'B';
Sequence(path == 14) = 'D';
Sequence(path == 15) = 'F';
Sequence(path == 16) = 'H';
Sequence(path == 17) = 'K';
Sequence(path == 18) = 'L';
Sequence(path == 19) = 'N';
Sequence(path == 20) = 'R';
Sequence(path == 21) = 'U';
Sequence(path == 22) = 'V';
Sequence(path == 23) = 'W';
Sequence(path == 24) = 'X';
Sequence(path == 25) = 'Y';
Sequence(path == 26) = 'A';
Sequence(path == 27) = 'Z';
Sequence(path == 28) = 'e';

statePath = '';

for i = 1:t
    currentChar = char(Sequence(1, i));
    if(currentChar == 'M' || currentChar == 'a' || currentChar == 'b' || currentChar == 'c')
        statePath = strcat(statePath, 'E');
    elseif(currentChar == 'O'||currentChar == 'P'||currentChar == 'Q'||currentChar == 'B'||currentChar == 'D'||currentChar == 'F'||currentChar == 'H'||currentChar == 'K'||currentChar == 'L'||currentChar == 'N'||currentChar == 'R'||currentChar == 'U'||currentChar == 'V'||currentChar == 'W'||currentChar == 'X'||currentChar == 'Y')
        statePath = strcat(statePath, 'I');
    else
        statePath = strcat(statePath, currentChar);
    end
end

for i = 1:t
    if(statePath(1, i) == 'G'||statePath(1, i) == 'T')
        statePath(1, i) = 'D';
    elseif(statePath(1, i) == 'Z')
        statePath(1, i) = 'A';
    end
end

for i = 2:t-1
    if(statePath(1, i) == 'A' & statePath(1, i-1) == 'I' & statePath(1, i+1) == 'I')
        statePath(1, i) = 'I';
    end
end

set(handles.analysis, 'String', statePath);



function analysis_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white'); 
end
