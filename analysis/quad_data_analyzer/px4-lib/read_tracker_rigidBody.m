function [rb] = read_tracker_rigidBody(filename)

if(exist(filename,'file') == 0)
    rb = [];
    return;
end

data = dlmread(filename);

%{
    //---   rigid body head
    timestamp
    tracker timestamp
    frame number
    id
    pos.x in mm
    pos.y
    pos.z
    roll in rad
    pitch in rad
    yaw in rad
    roll in deg
    pitch in deg
    yaw in deg
    quaternion.x
    quaternion.y
    quaternion.z
    quaternion.w
    mean error
    number of markers
%}

%{
    //---   marker
    marker index
    marker id
    marker size
    marker pos.x
    marker pos.y
    marker pos.z
%}


rb.ts               = data(:,1);
rb.tracker_ts       = data(:,2);
rb.fame_nr          = data(:,3);
rb.id               = data(:,4);
rb.x                = data(:,5);
rb.y                = data(:,6);
rb.z                = data(:,7);
rb.roll             = data(:,8);
rb.pitch            = data(:,9);
rb.yaw              = data(:,10);
rb.droll            = data(:,11);
rb.dpitch           = data(:,12);
rb.dyaw             = data(:,13);
rb.q(:,1)           = data(:,14);
rb.q(:,2)           = data(:,15);
rb.q(:,3)           = data(:,16);
rb.q(:,4)           = data(:,17);
rb.mean_error       = data(:,18);
rb.nMarkers         = data(:,19);

for k=1:rb.nMarkers

    rb.m(k).index   = data(:,18 + (k-1)*6 + 1);
    rb.m(k).id      = data(:,18 + (k-1)*6 + 2);
    rb.m(k).size    = data(:,18 + (k-1)*6 + 3);
    rb.m(k).x       = data(:,18 + (k-1)*6 + 4);
    rb.m(k).y       = data(:,18 + (k-1)*6 + 5);
    rb.m(k).z       = data(:,18 + (k-1)*6 + 6);

end

rb.n = length(rb.ts);

end