% length1/2 (List, Length)
length1([],0).		 	% length of empty list is 0
length1([_|T],N):-
	length1(T,N1),	 	% length of tail calculated as N1
	N is N1+1.			% add 1 to the length of tail 

% ?- length1(InList,Result).

% length2/2 (Length, List)
length2([],Res,Res).
length2([_|T],PR,FR):-
	NPR is PR+1, 	
	length2(T,NPR,FR).

length2(InList,Result):-
	length2(InList,0,Result).

% ?- length2(InList,0,Result).
% ?- length2(InList,Result).


% reverse1/2 (List, Rev_list)

reverse1([],[]). 		% empty input returns empty output
reverse1([H|T],R):-
	reverse1(T,PR),   	% reverses the tail of list
	append(PR,[H],R).	% concatenates the partial results


% reverse2/3(List, Part_rev_list, Rev_list)

reverse2([],PR,PR).		% when input gets empty the partial 					 
						% result becomes the final one
reverse2([H|T],PR,R):-
	NPR=[H|PR], 	    % concatenates the partial results
						% PR, NPR acts as a stack
	reverse2(T,NPR,R). 	% reverses the tail of list

reverse(In,Out):-
	reverse2(In,[],Out).


not(P):-
	P, !, fail.
not(P).
