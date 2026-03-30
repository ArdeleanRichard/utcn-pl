member_IL(_,L):-
	var(L),!, 		% this order: check, cut, fail
	fail. 		
member_IL(H,[H|_]):-!.	% cut mandatory
member_IL(H,[_|T]):-	 	
	member_IL(H,T).
	
% [q1] ?- L=[1,2,3|_],member_IL(2,L).
% true, L=[1,2,3|_]. 		%exe stops on clause 2

% [q2] ?- L=[1,2,3|_],member_IL(4,L).
% false. 					%exe stops on clause 1



insert_IL(H,[H|_]):-!.
insert_IL(H,[_|T]):-	 	
	insert_IL(H,T).

% [q1] ?- L=[1,2,3|_], insert_IL(4,L).
% true, L=[1,2,3,4|_].
% 	Has pure insert behavior. Clause 1 behaves as:
% 	insert_IL(X,L):- var(L), !, L=[X|_].

% [q2] ?- L=[1,2,3|_], insert_IL(3,L).
% true, L=[1,2,3|_].
% 	Has member behavior. Clause 1 behaves as:
% 	insert_IL(X,[H|_]):-X=H, !. 	% member(X,[X|_]):-!. 



tree(t(7, t(5,_,_),t(9,t(8,_,_),_))).

search(Key, t(Key,_,_)):-!,
	write(“found”).
search(Key, t(K,L,_)):-
	Key<K,!,
	search(Key, L).
search(Key, t(_,_,R)):-
	search(Key, R).



search_ins(Key,t(Key,_,_)):-!,
	write(“found”).
search_ins(Key, t(K,L,_)):-
	Key<K,!,
	search_ins(Key, L).
search_ins(K, t(_,_,R)):-
	search_ins(Key, R).


% [q1] ?-tree(T), search_ins(9,T).
% 	behaves as search (= search_ins)


% [q2] ?-tree(T), search_ins(6,T).
% 	behaves as insert (= search_ins)


search_IT(_, T):-
	var(T), !,
	fail.
search_IT(Key,t(Key,_,_)):- 
	!,
	write(“found”).
search_IT(Key, t(K,L,_)):-
	Key<K,!,
	search_IT(Key, L).
search_IT(Key, t(_,_,R)):-
	search_IT(Key, R). 



tree2(
	n(
		n(_, a(5,john), _),
					a(7,dan),
		n(_, a(9,peter), _)
	)
).


search_ins(Key, Info, n(_,a(Key,Info),_)):-!. 
search_ins(Key, Info, n(L,a(K,_),_)):-
	Key<K, !,
	search_ins(Key, Info, L).	
search_ins(Key, Info, n(_,_,R)):-
	search_ins(Key, Info, R).


% [q1] ?- tree2(T), search_ins(9,I,T).
% true, I=peter

% [q2] ?- tree2(T), search_ins(8,fred,T). 
% true, T increases	    		

% [q3] ?- tree2(T), search_ins(5,T,maria).
% true, T increases

