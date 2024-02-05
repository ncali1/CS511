-module(mk_barrier).
-compile(export_all).
-compile(nowarn_export_all).

mk_barrier(N) ->
    S = spawn(?MODULE, coord, [N, 0, []]),
    case whereis(coord) of
        undefined ->
            ok;
        _PID when is_pid(_PID) ->
            unregister(coord)
    end,
    register(coord, S).

%%coord(N, M, L)
%%N is the size of the barrier
%%M is the number of process yet to arrive
%%L is a list of the PIDs of theose that have arrived

coord(N, 0, L) ->
    [{PID} ! {ok} || PID <- L],
    coord(N, N, []);
coord(N, M, L) when M > 0 ->
    receive
        {PID} ->
            coord(N, M - 1, [PID | L])
    end.

reached(B) ->
    B ! {self()},
    receive
        {ok} ->
            ok
    end.
