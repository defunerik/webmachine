%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc {{appid}} startup code

-module({{appid}}).
-author('author <author@example.com>').
-export([start/0, start_link/0, stop/0]).

-define(DEPS, [inets, % builtin
	       crypto, % builtin
	       public_key, % for ssl
	       xmerl, % for ssl
	       ssl, % for mochiweb
	       compiler, % for mochiweb
	       syntax_tools, % for mochiweb
	       mochiweb, % builtin
	       webmachine %builtin
	       %% DEVELOPERS - put your dependencies here. Don't forget the comma after
	       %% the previous item (webmachine)
	       ]).

ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.

start_dependencies() ->
    lists:foreach(fun (Dep) -> ensure_started(Dep) end, ?DEPS).

stop_dependencies() ->
    lists:foreach(fun (Dep) -> application:stop(Dep) end, lists:reverse(?DEPS)).


%% @spec start_link() -> {ok,Pid::pid()}
%% @doc Starts the app for inclusion in a supervisor tree
start_link() ->
    start_dependencies(),
    {{appid}}_sup:start_link().

%% @spec start() -> ok
%% @doc Start the {{appid}} server.
start() ->
    start_dependencies(),
    application:start({{appid}}).

%% @spec stop() -> ok
%% @doc Stop the {{appid}} server.
stop() ->
    Res = application:stop({{appid}}),
    stop_dependencies(),
    Res.
