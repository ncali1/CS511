-module(bt).
-compile(nowarn_export_all).
-compile(export_all).

-type btree() :: {empty} | {node, number(), btree(), btree()}.

% Example of a complete bt
-spec t1() -> btree().
t1() ->
    {node, 1, {node, 2, {empty}, {empty}}, {node, 3, {empty}, {empty}}}.

% Example of a non-complete bt
-spec t2() -> btree().
t2() ->
    {node, 1, {node, 2, {empty}, {empty}}, {node, 3, {empty}, {node, 3, {empty}, {empty}}}}.

% Checks that all the trees in the queue are empty trees.
-spec all_empty(queue:queue()) -> boolean().
all_empty(Q) ->
    case queue:is_empty(Q) of
        true ->
            true;
        _ ->
            case queue:out(Q) of
                {{value, {empty}}, Q1} ->
                    all_empty(Q1);
                {{value, _}, _} ->
                    false;
                _ ->
                    erlang:error("cannot happen")
            end
    end.

% Helper function for ic
-spec ich(queue:queue()) -> boolean().
ich(Q) ->
    {{value, T}, Q1} = queue:out(Q),
    case T of
        {empty} ->
            all_empty(Q1);
        {node, _D, LT, RT} ->
            ich(queue:in(RT, queue:in(LT, Q1)))
    end.

% Check if the binary tree is complete.
-spec ic(btree()) -> boolean().
ic(T) ->
    ich(queue:in(T, queue:new())).
