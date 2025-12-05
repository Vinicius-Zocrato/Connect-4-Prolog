% moves(+Board, -ValidColumns)
moves(Board, ValidColumns) :-
    findall(ColNum,
        (between(1,7,ColNum), column_not_full(Board, ColNum)),
        ValidColumns).

% column_not_full(+Board, +ColNum)
column_not_full(Board, ColNum) :-
    nth1(ColNum, Board, Column),
   	memberchk('e', Column). 
