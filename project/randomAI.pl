randomAI(Board, Move) :-
    moves(Board, ValidColumns),
    length(ValidColumns, Len),
    Len > 0,
    random_between(1, Len, Index),
    nth1(Index, ValidColumns, Move).