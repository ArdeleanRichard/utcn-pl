% inorder(nil).
% inorder(n(Left,Key,Right)):-
% 	inorder(Left),
% 	do_something(Key),
% 	inorder(Right)


tree(n(n(nil,2,nil),7,n(nil,9,nil))).


% forward inorder
inorder1(nil,Res,Res).	
inorder1(n(L,K,R), Acc, Res):-
	inorder1(L, Acc, Acc1),
	append(Acc1,[Key],Acc2),
	inorder1(R, Acc2, Res).

inorder1(Tree, Result):-
	inorder1(Tree, [], Result).

% ?- tree(T), inorder1(T, R).



% backward inorder
% inorder2/2 (In_tree, Result_list)

inorder2(nil,[]).	
inorder2(n(L,K,R),Res):-
	inorder2(L, LL),
	append(LL, [Key], Int),
	inorder2(R, RR),
	append(Int, RR, Res).

inorder3(nil,[]).	
inorder3(n(L,K,R),Res):-
	inorder3(L,LL),
	inorder3(R,RR),
	append(LL,[Key| RR],Res).




%insert_bst/3(In_tree, Key_to_ins, Out_tree).

insert_bst(nil, Key, n(nil,Key,nil)):-!. 			% insert_bst(T, Key, R):- T=nil,!, R = t(nil,Key,nil). 
insert_bst(n(L,Key,R), Key, n(L,Key,R)):-!, write("in tree").
insert_bst(n(L,K,R), Key, n(NL,K,R)):-
	Key<K,!,
	insert_bst(L,Key,NL).
insert_bst(n(L,K,R), Key, n(L,Key,NR)):-
	insert_bst(R,Key,NR).


%insert/3(In_tree, Key_to_ins, Out_tree).

insert(nil, Key, n(nil,Key,nil)):-!. 				% insert(Tin, Key, Tout):-Tin=nil, !, Tout=t(nil,Key,nil).
insert(n(L,Key,R), Key, n(L,Key,R)):- 				% insert(Tin,K,Tout):-
	!, write("in tree"). 							% 	Tin=t(L,Key,R),!,write("in tree"),Tout= t(L,Key,R)).
insert(n(L,K,R), Key, n(NL,K,R)):-
	insert(L, Key, NL).
insert(n(L,K,R), Key, n(L,K,NR)):-
	insert(R, Key, NR).



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

