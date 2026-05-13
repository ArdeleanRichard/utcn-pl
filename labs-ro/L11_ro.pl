%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 			LABORATORUL 11 EXEMPLE		%%%%%%
%%%%%% 					Graphs 				%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%--------------------------------------------------
% The GRAPH REPRESENTATIONS %
%--------------------------------------------------
% A1B2
node1(a). 
node1(b). %etc

edge1(a,b). 
edge1(b,a).
edge1(b,c). 
edge1(c,b). %etc

is_edge1(X,Y):- edge1(X,Y); edge1(Y,X).


% A2B2
neighbor1(a, [b, d]).
neighbor1(b, [a, c, d]).
neighbor1(c, [b, d]). %etc.



%--------------------------------------------------
% Predicatul de conversie între reprezentări de grafuri %
%--------------------------------------------------
% declarăm predicatul dinamic pentru a putea folosi retract
:-dynamic neighbor/2.
% predicatul neighbor este considerat a fiind static deoarece este introdus
% în fișier, doar prin adăugarea declarației de dinamicitate ne este permis
% să folosim operația de retract asupra lui


% un exemplu de graf – prima componentă conexă a grafului
neighbor(a, [b, d]).
neighbor(b, [a, c, d]).
neighbor(c, [b, d]).
%etc.

neighb_to_edge:-
    %extrage un predicat neighbor 
    retract(neighbor(Node,List)),!, 
    % și apoi îl procesează
    process(Node,List),
    neighb_to_edge.
neighb_to_edge. % dacă nu mai sunt predicate neighbor/2, ne oprim

% procesarea presupune adăugarea de predicate edge și node 
% pentru un predicat neighbor, prima dată adăugăm muchiile 
% până când lista devine vidă iar abia apoi predicatele de tip node
process(Node, [H|T]):- assertz(gen_edge(Node, H)), process(Node, T).
process(Node, []):- assertz(gen_node(Node)).



% Testați următoarele întrebări:
% ?- neighb_to_edge.
% true;
% false.

% Încercați:
% ?- retractall(gen_edge(_,_)), neighb_to_edge, listing(gen_edge/2).


% Varianta 2, folosind failure-driven loops
neighb_to_edge_v2:-
    neighbor(Node,List), % access the fact
    process(Node,List),
    fail.
neighb_to_edge_v2.



% Variant 3, recursivitate fara retract
:-dynamic seen/1. 

neighb_to_edge_v3:-
    neighbor(Node,List), 
    not(seen(Node)),!,
    assert(seen(Node)),
    process(Node,List),
    neighb_to_edge_v3.
neighb_to_edge_v3. 


%--------------------------------------------------
% Predicatul PATH %
%--------------------------------------------------
edge(a,c).
edge(b,c).
edge(c,d).
edge(d,e).
edge(c,e).

% path(Source, Target, Path)
% drumul parțial începe cu nodul sursă – acesta este un wrapper
path(X, Y, Path):-path(X, Y, [X], Path). 

% când sursa (primul argument) este egal cu destinația (al doilea argument),
% atunci știm că drumul a ajuns la final 
% și putem unifica drumul parțial cu cel final
path(Y, Y, PPath, PPath).			
path(X, Y, PPath, FPath):-
    edge(X, Z), 				% căutăm o muchie
    not(member(Z, PPath)), 		% care nu a mai fost parcursă
    path(Z, Y, [Z|PPath], FPath).	          % și o adăugăm în rezultatul parțial


	
% Urmărește execuția la:
% ?- trace, trace, path(a,c,R).




%--------------------------------------------------
% Predicatul RESTRICTED PATH %
%--------------------------------------------------
% restricted_path(Source, Target, RestrictionsList, Path)
restricted_path(X,Y,LR,P):- 
    path(X,Y,P), 
    reverse(P,PR), 
    check_restrictions(LR, PR).

% predicate that verifies the restrictions
check_restrictions([],_):- !.
check_restrictions([H|TR], [H|TP]):- !, check_restrictions(TR,TP).
check_restrictions(LR, [_|TP]):-check_restrictions(LR,TP).



% Urmărește execuția la:
% ?- trace, check_restrictions([2,3], [1,2,3,4]).
% ?- trace, check_restrictions([1,3], [1,2,3,4]).
% ?- trace, check_restrictions([1,3], [1,2]).
% ?- trace, restricted_path(a, c, [a,c,d], R).


%--------------------------------------------------
% Predicatul OPTIMAL PATH %
%--------------------------------------------------

edge_o(a,c).
edge_o(b,c).
edge_o(c,d).
edge_o(d,e).
edge_o(c,e).
edge_o(a,b).
edge_o(b,e).

:- dynamic sol_part/2.

% optimal_path(Source, Target, Path)
optimal_path(X,Y,Path):-
    asserta(sol_part([], 100)), 	% 100 = distanța maximă inițială
    path(X, Y, [X], Path, 1).		
optimal_path(_,_,Path):- 
    retract(sol_part(Path,_)).

% path(Source, Target, PartialPath, FinalPath, PathLength)
% când ținta este egală cu sursa, salvăm soluția curentă
path(Y,Y,Path,Path,LPath):-	
    % scoatem ultima soluție	
    retract(sol_part(_,_)),!, 	
    % salvăm soluția curentă	
    asserta(sol_part(Path,LPath)),	
    % căutăm o altă soluție
    fail.						
path(X,Y,PPath,FPath,LPath):-
    edge(X,Z),
    not(member(Z,PPath)),
    % calculăm distanța parțială
    LPath1 is LPath+1,	
    % extragem distanța de la soluția precedentă		
    sol_part(_,Lopt),
    % dacă distanța curentă nu depășește distanța precedentă 
    LPath1<Lopt,	
    % mergem mai departe				
    path(Z,Y,[Z|PPath],FPath,LPath1).



% Urmărește execuția la:
% ?- trace, optimal_path(a,c,R).


%--------------------------------------------------
% A better implementation of paths %
%--------------------------------------------------

% Ordinea drumului este corecta acum (nu este inversat)
path1(X, Y, Path):- path1(X, Y, [X], Path). 

path1(Y, Y, _, []).			
path1(X, Y, PPath, [Z|FPath]):-
    edge(X, Z), 				
    not(member(Z, PPath)), 		
    path1(Z, Y, [Z|PPath], FPath).	          




% Acum putem aplica path pe orice graph
% meta_predicate indica ca primul argument al path1/4 este un predicat in sine cu 2 argumente
:- meta_predicate path1(2, ?, ?, ?).

path2(Graph, X, Y, Path):- path2(Graph, X, Y, [X], Path). 

path2(_, Y, Y, _, [Y]).			
path2(G, X, Y, PPath, [X|FPath]):-
    call(G, X, Z),					% apelam G(X,Z)
    not(member(Z, PPath)), 		
    path2(G, Z, Y, [Z|PPath], FPath).         

% Urmărește execuția la:
% ?- trace, path2(edge, a, c, P).    





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 				EXERCIȚII				%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------
% Fiecare exercițiu are alocat propriul său graf. Așadar, în implementarea ta ar trebui să 
% folosești muchiile acelui graf. De exemplu, când rezolvi Exercițiul 1, predicatul ar trebui să apeleze edge_ex1/2.


%--------------------------------------------------
% 1. Rescrie optimal_path/3 astfel încât să funcționeze pe grafuri ponderate:
% atașați o pondere pentru fiecare muchie din graf și calculați drumul de cost
% minim dintr-un nod sursă la un nod destinație.
% ?- optimal_weighted_path(a, e, P).
% P = [e, b, a]

edge_ex1(a,c,7).
edge_ex1(a,b,10).
edge_ex1(c,d,3).
edge_ex1(b,e,1).
edge_ex1(d,e,2).

% opt_weight_path(a, e, P):- % *IMPLEMENTAȚI AICI*



% 2. Continuă implementarea la ciclul Hamiltonian folosind predicatul hamilton/3.

% ?- hamilton(5, a, P).
% P = [a, e, d, c, b, a]

edge_ex2(a,b).
edge_ex2(b,c).
edge_ex2(a,c).
edge_ex2(c,d).
edge_ex2(b,d).
edge_ex2(d,e).
edge_ex2(e,a).



% hamilton(NumOfNodes, Source, Path)
hamilton(NN, X, Path):- 
    NN1 is NN-1, 
    hamilton_path(NN1, X, X,[X],Path).

% *IMPLEMENTAȚI AICI*




%--------------------------------------------------
% 3. Scrieți predicatul euler/3 care poate să găsească drumuri Euleriane într-un graf dat de la un nod dat. 
% ?- euler(5, a, R).
% R = [[b, a], [e, b], [d, e], [c, d], [a, c]];
% R = [[c, a], [d, c], [e, d], [b, e], [a, b]]

edge_ex3(a,b).
edge_ex3(b,e).
edge_ex3(c,a).
edge_ex3(d,c).
edge_ex3(e,d).


% euler(NE, X, Path):- % *IMPLEMENTAȚI AICI*






%--------------------------------------------------
% 4. Scrie predicatul cycle(X,R) care găsește un ciclu ce pornește din nodul X dintrun graf G 
% (folosind reprezentarea edge/2) și pune rezultatul în R. Predicatul trebuie să returneze toate 
% ciclurile prin backtracking. În plus, predicatul trebuie să primească predicatul edge 
% care definește graful ca și input (sugestie: predicatul call/n).
% ?- cycle(edge_ex4, a, R).
% R = [a,d,b,a] ;
% R = [a,e,c,a] ;
% false

edge_ex4(a,b).
edge_ex4(a,c).
edge_ex4(c,e).
edge_ex4(e,a).
edge_ex4(b,d).
edge_ex4(d,a).



% cycle(G, X,Path):- % *IMPLEMENTAȚI AICI*






%--------------------------------------------------
% 5. Scrieți predicatul cycle(X,R) din exercițiul anterior folosind reprezentarea neighbour/2. 
% În plus, predicatul trebuie să primească predicatul neighb care definește graful ca și input 
% (sugestie: predicatul call/n).
% ?- cycle_neighb(neighb_ex5, a, R).
% R = [a,d,b,a] ;
% R = [a,e,c,a] ;
% false

neighb_ex5(a, [b,c]).
neighb_ex5(b, [d]).
neighb_ex5(c, [e]).
neighb_ex5(d, [a]).
neighb_ex5(e, [a]).



% cycle_neighb(G, X,Path):- % *IMPLEMENTAȚI AICI*






%--------------------------------------------------
% 6. Scrieți un predicat care convertește din A1B2 (edge-clause) în A2B2 (neighbor list-clause).
% ?- retractall(gen_neighb_list(_,_)), edge_to_neighb, listing(gen_neighb_list/2).
% true

edge_ex6(a,b).
edge_ex6(a,c).
edge_ex6(b,d).

:- dynamic gen_neighb/2.

% edge_to_neighb:- % *IMPLEMENTAȚI AICI*






%--------------------------------------------------
% 7. Predicatul restricted_path/4 găsește un drum între nodul sursă și cel
% destinație și verifică dacă drumul găsit conține nodurile din lista de restricții.
% Acest predicat folosește recursivitate înainte, ordinea nodurilor trebuie
% inversată în ambele liste – lista de drum și de restricții. Motivați de ce această
% strategie nu este eficientă (urmăriți ce se întâmplă). Scrieți un predicat mai
% eficient care caută un drum restricționat între nodul sursă și cel destinație.
% ? - restricted_path_efficient(a, e, [c,d], P2).
% P = [a, b, c, d, e];
% P = [a, c, d, e];
% false

edge_ex7(a,b).
edge_ex7(b,c).
edge_ex7(a,c).
edge_ex7(c,d).
edge_ex7(b,d).
edge_ex7(d,e).
edge_ex7(e,a).


% restricted_path_efficient(X,Y,LR,Path):- % *IMPLEMENTAȚI AICI*


















%--------------------------------------------------
% 8. Scrie o serie de predicate care să rezolve problema Lupul-Capra-Varza: “un
% fermier trebuie să mute în siguranță, de pe malul nordic pe malul sudic, un
% lup, o capră și o varză. În barcă încap maxim doi și unul dintre ei trebuie să
% fie fermierul. Dacă fermierul nu este pe același mal cu lupul și capra, lupul
% va mânca capra. Același lucru se întâmplă și cu varza și capra, capra va mânca
% varza.”
% Sugestii:
% ● Puteți alege să encodați spațiul de stări ca instanțe a unei
%	configurări ale celor 4 obiecte (Fermir, Lup, Capră, Varză):
%	reprezentate ca o listă cu poziția celor 4 obiecte [Fermier, Lup,
%	Capră, Varză] sau ca o structură complexă (ex. F-W-G-C, sau
% 	state(F,W,G,C)).
% ● starea inițială este [n,n,n,n] (toți sunt în nord) și starea finală
%	este [s,s,s,s] (toți au ajuns în sud); pentru reprezentarea folosind
%	liste a stărilor (ex. dacă Fermierul trece lupul -> [s,s,n,n], această
%	stare nu ar trebui să fie validă deoarece capra mănâncă varza).
% ● la fiecare trecere Fermierul își schimba poziția (din „n” în „s” sau
%	invers) și cel mult încă un participant (Lupul, Capra, Varza).
% ● problema poate fi văzută ca o problema de căutare a drumului
%	într-un graf.



