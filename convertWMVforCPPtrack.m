function convertWMVforCPPtrack(varargin)


% select file to process
if nargin == 0
    [filename, path] = uigetfile('.wmv', 'Select WMV file to process');
else
    filename = varargin{1};
    path = [pwd '\'];
end
cd(path);

[~, basename, ext] = fileparts(filename);

numFrames = 0;

disp(['Processing video file: ' filename]); 
tStart = tic;

vob = VideoReader([path filename]); % initialize videoReader object (NOTE: can only open WMV on Windows)

while hasFrame(vob)
    numFrames = numFrames+1;
    
    if mod(numFrames, 1000)==0
       disp(['Processing frame #' num2str(numFrames)]); 
       toc(tStart);
    end
    
    frame = readFrame(vob); % read a single frame
    frame = uint8(squeeze(mean(frame,3)));  % mean of RGB and make integer
    frame = frame(100:300, 50:end-50);  % trim a little off to make frame smaller
    imwrite(frame, [basename '.tif'], 'WriteMode', 'append');
end

toc(tStart);



