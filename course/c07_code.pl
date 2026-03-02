tree(t(7, t(5,_,_),t(9,t(8,_,_),_))).

search(K, t(K,_,_)):-!,
	 write(“found”).
search(K, t(Key,Left,_)):-
	K<Key,!,
	search(K, Left).
search(K, t(_,_,Right)):-
	search(K, Right).


search_ins(K,t(Key,_,_)):-!,
	 write(“found”).
search_ins(K, t(Key,Left,_)):-
	K<Key,!,
	search_ins(K, Left).
search_ins(K, t(_,_,Right)):-
	search_ins(K, Right).

% [q1] ?-tree(T),search_ins(9,T).
% 	behaves as search (= search_ins)


% [q2] ?-tree(T),search_ins(6,T).
% 	behaves as insert (= search_ins)


search_IT(K, T):-
	var(T), !,
	fail.
search_IT(K,t(K,_,_)):- 
	!,
	write(“found”).
search_IT(K, t(Key,Left,_)):-
	K<Key,!,
	search_IT(K, Left).
search_IT(Key, t(_,_,Right)):-
	search_IT(K, Right). 


tree2(
	n(
		n(_, a(5,john), _),
					a(7,dan),
		n(_, a(9,peter), _)
	)
).


search_ins(K, n(_,a(K,Info),_), Info):-!. 
search_ins(K, n(Left,a(Key,_),_), Info):-
	K<Key, !,
	search_ins(K, Left, Info).	
search_ins(K, n(_,_,Right), Info):-
	search_ins(K, Right, Info).

% [q1] ?- tree2(T),search_ins(9,T,R).
% Yes, R=peter

% [q2] ?- tree2(T), search_ins(8,T,fred). 
% Yes, T increases	    		

% [q3] ?- tree2(T), search_ins(5,T,maria).



% sort_1/3(In_tree, Partial_result_list, Final_result_list) 

sort_1(nil,L,L).	
sort_1(n(Left,Key,Right), Lin, Lout):-
	sort_1(Left, Lin, LLout),
	append(LLout,[Key], LRin),
	sort_1(Right, LRin, Lout).

sort_1(Tree,Result):-
	sort_1(Tree,[],Result).



generate_ordered_list(nil,L,L).
generate_ordered_list(t(Left,Key,Right),FirstListLeft,LastListRight):-
	generate_ordered_list(Left,FirstListLeft,[Key|Intermediate]),
	generate_ordered_list(Right,Intermediate,LastListRight).

generate_ordered_list(ITree,OList):-
    generate_ordered_list(ITree,OList,[]).




generate_preorder_list(nil,L,L).
generate_preorder_list(t(Left,Key,Right),[Key|FirstListLeft],LastListRight):-
	generate_preorder_list(Left, FirstListLeft, Interm),
	generate_preorder_list(Right,Interm, LastListRight).

generate_preorder_list(ITree,OList):-
	generate_preorder_list(ITree,OList,[]).




generate_postorder_list(nil,L,L).
generate_postorder_list(t(Left,Key,Right),FirstListLeft,LastListRight):-
	generate_postorder_list(Left, FirstListLeft, Intermediate),
	generate_postorder_list(Right, Intermediate, [Key|LastListRight]).

generate_postorder_list(ITree,OList):-
	generate_postorder_list(ITree,OList,[]).
