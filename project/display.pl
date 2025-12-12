cellByCoord(Board, Line, Col, Cell) :-%coordonnées entre 0 et n-1
    LineBis is 5-Line,
    nth0(Col, Board, Column),      
    nth0(LineBis, Column, Cell).      

total_cells([], 0).
total_cells([H|Q], Total) :-
    length(H,N),
    total_cells(Q, NewTotal),
    Total is NewTotal+N.

swapBoard(ComputeBoard,ReadBoard):-
    total_cells(ComputeBoard, TotalNbOfCell),
    swapBoard2(ComputeBoard, ReadBoard, TotalNbOfCell).
swapBoard2(_,_, 0).
swapBoard2(ComputeBoard, ReadBoard, TotalNbOfCell) :-
    LineNb is (TotalNbOfCell-1) div 7,
    ColNb is (TotalNbOfCell-1) mod 7,
    cellByCoord(ComputeBoard, LineNb, ColNb, Cell),
    nth0(LineNb, ReadBoard, Line),
    nth0(ColNb, Line, Cell),
    length(Line,7),
    length(ReadBoard,6),
    NewTotalNbOfCell is TotalNbOfCell-1,
    swapBoard2(ComputeBoard, ReadBoard, NewTotalNbOfCell).  

displayBoard(LastCol):-
    board(Board),
    swapBoard(Board, ReadBoard),
    nl,
    displayLines(ReadBoard, LastCol, Printed).

display([], _, _, _) :-
    write("|"),
    nl.

display([H|Q], LastCol, D, Printed) :-
    D2 is D+1,
    blank_mark(H),
    write("| "),
    display(Q, LastCol, D2, Printed).

display([H|Q], LastCol, D, Printed) :-   % colored cell
    D2 is D+1,
    D2 == LastCol,
    Printed \== 1,
    write("|\033[0;31m"),
    write(H),
    write("\033[0m"),
    Printed is 1,
    display(Q, LastCol, D2, Printed).

display([H|Q], LastCol, D, Printed) :-
    D2 is D+1,
    (D2 \== LastCol; Printed == 1),
    write("|"),
    write(H),
    display(Q, LastCol, D2, Printed).

displayLines([], _, _).

displayLines([H|Q], LastCol, Printed) :-
    display(H, LastCol, 0, Printed),
    displayLines(Q, LastCol, Printed).