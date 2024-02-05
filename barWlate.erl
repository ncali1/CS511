-module(barWlate).
-compile(export_all).
-compile(nowarn_export_all).

start(P, J) ->
    S = spawn(?MODULE, server, [0, 0]),
    [spawn(?MODULE, patriots, [S]) || _ <- lists:seq(1, P)],
    [spawn(?MODULE, jets, [S]) || _ <- lists:seq(1, J)],
    spawn(?MODULE, timer, [S]).

timer(S) ->
    timer:sleep(1000),
    S ! {itGotLate}.

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

flush_and_notify() ->
    receive
        {From, jets} ->
            From ! {ok},
            flush_and_notify()
    after 0 ->
        ok
    end.

%Counters for partiots available for justifying
server(Delta, false) ->
    receive
        {partiots} ->
            server(Delta + 1, false);
        {From, jets} when Delta > 1 ->
            From ! {ok},
            server(Delta - 2, false);
        {itGotLate} ->
            flush_and_notify(),
            server(Delta, true)
    end.

server1(_Delta, true) ->
    receive
        {patriots} ->
            server1(_Delta, true);
        {From, jets} ->
            From ! {ok},
            server1(_Delta, true)
    end.
