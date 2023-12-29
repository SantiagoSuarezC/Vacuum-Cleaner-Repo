%Authors: Fernando Nunez and Santiago Suarez.

#program initial.
% Define the grid
pos(X,Y) :- X=0..m-1, Y=0..n-1.
% Define the initial position of the robot
h(X,Y) :- _cell(X,Y,r).
% Define initial clean cells, which by now is only the position of the robot
clean(X,Y):-h(X,Y).
% Define initial dirty cells; all besides robot's position and block cells
dirty(X,Y):-not h(X,Y), pos(X,Y), not cell(X,Y,x).
% Define possible actions of the robot
action(move(u)).
action(move(d)).
action(move(l)).
action(move(r)).

#program dynamic.
% The robot must make one move
1 { o(A) : _action(A) } 1.
% Exclude movements that are not possible
h(X,Y+1) :- 'h(X,Y), o(move(u)), Y+1<n, not _cell(X,Y+1,x).
h(X,Y-1) :- 'h(X,Y), o(move(d)), Y-1>=0, not _cell(X,Y-1,x).
h(X+1,Y) :- 'h(X,Y), o(move(r)), X+1<m, not _cell(X+1,Y,x).
h(X-1,Y) :- 'h(X,Y), o(move(l)), X-1>=0, not _cell(X-1,Y,x).
% A cell remains clean if it was cleaned before
clean(X,Y):-'clean(X,Y).
% The robot cleans a cell if it is in that cell
clean(X,Y):- h(X,Y).
% A cell remains dirty if it was dirty before and the robot is not in that cell
dirty(X,Y):- 'dirty(X,Y), not h(X,Y).
% A cell is not dirty if the robot is in that cell
not dirty(X,Y):- 'dirty(X,Y), h(X,Y).

#program final.
% There must not be any dirty cells left
:- dirty(X,Y), _pos(X,Y).
% The robot must be in a goal cell
goal :- h(X,Y), _cell(X,Y,g).
:- not goal.

#show o/1.