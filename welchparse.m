function [x,M,isreal_x,y,Ly,win,winName,winParam,noverlap,k,L,options] = ...
    welchparse(x,esttype,varargin)
%WELCHPARSE   Parser for the PWELCH & SPECTROGRAM functions
%
% Outputs:
% X        - First input signal (used when esttype = MS & PSD)
% M        - An integer containing the length of the data to be segmented
% isreal_x - Boolean for input complexity
% Y        - Second input signal (used when esttype = CPSD, TFE, MSCOHERE)
% Ly       - Length of second input signal (used when esttype = CPSD, TFE,
%          MSCOHERE)
% WIN - A scalar or vector containing the length of the window or the 
%       window respectively (Note that the length of the window determines 
%       the length of the segments)
% WINNAME  - String with the window name.
% WINPARAM - Window parameter.
% NOVERLAP - An integer containing the number of samples to overlap (may 
%          be empty)
% K        - Number of segments
% OPTIONS  - A structure with the following fields:
%   OPTIONS.nfft  - number of freq. points at which the psd is estimated
%   OPTIONS.Fs    - sampling freq. if any
%   OPTIONS.range - 'onesided' or 'twosided' psd

%   Author(s): P. Costa
%   Copyright 1988-2006 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $  $Date: 2011/05/13 18:14:22 $

% Parse input arguments.
[x,M,isreal_x,y,Ly,win,winName,winParam,noverlap,opts] = ...
    parse_inputs(x,esttype,varargin{:});

% Obtain the necessary information to segment x and y.
[L,noverlap,win] = segment_info(M,win,noverlap);

% Parse optional args nfft, fs, and spectrumType.
options = welch_options(isreal_x,L,opts{:});

% Compute the number of segments
k = (M-noverlap)./(L-noverlap);

% Uncomment the following line to produce a warning each time the data
% segmentation does not produce an integer number of segements.
%if fix(k) ~= k),
%   warning('signal:welchparse:MustBeInteger','The number of segments is not an integer, truncating data.');
%end

k = fix(k); % fix(n)取小于n的整数

%-----------------------------------------------------------------------------------------------
function [x,Lx,isreal_x,y,Ly,win,winName,winParam,noverlap,opts] = ...
    parse_inputs(x,esttype,varargin)
% Parse the inputs to the welch function.

% Assign defaults in case of early return.
isreal_x = 1;
y        = [];
Ly       = 0;
is2sig   = false;
win      = [];
winName  = 'User Defined';
winParam = '';
noverlap = [];
opts     = {};

% Determine if one or two signal vectors was specified.
Lx = length(x);
if iscell(x),
    if Lx > 1, % Cell array.
        y = x{2};
        is2sig = true;
    end
    x = x{1};
    Lx = length(x);
else
    if ~any(strcmpi(esttype,{'psd','ms'})),
        error(message('signal:welchparse:NeedCellArray'));
    end
end

x = x(:);
isreal_x = isreal(x);

% Parse 2nd input signal vector.
if is2sig,
    y = y(:);
    isreal_x = isreal(y) && isreal_x;
    Ly = length(y);
    if Ly ~= Lx,
        error(message('signal:welchparse:MismatchedLength'));
    end
end

% Parse window and overlap, and cache remaining inputs.
lenargin = length(varargin);
if lenargin >= 1,
    win = varargin{1};
    if lenargin >= 2,
        noverlap = varargin{2};

        % Cache optional args nfft, fs, and spectrumType.
        if lenargin >= 3,  opts = varargin(3:end); end
    end
end

if isempty(win) | isscalar(win),
    winName = 'hamming';
    winParam = 'symmetric';
end

%-----------------------------------------------------------------------------------------------
function [L,noverlap,win] = segment_info(M,win,noverlap)
%SEGMENT_INFO   Determine the information necessary to segment the input data.
%
%   Inputs:
%      M        - An integer containing the length of the data to be segmented
%      WIN      - A scalar or vector containing the length of the window or the window respectively
%                 (Note that the length of the window determines the length of the segments)
%      NOVERLAP - An integer containing the number of samples to overlap (may be empty)
%
%   Outputs:
%      L        - An integer containing the length of the segments
%      NOVERLAP - An integer containing the number of samples to overlap
%      WIN      - A vector containing the window to be applied to each section
%
%
%   The key to this function is the following equation:
%
%      K = (M-NOVERLAP)/(L-NOVERLAP)
%
%   where
%
%      K        - Number of segments
%      M        - Length of the input data X
%      NOVERLAP - Desired overlap
%      L        - Length of the segments
%
%   The segmentation of X is based on the fact that we always know M and two of the set
%   {K,NOVERLAP,L}, hence determining the unknown quantity is trivial from the above
%   formula.

% Initialize outputs
L = [];

% Check that noverlap is a scalar
if any(size(noverlap) > 1),
    error(message('signal:welchparse:invalidNoverlap'));
end

if isempty(win),
    % Use 8 sections, determine their length
    if isempty(noverlap),
        % Use 50% overlap
        L = fix(M./4.5);
        noverlap = fix(0.5.*L);
    else
        L = fix((M+7.*noverlap)./8);
    end
    % Use a default window
    win = hamming(L);
else
    % Determine the window and its length (equal to the length of the segments)
    if ~any(size(win) <= 1) | ischar(win),
        error(message('signal:welchparse:MustBeScalarOrVector', 'WINDOW'));
    elseif length(win) > 1,
        % WIN is a vector
        L = length(win);
    elseif length(win) == 1,
        L = win;
        win = hamming(win);
    end
    if isempty(noverlap),
        % Use 50% overlap
        noverlap = fix(0.5.*L);
    end
end

% Do some argument validation
if L > M,
    error(message('signal:welchparse:invalidSegmentLength'));
end

if noverlap >= L,
    error(message('signal:welchparse:NoverlapTooBig'));
end

%------------------------------------------------------------------------------
function options = welch_options(isreal_x,N,varargin)
%WELCH_OPTIONS   Parse the optional inputs to the PWELCH function.
%   WELCH_OPTIONS returns a structure, OPTIONS, with following fields:
%
%   options.nfft         - number of freq. points at which the psd is estimated
%   options.Fs           - sampling freq. if any
%   options.range        - 'onesided' or 'twosided' psd

% Generate defaults
options.nfft = max(256,2^nextpow2(N)); 
% nextpow2() 比如数1000,那么靠的最近的（且比他大的）数就是1024=2^10，这个函数一般用在需要数组长度为2的指数的情况下，比如fft
options.Fs = []; % Work in rad/sample

% Determine if frequency vector specified
freqVecSpec = false;
if (length(varargin) > 0 && length(varargin{1}) > 1)
    freqVecSpec = true;
end    

if isreal_x && ~freqVecSpec,
    options.range = 'onesided';
else
    options.range = 'twosided';
end

if any(strcmp(varargin, 'whole'))
    warning(message('signal:welchparse:InvalidRange', '''whole''', '''twosided'''));
elseif any(strcmp(varargin, 'half'))
    warning(message('signal:welchparse:InvalidRange', '''half''', '''onesided'''));
end

[options,msg,msgobj] = psdoptions(isreal_x,options,varargin{:});
if ~isempty(msg), error(msgobj); end;



% [EOF]
