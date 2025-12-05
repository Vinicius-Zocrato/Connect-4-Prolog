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

make_move2(computer, P, B, B2) :-
    nl,
    nl,
    write('Computer is thinking about next move...'),
    player_mark(P, M),
    minimax(0, B, M, S, U),
    move(B,S,M,B2),

    nl,
    nl,
    write('Computer places '),
    write(M),
    write(' in square '),
    write(S),
    write('.')
    .

% moves(+Board, -ValidColumns)
moves(Board, ValidColumns) :-
    findall(ColNum,
        (between(1,7,ColNum), column_not_full(Board, ColNum)),
        ValidColumns).

% column_not_full(+Board, +ColNum)
column_not_full(Board, ColNum) :-
    nth1(ColNum, Board, Column),
   	memberchk('e', Column). 


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
    copy_term(Column, L2),
    set_item(Column,S,M,L2).

%.......................................
% set_item
%.......................................
% Given a list L, replace the item at position N with V
% return the new list in list L2
%

set_item(L, N, V, L2) :-
    set_item2(L, N, V, 1, L2)
        .

set_item2( [], N, V, A, L2) :- 
    N == -1, 
    L2 = []
    .

set_item2( [_|T1], N, V, A, [V|T2] ) :- 
    A = N,
    A1 is N + 1,
    set_item2( T1, -1, V, A1, T2 )
    .

set_item2( [H|T1], N, V, A, [H|T2] ) :- 
    A1 is A + 1, 
    set_item2( T1, N, V, A1, T2 )
    .



