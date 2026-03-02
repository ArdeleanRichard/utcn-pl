:-dynamic p/1.

p(1).
p(2).
p(3).
p(4).
p(5).

q1:-assertz(p(6)), fail.
q1.

% ?- listing(p/1).
% ?- q1, listing(p/1).


q2:-retract(p(_)), fail.
q2.

% ?- listing(p/1).
% ?- q2, listing(p/1).


% inorder(nil).
% inorder(n(Left,Key,Right)):-
% 	inorder(Left),
% 	do_something(Key),
% 	inorder(Right)


sort_1(nil,L,L).	
sort_1(n(Left,Key,Right), Lin, Lout):-
	sort_1(Left, Lin, LLout),
	append(LLout,[Key],LRin),
	sort_1(Right,LRin,Lout).


sort_1(nil,L,L).	
sort_1(n(Left,Key,Right), Lin, Lout):-
	sort_1(Left, Lin, LLout),
	append(LLout,[Key],LRin),
	sort_1(Right,LRin,Lout).

sort_1(Tree,Result):-
	sort_1(Tree,[],Result).


% sort_2/2 (In_tree, Result_list)

sort_2(nil,[]).	
sort_2(n(Left,Key,Right),Lout):-
	sort_2(Left,LLout),
	append(LLout, [Key], Lintout),
	sort_2(Right,LRout),
	append(Lintout, LRout, Lout).

sort_3(nil,[]).	
sort_3(n(Left,Key,Right),Lout):-
	sort_3(Left,LLout),
	sort_3(Right,LRout),
	append(LLout,[Key| LRout],Lout).


