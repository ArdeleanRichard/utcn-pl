%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 			LABORATORUL 10 EXEMPLE		%%%%%%
%%%%%%   			Side Effects  			%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%--------------------------------------------------
%--------------------------------------------------
% EFECTE LATERALE %
%--------------------------------------------------
%--------------------------------------------------

% Prima voastră întrebare cu efecte laterale:
% ?- assert(insect(ant)), assert(insect(bee)), (retract(insect(I)), writeln(I), retract(insect(II)), fail.


%--------------------------------------------------
% Predicatul FIBONACCI %
%--------------------------------------------------

:- dynamic memofib/2.

fib(N,F):-
	memofib(N,F),!.
	fib(N,F):- N>1,
	N1 is N-1,
	N2 is N-2,
	fib(N1,F1),
	fib(N2,F2),
	F is F1+F2,
	assertz(memofib(N,F)).
fib(0,1).
fib(1,1).


% Urmărește execuția la:
% ?- listing(memo_fib/2). % lists all definitions of the predicate memo_fib with 2 arguments
% ?- fib(4,F), listing(memo_fib/2).
% ?- fib(10,F), listing(memo_fib/2).



%--------------------------------------------------
% Predicatul PRINT FIBONNACI - Afișarea rezultatelor memorizate %
%--------------------------------------------------
print_all:-
	memofib(N,F),
	write(N),
	write(' - '),
	write(F),
	nl,
	fail.
print_all.

% Urmărește execuția la:
% ?-print_all.
% ?-retractall(memo_fib(_,_)).
% ?-print_all.


%--------------------------------------------------
% Colectarea rezultatelor memorizate %
%--------------------------------------------------

% Urmărește execuția la:
% ?- findall(X, append(X,_,[1,2,3,4]), List).
% ?- findall(lists(X,Y), append(X,Y,[1,2,3,4]), List).
% ?- findall(X, member(X,[1,2,3]), List).


%PERM
perm(L, [H|R]):-append(A, [H|T], L), append(A, T, L1), perm(L1, R).
perm([], []).

all_perm(L,_):-
	perm(L,L1),
	assertz(p(L1)),
	fail.
all_perm(_,R):-
	collect_perms(R).
	
collect_perms([L1|R]):-
	retract(p(L1)),
	!,
	collect_perms(R).
collect_perms([]).

% ?- all_perm([1,2,3],L).
% L=[[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]];
% no.


% Urmărește execuția la:
% ?- retractall(p(_)), all_perm([1,2],R), listing(p/1).
% ?- retractall(p(_)), all_perm([1,2,3],R), listing(p/1).




%--------------------------------------------------
% Failure driven loop vs recursion %
%--------------------------------------------------

:-dynamic p/1.

p(1).
p(2).
p(3).
p(4).
p(5).

% does not require the retract
failure_driven_loop1:-
    p(X),
    assert(q(X)),
    fail.
failure_driven_loop1:-listing(q/1).

% but can be implemented with it
failure_driven_loop2:-
    retract(p(X)),
    assert(q(X)),
    fail.
failure_driven_loop2:-listing(q/1).


% must make the retract, otherwise infinite loop
recursion1:-
    retract(p(X)),
    assert(q(X)),
    recursion1.
recursion1:-listing(q/1).


% to keep p/1 in knowledge base, requires additional predicate, highly inefficient
recursion2:-
    p(X),
	not(seen(X)),!,
	assert(seen(X)),
    assert(q(X)), % might be nonsensic here, simple case, yet when q/1 is a process, it is needed
    recursion2.
recursion2:-listing(q/1).


%--------------------------------------------------
% Univ predicate %
%--------------------------------------------------
% map(+Predicate, +List, -MappedList)
map(_, [], []).
map(Pred, [H|T], [H1|R]) :-
    P=..[Pred, H, H1],
    call(P), !,
    map(Pred, T, R).

double(X, Y) :- Y is X * 2.
halve(X, Y) :- Y is X / 2.
% ... add any function that you want

% Urmărește execuția la:
% ?- trace, map(double, [1, 2, 3], Result).
% Result = [2, 4, 6].



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 				EXERCIȚII				%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Arbori:
complete_tree(t(6, t(4,t(2,nil,nil),t(5,nil,nil)), t(9,t(7,nil,nil),nil))).
incomplete_tree(t(6, t(4,t(2,_,_),t(5,_,_)), t(9,t(7,_,_),_))).




%--------------------------------------------------
% 1. Generează toate descompunerile posibile a unei liste în doua sub-liste
% fără a folosi predicatul predefinit findall.
% ?- all_decompositions([1,2,3], List).
% List=[ [[], [1,2,3]], [[1], [2,3]], [[1,2], [3]], [[1,2,3], []] ] ;
% false


% all_decompositions(L, R):- % *IMPLEMENTAȚI AICI*





% 2. Filtrează elemente bazat pe o funcție dată (suggestie: predicatul univ).
% ?- filter(even, [1, 2, 3, 4], Result).
% Result = [2, 4].

% filter(Pred, L, R):- % *IMPLEMENTAȚI AICI*






% 3. Returnează true dacă oricare element satisface o funcție dată (suggestie: predicatul univ).
% ?- any(greater_than_three, [1, 2, 4]).
% true.

% any(Pred, L):- % *IMPLEMENTAȚI AICI*







% 4. Returnează true dacă toate elementele satisfac o funcție dată (suggestie: predicatul univ).
% ?- all(positive, [1, 2, 3]).
% true.

% all(Pred, L, R):- % *IMPLEMENTAȚI AICI*





% 5. Colectează (folosind retract-uri printr-un proces format din 2 pași) într-o listă diferență toate elementele pare ale unei liste incomplete date.
% ?- even_dl([1,2,3|_], S, E).
% S = [2|E]

% even_dl(T, _, _):- % *IMPLEMENTAȚI AICI*
% even_dl(_, S, E):- % *IMPLEMENTAȚI AICI*








% 6. Colectează (folosind retract-uri printr-un proces format din 2 pași) toate nodurile interne ale unui arbore binar incomplet.
% ?- incomplete_tree(T), internal_list(T, R).
% R = [7, 5|_].

% internal_list(T, _):- % *IMPLEMENTAȚI AICI*
% internal_list(_, R):- % *IMPLEMENTAȚI AICI*
