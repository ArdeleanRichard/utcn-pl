%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 			LABORATORUL 3 EXEMPLE		%%%%%%
%%%%%% 			Operații pe liste			%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ?- [H|T]=[].
% ?- [H|T]=[1,2,3], X=3, L=[X|T].

%--------------------------------------------------
% Predicatul MEMBER %
%--------------------------------------------------
member1(X, [X|_]).
member1(X, [_|T]) :- member1(X, T).


% Urmărește execuția la:
% ?- trace, member1(3,[1,2,3,4]).
% ?- trace, member1(a,[a, b, c, a]).
% ?- trace, X=a, member1(X, [a, b, c, a]).
% ?- trace, member1(a, [1,2,3]).


%--------------------------------------------------
% Predicatul APPEND %
%--------------------------------------------------
append1([], L, L).
append1([H|T], L, [H|R]) :- append1(T, L, R).

% Urmărește execuția la:
% ?- trace, append1([a,b],[c,d],R).
% ?- trace, append1([1, [2]], [3|[4, 5]], R).
% ?- trace, append1(T, L, [1, 2, 3, 4, 5]).
% ?- trace, append1(_, [X|_], [1, 2, 3, 4, 5]).


%--------------------------------------------------
% Predicatul DELETE %
%--------------------------------------------------
% șterge prima apariție și se oprește
% altfel iterează peste elementele listei
% daca a ajuns la lista vida înseamnă că elementul nu a fost găsit
% și putem returna lista vidă
delete1(X, [X|T], T).
delete1(X, [H|T], [H|R]) :- delete1(X, T, R).
delete1(_, [], []).



% Urmărește execuția la:
% ?- trace, delete1(3, [1, 2, 3, 4], R).
% ?- trace, X=3, delete1(X, [3, 4, 3, 2, 1, 3], R).
% ?- trace, delete1(3, [1, 2, 4], R).
% ?- trace, delete1(X, [1, 2, 4], R).


%--------------------------------------------------
% Predicatul DELETE ALL %
%--------------------------------------------------
% dacă s-a șters prima apariție se va continua și pe restul elementelor
delete_all(X, [X|T], R) :- delete_all(X, T, R).
delete_all(X, [H|T], [H|R]) :- delete_all(X, T, R).
delete_all(_, [], []).


% Urmărește execuția la:
% ?- trace, delete_all(3, [1, 2, 3, 4], R).
% ?- trace, X=3, delete_all(X, [3, 4, 3, 2, 1, 3], R).
% ?- trace, delete_all(3, [1, 2, 4], R).
% ?- trace, delete_all(X, [1, 2, 4], R).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 				EXERCIȚII				%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------
% 1. Scrieți predicatul add_first(X,L,R) care adaugă X la începutul listei L și pune rezultatul în R. 
% Sugestie: simplificați pe cât de mult posibil acest predicat.
% ?- add_first(1,[2,3,4],R).
% R=[1,2,3,4].

% add_first(X,L,R). – adaugă X la începutul listei L și pune rezultatul în R

% add_first(X, L, R):- % *IMPLEMENTAȚI AICI*


%--------------------------------------------------
% 2. Scrieți predicatul append3/4 care să realizeze concatenarea a 3 liste. 
% Sugestie: Nu folosiți append-ul a două liste.
% ?- append3([1,2],[3,4,5],[6,7],R).
% R=[1,2,3,4,5,6,7] ;
% false.


% append3(L1,L2,L3,R). – va realiza concatenarea listelor L1,L2,L3 în R

% append3(L1,L2,L3,R):-  % *IMPLEMENTAȚI AICI*



%--------------------------------------------------
% 3. Scrieți un predicat care realizează suma elementelor dintr-o lista dată. 
% ?- sum_bwd([1,2,3,4], S).
% R=10.
% ?- sum_fwd([1,2,3,4], S).
% R=10.

% sum(L, S). – calculează suma elementelor din L și returnează suma în S

% sum_bwd(L, S):-  % *IMPLEMENTAȚI AICI*

% sum_fwd(L, S):-  % *IMPLEMENTAȚI AICI*




%--------------------------------------------------
% 4. Scrieți un predicat care separă numerele pare de cele impare. 
% (Întrebare: de ce avem nevoie pentru recursivitate înainte?)
% ?- separate_parity([1, 2, 3, 4, 5, 6], E, O).
% E = [2, 4, 6]
% O = [1, 3, 5] ;
% false


% separate_parity(L, E, O):-  % *IMPLEMENTAȚI AICI*



%--------------------------------------------------
% 5. Scrieți un predicat care să șteargă toate elementele duplicate dintr-o listă.
% ?- remove_duplicates([3, 4, 5, 3, 2, 4], R).
% R = [3, 4, 5, 2] ; % păstrează prima apariție
% false
% SAU
% ?- remove_duplicates([3, 4, 5, 3, 2, 4], R).
% R = [5, 3, 2, 4] ; % păstrează ultima apariție
% false


% remove_duplicates(L, R):-  % *IMPLEMENTAȚI AICI*




%--------------------------------------------------
% 6. Scrieți un predicat care să înlocuiască toate aparițiile lui X în lista L cu Y și să pună rezultatul în R.
% ?- replace_all(1, a, [1, 2, 3, 1, 2], R).
% R = [a, 2, 3, a, 2] ;
% false


% replace_all(X, Y, L, R):-  % *IMPLEMENTAȚI AICI*




%--------------------------------------------------
% 7. Scrieți un predicat care șterge tot al k-lea element din lista de intrare.
% ?- drop_k([1, 2, 3, 4, 5, 6, 7, 8], 3, R).
% R = [1, 2, 4, 5, 7, 8] ;
% false


% drop_k(L, K, R):-  % *IMPLEMENTAȚI AICI*





%--------------------------------------------------
% 8. Scrieți un predicat care șterge duplicatele consecutive fără a modifica ordinea elementelor din listă.
% Sugestie: căutați observația despre șablonul extins în Laboratorul 1.
% ?- remove_consecutive_duplicates([1,1,1,1, 2,2,2, 3,3, 1,1, 4, 2], R).
% R = [1,2,3,1,4,2] ;
% false


% remove_consecutive_duplicates(L, R):-  % *IMPLEMENTAȚI AICI*




%--------------------------------------------------
% 9. Scrieți un predicat care adăugă duplicatele consecutive într-o sub-listă fără a modifica ordinea elementelor din listă.
% ?- pack_consecutive_duplicates([1,1,1,1, 2,2,2, 3,3, 1,1, 4, 2], R).
% R = [[1,1,1,1], [2,2,2], [3,3], [1,1], [4], [2]];
% false


% pack_consecutive_duplicates(L, R):-  % *IMPLEMENTAȚI AICI*





