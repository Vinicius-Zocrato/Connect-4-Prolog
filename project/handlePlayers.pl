read_players :-
    nl,
    nl,
    write('Number of human players? '),
    read(N),
    set_players(N)
    .

set_AIType(Player, AIType):-
    retractall(maxdepth(_)),
    %retractall(player(Player,_)),
    allAI(AllAITypes),
    member(AIType,AllAITypes),
    ((AIType == random ; AIType == blockWinning); 
    write('What depth ?'), read(Depth)),
    asserta( maxdepth(AIType, Depth)),
    asserta( player(Player, AIType) ), !.


set_AIType(Player, AIType):-
    allAI(AllAITypes),
    not(member(AIType, AllAITypes)),
    write('What kind of AI should the computer'),write(Player), write(' use among '), write(AllAITypes), write('? '),
    read(NewAIType),
    set_AIType(Player, NewAIType).

set_players(0) :- 
    set_AIType(1,' '),
    set_AIType(2,' '), !.

set_players(1) :-
    nl,
    write('Is human playing X or O (X moves first)? '),
    read(M),
    human_playing(M), !
    .

set_players(2) :- 
    asserta( player(1, human) ),
    asserta( player(2, human) ), !
    .

set_players(_) :-
    nl,
    write('Please enter 0, 1, or 2.'),
    read_players
    .


human_playing(M) :- 
    (M = 'x' ; M = 'X'), !,
    asserta( player(1, human) ),
    set_AIType(2,' ').

human_playing(M) :- 
    (M = 'o' ; M = 'O'), !,
    asserta( player(2, human) ),
    set_AIType(1,' ')
    .

human_playing(_) :-
    nl,
    write('Please enter X or O.'),
    set_players(1)
    .
