:- begin_tests(connect4).

%:- consult('../project/projet.pl').

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
% Résultat attendu: ValidColumns = [1,2,3,4,5,6,7]
test(every_case_is_empty) :-
Board = [
  ['e','e','e','e','e','e'],
  ['e','e','e','e','e','e'],
  ['e','e','e','e','e','e'],
  ['e','e','e','e','e','e'],
  ['e','e','e','e','e','e'],
  ['e','e','e','e','e','e'],
  ['e','e','e','e','e','e']
],
moves(Board, Valid),
Valid == [1,2,3,4,5,6,7].

% TEST 2: Board complètement plein, aucune colonne valide
% Résultat attendu: ValidColumns = []
test(every_case_is_taken) :-
Board = [
  ['x','o','x','o','x','o'],
  ['o','x','o','x','o','x'],
  ['x','o','x','o','x','o'],
  ['o','x','o','x','o','x'],
  ['x','o','x','o','x','o'],
  ['o','x','o','x','o','x'],
  ['x','o','x','o','x','o']
],
moves(Board, Valid),
Valid == [].

% TEST 3: Certaines colonnes pleines, d’autres vides ou partiellement remplies
% Colonnes 3 et 7 pleines, colonne 6 presque pleine (1 case vide)
% Résultat attendu: ValidColumns = [1,2,4,5,6]
test(some_column_are_taken) :-
Board = [
  ['e','e','e','e','e','e'],   
  ['x','x','o','e','e','e'], 
  ['x','o','o','x','o','x'],    
  ['e','e','e','e','e','e'],   
  ['e','e','e','e','e','e'],  
  ['x','x','x','x','x','e'],    
  ['o','o','o','o','o','o']    
],
moves(Board, Valid),
Valid == [1,2,4,5,6].

% TEST 4: Board avec une seule colonne non pleine (colonne 6)
% Résultat attendu: ValidColumns = [6]
test(one_column_available) :-
Board = [
  ['x','x','x','x','x','x'],
  ['x','x','x','x','x','x'],
  ['x','x','x','x','x','x'],
  ['x','x','x','x','x','x'],
  ['x','x','x','x','x','x'],
  ['e','e','e','e','e','e'],
  ['x','x','x','x','x','x']
],
moves(Board, Valid),
Valid== [6].

% TEST 5: Colonnes alternées pleines et vides
% Colonnes 1,3,5,7 vides ; colonnes 2,4,6 pleines
% Résultat attendu: ValidColumns = [1,3,5,7]
test(alternate_column) :-
Board = [
  ['e','e','e','e','e','e'], 
  ['x','x','x','x','x','x'],    
  ['e','e','e','e','e','e'],   
  ['x','x','x','x','x','x'],   
  ['e','e','e','e','e','e'],  
  ['x','x','x','x','x','x'],  
  ['e','e','e','e','e','e']    
],
moves(Board, Valid),
Valid == [1,3,5,7].

%==========
% TEST display
%==========

% TEST 1: mappe le board pour le lire par lignes
test(board_mapping) :-
    
Board = [
  ['l','e','e','e','e','f'],
  ['a','e','e','e','e','i'],
  ['s','e','e','e','e','r'],
  ['t','e','e','e','e','s'],
  ['e','e','e','e','e','t'],
  ['l','e','e','e','e','e'],
  ['i','e','e','e','e','l']
],
swapBoard(Board, Valid),
Valid == [['f','i','r','s','t','e','l'],['e','e','e','e','e','e','e'],['e','e','e','e','e','e','e'],['e','e','e','e','e','e','e'],['e','e','e','e','e','e','e'],['l','a','s','t','e','l','i']].

%==========
% TEST ia
%==========

test(randomAI) :-
    
    Board = [
    ['e','e','e','e','e','e'], 
    ['x','x','x','x','x','x'],    
    ['e','e','e','e','e','e'],   
    ['x','x','x','x','x','x'],   
    ['e','e','e','e','e','e'],  
    ['x','x','x','x','x','x'],  
    ['e','e','e','e','e','e']    
    ],
    randomAI(Board, Move1),
    randomAI(Board, Move2),
    randomAI(Board, Move3),
    randomAI(Board, Move4),

    (Move1 == 1; Move1 == 3; Move1 == 5; Move1 == 7),
    (Move2 == 1; Move2 == 3; Move2 == 5; Move2 == 7),
    (Move3 == 1; Move3 == 3; Move3 == 5; Move3 == 7),
    (Move4 == 1; Move4 == 3; Move4 == 5; Move4 == 7).

test(blockWinning) :-
    
    EmptyBoard = [
    ['e','e','e','e','e','e'],
    ['e','e','e','e','e','e'],
    ['e','e','e','e','e','e'],
    ['e','e','e','e','e','e'],
    ['e','e','e','e','e','e'],
    ['e','e','e','e','e','e'],
    ['e','e','e','e','e','e']
    ],
    blockWining(EmptyBoard, 'x', Move1),
    (Move1 == 1; Move1 == 2; Move1 == 3; Move1 == 4; Move1 == 5; Move1 == 6; Move1 == 7),
    
    WinningBoard = [
    ['x','o','e','e','e','e'],
    ['x','x','e','e','e','e'],
    ['x','x','x','o','e','e'],
    ['o','x','o','e','e','e'],
    ['e','e','e','e','e','e'],
    ['e','e','e','e','e','e'],
    ['e','e','e','e','e','e']
    ],
    blockWining(WinningBoard, 'x', Move2),

    Move2 == 4,

    LoosingBoard = [
    ['x','o','e','e','e','e'],
    ['x','x','e','e','e','e'],
    ['x','x','x','o','e','e'],
    ['o','x','o','e','e','e'],
    ['e','e','e','e','e','e'],
    ['e','e','e','e','e','e'],
    ['e','e','e','e','e','e']
    ],
    blockWining(LoosingBoard, 'o', Move3),

    Move3 == 4.

%==========
% TEST move
%==========

test(move) :-
    
Board = [
  ['e','e','e','e','e','e'], 
  ['x','x','x','x','x','x'],    
  ['e','e','e','e','e','e'],   
  ['x','x','x','x','x','x'],   
  ['e','e','e','e','e','e'],  
  ['x','x','x','x','e','e'],  
  ['e','e','e','e','e','e']    
],
move(Board, 6, 'o', NewBoard1),
NewBoard1 == [
  ['e','e','e','e','e','e'], 
  ['x','x','x','x','x','x'],    
  ['e','e','e','e','e','e'],   
  ['x','x','x','x','x','x'],   
  ['e','e','e','e','e','e'],  
  ['x','x','x','x','o','e'],  
  ['e','e','e','e','e','e']    
].

% Test utility

% ============================================
% TEST 1: X gagne - devrait retourner 10000
% ============================================
test(utility_x_wins) :-
    Board = [
        ['x','x','x','x','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e']
    ],
    utility(Board, U),
    U == 10000.

% ============================================
% TEST 2: O gagne - devrait retourner -10000
% ============================================
test(utility_o_wins) :-
    Board = [
        ['o','e','e','e','e','e'],
        ['o','e','e','e','e','e'],
        ['o','e','e','e','e','e'],
        ['o','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e']
    ],
    utility(Board, U),
    U == -10000.

% ============================================
% TEST 3: Board vide - devrait retourner 0
% ============================================
test(utility_empty_board) :-
    Board = [
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e']
    ],
    utility(Board, U),
    U == 0.

% ============================================
% TEST 4: Board avec quelques pions - score positif pour X
% ============================================
test(utility_x_advantage) :-
    Board = [
        ['x','x','x','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e']
    ],
    utility(Board, U),
    U > 0.

% ============================================
% TEST 5: Board avec quelques pions - score négatif pour O
% ============================================
test(utility_o_advantage) :-
    Board = [
        ['o','o','o','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e'],
        ['e','e','e','e','e','e']
    ],
    utility(Board, U),
    U < 0.

:- end_tests(connect4).

%==========
% TEST display
%==========
