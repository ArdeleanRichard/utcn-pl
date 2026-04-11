%--------------------------------------------------
% Graph - Representations %
%--------------------------------------------------
% neighb/2 (+Vertex, +NeighborList).
neighb(a,[b,c]).
neighb(z,[]).	% isolated node




% edge/2 (+Vertex1, +Vertex2).
edge(a,b).
edge(a,c).
edge(z,nil). 	% isolated node

% is_edge/2 (+Vertex1, +Vertex2).
is_edge(X,Y):-
	edge(X,Y); % check one way
	edge(Y,X). % and the other way




%--------------------------------------------------
% Graph - Paths %
%--------------------------------------------------

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



% path/3 (+Source, +Target, -Path).




% will have order reversed as try1/4 adds into the accumulator
path1(X,Y,Path):-
	try1(X,Y,[X],Path), 	% try a path from X to Y with the partial path 				
								% containing just the starting vertex at this point
	is_objective(Y), !. 		% why not start with this? 


% Call it with:
% ?- path1(a,X,Path). 		% is X safe here? Not Y? 



% try1 /4 (+Source, +Target, +PartialPath, -FinalPath)
try1(Y,Y,FPath,FPath). 					% at every step, stop and check if over
try1(X,Y,PPath,FPath):-					% if not over (how do we know is not over here?)
	is_pass(X,Z), 		  				% find next step to Z	
	not(member(Z,PPath)), 	  			% verify if unchecked door
	try1(Z,Y,[Z|PPath],FPath).			% make the step







% will have correct order as try2/4 adds into result backwards
path2(X,Y,Path):-
	try2(X,Y,[X],Path), 	% try a path from X to Y with the partial path 				
							% containing just the starting vertex at this point
	is_objective(Y), !. 	% why not start with this? 

%try2 /4 (+Source, +Target, +PartialPath, -FinalPath)
try2(Y,Y,_,[Y]).
try2(X,Y,PPath,[X|FPath]):-
	is_pass(X,Z),
	not(member(Z,PPath)),
	try2(Z,Y,[Z|PPath],FPath).


% Call it with:
% ?- path2(a,X,Path). 




% will have correct order as try3/3 adds into result backwards
path3(X,Y,Path):-
	retractall(seen(_)),
	try3(X,Y,Path), 		% try a path from X to Y with the partial path 				
							% containing just the starting vertex at this point
	is_objective(Y), !. 		% why not start with this? 


% try /3 (+Source, +Target, -FinalPath)
try3(X,X,[X]). 
try3(X,Y,[X|Path]):-
	is_pass(X,Z),
	accept(Z), 			% can Z be part of the thread
	try3(Z,Y,Path).

:-dynamic seen/1.

% accept/1 (+Vertex). 
accept(X):-
	seen(X),!, 			% is the contradiction! The ONLY contradiction is that the vertex is 
	fail.	 			% ALREADY in the solution. If there, don’t loop; fail to backtrack!
accept(X):-
	assert(seen(X)). 	% no contradiction, add it in the solution 
accept(X):-
	retract(seen(X)),!, % cannot conclude with X in solution, remove and
	fail.			  	% backtrack to try WITHOUT it!

% Call it with:
% ?- path3(a,X,Path). 




%--------------------------------------------------
% Graph - Best path %
%--------------------------------------------------

:-dynamic best/2.

best_path(X,Y,_):-
	assert(best([],1000)), 			% not a wise init; better sum of all weights
	a_path(X,Y,[X],1).
best_path(_,_,Thread):-
	retract(best(Thread,_)).



a_path(Y,Y,Path,PathLen):-
	is_objective(Y), !, 
	retract(best(_,_)), !,
	asserta(best(Path,PathLen)),
	fail. 						% cut above. So, where does backtracking fail? Mistake?
a_path(X,Y, Path,PathLen):-
	best(_,BestLen),
	PathLen1 is PathLen +1,
	PathLen1 < BestLen,
	is_pass(X,Z), 				% nondetermistic call. Why nondetermistic?
	not(member(Z,Path)),
	a_path(Z,Y, [Z|Path],PathLen1).


% Call it with:
% ?- best_path(a,X,Path).


%--------------------------------------------------
% Graph - All paths %
%--------------------------------------------------


% is_door(a,b).
% is_door(b,c).
% is_door(b,e).
% is_door(c,d).
% is_door(d,e).
% is_door(e,f).
% is_door(e,g).





neighb1(a, [b]).
neighb1(b, [c,e]).
neighb1(c, [d]).
neighb1(d, [e]).
neighb1(e, [f,g]).

% neighb2/2 due to the a-b and b-a generates an infinite path between them
% neighb2(a, [b]).
% neighb2(b, [a,c,e]).
% neighb2(c, [b,d]).
% neighb2(d, [c,e]).
% neighb2(e, [f,g]).


% a_path /3 (+Source, +Target, -Path).
a_path(Y,Y,[Y]).
a_path(X,Y,[X|Rest]):-
	neighb1(X,L),
	all_paths(L,Y,Rest).

% all_paths /3 (+SourcesList, +Target, -Path).
all_paths([X|_],Y,Path):-
	a_path(X,Y,Path).
all_paths([_|Rest],Y,Path):-
	all_paths(Rest,Y,Path).

% Call it with:
% ?- all_paths([a], X, Path).


%--------------------------------------------------
% Graph - Restricted path %
%--------------------------------------------------
% restricted_path /4 (+Source, +Target, +RestrictionsList, -Path)
restricted_path(X,Y,Restrictions,Path):-
	path_obj(X,Y,Path),
	restrict(Restrictions,Path).	% how else could we do?

path_obj(X,Y,Path):-
	nonvar(X), 		 		% meaning? Why needed?	
	try2(X,Y,[X],Path), 	% any try from v1, v2, v3
	is_objective(Y).		% why test here and not before try? Would it be better?

restrict([H|TR],[H|T]):- !,		% what is this cut cutting?
	restrict(TR,T).
restrict([HR|TR],[_|T]):-
	restrict([HR|TR],T).
restrict([],_).

% Call it with:
% ?- restricted_path(a, X, [b,c,d], Path).
% ?- restricted_path(a, X, [b,e,d], Path).






%--------------------------------------------------
% Univ predicate in Graphs %
%--------------------------------------------------

% path1 /4 (+Graph, +Source, +Target, -Path)
path1(Graph, X, Y, Path):- 
	path1(Graph, X, Y, [X], Path).

path1(_, Y, Y, _, []).
path1(G, X, Y, PPath, [Z|FPath]):-
 	Edge=..[G, X, Z], 	% Edge becomes → G(X, Z),
 	call(Edge),
 	not(member(Z, PPath)),
 	path1(G, Z, Y, [Z|PPath], FPath).


% Call it with:
% ?- path1(edge, a, g, Path).
