:- begin_tests(connect4).

:- consult('../project/projet.pl').

%==========
% TEST win
%==========

% ============================================
% TEST 1: Victoire verticale
% ============================================
test(vertical_win) :-
    Board = [
        ['x','x','x','x','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e']
    ],
    win(Board, 'x').

% ============================================
% TEST 2: Pas de victoire (3 x)
% ============================================
test(no_vertical_win, [fail]) :-
    Board = [
        ['x','x','x','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e']
    ],
    win(Board, 'x').

% ============================================
% TEST 3: Victoire horizontale ligne 1
% ============================================
test(horizontal_bottom) :-
    Board = [
        ['o','e','e','e','e','e'],
        ['o','e','e','e','e','e'],
        ['o','e','e','e','e','e'],
        ['o','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e']
    ],
    win(Board, 'o').

% ============================================
% TEST 4: Victoire horizontale ligne 3
% ============================================
test(horizontal_mid) :-
    Board = [
        ['e','e','x','e','e','e'],
        ['e','e','x','e','e','e'],
        ['e','e','x','e','e','e'],
        ['e','e','x','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e']
    ],
    win(Board, 'x').

% ============================================
% TEST 5: Diagonale ↗
% ============================================
test(diagonal_up_right) :-
    Board = [
        ['x','e','e','e','e','e'],
        ['e','x','e','e','e','e'],
        ['e','e','x','e','e','e'],
        ['e','e','e','x','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e']
    ],
    win(Board, 'x').

% ============================================
% TEST 6: Diagonale ↘
% ============================================
test(diagonal_down_right) :-
    Board = [
        ['e','e','e','o','e','e'],
        ['e','e','o','e','e','e'],
        ['e','o','e','e','e','e'],
        ['o','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e']
    ],
    win(Board, 'o').

% ============================================
% TEST 7: Pas de victoire (board vide)
% ============================================
test(empty_board, [fail]) :-
    Board = [
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e']
    ],
    win(Board, 'x').

% ============================================
% TEST 8: 4 non consécutifs
% ============================================
test(non_consecutive, [fail]) :-
    Board = [
        ['x','e','e','e','e','e'],
        ['x','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['x','e','e','e','e','e'],
        ['x','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e']
    ],
    win(Board, 'x').

% ============================================
% TEST 9: >4 alignés
% ============================================
test(more_than_four) :-
    Board = [
        ['e','e','e','e','e','e'],
        ['x','x','x','x','x','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e']
    ],
    win(Board, 'x').

% ============================================
% TEST 10: horizontale colonnes 2–5
% ============================================
test(horizontal_2_to_5) :-
    Board = [
        ['e','e','e','e','e','e'],
        ['o','e','e','e','e','e'],
        ['o','e','e','e','e','e'],
        ['o','e','e','e','e','e'],
        ['o','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e']
    ],
    win(Board, 'o').

%==========
% TEST moves
%==========

% TEST 1: Board complètement vide, toutes les colonnes sont valides (1 à 7)

Board = [
  ['x','o','x','o','x','o'],
  ['o','x','o','x','o','x'],
  ['x','o','x','o','x','o'],
  ['o','x','o','x','o','x'],
  ['x','o','x','o','x','o'],
  ['o','x','o','x','o','x'],
  ['x','o','x','o','x','o']
],
moves(Board, Valid).

% TEST 2: Board complètement plein, aucune colonne valide
% Résultat attendu: ValidColumns = []
moves([
  ['x','o','x','o','x','o'],
  ['o','x','o','x','o','x'],
  ['x','o','x','o','x','o'],
  ['o','x','o','x','o','x'],
  ['x','o','x','o','x','o'],
  ['o','x','o','x','o','x'],
  ['x','o','x','o','x','o']
], ValidColumns), write(ValidColumns).

% TEST 3: Certaines colonnes pleines, d’autres vides ou partiellement remplies
% Colonnes 3 et 7 pleines, colonne 6 presque pleine (1 case vide)
% Résultat attendu: ValidColumns = [1,2,4,5,6]
moves([
  ['e','e','e','e','e','e'],    % colonne 1 vide
  ['x','x','o','e','e','e'],    % colonne 2 partiellement remplie
  ['x','o','o','x','o','x'],    % colonne 3 pleine
  ['e','e','e','e','e','e'],    % colonne 4 vide
  ['e','e','e','e','e','e'],    % colonne 5 vide
  ['x','x','x','x','x','e'],    % colonne 6 presque pleine
  ['o','o','o','o','o','o']     % colonne 7 pleine
], ValidColumns), write(ValidColumns).

% TEST 4: Board avec une seule colonne non pleine (colonne 6)
% Résultat attendu: ValidColumns = [6]
moves([
  ['x','x','x','x','x','x'],
  ['x','x','x','x','x','x'],
  ['x','x','x','x','x','x'],
  ['x','x','x','x','x','x'],
  ['x','x','x','x','x','x'],
  ['e','e','e','e','e','e'],
  ['x','x','x','x','x','x']
], ValidColumns), write(ValidColumns).

% TEST 5: Colonnes alternées pleines et vides
% Colonnes 1,3,5,7 vides ; colonnes 2,4,6 pleines
% Résultat attendu: ValidColumns = [1,3,5,7]
moves([
  ['e','e','e','e','e','e'],    % 1 vide
  ['x','x','x','x','x','x'],    % 2 pleine
  ['e','e','e','e','e','e'],    % 3 vide
  ['x','x','x','x','x','x'],    % 4 pleine
  ['e','e','e','e','e','e'],    % 5 vide
  ['x','x','x','x','x','x'],    % 6 pleine
  ['e','e','e','e','e','e']     % 7 vide
], ValidColumns), write(ValidColumns).

:- end_tests(connect4).
