make_move(P, B, Move) :-
    player(P, Type),

    make_move2(Type, P, B, B2, Move),

    retract( board(_) ),
    asserta( board(B2) ),
    utility(B2, U),
    write('Utility: '), write(U)
    %print_utility(Type, U)
    .

make_move2(human, P, B, B2, S) :-
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

make_move2(human, P, B, B2, _) :-
    nl,
    nl,
    write('Please select a numbered square.'),
    make_move2(human,P,B,B2,_)
    .

make_move2(random, Player, Board, B2, Move) :-
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
    write('.'),
    nl.

make_move2(blockWinning, Player, Board, B2, Move) :-
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

make_move2([minimax, Depth], Player, Board, B2, Move) :-
    nl,
    nl,
    write('Computer is thinking about next move...'),
    player_mark(Player, Mark),
    minimax(0, Board,Mark,Move,Utility),
    move(Board,Move,Mark,B2),
    nl,
    nl,
    write('Computer places '),
    write(Mark),
    write(' in column '),
    write(Move),
    write('.'),
    nl.

make_move2([minimax_ab, Depth], Player, Board, B2, Move) :-
    nl,
    nl,
    write('Computer is thinking (Alpha-Beta)...'),
    player_mark(Player, Mark),
    minimax_ab(0, Board, Mark, Move, Utility, -10000000, 10000000),  % Alpha=-10000000, Beta=+10000000
    move(Board, Move, Mark, B2),
    nl,
    nl,
    write('Computer places '),
    write(Mark),
    write(' in column '),
    write(Move),
    write('.'),
    nl.


% moves(+Board, -ValidColumns)
moves(Board, ValidColumns) :-
    findall(ColNum,
        (between(1,7,ColNum), column_not_full(Board, ColNum)),
        ValidColumns).

% column_not_full(+Board, +ColNum)
column_not_full(Board, ColNum) :-
    nth1(ColNum, Board, Column),
    blank_mark(H),
    member(H, Column), !.  % CORRECTION: Ajout du cut pour éviter les doublons 

%.......................................
% square
%.......................................

% square(+B,+Move,+M) 
% Check if the top element of a column Move is equal to M

square(B,Move,M):-
    nth1(Move, B, Column),
    height(Column, Height), 
    Index is Height + 1, %% first empty position in the column
    Index =< 6, 
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


print_utility(Type, U) :-
    (Type = [minimax_ab, _] -> 
        (write('Minimax AI utility: '), write(U))
    ;
    true
    ).
