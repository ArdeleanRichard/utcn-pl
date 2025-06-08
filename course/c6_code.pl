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

insert(nil, K, t(nil,K,nil)):-!. % insert(Tin, K, Tout):-Tin=nil, !, Tout=t(nil,Key,nil).
insert(t(Left,K,Right), K, t(Left,K,Right)):- % insert(Tin,K,Tout):-
	!, write("in tree"). % Tin=t(Left,K,Right),!,write("in tree"),Tout= t(Left,K,Right)).
insert(t(Left,Key,Right), K, t(NewLeft,Key,Right)):-
	insert(Left,  K, NewLeft).
insert(t(Left,Key,Right), K, t(Left,Key,NewRight)):-
	insert(Right, K, NewRight).



tree(
	n(
		n(nil, a(5,john), nil),
					a(7,dan),
		n(nil, a(9,peter), nil)
	)
).



%is_in_stree/2(Node_searched,Tree)
is_in_stree(N, n(_,Node,_)):-
	eqch(N, Node),!,
	N=Node.
is_in_stree(N, n(Left,Node,_)):-
	ord(N, Node), !,
	is_in_stree(N, Left).
is_in_stree(N, n(_,_,Right)):-
	is_in_stree(N, Right).

eqch(a(K,_),a(Key,_)):-
	nonvar(K),		
	K=Key,!.

ord(a(K,_),a(Key,_)):-
	nonvar(K),
	K<Key,!.

%is_in_tree/2(Key_searched,Tree)
is_in_tree(N, n(_,N,_)).	
is_in_tree(N, n(Left,_,_)):-
	is_in_tree(N, Left).
is_in_tree(N, n(_,_,Right)):-
	is_in_tree(N, Right).

% ?-tree(T),is_in_tree(a(R,john),T).
% ?-tree(T),is_in_tree(a(9,X),T).


% search
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



member_IL(_,L):-
	var(L),!, 		% this order: check, cut, fail
	fail. 		
member_IL(H,[H|_]):-!.	% cut mandatory
member_IL(H,[_|T]):-	 	
	member_IL(H,T).
	
% [q1] ?- L=[1,2,3|_],member_IL(2,L).
% Yes, L=[1,2,3|_]. 		%exe stops on clause 2

% [q2] ?- L=[1,2,3|_],member_IL(4,L).
% No. 				%exe stops on clause 1



insert_IL(H,[H|_]):-!.
insert_IL(H,[_|T]):-	 	
	insert_IL(H,T).

% [q1] ?- L=[1,2,3|_], insert_IL(4,L).
% Yes, L=[1,2,3,4|_].
% Has pure insert behavior. Clause 1 behaves as:
% insert_IL(X,L):-
% 	var(L),!,L=[X|_].

% [q2] ?- L=[1,2,3|_], insert_IL(3,L).
% Yes, L=[1,2,3|_].
% Has member behavior. Clause 1 behaves as:
% insert_IL(X,[H|_]):-X=H, !. 	% member(X,[X|_]):-!. 
