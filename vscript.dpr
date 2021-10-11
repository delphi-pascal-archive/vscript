program vscript;

{$R xp.res}


uses scriptix, Windows, SysUtils;


function CustomFunc(NameOfFunc:String;Parameters:Array of String;var Return:String):Bool;stdcall;begin
    Result:=False;

//    if NameOfFunc='ALERT' then MessageBox(0,PChar(Parameters[0]),PChar(ParamStr(0)),48);


end;

function DebugOutput(Print:String;Expert:Bool;Error:Bool):Bool;stdcall;begin
    Result:=True;

//
//messagebox(getDesktopWindow,pchar(print),'',0);  


end;
 var return:string;
begin
  SetDebugHwnd(FindWindow('TSCDebugForm',nil));
  SetCustomFunc(@CustomFunc);
  //SetDebugOutputFunc(@DebugOutput);


  if fileexists(escape_string(ParamStr(1)))=false then halt;
  Script.comp_execute_script(escape_string(ParamStr(1)),return);
end.
