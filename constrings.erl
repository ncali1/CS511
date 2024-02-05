-module(constrings).
-compile(nowarn_unused_vars).
-compile([export_all]).

start() ->
    spawn(?MODULE, server, [[]]).

client(ServerPid) ->
    ServerPid ! {start, self()},
    ServerPid ! {add, "h"},
    ServerPid ! {add, "e"},
    ServerPid ! {add, "l"},
    ServerPid ! {add, "l"},
    ServerPid ! {add, "o"},
    ServerPid ! {done, self()},
    receive
        {ServerPid, Str} ->
            io:format("Done: ~p~s~n", [self(), Str])
    end.

server(ActiveClients) ->
    receive
        {start, ClientPid} ->
            NewActiveClients = [{ClientPid, []} | ActiveClients],
            server(NewActiveClients);
        {add, String} ->
            NewActiveClients = add_string(ActiveClients, self(), String),
            server(NewActiveClients);
        {done, ClientPid} ->
            {Result, NewActiveClients} = concat_strings(ActiveClients, ClientPid, []),
            ClientPid ! {self(), Result},
            server(NewActiveClients)
    end.

add_string(ActiveClients, ClientPid, String) ->
    lists:map(
        fun
            ({Pid, Acc}) when Pid == ClientPid -> {Pid, [String | Acc]};
            (Other) -> Other
        end,
        ActiveClients
    ).

concat_strings(ActiveClients, ClientPid, Result) ->
    {Result, NewActiveClients} = lists:foldl(
        fun
            ({Pid, Acc}, {ResultAcc, NewClients}) when Pid == ClientPid ->
                {list_to_binary(lists:reverse(Acc)), NewClients};
            (Other, {ResultAcc, NewClients}) ->
                {ResultAcc, [Other | NewClients]}
        end,
        {"", []},
        ActiveClients
    ),
    {Result, NewActiveClients}.
