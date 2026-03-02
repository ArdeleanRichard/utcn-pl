%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 			LABORATORY 9 EXAMPLES		%%%%%%
%%%%%%   			Difference Lists  		%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------
%--------------------------------------------------
% LISTS %
%--------------------------------------------------
%--------------------------------------------------

%--------------------------------------------------
% The ADD predicate %
%--------------------------------------------------

% For complete lists
add_cl(X, [H|T], [H|R]):- add_cl(X, T, R).
add_cl(X, [], [X]).

% For difference lists
add_dl(X, LS, LE, RS, RE):- RS = LS, LE = [X|RE].

add_dl2(X,LS,[X|RE],LS,RE). % * SIMPLIFIED

% Follow the execution of:
% ? - trace, LS=[1,2,3,4|LE], add_dl2(5,LS,LE,RS,RE).
% LE = [5|RE],
% LS = RS, RS = [1, 2, 3, 4, 5|RE]

%--------------------------------------------------
% The APPEND predicate %
%--------------------------------------------------
append_dl(LS1, LE1, LS2,LE2, RS,RE):- RS=LS1, LE1=LS2, RE=LE2.

% Follow the execution of:
% ? - trace, LS1=[1,2,3,4|LE1], LS2=[5,6,7,8|LE2], append_dl(LS1, LE1, LS2, LE2, RS, RE).
% LE1 = LS2, LS2 = [5, 6, 7, 8|RE],
% LE2 = RE,
% LS1 = RS, RS = [1, 2, 3, 4, 5, 6, 7, 8|RE]



%--------------------------------------------------
% The QUICKSORT predicate %
%--------------------------------------------------
% H is pivot, Sm = smaller than pivot, Lg = greater than pivot
partition(H, [X|T], [X|Sm], Lg):-X<H, !, partition(H, T, Sm, Lg).
partition(H, [X|T], Sm, [X|Lg]):-partition(H, T, Sm, Lg).
partition(_, [], [], []).

quicksort_dl([H|T], S, E):- % a new argument was added
	partition(H, T, Sm, Lg), % partition predicate remains the same
	quicksort_dl(Sm, S, [H|L]), %implicit concatenation
	quicksort_dl(Lg, L, E).
quicksort_dl([], L, L). % stopping condition has been changed

% Follow the execution of:
% ?- trace, quicksort_dl([4,2,5,1,3], L, []).
% ?- trace, quicksort_dl([4,2,5,1,3], L, _).





%--------------------------------------------------
%--------------------------------------------------
% TREES %
%--------------------------------------------------
%--------------------------------------------------

%TREE
tree1(t(6, t(4, t(2, nil, nil), t(5, nil, nil)), t(9, t(7, nil, nil), nil))).


%--------------------------------------------------
% The INORDER predicate %
%--------------------------------------------------

% For complete lists
inorder(t(K,L,R),List):-
	inorder(L,ListL),
	inorder(R,ListR),
	append(ListL,[K|ListR],List).
inorder(nil,[]).

% For difference lists
% when we reached the end of the tree we unify the beginning and end
% of the partial result list – representing an empty list as a difference list
inorder_dl(nil,L,L).
inorder_dl(t(K,L,R),LS,LE):-
	%obtain the start and end of the lists for the left and right subtrees
	inorder_dl(L,LSL,LEL),
	inorder_dl(R,LSR,LER),
	% the start of the result list is the start of the left subtree list
	LS=LSL,
	% key K is inserted between the end of left and the start of right
	LEL=[K|LSR],
	% the end of the result list is the end of the right subtree list
	LE=LER.

% Test the following queries:
% ? - trace, tree1(T), inorder_dl(T,L,[]).
% ? - trace, tree1(T), inorder_dl(T,L,_).

% *simplified 
inorder_dl2(nil,L,L).
inorder_dl2(t(K,L,R),LS,LE):-
	inorder_dl2(L,LS,[K|LT]), 
	inorder_dl2(R,LT,LE).
	






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 				EXERCISES				%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trees:
complete_tree(t(6, t(4,t(2,nil,nil),t(5,nil,nil)), t(9,t(7,nil,nil),nil))).
incomplete_tree(t(6, t(4,t(2,_,_),t(5,_,_)), t(9,t(7,_,_),_))).


% Write a predicate which:
%--------------------------------------------------
% 1. Transforms a complete list into a difference list and vice versa.
% ?- convertCL2DL([1,2,3,4], LS, LE).
% LS = [1, 2, 3, 4|LE]
% ?- LS=[1,2,3,4|LE], convertDL2CL(LS,LE,R).
% R = [1, 2, 3, 4]


% convertCL2DL(L, LS, LE):- % *IMPLEMENTATION HERE*

% convertDL2CL(LS, LE, R):- % *IMPLEMENTATION HERE*


%--------------------------------------------------
% 2. Transforms an incomplete list into a difference list and vice versa.
% ?- convertIL2DL([1,2,3,4|_], LS, LE).
% LS = [1, 2, 3, 4|LE]
% ?- LS=[1,2,3,4|LE], convertDL2IL(LS,LE,R).
% R = [1, 2, 3, 4|_]


% convertIL2DL(L, LS, LE):- % *IMPLEMENTATION HERE*

% convertDL2IL(LS, LE, R):- % *IMPLEMENTATION HERE*



%--------------------------------------------------
% 3. Flattens a deep list using difference lists instead of append.
% ?- flat_dl([[1], 2, [3, [4, 5]]], RS, RE).
% RS = [1, 2, 3, 4, 5|RE] ;
% false


% flat_dl(L, RS, RE):- % *IMPLEMENTATION HERE*







%--------------------------------------------------
% 4. Traverses a complete tree in pre-order and post-order using difference lists in an implicit manner.
% ?- complete_tree(T), preorder_dl(T, S, E).
% S = [6, 4, 2, 5, 9, 7|E]
% ?- complete_tree(T), postorder_dl(T, S, E).
% S = [2, 5, 4, 7, 9, 6|E]


% preorder_dl(t(K,L,R), S, E):- % *IMPLEMENTATION HERE*

% postorder_dl(t(K,L,R), S, E):- % *IMPLEMENTATION HERE*



%--------------------------------------------------
% 5. Collects all even keys in a complete binary tree, using difference lists.
% ?- complete_tree(T), even_dl(T, S, E).
% S = [2, 4, 6|E]


% even_dl(t(K,L,R), S, E):- % *IMPLEMENTATION HERE*



%--------------------------------------------------
% 6. Collects, from a incomplete binary search tree, all keys between K1 and K2, using difference lists.
% ?- incomplete_tree(T), between_dl(T, S, E, 3, 7).
% S = [4, 5, 6|E]


% between_dl(t(K,L,R), S, E):- % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 7. Collects, from a incomplete binary search tree, all keys at a given depth K using difference lists.
% ? – incomplete_tree(T), collect_depth_k(T, 2, S, E).
% S = [4, 9|E].

    
% collect_depth_k(t(K,L,R), S, E):- % *IMPLEMENTATION HERE*