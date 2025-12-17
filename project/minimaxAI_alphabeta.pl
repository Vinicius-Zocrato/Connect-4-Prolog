%.......................................
% minimax_ab
%.......................................
% The minimax_ab algorithm always assumes an optimal opponent.
% For tic-tac-toe, optimal play will always result in a tie, so the algorithm is effectively playing not-to-lose.
% For the opening move against an optimal player, the best_ab minimax_ab can ever hope for is a tie.
% So, technically speaking, any opening move is acceptable.
% Save the user the trouble of waiting  for the computer to search the entire minimax_ab tree 
% by simply selecting a random square.

minimax_ab(D, [
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

% minimax_ab avec alpha-beta
% D = profondeur, B = plateau, M = joueur, S = coup, U = utilité
% Alpha = meilleure valeur pour Max, Beta = meilleure valeur pour Min

minimax_ab(D, B, M, S, U, Alpha, Beta) :-
    maxdepth(MaxDepth),
    D < MaxDepth,              %%% limit the depth of the search to avoid long computation times
    moves(B, L),               %%% get the list of available moves
    L \= [],                   %%% if there are available moves,
    !,
    D2 is D + 1,
    %order_moves(B, M, L, OrderedL),  % ordre des mouvements pour optimisation
    best_ab(D2, B, M, OrderedL, S, U, Alpha, Beta)    %%% recursively determine the best_ab available move
    .

% if there are no more available moves, 
% then the minimax_ab value is the utility of the given board position

minimax_ab(D, B, M, S, U, Alpha, Beta) :-
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
% Implémentation de l'élagage alpha-beta

best_ab(D,B,M,[S1|T],S,U, Alpha, Beta) :-
    move(B,S1,M,B2),             %%% apply the first move (in the list) to the board,
    inverse_mark(M,M2), 
    minimax_ab(D,B2,M2,_S,U1, Alpha, Beta),      %%% recursively search for the utility value of that move,
    
    % algorithme alpha-beta
    (maximizing(M) ->
        % Nœud de type Max
        NewAlpha is max(Alpha, U1),
        (U1 >= Beta ->
            % Coupure beta : on retourne immédiatement
            S = S1,
            U = U1
        ;
            % Pas de coupure : on continue avec les autres mouvements
            best_ab(D,B,M,T,S2,U2, NewAlpha, Beta),
            better(D,M,S1,U1,S2,U2,S,U)
        )
    ;
        % Nœud de type Min
        NewBeta is min(Beta, U1),
        (U1 >= NewBeta ->
            % Coupure alpha : on retourne immédiatement
            S = S1,
            U = U1
        ;
            % Pas de coupure : on continue avec les autres mouvements
            best_ab(D,B,M,T,S2,U2, Alpha, NewBeta),
            better(D,M,S1,U1,S2,U2,S,U)
        )
    ), !
    .


%.......................................
% better
%.......................................
% returns the better of two moves based on their respective utility values.
%
% if both moves have the same utility value, then one is chosen at random.

better(D,M,S1,U1,S2,U2,     S,U) :-
    maximizing(M),                     %%% if the player is maximizing
    U1 > U2,                           %%% then greater is better.
    S = S1,
    U = U1,
    !
    .

better(D,M,S1,U1,S2,U2,     S,U) :-
    minimizing(M),                     %%% if the player is minimizing,
    U1 < U2,                           %%% then lesser is better.
    S = S1,
    U = U1, 
    !
    .

better(D,M,S1,U1,S2,U2,     S,U) :-
    U1 == U2,                          %%% if moves have equal utility,
    random_int_1n(10,R),               %%% then pick one of them at random
    better2(D,R,M,S1,U1,S2,U2,S,U),    
    !
    .

better(D,M,S1,U1,S2,U2,     S,U) :-        %%% otherwise, second move is better
    S = S2,
    U = U2,
    !
    .


%.......................................
% better2
%.......................................
% randomly selects two squares of the same utility value given a single probability
%

better2(D,R,M,S1,U1,S2,U2,  S,U) :-
    R < 6,
    S = S1,
    U = U1, 
    !
    .

better2(D,R,M,S1,U1,S2,U2,  S,U) :-
    S = S2,
    U = U2,
    !
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
% center_bonus - Bonus pour colonnes centrales
%.......................................
% Colonnes centrales (4) > près du centre (3,5) > bords (2,6) > coins (1,7)

center_bonus(4, 400) :- !.      % Colonne centrale
center_bonus(3, 300) :- !.      % Près du centre
center_bonus(5, 300) :- !.      % Près du centre
center_bonus(2, 100) :- !.      % Bords
center_bonus(6, 100) :- !.      % Bords
center_bonus(1, 0) :- !.        % Coins
center_bonus(7, 0) :- !.        % Coins
center_bonus(_, 0).             % Par défaut

%.......................................
% extract_columns - Extrait les colonnes d'une liste (Score-Col)
%.......................................
extract_columns([], []).
extract_columns([_Score-Col|Rest], [Col|RestCols]) :-
    extract_columns(Rest, RestCols).


%.......................................
% calculate_score - Évalue le potentiel d'une pièce
%.......................................
% Pour chaque pièce, on compte les alignements potentiels dans 4 directions
% Score = somme des alignements 'x' ou 'o' dans chaque direction

calculate_score(_, _, _, 'e', 0) :- !. 
% pièce vide = pas de score

calculate_score(B, Column, Row, Mark, Score) :-
    Mark \= 'e',  % seulement pour 'x' ou 'o'
    % 4 directions : horizontal, vertical, diag-down-right, diag-up-right
    score_direction(B, Column, Row, Mark, 0, 1, S1),      % horizontal
    score_direction(B, Column, Row, Mark, 1, 0, S2),      % vertical
    score_direction(B, Column, Row, Mark, 1, -1, S3),      % diag topleft-bottomright
    score_direction(B, Column, Row, Mark, 1, 1, S4),     % diag bottomleft-topright
    Score is S1 + S2 + S3 + S4
    .

%.......................................
% score_direction - Compte les alignements dans une direction
%.......................................
% DeltaCol, DeltaRow = direction (ex: 1,0 = horizontal)
% Retourne : score selon le nombre d'alignés

score_direction(B, Col, Row, Mark, DeltaCol, DeltaRow, Score) :-
    % Compte vers un sens (inclut la pièce actuelle)
    count_in_direction(B, Col, Row, Mark, DeltaCol, DeltaRow, Count1),
    % Compte vers l'autre sens (inverse)
    NegDeltaCol is -DeltaCol,
    NegDeltaRow is -DeltaRow,
    count_in_direction(B, Col, Row, Mark, NegDeltaCol, NegDeltaRow, Count2),
    % Total alignés (en retirant 1 car la pièce actuelle a été comptée 2 fois)
    Total is Count1 + Count2 - 1,
    score_from_count(Total, Score)
    .

%.......................................
% count_in_direction - Compte les pièces alignées dans une direction
%.......................................
% Retourne 1 + nombre de voisins identiques dans cette direction

count_in_direction(B, Col, Row, Mark, DeltaCol, DeltaRow, Count) :-
    NextCol is Col + DeltaCol,
    NextRow is Row + DeltaRow,
    % Vérifier les limites du board
    (NextCol >= 1, NextCol =< 7, NextRow >= 1, NextRow =< 6 ->
        get_item(B, NextCol, Column),
        get_item(Column, NextRow, V),
        (V == Mark ->
            % Pièce du même joueur : on continue et on compte
            count_in_direction(B, NextCol, NextRow, Mark, DeltaCol, DeltaRow, Count1),
            Count is Count1 + 1
        ;
            % Pièce adverse ou vide : on arrête (mais on compte la pièce actuelle)
            Count is 1
        )
    ;
        % Hors limites (mais on compte la pièce actuelle)
        Count is 1
    ).

%.......................................
% score_from_count - Convertit le nombre d'alignés en score
%.......................................

score_from_count(Total, Score) :-
    Total >= 4, !, Score is 10000.  % 4+ alignés = victoire !

score_from_count(Total, Score) :-
    Total = 3, !, Score is 1000.  % 3 alignés = MENACE CRITIQUE

score_from_count(Total, Score) :-
    Total = 2, !, Score is 100.   % 2 alignés = bon

score_from_count(Total, Score) :-
    Total = 1, !, Score is 10.    % 1 pièce isolée = faible

score_from_count(_, 0).              % 0 : impossible normalement

%.......................................
% utility - Évalue le plateau complet
%.......................................

utility(B, U) :-
    win(B, 'x'),
    U = 10000, !
    .

utility(B, U) :-
    win(B, 'o'),
    U = (-10000), !
    .

utility(B, U) :-
    % somme tous les scores du boad pour donner l'utility
    aggregate_all(sum(ScoreVal), 
        (between(1, 7, Col),
         between(1, 6, Row),
         get_item(B, Col, Column),
         get_item(Column, Row, V),
         calculate_score(B, Col, Row, V, S1),
         (V == 'x' -> ScoreVal = S1 ; V == 'o' -> ScoreVal = -S1 ; ScoreVal = 0)),
        U)
        . 

