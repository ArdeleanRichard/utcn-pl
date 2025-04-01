%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 			LABORATORY 5 EXAMPLES		%%%%%%
%%%%%% 			Sorting Methods				%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------
% The PERMUTATION SORT predicate %
%--------------------------------------------------
perm_sort(L,R):-perm(L, R), is_ordered(R), !.

perm(L, [H|R]):- append(A, [H|T], L), append(A, T, L1), perm(L1, R).
perm([], []).

is_ordered([H1, H2|T]):- H1 =< H2, is_ordered([H2|T]).
is_ordered([_]). % if only one element remains, the list is already ordered


% Follow the execution of:
% ?- append(A, [H|T], [1, 2, 3]), append(A, T, R).
% ?- perm([1, 2, 3], L).
% ?- is_ordered([1, 2, 4, 4, 5]).
% ?- perm_sort([1, 4, 2, 3, 5], R).



%--------------------------------------------------
% The SELECTION SORT predicate %
%--------------------------------------------------
sel_sort(L, [M|R]):- min1(L, M), delete1(M, L, L1), sel_sort(L1, R).
sel_sort([], []).

delete1(X, [X|T], T) :- !.
delete1(X, [H|T], [H|R]) :- delete1(X, T, R).
delete1(_, [], []).

min1([H|T], M) :- min1(T, M), M<H, !.
min1([H|_], H).


% Follow the execution of:
% ?- sel_sort([3, 2, 4, 1], R).
% ?- sel_sort([3, 1, 5, 2, 4, 3], R).



%--------------------------------------------------
% The INSERTION SORT predicate %
%--------------------------------------------------
ins_sort([H|T], R):- ins_sort(T, R1), insert_ord(H, R1, R).
ins_sort([], []).

insert_ord(X, [H|T], [H|R]):-X>H, !, insert_ord(X, T, R).
insert_ord(X, T, [X|T]). 

% Follow the execution of:
% ?- insert_ord(3, [], R).
% ?- insert_ord(3, [1, 2, 4, 5], R).
% ?- insert_ord(3, [1, 3, 3, 4], R).
% ?- ins_sort([3, 2, 4, 1], R).




%--------------------------------------------------
% The BUBBLE SORT predicate %
%--------------------------------------------------
bubble_sort(L, R):-one_pass(L, R1, F), nonvar(F), !, bubble_sort(R1, R).
bubble_sort(L, L).

one_pass([H1, H2|T], [H2|R], F):- H1>H2, !, F = 1, one_pass([H1|T], R, F).
one_pass([H1|T], [H1|R], F):-one_pass(T, R, F).
one_pass([], [] ,_).


% Follow the execution of:
% ?- one_pass([1, 2, 3, 4], R, F).
% ?- one_pass([2, 3, 1, 4], R, F).
% ?- bubble_sort([1, 2, 3, 4], R).
% ?- bubble_sort([2, 3, 1, 4], R).




%--------------------------------------------------
% The QUICK SORT predicate %
%--------------------------------------------------
quick_sort([H|T], R):-
	partition(H, T, Sm, Lg), 
    quick_sort(Sm, SmS),
	quick_sort(Lg, LgS), 
    append(SmS, [H|LgS], R).
quick_sort([], []).

% H is pivot, Sm = smaller than pivot, Lg = greater than pivot
partition(H, [X|T], [X|Sm], Lg):-X<H, !, partition(H, T, Sm, Lg).
partition(H, [X|T], Sm, [X|Lg]):-partition(H, T, Sm, Lg).
partition(_, [], [], []).


% Follow the execution of:
% ?- partition(3, [4, 2, 6, 1, 3], Sm, Lg).
% ?- quick_sort([3, 2, 5, 1, 4, 3], R).
% ?- quick_sort([1, 2, 3, 4], R).


%--------------------------------------------------
% The MERGE SORT predicate %
%--------------------------------------------------
merge_sort(L, R):- 
	split(L, L1, L2), 
    merge_sort(L1, R1), 
    merge_sort(L2, R2),
	merge(R1, R2, R).
merge_sort([H], [H]).
merge_sort([], []).

split(L, L1, L2):-
	length(L, Len), 
	Len>1, 
	K is Len/2, 
	splitK(L, K, L1, L2).

splitK([H|T], K, [H|L1], L2):- K>0, !, K1 is K-1, splitK(T, K1, L1, L2).
splitK(T, _, [], T).

merge([H1|T1], [H2|T2], [H1|R]):-H1<H2, !, merge(T1, [H2|T2], R).
merge([H1|T1], [H2|T2], [H2|R]):-merge([H1|T1], T2, R).
merge([], L, L).
merge(L, [], L).



% Follow the execution of:
% ?- split([2, 5, 1, 6, 8, 3], L1, L2).
% ?- split([2], L1, L2).
% ?- merge([1, 5, 7], [3, 6, 9], R).
% ?- merge([1, 1, 2], [1], R).
% ?- merge([], [3], R).
% ?- merge_sort([4, 2, 6, 1, 5], R).





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 				EXERCISES				%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%--------------------------------------------------
% 1. Rewrite the sel_sort/2 predicate such that it selects the maximum value
% from the unsorted part, therefore it sorts the list decreasingly, name it
% sel_sort_max/2. The max1/2 predicate can be created by modifying the
% min1/2 predicate from the last laboratory.
% ?- sel_sort_max([3,4,1,2,5], R).
% R = [5, 4, 3, 2, 1];
% false


% sel_sort_max(L, R):-  % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 2. Implement bubble sort using a fixed number of passes through the input
% sequence, name it bubble_sort_fixed/3.
% ?- bubble_sort_fixed([3,5,4,1,2], 2, R).
% R = [3, 1, 2, 4, 5]


% bubble_sort_fixed(L, K, R):-  % *IMPLEMENTATION HERE*, K is the number of passes






%--------------------------------------------------
% 3. Write a predicate that sorts a list of ASCII characters. (You can use a
% sorting method of your choice).
% Suggestion: use the char_code/2 built-in predicate
% ?- sort_chars([e, t, a, v, f], L).
% L = [a, e, f, t, v] ;
% false


% sort_chars(L, R):-  % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 4. Write a predicate that sorts a list of sub-lists according to the lengths of
% the sub-lists. (You can use a sorting method of your choice).
% ?- sort_lens([[a, b, c], [f], [2, 3, 1, 2], [], [4, 4]], R).
% R = [[], [f], [4, 4], [a, b, c], [2, 3, 1, 2]] ;
% false

% sort_lens(L, R):-  % *IMPLEMENTATION HERE*




%--------------------------------------------------
% Optional. This predicate can be made more complex when considering the case
% of two sub-lists with equal lengths, take the case of [1,1,1] and [1,1,2], the
% predicate would have to additionally parse the two lists in the case of equal
% lengths and compare them element-by-element.
% ?- sort_lens2([[], [1], [2, 3, 1, 2], [2, 3, 5, 2], [7,6,8], [4, 4]], R).
% R = [[], [1], [4, 4], [7, 6, 8], [2, 3, 1, 2], [2, 3, 5, 2]];
% false


% sort_lens2(L, R):-  % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 5. Write a forward recursive implementation of the ins_sort/2 predicate,
% name it ins_sort_fwd/2.
% Recommendation: the insertion sort predicate is made of two predicates,
% both using a backwards approach, try to modify them both into a forwards approach.
% ?- ins_sort_fwd([3,4,1,2,5], R).
% R = [1, 2, 3, 4, 5];
% false


% ins_sort_fwd(L, R):-  % *IMPLEMENTATION HERE*






%--------------------------------------------------
% 6. Rewrite the perm/2 predicate without using the append/3 predicate,
% name it perm1/2. Extracting and deleting an element must be achieved differently.
% ?- perm1([1,2,3], R).
% R = [1, 2, 3];
% R = [1, 3, 2];
% R = [2, 1, 3];
% …


% perm1(L, R):-  % *IMPLEMENTATION HERE*




