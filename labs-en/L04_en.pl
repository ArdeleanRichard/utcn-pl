%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 			LABORATORY 4 EXAMPLES		%%%%%%
%%%%%% 				The Cut					%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------
% The MEMBER predicate %
%--------------------------------------------------
member1(X, [X|_]) :- !.
member1(X, [_|T]) :- member1(X, T).


% Follow the execution of the following:
% ?- trace, member1(X,[1,2,3])
% ?- trace, X=3, member1(X, [3, 2, 4, 3, 1, 3]).
% ?- trace, member1(X, [3, 2, 4, 3, 1, 3]).


%--------------------------------------------------
% The DELETE predicate %
%--------------------------------------------------
delete1(X, [X|T], T) :- !.
delete1(X, [H|T], [H|R]) :- delete1(X, T, R).
delete1(_, [], []).


% Follow the execution of the following:
% ?- trace, delete1(3,[4,3,2,3,1], R).
% ?- trace, delete1(X, [3, 2, 4, 3, 1, 3], R).


%--------------------------------------------------
% The LENGTH predicate %
%--------------------------------------------------
% Variant 1 (backwards recursion)
len_bw([], 0).
len_bw([_|T], Len) :- len_bw(T, Lcoada), Len is 1+Lcoada.


% Variant 2 (forward recursion –> accumulator = second argument)
len_fw([], Len, Len).
len_fw([_|T], Acc, Len) :- Acc1 is Acc + 1, len_fw(T, Acc1, Len).

% len_fw/2 = wrapper of the len_fw/3 predicate that uses an accumulator
len_fw(L, R) :- len_fw(L, 0, R).


% Follow the execution of:
% ?- trace, len_bw([a, b, c, d], Len).
% ?- trace, len_bw([1, [2], [3|[4]]], Len).
% ?- trace, len_fw([a, b, c, d], 0, Res).
% ?- trace, len_fw([a, b, c, d], Len).
% ?- trace, len_fw([1, [2], [3|[4]]], Len).
% ?- trace, len_fw([a, b, c, d], 3, Len).




%--------------------------------------------------
% The REVERSE predicate %
%--------------------------------------------------
% Variant 1 (backward recursion)
rev_bw([], []).
rev_bw([H|T], R) :- rev_bw(T, Rtail), append1(Rtail, [H], R).

append1([], R, R).
append1([H|T], L, [H|R]) :- append1(T, L, R).



% Variant 2 (forward recursion –> accumulator = second argument)
rev_fw([], R, R).
rev_fw([H|T], Acc, R) :- Acc1=[H|Acc], rev_fw(T, Acc1, R).

% rev_fw/2 = wrapper of the rev_fw/3 predicate that uses an accumulator.
rev_fw(L, R) :- rev_fw(L, [], R).

% In contrast to the accumulators used until now, here we have
% operations with lists, we will instantiate it with an empty list.



% Follow the execution of:
% ?- trace, rev_bw([a, b, c, d], R).
% ?- trace, rev_bw([1, [2], [3|[4]]], R).
% ?- trace, rev_fw([a, b, c, d], R).
% ?- trace, rev_fw([1, [2], [3|[4]]], R).
% ?- trace, rev_fw([a, b, c, d], [1, 2], R).




%--------------------------------------------------
% The MIN predicate %
%--------------------------------------------------

% Variant 1 (forward recursion –> accumulator = second argument)
min_fw([], Mp, M) :- M=Mp.
min_fw([H|T], Mp, M) :- H<Mp, !, min_fw(T, H, M).
min_fw([_|T], Mp, M) :- min_fw(T, Mp, M).

% In a similar fashion, min_fw/2 is a wrapper.
min_fw([H|T], M) :- min_fw(T, H, M).

% In contrast to the accumulators used until now, for the min_fw/3 predicate,
% the accumulator (2nd argument) will be initialized with the first element


% Variant 2 (backward recursion)
min_bw([H|T], M) :- min_bw(T, M), H>M, !.
min_bw([H|_], H).


% Follow the execution of:
% ?- trace, min_fw([], M).
% ?- trace, min_fw([3, 2, 6, 1, 4, 1, 5], M).
% ?- trace, min_bw([], M).
% ?- trace, min_bw([3, 2, 6, 1, 4, 1, 5], M).




%--------------------------------------------------
% The SET OPERATIONS  %
%--------------------------------------------------
% Through the use of the member/2 predicate and recursion, 
% we check each element (H) of list L1, if it already is an element of L2:
% 	if it is -> we do not add it to the result R.
% 	Otherwise, we add it to R.

union([], L, L).
union([H|T], L2, R) :- member(H, L2), !, union(T, L2, R).
union([H|T], L2, [H|R]) :- union(T, L2, R).



% Follow the execution of:
% ?- trace, union([1,2,3], [4,5,6], R).
% ?- trace, union([1,2,5], [2,3], R).
% ?- trace, union(L1,[2,3,4],[1,2,3,4,5]).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 				EXERCISES				%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------
% 1. Write the intersect(L1, L2, R) predicate that achieves the intersection of 2 sets.
% Suggestion: Think of how the union predicate was implemented.
% Remember - take only the elements that appear in both lists.
% ?- intersect([1,2,3], [1,3,4], R).
% R = [1, 3] ;
% false


% intersect(L1, L2, R):-  % *IMPLEMENTATION HERE*



%--------------------------------------------------
% 2. Write the diff(L1, L2, R) predicate that achieves the difference of 2 sets (elements that appear in the first set but not in the second set).
% Suggestion: Think of how the union and intersection predicates are implemented. 
% Remember – take only the elements of the first list that do not appear in the second.
% ?- diff([1,2,3], [1,3,4], R).
% R = [2] ;
% false


% diff(L1, L2, R):-  % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 3. Write the del_min(L,R) and del_max(L,R) predicates that delete all
% occurrences of the minimum and maximum of list L, respectively.
% ?- del_min([1,3,1,2,1], R).
% R = [3, 2] ;
% false
% ?- del_max([3,1,3,2,3], R).
% R = [1, 2] ;
% false

delete_all(X, [X|T], R) :- delete_all(X, T, R).
delete_all(X, [H|T], [H|R]) :- delete_all(X, T, R).
delete_all(_, [], []).

% del_min(L, R):-  % *IMPLEMENTATION HERE*


% del_max(L, R):-  % *IMPLEMENTATION HERE*





%--------------------------------------------------
% Hard exercise: Try to implement each of these predicates using a single traversal of the list (del_min1/2 and del_max1/2).


% del_min1(L, R):-  % *IMPLEMENTATION HERE*


% del_max1(L, R):-  % *IMPLEMENTATION HERE*





%--------------------------------------------------
% 4. Write a predicate that reverses the order of the elements of a list starting from the K-th element.
% ?- reverse_k([1, 2, 3, 4, 5], 2, R).
% R = [1, 2, 5, 4, 3] ;
% false





%--------------------------------------------------
% 5. Write a predicate that encodes the elements of a list using the RLE (Runlength encoding) algorithm. A sequence of equal and consecutive
% elements will be replaced with the [element, number of occurrences]
% pair.
% ?- rle_encode([1, 1, 1, 2, 3, 3, 1, 1], R).
% R = [[1, 3], [2, 1], [3, 2], [1, 2]] ;
% false


% rle_encode(L, R):-  % *IMPLEMENTATION HERE*





%--------------------------------------------------
% Optional. Can you modify this predicate such that if the element is singular (has
% no consecutive equal values), it keeps that element instead of adding the pair?
% ?- rle_encode1([1, 1, 1, 2, 3, 3, 1, 1], R).
% R = [[1, 3], 2, [3, 2], [1, 2]] ;
% false


% rle_encode1(L, R):-  % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 6. Write a predicate that rotates a list by K positions to the right.
% Suggestion: try rotate_left first, it is much easier to implement
% ?- rotate_right([1, 2, 3, 4, 5, 6], 2, R).
% R = [5, 6, 1, 2, 3, 4] ;
% false


% rotate_right(L, K, R):-  % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 7. Write a predicate that extracts K elements of list L randomly and inserts them into R.
% Suggestion: use the random_between/3(min_value, max_value, result) built-in predicate.
% ?- rnd_select([a, b, c, d, e, f, g, h], 3, R).
% R = [e, d, a] ;
% false


% rnd_select(L, K, R):-  % *IMPLEMENTATION HERE*



%--------------------------------------------------
% 8. Write a predicate that decodes the elements of a list using the RLE (Runlength encoding) algorithm. An [element, number of occurrences] pair
% will be replaced with the sequence of equal and consecutive elements.
% ?- rle_decode([[1, 3], [2, 1], [3, 2], [1, 2]], R).
% R = [1, 1, 1, 2, 3, 3, 1, 1] ;
% false


% rle_decode(L, R):-  % *IMPLEMENTATION HERE*


