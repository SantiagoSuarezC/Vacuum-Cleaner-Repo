% Game Setup: Definition of Grid and Cell Types
% -----------------------------------------------------------------------------------
% Define all positions for the grid
pos((X, Y)) :- X=0..n-1, Y=0..n-1.

% Define block cells (cells that are either 'x' or contain a number)
block_cell(X,Y) :- cell(X,Y,x).
block_cell(X,Y) :- numbered_cell(X,Y).
numbered_cell(X,Y) :- cell(X,Y,N), N >= 0, N <= 4.

% Define empty cells (cells without a number or 'x')
empty_cell(X,Y) :- pos((X,Y)), not block_cell(X,Y).

% Bulb Placement Rules
% -----------------------------------------------------------------------------------
% Bulbs can be placed in any empty cell
{ bulb(X,Y) : empty_cell(X,Y) }.

% Lighting Mechanics: How Bulbs Illuminate Cells
% -----------------------------------------------------------------------------------
% A bulb illuminates its entire row and column unless blocked by a black cell
% Light up a x and y line from a bulb
illuminate_x(Xbulb,Ybulb,X,Y) :- bulb(Xbulb,Ybulb), X = Xbulb, Y = Ybulb.
illuminate_y(Xbulb,Ybulb,X,Y) :- bulb(Xbulb,Ybulb), X = Xbulb, Y = Ybulb.
% Extend light in x-line until it hits a block cell or the grid edge
illuminate_x(Xbulb,Ybulb,X,Y) :- illuminate_x(Xbulb,Ybulb, X1,Y), X = X1 + 1, X < n, not block_cell(X,Y).
illuminate_x(Xbulb,Ybulb,X,Y) :- illuminate_x(Xbulb,Ybulb, X1,Y), X = X1 - 1, X >= 0, not block_cell(X,Y).
% Extend light in y-line until it hits a block cell or the grid edge
illuminate_y(Xbulb,Ybulb,X,Y) :- illuminate_y(Xbulb,Ybulb, X,Y1), Y = Y1 + 1, Y < n, not block_cell(X,Y).
illuminate_y(Xbulb,Ybulb,X,Y) :- illuminate_y(Xbulb,Ybulb, X,Y1), Y = Y1 - 1, Y >= 0, not block_cell(X,Y).
% Combine x and y illuminated
illuminated(Xbulb,Ybulb,X,Y) :- illuminate_y(Xbulb,Ybulb,X,Y).
illuminated(Xbulb,Ybulb,X,Y) :- illuminate_x(Xbulb,Ybulb,X,Y).

% Game Rules: Constraints for Valid Bulb Placement
% -----------------------------------------------------------------------------------
% Rule 1: All white cells must be lighted up by some bulb
%   checking if all board is lit up
:- illuminated(_,_,X,Y), not empty_cell(X,Y).
:- not illuminated(_,_,X,Y), empty_cell(X,Y).

% Rule 2: A light bulb cannot send a light ray on another bulb
:- illuminated(Xbulb1,Ybulb1,X,Y), bulb(Xbulb2,Ybulb2), X=Xbulb2, Y=Ybulb2, Xbulb1=Xbulb2, Ybulb1!=Ybulb2.
:- illuminated(Xbulb1,Ybulb1,X,Y), bulb(Xbulb2,Ybulb2), X=Xbulb2, Y=Ybulb2, Xbulb1!=Xbulb2, Ybulb1=Ybulb2.
:- illuminated(Xbulb1,Ybulb1,X,Y), bulb(Xbulb2,Ybulb2), X=Xbulb2, Y=Ybulb2, Xbulb1!=Xbulb2, Ybulb1!=Ybulb2.

% Rule 3: Number in black cell must match the count of neighboring bulbs
neighbours(Xblock,Yblock,Xbulb,Ybulb) :- numbered_cell(Xblock, Yblock),bulb(Xbulb,Ybulb), Xblock + 1 = Xbulb, Yblock = Ybulb, Xbulb < n.
neighbours(Xblock,Yblock,Xbulb,Ybulb) :- numbered_cell(Xblock,Yblock),bulb(Xbulb,Ybulb), Xblock - 1 = Xbulb, Yblock = Ybulb, Xbulb >= 0.
neighbours(Xblock,Yblock,Xbulb,Ybulb) :- numbered_cell(Xblock,Yblock),bulb(Xbulb,Ybulb), Xblock = Xbulb, Yblock + 1 = Ybulb, Ybulb < n.
neighbours(Xblock,Yblock,Xbulb,Ybulb) :- numbered_cell(Xblock,Yblock),bulb(Xbulb,Ybulb), Xblock = Xbulb, Yblock - 1 = Ybulb, Ybulb >= 0.
count_neighbour_bulbs(XBl, YBl, N) :- numbered_cell(XBl, YBl), #count{ Xbulb, Ybulb : neighbours(XBl, YBl, Xbulb, Ybulb) } = N.
:- count_neighbour_bulbs(X, Y, N1), numbered_cell(X, Y), cell(X, Y, N2), N1 != N2.

% Output Formatting
% -----------------------------------------------------------------------------------
% Bulb cell definition
cell(X, Y, b) :- bulb(X, Y).

% Output variables
#show pos/1.
#show cell/3.