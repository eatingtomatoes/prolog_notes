# List processing idioms

Suppose you have an "input list" and an "output list", both of the same length, and with the ouput list to be constructed from the input list
according to some algorithm. The relation between the elements need not be pairwise.

It is also possible that both lists are given and that you want to check that "output list" is indeed the result of constructing input list.

Note there is the special group of "folding" processing, where one "folds" a list (or another structure like atree) into a single atomic value.
More on this [here](../about_foldl_and_foldr)


            folding ---> fold/[4-7] of library(apply)
 
  ----+---> pairwise processing ---> use maplist/3
      |     
      +---> non-pairwise processing ----+----> from head to tail ---> shave-off and prepend in head of clause
                                        | 
                                        +----+ from tail to head 
      
## Pairwise processing

If the processing is pairwise, then you do not need to write your own predicate. Using the
metapredicate [maplist/3](https://eu.swi-prolog.org/pldoc/doc_for?object=maplist/3) is a good choice.

For example, the output list is the powers of two of the input list:

```logtalk
power2(In,Out) :- maplist([X,Y]>>(Y is X*X),In,Out).
```

then

```text
?- power2([0,1,2,3],Result).
Result = [0, 1, 4, 9].

?- power2([0,1,2,3],[0,1,1,1]).
false.
```

or you can build a result of the actual pairs:

```logtalk
power2pairs(In,OutPairs) :- maplist([X,Y]>>(Y is X*X),In,Powers),maplist([X,Y,X-Y]>>true,In,Powers,OutPairs).
```

then

```text
?- power2pairs([0,1,2,3],OutPairs).
OutPairs = [0-0, 1-1, 2-4, 3-9].
```

For more on this, see [Examples for the Prolog predicate `maplist/3`](../../swipl_notes/about_maplist/maplist_3_examples.md).

## Non-Pairwise processing, head-to-tail of input list

The elements of the output list may have a more complicated relationship to the elements of the input list. For example,
at the ouput value at pos _i_ may be the sum of input values at position _j < i_. Or the output value at posiition _i_ may
be a pair of the input value at position _i_ and _i_ itself.

### In correct order

This is the usual case. Create a predicate that performs a recursive call at last position and which, at each activation:

- takes an input list and an output list (generally a freshvar), plus any extra arguments ; 
- at each activation
   - removes the head of the input list, with the rest given to the recursive call (a monotonically decreasing variant) ;
   - constructs the output list by prepending the ouput value at this position to the output list constructed by the recursive call ;
- the base case just relates the empty input list to the empty output list.

This is subject to tail-call optimization (i.e. transformation by the compiler into a loop) because the last action taken is
the recursive call. The construction of the ouptut list is performed (here, `[I-D|Os]` is done when the present call is made!
See also "[Tail recursion modulo cons](https://en.wikipedia.org/wiki/Tail_call#Tail_recursion_modulo_cons)".

```logtalk
index_elements(In,Out) :- correct_order_processing(In,Out,0).

correct_order_processing([I|Is],[I-D|Os],D) :-
   succ(D,Dp),
   correct_order_processing(Is,Os,Dp).
   
correct_order_processing([],[],_).
```

then

```text
?- index_elements([a,b,c,d,e,f,g],Out).
Out = [a-0, b-1, c-2, d-3, e-4, f-5, g-6].
```

This one is not subject to tail-call optimization although it does exactly the same. BAD!

```logtalk
index_elements_bad(In,Out) :- correct_order_processing_non_tco(In,Out,0).

correct_order_processing_non_tco([I|Is],Out,D) :-
   succ(D,Dp),
   correct_order_processing_non_tco(Is,Mid,Dp),
   Out = [I-D|Mid]. % perform some operation after return from the recursive call
   
correct_order_processing_non_tco([],[],_).
```

With `index_elements_bad/2` you can exhaust the stack:

```text
?- bagof(N,between(1,10000000,N),Bag), index_elements_bad(Bag,Out).
ERROR: Stack limit (1.0Gb) exceeded
ERROR:   Stack sizes: local: 0.5Gb, global: 0.2Gb, trail: 32.3Mb
```

...with `index_elements/2` things look much better:

```text
?- bagof(N,between(1,10000000,N),Bag), index_elements(Bag,Out).
Bag = [1, 2, 3, 4, 5, 6, 7, 8, 9|...],
Out = [1-0, 2-1, 3-2, 4-3, 5-4, 6-5, 7-6, 8-7, ... - ...|...].
```

### Using accumulator, resulting in output list in reverse order

Sometimes you want to generate the ouput list in reverse order. Or maybe you are forced to due to the structure of the problem?

Create a predicate that performs a recursive call at last position and which, at each activation:

- takes an input list, an _accumulator_ (initially `[]`) and an output list (generally a freshvar) which passed unmodified to the base case (it allows the caller to "fish" the result out of the depth of the recursion), plus any extra arguments ;
- at each activation
   - removes the head of the input list, with the rest given to the recursive call (a monotonically decreasing variant) ;
   - passes a new accumulator to the recursive call, which has the ouput value at this position prepended ;
- the base case just sets the output list to the received accumulator (shunts the accumulator to the output)

```logtalk
index_elements_acc_reverse(In,Out) :- reverse_order_acc_processing(In,[],Out,0).

reverse_order_acc_processing([I|Is],Acc,Out,D) :-
   succ(D,Dp),
   reverse_order_acc_processing(Is,[I-D|Acc],Out,Dp).
   
reverse_order_acc_processing([],Shunt,Shunt,_).
```

And thus:

```text
?- index_elements_acc_reverse([a,b,c,d,e,f,g],Out).
Out = [g-6, f-5, e-4, d-3, c-2, b-1, a-0].
```

Note that this is (probably) subject to tail-optimization, but uses more structure on the global stack:

```text
?- bagof(N,between(1,10000000,N),Bag), index_elements_reverse(Bag,Out).
ERROR: Stack limit (1.0Gb) exceeded
ERROR:   Stack sizes: local: 2Kb, global: 0.7Gb, trail: 1Kb
```

You have to use the accumulator idiom when you want to communicate to the next activation previous results. 

### Using accumulator and difference list, resulting in output list in correct order

If you want to use the accumulator idiom and still end up with a list in correct order, and without 
using [reverse/2](https://eu.swi-prolog.org/pldoc/doc_for?object=reverse/2), you would use a difference list
to efficiently append new elements to an existing (open) list. 

A difference list is represented by two variables:

- One denoting the _tip_ of the list, i.e. the first list-cell.
- One denoting the _fin_ of the list, i.e. the hole referenced by the second argument of the last list-cell, which in closed/proper lists is the `[]` atom.

An element is easily appended to such a structure by binding the _fin_ to a new list-cell with a new last element, and using a new _fin_, which,
again denotes the hole referenced by the second argument of the last list-cell in a new activation.

In fact the _Head_ + _Tail_ pair functions as a "accumulator with append possibilites" in this scenario.

```logtalk
index_elements_acc_correct(In,Out) :- 
   correct_order_acc_processing(In,D,D,0),   % D is both the tip and fin of an empty difference list
   Out = D.                                  % D must be freshvar, so you cannot pass Out directly 

correct_order_acc_processing([I|Is],Head,Tail,D) :-
   succ(D,Dp),
   Tail = [I-D|NewTail],
   correct_order_acc_processing(Is,Head,NewTail,Dp).
   
correct_order_acc_processing([],_Head,Tail,_) :-
   Tail = []. % this creates a proper list; could also be put into head directly (maybe save a few cycles if it's here)
```

And thus:

```text
?- index_elements_acc_correct([a,b,c,d,e,f,g],Out).
Out = [a-0, b-1, c-2, d-3, e-4, f-5, g-6].
```

## Non-Pairwise processing, tail-to-head of input list


 
   