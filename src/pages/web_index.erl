-module (web_index).
-include_lib ("nitrogen/include/wf.inc").
-compile(export_all).

main() -> 
  game_server:start("Colin", "Royce"),
  #template { file="./wwwroot/template.html"}.

title() ->
	"web_index".

body() ->
  #panel{body=[
      #p{},
      "Registered processes:",
      #list{ body=registered_process_list() }
    ]}.
	
event(_) -> ok.

registered_process_list() ->
  WrapLI = fun (ProcessName) -> #listitem{ text=io_lib:write(ProcessName) } end,
  lists:map(WrapLI, registered()).
