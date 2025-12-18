%.......................................
% minimax
%.......................................
% The minimax algorithm always assumes an optimal opponent.
% For tic-tac-toe, optimal play will always result in a tie, so the algorithm is effectively playing not-to-lose.
% For the opening move against an optimal player, the best minimax can ever hope for is a tie.
% So, technically speaking, any opening move is acceptable.
% Save the user the trouble of waiting  for the computer to search the entire minimax tree 
% by simply selecting a random square.

minimax(D, [
        [E,E,E,E,E,E], 
        [E,E,E,E,E,E], 
        [E,E,E,E,E,E], 
        [E,E,E,E,E,E], 
        [E,E,E,E,E,E], 
        [E,E,E,E,E,E], 
        [E,E,E,E,E,E]
    ],M,S,U) :-   
    blank_mark(E),
    U = 0,
    S = 4,
    !
    .


minimax(D, B, M, S, U) :-
    maxdepth(minimax, MaxDepth),
    D < MaxDepth,              %%% limit the depth of the search to avoid long computation times
    moves(B, L),               %%% get the list of available moves
    L \= [],                   %%% if there are available moves,
    !,
    D2 is D + 1,
    best(D2, B, M, L, S, U)    %%% recursively determine the best available move
    .

% if there are no more available moves, 
% then the minimax value is the utility_vanilla of the given board position

minimax(D, B, M, S, U) :-
    utility_vanilla(B, U),
    S = 0, !
    .


%.......................................
% best
%.......................................
% determines the best move in a given list of moves by recursively calling minimax
%

% if there is only one move left in the list...

best(D,B,M,[S1],S,U) :-
    move(B,S1,M,B2),        %%% apply that move to the board,
    inverse_mark(M,M2), !,   
    minimax(D, B2,M2,_S,U),  %%% then recursively search for the utility_vanilla value of that move.
    S = S1, !
    .

% if there is more than one move in the list...
% OPTIMISATION : Vérifier d'abord si un coup mène à une victoire immédiate

best_ab(D,B,M,[S1|T],S,U, Alpha, Beta) :-
    move(B,S1,M,B2),
    win(B2, M),                  %%% Si CE coup me fait gagner immédiatement
    !,                           %%% Pas besoin de chercher plus loin
    S = S1,
    utility(B2, U)            %%% Retourner le score de victoire avec profondeur
    .

best(D,B,M,[S1|T],S,U) :-
    move(B,S1,M,B2),             %%% apply the first move (in the list) to the board,
    inverse_mark(M,M2), !,
    minimax(D,B2,M2,_S,U1),      %%% recursively search for the utility_vanilla value of that move,
    best(D,B,M,T,S2,U2),         %%% determine the best move of the remaining moves,     
    better(D,M,S1,U1,S2,U2,S,U), !  %%% and choose the better of the two moves (based on their respective utility_vanilla values)
    . 
    
%.......................................
% utility_vanilla - Évalue le plateau complet
%.......................................

utility_vanilla(B, U) :-
    win(B, 'x'),
    U = 100000, !
    .

utility_vanilla(B, U) :-
    win(B, 'o'),
    U = (-100000), !
    .
    
utility_vanilla(B, U) :-
    U = 0, !
        . 


