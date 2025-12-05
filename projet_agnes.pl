cellByCoord(Board, Line, Col, Cell) :-%coordonnées entre 0 et n-1
    LineBis is 5-Line,
    nth0(Col, Board, Column),      
    nth0(LineBis, Column, Cell).      

total_cells([], 0).
total_cells([H|Q], Total) :-
    length(H,N),
    total_cells(Q, NewTotal),
    Total is NewTotal+N.

swapBoard(_,_, 0).
swapBoard(ComputeBoard, ReadBoard, TotalNbOfCell) :-
    LineNb is (TotalNbOfCell-1) div 7,
    ColNb is (TotalNbOfCell-1) mod 7,
    cellByCoord(ComputeBoard, LineNb, ColNb, Cell),
    nth0(LineNb, ReadBoard, Line),
    nth0(ColNb, Line, Cell),
    length(Line,7),
    length(ReadBoard,6),
    NewTotalNbOfCell is TotalNbOfCell-1,
    swapBoard(ComputeBoard, ReadBoard, NewTotalNbOfCell).  

displayBoard():-
    board(Board),
    total_cells(Board, TotalNbOfCell),
    swapBoard(ComputeBoard, ReadBoard, TotalNbOfCell),
    displayLines(Board).

display([]):- nl.
display([H|Q]) :-
    write(H),
    display(Q).

displayLines([]).
displayLines([H|Q]) :-
    display(H),
    displayLines(Q).