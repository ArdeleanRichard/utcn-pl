% inorder(nil).
% inorder(n(Left,Key,Right)):-
% 	inorder(Left),
% 	do_something(Key),
% 	inorder(Right)


tree(n(n(nil,2,nil),7,n(nil,9,nil))).


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

insert_bst(nil, K, t(nil,K,nil)):-!. % insert_bst(T, K, R):-T=nil,!, R = t(nil,K,nil). 
insert_bst(t(Left,K,Right), K, t(Left,K,Right)):-!,
	write("in tree").
insert_bst(t(Left,Key,Right), K, t(NewLeft,Key,Right)):-
	K<Key,!,
	insert_bst(Left,K,NewLeft).
insert_bst(t(Left,Key,Right), K, t(Left,Key,NewRight)):-
	insert_bst(Right,K,NewRight).


%insert/3(In_tree, Key_to_ins, Out_tree).

insert(nil, K, t(nil,K,nil)):-!. 				% insert(Tin, K, Tout):-Tin=nil, !, Tout=t(nil,Key,nil).
insert(t(Left,K,Right), K, t(Left,K,Right)):- 	% insert(Tin,K,Tout):-
	!, write("in tree"). 						% Tin=t(Left,K,Right),!,write("in tree"),Tout= t(Left,K,Right)).
insert(t(Left,Key,Right), K, t(NewLeft,Key,Right)):-
	insert(Left,  K, NewLeft).
insert(t(Left,Key,Right), K, t(Left,Key,NewRight)):-
	insert(Right, K, NewRight).



tree(
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

% ?-tree(T),search_tree(a(R,john),T).
% ?-tree(T),search_tree(a(9,X),T).

% search part
delete_bst(t(Left,Key,Right), K, t(NewLeft,Key,Right)):-
	K<Key,!,
	delete_bst(Left, K, NewLeft).
delete_bst(t(Left,Key,Right), K, t(Left,Key,NewRight)):-
	K>Key,!,
	delete_bst(Right, K, NewRight).

% cases of no children or 1 child
delete_bst(nil,K,nil):-!,write(K),write('not found').	
delete_bst(t(nil,K,Right), K, Right):-!.
delete_bst(t(Left,K,nil), K, Left):-!.

% case of 2 children
delete_bst(t(Left,Key,Right),Key,t(NewLeft,MaxLeft,Right)):-!,
	deleteMaxFromTree(Left,MaxLeft,NewLeft).

deleteMaxFromTree(t(Left,Key,Right),MaxKey,t(Left,Key,NewRight)):-
	deleteMaxFromTree(Right,MaxKey,NewRight).
deleteMaxFromTree(t(Left,MaxKey,nil),MaxKey,Left):-!.

