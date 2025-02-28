%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 			LABORATORUL 1 EXEMPLE		%%%%%%
%%%%%% 			Introducere în Prolog		%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------
% Exemple de FAPTE %
%--------------------------------------------------
we_are_in_classroom_108.
height(girafa, 5.5). % înălțime în metri
tree( t(1, t(-2, nil, nil), t(8,nil,nil)) ).

animal(elephant).
animal('Gnu antilope').

eat(human, fruits).
eat(human, meat).
eat(human, nuts).

% Întrebări %
% ?- we_are_in_classroom_108.
% true.

% ?- animal(’Gnu antilope’).
% true.

% ?- animal(X).
% X = elephant; % repetă întrebarea cu ; sau n sau spațiu
% X = ’Gnu antilope’;
% false. % nu mai există un alt animal definit în program


% Testează următoarea întrebare, care se poate traduce în 'Ce mănâncă un om?':
% ?-eats(human, X).



%--------------------------------------------------
% Exemple de REGULI %
%--------------------------------------------------
human(socrates). % fapta human/1

mortal(X):- human(X).


mai_inalt(X,Y) :- inaltime(X,Hx), inaltime(Y,Hy), Hx>Hy.
% prima data luam înălțimea lui X, apoi luam înălțimea lui Y
% și în final verificăm inegalitatea

drum(X,Y) :- muchie(X,Y).
drum(X,Y) :- muchie(X,Intermediar), drum(Intermediar,Y).
% drumul între nodurile X și Y poate să fie conexiunea directă
% între cele 2 noduri SAU daca nu există conexiune directă ne
% folosim de o conexiune indirectă printr-un nod intermediar






%--------------------------------------------------
% Exemple de BACKTRACKING %
%--------------------------------------------------
% hold_party/1 este o regulă care depinde de execuția reușită
% a faptelor birthday/1 și happy/1
hold_party(X):-
 birthday(X),
 happy(X).


% o serie de fapte de tip birthday/1 și happy/1
birthday(alex).
birthday(maria).
birthday(adriana).
happy(ana).
happy(george).
happy(adriana).


% Întrebări %
% Urmărește intrebările:
% ?- hold_party(X).


%--------------------------------------------------
% Exemple de RECURSIVITATE %
%--------------------------------------------------
% fapta si regula on_route/1, formează predicatul on_route/1
% fapta on_route/1
on_route(rome).
% regula on_route/1 – o regulă recursivă
on_route(Place):-
	move(Place,_,NewPlace), % move(Place,Method,NewPlace) - 'Method' a fost inlocuit cu _ pentru a evita 'singleton variable' warning
	on_route(NewPlace).

% predicatul move/3, format din 3 fapte
move(home,taxi,halifax).
move(halifax,train,gatwick).
move(gatwick,plane,rome).


% Întrebări %
% Urmărește intrebările:
% ?- on_route(acasa).







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 				EXERCIȚII				%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Scrieți noi predicate pentru relațiile de rudenie.


% Predicatul woman/1
woman(ana).
woman(sara).
woman(ema).
woman(maria). 
% … adăugați restul faptelor acestui predicat

% Predicatul man/1
man(andrei).
man(george).
man(alex). 
% … adăugați restul faptelor acestui predicat

% Predicatul parent/2
parent(maria, ana). % maria este părintele anei
parent(george, ana). % george este părintele anei
parent(maria, andrei).
parent(george, andrei). 
% … adăugați restul faptelor acestui predicat





% 1.1. Testați următoarele întrebări:
% Este george bărbat?
% ?- man(george). 
% true.

% Cine este bărbat?
% ?- man(X). 
% X = andrei ? ; % repetăm întrebarea cu ; sau n sau spațiu
% X = george ? ;
% X = alex.

% Cine sunt părinții lui andrei?
% ?- parent(X, andrei). 
% X = maria ? ;
% X = george.



% Predicatul mother/2
% X este mama lui Y, daca X este femeie și X este părintele lui Y
mother(X,Y) :- woman(X), parent(X,Y).

% Cine sunt copii anei?
% ?- mother(ana, X). 

% Care este mama anei?
% ?- mother(X, ana). 


%--------------------------------------------------
% 1.2. Scrieți predicatul father/2.
% father(X,Y):-



%--------------------------------------------------
% 1.3. Completați predicatele man/1, woman/1 și parent/2 pentru a acoperi arborele genealogic de mai sus.



%--------------------------------------------------
% 1.4. Testați următoarele întrebări:
% ?- father(alex, X).
% ?- father(X, Y).
% ?- mother(dorina, maria).


%--------------------------------------------------
% 1.5. 1.5. Testați următoarele predicate:
% Predicatul sibling/2
% X și Y sunt frați/surori dacă au cel puțin un părinte în comun
% și X diferit de Y
sibling(X,Y) :- parent(Z,X), parent(Z,Y), X\=Y.

% Predicatul sister/2
% X este sora lui Y dacă X este femeie și X și Y sunt frați/surori
sister(X,Y) :- sibling(X,Y), woman(X).

% Predicatul aunt/2
% X este mătușa lui Y daca este sora lui Z și Z este părintele lui Y
aunt(X,Y) :- sister(X,Z), parent(Z,Y).



%--------------------------------------------------
% 1.6. Scrieți predicatele brother/2, uncle/2, grandmother/2 și grandfather/2.

% brother(X,Y):- % *IMPLEMENTAȚI AICI*

% uncle(X,Y):- % *IMPLEMENTAȚI AICI*

% grandmother(X,Y):- % *IMPLEMENTAȚI AICI*

% grandfather(X,Y):- % *IMPLEMENTAȚI AICI*



%--------------------------------------------------
% 1.7. Urmăriți pașii pentru găsirea răspunsului la următoarele întrebări (prin utilizarea trace-ului):
% ?- aunt(carmen, X).
% ?- grandmother(dorina, Y).
% ?- grandfather(X, ana).



%--------------------------------------------------
% 1.8. Scrieți predicatul ancestor/2, unde X este strămoșul lui Y dacă X este legat de Y printr-o serie (indiferent de număr) de relații de tip părinte. 


% ancestor(X, Y):- % *IMPLEMENTAȚI AICI*


