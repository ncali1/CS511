-module(gg).
-compile(export_all).

start() ->
    spawn(fun() -> server() end).

server() ->
    server_loop().

server_loop() ->
    receive
        {From, Ref, start} ->
            Pid = spawn(fun() -> servlet(From, Ref) end),
            server_loop();
        Other ->
            io:format("Server received unknown message: ~p~n", [Other]),
            server_loop()
    end.

servlet(ClientPid, Ref) ->
    NumberToGuess = rand:uniform(10),
    servlet_loop(ClientPid, Ref, NumberToGuess).

servlet_loop(ClientPid, Ref, NumberToGuess) ->
    receive
        {ClientPid, Ref, Number} when Number == NumberToGuess ->
            ClientPid ! {gotIt, Ref},
            io:format("Client ~p guessed correctly!~n", [ClientPid]),
            done;
        {ClientPid, Ref, Number} ->
            ClientPid ! {tryAgain, Ref},
            servlet_loop(ClientPid, Ref, NumberToGuess);
        Other ->
            io:format("Servlet received unknown message: ~p~n", [Other]),
            servlet_loop(ClientPid, Ref, NumberToGuess)
    end.

% Example usage:
% 1. Open an Erlang shell.
% 2. Compile the module by executing `c(gg).`
% 3. Start the server by executing `gg:start().`
% 4. Send a request to play the game by executing `gg:server().`
% 5. The server will start handling game requests, and each client will have its servlet process.

-module(b).
-compile(export_all).

start(P, J) ->
    S = spawn(?MODULE, server, [0]),
    [spawn(?MODULE, patriots, [S]) || _ <- lists:seq(1, P)],
    [spawn(?MODULE, jets, [S]) || _ <- lists:seq(1, J)].

% Reference to PID of server
patriots(S) ->
    S ! {self(), patriots}.

% Reference to PID of server
jets(S) ->
    Ref = make_ref(),
    S ! {self(), Ref, jets},
    receive
        {S, Ref, ok} ->
            ok
    end.

server(Patriots) ->
    receive
        {_From, patriots} ->
            server(Patriots + 1);
        {From, Ref, jets} when Patriots > 1 ->
            From ! {self(), Ref, ok},
            server(Patriots - 2)
    end.
