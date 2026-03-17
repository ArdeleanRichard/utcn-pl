%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 			LABORATORUL 4 EXEMPLE		%%%%%%
%%%%%% 				The Cut					%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%--------------------------------------------------
% Predicatul MEMBER %
%--------------------------------------------------
member1(X, [X|_]) :- !.
member1(X, [_|T]) :- member1(X, T).


% Urmărește execuția la:
% ?- trace, member1(X,[1,2,3])
% ?- trace, X=3, member1(X, [3, 2, 4, 3, 1, 3]).
% ?- trace, member1(X, [3, 2, 4, 3, 1, 3]).



%--------------------------------------------------
% Predicatul DELETE %
%--------------------------------------------------
delete1(X, [X|T], T) :- !.
delete1(X, [H|T], [H|R]) :- delete1(X, T, R).
delete1(_, [], []).


% Urmărește execuția la:
% ?- trace, delete1(3,[4,3,2,3,1], R).
% ?- trace, delete1(X, [3, 2, 4, 3, 1, 3], R).



%--------------------------------------------------
% Predicatul LENGTH %
%--------------------------------------------------
% Varianta 1 (recursivitate înapoi)
len_bw([], 0).
len_bw([_|T], Len) :- len_bw(T, Lcoada), Len is 1+Lcoada.


% Varianta 2 (recursivitate înainte -> acumulator = al doilea argument)
len_fw([], Len, Len).
len_fw([_|T], Acc, Len) :- Acc1 is Acc + 1, len_fw(T, Acc1, Len).

% len_fw/2 = wrapper al predicatului len_fw/3 care folosește un acumulator
len_fw(L, R) :- len_fw(L, 0, R).


% Urmărește execuția la:
% ?- trace, len_bw([a, b, c, d], Len).
% ?- trace, len_bw([1, [2], [3|[4]]], Len).
% ?- trace, len_fw([a, b, c, d], 0, Res).
% ?- trace, len_fw([a, b, c, d], Len).
% ?- trace, len_fw([1, [2], [3|[4]]], Len).
% ?- trace, len_fw([a, b, c, d], 3, Len).





%--------------------------------------------------
% Predicatul REVERSE %
%--------------------------------------------------
% Varianta 1 (recursivitate înapoi)
rev_bw([], []).
rev_bw([H|T], R) :- rev_bw(T, Rtail), append1(Rtail, [H], R).

append1([], R, R).
append1([H|T], L, [H|R]) :- append1(T, L, R).



% Varianta 2 (recursivitate înainte –> acumulator = al doilea argument)
rev_fw([], R, R).
rev_fw([H|T], Acc, R) :- Acc1=[H|Acc], rev_fw(T, Acc1, R).

% rev_fw/2 = wrapper a predicatului rev_fw/3 care folosește un acumulator
rev_fw(L, R) :- rev_fw(L, [], R).

% În contrast cu acumulatoarele de până acum, aici avem operații cu liste,
% astfel va fi instanțiată cu o listă vidă



% Urmărește execuția la:
% ?- trace, rev_bw([a, b, c, d], R).
% ?- trace, rev_bw([1, [2], [3|[4]]], R).
% ?- trace, rev_fw([a, b, c, d], R).
% ?- trace, rev_fw([1, [2], [3|[4]]], R).
% ?- trace, rev_fw([a, b, c, d], [1, 2], R).





%--------------------------------------------------
% Predicatul MIN %
%--------------------------------------------------

% Varianta 1 (recursivitate înainte –> acumulator = al doilea argument)
min_fw([], Mp, M) :- M=Mp.
min_fw([H|T], Mp, M) :- H<Mp, !, min_fw(T, H, M).
min_fw([_|T], Mp, M) :- min_fw(T, Mp, M).

% Într-un mod similar, min_fw/2 este un wrapper.
min_fw([H|T], M) :- min_fw(T, H, M).

% În contrast cu acumulatoare folosite până acum pentru predicatul min_fw/3,
% acumulatorul (al doilea argument) va fi inițializat cu primul element



% Varianta 2 (recursivitate înapoi)
min_bw([H|T], M) :- min_bw(T, M), M<H, !.
min_bw([H|_], H).


% Urmărește execuția la:
% ?- trace, min_fw([], M).
% ?- trace, min_fw([3, 2, 6, 1, 4, 1, 5], M).
% ?- trace, min_bw([], M).
% ?- trace, min_bw([3, 2, 6, 1, 4, 1, 5], M).





%--------------------------------------------------
% Operații pe Seturi %
%--------------------------------------------------
% Prin folosirea predicatului member/2 și recursivitate, 
% putem verifica fiecare element (H) a listei L1 dacă este un element și a L2:
% 	Dacă este -> nu va fi adăugat în rezultatul R
% 	Altfel, îl adăugăm in R.

union([], L, L).
union([H|T], L2, R) :- member(H, L2), !, union(T, L2, R).
union([H|T], L2, [H|R]) :- union(T, L2, R).


% Urmărește execuția la:
% ?- trace, union([1,2,3], [4,5,6], R).
% ?- trace, union([1,2,5], [2,3], R).
% ?- trace, union(L1,[2,3,4],[1,2,3,4,5]).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 				EXERCIȚII				%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------
% 1. Scrieți predicatul intersect(L1,L2,R) care realizează intersecția între două mulțimi.
% Sugestie: Gândiți-vă la cum a fost implementat predicatul union. Rețineți – vom lua doar elementele care apar în ambele liste.
% Remember - take only the elements that appear in both lists.
% ?- intersect([1,2,3], [1,3,4], R).
% R = [1, 3] ;
% false


% intersect(L1, L2, R):-  % *IMPLEMENTAȚI AICI*



%--------------------------------------------------
% 2. Scrieți predicatul diff(L1,L2,R) care realizează diferența între două
% mulțimi (elementele care apar în prima mulțime și nu apar în a doua mulțime).
%Sugestie: Gândiți-vă la cum a fost implementat predicatul union și
% intersect. Rețineți – vom lua doar elementele care apar în prima listă și nu și in a doua
% ?- diff([1,2,3], [1,3,4], R).
% R = [2] ;
% false


% diff(L1, L2, R):-  % *IMPLEMENTAȚI AICI*




%--------------------------------------------------
% 3. Scrieți predicatele del_min(L,R) și del_max(L,R) care șterg toate aparițiile
% minimului, respectiva ale maximului din lista L.
% ?- del_min([1,3,1,2,1], R).
% R = [3, 2] ;
% false
% ?- del_max([3,1,3,2,3], R).
% R = [1, 2] ;
% false

delete_all(X, [X|T], R) :- delete_all(X, T, R).
delete_all(X, [H|T], [H|R]) :- delete_all(X, T, R).
delete_all(_, [], []).

% del_min(L, R):-  % *IMPLEMENTAȚI AICI*


% del_max(L, R):-  % *IMPLEMENTAȚI AICI*





%--------------------------------------------------
% Exercițiu greu: Încercați să implementați fiecare din aceste predicate folosind o singură traversare a listei (del_min1/2 și del_max1/2). 


% del_min1(L, R):-  % *IMPLEMENTAȚI AICI*


% del_max1(L, R):-  % *IMPLEMENTAȚI AICI*





%--------------------------------------------------
% 4. Scrieți un predicat care inversează ordinea elementelor dintr-o listă începând cu al K-lea element.
% ?- reverse_k([1, 2, 3, 4, 5], 2, R).
% R = [1, 2, 5, 4, 3] ;
% false





%--------------------------------------------------
% 5. Scrieți un predicat care codifică șirul de elemente folosind algoritmul RLE
% (Run-length encoding). Un șir de elemente consecutive și egale se vor
% înlocui cu perechi [element, număr de apariții].
% pair.
% ?- rle_encode([1, 1, 1, 2, 3, 3, 1, 1], R).
% R = [[1, 3], [2, 1], [3, 2], [1, 2]] ;
% false


% rle_encode(L, R):-  % *IMPLEMENTAȚI AICI*





%--------------------------------------------------
% Opțional. Puteți modifica acest predicat astfel încât dacă un element este
% singular (nu are valori consecutive egale), să păstram acel element în loc să adăugam o pereche?
% ?- rle_encode2([1, 1, 1, 2, 3, 3, 1, 1], R).
% R = [[1, 3], 2, [3, 2], [1, 2]] ;
% false


% rle_encode1(L, R):-  % *IMPLEMENTAȚI AICI*




%--------------------------------------------------
% 6. Scrieți un predicat care rotește o listă K poziții la dreapta.
% Sugestie: încercați să implementați rotate_left mai întâi, este mai ușor.
% ?- rotate_right([1, 2, 3, 4, 5, 6], 2, R).
% R = [5, 6, 1, 2, 3, 4] ;
% false


% rotate_right(L, K, R):-  % *IMPLEMENTAȚI AICI*




%--------------------------------------------------
% 7. Scrieți un predicat care extrage aleatoriu K element din lista L și le pune în lista rezultat R.
% Sugestie: folosiți predicatul predefinit random_between/3(min_value, max_value, result).
% ?- rnd_select([a, b, c, d, e, f, g, h], 3, R).
% R = [e, d, a] ;
% false


% rnd_select(L, K, R):-  % *IMPLEMENTAȚI AICI*



%--------------------------------------------------
% 8. Scrieți un predicat care decodifică șirul de elemente folosind algoritmul
% RLE (Run-length encoding). O pereche [element, număr de apariții] va fi
% înlocuită de un șir de elemente consecutive și egale. 
% ?- rle_decode([[1, 3], [2, 1], [3, 2], [1, 2]], R).
% R = [1, 1, 1, 2, 3, 3, 1, 1] ;
% false


% rle_decode(L, R):-  % *IMPLEMENTAȚI AICI*


