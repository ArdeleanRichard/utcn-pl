%--------------------------------------------------
% Functor, Arg, Univ %
%--------------------------------------------------


% ?- functor(a+b,F,N). 
% true, F=+, N=2

% ?- functor([a,b,c],F,N).
% true, F=., N=2 		% Why 2? Which ones?

% ?- functor([a,b,c],F,3).
% fails. 				% Why?

% ?- functor(a,F,N).
% true, F=a, N=0.

% ?- functor(f(a,b),F,N).
% true, F=f, N=2.

% ?- functor(F,f,3).
% true, F=f(_1,_2,_3).

% ?- functor(F,+,2).
% true, F=_1 + _2.



% ?- arg(2,f(a,b),X).
% true, X=b.

% ?- arg(1,a+b+c,X).
% true, X=a

% ?- arg(3,a+b+c,Y).
% false. 				% WHY?

% ?- arg(2,a+b+c,Z).
% true, Z=b+c

% ?- arg(1,[a,b,c],X).
% true, X=a

% ?- arg(2,[a,b,c],Y).
% true, Y=[b,c]




% ?- X=..[a,b,c,d].
% true, X=a(b,c,d)

% ?- X=..[member,a,[b,c]].
% true, X=member(a,[b,c]).

% ?- f(a,b,c)=..X. 				% Can we ask with X on the left?
% true, X=[f,a,b,c].

% ?- append([H|T],L,[H|R])=..X.
% true, X=[append,[H|T],L,[H|R]].

% ?- (a+b)=..L.
% true, L=[+,a,b].

% ?- (a+b+c)=..L.
% true, L=[+,a,b+c]

% ?- [a,b,c,d]=..[H|T]. 		% Can we ask with [H|T] on the left?
% true, H=., T=[a,[b,c,d]]








univ(Eq, [F|Terms]):-
    length(Terms, N),
    functor(Eq, F, N),
    get_args(Eq, 0, N, Terms).
    
get_args(_, N, N, []):- !.
get_args(Eq, C, N, [X|R]):-
    C1 is C+1,
    arg(C1, Eq, X),
    get_args(Eq, C1, N, R).

% ?- f(a,b,c)=..L1, univ(f(a,b,c), L2).
% L1 = L2 = [f, a, b, c] 		% equiExprent

% ?- F1=..[f,a,b,c], univ(F2, [f,a,b,c]).
% F1 = F2 = f(a,b,c).			% equiExprent


%--------------------------------------------------
% Substitution %
%--------------------------------------------------

% subst /4 (+Old, +New, +OldExpr, -NewExpr).
% subst_args /4 (+Old, +New, +ListOldArgs, -ListNewArgs).


subst1(Old,New,Old,New):-!. 
subst1(_,_,Old,Old):-	 	
	atomic(Old),!.	
subst1(Old,New,Expr,NewExpr):-
	Expr=..[F|Args], 										% decomposition: f(a, b, g(a)) = ..[F|Args] 	--> F=f, Args=[a,b,g(a)]
	subst_args1(Old,New,Args,NewArgs),
	NewExpr=..[F|NewArgs]. 									% recomposition: NewExpr = ..[f|[x,b,g(x)]] 		--> NewExpr=f(x, b, g(x))


% subst_args1 calls subst1 to process predicates
% - in the case of  a  being atomic it goes directly to the atomic clause
% - but for the case of  g(a)  it must process it by going into its arguments

subst_args1(_,_,[],[]).
subst_args1(Old,New,[Arg|Args],[NewArg|NewArgs]):-
	subst1(Old,New,Arg,NewArg),
	subst_args1(Old,New,Args,NewArgs). 

% similar to replace from laboratory
% [q] ?- subst1(a, x, f(a, b, g(a)), R).
% R = f(x,b,g(x))



subst2(Old,New,Old,New):- !. 	
subst2(_,_,Old,Old):- 
	atomic(Old), !.	
subst2(Old,New,Expr,NewExpr):-
	functor(Expr,F,N), 										% Expr=f(a, b, g(a)) --> functor(f(a, b, g(a), F, N) --> F=f, N=3
	functor(NewExpr,F,N),									% F=f, N=3 			--> functor(NewExpr, f, 3) 		--> NewExpr=f(_1, _2, _3)
	subst_args2(N,Old,New,Expr,NewExpr).
	
subst_args2(0,_,_,_,_):-!. 
subst_args2(N,Old,New,Expr,NewExpr):-
	arg(N,Expr,OldArg),										% N=3, Expr=f(a, b, g(a)) 	--> arg(3, f(a, b, g(a)), OldArg)	--> OldArg=g(a)
 	arg(N,NewExpr,NewArg),									% N=3, NewExpr=f(_1, _2, _3) --> arg(3, f(_1, _2, _3), NewArg) 	--> NewArg=_3 	(variable _3 which will be instantiated in subst2 call)
 	subst2(Old,New,OldArg,NewArg),
	N1 is N-1,	
	subst_args2(N1,Old,New,Expr,NewExpr). 
	
% similar to replace from laboratory
% [q] ?- subst2(a, x, f(a, b, g(a)), R).
% R = f(x,b,g(x))


