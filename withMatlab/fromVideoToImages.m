

source='vid.mp4';
vidobj=VideoReader(source);
frames = vidobj.FrameRate*vidobj.Duration;

%frames=vidobj.NumOfFrames;

for f=1:(frames-1)
    thisframe = read(vidobj,f);
    f
    %figure(1); 
    %imagesc(thisframe);
    thisfile = sprintf('dir/frame_%04d.jpg', f);
    imwrite( thisframe, thisfile );
    
end