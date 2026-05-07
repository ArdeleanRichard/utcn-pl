%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 			LABORATORY 10 EXAMPLES		%%%%%%
%%%%%%   				Side Effects  		%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%--------------------------------------------------
%--------------------------------------------------
% SIDE EFFECTS %
%--------------------------------------------------
%--------------------------------------------------

% Your first query with side effects:
% ?- assert(insect(ant)), assert(insect(bee)), retract(insect(A)), writeln(A), retract(insect(B)), fail.


:-dynamic p/1.

p(1).
p(2).
p(3).
p(4).
p(5).

example:- 
    retract(p(X)), 
    retract(p(Y)),
    format('q(~w, ~w).', [X, Y]), nl,
    fail.
example.

% Try to think what the predicate will print with format/2.
% ?- example.



%--------------------------------------------------
% The FIBONACCI predicate %
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


% Follow the execution of (run the queries sequentially):
% ?- fib(4,F), listing(memo_fib/2).
% ?- fib(10,F), listing(memo_fib/2).
% listing/1 - lists all clauses of the memo_fib predicate with 2 arguments



%--------------------------------------------------
% The PRINT FIBONACCI predicate - Printing memorised results %
%--------------------------------------------------
print_memo_fib:-
	memo_fib(N,F),
	format('memo_fib(~w, ~w).', [N, F]), nl,
	fail.
print_memo_fib.

% Follow the execution of:
% ?- fib(4,F), print_memo_fib.
% ?- fib(10,F), print_memo_fib.



%--------------------------------------------------
% Collecting memorised results %
%--------------------------------------------------

% Follow the execution of:
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


% Follow the execution of:
% ?- retractall(perm(_)), all_perm([1,2],R), listing(perm/1).
% ?- retractall(perm(_)), all_perm([1,2,3],R), listing(perm/1).




store_nr_btw(Low, High):-
    Low<High,
    assertz(nr(Low)),
    Low1 is Low+1,
    store_nr_btw(Low1, High).
store_nr_btw(High, High).

% Follow the execution of:
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

% does not require the retract
failure_driven_loop1:-
    p(X),
    assert(q(X)),
    fail.
failure_driven_loop1:- listing(q/1).

% but can be implemented with it
failure_driven_loop2:-
    retract(p(X)),
    assert(q(X)),
    fail.
failure_driven_loop2:- listing(q/1).


% must make the retract, otherwise infinite loop
recursion1:-
    retract(p(X)),
    assert(q(X)),
    recursion1.
recursion1:- listing(q/1).


% to keep p/1 in knowledge base, requires additional predicate, highly inefficient
recursion2:-
    p(X),
	not(seen(X)),!,
	assert(seen(X)),
    assert(q(X)), 		% might be nonsensic here, simple case, yet when q/1 is a process, it is needed
    recursion2.
recursion2:- listing(q/1).

% Follow the execution of:
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
% The issue with univ and SWISH %
%--------------------------------------------------
% Solution: Workaround
% We may use the call/n predicate that has the behaviour of both univ and call, 
% creating a predicate call with the first argument as the predicate, 
% whilst the rest become the arguments of said predicate and calling it. 

map(_, [], []).
map(Pred, [H|T], [H1|R]) :-
    call(Pred, H, H1), !,
    map1(Pred, T, R).


double(X, Y) :- Y is X * 2.
halve(X, Y) :- Y is X / 2.
% ... add any function that you want

% Follow the execution of:
% ?- trace, map(double, [1, 2, 3], Result).
% Result = [2, 4, 6].
% ?- trace, map(halve, [2, 4, 6], Result).
% Result = [1, 2, 3].




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 				EXERCISES				%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trees:
complete_tree(t(6, t(4,t(2,nil,nil),t(5,nil,nil)), t(9,t(7,nil,nil),nil))).
incomplete_tree(t(6, t(4,t(2,_,_),t(5,_,_)), t(9,t(7,_,_),_))).





%--------------------------------------------------
% 1. Generates a list with all the possible decompositions of a list into 2 lists,
% without using the built-in predicate findall.
% ?- all_decompositions([1,2,3], List).
% List=[ [[], [1,2,3]], [[1], [2,3]], [[1,2], [3]], [[1,2,3], []] ] ;
% false


% all_decompositions(L, R):- % *IMPLEMENTATION HERE*





% 2.	Computes the number of occurrences of unique elements in a list 
% and creates the list containing Element-Count pairs using assert and retract.
% ?- count_elements([a,b,a,b,c], R).
% R = [a-2, b-2, c-1]


% count_elements(L, R):- % *IMPLEMENTATION HERE*






% 3. Collects (using retracts through a 2-step process) in a difference list all even elements of a given incomplete list.
% ?- even_dl([1,2,3|_], S, E).
% S = [2|E]

% even_dl(T, _, _):- % *IMPLEMENTATION HERE*
% even_dl(_, S, E):- % *IMPLEMENTATION HERE*






% 4. Collects (using retracts through a 2-step process) all internal nodes of an incomplete binary tree.
% ?- incomplete_tree(T), internal_list(T, R).
% R = [7, 5|_].

% internal_list(T, _):- % *IMPLEMENTATION HERE*
% internal_list(_, R):- % *IMPLEMENTATION HERE*








% 5. Filters out elements based on a given function (suggestion: call/n predicate).
% ?- filter(odd, [1, 2, 3, 4], Result).
% Result = [1, 3].

% filter(Pred, L, R):- % *IMPLEMENTATION HERE*

% odd( ... ) :- % *IMPLEMENTATION HERE*







% 6. Returns true if any elements satisfies a given function (suggestion: call/n predicate).
% ?- any(greater_than_three, [1, 2, 4]).
% true.

% any(Pred, L):- % *IMPLEMENTATION HERE*

% greater_than_three( ... ) :- % *IMPLEMENTATION HERE*






% 7. Returns true if all elements satisfy a given function (suggestion: call/n predicate).
% ?- all(positive, [1, 2, 3]).
% true.

% all(Pred, L, R):- % *IMPLEMENTATION HERE*

% positive( ... ) :- % *IMPLEMENTATION HERE*
