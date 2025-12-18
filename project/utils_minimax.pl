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
    write('MAXIMIZING Comparing U1 and U2 :'), write(U1), write(' vs '), write(U2), nl,
    !
    .

better(D,M,S1,U1,S2,U2,     S,U) :-
    minimizing(M),                     %%% if the player is minimizing,
    U1 < U2,                           %%% then lesser is better.
    S = S1,
    U = U1, 
    write('MINIMIZING Comparing U1 and U2 :'), write(U1), write(' vs '), write(U2), nl,
    !
    .

better(D,M,S1,U1,S2,U2,     S,U) :-
    U1 == U2,                          %%% if moves have equal utility,
    random_int_1n(10,R),               %%% then pick one of them at random
    better2(D,R,M,S1,U1,S2,U2,S,U),    
    write('EQUAL Comparing U1 and U2 :'), write(U1), write(' vs '), write(U2), nl,
    !
    .
   
better(D,M,S1,U1,S2,U2,     S,U) :-        %%% otherwise, second move is better
    S = S2,
    U = U2,
    write('OTHERWISE Comparing U1 and U2 :'), write(U1), write(' vs '), write(U2), nl,
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
    Total >= 4, !, Score is 100000.  % 4+ alignés = VICTOIRE !

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
    U = 100000, !
    .

utility(B, U) :-
    win(B, 'o'),
    U = (-100000), !
    .
    
utility(B, U) :-
    U = 0, !
        . 

utility(B, U) :-
    % somme tous les scores du board pour donner l'utility
    aggregate_all(sum(ScoreVal), 
        (between(1, 7, Col),
         between(1, 6, Row),
         get_item(B, Col, Column),
         get_item(Column, Row, V),
         calculate_score(B, Col, Row, V, S1),
         center_bonus(Col, CenterBonus),
         % Ajouter le bonus de position centrale à chaque pièce
         (V == 'x' -> ScoreVal is S1 + CenterBonus ; 
          V == 'o' -> ScoreVal is -(S1 + CenterBonus) ; 
          ScoreVal = 0)),
        U)
        . 