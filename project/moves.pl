make_move(P, B) :-
    player(P, Type),

    make_move2(Type, P, B, B2),

    retract( board(_) ),
    asserta( board(B2) )
    .

make_move2(human, P, B, B2) :-
    nl,
    nl,
    write('Player '),
    write(P),
    write(' move? '),
    read(S),

    blank_mark(E),
    square(B, S, E),
    player_mark(P, M),
    move(B, S, M, B2), !
    .

make_move2(human, P, B, B2) :-
    nl,
    nl,
    write('Please select a numbered square.'),
    make_move2(human,P,B,B2)
    .

make_move2(random, Player, Board, B2) :-
    nl,
    nl,
    write('Computer is thinking about next move...'),
    player_mark(Player, Mark),
    randomAI(Board, Move),
    move(Board,Move,Mark,B2),

    nl,
    nl,
    write('Computer places '),
    write(Mark),
    write(' in column '),
    write(Move),
    write('.').

make_move2(blockWinning, Player, Board, B2) :-
    nl,
    nl,
    write('Computer is thinking about next move...'),
    player_mark(Player, Mark),
    blockWining(Board, Mark, Move),
    move(Board,Move,Mark,B2),

    nl,
    nl,
    write('Computer places '),
    write(Mark),
    write(' in column '),
    write(Move),
    write('.').

make_move2([minimax, Depth], Player, Board, B2) :-
    nl,
    nl,
    write('Computer is thinking about next move...'),
    player_mark(Player, Mark),
    utility(Board,Utility)
    minimax(Depth,Board,Mark,Move,Utility),
    move(Board,Move,Mark,B2),

    nl,
    nl,
    write('Computer places '),
    write(Mark),
    write(' in column '),
    write(Move),
    write('.').


% moves(+Board, -ValidColumns)
moves(Board, ValidColumns) :-
    findall(ColNum,
        (between(1,7,ColNum), column_not_full(Board, ColNum)),
        ValidColumns).

% column_not_full(+Board, +ColNum)
column_not_full(Board, ColNum) :-
    nth1(ColNum, Board, Column),
    %write('Checking column '), write(Column), nl,
    blank_mark(H),
    %write('Blank mark is '), write(H), nl,
   	member(Column, H). 

%.......................................
% square
%.......................................
% The mark in a square(N) corresponds to an item in a list, as follows:

square([M,_,_,_,_,_,_,_,_],1,M).
square([_,M,_,_,_,_,_,_,_],2,M).
square([_,_,M,_,_,_,_,_,_],3,M).
square([_,_,_,M,_,_,_,_,_],4,M).
square([_,_,_,_,M,_,_,_,_],5,M).
square([_,_,_,_,_,M,_,_,_],6,M).
square([_,_,_,_,_,_,M,_,_],7,M).
square([_,_,_,_,_,_,_,M,_],8,M).
square([_,_,_,_,_,_,_,_,M],9,M).
% square(+B,+Move,+M) 
% Check if the top element of a column Move is equal to M

square(B,Move,M):-
    nth1(Move, B, Column),
    height(Column, Height), 
    Index is Height + 1, %% first empty position in the column
    Index < 6, 
    nth1(Index, Column, M).

%.......................................
% move
%.......................................
% applies a move on the given board
% (put mark M in square S on board B and return the resulting board B2)
%

move(B,S,M,B2) :-
    nth1(S, B, Column),
    height(Column, Height),
    NewHeight is Height + 1,
    set_item(Column,NewHeight,M,L2),
    set_item(B,S,L2,B2).
