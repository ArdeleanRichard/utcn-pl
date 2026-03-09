%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 			LABORATORY 2 EXAMPLES		%%%%%%
%%%%%% 			Arithmetic Operations		%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------
% The IS predicate %
%--------------------------------------------------
% Follow the execution of:

% ?- X = 1+2.
% X = 1+2.

% ?- X is 1+2.
% X = 3.

% The mathematic expression is written on the right of „is” and must not contain any uninstantiated variables.
% Examples:
% ?- X is sqrt(4).
% X = 2.0.

% ?- Y = 10, X is Y mod 2.
% X = 0.

% ?- X is (1+2*3)/7-1.
% X = 0.

% ?- X is Y+1.
% Arguments are not sufficiently instantiated *ERROR*

% ?- X is 1+2, X is 3+4.
% false.


%--------------------------------------------------
% The GCD predicate %
%--------------------------------------------------
% Variant 1
gcd1(X,X,X). % The third parameter is the result of GCD
gcd1(X,Y,Z) :- X>Y, Diff is X-Y, gcd1(Diff,Y,Z).
gcd1(X,Y,Z) :- X<Y, Diff is Y-X, gcd1(X,Diff,Z).

% Variant 2
gcd2(X,0,X). % The third parameter is the result of GCD
gcd2(X,Y,Z) :- Y\=0, Rest is X mod Y, gcd2(Y,Rest,Z).

% Follow the execution of the following:
% ?- trace, gcd1(30,24,X).
% ?- trace, gcd1(15,2,X).
% ?- trace, gcd1(4,1,X).




%--------------------------------------------------
% The FACTORIAL predicate %
%--------------------------------------------------
% Variant 1 - using backwards recursion
fact_bwd(0,1).
fact_bwd(N,F) :- N > 0, N1 is N-1, fact_bwd(N1,F1), F is N*F1.


% Variant 2 - using forwards recursion
fact_fwd(0,Acc,F) :- F = Acc.
fact_fwd(N,Acc,F) :- N > 0, N1 is N-1, Acc1 is Acc*N, fact_fwd(N1,Acc1,F).

% the wrapper
fact_fwd(N,F) :- fact_fwd(N,1,F). % the accumulator is initialized with 1



 
 
 
 
 
 
 
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 				EXERCISES				%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------
% 1. Write the predicate lcm/3 which calculates the Least Common Multiplier (LCM).
% Suggestion: LCM between two natural numbers is the division of their product by their GCD.
% ?- lcm(12, 24, Z).
% Z=24;
% false.

% lcm(X, Y, Z). – will calculate the least common multiplier between X and Y and return it in Z

% lcm(X, Y, Z):-  % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 2. Write the triangle/3 predicate that verifies if the three parameters can
% represent the lengths of the sides of a triangle. The sum of any two edges
% must be bigger than the third.
% ?- triangle(3, 4, 5).
% true.
% ?- triangle(3, 4, 8).
% false.


% triangle(A, B, C). – will check whether A,B,C could be the sides of a triangle and will return true or false

% triangle(A, B, C):-  % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 3. Write the solve/4 predicate that solves the quadratic equation
% (a*x2+b*x+c = 0). The predicate must have 3 input parameters (A,B,C) and
% one ouput parameters (X). When repeating the query it must return the
% second (distinct) solution if it exists.
% ?- solve(1, 3, 2, X).
% X=-1;
% X=-2;
% false.
% ?- solve(1, 2, 1, X).
% X=-1;
% false.
% ?- solve(1, 2, 3, X).
% false

% solve(A, B, C, X). – will solve the quadratic equation A*x2 +B*x+C = 0
% and will return the result(s) in X or false otherwise

% solve(A, B, C, X):-  % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 4. Write the predicates for raising a number to a chosen power using:
% • forward recursion: power_fwd/3
% • backword recusion: power_bwd/3
% ?- power_fwd(2, 3, Z).
% Z=8;
% false.
% ?- power_bwd(2, 3, Z).
% Z=8;
% false.


% power(X, Y, Z). – will calculate X to the power of Y and return it in Z


% power_fwd(X, Y, Z):-   % *IMPLEMENTATION HERE*

% power_bwd(X, Y, Z):-   % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 5. Write the predicate fib/2 which calculates the n-th number in the Fibonacci sequence.
% The recurrence formula is:
% 	fib(0) = 0
% 	fib(1) = 1
% 	fib(n) = fib(n-1) + fib(n-2), pentru n>0

% ?- fib(5, X).
% X=5;
% false.
% ?- fib(8, X).
% X=21;
% false.


% fib(N, X). – will calculate N-th number of the Fibonacci sequence and return it in X


% fib(N, X):-   % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 6. Write the previous predicate using only 1 recursion call.
% ?- fib1(5, X).
% X=5;
% false.
% ?- fib1(8, X).
% X=21;
% false.

% fib1(N, X):-   % *IMPLEMENTATION HERE*





%--------------------------------------------------
% 7. For: Write the for/3 predicate after the specifications given in section 2.4
% that calculates the sum of all numbers smaller than a given number.
% ?- for(0, S, 9).
% S=45;
% false.



for(Inter,Inter,0).
for(Inter,Out,In):-
	In>0,
	NewIn is In-1,
	Intermediate=Inter, % *DELETE LINE, IMPLEMENTATION HERE* <do_something_to_Inter_to_get_Intermediate>
	for(Intermediate,Out,NewIn).




%--------------------------------------------------
% 8. For: Write the for_bwd/2 predicate using backwards recursion that
% calculates the sum of all numbers smaller than a given number.
% ?- for_bwd(9, S).
% S=45;
% false.

% for_bwd(In,Out). – will compute the sum of all values between 0 and In and return the result in Out


% for_bwd(In, Out):-   % *IMPLEMENTATION HERE*






%--------------------------------------------------
% 9. While: Write the while/3 predicate which simulates a while loop and
% returns the sum of all values between Low and High.
% Hint. The structure of such a loop is:
% 	while <some condition>
% 		<do something>
% 	end while

% ?- while(0, 5, S).
% S=10;
% false.
% ?- while(2, 2, S).
% S=0;
% false


% while(Low,High,Sum). – will compute the sum of all values between Low and High and return the result in Sum


% while(Low, High, Sum):-   % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 10.Repeat….until: Write the dowhile/3 predicate which simulates a
% repeat…until loop and returns the sum of all values between two given numbers.
% Hint. The structure of such a loop is:
% 	repeat
% 		<do something>
% 	until <some condition>

% ?- dowhile(0, 5, S).
% S=10;
% false.
% ?- dowhile(2, 2, S).
% S=2;
% false.


% dowhile(Low,High,Sum). – will compute the sum of all values between Low and High and return the result in Sum


% dowhile(Low, High, Sum):-   % *IMPLEMENTATION HERE*