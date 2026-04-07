% sum_fw/3 (+List, +Accumulator, -Result).
sum_fw([],PartialSum,PartialSum). 			% final result, copies the value of the partial 
											% result with default unification
sum_fw([H|T],PartialSum,Sum):-
	NewPartialSum is PartialSum + H, 		% do process the current item
	sum_fw(T,NewPartialSum,Sum).			% go ahead with the remaining struct




% sum_fw/2 (+List, -Result)
sum_fw(List,Sum):-	      		% same partial result as in case of backward
	sum_fw(List,0,Sum).     	% nothing yet processed, null result.
								% same as in stop condition for bwd.



% sum_bw/2 (+List, -Result).
sum_bw([],0).		   			% result gets initialized. Empty input, null
sum_bw([H|T],Sum):-
	sum_bw(T,TailSum),			% call processing first on rest of the partition
	Sum is TailSum + H. 		% do process the current item	






% forward_recursion/3 (+Input, +Accumulator, -Output)

% final result (arg 3) copies partial result(arg 2) value with default unification
forward_recursion([],Result,Result). 

% partition data, split into H and T
forward_recursion([H|T],PartialResult,Result):- 
	% start by processing the current item and thus 
	% updating previous PartialResult to NewPartialResult via processing do/3
	do(PartialResult,H,NewPartialResult), 
	
	% process the rest of the structure with recursive call.
	forward_recursion(T,NewPartialResult,Result). 


% forward_recursion_call/2 (+Input, -Output)
% make the initialization with a separate predicate (wrapper) to avoid mandatory user initialization
forward_recursion_call(Input,Output):-
	forward_recursion(Input,InitialValueOfResult,Output)





% backward_recursion/2 (+Input, -Output)
 
% empty input, make initialization backwards
backward_recursion([],InitialValueOfResult).	
backward_recursion([H|T],NewPartialResult):-
	% starts with processing the rest of the structure; 
	% all partition but the current item.
	backward_recursion(T,PartialResult),

	%process the current item
	do(PartialResult,H,NewPartialResult).	




append3_1(L1,L2,L3,Result):
	append(L1,L2,Intermediate),      % link L2 at the end of L1 = Intermediate
	append(Intermediate,L3,Result).  % link L3 at the end of the intermediate result


append3_2(L1,L2,L3,Result):-
	append(L2,L3,Intermediate),	  	% link L3 at the end of L2 = Intermediate
	append(L1,Intermediate,Result). % link intermediate at the end of the first list L1 


append3_3([H|T],L2,L3,[H|R]):- 
	% as long as the first arg	
	% nonempty, decompose it
	append3_3(T,L2,L3,R). 
append3_3([],[H|T],L,[H|R]):-
	% once first argument empty 
	% you are back on 2 list concatenation
	append3_3([],T,L,R). 
append3_3([],[],L,L).


delete1(X,[X|T],T).	
delete1(X,[H|T],[H|R]):- 		
	delete1(X,T,R). 	
delete1(_,[],[]). 

delete2(X,[X|T],T):- !.	
delete2(X,[H|T],[H|R]):- 		
	delete2(X,T,R). 	
delete2(_,[],[]).


delete_all(X,[X|T],R):-
	!,
	delete_all(X,T,R). 	
delete_all(X,[H|T],[H|R]):- 	
	delete_all(X,T,R). 	
delete_all(_,[],[]). 