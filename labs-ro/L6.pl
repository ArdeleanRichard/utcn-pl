%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 			LABORATORUL 6 EXEMPLE		%%%%%%
%%%%%% 				Deep Lists				%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% L1 = [1,2,3,[4]]
% L2 = [[1],[2],[3],[4,5]]
% L3 = [[],2,3,4,[5,[6]],[7]]
% L4 = [[[[1]]],1,[1]]
% L5 = [1,[2],[[3]],[[[4]]],[5,[6,[7,[8,[9],10],11],12],13]]
% L6 = [alpha,2,[beta],[gamma,[8]]]

% Testați următoarele întrebări:
% ?- member(2,L5).
% ?- member([2], L5).
% ?- member(X, L5).
% ?- append(L1,R,L2).
% ?- append(L4,L5,R).
% ?- delete(1, L4,R).
% ?- delete(13,L5,R)


%--------------------------------------------------
% The ATOMIC predicate %
%--------------------------------------------------
% Testați următoarele întrebări:
% ? – atomic(apple).
% ? – atomic(4).
% ? – atomic(X).
% ? – atomic(apple(2)).
% ? – atomic([1,2,3]).
% ? – atomic([]).


%--------------------------------------------------
% Predicatul DEPTH %
%--------------------------------------------------

max(A, B, A):- A>B, !.
max(_, B, B).

depth([],1).
depth([H|T],R):- atomic(H), !, depth(T,R).
depth([H|T],R):- depth(H,R1), depth(T,R2), R3 is R1+1, max(R3,R2,R).


% Testați predicatul pentru listele L1-L6 de mai sus, de exemplu: 
% ?- depth(L1, R).



%--------------------------------------------------
% Predicatul FLATTEN %
%--------------------------------------------------

flatten([],[]).
flatten([H|T], [H|R]):- atomic(H), !, flatten(T,R).
flatten([H|T], R):- flatten(H,R1), flatten(T,R2), append(R1,R2,R).

% Testați predicatul pentru listele L1-L6 de mai sus, de exemplu: 
% ?- flatten(L1, R).


%--------------------------------------------------
% Predicatul HEADS %
%--------------------------------------------------

% Variant 1
skip([],[]).
skip([H|T],R):- atomic(H),!,skip(T,R).
skip([H|T],[H|R]):- skip(T,R).

% luăm primul element din fiecare listă,
% după trecem peste restul elementelor
% prin apelul predicatului skip, și apelăm recursiv pentru liste
heads1([],[]).
heads1([H|T],[H|R]):- atomic(H),!,skip(T,T1), heads1(T1,R).
heads1([H|T],R):- heads1(H,R1), heads1(T,R2),append(R1,R2,R).



% Variant 2
heads2([],[],_).
heads2([],[],_).
% dacă flag=1 atunci suntem la început de lista și putem extrage capul
% listei; în apelul recursiv setam flag=0
heads2([H|T],[H|R],1):- atomic(H), !, heads2(T,R,0).
% dacă flag=0 atunci nu suntem la primul element atomic și
% atunci continuam cu restul elementelor
heads2([H|T],R,0):- atomic(H), !, heads2(T,R,0).
% dacă am ajuns la aceasta clauza înseamnă că primul element nu este
% atomic și atunci trebuie să apelam recursiv și pe acest element
heads2([H|T],R,_):- heads2(H,R1,1), heads2(T,R2,0), append(R1,R2,R).
% un wrapper pentru predicatul heads
heads2(L,R):- heads2(L, R, 1).


% Testați predicatul pentru listele L1-L6 de mai sus, de exemplu: 
% ?- heads1(L1, R).
% ?- heads2(L1, R).


%--------------------------------------------------
% Predicatul MEMBER %
%--------------------------------------------------

% Variant 1
member1(X, L):- flatten(L,L1), member(X,L1).

% Variant 2
member2(H, [H|_]).
member2(X, [H|_]):- member1(X,H). % H is a list
member2(X, [_|T]):- member1(X,T).

% Testați următoarele întrebări:
% ?– member2(1,L1).
% ?– member2(4,L2).
% ?– member2([5,[6]], L3).
% ?– member2(X,L4).
% ?– member2(X,L6).
% ?– member2(14,L5).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 				EXERCIȚII				%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------
% 1. Scrieți predicatul count_atomic(L,R) care calculează numărul de elemente
% atomice din lista L (toate elementele atomice de la toate adâncimile).
% ?- count_atomic([1,[2],[[3]],[[[4]]],[5,[6,[7,[8,[9],10],11],12],13]], R).
% R = 13;
% false.


% count_atomic(L, R):-  % *IMPLEMENTAȚI AICI*




%--------------------------------------------------
% 2. Scrieți predicatul sum_atomic(L,R) care calculează suma elementelor
% atomice din lista L (toate elementele atomice de la toate adâncimile).
% ?- sum_atomic([1,[2],[[3]],[[[4]]]], R).
% R = 10;
% false.


% sum_atomic(L, R):-  % *IMPLEMENTAȚI AICI*




%--------------------------------------------------
% 3. Scrieți predicatul replace(X,Y,L,R) care înlocuiește pe X cu Y în lista adâncă
% L (la orice nivel de imbricare) și pune rezultatul în R.
% ?- replace(1, a, [[[[1,2], 3, 1], 4],1,2,[1,7,[[1]]]], R).
% R = [[[[a, 2], 3, a], 4], a, 2, [a, 7, [[a]]]];
% false.


% replace(X, Y, L, R):-  % *IMPLEMENTAȚI AICI*




%--------------------------------------------------
% 4. Scrieți predicatul lasts(L,R) care extrage elementele atomice de pe ultima poziție (imediat anterior ‘]’) din fiecare sublistă din L.
% ?- lasts([1,2,[3],[4,5],[6,[7,[9,10],8]]], R).
% R = [3,5,10,8] ;
% false.


% lasts(L, R):-  % *IMPLEMENTAȚI AICI*




%--------------------------------------------------
% 5. Înlocuiți fiecare secvență constantă de o anumită adâncime cu lungimea ei (făra să utilizați predicatul length/2).
% ? – len_con_depth([[1,2,3],[2],[2,[2,3,1],5],3,1],R).
% R = [[3],[1],[1,[3],1],2].


% len_con_depth(L, R):-  % *IMPLEMENTAȚI AICI*




%--------------------------------------------------
% 6. Înlocuiți fiecare secvență constantă de o anumită adâncime cu adâncimea ei (făra să utilizați predicatul depth/2).

% ? – depth_con_depth([[1,2,3],[2],[2,[2,3,1],5],3,1],R).
% R = [[1], [1], [1, [2], 1], 0].


% depth_con_depth(L, R):-  % *IMPLEMENTAȚI AICI*


%--------------------------------------------------
% 7. Modificați predicatul member2/2 pentru liste adânci astfel încât să fie
% determinist (în acest caz, deterministic se referă la faptul că predicatul va
% returna un singur răspuns – nu va exista opțiunea de next – este nevoie
% de multiple teste ale predicatului member_deterministic/2 cu input-uri
% variate pentru a verifica).
% ?- member_deterministic(1, [1,2,1]).
% true.
% ?- member_deterministic(1, [[1],2,1]).
% true.


% member_deterministic(X, L):-  % *IMPLEMENTAȚI AICI*



%--------------------------------------------------
% 8. Scrieți un predicat care să sorteze o listă adâncă în funcție de adâncimea
% fiecărui element. Dacă două elemente au aceeași adâncime atunci se vor
% compara în funcție de elementele atomice pe care le conțin.
% Sugestie:
% • L1 < L2, dacă L1 și L2 sunt liste, sau liste adânci, și dacă adâncimea
%	listei L1 este mai mică decât adâncimea listei L2.
% • L1 < L2, dacă L1 și L2 sunt liste, sau liste adânci cu adâncime egală,
%	toate elementele până la poziția k sunt egale, iar al k+1-lea element
% 	din lista L1 este mai mic decât al k+1-lea element din lista L (la
%	adâncimi egale, lista cu indexul mai mic sublistei care va da ultima
%	adâncime este considerat mai mare – ca în exemplu la comparația
%	dintre 5 și [5])
% ?- sort_depth([[[[1]]], 2, [5,[4],7], [[5],4], [5,[0,9]]], R).
% R = [2, [5,[0,9]], [[5],4], [5,[4],7], [[[1]]]] ;
% false


% sort_depth(L, R):-  % *IMPLEMENTAȚI AICI*
