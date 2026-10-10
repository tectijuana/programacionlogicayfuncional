-module(sse_demo).
-export([iniciar/0, iniciar/1]).

iniciar() -> iniciar(8081).
iniciar(Puerto) -> sse_sup:start_link(Puerto).
