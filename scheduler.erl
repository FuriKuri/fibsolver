-module(scheduler).
-export([run/4]).

run(Num, Module, Func, ToCalc) ->
  Processes = lists:map(fun(_) -> spawn(Module, Func, [ self() ]) end,lists:seq(1, Num)),
  schedule(Processes, ToCalc, []).

schedule(Processes, Queue, Results) ->
 receive
   { ready, Process } when length(Queue) > 0 ->
     [ Next | Tail ] = Queue,
     Process ! { fib, Next, self() },
     schedule(Processes, Tail, Results);
   { ready, Process } ->
     Process ! { shutdown },
     if
       length(Processes) > 1 -> schedule(lists:delete(Process, Processes), Queue, Results);
       true -> Results
     end;
   { answer, Number, Result, _ } ->
     schedule(Processes, Queue, [ { Number, Result } | Results ])
 end.
