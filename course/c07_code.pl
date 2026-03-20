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





partition(X,[H|T],[H|Left],Right):- 
	H<X,!,
	partition(X,T,Left,Right).
partition(X,[H|T],Left,[H|Right]):-
	partition(X,T,Left,Right).
partition(_,[],[],[]).



quicksort([H|T],Result):-
	partition(H,T,Left,Right),
	quicksort(Left,SortedLeft),
	quicksort(Right,SortedRight),
	append(SortedLeft,[H|SortedRight],Result).
quicksort([],[]).


%qsort_DL2/3 (InList, FirstOutList,LastOutList)
qsort_DL2([H|T],LFirst,LLast):-
	partition(H,T,Left,Right),
	qsort_DL2(Left,LFirst,[H|Inter]),
	qsort_DL2(Right,Inter,LLast).
qsort_DL2([],List,List).


%enqueue/5 (El2enQ, FirstQBefore, LastQBefore, FirstQAfter, LastQAfter)

enqueue1(El,First,[El|Last],First,Last).

% Means:
enqueue(El,FQB,LQB,FQA,LQA):-
	FQA=FQB,    % after adding in the Q, it starts in the same place
	LQB=[H|LQA],% before adding, the list ends IN FRONT 		
	H = El. 	% of the item to be added


% ?-enqueue(Item,FB,LB,FA,LA).


%dequeue/5 (El2deQ, FirstQBefore, LastQBefore, FirstQAfter, LastQAfter)

dequeue1(El,[El|First],Last,First,Last).

% Means:
dequeue(El,FQB,LQB,FQA,LQA):-
	FQB=[H|FI], % extracted element H from the front of Q
	El=H, 		% assign it to our argument	
	FI=FQA, 	% Q without first element is our FirstQueueAfter 	
	LQA=LQB. 	% list ends are the same as removal is from front


% ?-dequeue(Item,FB,LB,FA,LA).










% What is a deep list?
% L=[1,1,[2,2,2,[3,3,[4],3],2,2,[3,[4,[5,5,5]]],2]]


%deep2flat/2 (DeepList,FlatList).
deep2flat([],[]):-!.
deep2flat([H|T],[H|FlattenedTail]):-
	atomic(H),!,
	deep2flat(T,FlattenedTail).
deep2flat([H|T],FlattenedList):-
	deep2flat(H,FlattenedHead),
	deep2flat(T,FlattenedTail),
	append(FlattenedHead,FlattenedTail,FlattenedList).

% [q] ?- deep2flat([1,1,[2,2,2,[3,3,[4],3],2,2,[3,[4,[5,5,5]]],2]], R)
% R=[1, 1, 2, 2, 2, 3, 3, 4, 3, 2, 2, 3, 4, 5, 5, 5, 2]



%deep2flat_dl/3 (DeepList, FirstFlatList, LastFlatList).
deep2flat_dl([],Last,Last):-!.
deep2flat_dl([H|T],[H|FlattenedTail],Last):-
		atomic(H),!,
		deep2flat_dl(T,FlattenedTail,Last).
deep2flat_dl([H|T],FlattenedList,Last):-
		deep2flat_dl(H,FlattenedList,Int),
		deep2flat_dl(T,Int,Last).

flatten(Deep,Flat):-
	 deep2flat_dl(Deep,Flat,[]).








