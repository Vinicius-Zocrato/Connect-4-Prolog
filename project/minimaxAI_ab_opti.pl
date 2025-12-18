%.......................................
% minimax_ab_opti
%.......................................
% The minimax_ab_opti algorithm always assumes an optimal opponent.
% For tic-tac-toe, optimal play will always result in a tie, so the algorithm is effectively playing not-to-lose.
% For the opening move against an optimal player, the best_ab_opti minimax_ab_opti can ever hope for is a tie.
% So, technically speaking, any opening move is acceptable.
% Save the user the trouble of waiting  for the computer to search the entire minimax_ab_opti tree 
% by imply selecting a random square.

minimax_ab_opti(D, [
        [E,E,E,E,E,E], 
        [E,E,E,E,E,E], 
        [E,E,E,E,E,E], 
        [E,E,E,E,E,E], 
        [E,E,E,E,E,E], 
        [E,E,E,E,E,E], 
        [E,E,E,E,E,E]
    ],M,S,U, Alpha, Beta) :-   
    blank_mark(E),
    U = 0,
    S = 4,
    !
    .

% minimax_ab_opti avec alpha-beta
% D = profondeur, B = plateau, M = joueur, S = coup, U = utilité
% Alpha = meilleure valeur pour Max, Beta = meilleure valeur pour Min

% VÉRIFICATION PRÉCOCE : Si quelqu'un a gagné, arrêter immédiatement
minimax_ab_opti(D, B, M, S, U, Alpha, Beta) :-
    (win(B, 'x') ; win(B, 'o')),   %%% Si victoire détectée
    !,
    utility(B, U)                   %%% Retourner l'utilité immédiatement
    .

minimax_ab_opti(D, B, M, S, U, Alpha, Beta) :-
    maxdepth(minimax_ab_opti, MaxDepth),
    D < MaxDepth,              %%% limit the depth of the search to avoid long computation times
    moves(B, L),               %%% get the list of available moves
    L \= [],                   %%% if there are available moves,
    !,
    D2 is D + 1,
    order_moves(B, M, L, OrderedL),  % ordre des mouvements pour optimisation
    best_ab_opti(D2, B, M, OrderedL, S, U, Alpha, Beta)    %%% recursively determine the best_ab_opti available move
    .

% if there are no more available moves, 
% then the minimax_ab_opti value is the utility of the given board position

minimax_ab_opti(D, B, M, S, U, Alpha, Beta) :-
    utility(B, U)    
    .


%.......................................
% best_ab_opti avec alpha-beta pruning
%.......................................
% determines the best_ab_opti move in a given list of moves by recursively calling minimax_ab_opti
%

% if there is only one move left in the list...

best_ab_opti(D,B,M,[S1],S,U, Alpha, Beta) :-
    move(B,S1,M,B2),        %%% apply that move to the board,
    inverse_mark(M,M2),   
    minimax_ab_opti(D, B2,M2,_S,U, Alpha, Beta),  %%% then recursively search for the utility value of that move.
    S = S1, !
    .

% if there is more than one move in the list...
% OPTIMISATION : Vérifier d'abord si un coup mène à une victoire immédiate

best_ab_opti(D,B,M,[S1|T],S,U, Alpha, Beta) :-
    move(B,S1,M,B2),
    win(B2, M),                  %%% Si CE coup me fait gagner immédiatement
    !,                           %%% Pas besoin de chercher plus loin
    S = S1,
    utility(B2, U)            %%% Retourner le score de victoire avec profondeur
    .

% if there is more than one move in the list...
% Implémentation de l'élagage alpha-beta

best_ab_opti(D,B,M,[S1|T],S,U, Alpha, Beta) :-
    move(B,S1,M,B2),             %%% apply the first move (in the list) to the board,
    inverse_mark(M,M2), 
    minimax_ab_opti(D,B2,M2,_S,U1, Alpha, Beta),      %%% recursively search for the utility value of that move,
    
    % algorithme alpha-beta
    (maximizing(M) ->
        % Nœud de type Max
        NewAlpha is max(Alpha, U1),
        (NewAlpha >= Beta ->
            % Coupure beta : on retourne immédiatement
            S = S1,
            U = NewAlpha,
        ;
            % Pas de coupure : on continue avec les autres mouvements
            best_ab_opti(D,B,M,T,S2,U2, NewAlpha, Beta),
            better(D,M,S1,U1,S2,U2,S,U)
        )
    ;
        % Nœud de type Min
        NewBeta is min(Beta, U1),
        (Alpha >= NewBeta ->
            % Coupure alpha : on retourne immédiatement
            S = S1,
            U = NewBeta,
        ;
            % Pas de coupure : on continue avec les autres mouvements
            best_ab_opti(D,B,M,T,S2,U2, Alpha, NewBeta),
            better(D,M,S1,U1,S2,U2,S,U)
        )
    ), !
    .
     
%.......................................
% heuristique pour parcourir les branches de façon plus optimisée
%.......................................

order_moves(B, M, Moves, OrderedMoves) :-
    % Évaluer chaque coup avec un score heuristique
    evaluate_moves(B, M, Moves, ScoredMoves),
    % Trier par score décroissant (meilleurs en premier)
    sort(1, @>=, ScoredMoves, SortedMoves),
    % Extraire juste les colonnes (sans les scores)
    extract_columns(SortedMoves, OrderedMoves).


%.......................................
% evaluate_moves - Évalue chaque coup
%.......................................
evaluate_moves(_, _, [], []).

evaluate_moves(B, M, [Col|Rest], [Score-Col|RestScored]) :-
    move(B, Col, M, B2),
    % Évaluer la position résultante avec une heuristique rapide
    quick_eval(B2, M, Col, Score),
    evaluate_moves(B, M, Rest, RestScored).


%.......................................
% quick_eval - Évaluation heuristique rapide
%.......................................
% Combine plusieurs facteurs :
% 1. Coup gagnant immédiat = priorité maximale
% 2. Bloquer un coup gagnant adverse = haute priorité
% 3. Position centrale = bonus

quick_eval(B, M, Col, Score) :-
    % Facteur 1 : Coup gagnant immédiat ?
    (win(B, M) ->
        Score is 1000000
    ;
        inverse_mark(M, OpponentMark),
        
        % Facteur 2 : Bloquer un coup gagnant adverse ?
        (would_win_next(B, Col, OpponentMark) ->
            BlockScore = 100000  
        ;
            BlockScore = 0
        ),
        
        % Facteur 3 : Position centrale
        center_bonus(Col, CenterScore),
        
        % Score final = somme pondérée
        Score is BlockScore + CenterScore
    ).

would_win_next(B, Col, M) :-
    move(B, Col, M, B2),
    win(B2, M).



%.......................................
% extract_columns - Extrait les colonnes d'une liste (Score-Col)
%.......................................
extract_columns([], []).
extract_columns([_Score-Col|Rest], [Col|RestCols]) :-
    extract_columns(Rest, RestCols).



