
t = createStereoVideo('C:\Users\danielbello\Desktop\matlab project\dir', 50);

implay(t);

disp('saving...')
v = VideoWriter('newfile.avi');
open(v)
writeVideo(v,t)
close(v)
