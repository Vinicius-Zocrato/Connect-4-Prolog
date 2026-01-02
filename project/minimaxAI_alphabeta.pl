%.......................................
% minimax_ab
%.......................................
% The minimax_ab algorithm always assumes an optimal opponent.
% For tic-tac-toe, optimal play will always result in a tie, so the algorithm is effectively playing not-to-lose.
% For the opening move against an optimal player, the best_ab minimax_ab can ever hope for is a tie.
% So, technically speaking, any opening move is acceptable.
% Save the user the trouble of waiting  for the computer to search the entire minimax_ab tree 
% by imply selecting a random square.

minimax_ab(_, [
        [E,E,E,E,E,E], 
        [E,E,E,E,E,E], 
        [E,E,E,E,E,E], 
        [E,E,E,E,E,E], 
        [E,E,E,E,E,E], 
        [E,E,E,E,E,E], 
        [E,E,E,E,E,E]
    ],_,S,U, _, _) :-   
    blank_mark(E),
    U = 0,
    S = 4,
    !
    .

% minimax_ab avec alpha-beta
% D = profondeur, B = plateau, M = joueur, S = coup, U = utilité
% Alpha = meilleure valeur pour Max, Beta = meilleure valeur pour Min

% VÉRIFICATION PRÉCOCE : Si quelqu'un a gagné, arrêter immédiatement
minimax_ab(_, B, _, _, U, _, _) :-
    (win(B, 'x') ; win(B, 'o')),   %%% Si victoire détectée
    !,
    utility(B, U)                   %%% Retourner l'utilité immédiatement
    .

minimax_ab(D, B, M, S, U, Alpha, Beta) :-
    maxdepth(minimax_ab, MaxDepth),
    D < MaxDepth,              %%% limit the depth of the search to avoid long computation times
    moves(B, L),               %%% get the list of available moves
    L \= [],                   %%% if there are available moves,
    !,
    D2 is D + 1,
    best_ab(D2, B, M, L, S, U, Alpha, Beta)    %%% recursively determine the best_ab available move
    .

% if there are no more available moves, 
% then the minimax_ab value is the utility of the given board position

minimax_ab(_, B, _, _, U, _, _) :-
    utility(B, U)    
    .


%.......................................
% best_ab avec alpha-beta pruning
%.......................................
% determines the best_ab move in a given list of moves by recursively calling minimax_ab
%

% if there is only one move left in the list...

best_ab(D,B,M,[S1],S,U, Alpha, Beta) :-
    move(B,S1,M,B2),        %%% apply that move to the board,
    inverse_mark(M,M2),   
    minimax_ab(D, B2,M2,_S,U, Alpha, Beta),  %%% then recursively search for the utility value of that move.
    S = S1, !
    .
    

% if there is more than one move in the list...
% OPTIMISATION : Vérifier d'abord si un coup mène à une victoire immédiate

best_ab(_,B,M,[S1|_],S,U, _, _) :-
    move(B,S1,M,B2),
    win(B2, M),                  %%% Si CE coup me fait gagner immédiatement
    !,                           %%% Pas besoin de chercher plus loin
    S = S1,
    utility(B2, U)            %%% Retourner le score de victoire avec profondeur
    .

best_ab(_,B,M,[S1|_],S,U, _, _) :-
    inverse_mark(M,M2),
    move(B,S1,M2,B2),
    win(B2, M2),                  %%% Si CE coup me fait gagner immédiatement
    !,                           %%% Pas besoin de chercher plus loin
    S = S1,
    (M == 'x' -> U = 100000; M == 'o' -> U = -100000 )  .         %%% Retourner le score de victoire avec profondeur
   

% if there is more than one move in the list...
% Implémentation de l'élagage alpha-beta

best_ab(D,B,M,[S1|T],S,U, Alpha, Beta) :-
    move(B,S1,M,B2),             %%% apply the first move (in the list) to the board,
    inverse_mark(M,M2), 
    minimax_ab(D,B2,M2,_S,U1, Alpha, Beta),      %%% recursively search for the utility value of that move,
    
    % algorithme alpha-beta
    (maximizing(M) ->
        % Nœud de type Max
        NewAlpha is max(Alpha, U1),
        (NewAlpha >= Beta ->
            % Coupure beta : on retourne immédiatement
            S = S1,
            U = NewAlpha
        ;
            % Pas de coupure : on continue avec les autres mouvements
            best_ab(D,B,M,T,S2,U2, NewAlpha, Beta),
            better(D,M,S1,U1,S2,U2,S,U)
        )
    ;
        % Nœud de type Min
        NewBeta is min(Beta, U1),
        (Alpha >= NewBeta ->
            % Coupure alpha : on retourne immédiatement
            S = S1,
            U = NewBeta
        ;
            % Pas de coupure : on continue avec les autres mouvements
            best_ab(D,B,M,T,S2,U2, Alpha, NewBeta),
            better(D,M,S1,U1,S2,U2,S,U)
        )
    ), !
    .



