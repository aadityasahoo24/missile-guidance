%% Extract missile data

missileTS = exportVar{1}.Values;
targetTS  = exportVar{2}.Values;

tM = missileTS.Time;
xM = missileTS.Data(:,1);
yM = missileTS.Data(:,2);

tT = targetTS.Time;
xT = targetTS.Data(:,1);
yT = targetTS.Data(:,2);

%% Create figure

figure('Name','Missile Intercept Animation');

xmin = min([xM; xT]);
xmax = max([xM; xT]);

ymin = min([yM; yT]);
ymax = max([yM; yT]);

padding = 500;

axis equal
grid on
hold on

xlim([xmin-padding xmax+padding]);
ylim([ymin-padding ymax+padding]);
    
xlabel('X Position (m)');
ylabel('Y Position (m)');

%% Graphics objects

missileTrail = plot(NaN,NaN,'b','LineWidth',2);
targetTrail  = plot(NaN,NaN,'r','LineWidth',2);

missileDot = plot(NaN,NaN,'bo',...
    'MarkerFaceColor','b',...
    'MarkerSize',8);

targetDot = plot(NaN,NaN,'ro',...
    'MarkerFaceColor','r',...
    'MarkerSize',8);

losLine = plot(NaN,NaN,'k--','LineWidth',1);

legend('Missile Path',...
       'Target Path',...
       'Missile',...
       'Target',...
       'LOS', 'Location','northwest');

%% Animation loop

for k = 1:length(tM)

    % update trails
    set(missileTrail,...
        'XData',xM(1:k),...
        'YData',yM(1:k));

    set(targetTrail,...
        'XData',xT(1:k),...
        'YData',yT(1:k));

    % update vehicle markers
    set(missileDot,...
        'XData',xM(k),...
        'YData',yM(k));

    set(targetDot,...
        'XData',xT(k),...
        'YData',yT(k));

    % LOS line
    set(losLine,...
        'XData',[xM(k) xT(k)],...
        'YData',[yM(k) yT(k)]);

    % range
    R = hypot(xT(k)-xM(k),yT(k)-yM(k));

    title(sprintf( ...
        't = %.2f s   Range = %.1f m', ...
        tM(k),R));

    drawnow

    % replay at simulation speed
    if k > 1
        %pause(tM(k)-tM(k-1));
    end

    % stop animation at hit
    if R < Rhit 
        title(sprintf( ...
            'TARGET HIT   t = %.2f s', ...
            tM(k)));
        break
    end

end