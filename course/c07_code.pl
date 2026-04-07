% gen_preorder/3 (+Tree, -DifferenceListStart, -DifferenceListEnd)

gen_preorder(nil, Start, End):- Start = End.
gen_preorder(t(Left,Key,Right), Start, End):-
	gen_preorder(Left, LeftStart, LeftEnd),
	gen_preorder(Right,RightStart,RightEnd),
	Start		= [Key|LeftStart],
	LeftEnd		= RightStart,
	End		= RightEnd.


preorder(nil,L,L).
preorder(t(Left,Key,Right),[Key|LeftStart],RightEnd):-
	preorder(Left,LeftStart,Intermediate),
	preorder(Right,Intermediate, RightEnd).

preorder(ITree,OList):-
 	preorder(ITree,OList,[]).


inorder(nil,L,L).
inorder(t(Left,Key,Right),LeftStart,RightEnd):-
	inorder(Left,LeftStart,[Key|Intermediate]),
	inorder(Right,Intermediate, RightEnd).

inorder(ITree,OList):-
 	inorder(ITree,OList,[]).


postorder(nil,L,L).
postorder(t(Left,Key,Right),LeftStart,RightEnd):-
	postorder(Left,LeftStart,Intermediate),
	postorder(Right,Intermediate, [Key|RightEnd]).

postorder(ITree,OList):-
 	postorder(ITree,OList,[]).




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


% quicksort_DL1/3 (+List, -OutListStart, -OutListEnd)

quicksort_DL1([H|T],Start,End):-
	partition(H,T,Left,Right),
	quicksort_DL1(Left, StartLeft, EndLeft),
	quicksort_DL1(Right,StartRight,EndRight),
	Start		= LeftStart, 
	EndLeft	= [H|StartRight],
	RightEnd 	= End.
quicksort_DL1([],L,L).



% quicksort_DL2/3 (+List, -OutListStart, -OutListEnd)
quicksort_DL2([H|T],Start,End):-
	partition(H,T,Left,Right),
	quicksort_DL2(Left, Start,[H|Inter]),
	quicksort_DL2(Right,Inter, End).
quicksort_DL2([],List,List).



% enqueue/5 (+El2enQ, +QBeforeStart, +QBeforeEnd, -QAfterStart, -QAfterEnd)

enqueue1(El,First,[El|Last],First,Last).

% Means:
enqueue(El,FQB,LQB,FQA,LQA):-
	FQA=FQB,    	% after adding in the Q, it starts in the same place
	LQB=[H|LQA],	% before adding, the list ends IN FRONT 		
	H = El. 		% of the item to be added


% ?-enqueue(Item,FB,LB,FA,LA).




% dequeue/5 (+El2deQ, +QBeforeStart, +QBeforeEnd, -QAfterStart, -QAfterEnd)

dequeue1(El,[El|First],Last,First,Last).

% Means:
dequeue(El,FQB,LQB,FQA,LQA):-
	FQB=[H|FI], 	% extracted element H from the front of Q
	El=H, 			% assign it to our argument	
	FI=FQA, 		% Q without first element is our FirstQueueAfter 	
	LQA=LQB. 		% list ends are the same as removal is from front


% ?-dequeue(Item,FB,LB,FA,LA).










% What is a deep list?
% L=[1,1,[2,2,2,[3,3,[4],3],2,2,[3,[4,[5,5,5]]],2]]


% deep2flat/2 (+DeepList, -FlatList).
deep2flat([],[]):-!.
deep2flat([H|T],[H| Tflat]):-
	atomic(H),!,
	deep2flat(T, Tflat).
deep2flat([H|T],R):-
	deep2flat(H,Hflat), 	% H is a list
	deep2flat(T,Tflat),
	append(Hflat, Tflat, R).


% [q] ?- deep2flat([1,1,[2,2,2,[3,3,[4],3],2,2,[3,[4,[5,5,5]]],2]], R)
% R=[1, 1, 2, 2, 2, 3, 3, 4, 3, 2, 2, 3, 4, 5, 5, 5, 2]



% deep2flat_dl/3 (+DeepList, -FlatListStart, -FlatListEnd).
deep2flat_dl([], End, End):-!.
deep2flat_dl([H|T],[H|Tflat],End):-
		atomic(H),!,
		deep2flat_dl(T,Tflat,End).
deep2flat_dl([H|T],Start,End):-
		deep2flat_dl(H,Start,Int),
		deep2flat_dl(T,Int,End).

flatten(Deep,Flat):-
	 deep2flat_dl(Deep,Flat,[]).
