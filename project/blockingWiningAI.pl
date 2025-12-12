
winnigMove(Board, Mark, Move) :-
    write('Checking winning move at '),
    moves(Board, ValidColumns),
    member(ValidColumns, Move), 
    write(Move), nl,
    move(Board,Move,Mark,Board2),
    write('truc'), nl,
    win(Board2, Mark).         % find a move that wins the game for the AI

notLoosingMove(Board, Mark, Move) :-
    write('Checking blocking move...'), nl,
    moves(Board, ValidColumns),
    member(ValidColumns, Move),
    inverse_mark(Mark, Opponent),
    winnigMove(Board, Opponent, Move). % find a move that blocks the opponent from winning

blockWining(Board, Mark, Move) :-
    winnigMove(Board, Mark, Move);
    notLoosingMove(Board, Mark, Move);
    randomAI(Board, Move).
    