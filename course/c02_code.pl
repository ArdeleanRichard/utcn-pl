% ?- X==Y	.
% no (fails; even if both X and Y are free variables)

% ?- X==X	.
% yes, X=_some_number

% ?- X=Y, X==Y.	
% yes, X=_some_number; Y =_some_number (SAME)

% ?- X=[a,b], Y=[a,b], X==Y. [in STANDARD Prolog]
% no (although same list [a,b] is JUST same content, they are NOT shared in memory, NOT same location)
%	?- X=[a,b], Y=[a,b], X==Y. [in SWI Prolog]
%	yes (same list [a,b]  same content, constants whether atomic or compound are 	considered identical)

% ?- X=[a,b], Y=X, X==Y.
% yes

% ?- X is 2+3.
% yes, X=5

% ?- X=2+3.	
% yes, X=2+3

% ?- 2+3 is X.	
% Arguments are not sufficiently instantiated	

% ?- X is Y+1.	
% Arguments are not sufficiently instantiated

% ?- X is (2+2)/(4*1).
% X=1

% ?- X=2+3, Y is X.
% X=2+3, Y=5

% ?- Y=2, X is Y+1.
% X=3, Y=2

% ?- X=Y+1, Y=2, Z is X.
% X=2+1, Y=2, Z=3.

member1(H,[H|T]). 
member1(X,[H|T])
	member1(X,T).
