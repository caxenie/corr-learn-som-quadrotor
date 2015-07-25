% visualize the inferred RPY and overlay the optimizer extracted curve
close all; clear all; clc;
% ROLL ANALYSIS
hgload('/home/caxenie/Dropbox/Public/sandbox/research/research_overview_19_02_2015/media/quad_data/learned/roll.fig');
hr = findall(gcf, 'type','image');
datar = get(hr,'cdata');
ymarksr=1:100; [~, xmarksr]=max((datar), [], 2);
hold on; plot(xmarksr, ymarksr, '*y', 'LineWidth', 4);
hold on; plot(xmarksr, ymarksr, 'y', 'LineWidth', 4);
% PITCH ANALYSIS
hgload('/home/caxenie/Dropbox/Public/sandbox/research/research_overview_19_02_2015/media/quad_data/learned/pitch.fig');
hp = findall(gcf, 'type','image');
datap = get(hp,'cdata');
ymarksp=1:100; [~, xmarksp]=max((datap), [], 2);
hold on; plot(xmarksp, ymarksp, '*y', 'LineWidth', 4);
hold on; plot(xmarksp, ymarksp, 'y', 'LineWidth', 4);
% YAW ANALYSIS
hgload('/home/caxenie/Dropbox/Public/sandbox/research/research_overview_19_02_2015/media/quad_data/learned/yaw.fig');
hy = findall(gcf, 'type','image');
datay = get(hy,'cdata');
ymarksy=1:100; [~, xmarksy]=max((datay), [], 2);
hold on; plot(xmarksy, ymarksy, '*y', 'LineWidth', 4);
hold on; plot(xmarksy, ymarksy, 'y', 'LineWidth', 4);