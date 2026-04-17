%--------------------------------------------------
% Graph isomorphism %
%--------------------------------------------------

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

%graph1([
%	n(a,[b]),
%	n(b,[c])
%]).



%graph2([
%	n(b,[a]),
%	n(a,[c])
%]).



:-dynamic p/2.

% VERSION 1
% ?- graph1(G1), graph2(G2), iso_graph1(G1,G2).

iso_graph1(L1,L2):-eq_perm1(L1,L2,eq_neighb2).

eq_perm1([H1|T1],L2,EQ):- 	% is the perm predicate
	delete(H2,L2,T2),		% with an equivalence predicate
	P=..[EQ,H1,H2],			% which is created here
	call(P),				% and called here
	eq_perm1(T1,T2,EQ).
eq_perm1([],[],_).

eq_neighb1(n(N1,L1),n(N2,L2)):- 	% 2 neighb pairs are equivalent
	eq_node1(N1,N2),				% if the nodes are equivalent
	eq_perm1(L1,L2,eq_node1). 	% and the neighb lists are equivalent

delete(X,[X|T],T).				% what if we add a cut here?
delete(X,[H|T],[H|R]):-
	delete(X,T,R).


:-dynamic p/2.

eq_node1(N1,N2):-	% if nodes N1 and N2 already form a pair in the akb
	p(N1,N2).		% the evaluation continues
eq_node1(N1,_):-		% if N1 forms a pair with some OTHER node
	p(N1,_),!,		% we get an inconsistency, so should NOT allow
 	fail.			% (N1,N2) form a pair, so, fail to backtrack
eq_node1(_,N2):-		% symmetric on N2
eq_node1(_,N2),!,
	fail.
eq_node1(N1,N2):-			% if you reach here, the is no inconsistency
	asserta(p(N1,N2)). 		% hence pair N1, N2 is a legitimate one.
eq_node1(N1,N2):-			% if at a later moment, although pair N1, N2 is a 	
    retract(p(N1,N2)),!, 	% legitimate one, the reasoning cannot 	
    fail.					% conclude, so remove it from the akb, and fail to 			
							% backtrack and resume execution 
							% WITHOUT the pair in the akb






% VERSION 2 - can obtain result
% ?- graph1(G1), graph2(G2), iso_graph2(G1,G2, R).
iso_graph2(L1,L2,Lout):-eq_perm2(L1,L2,eq_neighb2,[],Lout).

eq_perm2([H1|T1],L2,EQ,LI,LO):-	% same as in v1
	delete(H2,L2,T2),
	P=..[EQ,H1,H2,LI,Lint], 	% just that with args
	call(P),
	eq_perm2(T1,T2,EQ,Lint,LO).
eq_perm2([],[],_,L,L).

eq_neighb2(n(N1,L1),n(N2,L2),LI,LO):-
	eq_node2(N1,N2,LI,Lint), 
	eq_perm2(L1,L2,eq_node2,Lint,LO).

eq_node2(N1,N2,LI,LI):-
	member(p(N1,N2),LI),!.
eq_node2(N1,N2,LI,[p(N1,N2)|LI]):-
	not(member(p(N1,_),LI)),
	not(member(p(_,N2),LI)).




% VERSION 3
% ?- graph1(G1), graph2(G2), iso_graph3(G1,G2, R).
iso_graph3(L1,L2,Lout):-eq_perm3(L1,L2,eq_neighb3,Lout).

eq_perm3([H1|T1],L2,EQ,LO):-	% same as in v1
	delete(H2,L2,T2),
	P=..[EQ,H1,H2,LO], 	% just that with args
	call(P),
	eq_perm3(T1,T2,EQ,LO).
eq_perm3([],[],_,_).

eq_neighb3(n(N1,L1),n(N2,L2),LO):-
	eq_node3(N1, N2, LO),
	eq_perm3(L1,L2,eq_node3,LO).


eq_node3(N1,N2,[p(N1,N2)|_]):-!.
eq_node3(N1,_,[p(N1,_)|_]):-
	!,
	fail.
eq_node3(_,N2,[p(_,N2)|_]):-
	!,
	fail.
eq_node3(N1,N2,[_|T]):-
	eq_node3(N1,N2,T).




% VERSION 4 - can obtain result
% ?- graph1(G1), graph2(G2), iso_graph4(G1,G2, R).
iso_graph4(L1,L2,Lout):-eq_perm4(L1,L2,eq_neighb4,Lout).

eq_perm4([H1|T1],L2,EQ,LO):-	% same as in v1
	delete(H2,L2,T2),
	P=..[EQ,H1,H2,LO], 			% just that with args
	call(P),
	eq_perm4(T1,T2,EQ,LO).
eq_perm4([],[],_,_).

eq_neighb4(n(N1,L1),n(N2,L2),LO):-
	eq_node4(N1, N2, LO),
	eq_perm4(L1,L2,eq_node4,LO).

member_il(_, L):- var(L), !, fail.
member_il(X, [X|_]):- !.
member_il(X, [_|T]):- member_il(X, T).

eq_node4(N1,N2,LI):-
	member_il(p(N1,N2),LI),!.
eq_node4(N1,N2,[p(N1,N2)|LI]):-
	not(member_il(p(N1,_),LI)),
	not(member_il(p(_,N2),LI)).





