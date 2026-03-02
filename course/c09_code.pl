% subst/4 (OldExpr,NewExpr,OldSubExpr,NewSubExpr).
% subst_args/4 (ListOldExpr,ListNewExpr,OldSubExpr,NewSubExpr).


subst1(Old,New,Old,New):-!. 
subst1(Val,Val,_,_):- atomic(Val),!.	
subst1(Val,NewVal,OldSubExpr,NewSubExpr):-
	Val=..[F|Args], 
	subst_args1(Args,NewArgs,OldSubExpr,NewSubExpr),
	NewVal=..[F|NewArgs]. 

subst_args1([],[],_,_).
subst_args1([Arg|Args],[NArg|NArgs],Old,New):-
	subst1(Arg,NArg,Old,New), 	
	subst_args1(Args,NArgs,Old,New). 

% [q] ?- subst1(f(a, b, g(a)), R, a, x).
% R = f(x,b,g(x))


subst2(Old,New,Old,New):-!. 	
subst2(Val,Val,_,_):- atomic(Val),!.	
subst2(Val,NewVal,OldSubExpr,NewSubExpr):-
	functor(Val,F,N), 
	functor(NewVal,F,N), 	
	subst_args2(N,Val,NewVal,OldSubExpr,NewSubExpr).
	
subst_args2(0,_,_,_,_):-!. 
subst_args2(N,Val,NewVal,Old,New):-
	arg(N,Val,OldArg),
 	arg(N,NewVal,NewArg),
 	subst2(OldArg,NewArg,Old,New),
	N1 is N-1,
	subst_args2(N1,Val,NewVal,Old,New). 

% [q] ?- subst2(f(a, b, g(a)), R, a, x).
% R = f(x,b,g(x))








:- dynamic(input/1).
:- dynamic(int/1).
:- dynamic(out/1).

move_discs(0,_,_,_):-!.
move_discs(N,X,Y,Z):- 
	N1 is N-1,
	move_discs(N1,X,Z,Y),
	move_disc(X, Z),
	move_discs(N1,Y,X,Z).

move_disc(IP,OP):-
	DI=..[IP,Size],
	retract(DI),!,
	DO=..[OP,Size], 
	asserta(DO).

init_pole(_,[]):-!.
init_pole(P,[N|L]):-
	D=..[P,N],		% D=..[input, N] <--> D=input(1) / D=input(2) ...
	asserta(D), 	% asserta(input(1)), assert(input(2)), ...
	init_pole(P,L).

init_list(1,[1]):-!.
init_list(N,[N|Rest]):- 
	N1 is N-1,
	init_list(N1,Rest).

hanoi(N):-
	init_list(N,List), 				% List = [5, 4, 3, 2, 1]
	init_pole(input,List),			% ?- init_list(3, List), init_pole(input, List), listing(input/1). % Creates pole as: input(1), input(2)
	move_discs(N,input,int,out).	% input,int,out = x,y,z towers

% ?- retractall(out(_)), hanoi(3), listing(input/1), listing(out/1).











is_door(a,b).
is_door(b,c).
is_door(b,e).
is_door(c,d).
is_door(d,e).
is_door(e,f).
is_door(e,g).

is_objective(g).

is_pass(X,Y):-
	is_door(X,Y);
	is_door(Y,X).







% will have order reversed as try1/4 adds into the accumulator
search_v1(X,Y,Way):-
	try1(X,Y,[X],Way), 	% try a path from X to Y with the partial path 				
						% containing just the starting vertex at this point
	is_objective(Y),!. 	% why not start with this? 


% Call it with:
% ?- search_v1(a,X,Way_Out). 	% is X safe here? Not Y? 



%try1/4 (From_vertex,To_vertex,Partial_path,Final_path)
try1(X,X,L,L). 					% at every step, stop and check if over
try1(X,Y,Thread,Way):-			% if not over (how do we know is not over here?)
	is_pass(X,Z), 		  		% find next step to Z	
	not(member(Z,Thread)), 	  	% verify if unchecked door
	try1(Z,Y,[Z|Thread],Way).	% make the step







% will have correct order as try2/4 adds into result backwards
search_v2(X,Y,Way):-
	try2(X,Y,[X],Way), 	% try a path from X to Y with the partial path 				
						% containing just the starting vertex at this point
	is_objective(Y),!. 	% why not start with this? 

%try2/4 (From_vertex,To_vertex,Partial_path,Final_path)
try2(X,X,_,[X]).
try2(X,Y,Thread,[X|L]):-
	is_pass(X,Z),
	not(member(Z,Thread)),
	try2(Z,Y,[Z|Thread],L).






% will have correct order as try3/3 adds into result backwards
search_v3(X,Y,Way):-
	retractall(seen(_)),
	try3(X,Y,Way), 		% try a path from X to Y with the partial path 				
						% containing just the starting vertex at this point
	is_objective(Y),!. 	% why not start with this? 


% try/3 (From_vertex,To_vertex,Path).
try3(X,X,[X]). 
try3(X,Y,[X|L]):-
	is_pass(X,Z),
	accept(Z), 		% can Z be part of the thread
	try3(Z,Y,L).

:-dynamic seen/1.

% accept/1 (Vertex). 
accept(X):-
	seen(X),!, 			% is the contradiction! The ONLY contradiction is that the vertex is 
	fail.	 			% ALREADY in the solution. If there, don’t loop; fail to backtrack!
accept(X):-
	assert(seen(X)). 	% no contradiction, add it in the solution 
accept(X):-
	retract(seen(X)),!, % cannot conclude with X in solution, remove and
	fail.			  	% backtrack to try WITHOUT it!

