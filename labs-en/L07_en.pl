%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 			LABORATORY 7 EXAMPLES		%%%%%%
%%%%%% 					Trees				%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%TREES EXAMPLES
tree1(t(6, t(4, t(2, nil, nil), t(5, nil, nil)), t(9, t(7, nil, nil), nil))).
tree2(t(8, t(5, nil, t(7, nil, nil)), t(9, nil, t(11, nil, nil)))). 
% …
% through this query, the T variable unifies with the tree in the tree1/1 fact.
% ? - tree1(T), operation_on_tree(T, …).


%--------------------------------------------------
% The Tree TRAVERSAL predicates %
%--------------------------------------------------

% inorder traversal - left sub-tree, key, right sub-tree (order in append)
inorder(t(K,L,R), List):-
	inorder(L,LL), 
	inorder(R, LR),
	append(LL, [K|LR],List).
inorder(nil, []). 

% key, left sub-tree, right sub-tree (order in append)
preorder(t(K,L,R), List):-
	preorder(L,LL), 
	preorder(R, LR),
	append([K|LL], LR, List).
preorder(nil, []).

% left sub-tree, right sub-tree, key (order in appends)
postorder(t(K,L,R), List):-
	postorder(L,LL), 
	postorder(R, LR),
	append(LL, LR, R1), 
	append(R1, [K], List).
postorder(nil, []). 


% Follow the execution of:
% ?- trace, tree1(T), inorder(T, L).
% ?- trace, tree1(T), preorder(T, L).
% ?- trace, tree1(T), postorder(T, L).



%--------------------------------------------------
% The PRETTY PRINT predicate %
%--------------------------------------------------

% wrapper
pretty_print(T):- pretty_print(T, 0).

% predicate that prints the tree
pretty_print(nil, _).
pretty_print(t(K,L,R), D):- 
	D1 is D+1,
	pretty_print(L, D1),
	print_key(K, D),
	pretty_print(R, D1).

% print_key/2 prints key K at D tabs from the left margin
% and inserts a new line (through nl)
print_key(K, D):-D>0, !, D1 is D-1, tab(8), print_key(K, D1).
print_key(K, _):-write(K), nl.
% write('\n') is equivalent to nl/0

% Follow the execution of:
% ?- tree2(T), pretty_print(T).


%--------------------------------------------------
% The SEARCH predicate %
%--------------------------------------------------
search_key(Key, t(Key, _, _)):-!.
search_key(Key, t(K, L, _)):-Key<K, !, search_key(Key, L).
search_key(Key, t(_, _, R)):-search_key(Key, R).


% Follow the execution of:
% ?- trace, tree1(T), search_key(5,T).
% ?- trace, tree1(T), search_key(8,T).


%--------------------------------------------------
% The INSERT predicate %
%--------------------------------------------------
insert_key(Key, nil, t(Key, nil, nil)). % insert key in tree
insert_key(Key, t(Key, L, R), t(Key, L, R)):- !. % key already exists
insert_key(Key, t(K,L,R), t(K,NL,R)):- Key<K,!,insert_key(Key,L,NL).
insert_key(Key, t(K,L,R), t(K,L,NR)):- insert_key(Key, R, NR).


% Follow the execution of:
% ?- tree1(T),pretty_print(T),insert_key(8,T,T1),pretty_print(T1).
% ?- tree1(T),pretty_print(T),insert_key(5,T,T1),pretty_print(T1).
% ?- insert_key(7, nil, T1), insert_key(12, T1, T2), insert_key(6, T2, T3), insert_key(9, T3, T4), insert_key(3, T4, T5), insert_key(8, T5, T6), insert_key(3, T6, T7), pretty_print(T7).



%--------------------------------------------------
% The DELETE predicate %
%--------------------------------------------------
delete_key(Key, t(Key, L, nil), L):- !.
delete_key(Key, t(Key, nil, R), R):- !.
delete_key(Key, t(Key, L, R), t(Pred,NL,R)):- !, get_pred(L,Pred,NL).
delete_key(Key, t(K,L,R), t(K,NL,R)):- Key<K, !, delete_key(Key,L,NL).
delete_key(Key, t(K,L,R), t(K,L,NR)):- delete_key(Key,R,NR).

% search for the predecessor node
get_pred(t(Pred, L, nil), Pred, L):-!.
get_pred(t(Key, L, R), Pred, t(Key, L, NR)):- get_pred(R, Pred, NR).


% Follow the execution of:
% ?- tree1(T), pretty_print(T), delete_key(5, T, T1), pretty_print(T1).
% ?- tree1(T), pretty_print(T), delete_key(9, T, T1), pretty_print(T1).
% ?- tree1(T), pretty_print(T), delete_key(6, T, T1), pretty_print(T1).
% ?- tree1(T), pretty_print(T), insert_key(8, T, T1), pretty_print(T1), delete_key(6, T1, T2), pretty_print(T2), insert_key(6, T2, T3), pretty_print(T3).


%--------------------------------------------------
% The HEIGHT predicate %
%--------------------------------------------------

% predicate which computes the maximum between 2 numbers
max(X, Y, X):- X>Y, !.
max(_, Y, Y).

% predicate which computes the height of a binary tree
height(nil, 0).
height(t(_, L, R), H):- 
    height(L, H1),
 	height(R, H2),
 	max(H1, H2, H3),
 	H is H3+1.


% Follow the execution of:
% ?- trace, tree1(T), height(T, H).
% ?- tree1(T), height(T, H), pretty_print(T), insert_key(8, T, T1), height(T1, H1), pretty_print(T1).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 				EXERCISES				%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trees:
binary_tree(t(6, t(4,t(2,nil,nil),t(5,nil,nil)), t(9,t(7,nil,nil),nil))).
ternary_tree(t(6, t(4, t(2, nil, nil, nil), nil, t(5, nil, nil, nil)), t(7, nil, nil, nil), t(9, t(8, nil, nil, nil), nil, nil))).


%--------------------------------------------------
% 1. Write the predicates that iterate over the elements of a ternary tree in:
% 1.1. preorder=Root->Left->Middle->Right
% 1.2. inorder=Left->Root->Middle->Right
% 1.3. postorder=Left->Middle->Right->Root


% ?- ternary_tree(T), ternary_preorder(T, L).
% L = [6, 4, 2, 5, 7, 9, 8], T= ... 
% ?- ternary_tree(T), ternary_inorder(T, L).
% L = [2, 4, 5, 6, 7, 8, 9], T= ... 
% ?- ternary_tree(T), ternary_postorder(T, L).
% L = [2, 5, 4, 7, 8, 9, 6], T= ...  


% ternary_preorder(T, List):- % *IMPLEMENTATION HERE*

% ternary_inorder(T, List):- % *IMPLEMENTATION HERE*

% ternary_postorder(T, List):- % *IMPLEMENTATION HERE*


%--------------------------------------------------
% 2. Write the pretty print predicate called pretty_print_ternary/1 for a ternary tree.
% ?- ternary_tree(T), pretty_print_ternary(T).


% pretty_print_ternary(T):- % *IMPLEMENTATION HERE*



%--------------------------------------------------
% 3. Write a predicate that computes the height of a ternary tree.
% ?- ternary_tree(T), ternary_height(T, H).
% H=3, T= ... ;
% false.

% ternary_height(T, H):- % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 4. Write a predicate that collects into a list, all the keys of the leaves of a Binary Search Tree.
% ?- binary_tree(T), leaf_list(T, R).
% R=[2,5,7], T= ... ;
% false.

% leaf_list(T, List):- % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 5. Write a predicate that collects into a list, all the keys of the internal nodes (non-leaves) of a Binary Search Tree.
% ?- binary_tree(T), internal_list(T, R).
% R = [4, 6, 9], T = ... ;
% false.

% internal_list(T, List):- % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 6. Write a predicate that collects into a list, all the nodes from the same depth (inverse of height) in a Binary Tree.
% ?- binary_tree(T), same_depth(T, 2, R).
% R = [4, 9], T = ... ;
% false.

% same_depth(T, K, List):- % *IMPLEMENTATION HERE*



%--------------------------------------------------
% 7. Write a predicate that computes the diameter of a Binary Tree.
% 𝑑𝑖𝑎𝑚(𝑇) = max {𝑑𝑖𝑎𝑚(𝑇. 𝑙𝑒𝑓𝑡), 𝑑𝑖𝑎𝑚(𝑇. 𝑟𝑖𝑔ℎ𝑡), ℎ𝑒𝑖𝑔ℎ𝑡(𝑇. 𝑙𝑒𝑓𝑡) + ℎ𝑒𝑖𝑔ℎ𝑡(𝑇. 𝑟𝑖𝑔ℎ𝑡) + 1}
% ?- binary_tree(T), diam(T, D).
% D = 5, T = ... ;
% false.


% diam(T, D):- % *IMPLEMENTATION HERE*


%--------------------------------------------------
% 8. Write a predicate that checks if a binary tree is symmetric. A binary tree
% is symmetric if the left sub-tree is the mirror of the right sub-tree. We are
% interested in the structure of the tree, not the values (keys) of the nodes.
% ?- binary_tree(T), symmetric(T).
% false.
% ?- binary_tree(T), delete_key(2, T, T1), symmetric(T1).
% T = t(6,t(4,t(2,nil,nil),t(5,nil,nil)),t(9,t(7,nil,nil),nil)),
% T1 = t(6,t(4,nil,t(5,nil,nil)),t(9,t(7,nil,nil),nil));
% false.


% symmetric(T):- % *IMPLEMENTATION HERE*



%--------------------------------------------------
% 9. Rewrite the delete_key predicate using the successor node (binary search trees).
% ?- binary_tree(T), delete_key(5, T, T1), delete_key_succ(5, T, T2).
% T1 = T2, T2 = t(6,t(4,t(2,nil,nil),nil),t(9,t(7,nil,nil),nil)),
% T = t(6,t(4,t(2,nil,nil),t(5,nil,nil)),t(9,t(7,nil,nil),nil)).
% ?- binary_tree(T), delete_key(6, T, T1), delete_key_succ(6, T, T2).
% T = t(6,t(4,t(2,nil,nil),t(5,nil,nil)),t(9,t(7,nil,nil),nil)),
% T1 = t(5,t(4,t(2,nil,nil),nil),t(9,t(7,nil,nil),nil)),
% T2 = t(7,t(4,t(2,nil,nil),t(5,nil,nil)),t(9,nil,nil))


% delete_key_succ(K, T, T2):- % *IMPLEMENTATION HERE*

