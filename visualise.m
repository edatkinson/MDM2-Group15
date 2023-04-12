
displacement_x = diff(velocities(:,1));
displacement_y = diff(velocities(:,2));
disp_mag = sqrt(displacement_x.^2 + displacement_y.^2);
t = linspace(0,42,length(velocities));
td = linspace(0,42,length(displacement_x)); 
angular_vel = diff(orientations);

% figure; Magnitudes of velocity and displacement.
% subplot(3,1,1)
% plot(td,disp_mag,'b');
% title('Displacement graph against Time ');
% xlabel('Time');
% ylabel('Displacement');
% 
% subplot(3,1,2)
% plot(t,velocities(:,3),'r');
% title("Velocity Graph Against Time)");
% xlabel('Time');
% ylabel('Velocity');

%figure;
smooth_angular_vel = movmean(angular_vel, 10); 
%plot(smooth_angular_vel);
figure;
plot(angular_vel)
title("Angular Velocity");
xlabel("Frames");
ylabel("Angular Velocity (Rad/s)");


figure;
subplot(4,1,1)
plot(velocities(:,1),'r');
title("Velocity Graph Against Frames (X-Direction)");
xlabel('Frames');
ylabel('Velocity Pixel/Frame');
subplot(4,1,2)
plot(displacement_x, 'b');
title('Displacement graph against Time (X-Direction)')
xlabel('Frame');
ylabel('Displacement Pixels');
subplot(4,1,3);
plot(velocities(:,2),'r');
title("Velocity Graph Against Frames (Y-Direction)");
xlabel('Frames');
ylabel('Velocity Pixels/Frame');
subplot(4,1,4);
plot(displacement_y,'b')
title('Displacement graph against Time (Y-Direction)')
xlabel('Frames');
ylabel('Displacement Pixels');