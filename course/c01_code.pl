man(john).
.
.
.
parent(john,david).
parent(john,edward).
.
.
.

father(X,Y):-
	man(X),
	parent(X,Y).

% ?- father(john, Z).


append1([],L,L).
append1([H|T],L,[H|R]):-
	append1(T,L,R).
