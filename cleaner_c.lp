#program initial.
cell(0..m-1, 0..n-1). 

% Fluent: position of the robot
h(robot_row, X) :- _cell(X,_,r).
h(robot_col, Y) :- _cell(_,Y,r).
% Fluent: all the empty cells are dirty (We consider that the obstacles are not dirty)
h(clean(X,Y),d) :- cell(X,Y), not _cell(X,Y,x), not _cell(X,Y,r).
h(clean(X,Y),c) :- _cell(X,Y,r).
h(clean(X,Y),c) :- _cell(X,Y,x).

% The robot can move up, down, left, or right within the grid
action(move(u)).
action(move(d)).
action(move(l)).
action(move(r)).


#program dynamic.
1 {o(A) : _action(A) } 1.

h(robot_row, X-1) :- o(move(u)), 'h(robot_row, X), X>0.
h(robot_row, X+1) :- o(move(d)), 'h(robot_row, X), X<m-1.
h(robot_col, Y-1) :- o(move(l)), 'h(robot_col, Y), Y>0.
h(robot_col, Y+1) :- o(move(r)), 'h(robot_col, Y), Y<n-1.

% Cant move to an obstacle
:- 'h(robot_row, X), 'h(robot_col, Y), o(move(u)), _cell(X-1,Y,x).
:- 'h(robot_row, X), 'h(robot_col, Y), o(move(d)), _cell(X+1,Y,x).
:- 'h(robot_row, X), 'h(robot_col, Y), o(move(l)), _cell(X,Y-1,x).
:- 'h(robot_row, X), 'h(robot_col, Y), o(move(r)), _cell(X,Y+1,x).

% The robot cleans the cells it is in
h(clean(X,Y),c) :- h(robot_row,X), h(robot_col,Y).

% Inertia axioms
h(F,V) :- 'h(F,V), not c(F).
c(F) :- 'h(F,V), h(F,W), V!=W.


#program final.
% None of the cells that are empty must be dirty
:- h(clean(X,Y),d).

% The robot must reach the goal
reach_goal :- h(robot_row, X), h(robot_col, Y), _cell(X,Y,g).
:- not reach_goal.