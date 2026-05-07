%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 			LABORATORY 11 EXAMPLES		%%%%%%
%%%%%% 					Graphs 				%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%--------------------------------------------------
% The GRAPH REPRESENTATIONS %
%--------------------------------------------------
% A1B2
node(a). 
node(b). %etc

edge1(a,b). 
edge1(b,a).
edge1(b,c). 
edge1(c,b). %etc

is_edge(X,Y):- edge(X,Y); edge(Y,X).


% A2B2
neighbor1(a, [b, d]).
neighbor1(b, [a, c, d]).
neighbor1(c, [b, d]). %etc.



%--------------------------------------------------
% The Graph representation conversion predicate %
%--------------------------------------------------
% we declare the predicate as dynamic to be able to use retract
:-dynamic neighbor/2. 
% as the neighbour predicate is introduced in the file, 
% it is considered static only through the introduction of the 
% dynamic declaration can we use the retract operation on it

% an example graph – 1st connected component of the example graph
neighbor(a, [b, d]).  
neighbor(b, [a, c, d]).
neighbor(c, [b, d]).
%etc.

neighb_to_edge:-
    % extract the first neighbour predicate
    retract(neighbor(Node,List)),!, 
    % and process it
    process(Node,List),
    neighb_to_edge.
neighb_to_edge. % if no more neighbor/2 predicates remain then we stop

% processing presumes the addition of edge & node predicates 
% for each neighbour predicate, we first add the edges 
% until the list is empty and then add the node predicate
process(Node, [H|T]):- assertz(gen_edge(Node, H)), process(Node, T).
process(Node, []):- assertz(gen_node(Node)).


% The querying of this predicate is rather simple:
% ?- neighb_to_edge.
% true;
% false.

% Try:
% ?- retractall(gen_edge(_,_)), neighb_to_edge, listing(gen_edge/2).


% Variant 2, with failure-driven loops
neighb_to_edge_v2:-
    neighbor(Node,List), % access the fact
    process(Node,List),
    fail.
neighb_to_edge_v2.


% Variant 3, recursion without retract
:-dynamic seen/1. 

neighb_to_edge_v3:-
    neighbor(Node,List), 
    not(seen(Node)),!,
    assert(seen(Node)),
    process(Node,List),
    neighb_to_edge_v3.
neighb_to_edge_v3. 


%--------------------------------------------------
% The PATH predicate %
%--------------------------------------------------
edge(a,c).
edge(b,c).
edge(c,d).
edge(d,e).
edge(c,e).

% path(Source, Target, Path)
% the partial path starts with the source node – it is a wrapper
path(X, Y, Path):-path(X, Y, [X], Path). 

% when source (1st argument) is equal to target (2nd argument), 
% we finished the path and we unify the partial and final paths.
path(Y, Y, PPath, PPath).			
path(X, Y, PPath, FPath):-
    edge(X, Z), 				% search for an edge
    not(member(Z, PPath)), 		% that was not traversed
    path(Z, Y, [Z|PPath], FPath).	          % add to partial result

	
% Follow the execution of:
% ?- trace, path(a,c,R).



%--------------------------------------------------
% The RESTRICTED PATH predicate %
%--------------------------------------------------
% restricted_path(Source, Target, RestrictionsList, Path)
restricted_path(X,Y,LR,P):- 
    path(X,Y,P), 
    reverse(P,PR), 
    check_restrictions(LR, PR).

% predicate that verifies the restrictions
check_restrictions([],_):- !.
check_restrictions([H|TR], [H|TP]):- !, check_restrictions(TR,TP).
check_restrictions(LR, [_|TP]):-check_restrictions(LR,TP).



% Follow the execution of:
% ?- trace, check_restrictions([2,3], [1,2,3,4]).
% ?- trace, check_restrictions([1,3], [1,2,3,4]).
% ?- trace, check_restrictions([1,3], [1,2]).
% ?- trace, restricted_path(a, c, [a,c,d], R).



%--------------------------------------------------
% The OPTIMAL PATH predicate %
%--------------------------------------------------
edge_o(a,c).
edge_o(b,c).
edge_o(c,d).
edge_o(d,e).
edge_o(c,e).
edge_o(a,b).
edge_o(b,e).

:- dynamic sol_part/2.

% optimal_path(Source, Target, Path)
optimal_path(X,Y,Path):-
    asserta(sol_part([], 100)), 	% 100 = max initial distance
    path(X, Y, [X], Path, 1).
optimal_path(_,_,Path):- 
    retract(sol_part(Path,_)).

% path(Source, Target, PartialPath, FinalPath, PathLength)
% when target is equal to source, we save the current solution
path(Y,Y,Path,Path,LPath):-	
    % we retract the last solution	
    retract(sol_part(_,_)),!, 		
    % save current solution
    asserta(sol_part(Path,LPath)), 	
    % search for another solution
    fail.					
path(X,Y,PPath,FPath,LPath):-
    edge_o(X,Z),
    not(member(Z,PPath)),
    % compute partial distance
    LPath1 is LPath+1,			
    % extract distance from previous solution
    sol_part(_,Lopt),			
    % if current distance is smaller than the previous distance, 
    LPath1<Lopt,		
    % we keep going		
    path(Z,Y,[Z|PPath],FPath,LPath1).


% Follow the execution of:
% ?- trace, optimal_path(a,c,R).




%--------------------------------------------------
% A better implementation of paths %
%--------------------------------------------------

% Order of paths is now correct (not reversed)
path1(X, Y, Path):- path1(X, Y, [X], Path). 

path1(Y, Y, _, []).			
path1(X, Y, PPath, [Z|FPath]):-
    edge(X, Z), 				
    not(member(Z, PPath)), 		
    path1(Z, Y, [Z|PPath], FPath).	          




% Now we can apply path on any graph
path1(Graph, X, Y, Path):- path1(Graph, X, Y, [X], Path). 

path1(_, Y, Y, _, []).			
path1(G, X, Y, PPath, [Z|FPath]):-   
    call(G, X, Z),				% we call G(X, Z),
    not(member(Z, PPath)), 		
    path1(G, Z, Y, [Z|PPath], FPath).	          

% Follow the execution of: 
% ?- trace, path1(edge, a, c, P).





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 				EXERCISES				%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------
% Each exercise has its own graph allocated to it. As such, in your implementation you should 
% use the edges of that graph. For example, when solving Exercise 1, the predicate should call edge_ex1/2.





%--------------------------------------------------
% 1. Rewrite the optimal_path/3 predicate such that it operates on weighted graphs: attach a 
% weight to each edge on the graph and compute the minimum cost path from a source node to a 
% destination node. 
% ?- optimal_weighted_path(a, e, P).
% P = [e, b, a]

edge_ex1(a,c,7).
edge_ex1(a,b,10).
edge_ex1(c,d,3).
edge_ex1(b,e,1).
edge_ex1(d,e,2).


% opt_weight_path(a, e, P):- % *IMPLEMENTATION HERE* 




% 2. Continue the implementation of the Hamiltonian Cycle using the hamilton/3 predicate.
% ?- hamilton(5, a, P).
% P = [a, e, d, c, b, a]

edge_ex2(a,b).
edge_ex2(b,c).
edge_ex2(a,c).
edge_ex2(c,d).
edge_ex2(b,d).
edge_ex2(d,e).
edge_ex2(e,a).


% hamilton(NumOfNodes, Source, Path)
hamilton(NN, X, Path):- 
    NN1 is NN-1, 
    hamilton_path(NN1, X, X,[X],Path).

% *IMPLEMENTATION HERE* 





%--------------------------------------------------
% 3. Write the euler/3 predicate that can find Eulerian paths in a given graf starting from a given source node.
% ?- euler(5, a, R).
% R = [[b, a], [e, b], [d, e], [c, d], [a, c]]

edge_ex3(a,b).
edge_ex3(b,e).
edge_ex3(c,a).
edge_ex3(d,c).
edge_ex3(e,d).



% euler(NE, X, Path):- % *IMPLEMENTATION HERE* 






%--------------------------------------------------
% 4. Write a predicate cycle(X,R) to find a closed path (cycle) starting at a given node X in 
% the graph G (using the edge/2 representation)  and saves the result in R. The predicate should 
% return all cycles via backtracking. Moreover, the predicate should receive the edge predicate 
% defining the graph as an input (suggestion: call/n predicate).
% ?- cycle(edge_ex4, a, R).
% R = [a,d,b,a] ;
% R = [a,e,c,a] ;
% false

edge_ex4(a,b).
edge_ex4(a,c).
edge_ex4(c,e).
edge_ex4(e,a).
edge_ex4(b,d).
edge_ex4(d,a).




% cycle(G, X,Path):- % *IMPLEMENTATION HERE* 





%--------------------------------------------------
% 5. Write the cycle(X,R) predicate from the previous exercise using the neighbour/2 representation.
% Moreover, the predicate should receive the neighb predicate defining the graph as an input 
% (suggestion: call/n predicate).
% ?- cycle_neighb(neighb_ex5, a, R).
% R = [a,d,b,a] ;
% R = [a,e,c,a] ;
% false

neighb_ex5(a, [b,c]).
neighb_ex5(b, [d]).
neighb_ex5(c, [e]).
neighb_ex5(d, [a]).
neighb_ex5(e, [a]).



% cycle_neighb(G, X,Path):- % *IMPLEMENTATION HERE* 






%--------------------------------------------------
% 6. Write the predicate(s) which perform the conversion between the edge-clause representation (A1B2) to the neighbor list-list representation (A2B1).
% ?- retractall(gen_neighb(_,_)), edge_to_neighb, listing(gen_neighb/2).
% true

edge_ex6(a,b).
edge_ex6(a,c).
edge_ex6(b,d).



:- dynamic gen_neighb/2.

% edge_to_neighb:- % *IMPLEMENTATION HERE* 






%--------------------------------------------------
% 7. The restricted_path/4 predicate computes a path between the source and the destination 
% node, and then checks whether the path found contains the nodes in the restriction list. Since 
% predicate path used forward recursion, the order of the nodes must be inversed in both lists 
% – path and restrictions list. Try to motivate why this strategy is not efficient (use trace to 
% see what happens). Write a more efficient predicate which searches for the restricted path  
% between a source and a target node.
% ? - restricted_path_efficient(a, e, [c,d], P2).
% P = [a, b, c, d, e];
% P = [a, c, d, e];
% false

edge_ex7(a,b).
edge_ex7(b,c).
edge_ex7(a,c).
edge_ex7(c,d).
edge_ex7(b,d).
edge_ex7(d,e).
edge_ex7(e,a).


% restricted_path_efficient(X,Y,LR,Path):- % *IMPLEMENTATION HERE* 

















%--------------------------------------------------
% 8. Write a set of Prolog predicates to solve the Wolf-Goat-Cabbage problem: “A farmer and his goat, wolf, and cabbage are on the North bank of a river. 
% They need to cross to the South bank. They have a boat, with a capacity of two; the farmer is the only one that can row. If the goat and the cabbage are 
% left alone without the farmer, the goat will eat the cabbage. Similarly, if the wolf and the goat are together without the farmer, the goat will be eaten.”
% Suggestions:
% ●	you may choose to encode the state space as instances of the configuration of the 4 objects (Farmer, Wolf, Goat, Cabbage), represented either 
% 	as a list (i.e. [F,W,G,C]), or as a complex structure (e.g. F-W-G-C, or state(F,W,G,C)).
% ●	the initial state would be [n,n,n,n] (all north) and the final state [s,s,s,s] (all south); for the list representation of states 
% 	(e.g. if Farmer takes Wolf across -> [s,s,n,n], this state should not be valid as the goat eats the cabbage).
% ●	in each transition (or move), the Farmer can change its state (from n to s, or vice-versa) together with at most one other participant (Wolf, Goat, or Cabbage).
% ●	this can be viewed as a path search problem in a graph.
