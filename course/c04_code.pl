% sum2/3 (In_list, Final_result, Accumulator_partial_result).

sum2([],PartialSum,PartialSum). 		% final result, copies the value of the partial 
										% result with default unification
sum2([H|T],Sum,PartialSum):-
	NewPartialSum is PartialSum + H, 	% do process the current item
	sum2(T,Sum,NewPartialSum).			% go ahead with the remaining struct


sum2(List,Sum):-	             		% same partial result as in case of backward
	sum2(List,Sum,0).    				% nothing yet processed, null result. 			
										% Same as in stop condition for bwd.


% sum1/2 (In_list, Sum_of_els_in_arg_1).
sum1([],0).		   						% result gets initialized. Empty input, null
sum1([H|T],Sum):-
	sum1(T,TailSum),	   				% call processing first on rest of the partition
	Sum is TailSum + H. 				% do process the current item	





% forward_recursion/3 (input argument, final result, partial result)

% final result(arg 2) copies partial result(arg3) value with default unification
forward_recursion([],PartialResult,PartialResult). 

% partition data, here split into H and T
forward_recursion([H|T],Result,PartialResult):- 
	% start by processing the current item and thus 
	% updating previous PartialResult to NewPartialResult via processing do
	do(NewPartialResult,H,PartialResult), 
	
	% process the rest of the structure with recursive call.
	forward_recursion(T,Result,NewPartialResult). 

%forward_recursion_call/2 (in, out)
forward_recursion_call(Input,Output):-
	forward_recursion(Input,Output,InitialValueOfResult) 
% make the initialization with a separate predicate (wrapper) 
% to avoid mandatory user initialization


% backward_recursion/2 (input argument, output result)
 
% empty input, make initialization backwards
backward_recursion([],InitialValue).	

backward_recursion([H|T],PartialResult):-
	% starts with processing the rest of the structure; 
	% all partition but the current item.
	backward_recursion(T,NewPartialResult),

	%process the current item
	do(PartialResult,H,NewPartialResult).	
	
% No need for a specific initial call, hence, no wrapper predicate.


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