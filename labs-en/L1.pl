%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 			LABORATORY 1 EXAMPLES		%%%%%%
%%%%%% 			Introduction to Prolog		%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------
% Examples of FACTS %
%--------------------------------------------------
we_are_in_classroom_108.
height(girafa, 5.5). % height in metres
tree( t(1, t(-2, nil, nil), t(8,nil,nil)) ).

animal(elephant).
animal('Gnu antilope').

eat(human, fruits).
eat(human, meat).
eat(human, nuts).

% Queries %
% ?- we_are_in_classroom_108.
% true.

% ?- animal(’Gnu antilope’).
% true.

% ?- animal(X).
% X = elephant; % repeat query with ; or n or space
% X = ’Gnu antilope’;
% false. % there are no other animals defined in the program


% Test the following query by yourself, which can be translated to 'What does a human eat?':
% ?-eats(human, X).



%--------------------------------------------------
% Examples of RULES %
%--------------------------------------------------
human(socrates). % human/1 fact

mortal(X):- human(X).


% first we take the height of X, then we take the height of Y
% and finally we compare the heights through the inequality
taller(X,Y) :- height(X,Hx), height(Y,Hy), Hx>Hy.


% the path between nodes X and Y can be a direct connection between
% the 2 nodes OR if no direct connection exists, we search for a
% indirect connection through an intermediary node

path(X,Y) :- edge(X,Y).
path(X,Y) :- edge(X,Intermediary), path(Intermediary,Y).






%--------------------------------------------------
% Examples of BACKTRACKING %
%--------------------------------------------------
% hold_party/1 is a rule that depends upon the successful execution
% of the birthday/1 and happy/1 facts
hold_party(X):-
 birthday(X),
 happy(X).

% a series of birthday/1 and happy/1 facts
birthday(alex).
birthday(maria).
birthday(adriana).
happy(ana).
happy(george).
happy(adriana).

% Queries %
% Follow these queries:
% ?- hold_party(X).


%--------------------------------------------------
% Examples of RECURSION %
%--------------------------------------------------
% the recursive on_route/1 predicate
on_route(rome).
on_route(Place):-
	move(Place,_,NewPlace), % move(Place,Method,NewPlace) - 'Method' was replaced with _ to avoid 'singleton variable' warning
	on_route(NewPlace).

% the move/3 predicate which has 3 facts
move(home,taxi,halifax).
move(halifax,train,gatwick).
move(gatwick,plane,rome).


% Queries %
% Follow these queries:
% ?- on_route(acasa).







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 				EXERCISES				%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Write new predicates for the kinship relations

% The woman/1 predicate – remember /x specifies the arity as ‚x’
woman(ana).
woman(sara).
woman(ema).
woman(maria). 
% … add the remaining facts of this predicate


% The man/1 predicate
man(andrei).
man(george).
man(alex). 
% … add the remaining facts of this predicate


% The parent/2 predicate
parent(maria, ana). % maria is the parent of ana
parent(george, ana). % george is the parent of ana
parent(maria, andrei).
parent(george, andrei). 
% … add the remaining facts of this predicate



% 1.1. Test the following queries:
% Is george a man?
% ?- man(george). 
% X = andrei ? ;	% we can repeat the question using ; or n or space
% X = george ? ;
% X = alex.

% Who is a man?
% ?- man(X). 

% Who are the parents of andrei?
% ?- parent(X, andrei). 
% X = maria ? ;
% X = george.


% The mother/2 predicate – based on the parent and woman predicates
% X is the mother of Y, if X is a woman and X is the parent of Y
mother(X,Y):-woman(X), parent(X,Y).

% Who are the children of ana?
% ?- mother(ana, X). 

% Who is the mother of ana?
% ?- mother(X, ana). 


%--------------------------------------------------
% 1.2. Write the father/2 predicate.
% father(X,Y):-



%--------------------------------------------------
% 1.3. Complete the man/1, woman/1 and parent/2 predicates to cover the whole genealogic tree from above. 



%--------------------------------------------------
% 1.4. Test the following queries:
% ?- father(alex, X).
% ?- father(X, Y).
% ?- mother(dorina, maria).


%--------------------------------------------------
% 1.5. Test the following predicates:

% The sibling/2 predicate
% X and Y are siblings if they have at least one parent in common
% and X is different from Y
sibling(X,Y) :- parent(Z,X), parent(Z,Y), X\=Y.

% The sister/2 predicate
% X is the sister of Y if X is a woman and X and Y are siblings
sister(X,Y) :- sibling(X,Y), woman(X).

% The aunt/2 predicate
% X is the aunt of Y if she(X) is the sister of Z and Z is the parent of Y
aunt(X,Y) :- sister(X,Z), parent(Z,Y).


%--------------------------------------------------
% 1.6. Write the brother/2, uncle/2, grandmother/2 and grandfather/2 predicates.

% brother(X,Y):- % *IMPLEMENTATION HERE*

% uncle(X,Y):- % *IMPLEMENTATION HERE*

% grandmother(X,Y):- % *IMPLEMENTATION HERE*
 
% grandfather(X,Y):- % *IMPLEMENTATION HERE*



%--------------------------------------------------
% 1.7. Follow the steps of finding the answer of the following queries (through the use of trace):
% ?- aunt(carmen, X).
% ?- grandmother(dorina, Y).
% ?- grandfather(X, ana).



%--------------------------------------------------
% 1.8. Write the ancestor/2 predicate. X is the ancestor of Y if X is linked to Y through a series (regardless of number) of parent relationships.

% ancestor(X, Y% *IMPLEMENTATION HERE*


