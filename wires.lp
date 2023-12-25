%PROBLEMITA QUE LA AMIGA ME ENCONTRÓ QUE PODE SERVIR DE INSPIRAÇÃO: https://github.com/kirle/ASP_Exercises

% ===============
% Used predicates: 
% ===============
% c(X,Y) meaning there is cell in row(X) and col(Y)
% startpoint(W,C) meaning cell C is the startpoint of wire W
% fill(X,Y,W) meaning position defined by (X,Y) is filled with wire W
% h(W,C) meaning that robot with wire W is in cell C
% adj(C1,C2) meaning C2 is adyacent to cell C1
% move (W,C1,C2) meaning there is a move of W from C1 to C2

% ===============
% Program
% ===============

% ----------------------
#program initial.
% Board 
row(0..nrows-1).
col(0..ncols-1).
c(X,Y) :- row(X), col(Y).

% Initial state
startpoint(W,C) :- end(W,C), end(W,C'), C<C'.
% Robot on starting point
h(W,C) :- startpoint(W,C).

% -------------------------
#program dynamic. 

% the robot W was in cell C if in last step has move from another cell to C
h(W,C) :- 'move(W,_,C).
% if a cell is filled it mantains filled over states
fill(X,Y,W) :- 'fill(X,Y,W).

% Minimizing in each state seems to improve performance better than doing in the final state (~3sec)
#minimize{1,X,Y:fill(X,Y,_)}.

% -------------------------
#program always.

% fill the cell where the robot is in
fill(X,Y,W) :- h(W,c(X,Y)).

% cant be two fills on same position
:- fill(X,Y,W), fill(X,Y,S), W<S.

% adjacent cells in the four possible directions
adj(c(X,Y), c(X+1,Y)) :- _c(X,Y), _c(X+1,Y), not _obs(X,Y), not _obs(X+1,Y).
adj(c(X,Y), c(X-1,Y)) :- _c(X,Y), _c(X-1,Y), not _obs(X,Y), not _obs(X-1,Y).
adj(c(X,Y), c(X,Y+1)) :- _c(X,Y), _c(X,Y+1), not _obs(X,Y), not _obs(X,Y+1).
adj(c(X,Y), c(X,Y-1)) :- _c(X,Y), _c(X,Y-1), not _obs(X,Y), not _obs(X,Y-1).

% chose only 1 move on each step
1{move(W,c(A,B),c(X,Y)) : adj(c(A,B),c(X,Y))}1 :-  fill(A,B,W).

% ----------------------
#program final.
% Goal: there is no endpoint of fill W that is no filled with this W
:- _end(W,c(X,Y)), not fill(X,Y,W).

% Show fluents to the output script
#show fill/3.
#show end/3.
#show obs/2.