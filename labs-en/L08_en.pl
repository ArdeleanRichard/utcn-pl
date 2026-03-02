%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 			LABORATORY 8 EXAMPLES		%%%%%%
%%%%%% Incomplete Structures (Lists & Trees)%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------
%--------------------------------------------------
% LISTS %
%--------------------------------------------------
%--------------------------------------------------

%--------------------------------------------------
% The MEMBER predicate %
%--------------------------------------------------
% must test explicitly for the end of the list
% which means we did not find the element, so we call fail
member_il(_, L):-var(L), !, fail.
% these 2 clauses are the same as for the member1 predicate
member_il(X, [X|_]):-!.
member_il(X, [_|T]):-member_il(X, T).

% Follow the execution of:
% ?- trace, L = [1, 2, 3|_], member_il(3, L).
% ?- trace, L = [1, 2, 3|_], member_il(4, L).
% ?- trace, L = [1, 2, 3|_], member_il(X, L).


%--------------------------------------------------
% The INSERT predicate %
%--------------------------------------------------

% found end of list, add element
insert_il1(X, L):-var(L), !, L=[X|_].
insert_il1(X, [X|_]):-!. % element found, stop
insert_il1(X, [_|T]):- insert_il1(X, T). %traverse input list to reach end


% *SIMPLIFIED
insert_il2(X, [X|_]):-!.
insert_il2(X, [_|T]):- insert_il2(X, T).

% Follow the execution of:
% ?- trace, L = [1, 2, 3|_], insert_il2(3, L).
% ?- trace, L = [1, 2, 3|_], insert_il2(4, L).
% ?- trace, L = [1, 2, 3|_], insert_il2(X, L).



%--------------------------------------------------
% The DELETE predicate %
%--------------------------------------------------
delete_il(_, L, L):-var(L), !. % reached end, stop
delete_il(X, [X|T], T):- !. % found, remove the first appearance and stop
delete_il(X, [H|T], [H|R]):- delete_il(X, T, R). % traverse, search for the element

% Follow the execution of:
% ?- trace, L = [1, 2, 3|_], delete_il(2, L, R).
% ?- trace, L = [1, 2, 3|_], delete_il(4, L, R).
% ?- trace, trace, L = [1, 2, 3|_], delete_il(X, L, R).





%--------------------------------------------------
%--------------------------------------------------
% TREES %
%--------------------------------------------------
%--------------------------------------------------

%--------------------------------------------------
% The SEARCH predicate %
%--------------------------------------------------
search_it(_, T):- var(T), !, fail.
search_it(Key, t(Key, _, _)):- !.
search_it(Key, t(K, L, _)):- Key<K, !, search_it(Key, L).
search_it(Key, t(_, _, R)):- search_it(Key, R).

% Follow the execution of:
% ?- trace, T=t(7, t(5, t(3,_,_), t(6,_,_)), t(11,_,_)), search_it(6, T).
% ?- trace, T=t(7, t(5, t(3,_,_), _), t(11,_,_)), search_it(9, T).


%--------------------------------------------------
% The INSERT predicate %
%--------------------------------------------------
% inserts the element or verifies if the element is already in the tree
insert_it(Key, t(Key, _, _)):-!.
insert_it(Key, t(K, L, _)):-Key<K, !, insert_it(Key, L).
insert_it(Key, t(_, _, R)):-insert_it(Key, R).

% Follow the execution of:
% ?- trace, T=t(7, t(5, t(3,_,_), t(6,_,_)), t(11,_,_)), insert_it(6, T).
% ?- trace, T=t(7, t(5, t(3,_,_), _), t(11,_,_)), insert_it(9, T).



%--------------------------------------------------
% The DELETE predicate %
%--------------------------------------------------
delete_it(_, T, T):- var(T), !. % element not in tree
delete_it(Key, t(Key, L, R), L):- var(R), !.
delete_it(Key, t(Key, L, R), R):- var(L), !.
delete_it(Key, t(Key, L, R), t(Pred,NL,R)):- !, get_pred(L,Pred,NL).
delete_it(Key, t(K,L,R), t(K,NL,R)):- Key<K, !, delete_it(Key,L,NL).
delete_it(Key, t(K,L,R), t(K,L,NR)):- delete_it(Key,R,NR).

% searches for the predecessor node
get_pred(t(Pred, L, R), Pred, L):- var(R), !.
get_pred(t(Key, L, R), Pred, t(Key, L, NR)):- get_pred(R, Pred, NR).

% Follow the execution of:
% ?- trace, T=t(7, t(5, t(3,_,_), t(6,_,_)), t(11,_,_)), delete_it(6, T, R).
% ?- trace, T=t(7, t(5, t(3,_,_), _), t(11,_,_)), delete_it(9, T, R).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 				EXERCISES				%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trees:
incomplete_tree(t(7, t(5, t(3, _, _), t(6, _, _)), t(11, _, _))).
complete_tree(t(7, t(5, t(3, nil, nil), t(6, nil, nil)), t(11, nil, nil))).




% Write a predicate which:
%--------------------------------------------------
% 1. Transforms an incomplete list into a complete list and vice versa.
% ?- convertIL2CL([1,2,3|_], R).
% R = [1, 2, 3].
% ?- convertCL2IL([1,2,3], R).
% R = [1, 2, 3|_].


% convertIL2CL(L, R):- % *IMPLEMENTATION HERE*

% convertCL2IL(L, R):- % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 2. Appends two incomplete lists (the result should be an incomplete list – How many arguments do we need, could we lose one?).
% ?- append_il([1,2|_], [3,4|_], R).
% R = [1, 2, 3, 4|_].


% append_il(L1, L2, R):- % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 3. Reverses an incomplete list (the result should be an incomplete list also). Implement in both types of recursion.
% ?- reverse_il_fwd([1,2,3|_], R).
% R = [3, 2, 1|_].
% ?- reverse_il_bwd([1,2,3|_], R).
% R = [3, 2, 1|_].

% reverse_il_fwd(L, R):- % *IMPLEMENTATION HERE*

% reverse_il_bwd(L, R):- % *IMPLEMENTATION HERE*



%--------------------------------------------------
% 4. Flattens a deep incomplete list (the result should be a simple incomplete list).
% ?- flat_il([[1|_], 2, [3, [4, 5|_]|_]|_], R).
% R = [1, 2, 3, 4, 5|_] ;
% false.


% flat_il(L, R):- % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 5. Transforms an incomplet tree into a complete tree and vice versa.
% ?- incomplete_tree(T), convertIT2CT(T, R).
% R = t(7,t(5,t(3,nil,nil),t(6,nil,nil)),t(11,nil,nil))
% ?- complete_tree(T), convertCT2IT(T, R).
% R = t(7, t(5, t(3, _, _), t(6, _, _)), t(11, _, _))

% convertIT2CT(T, R):- % *IMPLEMENTATION HERE*

% convertCT2IT(T, R):- % *IMPLEMENTATION HERE*



%--------------------------------------------------
% 6. Performs a preorder traversal on an incomplete tree, and collects the keys in an incomplete list.
% ?- incomplete_tree(T), preorder_it(T, R).
% R = [7, 5, 3, 6, 11|_]


% preorder_it(T, R):- % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 7. Computes the height of an incomplete binary tree.
% ?- incomplete_tree(T), height_it(T, R).
% R=3


% height_it(T, R):- % *IMPLEMENTATION HERE*




%--------------------------------------------------
% 8. Computes the diameter of a binary incomplete tree.
% 𝑑𝑖𝑎𝑚(𝑇) = max {𝑑𝑖𝑎𝑚(𝑇. 𝑙𝑒𝑓𝑡), 𝑑𝑖𝑎𝑚(𝑇. 𝑟𝑖𝑔ℎ𝑡), ℎ𝑒𝑖𝑔ℎ𝑡(𝑇. 𝑙𝑒𝑓𝑡) + ℎ𝑒𝑖𝑔ℎ𝑡(𝑇. 𝑟𝑖𝑔ℎ𝑡) + 1}
% ?- incomplete_tree(T), diam_it(T, R).
% R=4


% diam_it(T, R):- % *IMPLEMENTATION HERE*


%--------------------------------------------------
% 9. Determines if an incomplete list is a sub-list in another incomplete list.
% ?- subl_il([1, 1, 2|_], [1, 2, 3, 1, 1, 3, 1, 1, 1, 2, 3,4|_]).
% true
% ?- subl_il([1, 1, 2|_], [1, 2, 3, 1, 1, 3, 1, 1, 1, 3, 2, 4|_]).
% false


% subl_il(SL, L):- % *IMPLEMENTATION HERE*





%--------------------------------------------------
% 10. Write the append_il/2 predicate that concatenates two incomplete lists using only two arguments (without an argument for the result).









