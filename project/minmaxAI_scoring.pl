%.......................................
% minimax_scoring
%.......................................
% The minimax_scoring algorithm always assumes an optimal opponent.
% For tic-tac-toe, optimal play will always result in a tie, so the algorithm is effectively playing not-to-lose.
% For the opening move against an optimal player, the best_scoring minimax_scoring can ever hope for is a tie.
% So, technically speaking, any opening move is acceptable.
% Save the user the trouble of waiting  for the computer to search the entire minimax_scoring tree 
% by simply selecting a random square.

minimax_scoring(_, [
        [E,E,E,E,E,E], 
        [E,E,E,E,E,E], 
        [E,E,E,E,E,E], 
        [E,E,E,E,E,E], 
        [E,E,E,E,E,E], 
        [E,E,E,E,E,E], 
        [E,E,E,E,E,E]
    ],_,S,U) :-   
    blank_mark(E),
    U = 0,
    S = 4,
    !
    .


minimax_scoring(D, B, M, S, U) :-
    maxdepth(minimax_scoring, MaxDepth),
    D < MaxDepth,              %%% limit the depth of the search to avoid long computation times
    moves(B, L),               %%% get the list of available moves
    L \= [],                   %%% if there are available moves,
    !,
    D2 is D + 1,
    best_scoring(D2, B, M, L, S, U)    %%% recursively determine the best_scoring available move
    .

% if there are no more available moves, 
% then the minimax_scoring value is the utility of the given board position

minimax_scoring(_, B, _, S, U) :-
    utility(B, U),
    S = 0, !
    .


%.......................................
% best_scoring
%.......................................
% determines the best_scoring move in a given list of moves by recursively calling minimax_scoring
%

% if there is only one move left in the list...

best_scoring(D,B,M,[S1],S,U) :-
    move(B,S1,M,B2),        %%% apply that move to the board,
    inverse_mark(M,M2), !,   
    minimax_scoring(D, B2,M2,_S,U),  %%% then recursively search for the utility value of that move.
    S = S1, !
    %output_value(D,S,U),
    .

% if there is more than one move in the list...
% OPTIMISATION : Vérifier d'abord si un coup mène à une victoire immédiate

best_scoring(_,B,M,[S1|_],S,U) :-
    move(B,S1,M,B2),
    win(B2, M),                  %%% Si CE coup me fait gagner immédiatement
    !,                           %%% Pas besoin de chercher plus loin
    S = S1,
    utility(B2, U).            %%% Retourner le score de victoire avec profondeur
        
best_scoring(_,B,M,[S1|_],S,U, _, _) :-
    inverse_mark_mark(M,M2),
    move(B,S1,M2,B2),
    win(B2, M2),                  %%% Si CE coup me fait gagner immédiatement
    !,                           %%% Pas besoin de chercher plus loin
    S = S1,
    (M == 'x' -> U = 100000; M == 'o' -> U = -100000 )  .         %%% Retourner le score de victoire avec profondeur
   

best_scoring(D,B,M,[S1|T],S,U) :-
    move(B,S1,M,B2),             %%% apply the first move (in the list) to the board,
    inverse_mark(M,M2), !,
    minimax_scoring(D,B2,M2,_S,U1),      %%% recursively search for the utility value of that move,
    best_scoring(D,B,M,T,S2,U2),         %%% determine the best_scoring move of the remaining moves,
    %output_value(D,S1,U1),      
    better(D,M,S1,U1,S2,U2,S,U), !  %%% and choose the better of the two moves (based on their respective utility values)
    .



