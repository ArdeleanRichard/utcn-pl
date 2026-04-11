%--------------------------------------------------
% findall %
%--------------------------------------------------

% findall1/3 (+CollectedVar, +CollectorPred, -CollectorVar). 	

findall1(X,G,_):- 	
	asserta(found(end)),	
	G,					

	asserta(found(X)),
	fail. 	
findall1(_,_,L):-			
	collect_found([],L). 	


collect_found(P,L):-
	retract(found(X)),	
	X\=end,!, 	
	collect_found([X|P],L). 
collect_found(L,L).


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
% this garbage works only if unoriented, and all are provided only with 'edge1(a,b).neighbor1(a,[b]).' it fails
edge1(a,b).
edge1(b,a).
neighbor1(a,[b]).
neighbor1(b,[a]).

not1(P):-
	P, !, fail.
not1(_).

member1(X, [X|_]).
member1(X, [_|T]):-member1(X, T).

is_neighbor1(X,Y):-		% to find all edges in G1, call nondeterminist(X,Y,free)
	neighbor1(X,L),		% finds first pair first (and next on backtrack), instantiates both X and L. 
	member1(Y,L).		% nondeterm call on member; instantiate Y, one at a time, eventually all.

is_edge1(X,Y):-
	edge1(X,Y);
	edge1(Y,X).

eq1:-
	is_neighbor1(X,Y),			% for each edge in the first representation
	not1(is_edge1(X,Y)),!, 	% there is one edge in the other graph 
	fail.		 			% otherwise we reach here, hence, fail.
eq1. 						% when we get here, G1=>G2 shown

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


%--------------------------------------------------
% DFS %
%--------------------------------------------------


edge3(a,b).
% ...

is_edge3(X,Y):-
	edge3(X,Y);
	edge3(Y,X).

dfs(X,_):-
	assertz(node(X)),	% place start/current node in Q
	is_edge3(X,Y), 		% take first/next neighbor of current node X
	not(node(Y)), 		% if already visited, backtrack to take another; 
						% 	if not, continue from Y
	dfs(Y,_).
dfs(_,L):-
	assertz(node(end)),
	collect2([],L). 		% similar to collect in findall, but on vert akb.


%--------------------------------------------------
% BFS %
%--------------------------------------------------

bfs(X,_):-
	assertz(node(X)), 	% add at the end of the Q the current node
	node(Y), 			% reads from front of Q (first time is first=X=ONLY one in Q) 
						% current Y (gets Y instantiated)
	is_edge3(Y,Z), 		% take first/next neighbor of current Y (gets Z instantiated); 
						% 	if none, backtrack and take next from Q
    not(node(Z)), 		% if Z already visited, backtrack to take another; 
	assertz(node(Z)), 	% if not, put Z in Q and
	fail.				% backtrack anyway to another neighbor of Y
bfs(_,L):-
	assertz(node(end)),
	collect2([],L). 		% similar to collect in findall, but on node akb.


collect1(P, L):-
	retract(node(X)),!, 
	collect2([X|P], L).
collect1(L, L).


collect2(P, L):-
    retract(node(X)), 
	X\=end, !,
	collect2([X|P], L).
collect2(L, L).

	.

%--------------------------------------------------
% BFS with Queue %
%--------------------------------------------------


% bfs /3 (+Queue, +ExpansionList, -Result).
bfs(Cand,Exp,Exp):-			% when Q is empty, end exe, the Exp becomes Rez
	var(Cand),!.
bfs([X|Cand],Exp,Rez):-		% else, take first from Q
	expand(X,Cand,Exp),				% and expand (put all white neighbors in Q) and
	bfs(Cand,[X|Exp],Rez).	% continue by moving it in expanded 						% = make it black


:-dynamic desc/1.

expand(X,_,Exp):-
	is_edge(X,Z,_), 		% nondeterministically take Z,  first neighbor of X (eventually all of them)
	not(member(Z,Exp)),		% should NOT be already processed (=not  a black node)
	assertz(desc(Z)), 		% potentially add it in Q
	fail. 					% backtrack to evaluate another neighbor of X
expand(_,Cand,_):-
	assertz(desc(end)),		% mark end of akb
	collect(Cand).

collect(Cand):-
	retract(desc(X)),		% take X and if not under processing (not a grey one)
	X\=end,	!,				% as long as akb not empty
	insert_IL(X,Cand),		% take one and if not under processing (not a grey one) add it in Q
	collect(Cand).			% continue. How is possible with the SAME argument?
collect(_).					% end when akb empty



insert_IL(X,[X|_]):-!.
insert_IL(X,[_|L]):-
	insert_IL(X,L).

% ?- bfs([a|_],[],Rez). 
% for the first graph – search for a path