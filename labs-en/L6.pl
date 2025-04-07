%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 			LABORATORY 6 EXAMPLES		%%%%%%
%%%%%% 				Deep Lists				%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% L1 = [1,2,3,[4]]
% L2 = [[1],[2],[3],[4,5]]
% L3 = [[],2,3,4,[5,[6]],[7]]
% L4 = [[[[1]]],1,[1]]
% L5 = [1,[2],[[3]],[[[4]]],[5,[6,[7,[8,[9],10],11],12],13]]
% L6 = [alpha,2,[beta],[gamma,[8]]]

% Test the following queries:
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
% Test the following queries:
% ? – atomic(apple).
% ? – atomic(4).
% ? – atomic(X).
% ? – atomic(apple(2)).
% ? – atomic([1,2,3]).
% ? – atomic([]).


%--------------------------------------------------
% The DEPTH predicate %
%--------------------------------------------------
max(A, B, A):- A>B, !.
max(_, B, B).

depth([],1).
depth([H|T],R):- atomic(H), !, depth(T,R).
depth([H|T],R):- depth(H,R1), depth(T,R2), R3 is R1+1, max(R3,R2,R).


% Test the predicate for lists L1-L6 presented above, for example:
% ?- depth(L1, R).



%--------------------------------------------------
% The FLATTEN predicate %
%--------------------------------------------------
flatten([],[]).
flatten([H|T], [H|R]):- atomic(H), !, flatten(T,R).
flatten([H|T], R):- flatten(H,R1), flatten(T,R2), append(R1,R2,R).

% Test the predicate for lists L1-L6 presented above, for example:
% ?- flatten(L1, R).


%--------------------------------------------------
% The HEADS predicate %
%--------------------------------------------------
% Variant 1
skip([],[]).
skip([H|T],R):- atomic(H),!,skip(T,R).
skip([H|T],[H|R]):- skip(T,R).

% takes the first element from each list,
% then skips the rest of atomic elements, calls recursively for lists.
heads1([],[]).
heads1([H|T],[H|R]):- atomic(H),!,skip(T,T1), heads1(T1,R).
heads1([H|T],R):- heads1(H,R1), heads1(T,R2),append(R1,R2,R).



% Variant 2
heads2([],[],_).
% if flag=1, it means that we are at the beginning of the list and we can
% extract the head, but on the recursive call we must set the flag to 0
heads2([H|T],[H|R],1):- atomic(H), !, heads2(T,R,0).
% if flag=0, then we are not at the first atomic element
% and we must continue with the rest of the elements
heads2([H|T],R,0):- atomic(H), !, heads2(T,R,0).
% if we reach this clause it means that the first element is not
% atomic and we must call recursively on this element as well
heads2([H|T],R,_):- heads2(H,R1,1), heads2(T,R2,0), append(R1,R2,R).
% wrapper for heads predicate
heads2(L,R):- heads2(L, R, 1).

% Test the predicate for lists L1-L6 presented above, for exemple:
% ?- heads1(L1, R).
% ?- heads2(L1, R).


%--------------------------------------------------
% The MEMBER predicate %
%--------------------------------------------------

% Variant 1
member1(X, L):- flatten(L,L1), member(X,L1).

% Variant 2
member2(H, [H|_]).
member2(X, [H|_]):- member2(X,H). % H is a list
member2(X, [_|T]):- member2(X,T).

% Test the following queries:
% ?– member2(1,L1).
% ?– member2(4,L2).
% ?– member2([5,[6]], L3).
% ?– member2(X,L4).
% ?– member2(X,L6).
% ?– member2(14,L5).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 				EXERCISES				%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%--------------------------------------------------
% 1. Write the count_atomic(L,R) predicate that counts the number of atomic
% elements in list L (all atomic elements on all depths).
% ?- count_atomic([1,[2],[[3]],[[[4]]],[5,[6,[7,[8,[9],10],11],12],13]], R).
% R = 13;
% false.


% count_atomic(L, R):-  % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 2. Write the sum_atomic(L,R) predicate that counts the sum of atomic
% elements from list L (all atomic elements on all depths).
% ?- sum_atomic([1,[2],[[3]],[[[4]]]], R).
% R = 10;
% false.


% sum_atomic(L, R):-  % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 3. Write the replace(X,Y,L,R) predicate that replaces each occurrence of X with Y 
% in a deep list L (at any imbrication level) and inserts the result into R.
% ?- replace(1, a, [[[[1,2], 3, 1], 4],1,2,[1,7,[[1]]]], R).
% R = [[[[a, 2], 3, a], 4], a, 2, [a, 7, [[a]]]];
% false.


% replace(X, Y, L, R):-  % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 4. Write the lasts(L,R) predicate that extracts the last position (immediately before ‘]’) of each sublist in L.
% ?- lasts([1,2,[3],[4,5],[6,[7,[9,10],8]]], R).
% R = [3,5,10,8] ;
% false.


% lasts(L, R):-  % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 5. Replace each constant depth sequence in a deep list with its length (do not use the length/2 predicate).
% ? – len_con_depth([[1,2,3],[2],[2,[2,3,1],5],3,1],R).
% R = [[3],[1],[1,[3],1],2].


% len_con_depth(L, R):-  % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 6. Replace each constant depth sequence in a deep list with its depth (do not use the depth/2 predicate).
% ? – depth_con_depth([[1,2,3],[2],[2,[2,3,1],5],3,1],R).
% R = [[1], [1], [1, [2], 1], 0].


% depth_con_depth(L, R):-  % *IMPLEMENTATION HERE*


%--------------------------------------------------
% 7. Modify the member2/2 predicate for deep lists so that it is a deterministic
% predicate (in this case, deterministic means that only one answer will be
% returned – there is no next answer – multiple tests have to be made on
% the member_deterministic/2 predicate with various inputs to verify).
% ?- member_deterministic(1, [1,2,1]).
% true.
% ?- member_deterministic(1, [[1],2,1]).
% true.


% member_deterministic(X, L):-  % *IMPLEMENTATION HERE*



%--------------------------------------------------
% 8. Write a predicate that sorts a deep list based on the depth of each
% element. If two elements have the same depth, then they will be
% compared based on the atomic elements they contain. (You can use a
% sorting method of your choice).
% Hint:
% • L1< L2, if L1 and L2 are lists, or deep lists, and the depth of L1 is
% 	smaller than the depth of L2.
% • L1 < L2, if L1 and L2 are lists, or deep lists with equal depth, all the
% 	elements up to the k-th are equal, and the k+1-th element of L1 is
% 	smaller than the k+1th element of L2 (at equal depths, the list with
% 	the smaller index of the sublist that gives the last depth is
% 	considered larger – as shown in the example for the comparison
% 	between 5 and [5])
% ?- sort_depth([[[[1]]], 2, [5,[4],7], [[5],4], [5,[0,9]]], R).
% R = [2, [5,[0,9]], [[5],4], [5,[4],7], [[[1]]]] ;
% false


% sort_depth(L, R):-  % *IMPLEMENTATION HERE*
