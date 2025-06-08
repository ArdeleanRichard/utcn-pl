% ?- for_all_is_true(member(Char, ['a','b','c']), char_type(Char, lower)).
% ?- for_all_is_true(member(Char, ['a','B','c']), char_type(Char, lower)).
for_all_is_true(X,Y):-
	X,
	not(Y),!, 
	fail. 
for_all_is_true(_,_). 





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










edge2(a, b, 15).
is_edge2(X,Y,W):-
	edge2(X,Y,W);
	edge2(Y,X,W).

:-dynamic neighbor/2.

gen_graph2:-
	is_edge2(X,_,_),
	not(neighbor(X,L)),
	findall(Z,succ(X,Z),L),
	assertz(neighbor(X,L)),
	fail.
gen_graph2.

succ(X,Z):-
	is_edge2(X,Y,W),
	Z=p(Y,W).

% ?- gen_graph2, listing(neighbor/2).










:-dynamic node/1.

edge3(a,b).
% ...

is_edge3(X,Y):-
	edge3(X,Y);
	edge3(Y,X).

df_search(X,_):-
	assertz(node(X)),	% place start/current node in Q
	is_edge3(X,Y), 		% take first/next neighbor of current node X
	not(node(Y)), 		% if already visited, backtrack to take another; 
						% 	if not, continue from Y
	df_search(Y,_).
df_search(_,L):-
	assertz(node(end)),
	collect2([],L). 		% similar to collect in findall, but on vert akb.




bf_search(X,_):-
	assertz(node(X)), 	% add at the end of the Q the current node
	node(Y), 			% reads from front of Q (first time is first=X=ONLY one in Q) 
						% current Y (gets Y instantiated)
	is_edge3(Y,Z), 		% take first/next neighbor of current Y (gets Z instantiated); 
						% 	if none, backtrack and take next from Q
    not(node(Z)), 		% if Z already visited, backtrack to take another; 
	assertz(node(Z)), 	% if not, put Z in Q and
	fail.				% backtrack anyway to another neighbor of Y
bf_search(_,L):-
	assertz(node(end)),
	collect2([],L). 		% similar to collect in findall, but on node akb.


collect1(P, L):-
	retract(node(X)),!, 
	collect2([X|P], L).
collect1(L, L).


collect2(P, L):-
    get_next(X), !,
	collect2([X|P], L).
collect2(L, L).

get_next(X):-
	retract(node(X)),!, X\=end.







graph1([
	n(a,[b,c,d]),
	n(b,[a,c]),
	n(c,[a,b,d]),
	n(d,[a,c])
]).



graph2([
	n(1,[2,4]),
	n(2,[1,3,4]),
	n(3,[2,4]),
	n(4,[1,2,3])
]).



% VERSION 1
% ?- graph1(G1),graph2(G2),iso_graph1(G1,G2).

iso_graph1(L1,L2):-eq_perm(L1,L2,eq_neighb).

eq_perm([H1|T1],L2,EQ):- 	% is the perm predicate
	delete(H2,L2,T2),		% with an equivalence predicate
	P=..[EQ,H1,H2],			% which is created here
	call(P),				% and called here
	eq_perm(T1,T2,EQ).
eq_perm([],[],_).

eq_neighb(n(N1,L1),n(N2,L2)):- 	% 2 neighb pairs are equivalent
	eq_node(N1,N2),				% if the nodes are equivalent
	eq_perm(L1,L2,eq_node). 	% and the neighb lists are equivalent

delete(X,[X|T],T).				% what if we add a cut here?
delete(X,[H|T],[H|R]):-
	delete(X,T,R).

:-dynamic p/2.

eq_node(N1,N2):-	% if nodes N1 and N2 already form a pair in the akb
	p(N1,N2).		% the evaluation continues
eq_node(N1,_):-		% if N1 forms a pair with some OTHER node
	p(N1,_),!,		% we get an inconsistency, so should NOT allow
 	fail.			% (N1,N2) form a pair, so, fail to backtrack
eq_node(_,N2):-		% symmetric on N2
	p(_,N2),!,
	fail.
eq_node(N1,N2):-			% if you reach here, the is no inconsistency
	asserta(p(N1,N2)). 		% hence pair N1, N2 is a legitimate one.
eq_node(N1,N2):-			% if at a later moment, although pair N1, N2 is a 	
    retract(p(N1,N2)),!, 	% legitimate one, the reasoning cannot 	
    fail.					% conclude, so remove it from the akb, and fail to 			
							% backtrack and resume execution 
							% WITHOUT the pair in the akb






% VERSION 2 - can obtain result
% ?- graph1(G1),graph2(G2),iso_graph2(G1,G2, R).
iso_graph2(L1,L2,Lout):-eq_perm(L1,L2,eq_neighb,[],Lout).

eq_perm([H1|T1],L2,EQ,LI,LO):-	% same as in v1
	delete(H2,L2,T2),
	P=..[EQ,H1,H2,LI,Lint], 	% just that with args
	call(P),
	eq_perm(T1,T2,EQ,Lint,LO).
eq_perm([],[],_,L,L).

eq_neighb(n(N1,L1),n(N2,L2),LI,LO):-
	eq_node(N1,N2,LI,Lint), 
	eq_perm(L1,L2,eq_node,Lint,LO).

eq_node(N1,N2,LI,LI):-
	member(p(N1,N2),LI),!.
eq_node(N1,N2,LI,[p(N1,N2)|LI]):-
	not(member(p(N1,_),LI)),
	not(member(p(_,N2),LI)).




% VERSION 3
% ?- graph1(G1),graph2(G2),iso_graph3(G1,G2, R).
iso_graph3(L1,L2,Lout):-eq_perm(L1,L2,eq_neighb,Lout).

eq_perm([H1|T1],L2,EQ,LO):-	% same as in v1
	delete(H2,L2,T2),
	P=..[EQ,H1,H2,LO], 	% just that with args
	call(P),
	eq_perm(T1,T2,EQ,LO).
eq_perm([],[],_,_).

eq_neighb(n(N1,L1),n(N2,L2),LO):-
	eq_node(N1, N2, LO),
	eq_perm(L1,L2,eq_node,LO).


eq_node(N1,N2,[p(N1,N2)|_]):-!.
eq_node(N1,_,[p(N1,_)|_]):-
	!,
	fail.
eq_node(_,N2,[p(_,N2)|_]):-
	!,
	fail.
eq_node(N1,N2,[_|T]):-
	eq_node(N1,N2,T).
