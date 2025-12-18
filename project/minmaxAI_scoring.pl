%.......................................
% minimax_scoring
%.......................................
% The minimax_scoring algorithm always assumes an optimal opponent.
% For tic-tac-toe, optimal play will always result in a tie, so the algorithm is effectively playing not-to-lose.
% For the opening move against an optimal player, the best minimax_scoring can ever hope for is a tie.
% So, technically speaking, any opening move is acceptable.
% Save the user the trouble of waiting  for the computer to search the entire minimax_scoring tree 
% by simply selecting a random square.

minimax_scoring(D, [
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


minimax_scoring(D, B, M, S, U) :-
    maxdepth(minimax_scoring, MaxDepth),
    D < MaxDepth,              %%% limit the depth of the search to avoid long computation times
    moves(B, L),               %%% get the list of available moves
    L \= [],                   %%% if there are available moves,
    !,
    D2 is D + 1,
    best(D2, B, M, L, S, U)    %%% recursively determine the best available move
    .

% if there are no more available moves, 
% then the minimax_scoring value is the utility of the given board position

minimax_scoring(D, B, M, S, U) :-
    utility(B, U),
    S = 0, !
    .


%.......................................
% best
%.......................................
% determines the best move in a given list of moves by recursively calling minimax_scoring
%

% if there is only one move left in the list...

best(D,B,M,[S1],S,U) :-
    move(B,S1,M,B2),        %%% apply that move to the board,
    inverse_mark(M,M2), !,   
    minimax_scoring(D, B2,M2,_S,U),  %%% then recursively search for the utility value of that move.
    S = S1, !
    %output_value(D,S,U),
    .

% if there is more than one move in the list...

best(D,B,M,[S1|T],S,U) :-
    move(B,S1,M,B2),             %%% apply the first move (in the list) to the board,
    inverse_mark(M,M2), !,
    minimax_scoring(D,B2,M2,_S,U1),      %%% recursively search for the utility value of that move,
    best(D,B,M,T,S2,U2),         %%% determine the best move of the remaining moves,
    %output_value(D,S1,U1),      
    better(D,M,S1,U1,S2,U2,S,U), !  %%% and choose the better of the two moves (based on their respective utility values)
    .


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



