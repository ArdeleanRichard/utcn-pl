%--------------------------------------------------
% findall %
%--------------------------------------------------

% findall1/3 (+CollectedVar, +CollectorPred, -CollectorVar). 	

findall1(X,P,_):- 	
	P,					
	asserta(found(X)),
	fail. 	
findall1(_,_,L):-			
	collect([],L). 	

% forward recursion, 1st argument is the accumulator
collect(P,L):-
	retract(found(X)),!, 	
	collect([X|P],L). 
collect(L,L).


% likes/2 (+Person, +Drink).
likes(bill,  wine).
likes(dick,  beer).
likes(harry, beer).
likes(john,  beer).
likes(peter, wine).
likes(tom,   beer).
		
% [q] ?- findall1(X, likes(X,beer), L).



%--------------------------------------------------
% For all is true %
%--------------------------------------------------


% ?- for_all_is_true(member(Char, ['a','b','c']), char_type(Char, lower)).
% ?- for_all_is_true(member(Char, ['a','B','c']), char_type(Char, lower)).
for_all_is_true(X,Y):-
	X,
	not(Y),!, 
	fail. 
for_all_is_true(_,_). 



%--------------------------------------------------
% Equivalent graphs %
%--------------------------------------------------

% ?- same_graph
% works only if unoriented and all combinations are provided as below 
% check only with 'edge1(a,b). neighbor1(a,[b]).' -> it fails
edge1(a,b).
edge1(b,a).
neighbor1(a,[b]).
neighbor1(b,[a]).

not1(P):-
	P, !, fail.
not1(_).



is_neighbor1(X,Y):-				% to find all edges in G1, call nondeterminist(X,Y,free)
	neighbor1(X,L),				% finds first pair first (and next on backtrack), instantiates both X and L. 
	member(Y,L).				% nondeterm call on member; instantiate Y, one at a time, eventually all.

is_edge1(X,Y):-
	edge1(X,Y);
	edge1(Y,X).



eq1:-
	is_neighbor1(X,Y),			% for each edge in the first representation
	not1(is_edge1(X,Y)),!, 		% there is one edge in the other graph 
	fail.		 				% otherwise we reach here, hence, fail.
eq1. 							% if we get here, G1=>G2 shown

eq2:-
	is_edge1(X,Y),
	not1(is_neighbor1(X,Y)),!,
	fail.
eq2.

same_graph:- eq1, eq2.





%--------------------------------------------------
% Transform between graph representations %
%--------------------------------------------------


edge2(a, b, 15).

is_edge2(X,Y,W):-
	edge2(X,Y,W);
	edge2(Y,X,W).

:-dynamic neighbor/2.

edge2neighb:-
	is_edge2(X,_,_),
	not(neighbor(X,L)),
	findall(Z,convert(X,Z),L),
	assertz(neighbor(X,L)),
	fail.
edge2neighb.

convert(X,Z):-
	is_edge2(X,Y,W),
	Z=p(Y,W).

% ?- edge2neighb, listing(neighbor/2).





:-dynamic node/1.

collect([X|R]):-
	retract(node(X)),!, 
	collect(R).
collect([]).


%--------------------------------------------------
% DFS %
%--------------------------------------------------


edge3(a,b).
edge3(b,c).
edge3(c,a).
edge3(c,d).
% ...


is_edge3(X,Y):-
	edge3(X,Y);
	edge3(Y,X).

dfs(X,L):-
	assertz(node(X)),	% place start/current node as visited
	is_edge3(X,Y), 		% take first/next neighbor of current node X
	not(node(Y)), 		% if already visited, backtrack to take another; 
						% 	if not, continue from Y
	dfs(Y,L).
dfs(_,L):-
	collect(L). 		% similar to collect in findall, but on vert akb.


% ?- dfs(a, R), listing(node/1).


%--------------------------------------------------
% BFS %
%--------------------------------------------------
% Optimization strategy of SWI prolog - makes node(Y) backtracking to not detect new nodes added by assertz(node(Z)) -> it only finds the neighbours of the first node
% not wrong - just doesnt work
bfs_wrong(X,_):-
	assertz(node(X)), 	% add at the end of the Q the current node
	node(Y), 			% reads from front of Q (first time is first=X=ONLY one in Q) 
						% current Y (gets Y instantiated)
	is_edge3(Y,Z), 		% take first/next neighbor of current Y (gets Z instantiated); 
						% 	if none, backtrack and take next from Q
    not(node(Z)), 		% if Z already visited, backtrack to take another; 
	assertz(node(Z)), 	% if not, put Z in Q and
	fail.				% backtrack anyway to another neighbor of Y
bfs_wrong(_,L):-
	collect(L). 		% similar to collect in findall, but on node akb.


% ?- bfs_wrong(a, R), listing(node/1).
% It can only see the neighbours of the given node, does not go through all the graph.

%--------------------------------------------------
% BFS with Queue %
%--------------------------------------------------

% bfs /3 (+Queue, +ExpansionList, -Result).
bfs(Q,R,R):- var(Q),!.	% when Q is empty, end exe, the Exp becomes R 
bfs([X|Q],Exp,R):-		% else, take first from Q
	expand(X,Q,Exp),			% and expand (put all white neighbors in Q) and
	bfs(Q,[X|Exp],R).	% continue by moving it in expanded 						% = make it black



expand(X,_,Exp):-
	is_edge3(X,Z), 			% nondeterministically take Z,  first neighbor of X (eventually all of them)
	not(member(Z,Exp)),		% should NOT be already processed (=not  a black node)
	assertz(node(Z)), 		% potentially add it in Q
	fail. 					% backtrack to evaluate another neighbor of X
expand(_,Q,_):-
	collect1(Q).			% we get here, end


collect1(Q):-
	retract(node(X)),!,		% take X and if not under processing (not a grey one)
	insert_IL(X,Q),			% take one and if not under processing (not a grey one) add it in Q
	collect1(Q).			% continue. How is possible with the SAME argument?
collect1(_).				% end when akb empty



insert_IL(X,[X|_]):-!.
insert_IL(X,[_|L]):-
	insert_IL(X,L).

% ?- bfs([a|_],[],R). 
% for the first graph – search for a path