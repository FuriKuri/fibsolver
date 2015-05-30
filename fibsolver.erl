-module(fibsolver).
-export([fib/1]).

fib(Scheduler) ->
  Scheduler ! { ready, self() },
  receive 
    { fib, N, Client} ->
      Client ! { answer, N, fib_calc(N), self() },
      fib(Scheduler);
    { shutdown } ->
      exit(normal)
  end.

fib_calc(0) -> 0;
fib_calc(1) -> 1;
fib_calc(N) -> fib_calc(N - 1) + fib_calc(N - 2).
    
