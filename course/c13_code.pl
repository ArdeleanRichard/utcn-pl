%--------------------------------------------------
% Hamiltonian cycle %
%--------------------------------------------------
edge(a,b,7).
edge(a,c,1).
edge(a,d,8).
edge(b,c,2).
edge(b,f,5).
edge(b,e,10).
edge(c,d,3).
edge(d,f,4).
edge(d,e,8).
edge(f,e,3).

is_edge(X,Y,W):-
	edge(X,Y,W);
	edge(Y,X,W).



% ?- hamilton(6,a,Cycle,Cost).

hamilton(N,X,Cycle,Cost):-
	N1 is N-1,
	try(N1,X,X,[X],0,Cycle,Cost).

try(N, X, Y, PPath, PCost, Cycle, Cost):-
    N > 0,
    N1 is N-1,
    is_edge(Y, Z, W),
    not(member(Z, PPath)),
    PCost1 is PCost + W,
    try(N1, X, Z, [Z|PPath], PCost1, Cycle, Cost). 
try(0, X, Y, PPath, PCost, [X|PPath], Cost):-
    is_edge(Y, X, W), 
    Cost is PCost + W.



%--------------------------------------------------
% Hamiltonian cycle with B&B %
%--------------------------------------------------
% searches for N nodes to end in X the way; put in Cand a path containing just one element: [n(X,0,0)] 
% start node X, estimated weight of hamilton EXi=0, number of nodes 0, NO parent. Expanded list empty.

% ?- hamilton(6, a, Path)
hamilton(N,X,Cycle):-
	search(N,X,[[n(X,0,0)]],[],Cycle).


% ?- search(6,a,[[n(a,0,0)]],[],Way).
search(N,_,_,[Cycle|_],Cycle):- 			% stop with path the way in front of Expanded
	Cycle=[n(_,N,_)|_],!. 					% if its length equals the number of nodes in graph
search(N,X,[C|Cands],Exp,Cycle):-
	expand(N,X,C,Cands,NewCands), 			% if not, expand best node so far = the element in front of current Cands
	search(N,X,NewCands,[C|Exp],Cycle). 	% and continue after expansion with the new Cands
% C is a candidate path (best) which is expanded from last node added (first in list)
% expand takes the best candidate path C and tries to find the next nodes
% from these next nodes, all are collected and they update Cand into NewCand


% 3rd arg is the best candidate list which is expanded, take first node (last added) and find neighbours
expand(N,X,[n(Y,Len,Fi)|Cy],_,_):-
	is_edge(Y,Z,W), 								% nondeterministically take Z,  first neighbor of Y (eventually all of them) and weight W
	(not(member_path(Z,Cy));(Len is N-1,Z=X)), 		% should NOT be already processed / just if it is the source
	FiW is Fi+W, Len1 is Len+1, 					% estimate the new parameters
	assertz(node(n(Z,Len1,FiW))),					% put it in the akb
	fail.											% backtrack to a new neighbor of Y 
expand(_,_,C,Cands,NewCands):-
	collect(C,Cands,NewCands).						% start collecting from akb and place in NewCands


member_path(X,[n(X,_,_)|_]). 						% checks if a node is in a list
member_path(X,[_|T]):- member_path(X,T).


% take the current best candidate list L, create a number of Lists that contain the next options and add them to candidate paths
collect(C,Cands,NewCands):- 				% L is the parent, a whole path. Is Y in Candidate from clause 2 in search
	retract(node(Node)),!,	 					% take top from akb 
	ins_ord_list([Node|C],Cands,IntCands),		% add in Cand with the whole path (+L, parent of path)
	collect(C,IntCands,NewCands).			% continue with the Intermediate Candidate 
collect(_,Cands,Cands).


ins_ord_list(X,[H|T],[H|R]):-				% in the right (ordered by Fi function) place in the list
	X = [n(_,_,Xfi)|_], H = [n(_,_,Yfi)|_], 
    Xfi>=Yfi,!,
    ins_ord_list(X, T, R).
ins_ord_list(X,L,[X|L]):-!. 				% adds an element