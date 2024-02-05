-module(bar).
-compile(export_all).
-compile(nowarn_export_all).

start(P, J) ->
    S = spawn(?MODULE, server, [0, 0]),
    [spawn(?MODULE, patriots, [S]) || _ <- lists:seq(1, P)],
    [spawn(?MODULE, jets, [S]) || _ <- lists:seq(1, J)].

%Reference to PID of server
patriots(S) ->
    S ! (patriots).

%Reference to PID of server
jets(S) ->
    S ! {self(), jets},
    receive
        {ok} ->
            ok
    end.

%Counters for partiots available for justifying
server(Delta) ->
    receive
        {partiots} ->
            server(Delta + 1);
        {From, jets} when Delta > 1 ->
            From ! {ok},
            server(Delta - 2)
    end.
