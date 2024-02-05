 % this is a test hello world erlang code
 -module(hello).
-import(io, [fwrite/1]).
-export([helloworld/0]).

helloworld() -> 
	fwrite("Hello, Erlang World!\n").

