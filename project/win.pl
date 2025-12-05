win(Board, M) :-
    % For each column, check the 3 first rows as a starting point for vertical win
    between(1,7,Col),
    between(1,3,Row),

    get_item(Board, Col, Column), % We retrieve the list Column in Board (list of lists)
    
    % We verify that the 4 items in the column are equal to M 
    get_item(Column, Row, M),
    R2 is Row+1, R3 is Row+2, R4 is Row+3,
    get_item(Column, R2, M),
    get_item(Column, R3, M),
    get_item(Column, R4, M).

win(Board, M) :-
    % For each row, check the 4 first columns as a starting point for horizontal win
    between(1,6,Row),
    between(1,4,Col),

    C2 is Col+1, C3 is Col+2, C4 is Col+3,

    get_item(Board, Col, ColList1), get_item(ColList1, Row, M),
    get_item(Board, C2, ColList2), get_item(ColList2, Row, M),
    get_item(Board, C3, ColList3), get_item(ColList3, Row, M),
    get_item(Board, C4, ColList4), get_item(ColList4, Row, M).

win(Board, M) :-
    % Check for rising diagonal wins
    between(1,4,Col),
    between(1,3,Row),

    C2 is Col+1, C3 is Col+2, C4 is Col+3,
    R2 is Row+1, R3 is Row+2, R4 is Row+3,

    get_item(Board, Col, Col1), get_item(Col1, Row, M),
    get_item(Board, C2, Col2), get_item(Col2, R2, M),
    get_item(Board, C3, Col3), get_item(Col3, R3, M),
    get_item(Board, C4, Col4), get_item(Col4, R4, M).

win(Board, M) :-
    % Check for falling diagonal wins
    between(1,4,Col),
    between(4,6,Row),
    C2 is Col+1, C3 is Col+2, C4 is Col+3,
    R2 is Row-1, R3 is Row-2, R4 is Row-3,
    get_item(Board, Col, Col1), get_item(Col1, Row, M),
    get_item(Board, C2, Col2), get_item(Col2, R2, M),
    get_item(Board, C3, Col3), get_item(Col3, R3, M),
    get_item(Board, C4, Col4), get_item(Col4, R4, M).