#program initial.
pos(X,Y) :- X=0..m-1, Y=0..n-1.
h(X,Y) :- cell(X,Y,r).
clean(X,Y):-h(X,Y), pos(X,Y), not cell(X,Y,x).
dirty(X,Y):-not h(X,Y), pos(X,Y), not cell(X,Y,x).

#program dynamic.
1 { move(u); move(d); move(r); move(l) } 1.
h(X,Y+1) :- 'h(X,Y), move(u), Y+1<n, not _cell(X,Y+1,x).
h(X,Y-1) :- 'h(X,Y), move(d), Y-1>=0, not _cell(X,Y-1,x).
h(X+1,Y) :- 'h(X,Y), move(r), X+1<m, not _cell(X+1,Y,x).
h(X-1,Y) :- 'h(X,Y), move(l), X-1>=0, not _cell(X-1,Y,x).


clean(X,Y):-'clean(X,Y).
clean(X,Y):- h(X,Y).
dirty(X,Y):- 'dirty(X,Y), not h(X,Y).

#program final.
%h(X,Y) :- cell(X,Y,g).
goal :- h(X,Y), cell(X,Y,g).
:- not goal.