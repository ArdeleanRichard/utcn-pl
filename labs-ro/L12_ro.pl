%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 			LABORATORUL 12 EXEMPLE		%%%%%%
%%%%%% Algoritmi de traversare a grafurilor %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

edge(1,2).
edge(1,5).
edge(2,3).
edge(2,5).
edge(3,4).
edge(4,5).
edge(4,6).

is_edge(X,Y):- edge(X,Y);edge(Y,X).


%--------------------------------------------------
% Predicatul DFS %
%--------------------------------------------------
:- meta_predicate dfs(2, ?, ?).
:- dynamic nod_vizitat/1.

% dfs(+Graph, +Source, -Path)
dfs(G,X,_) :- df_search(G,X). 			% pas1. parcurgerea nodurilor
% când parcurgerea se termină, începe colectarea
dfs(_,_,R) :- !, collect(R). 			% pas2. colectarea rezultatelor

% predicatul de traversare
df_search(G,X):-
    % salvăm X ca nod vizitat
    assertz(nod_vizitat(X)),
    % luăm un prim edge de la X la Y, restul le vom găsi prin backtracking
    call(G, X, Y), 
    % verificăm daca acest Y a fost deja vizitat
    not(nod_vizitat(Y)),
    % dacă nu a fost -  de aceea avem nevoie de negare – 
   	% atunci vom continua parcurgerea prin mutarea nodululi curent la Y
    df_search(G,Y).

% predicatul de colectare - colectarea se face în ordine
collect([X|R]):- % îl adăugăm la lista ca primul element
    % scoatem fiecare nod vizitat
    retract(nod_vizitat(X)), !, 
    collect(R).
% rezultatul se construiește la întoarcere
collect([]).



% Urmărește execuția la:
% ?- dfs(is_edge,1,R).
% R = [1, 2, 3, 4, 5, 6].




%--------------------------------------------------
% Predicatul BFS %
%--------------------------------------------------
:- meta_predicate bfs(2, ?, ?).
:- dynamic nod_vizitat/1.
:- dynamic coada/1. 			% coada reține nodurile care trebuie expandate

% bfs(+Graph, +Source, -Path)
bfs(G,X, _):-      				% pas1. parcurgerea nodurilor
    assertz(nod_vizitat(X)), 	% adăugăm sursa ca nod vizitat
    assertz(coada(X)), 			% adăugăm sursa în coadă
    bf_search(G).
bfs(_,_,R):- !, collect(R). 	% pas2. colectarea rezultatelor

bf_search(G):-
    retract(coada(X)), 			% scoatem nodul care trebuie expandat
    expand(G,X), !, 			% apelăm predicatul de expansiune
    bf_search(G). 				% recursivitate
	
expand(G,X):-	
    call(G, X, Y), 				% găsim un nod Y cu o muchie la X-ul dat
    not(nod_vizitat(Y)), 		% verificăm daca Y a fost vizitat
	assertz(nod_vizitat(Y)), 	% adăugăm Y la nodurile vizitate
    assertz(coada(Y)), 			% adăugam Y în coadă pentru a fi expandat 
    							% la un moment dat
    fail. 						% fail-ul este necesar pentru a găsi un alt Y
expand(_,_).  



% Urmărește execuția la:
% ?- bfs(is_edge,1,R).
% R = [1, 2, 5, 3, 4, 6].


%--------------------------------------------------
% Predicatul BFS fara efecte laterale %
%--------------------------------------------------
:- meta_predicate bfs1(2, ?, ?).

neighbor(1, [2,5]).
neighbor(2, [1,3,5]).
neighbor(3, [2,4]).
neighbor(4, [3,5,6]).
neighbor(5, [1,2,4]).
neighbor(6, [4]).

% bfs1(+Graph, +Source, -Path)
bfs1(G, X, R) :-
    % bfs1(+Graph, +Queue, +Visited, -Path)
    bfs1(G, [X], [X], R).

bfs1(_, [], R, R).
bfs1(G, [X|Q], V, R):- 
    call(G, X, Ns), 					% Neighb = G(X, Ns)
    remove_visited(Ns, V, RemNs),
    append(V, RemNs, NewV),
    append(Q, RemNs, NewQ),
    bfs1(G, NewQ, NewV, R).

% este de fapt acelasi ca si predicatul difference/3 de la seturi
remove_visited([], _, []).
remove_visited([H|T], V, [H|R]):- \+member(H, V), !, remove_visited(T, V, R).
remove_visited([_|T], V, R):- remove_visited(T, V, R).


% Urmărește execuția la:
% ?- trace, bfs1(neighbor,1,R).
% R = [1, 2, 5, 3, 4, 6].





%--------------------------------------------------
% Predicatul Best-First Search %
%--------------------------------------------------
pos_vec(start,0,2,[a,d]).
pos_vec(a,2,0,[start,b]).
pos_vec(b,5,0,[a,c, end]).
pos_vec(c,10,0,[b, end]).
pos_vec(d,3,4,[start,e]).
pos_vec(e,7,4,[d]).
pos_vec(end,7,2,[b,c]).

is_target(end).



best([], []):-!.
best([[Target|Rest]|_], [Target|Rest]):- is_target(Target),!.
best([[H|T]|Rest], Best):-
	pos_vec(H,_,_, Neighb),
	expand(Neighb, [H|T], Rest, Exp),
	quick_sort(Exp, SortExp, []),
	best(SortExp, Best).

% Bazat pe calea curentă (al doilea argument), predicatul expand/4 
% caută prin vecinii ultimului nod expandat (primul argument) 
expand([],_,Exp,Exp):- !.
expand([H|T],Path,Rest,Exp):- 
	\+(member(H,Path)), !, expand(T,Path,[[H|Path]|Rest],Exp).
expand([_|T],Path,Rest,Exp):- expand(T,Path,Rest,Exp).

% Predicatul quick_sort/3 utilizează liste diferență
quick_sort([H|T],S,E):-
	partition(H,T,A,B),
	quick_sort(A,S,[H|Y]),
	quick_sort(B,Y,E).
quick_sort([],S,S).

% În acest caz, predicatul partition/4 folosește un predicat auxiliar
% order/2 care definește modul de a partiționa ca fiind 
% bazat pe distanțte
partition(H,[A|X],[A|Y],Z):- order(A,H), !, partition(H,X,Y,Z).
partition(H,[A|X],Y,[A|Z]):- partition(H,X,Y,Z).
partition(_,[],[],[]).

% predicat care calculează distanța între două noduri
dist(Node1,Node2,Dist):-
pos_vec(Node1, X1, Y1, _),
pos_vec(Node2, X2, Y2, _),
	Dist is (X1-X2)*(X1-X2)+(Y1-Y2)*(Y1-Y2).

% predicatul order/2 bazat pe distanțe folosit in partition/4
order([Node1|_],[Node2|_]):- 
is_target(Target),
	dist(Node1,Target,Dist1),
	dist(Node2,Target,Dist2),
	Dist1<Dist2.




% Urmărește execuția la:
% ?- best([[start]], Best).






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 				EXERCIȚII				%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------
% 1. Modificați predicatul DFS astfel încât să caute noduri numai până la o anumită adâncime (DLS – Depth-Limited Search). Setați limita de adâncime printr-un predicat, depth_max(2). de exemplu.
% ?- dfs(edge_ex1,a,DFS), dls(edge_ex1,a,DLS).
% DFS = [a, b, d, e, g, c, f, h],
% DLS = [a, b, d, c, f].

edge_ex1(a,b).
edge_ex1(a,c).
edge_ex1(b,d).
edge_ex1(d,e).
edge_ex1(c,f).
edge_ex1(e,g).
edge_ex1(f,h).

% dls(G, X, R):- % *IMPLEMENTAȚI AICI*
 
 
 
 
 
% 2. Având implementarea algoritmului BFS fără efecte laterale, modificați fără efecte laterale 
% astfel încât să funcționeze pe reprezentarea de edge în loc de reprezentarea de neighbor.
% ?- bfs(is_edge,1,R), bfs1(neighbor,1,R1), bfs2(is_edge,1,R2).
% R = R1 = R2 = [1, 2, 5, 3, 4, 6].

:- meta_predicate bfs2(2, ?, ?).



% bfs2(G, X, R):- % *IMPLEMENTAȚI AICI*








% 3. Scrieți implementarea algoritmului DFS fără efecte laterale pentru reprezentările de edge si neighbor.
% ?- dfs(is_edge,1,R), dfs1(neighbor,1,R1), dfs2(is_edge,1,R2).
% R = R1 = R2 = [1, 2, 3, 4, 5, 6].

:- meta_predicate dfs1(2, ?, ?).
:- meta_predicate dfs2(2, ?, ?).




% dfs1(G, X, R):- % *IMPLEMENTAȚI AICI*





% dfs2(G, X, R):- % *IMPLEMENTAȚI AICI*




