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








% ?-functor(a+b,F,N). 
% Yes, F=+, N=2

% ?-functor([a,b,c],F,N).
% Yes, F=., N=2 (why 2? Which ones?)

% ?-functor([a,b,c],F,3).
% fails. Why?

% ?-functor(a,F,N).
% Yes, F=a, N=0

% ?-functor(f(a,b),F,N).
% Yes, F=f,N=2.

% ?-functor(F,f,3).
% Yes, F=f(A,B,C).

% ?-functor(F,+,2).
% Yes, F=A+B



% ?-arg(2,f(a,b),X).
% Yes, X=b.

% ?-arg(1,a+b+c,X).
% Yes, X=a

% ?-arg(3,a+b+c,Y).
% No. WHY?

% ?-arg(2,a+b+c,Z).
% Yes, Z=b+c

% ?-arg(1,[a,b,c],X).
% Yes, X=a

% ?-arg(2,[a,b,c],Y).
% Yes, Y=[b,c]




% ?-X=..[a,b,c,d].
% Yes, X=a(b,c,d)

% ?-X=..[member,a,[b,c]].
% Yes, X=member(a,[b,c]).

% ?-f(a,b,c)=..X. % Can we ask with X on the left?
% Yes, X=[f,a,b,c].

% ?-append([H|T],L,[H|R])=..X.
% Yes, X=[append,[H|T],L,[H|R]].

% ?-(a+b)=..L.
% Yes, L=[+,a,b].

% ?-(a+b+c)=..L.
% Yes, L=[+,a,b+c]

% ?-[a,b,c,d]=..[H|T]. % Can we ask with [H|T] on the left?
% Yes, H=., T=[a,[b,c,d]]





% ?- (a+b)=..L1, test(a+b, L2). % equivalent

test(Eq1, [F|Terms]):-
    functor(Eq1,F,N),
    get_args(Eq1, 1, N, Terms).
    
get_args(_, C, N, []):- N is C-1.
get_args(Eq1, C, N, [X|R]):-
    C1 is C+1,
    arg(C, Eq1, X),
    get_args(Eq1, C1, N, R).





subst1(Old,New,Old,New):-!. 
subst1(Val,Val,_,_):-	 	
	atomic(Val),!.	
subst1(Val,NewVal,OldSubExpr,NewSubExpr):-
	Val=..[F|Args], 
	subst_args1(Args,NewArgs,OldSubExpr,NewSubExpr),
	NewVal=..[F|NewArgs]. 

subst_args1([],[],_,_).
subst_args1([Arg|Args],[NArg|NArgs],Old,New):-
	subst1(Arg,NArg,Old,New),
	subst_args1(Args,NArgs,Old,New). 

% [q] ?- subst1(f(a, b, g(a)), R, a, x).
% R = f(x,b,g(x))


subst2(Old,New,Old,New):-!. 	
subst2(Val,Val,_,_):-		
	atomic(Val),!.	
subst2(Val,NewVal,OldSubExpr,NewSubExpr):-
	functor(Val,F,N), 
	functor(NewVal,F,N),
	subst_args2(N,Val,NewVal,OldSubExpr,NewSubExpr).
	
subst_args2(0,_,_,_,_):-!. 
subst_args2(N,Val,NewVal,Old,New):-
	arg(N,Val,OldArg),
 	arg(N,NewVal,NewArg),
 	subst2(OldArg,NewArg,Old,New),
	N1 is N-1,	
	subst_args2(N1,Val,NewVal,Old,New). 

% [q] ?- subst2(f(a, b, g(a)), R, a, x).
% R = f(x,b,g(x))
