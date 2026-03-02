%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 			LABORATORUL 9 EXEMPLE		%%%%%%
%%%%%%   			Difference Lists  		%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------
%--------------------------------------------------
% LISTS %
%--------------------------------------------------
%--------------------------------------------------

%--------------------------------------------------
% Predicatul ADD %
%--------------------------------------------------

% For complete lists
add_cl(X, [H|T], [H|R]):- add_cl(X, T, R).
add_cl(X, [], [X]).

% For difference lists
add_dl(X, LS, LE, RS, RE):- RS = LS, LE = [X|RE].

add_dl2(X,LS,[X|RE],LS,RE). % *SIMPLIFICAT

% Urmărește execuția la:
% ? - trace, LS=[1,2,3,4|LE], add_dl2(5,LS,LE,RS,RE).
% LE = [5|RE],
% LS = RS, RS = [1, 2, 3, 4, 5|RE]

%--------------------------------------------------
% Predicatul APPEND %
%--------------------------------------------------
append_dl(LS1, LE1, LS2,LE2, RS,RE):- RS=LS1, LE1=LS2, RE=LE2.

% Urmărește execuția la:
% ? - trace, LS1=[1,2,3,4|LE1], LS2=[5,6,7,8|LE2], append_dl(LS1, LE1, LS2, LE2, RS, RE).
% LE1 = LS2, LS2 = [5, 6, 7, 8|RE],
% LE2 = RE,
% LS1 = RS, RS = [1, 2, 3, 4, 5, 6, 7, 8|RE]



%--------------------------------------------------
% Predicatul QUICK SORT %
%--------------------------------------------------
% H is pivot, Sm = smaller than pivot, Lg = greater than pivot
partition(H, [X|T], [X|Sm], Lg):-X<H, !, partition(H, T, Sm, Lg).
partition(H, [X|T], Sm, [X|Lg]):-partition(H, T, Sm, Lg).
partition(_, [], [], []).

quicksort_dl([H|T], S, E):- % s-a adăugat un parametru nou
	partition(H, T, Sm, Lg), % predicatul partition a rămas la fel
	quicksort_dl(Sm, S, [H|L]), %concatenare implicită
	quicksort_dl(Lg, L, E).
quicksort_dl([], L, L). % condiția de oprire s-a modificat

% Urmărește execuția la:
% ?- trace, quicksort_dl([4,2,5,1,3], L, []).
% ?- trace, quicksort_dl([4,2,5,1,3], L, _).







%--------------------------------------------------
%--------------------------------------------------
% ARBORI %
%--------------------------------------------------
%--------------------------------------------------

%TREE
tree1(t(6, t(4, t(2, nil, nil), t(5, nil, nil)), t(9, t(7, nil, nil), nil))).


%--------------------------------------------------
% Predicatul INORDER %
%--------------------------------------------------

% For complete lists
inorder(t(K,L,R),List):-
	inorder(L,ListL),
	inorder(R,ListR),
	append(ListL,[K|ListR],List).
inorder(nil,[]).

% For difference lists
% când ajungem la finalul arborelui, unificăm începutul și finalul listei
% parțiale de rezultat - lista vidă este reprezentată de 2 variabile egale
inorder_dl(nil,L,L). 
inorder_dl(t(K,L,R),LS,LE):-
    % obtinem începutul și finalul listelor pentru subarborele stâng și drept
    inorder_dl(L,LSL,LEL), 
    inorder_dl(R,LSR,LER), 
    % începutul listei rezultat este începutul listei subarborelui stâng
    LS=LSL, 
    % cheia K este adăugat între finalul din stânga și începutul din dreapta
    LEL=[K|LSR], 
    % finalul listei rezultat este finalul listei subarborelui drept
    LE=LER.


% Testați următoarele întrebări:
% ? - trace, tree1(T), inorder_dl(T,L,[]).
% ? - trace, tree1(T), inorder_dl(T,L,_).

% *simplificat 
inorder_dl2(nil,L,L).
inorder_dl2(t(K,L,R),LS,LE):-
	inorder_dl2(L,LS,[K|LT]), 
	inorder_dl2(R,LT,LE).
	






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 				EXERCIȚII				%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Arbori:
complete_tree(t(6, t(4,t(2,nil,nil),t(5,nil,nil)), t(9,t(7,nil,nil),nil))).
incomplete_tree(t(6, t(4,t(2,_,_),t(5,_,_)), t(9,t(7,_,_),_))).


% Scrieți un predicat care:
%--------------------------------------------------
% 1. Convertește o listă completă într-o listă diferență și viceversa.
% ?- convertCL2DL([1,2,3,4], LS, LE).
% LS = [1, 2, 3, 4|LE]
% ?- LS=[1,2,3,4|LE], convertDL2CL(LS,LE,R).
% R = [1, 2, 3, 4]


% convertCL2DL(L, LS, LE):- % *IMPLEMENTAȚI AICI*

% convertDL2CL(LS, LE, R):- % *IMPLEMENTAȚI AICI*


%--------------------------------------------------
% 2. Convertește o listă incompletă într-o listă diferență și viceversa.
% ?- convertIL2DL([1,2,3,4|_], LS, LE).
% LS = [1, 2, 3, 4|LE]
% ?- LS=[1,2,3,4|LE], convertDL2IL(LS,LE,R).
% R = [1, 2, 3, 4|_]


% convertIL2DL(L, LS, LE):- % *IMPLEMENTAȚI AICI*

% convertDL2IL(LS, LE, R):- % *IMPLEMENTAȚI AICI*



%--------------------------------------------------
% 3. Aplatizează o listă adâncă folosind liste diferență în loc de append.
% ?- flat_dl([[1], 2, [3, [4, 5]]], RS, RE).
% RS = [1, 2, 3, 4, 5|RE] ;
% false


% flat_dl(L, RS, RE):- % *IMPLEMENTAȚI AICI*





%--------------------------------------------------
% 4. Traversează un arbore în pre-ordine și încă unul pentru post-ordine folosind liste diferență în manieră implicită.
% ?- complete_tree(T), preorder_dl(T, S, E).
% S = [6, 4, 2, 5, 9, 7|E]
% ?- complete_tree(T), postorder_dl(T, S, E).
% S = [2, 5, 4, 7, 9, 6|E]


% preorder_dl(t(K,L,R), S, E):- % *IMPLEMENTAȚI AICI*

% postorder_dl(t(K,L,R), S, E):- % *IMPLEMENTAȚI AICI*



%--------------------------------------------------
% 5. Colectează toate nodurile care au chei pare, dintr-un arbore binar complet folosind liste diferență.
% ?- complete_tree(T), even_dl(T, S, E).
% S = [2, 4, 6|E]


% even_dl(t(K,L,R), S, E):- % *IMPLEMENTAȚI AICI*



%--------------------------------------------------
% 6. Colectează toate nodurile care au chei între K1 și K2, dintr-un arbore binar
% de căutare incomplet folosind liste diferență.
% ?- incomplete_tree(T), between_dl(T, S, E, 3, 7).
% S = [4, 5, 6|E]


% between_dl(t(K,L,R), S, E):- % *IMPLEMENTAȚI AICI*




%--------------------------------------------------
% 7. Colectează toate cheile de la o adâncime dată K, dintr-un arbore binar de
% căutare incomplet folosind liste diferență.
% ? – incomplete_tree(T), collect_depth_k(T, 2, S, E).
% S = [4, 9|E].

    
% collect_depth_k(t(K,L,R), S, E):- % *IMPLEMENTAȚI AICI*