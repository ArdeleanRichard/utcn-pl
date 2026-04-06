% inorder(nil).
% inorder(n(Left,Key,Right)):-
% 	inorder(Left),
% 	do_something(Key),
% 	inorder(Right)


tree(n(n(nil,5,nil),7,n(nil,9,nil))).


% forward inorder
inorder1(nil,L,L).	
inorder1(n(Left,Key,Right), Lin, Lout):-
	inorder1(Left, Lin, LLout),
	append(LLout,[Key],LRin),
	inorder1(Right,LRin,Lout).

inorder1(Tree,Result):-
	inorder1(Tree,[],Result).

% ?- tree(T), inorder1(T, R).



% backward inorder
% inorder2/2 (In_tree, Result_list)

inorder2(nil,[]).	
inorder2(n(Left,Key,Right),Lout):-
	inorder2(Left,LLout),
	append(LLout, [Key], Lintout),
	inorder2(Right,LRout),
	append(Lintout, LRout, Lout).

inorder3(nil,[]).	
inorder3(n(Left,Key,Right),Lout):-
	inorder3(Left,LLout),
	inorder3(Right,LRout),
	append(LLout,[Key| LRout],Lout).




%insert_bst/3(In_tree, Key_to_ins, Out_tree).

insert_bst(nil, K, n(nil,K,nil)):-!. 			% insert_bst(T, K, R):- T=nil,!, R = t(nil,K,nil). 
insert_bst(n(Left,K,Right), K, n(Left,K,Right)):-!, write("in tree").
insert_bst(n(Left,Key,Right), K, n(NewLeft,Key,Right)):-
	K<Key,!,
	insert_bst(Left,K,NewLeft).
insert_bst(n(Left,Key,Right), K, n(Left,Key,NewRight)):-
	insert_bst(Right,K,NewRight).


%insert/3(In_tree, Key_to_ins, Out_tree).

insert(nil, K, n(nil,K,nil)):-!. 				% insert(Tin, K, Tout):-Tin=nil, !, Tout=t(nil,Key,nil).
insert(n(Left,K,Right), K, n(Left,K,Right)):- 	% insert(Tin,K,Tout):-
	!, write("in tree"). 						% Tin=t(Left,K,Right),!,write("in tree"),Tout= t(Left,K,Right)).
insert(n(Left,Key,Right), K, n(NewLeft,Key,Right)):-
	insert(Left,  K, NewLeft).
insert(n(Left,Key,Right), K, n(Left,Key,NewRight)):-
	insert(Right, K, NewRight).



tree_kv(
	n(
		n(
			nil, 
				a(5,john), 
			nil
		),
					a(7,dan),
		n(
			nil, 
				a(9,peter), 
			nil
		)
	)
).



% search_bst/2(Node_searched,Tree)
search_bst(N, n(_,Node,_)):-
	eq(N, Node),!,
	N=Node.
search_bst(N, n(Left,Node,_)):-
	ord(N, Node), !,
	search_bst(N, Left).
search_bst(N, n(_,_,Right)):-
	search_bst(N, Right).

eq(a(K,_),a(Key,_)):-
	nonvar(K),		
	K=Key,!.

ord(a(K,_),a(Key,_)):-
	nonvar(K),
	K<Key,!.




% search_tree/2(Key,Tree)
search_tree(N, n(_,N,_)).	
search_tree(N, n(Left,_,_)):-
	search_tree(N, Left).
search_tree(N, n(_,_,Right)):-
	search_tree(N, Right).

% ?-tree_kv(T), search_tree(a(R,john),T).
% ?-tree_kv(T), search_tree(a(9,X),T).





% search part
delete_bst(n(Left,Key,Right), K, n(NewLeft,Key,Right)):-
	K<Key,!,
	delete_bst(Left, K, NewLeft).
delete_bst(n(Left,Key,Right), K, n(Left,Key,NewRight)):-
	K>Key,!,
	delete_bst(Right, K, NewRight).

% cases of no children or 1 child
delete_bst(nil,K,nil):-!,write(K),write('not found').	
delete_bst(n(nil,K,Right), K, Right):-!.
delete_bst(n(Left,K,nil), K, Left):-!.

% case of 2 children
delete_bst(n(Left,Key,Right),Key,n(NewLeft,MaxLeft,Right)):-!,
	deleteMaxFromTree(Left,MaxLeft,NewLeft).

deleteMaxFromTree(n(Left,Key,Right),MaxKey,n(Left,Key,NewRight)):-
	deleteMaxFromTree(Right,MaxKey,NewRight).
deleteMaxFromTree(n(Left,MaxKey,nil),MaxKey,Left):-!.

