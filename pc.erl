-module(pc).
-compile(export_all).
-compile(nowarn_unused_vars).
-compile(nowarn_export_all).

start(N, P, C) ->
    B = spawn(?MODULE, buffer, [N, 0, 0, 0]),
    [spawn(?MODULE, producer, [B]) || _ <- lists:seq(1, P)],
    [spawn(?MODULE, consumer, [B]) || _ <- lists:seq(1, P)].

buffer(N, Oc, PSP, CSC) ->
    receive
        {From, start_producing} when Oc + PSP < N ->
            From ! {ok},
            buffer(N, Oc, PSP + 1, CSC);
        {From, stop_producing} ->
            From ! {ok},
            buffer(N, Oc, PSP - 1, CSC);
        {From, start_consuming} when Oc - CSC > 0 ->
            From ! {ok},
            buffer(N, Oc, PSP, CSC + 1);
        {From, stop_consuming} ->
            From ! {ok},
            buffer(N, Oc, PSP, CSC - 1)
    end.

producer(B) ->
    B ! {self(), start_producing},
    receive
        {ok} ->
            ok
    end,
    B ! {stop_producing}.

consumer(B) ->
    B ! {self(), start_consuming},
    receive
        {ok} ->
            ok
    end,
    B ! {stop_consuming}.
