%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 			LABORATORUL 11 EXEMPLE		%%%%%%
%%%%%% Algoritmi de traversare a grafurilor %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

edge(a,b).
edge(a,c).
edge(b,d).
edge(d,e).
edge(c,f).
edge(e,g).
edge(f,h).


%--------------------------------------------------
% Predicatul DFS %
%--------------------------------------------------
:- dynamic nod_vizitat/1.

% d_search(Source, Path)
dfs(X,_) :- df_search(X). % parcurgerea nodurilor
% când parcurgerea se termină, începe colectarea
dfs(_,L) :- !, collect_reverse([], L). % colectarea rezultatelor

% predicatul de traversare
df_search(X):-
    % salvăm X ca nod vizitat
    asserta(nod_vizitat(X)),
    % luăm un prim edge de la X la un Y
    % restul le vom găsi prin backtracking
    edge(X,Y),
    % verificăm daca acest Y a fost deja vizitat
    not(nod_vizitat(Y)),
    % dacă nu a fost -  de aceea avem nevoie de negare – 
    % atunci vom continua parcurgerea prin mutarea nodululi curent la Y
    df_search(Y).

% predicatul de colectare - colectarea se face în ordine inversă
collect_reverse(L, P):-
    % scoatem fiecare nod vizitat
    retract(nod_vizitat(X)), !, 
    % îl adăugăm la lista ca primul element
    % astfel vor aparea în ordine inversă
    collect_reverse([X|L], P).
    % unificăm primul si al doilea argument, 
    % rezultatul va fi în al doilea argument
collect_reverse(L,L).



% Urmărește execuția la:
% ?- dfs(a,R).




%--------------------------------------------------
% Predicatul BFS %
%--------------------------------------------------
:- dynamic nod_vizitat/1.
:- dynamic coada/1. 	% coada reține nodurile care trebuie expandate

% b_search(Source, Path)
bfs(X, _):- % parcurgerea nodurilor
    assertz(nod_vizitat(X)), % adăugăm sursa ca nod vizitat
    assertz(coada(X)), % adăugăm sursa în coadă
    bf_search.
bfs(_,R):- !, collect_reverse([],R). % colectarea rezultatelor

bf_search:-
    retract(coada(X)), % scoatem nodul care trebuie expandat
    expand(X), !, % apelăm predicatul de expansiune
    bf_search. % recursivitate
	
expand(X):-	
    edge(X,Y), % găsim un nod Y cu o muchie la X-ul dat
    not(nod_vizitat(Y)), % verificăm daca Y a fost vizitat
    asserta(nod_vizitat(Y)), % adăugăm Y la nodurile vizitate
    assertz(coada(Y)), % adăugam Y în coadă pentru a fi expandat 
    % la un moment dat
    fail. % fail-ul este necesar pentru a găsi un alt Y
expand(_).  


% Urmărește execuția la:
% ?- bfs(a,R).



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
% ?- d_search(a,DFS), dl_search(a, DLS).
% DFS = [a, b, d, e, g, c, f, h],
% DLS = [a, b, d, c, f].

edge_ex1(a,b).
edge_ex1(a,c).
edge_ex1(b,d).
edge_ex1(d,e).
edge_ex1(c,f).
edge_ex1(e,g).
edge_ex1(f,h).

% dl_search(X, R):- % *IMPLEMENTAȚI AICI*
 