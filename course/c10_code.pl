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












:-dynamic best/2.
a_way(V,V,Thread,Th_length):-
	is_objective(V), !, 
	retract(best(_,_)), !,
	asserta(best(Thread,Th_length)),
	fail. 		% cut above. So, where does backtracking fail? Mistake?
a_way(V1,V2, Thread,Th_length):-
	best(_,BTh_length),
	Th_length1 is Th_length +1,
	Th_length1<BTh_length,
	is_pass(V1,V3), 	% nondetermistic call. Why nondetermistic?
	not(member(V3,Thread)),
	a_way(V3,V2, [V3|Thread],Th_length1).

best_way(V1,V2,_):-
	assert(best([],1000)), % not a wise init; better sum of all weights
	a_way(V1,V2,[V1],1).
best_way(_,_,Thread):-
	retract(best(Thread,_)).


% is_door(a,b).
% is_door(b,c).
% is_door(b,e).
% is_door(c,d).
% is_door(d,e).
% is_door(e,f).
% is_door(e,g).


neighb1(a, [b]).
neighb1(b, [a,c,e]).
neighb1(c, [b,d]).
neighb1(d, [c,e]).
neighb1(e, [f,g]).


neighb(a, [b]).
neighb(b, [c,e]).
neighb(c, [d]).
neighb(d, [e]).
neighb(e, [f,g]).


% ?- ways([a], X, Way).
%a_way/3 (First_vertex, Last_vertex, Path).
a_way(V,V,[V]).
a_way(V1,V2,[V1|Rest]):-
	neighb(V1,L),
	ways(L,V2,Rest).

%ways/3 (List_of vertices_to_start_from, Last_vertex, Path).
ways([V1|_],V2,Way):-
	a_way(V1,V2,Way).
ways([_|Rest],V2,Way):-
	ways(Rest,V2,Way).




% ?-is_restricted_way(a, X, [b,c,d], Way).
% ?-is_restricted_way(a, X, [b,e,d], Way).
is_restricted_way(NX,NY,Restrictions,Way):-
	is_way_obj(NX,NY,Way),
	is_in_order(Restrictions,Way).	% how else could we do?

is_way_obj(NX,NY,Way):-
	nonvar(NX), 		 % meaning? Why needed?	
	try2(NX,NY,[NX],Way), % any try from v1, v2, v3
	is_objective(NY).	% why test here and not before try? Would it be better?

is_in_order([NX|TX],[NX|TY]):-!,		% what is this cut cutting?
	is_in_order(TX,TY).
is_in_order([NX|TX],[_|TY]):-
	is_in_order([NX|TX],TY).
is_in_order([],_).



% findall/3 (Collected_var, Collector_predicate, Collector_var). 				
findall(X,G,_):- 	
	asserta(found(end)),	
	G,					

	asserta(found(X)),
	fail. 	
findall(_,_,L):-			
	collect_found([],L). 	
			
collect_found(P,L):-
	get_next(X),!, 	
	collect_found([X|P],L). 
collect_found(L,L).

get_next(X):-
	retract(found(X)),!, 	
	X=/=end.		

