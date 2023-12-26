#program initial.
% Define grid
pos(X,Y) :- X=0..m-1, Y=0..n-1.
% Initial position
r((X,Y)) :- cell(X,Y,r).
% Possible actions
action(move(u)).
action(move(d)).
action(move(l)).
action(move(r)).
1 { o(A) : action(A) } 1.

#program always.
%Action generation
1 { o(A) : _action(A) } 1.
%Effect axioms
r((X,Y+1)) :- o(move(u)).
r((X,Y-1)) :- o(move(d)).
r((X-1,Y)) :- o(move(l)).
r((X+1,Y)) :- o(move(r)).
%Executability constraints
:- 'r((X,Y)), o(move(u)), Y+1 < n.
:- 'r((X,Y)), o(move(u)), cell(X,Y+1,x).
:- 'r((X,Y)), o(move(d)), Y-1 < 0.
:- 'r((X,Y)), o(move(d)), cell(X,Y-1,x).
:- 'r((X,Y)), o(move(l)), X-1 < 0.
:- 'r((X,Y)), o(move(l)), cell(X-1,Y,x).
:- 'r((X,Y)), o(move(r)), X+1 >= m.
:- 'r((X,Y)), o(move(r)), cell(X+1,Y,x).
visited(X,Y) :- r((X,Y)).

#program final.
% Ensure the robot is in the goal cell for the last move
goal :- r((X,Y)), cell(X,Y,g).
:- not goal.
% Ensure all non-obstacle cells are visited at least once
%:- grid(X, Y), not cell(X, Y, x), not 'pos(X, Y).

% Output the move at each time step
#show o/1.

% Optional: Avoiding repeated states
%:- pos(X,Y,T1), pos(X,Y,T2), T1 != T2.