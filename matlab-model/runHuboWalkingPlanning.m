function plan = runHuboWalkingPlanning()
% Demonstration of footstep and walking planning on Atlas. First, the footstep planning
% step generates a set of reachable footstep poses. Next, we use those foot poses to
% plan a trajectory of the Zero Moment Point (ZMP), from which we can derive a
% trajectory for the robot's Center of Mass. From this, we can plan a full state
% trajectory for the robot.
% @retval plan a WalkingPlanData object including the zmp and com trajectories


checkDependency('lcmgl');
addpath(fullfile(getDrakePath(), 'examples', 'ZMP'));
% Set up the model
load('/home/alexc89/Desktop/Hubo/matlab-model/data/hubo_fp.mat', 'xstar');
x0 = xstar;
options = struct();
options.floating = true;
r = HuboBiped('urdf/hubo_minimal_contact.urdf',options);
r = r.setInitialState(x0);


% Plan footsteps to the goal
q0 = x0(1:r.getNumDOF());
goal_pos = struct('right', [1;0;0;0;0;0], 'left', [1;0;0;0;0;0]);
footstep_plan = r.planFootsteps(q0, goal_pos);

% Show the result
v = r.constructVisualizer();
v.draw(0, x0);
walking_plan_data = r.planWalkingZMP(x0, footstep_plan);
[xtraj, htraj, ts] = r.planWalkingStateTraj(walking_plan_data);

if isa(v, 'BotVisualizer')
  lcmgl = drake.util.BotLCMGLClient(lcm.lcm.LCM.getSingleton(), 'footstep_plan');
  footstep_plan.draw_lcmgl(lcmgl);
  lcmgl = drake.util.BotLCMGLClient(lcm.lcm.LCM.getSingleton(), 'walking_plan');
  walking_plan_data.draw_lcmgl(lcmgl);
  lcmgl.switchBuffers();
else
  figure(25)
  footstep_plan.draw_2d();
end
options.slider = true;
v.playback(xtraj,options);



end

