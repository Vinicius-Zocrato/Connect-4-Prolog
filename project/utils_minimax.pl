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
    write('EQUAL Comparing U1 and U2 :'), write(U1), write(' vs '), write(U2), nl
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