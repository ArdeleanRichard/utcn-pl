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
% ?- assert(insect(ant)), assert(insect(bee)), retract(insect(A)), writeln(A), retract(insect(B)), fail.


:-dynamic a/1.

a(1).
a(2).
a(3).
a(4).
a(5).

example:- 
    retract(a(X)), 
    retract(a(Y)),
    format('q(~w, ~w).', [X, Y]), nl,
    fail.
example.

% Incercati sa va ganditi la ce ar printa predicatul cu format/2.
% ?- example.

%--------------------------------------------------
% Predicatul FIBONACCI %
%--------------------------------------------------

:- dynamic memo_fib/2.

fib(N,F):- memo_fib(N,F), !.
fib(N,F):- 
    N>1, 
    N1 is N-1, 
    N2 is N-2, 
    fib(N1,F1),
    fib(N2,F2),
    F is F1+F2,
    assertz(memo_fib(N,F)).
fib(0,1).
fib(1,1).


% Urmărește execuția la:
% ?- fib(4,F), listing(memo_fib/2).
% ?- fib(10,F), listing(memo_fib/2).
% listing/1 - afișează toate clauzele predicatului memo_fib cu 2 argumente


%--------------------------------------------------
% Predicatul PRINT FIBONNACI - Afișarea rezultatelor memorizate %
%--------------------------------------------------
print_memo_fib:-
	memo_fib(N,F),
	format('memo_fib(~w, ~w).', [N, F]), nl,
	fail.
print_memo_fib.

% Urmărește execuția la:
% ?- fib(4,F), print_memo_fib.
% ?- fib(10,F), print_memo_fib.


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
	assertz(perm(L1)),
	fail.
all_perm(_,R):-
	collect_perms(R).
	
collect_perms([L1|R]):-
	retract(perm(L1)),
	!,
	collect_perms(R).
collect_perms([]).


% ?- all_perm([1,2,3],L).
% L=[[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]];
% no.


% Urmărește execuția la:
% ?- retractall(perm(_)), all_perm([1,2],R), listing(perm/1).
% ?- retractall(perm(_)), all_perm([1,2,3],R), listing(perm/1).




store_nr_btw(Low, High):-
    Low<High,
    assertz(nr(Low)),
    Low1 is Low+1,
    store_nr_btw(Low1, High).
store_nr_btw(High, High).

% Urmărește execuția la:
% ?- store_nr_btw(0, 2), listing(nr/1), store_nr_btw(0, 3), listing(nr/1).
% ?- store_nr_btw(0, 2), listing(nr/1), retract_all(nr(_)), store_nr_btw(0, 3), listing(nr/1).




%--------------------------------------------------
% Failure driven loop vs recursion %
%--------------------------------------------------

:-dynamic p/1.

p(1).
p(2).
p(3).
p(4).
p(5).

% nu necesită retract
failure_driven_loop1:-
    p(X),
    assert(q(X)),
    fail.
failure_driven_loop1:- listing(p/1), listing(q/1).

% dar se poate implementa cu
failure_driven_loop2:-
    retract(p(X)),
    assert(q(X)),
    fail.
failure_driven_loop2:- listing(p/1), listing(q/1).


% retract este obligatoriu, 
% altfel buclă infinită
recursion1:-
    retract(p(X)),
    assert(q(X)),
    recursion1.
recursion1:- listing(p/1), listing(q/1).


% pentru a păstra p/1 
% în baza de predicate, 
% necesită un predicat adițional, 
% este foarte ineficient
recursion2:-
    p(X),
	not(seen(X)),!,
	assert(seen(X)),
    assert(q(X)), 				% se poate să pară non-sensic, este un caz simplu, dar când q/1 este un proces, este necesar
    recursion2.
recursion2:- listing(p/1), listing(q/1), listing(seen/1).


% Urmărește execuția la:
% ?- trace, failure_driven_loop1.
% ?- trace, failure_driven_loop2.
% ?- trace, recursion1.
% ?- trace, recursion2.


%--------------------------------------------------
% Univ predicate ..= %
%--------------------------------------------------

% ?- X=..[a,b,c,d].
% X=a(b,c,d)
% 
% ?- X=..[member,a,[b,c]].
% X=member(a,[b,c]).
%
% ?- f(a,b,c)=..X. 
% X=[f,a,b,c].
%
% ?- append([H|T],L,[H|R])=..X.
% X=[append,[H|T],L,[H|R]].



% map(+Predicate, +List, -MappedList)
% map(_, [], []).
% map(Pred, [H|T], [H1|R]) :-
%    P=..[Pred, H, H1],
%    call(P), !,
%    map(Pred, T, R).


%--------------------------------------------------
% Problema cu univ și SWISH %
%--------------------------------------------------
% Soluția: Artificiu
% Putem folosi predicatul call/n care are comportamentul lui univ și call simultan, 
% creează un apel de predicat cu primul argument ca și predicat, 
% iar restul devin argumentele acestui predicat și apelează. 

map(_, [], []).
map(Pred, [H|T], [H1|R]) :-
    call(Pred, H, H1), !,
    map(Pred, T, R).

double(X, Y) :- Y is X * 2.
halve(X, Y) :- Y is X / 2.
% ... add any function that you want

% Urmărește execuția la:
% ?- trace, map(double, [1, 2, 3], Result).
% Result = [2, 4, 6].
% ?- trace, map(halve, [2, 4, 6], Result).
% Result = [1, 2, 3].




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 				EXERCIȚII				%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Arbori:
incomplete_tree(t(7, t(5, t(3, _, _), t(6, _, _)), t(11, _, _))). 
complete_tree(t(7, t(5, t(3, nil, nil), t(6, nil, nil)), t(11, nil, nil))). 




%--------------------------------------------------
% 1. Generează toate descompunerile posibile a unei liste în doua sub-liste
% fără a folosi predicatul predefinit findall.
% ?- all_decompositions([1,2,3], List).
% List=[ [[], [1,2,3]], [[1], [2,3]], [[1,2], [3]], [[1,2,3], []] ] ;
% false


% all_decompositions(L, R):- % *IMPLEMENTAȚI AICI*




% 2. Calculează numărul de apariții al elementelor unice dintr-o listă și 
% creează lista care contine perechi Element-Număr folosind assert și retract.
% ?- count_elements([a,b,a,b,c], R).
% R = [a-2, b-2, c-1]


% count_elements(L, R):- % *IMPLEMENTAȚI AICI*






% 3. Colectează (folosind retract-uri printr-un proces format din 2 pași) într-o listă diferență toate elementele pare ale unei liste incomplete date.
% ?- even_dl([1,2,3|_], S, E).
% S = [2|E]

% even_dl(T, _, _):- % *IMPLEMENTAȚI AICI*
% even_dl(_, S, E):- % *IMPLEMENTAȚI AICI*








% 4. Colectează (folosind retract-uri printr-un proces format din 2 pași) toate nodurile interne ale unui arbore binar incomplet.
% ?- incomplete_tree(T), internal_list(T, R).
% R = [7, 5|_].

% internal_list(T, _):- % *IMPLEMENTAȚI AICI*
% internal_list(_, R):- % *IMPLEMENTAȚI AICI*









% 5. Filtrează elemente bazat pe o funcție dată (suggestie: predicatul call/n).
% ?- filter(odd, [1, 2, 3, 4], Result).
% Result = [1, 3].

% filter(Pred, L, R):- % *IMPLEMENTAȚI AICI*

% odd( ... ) :- % *IMPLEMENTAȚI AICI*







% 6. Returnează true dacă oricare element satisface o funcție dată (suggestie: predicatul call/n).
% ?- any(greater_than_three, [1, 2, 4]).
% true.

% any(Pred, L):- % *IMPLEMENTAȚI AICI*

% greater_than_three( ... ) :- % *IMPLEMENTAȚI AICI*






% 7. Returnează true dacă toate elementele satisfac o funcție dată (suggestie: predicatul call/n).
% ?- all(positive, [1, 2, 3]).
% true.

% all(Pred, L, R):- % *IMPLEMENTAȚI AICI*

% positive( ... ) :- % *IMPLEMENTAȚI AICI*
