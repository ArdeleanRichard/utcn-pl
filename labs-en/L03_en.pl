%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 			LABORATORY 3 EXAMPLES		%%%%%%
%%%%%% 			Operations on Lists			%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ?- [H|T]=[].
% ?- [H|T]=[1,2,3], X=3, L=[X|T].

%--------------------------------------------------
% The MEMBER predicate %
%--------------------------------------------------
member1(X, [X|_]).
member1(X, [_|T]) :- member1(X, T).


% Follow the execution of:
% ?- trace, member1(3,[1,2,3,4]).
% ?- trace, member1(a,[a, b, c, a]).
% ?- trace, X=a, member1(X, [a, b, c, a]).
% ?- trace, member1(a, [1,2,3]).


%--------------------------------------------------
% The APPEND predicate %
%--------------------------------------------------
append1([], L, L).
append1([H|T], L, [H|R]) :- append1(T, L, R).

% Follow the execution of:
% ?- trace, append1([a,b],[c,d],R).
% ?- trace, append1([1, [2]], [3|[4, 5]], R).
% ?- trace, append1(T, L, [1, 2, 3, 4, 5]).
% ?- trace, append1(_, [X|_], [1, 2, 3, 4, 5]).


%--------------------------------------------------
% The DELETE predicate %
%--------------------------------------------------
% delete first occurrence and stop
% otherwise iterate over list elements
% if it reaches empty list (second argument) means that the element was
% not found and we can return an empty list (third argument)
delete1(X, [X|T], T).
delete1(X, [H|T], [H|R]) :- delete1(X, T, R).
delete1(_, [], []).

% Follow the execution of:
% ?- trace, delete1(3, [1, 2, 3, 4], R).
% ?- trace, X=3, delete1(X, [3, 4, 3, 2, 1, 3], R).
% ?- trace, delete1(3, [1, 2, 4], R).
% ?- trace, delete1(X, [1, 2, 4], R).


%--------------------------------------------------
% The DELETE ALL predicate %
%--------------------------------------------------
% if the first occurence was deleted, it continues on the rest of the elements
delete_all(X, [X|T], R) :- delete_all(X, T, R).
delete_all(X, [H|T], [H|R]) :- delete_all(X, T, R).
delete_all(_, [], []).


% Follow the execution of:
% ?- trace, delete_all(3, [1, 2, 3, 4], R).
% ?- trace, X=3, delete_all(X, [3, 4, 3, 2, 1, 3], R).
% ?- trace, delete_all(3, [1, 2, 4], R).
% ?- trace, delete_all(X, [1, 2, 4], R).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 				EXERCISES				%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------
% 1. Write the add_first/3 predicate that adds X at the beginning of list L and inserts the resulting list in R.
% Suggestion: simplify it as much as possible.
% ?- add_first(1,[2,3,4],R).
% R=[1,2,3,4].

% add_first(X,L,R). – adds X at the beginning of list L and returns result in R

% add_first(X, L, R):-  % *IMPLEMENTATION HERE*


%--------------------------------------------------
% 2. Write the append3/4 predicate that concatenates 3 lists.
% Suggestion: Do not use the append of 2 lists.
% ?- append3([1,2],[3,4,5],[6,7],R).
% R=[1,2,3,4,5,6,7] ;
% false.


% append3(L1,L2,L3,R). – concatenates lists L1,L2,L3 into R

% append3(L1,L2,L3,R):-  % *IMPLEMENTATION HERE*



%--------------------------------------------------
% 3. Write a predicate that calculates the sum of all elements in a given list.
% ?- sum_bwd([1,2,3,4], S).
% R=10.
% ?- sum_fwd([1,2,3,4], S).
% R=10.

% sum(L, S). – computes the sum of all elements of L and returns the sum in S

% sum_bwd(L, S):-  % *IMPLEMENTATION HERE*

% sum_fwd(L, S):-  % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 4. Write a predicate that separates the even numbers from the odd ones.
% (Question: what do you need for forwards recursion?)
% ?- separate_parity([1, 2, 3, 4, 5, 6], E, O).
% E = [2, 4, 6]
% O = [1, 3, 5] ;
% false


% separate_parity(L, E, O):-  % *IMPLEMENTATION HERE*



%--------------------------------------------------
% 5. Write a predicate that removes all duplicate elements of a given list.
% ?- remove_duplicates([3, 4, 5, 3, 2, 4], R).
% R = [3, 4, 5, 2] ; % keep the first occurrence
% false
% OR
% ?- remove_duplicates([3, 4, 5, 3, 2, 4], R).
% R = [5, 3, 2, 4] ; % keep the last occurrence
% false


% remove_duplicates(L, R):-  % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 6. Write a predicate that replaces all apparitions of X in list L with Y and inserts the resulting list into R.
% ?- replace_all(1, a, [1, 2, 3, 1, 2], R).
% R = [a, 2, 3, a, 2] ;
% false


% replace_all(X, Y, L, R):-  % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 7. Write a predicate that removes the elements at positions divisible by k from the input list.
% ?- drop_k([1, 2, 3, 4, 5, 6, 7, 8], 3, R).
% R = [1, 2, 4, 5, 7, 8] ;
% false


% drop_k(L, K, R):-  % *IMPLEMENTATION HERE*





%--------------------------------------------------
% 8. Write a predicate that removes consecutive duplicates without modifying the order of the list elements.
% Suggestion: search for the note about the extended template in Laboratory 1.
% ?- remove_consecutive_duplicates([1,1,1,1, 2,2,2, 3,3, 1,1, 4, 2], R).
% R = [1,2,3,1,4,2] ;
% false


% remove_consecutive_duplicates(L, R):-  % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 9. Write a predicate that packs consecutive duplicates in a sub-list without modifying the order of the list elements.
% ?- pack_consecutive_duplicates([1,1,1,1, 2,2,2, 3,3, 1,1, 4, 2], R).
% R = [[1,1,1,1], [2,2,2], [3,3], [1,1], [4], [2]];
% false


% pack_consecutive_duplicates(L, R):-  % *IMPLEMENTATION HERE*





