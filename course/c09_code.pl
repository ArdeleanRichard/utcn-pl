%--------------------------------------------------
% Side Effects %
%--------------------------------------------------


:-dynamic p/1.

p(1).
p(2).
p(3).
p(4).
p(5).

q1:-assertz(p(6)), fail.
q1.

% ?- listing(p/1).
% ?- q1, listing(p/1).


q2:-retract(p(_)), fail.
q2.

% ?- listing(p/1).
% ?- q2, listing(p/1).









%--------------------------------------------------
% Towers of Hanoi %
%--------------------------------------------------


:- dynamic(input/1).
:- dynamic(int/1).
:- dynamic(out/1).



hanoi(N):-
	init_list(N,List), 				% List = [5, 4, 3, 2, 1]
	init_tower(in,List),			% ?- init_list(3, List), init_pole(in, List), listing(in/1). 	% Creates tower as: in(1), in(2)
	move_discs(N,in,int,out).		% in,int,out = x,y,z towers


init_list(1,[1]):-!.
init_list(N,[N|Rest]):- 
	N1 is N-1,
	init_list(N1,Rest).

init_tower(_,[]):-!.
init_tower(T,[N|L]):-
	D=..[T,N],			% T name of tower, as x in example; N size   	% D=..[in, N] <--> D=in(1) / D=in(2) ...
	asserta(D), 		% put on top									% asserta(in(1)), assert(in(2)), ...
	init_tower(T,L).
	

move_discs(0,_,_,_):-!.
move_discs(N,X,Y,Z):- 
	N1 is N-1,
	move_discs(N1,X,Z,Y),
	move_disc(X, Z),
	move_discs(N1,Y,X,Z).

move_disc(IP,OP):-
	DI=..[IP,Size],
	retract(DI),!,
	DO=..[OP,Size], 
	asserta(DO).


% ?- retractall(out(_)), hanoi(3), listing(in/1), listing(out/1).


