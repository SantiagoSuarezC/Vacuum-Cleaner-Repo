% Definimos grid
grid(X, Y) :- X=0..m-1, Y=0..n-1.

% Initial position
pos(X,Y,0) :- cell(X,Y,"r").

% Movement actions
{ move(u); move(d); move(l); move(r) }.

% State transition
pos(X,Y+1,T+1) :- pos(X,Y,T), move(u).
pos(X,Y-1,T+1) :- pos(X,Y,T), move(d).
pos(X-1,Y,T+1) :- pos(X,Y,T), move(l).
pos(X+1,Y,T+1) :- pos(X,Y,T), move(r).

% Boundaries and obstacles
:- move(u), pos(X,Y,T), cell(X,Y+1,"x").
:- move(d), pos(X,Y,T), cell(X,Y-1,"x").
:- move(l), pos(X,Y,T), cell(X-1,Y,"x").
:- move(r), pos(X,Y,T), cell(X+1,Y,"x").
:- pos(X,Y,T), not grid(X,Y).

% Ensure all empty cells are visited
:- grid(X,Y), not cell(X, Y, "x"), T = 0..max_time, not pos(X, Y, T).

% Goal condition
pos(X,Y, T) :- cell(X,Y,"g"), T = max_time.

% Output the move at each time step
#show pos/3.

% Optional: Avoiding repeated states
%:- pos(X,Y,t1), pos(X,Y,t2), t1 != t2.

