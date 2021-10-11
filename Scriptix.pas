  (*      V 20091215   JUL 23   2010        WINALL (9x ME NT 2k XP VISTA WIN7)
  Script language for Delphi
  language:

  * instructions:

    break       break loop (for,while)
    exit        exit from function
    continue    begins from start of loop
    #include    includes functions from file (#include "file.h")
    idle        idle program

    halt        halt main program (default: false)  parameter to allow: const allow_halt


  * while() {}

  * for($i,1,10) [reverse] {}

  * if() {} [else {}]

  * switch($i){
    0:{}
    1:{}
    }


  types:
  * string    "<string>"
  * system    TRUE FALSE NULL
  * number    1 2 3 4 5 6 7 8 9 0

  \n New line
  \t Tab
  \\ \
  \$ $

  $i = 0;
  "test \\n string begins here\nNew line begins here\t\$i = $i"


  test \n string begins here
  New line begins here  $i = 0


  comments:

  // <remark>       -   to end of line

  /* <remark> */    -   from [/*] to [*/]


  strings:

  "file_lines = " . file_lines("c:\test.txt")   symbol [.] for supply 2 strings

  file_lines = 0


  math:

  $r = 1 + 2 * 3 / 2;

  $r = 4;


  $h=gui_window("class", "caption",style,x,y,width,height,icon,menu,cursor,"Callback");
  
  
  $button=gui_control(handle,class,id,caption,style,x,y,width,height);
  
  
  func  CallBack($window,$message,$hwnd,$id) {
	if($message==$_WM_COMMAND){
		if($id==201) {
			message("pressed!");
		}
	}
  
  }
  

  Symbol '->' replaces to '_'

  process_get_pid();
    or
  process -> get_pid();

  -----------------------------------


  func main($argc,$argv) {

    /* some func  */

    return;
  }
  -----------------------------------
  For Callback func use:
  
  process_enum("enum_func");
  
  Ex.:
  func enum_func($pid,$process) {
	message("enum_func","[$pid]  $process",0);
	return 0;
  }

  -----------------------------------

  SetCustomFunc(@<Func>)

  function CustomFunc(
                      NameOfFunc:String;            // Function name
                      Parameters:Array of String;   // From 0 to 255 string array
                      var Return:String             // return for func
                                                     ):Bool;stdcall;


  SetDebugOutputFunc(@<Func>);

  function DebugOutput(
                       Print:String;                // Output string from debuger
                       Expert:Bool;                 // If message consists expert message
					   Error:Bool					// If it's a error
                                                     ):Bool;stdcall;


  Class Script
  Script.comp_execute_script(<Filename>) - execute script
  Script.comp_execute_func(<Filename>,<Func>,<Param>) -execute function from file




  Script file (VCS,VSC)

-------------------------------
  func main($script) {
    // script body
    return;
  }
-------------------------------
$script = arg count

  Functions

-------------------------------
  // simple math (math.vsc)



  func add($a,$b) {
    return($a + $b);
  }

  func sub($a,$b) {
    return($a - $b);
  }

  func mul($a,$b) {
    return($a * $b);
  }

  func div($a,$b) {
    return($a / $b);
  }
-------------------------------

  Statements

-------------------------------
  func div($a,$b) {
    if($b==0){exit;}
    return($a / $b);
  }
-------------------------------



  --console

  -->console_write(string)

     "Welcome \$USER \fa White \f7 Silver \n New line \t <TAB>"

  0   FOREGROUND_BLACK
  1   FOREGROUND_NAVY
  2   FOREGROUND_GREEN
  3   FOREGROUND_TEAL
  4   FOREGROUND_MAROON
  5   FOREGROUND_PURPLE
  6   FOREGROUND_OLIVE
  7   FOREGROUND_SILVER
  8   FOREGROUND_GRAY
  9   FOREGROUND_BLUE
  A   FOREGROUND_LIME
  B   FOREGROUND_AQUA
  C   FOREGROUND_RED
  D   FOREGROUND_FUCHSIA
  E   FOREGROUND_YELLOW
  F   FOREGROUND_WHITE

  --addons:

  MD5
  PROCESSES

  --------------------------------------------  

// for debug

  *)
//                                        _______
                  //\\    //     // ===   _______
                 //  \\  //     // ===      //
//     ()       //    \\//     // ===      //


                                         // ||     //\\    ||
                                        //  ||    //  \\   ||
                                       //   ||   // == \\  ||
                                      //    ||  //      \\ ||___________
                                     //     || //        \\||-----------
//\\//\\//\\//\\//\\//\\//\\//\\//\\//unit:windows,system,strings,registry,classes




unit scriptix;
{$R input.res}



interface  uses
  Windows,  //standard
  SysUtils, //for system procs
  StrUtils, //string parser
  Registry, //registry_ tree
  Classes,   //consts...
  TlHelp32;  //addons (process_*)
  const
          MAX_BUFFER_LENGTH=        $FF;(*
           max buffer size          (**************)

          allow_halt=               false;(*
           allow halt from script   (**************)

          shell32=                  'shell32.dll';(*
           from ShellApi            (**************)


type TModuleArray = array of TModuleEntry32;

type TComp=record   //Class for language
   __statement:array[0..255]of boolean;
   __level:Byte;
   __cycle:Byte;
   __comments:boolean;
   __var_ident:array[0..255]of string;
   __var_value:array[0..255]of array[0..255] of string;
   __var_count:byte;
   __error:boolean;
   __use:array[0..255]of string;
   __result:byte;
   __code:TStrings;
   __current_code_line:Cardinal;
   __switch_level:Byte;
   __func_ident:array[0..255]of string;
   __func_body :array[0..255]of string;
   __func_count:byte;
   __return:string;
   __HALT:BOOLEAN;
   __debug_point:cardinal;
   __hwnds:TList;
end;

type TTimer=record
    Active: Boolean;
    Interval:Cardinal;
    ID:Cardinal;
    CallbackFunc:String;
end;

type TCallbackFunc=record
    Active:Boolean;
    Handle:THandle;
    CallBackFunc:String;
end;
  type TTimeoutOrVersion = record
    case Integer of          // 0: Before Win2000; 1: Win2000 and up
      0: (uTimeout: UINT);
      1: (uVersion: UINT);   // Only used when sending a NIM_SETVERSION message
  end;

  type  TNotifyIconDataEx = record
    cbSize: DWORD;
    hWnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
    szTip: array[0..127] of AnsiChar;  // Previously 64 chars, now 128
    dwState: DWORD;
    dwStateMask: DWORD;
    szInfo: array[0..255] of AnsiChar;
    TimeoutOrVersion: TTimeoutOrVersion;
    szInfoTitle: array[0..63] of AnsiChar;
    dwInfoFlags: DWORD;
{$IFDEF _WIN32_IE_600}
    guidItem: TGUID;  // Reserved for WinXP; define _WIN32_IE_600 if needed
{$ENDIF}
  end;
   PNotifyIconDataEx=^TNotifyIconDataEx;

  {$EXTERNALSYM _SHELLEXECUTEINFOA}
  _SHELLEXECUTEINFOA = record
    cbSize: DWORD;
    fMask: ULONG;
    Wnd: HWND;
    lpVerb: PAnsiChar;
    lpFile: PAnsiChar;
    lpParameters: PAnsiChar;
    lpDirectory: PAnsiChar;
    nShow: Integer;
    hInstApp: HINST;
    { Optional fields }
    lpIDList: Pointer;
    lpClass: PAnsiChar;
    hkeyClass: HKEY;
    dwHotKey: DWORD;
    hIcon: THandle;
    hProcess: THandle;
  end;
   PShellExecuteInfo=^_SHELLEXECUTEINFOA;

var TIMER_ARRAY:array[0..255]of TTimer;
    CBF_ARRAY:array[0..255]of TCallbackFunc;

type TScript=class
   private
             function   _execute_line(__comp_vars:TComp;str:string;T_LINE:STRING='';T_LINE_INDEX:INTEGER=0;l:integer=-1):string;
             procedure  comp_execute_script_from_strings(var __comp:TComp;st:string;is_func:boolean=false;__header:string='';__param:string='');

   public
             function   comp_execute_script(const fn:string;var return:string):boolean;
             procedure  comp_execute_line(const line:string);
             function   comp_execute_func(const fn:string;const func:string;const param:string;var output:string):boolean;

end;

  TFunction=function():DWORD;stdcall;
  TProcedure=procedure();stdcall;
  TCustomScriptFunction=function(NameOfFunc:String;Parameters:Array of String;var Return:String):Bool;stdcall;
  TDebugOutputFunction=function(Print:String;Expert:Boolean;Error:Boolean):Bool;stdcall;


var

  Script:TScript;


  function escape_string(str:string):string;
  procedure SetCustomFunc(Custom:Pointer);
  procedure SetDebugHwnd(Wnd:HWND);
  procedure SetDebugOutputFunc(Custom:Pointer);

{$EXTERNALSYM Shell_NotifyIcon}
function Shell_NotifyIcon(dwMessage: DWORD; lpData: PNotifyIconDataEx): BOOL;stdcall;
{$EXTERNALSYM ShellExecuteEx}
function ShellExecuteEx(lpExecInfo: PShellExecuteInfo):BOOL; stdcall;
{$EXTERNALSYM ShellAbout}
function ShellAbout(Wnd: HWND; szApp, szOtherStuff: PChar; Icon: HICON): Integer; stdcall;


implementation
uses sndkeys32,IdHashMessageDigest;

function Shell_NotifyIcon; external shell32 name 'Shell_NotifyIconA';
function ShellExecuteEx; external shell32 name 'ShellExecuteExA';
function ShellAbout; external shell32 name 'ShellAboutA';

type
  {$EXTERNALSYM tagINITCOMMONCONTROLSEX}
  tagINITCOMMONCONTROLSEX = packed record
    dwSize: DWORD;
    dwICC: DWORD;
  end;
  PInitCommonControlsEx = ^TInitCommonControlsEx;
  TInitCommonControlsEx = tagINITCOMMONCONTROLSEX;



  const
  // Key select events (Space and Enter)
  WM_USER              = $0400;
  NIN_SELECT           = WM_USER + 0;
  NINF_KEY             = 1;
  NIN_KEYSELECT        = NINF_KEY or NIN_SELECT;
  // Events returned by balloon hint
  NIN_BALLOONSHOW      = WM_USER + 2;
  NIN_BALLOONHIDE      = WM_USER + 3;
  NIN_BALLOONTIMEOUT   = WM_USER + 4;
  NIN_BALLOONUSERCLICK = WM_USER + 5;
  // Constants used for balloon hint feature
  NIIF_NONE            = $00000000;
  NIIF_INFO            = $00000001;
  NIIF_WARNING         = $00000002;
  NIIF_ERROR           = $00000003;
  NIIF_ICON_MASK       = $0000000F;    // Reserved for WinXP
  NIIF_NOSOUND         = $00000010;    // Reserved for WinXP
  // uFlags constants for TNotifyIconDataEx
  NIF_STATE            = $00000008;
  NIF_INFO             = $00000010;
  NIF_GUID             = $00000020;
  // dwMessage constants for Shell_NotifyIcon
  NIM_SETFOCUS         = $00000003;
  NIM_SETVERSION       = $00000004;
  NOTIFYICON_VERSION   = 3;            // Used with the NIM_SETVERSION message
  // Tooltip constants
  TOOLTIPS_CLASS       = 'tooltips_class32';
  TTS_NOPREFIX         = 2;

  NIM_ADD         = $00000000;
  NIM_MODIFY      = $00000001;
  NIM_DELETE      = $00000002;
  NIF_MESSAGE     = $00000001;
  NIF_ICON        = $00000002;
  NIF_TIP         = $00000004;

 WM_TRAYNOTIFY = WM_USER + 1024;

type TInput=packed record
    Rect:TRect;
    Width:Integer;
    Height:Integer;
    sCaption:String;
    sPrompt:String;
    sDefault:String;
    sInput:String;
    cLimitChars:Integer;
    bResult:Boolean;
    hLabel,hEdit:HWND;
    szBuff:array[0..1024]of char;
    intSize:Integer;
    cInputStyle:Integer;
    cPasswordChar:Char;
end;

var
  __DEBUG_HWND:HWND;
  __PUBLIC:TInput;
  ComCtl32DLL: THandle;
  CustomScriptFunction:TCustomScriptFunction;
  DebugOutputFunction:TDebugOutputFunction;
  _InitCommonControlsEx: function(var ICC: TInitCommonControlsEx): Bool stdcall;
  __VAR:string;
  __TEMP_S:STRING;
  __TEMP_I:INTEGER;
  __EXPERT:BYTE;
  __CONSOLE:THANDLE;
  __GUI_FUNC_ID:string;
  __MAIN_COMP:TComp;
  
  msg:TMsg; _WndClass: TWNDCLASS;
  IconData:TNotifyIconDataEx;
  ShellEx:_SHELLEXECUTEINFOA;

const
  wDOS:string='∞±≤≥¥µ∂∑∏π∫ªºΩæø¿¡¬√ƒ≈∆«»… ÀÃÕŒœ–—“”‘’÷◊Ÿ⁄€‹›ﬁﬂÚÛÙıˆ˜¯˘Ò˚¸˝˛ˇÿ˙ÄÅÇÉÑÖÜáàâäãåçéèêëíìîïñóòôöõúùûü†°¢£§•¶ß®©™´¨≠ÆØ‡·‚„‰ÂÊÁËÈÍÎÏÌÓÔ';
  wWIN:string='ÄÅÇÉÑÖÜáàâäãåçéèêëíìîïñóòôöõúùûü†°¢£§•¶ß®©™´¨≠ÆØ∞±≤≥¥µ∂∑∏π∫ªºΩæø¿¡¬√ƒ≈∆«»… ÀÃÕŒœ–—“”‘’÷◊ÿŸ⁄€‹›ﬁﬂ‡·‚„‰ÂÊÁËÈÍÎÏÌÓÔÒÚÛÙıˆ˜¯˘˙˚¸˝˛ˇ';






  procedure InitCommonControls; external comctl32 name 'InitCommonControls';


(*      FAST OPTIMIZATION      *)
// pos__fastcall failed



(**********************************************************)


procedure SetDebugHwnd(Wnd:HWND);begin
    __DEBUG_HWND:=Wnd;
end;
procedure SetCustomFunc(Custom:Pointer);begin
    @CustomScriptFunction:=Custom;
end;

procedure SetDebugOutputFunc(Custom:Pointer);begin
    @DebugOutputFunction:=Custom;
end;

procedure InitComCtl;
begin
  if ComCtl32DLL = 0 then
  begin
    ComCtl32DLL := GetModuleHandle(comctl32);
    if ComCtl32DLL <> 0 then
      @_InitCommonControlsEx := GetProcAddress(ComCtl32DLL, 'InitCommonControlsEx');
  end;
end;

function InitCommonControlsEx(var ICC: TInitCommonControlsEx): Bool;
begin
  if ComCtl32DLL = 0 then InitComCtl;
  Result := Assigned(_InitCommonControlsEx) and _InitCommonControlsEx(ICC);
end;




 /////////////////////////////////////////////////////////////////////////




 procedure CloseHandles(__comp:TComp);var i:integer;begin
     if not Assigned(__comp.__hwnds) then exit;
     for i:=0 to __comp.__hwnds.Count-1 do  
     CloseHandle(integer(__comp.__hwnds.Items[i]));
 end;
 procedure AddHandle(__comp:TComp;Handle:THandle);begin
   if not Assigned(__comp.__hwnds) then exit;
   if Handle>0 then  __comp.__hwnds.Add(pointer(Integer(Handle)));
 end;
 function GetModulesListByProcessId(ProcessId: Cardinal): TModuleArray;
var
  hSnapshot: THandle;
  lpme: TModuleEntry32;
  procedure AddModuleToList;
  begin
    SetLength(Result, High(Result) + 2);
    Result[high(Result)] := lpme;
  end;
begin
  SetLength(Result, 0);
  hSnapshot := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, ProcessId);
  if hSnapshot = -1 then exit;
  lpme.dwSize := SizeOf(lpme);
  if Module32First(hSnapshot, lpme) then
  begin
    AddModuleToList;
    while Module32Next(hSnapshot, lpme) do
      AddModuleToList;
  end;
end;
function GetFullPIDExePath(PID:Cardinal):String; var i:word;modarr:TModuleArray;exe_name:string; begin
  try
  if pid<10 then exit;
  fillchar(exe_name, sizeof(exe_name), #0);
  modarr := GetModulesListByProcessId(PID);
    for i := 0 to High(modarr) do begin
        //if uppercase(extractfileext(modarr[i].szExePath))='.EXE' then begin
          exe_name := modarr[i].szExePath;
          GetFullPIDExePath:=exe_name;
          
          break;
        //end;
    end;
    except asm nop end; end;
end;
function ProcToPID(proc:string):Cardinal;
var
  hSnapshoot: THandle;
  pe32: TProcessEntry32;
begin
  result:=0;
  hSnapshoot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if (hSnapshoot = -1) then exit;
  pe32.dwSize := SizeOf(TProcessEntry32);
  if (Process32First(hSnapshoot, pe32)) then repeat
      if pe32.szExeFile =proc then begin
        result:=pe32.th32ProcessID;
        break;
      end;
    until
      not Process32Next(hSnapshoot, pe32);
  CloseHandle (hSnapshoot);
end;
function PIDToProc(PID:Cardinal):string;
var
  hSnapshoot: THandle;
  pe32: TProcessEntry32;
begin
  //result:=0;
  hSnapshoot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if (hSnapshoot = -1) then exit;
  pe32.dwSize := SizeOf(TProcessEntry32);
  if (Process32First(hSnapshoot, pe32)) then repeat
      if pe32.th32ProcessID =PID then begin
        result:=pe32.szExeFile;
        break;
      end;
    until
      not Process32Next(hSnapshoot, pe32);
  CloseHandle (hSnapshoot);
end;
function ExePathToPID(exe_path:string):Cardinal;
var
  hSnapshoot: THandle;
  pe32: TProcessEntry32;
begin
  result:=0;
  hSnapshoot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if (hSnapshoot = -1) then exit;
  pe32.dwSize := SizeOf(TProcessEntry32);
  if (Process32First(hSnapshoot, pe32)) then repeat
      if GetFullPIDExePath(pe32.th32ProcessID) =exe_path then begin
        ExePathToPID:=pe32.th32ProcessID;
        break;
      end;
    until
      not Process32Next(hSnapshoot, pe32);
  CloseHandle (hSnapshoot);
end;

function sysIn(Flags,Flag:Cardinal):boolean;begin
    if (flags or flag)=flags then result:=true else result:=false;
end;

function md5(s: string): string;
begin
  Result := '';
  with TIdHashMessageDigest5.Create do
  try
    Result := AnsiLowerCase(AsHex(HashValue(s)));
  finally
    Free;
  end;
end;





function DlgProc(hWin, uMsg, wParam, lParam: Integer): Integer; stdcall;
begin with __PUBLIC do begin
 Result := 0;
  case uMsg of
   {WM_INITDIALOG}$0110:
    begin
    bResult:=False;
    sInput:='';
    Windows.GetWindowRect(hWin,Rect);
    Width := Rect.Right-Rect.Left;
    Height := Rect.Bottom-Rect.Top;
    Windows.GetWindowRect(Windows.GetDesktopWindow,Rect);
    Windows.SetWindowPos(hWin,0,(Rect.Right-Width)div 2,(Rect.Bottom-Height)div 2,Width,Height,0);

     SetWindowText(hWin,PChar(sCaption));
     hLabel:=Windows.FindWindowEx(hWin,0,'static',nil);
     hEdit:=Windows.FindWindowEx(hWin,0,'edit',nil);
     SetWindowText(hLabel,PChar(sPrompt));
     SetWindowText(hEdit,PChar(sDefault));
     Windows.SetWindowLong(hEdit,gwl_Style,Windows.GetWindowLong(hEdit,gwl_Style)OR cInputStyle);
     PostMessage(hEdit,{EM_SETLIMITTEXT}$00C5,cLimitChars,0);
     PostMessage(hEdit,{EM_SETSEL}$00B1,Windows.GetWindowTextLength(hEdit),0);
     PostMessage(hEdit,{WM_SETFOCUS}$0007,0,0);

     if length(cPasswordChar)=1 then PostMessage(hEdit,{EM_SETPASSWORDCHAR}$00CC,ORd(cPasswordChar),0);


    end;
   {WM_COMMAND}$0111:
    begin
    // 100-OK 101-CANCEL
     case LoWord(wParam) of
      100:begin

          bResult:=true;
          intSize:=GetWindowText(hEdit,szBuff,SizeOf(szBuff));
          sInput:=Copy(StrPas(szBuff),1,IntSize);

          EndDialog(hWin, 0);
      end;
      101: EndDialog(hWin, 0);
    end;
  end;
   {WM_DESTROY}$0002, {WM_CLOSE}$0010: EndDialog(hWin,0);
 end;
end;end;

Function InputBoxA(const ACaption, APrompt, ADefault:String):String;begin
    with __PUBLIC do begin
      sCaption:=ACaption;
      sPrompt:=APrompt;
      sDefault:=ADefault;
      cLimitChars:=0;
      DialogBox(hInstance,'INPUTBOX',0,@DlgProc);
      if bResult=true then result:=sInput else result:=ADefault;
    end;
end;




procedure _send_debug_print(input:string;stop_point:boolean=false);

var p:array [0..$FF]of char;
    gaa:THandle;begin
    if __DEBUG_HWND=0 then exit;

     gaa:=GlobalAddAtom(PChar(input));
    PostMessage(__DEBUG_HWND,$0400,gaa,GetCurrentProcessID);


   if stop_point then
     while(0<>GlobalGetAtomName(gaa,@P[0],$FF)) do
     

end;
procedure _debug_print(print:string;_expert:boolean=false;_error:boolean=False;stop_point:boolean=false);var _c:bool;begin

if length(print)=0 then exit;
_c:=false;
	    if @DebugOutputFunction<>nil then _c:=DebugOutputFunction(print,_expert,_error);
   if _c=true then exit;

     if _error=true then print:='[!E] '+print;
    _send_debug_print('['+datetimetostr(now)+'] '+print,stop_point);
    if ((__EXPERT=1)and(__CONSOLE>0)) then
    writeln('['+datetimetostr(now)+'] '+print);

end;
procedure cls();

var
  ConHandle: THandle;
  Coord: TCoord;
  NOCW: Cardinal;
  MaxX, MaxY: SmallInt;

procedure GotoXY( X, Y : Word );
begin
   Coord.X := X;
   Coord.Y := Y;
   SetConsoleCursorPosition( ConHandle, Coord );
end;

begin
   ConHandle := GetStdHandle( STD_OUTPUT_HANDLE );
   Coord := GetLargestConsoleWindowSize( ConHandle );
   MaxX := Coord.X;
   MaxY := Coord.Y;
   Coord.X := 0;
   Coord.Y := 0;
   FillConsoleOutputCharacter( ConHandle, #32, MaxX * MaxY, Coord, NOCW );

   GotoXY( 0, 0 );


end;

procedure launch(p1,p2:string;p_wait:boolean=false;p_show:Cardinal=SW_SHOWNORMAL);var exit_code:cardinal;si:_STARTUPINFOA;pi:_PROCESS_INFORMATION; begin

  si.cb:=sizeof(si);

  si.dwFlags :=si.dwFlags or STARTF_USESHOWWINDOW;
  si.wShowWindow:=p_show;
  ZeroMemory(@si, SizeOf(si));
  ZeroMemory(@pi, SizeOf(pi));
  createprocess(PAnsiChar(p1),pansichar(p2) ,nil,nil,true,NORMAL_PRIORITY_CLASS,nil,nil,si,pi);

  if pi.hProcess =0 then exit;

  if p_wait=true then repeat
   GetExitCodeProcess(pi.hProcess,exit_code);
  until exit_code<>259;



end;

//////   ADDED
function safe_StrToInt(S:string;default:integer=0):integer;begin
if uppercase(s)='NULL' then s:=inttostr(default);
     try result := StrToInt(S);except result := default; end;
end;
function safe_StrToFloat(S:string):Extended;begin
if uppercase(s)='NULL' then s:='0';
     try result := StrToFloat(S);except result := 0; end;
end;

function inside_op(const Input:String; Offset: Integer; DefaultOp: Boolean = False):Boolean;
var i:integer;
begin
    result:=DefaultOp;
    for i:=1 to Offset do
        if Input[i]='"' then if copy(Input,i-1,1)<>'\' then result:=not result;
end;


function ___StringReplaceX2(const S, OldPattern, NewPattern: string;
  Flags: TReplaceFlags; InOp: Boolean = True; IgnoreSlash: Boolean = True): string;
var
  SearchStr, Patt, NewStr: string;
  Offset: Integer;
  DefaultOp: Boolean;

 function ___posX2(substr,str:string;InOp:boolean=True;DefaultOp:Boolean=False;RegistrySlash:Boolean=False):integer;var i:integer;op,rs:boolean;begin
    op:=DefaultOp;
    result:=0;
    for i:=1 to length(str) do begin
        if RegistrySlash=true then rs:=true else begin
            if copy(str,i-1,1)<>'\' then rs:=true else rs:=false
        end;

        if op=InOp then if copy(str,i,length(substr))=substr then if rs=true then
        if copy(str,i-1,1)<>'"' then if copy(str,i+1,1)<>'"' then begin
            result:=i;
            exit;
        end;
        if str[i]='"' then if copy(str,i-1,1)<>'\' then op:=not op;
    end;
end;

begin
if length(OldPattern)=0 then begin result:=S;exit;end;
  DefaultOp := False;
  if rfIgnoreCase in Flags then
  begin
    SearchStr := AnsiUpperCase(S);
    Patt := AnsiUpperCase(OldPattern);
  end else
  begin
    SearchStr := S;
    Patt := OldPattern;
  end;
  NewStr := S;
  Result := '';
  while SearchStr <> '' do
  begin
    Offset := ___posx2(Patt, SearchStr, InOp, DefaultOp, IgnoreSlash);
    if Offset = 0 then
    begin
      Result := Result + NewStr;
      Break;
    end;
    Result := Result + Copy(NewStr, 1, Offset - 1) + NewPattern;
    NewStr := Copy(NewStr, Offset + Length(OldPattern), MaxInt);
    if not (rfReplaceAll in Flags) then
    begin
      Result := Result + NewStr;
      Break;
    end;
    SearchStr := Copy(SearchStr, Offset + Length(Patt), MaxInt);
  end;
end;









function ___StringReplace(const S, OldPattern, NewPattern: string;
  Flags: TReplaceFlags; InOp: Boolean = True; IgnoreSlash: Boolean = True): string;
var
  SearchStr, Patt, NewStr: string;
  Offset: Integer;
  DefaultOp: Boolean;

 function ___pos(substr,str:string;InOp:boolean=True;DefaultOp:Boolean=False;RegistrySlash:Boolean=False):integer;var i:integer;op,rs:boolean;begin
    op:=DefaultOp;
    result:=0;
    for i:=1 to length(str) do begin
        if RegistrySlash=true then rs:=true else begin
            if copy(str,i-1,1)<>'\' then rs:=true else rs:=false
        end;

        if op=InOp then if copy(str,i,length(substr))=substr then if rs=true then begin
            result:=i;
            exit;
        end;
        if str[i]='"' then if copy(str,i-1,1)<>'\' then op:=not op;
    end;
end;

begin
if length(OldPattern)=0 then begin result:=S;exit;end;
  DefaultOp := False;
  if rfIgnoreCase in Flags then
  begin
    SearchStr := AnsiUpperCase(S);
    Patt := AnsiUpperCase(OldPattern);
  end else
  begin
    SearchStr := S;
    Patt := OldPattern;
  end;
  NewStr := S;
  Result := '';
  while SearchStr <> '' do
  begin
    Offset := ___pos(Patt, SearchStr, InOp, DefaultOp, IgnoreSlash);
    if Offset = 0 then
    begin
      Result := Result + NewStr;
      Break;
    end;
    Result := Result + Copy(NewStr, 1, Offset - 1) + NewPattern;
    NewStr := Copy(NewStr, Offset + Length(OldPattern), MaxInt);
    if not (rfReplaceAll in Flags) then
    begin
      Result := Result + NewStr;
      Break;
    end;
    SearchStr := Copy(SearchStr, Offset + Length(Patt), MaxInt);
  end;
end;

//////////////////////////////////////////////////



function _pos(substr,str:string):integer;var i:integer;op:boolean;begin
    op:=false;
    result:=0;
    for i:=1 to length(str) do begin
        if str[i]='"' then if copy(str,i-1,1)<>'\' then op:=not op;
        if op=false then if copy(str,i,length(substr))=substr then begin
            result:=i;
            exit;
        end;
    end;
    
end;

function _StringReplace(const S, OldPattern, NewPattern: string;
  Flags: TReplaceFlags): string;
var
  SearchStr, Patt, NewStr: string;
  Offset: Integer;
begin if length(OldPattern)=0 then begin result:=S;exit;end;
  if rfIgnoreCase in Flags then
  begin
    SearchStr := AnsiUpperCase(S);
    Patt := AnsiUpperCase(OldPattern);
  end else
  begin
    SearchStr := S;
    Patt := OldPattern;
  end;
  NewStr := S;
  Result := '';
  while SearchStr <> '' do
  begin
    Offset := _pos(Patt, SearchStr);
    if Offset = 0 then
    begin
      Result := Result + NewStr;
      Break;
    end;
    Result := Result + Copy(NewStr, 1, Offset - 1) + NewPattern;
    NewStr := Copy(NewStr, Offset + Length(OldPattern), MaxInt);
    if not (rfReplaceAll in Flags) then
    begin
      Result := Result + NewStr;
      Break;
    end;
    SearchStr := Copy(SearchStr, Offset + Length(Patt), MaxInt);
  end;
end;
 function system(cmd:string):string;
function CreateChildProcess(ExeName, CommadLine: string; StdIn,
  StdOut: THandle): THandle;
var
  piProcInfo: TProcessInformation;
  siStartInfo: TStartupInfo;
begin
  // Set up members of STARTUPINFO structure.
  ZeroMemory(@siStartInfo, SizeOf(TStartupInfo));
  siStartInfo.cb := SizeOf(TStartupInfo);
  siStartInfo.hStdInput := StdIn;
  siStartInfo.hStdOutput := StdOut;

  siStartInfo.dwFlags := STARTF_USESTDHANDLES;
  sistartinfo.wShowWindow :=SW_HIDE;
  // Create the child process.

   CreateProcessA(PChar(ExeName),nil,
    nil,
    nil,
    TRUE,
    0,
    nil,
    nil,
    siStartInfo,
    piProcInfo);


    result:=piProcInfo.hProcess;
end;

 VAR FSAATTR:SECURITY_ATTRIBUTES;
 FChildStdoutRd,FChildStdoutWr,
 FChildStdinRd,FChildStdinWr,
 Tmp1,Tmp2:THandle;

  dwWritten, BufSize: DWORD;
  chBuf: PChar;

  i: Integer;
  dwRead, DesBufSize: DWORD;
  Res: Boolean;
  h:THandle;

begin

FsaAttr.nLength := SizeOf(SECURITY_ATTRIBUTES);
FsaAttr.bInheritHandle := True;
FsaAttr.lpSecurityDescriptor := nil;



CreatePipe(FChildStdoutRd, FChildStdoutWr, @FsaAttr, 0);
CreatePipe(FChildStdinRd, FChildStdinWr, @FsaAttr, 0);



DuplicateHandle(GetCurrentProcess(), FChildStdoutRd,
  GetCurrentProcess(), @Tmp1, 0, False, DUPLICATE_SAME_ACCESS);
DuplicateHandle(GetCurrentProcess(), FChildStdinWr,
  GetCurrentProcess(), @Tmp2, 0, False, DUPLICATE_SAME_ACCESS);

CloseHandle(FChildStdoutRd);
CloseHandle(FChildStdinWr);
FChildStdoutRd := Tmp1;
FChildStdinWr := Tmp2;

h:=CreateChildProcess(SysUtils.GetEnvironmentVariable('ComSpec'), '', FChildStdinRd, FChildStdoutWr);


  chBuf := PChar(CMD + Chr($0D) + Chr($0A));
  BufSize := Length(chBuf);



    try
    BufSize := 0;
    New(chBuf);
    repeat
      for i := 0 to 9 do
      begin
        Res := PeekNamedPipe(FChildStdoutRd, nil, 0, nil, @DesBufSize, nil);
        Res := Res and (DesBufSize > 0);
        if Res then
          Break;
        Sleep(Round(100 / 10));
      end;
      if Res then
      begin
        if DesBufSize > BufSize then
        begin
          FreeMem(chBuf);
          GetMem(chBuf, DesBufSize);
          BufSize := DesBufSize;
        end;
        Res := ReadFile(FChildStdoutRd, chBuf^, BufSize, dwRead, nil);
        Result := Result + LeftStr(chBuf, dwRead);
      end;
    until not Res;
  except
    Result := '';
  end;

  Sleep(100);
  WriteFile(FChildStdinWr, chBuf^, BufSize, dwWritten, nil);
  Result:='';

    try
    BufSize := 0;
    New(chBuf);
    repeat
      for i := 0 to 9 do
      begin
        Res := PeekNamedPipe(FChildStdoutRd, nil, 0, nil, @DesBufSize, nil);
        Res := Res and (DesBufSize > 0);
        if Res then
          Break;
        Sleep(Round(100 / 10));
      end;
      if Res then
      begin
        if DesBufSize > BufSize then
        begin
          FreeMem(chBuf);
          GetMem(chBuf, DesBufSize);
          BufSize := DesBufSize;
        end;
        Res := ReadFile(FChildStdoutRd, chBuf^, BufSize, dwRead, nil);
        Result := Result + LeftStr(chBuf, dwRead);
      end;
    until not Res;
  except
    Result := '';
  end;

  TerminateProcess(h,0);


end;
 function escape_param(str:string):string;begin
     result:=str;

    { result:=stringreplace(result,char(17),'\'+char(17),[rfReplaceAll]);
     result:=stringreplace(result,char(19),'\'+char(19),[rfReplaceAll]);
     result:=stringreplace(result,char(20),'\'+char(20),[rfReplaceAll]);
	 result:=stringreplace(result,'$','\$',[rfReplaceAll]);}

 end;
 function is_char(chr:string):Boolean;begin
    result:=false;
    if length(chr)=0 then exit;
    case ord(chr[1])of

        48..57,65..90,97..122,95: result:=true;

    end;
 end;
 function __pos(substr,str:string;var_rep:boolean=false):integer;var i:integer;begin
    result:=0;
    for i:=1 to length(str) do begin
        if copy(str,i,length(substr))=substr then if copy(str,i-1,1)<>'\' then begin
            if var_rep=true then
               if is_char(copy(str,i+length(substr),1)) then continue;
            result:=i;
            exit;
        end;
    end;

end;
 function __posex(substr,str:string;offset:integer):integer;var i:integer;begin
    result:=0;
    for i:=offset to length(str) do begin
        if copy(str,i,length(substr))=substr then if copy(str,i-1,1)<>'\' then begin
            result:=i;
            exit;
        end;
    end;

end;

 function escape_string(str:string):string;begin
    result:=str;
    if length(str)<2 then exit;
    if str[1]='"' then delete(str,1,1);
    if str[length(str)]='"' then delete(str,length(str),1);
    result:=str;
end;

 function __StringReplace(const S, OldPattern:string; NewPattern: string;
  Flags: TReplaceFlags;VAR_REP:BOOLEAN=FALSE): string;
var
  SearchStr, Patt, NewStr, NP: string;
  Offset: Integer;// " "
begin
if length(OldPattern)=0 then begin result:=S;exit;end;
  NP:=NewPattern;
  if rfIgnoreCase in Flags then
  begin
    SearchStr := AnsiUpperCase(S);
    Patt := AnsiUpperCase(OldPattern);
  end else
  begin
    SearchStr := S;
    Patt := OldPattern;
  end;
  NewStr := S;
  Result := '';
  while SearchStr <> '' do
  begin
    Offset := __pos(Patt, SearchStr,VAR_REP);
    if Offset = 0 then
    begin
      Result := Result + NewStr;
      Break;
    end;

     //////
     (*

        VAR_REP

        $sum = $d1 + $2;

        $<> = "1" + "4";

     *)
     /////


     /////
    if var_rep=false then Result := Result + Copy(NewStr, 1, Offset - 1) + NewPattern
    else begin

    // full word replace  $i=28   $inp  >>  28np


   if ((var_rep=true)and(inside_op(S, __posex(Patt,S,Offset),False)=True)) then

     Result := Result + Copy(NewStr, 1, Offset - 1) + escape_string(NewPattern)

   else

     Result := Result + Copy(NewStr, 1, Offset - 1) + NewPattern


   end;


    NewStr := Copy(NewStr, Offset + Length(OldPattern), MaxInt);
    if not (rfReplaceAll in Flags) then
    begin
      Result := Result + NewStr;
      Break;
    end;
    SearchStr := Copy(SearchStr, Offset + Length(Patt), MaxInt);
  end;
end;







 function __StringReplace_vars(const S, OldPattern:string; NewPattern: array of string;
  Flags: TReplaceFlags;VAR_REP:BOOLEAN=FALSE): string;
var
  SearchStr, Patt, NewStr:string;
  Offset: Integer;LOP:Cardinal;// " "
  _arr:byte;
begin
 _arr:=0;
if length(OldPattern)=0 then begin result:=S;exit;end;
LOP:=length(OldPattern);
  //NP:=NewPattern;
  if rfIgnoreCase in Flags then
  begin
    SearchStr := AnsiUpperCase(S);
    Patt := AnsiUpperCase(OldPattern);
  end else
  begin
    SearchStr := S;
    Patt := OldPattern;
  end;
  NewStr := S;
  Result := '';
  while SearchStr <> '' do
  begin
    Offset := __pos(Patt, SearchStr,VAR_REP);
    if Offset = 0 then
    begin
      Result := Result + NewStr;
      Break;
    end;

    // found #5var
    if copy(SearchStr,Offset+Length(Patt),1)='[' then
        if __pos(']',copy(SearchStr,Offset+Length(Patt)+1,length(SearchStr)))>0 then begin

        _arr:=safe_strtoint(
         Copy(SearchStr,Offset+Length(Patt)+1,
        __pos(']',copy(SearchStr,Offset+Length(Patt)+1,length(SearchStr)))-1)
        ,-1
        );
        if _arr>-1 then
        LOP:=length(OldPattern)+2+length(inttostr(_arr));
        asm nop end;
    end else begin _arr:=0;LOP:=length(OldPattern);end;

    if var_rep=false then Result := Result + Copy(NewStr, 1, Offset - 1) + NewPattern[_arr]
    else begin

    // full word replace  $i=28   $inp  >>  28np


   if ((var_rep=true)and(inside_op(S, __posex(Patt,S,Offset),False)=True)) then

     Result := Result + Copy(NewStr, 1, Offset - 1) + escape_string(NewPattern[_arr])

   else

     Result := Result + Copy(NewStr, 1, Offset - 1) + NewPattern[_arr]


   end;


    NewStr := Copy(NewStr, Offset + LOP, MaxInt);
    if not (rfReplaceAll in Flags) then
    begin
      Result := Result + NewStr;
      Break;
    end;
    SearchStr := Copy(SearchStr, Offset + Length(Patt), MaxInt);
  end;
end;







function untr(const S: String):String;var escape:Boolean; begin

    if ((copy(s,1,1)='"')and(copy(s,length(s),1)='"')) then escape:=true else escape:=false;
    result:=escape_string(s);

//        {\"}034
//        {\\}092
//        {\$}036

result:=__stringreplace(result,'\','\\',[rfReplaceAll]);
result:=__stringreplace(result,'"','\"',[rfReplaceAll]);
result:=__stringreplace(result,'$','\$',[rfReplaceAll]);

if escape=true then result:='"'+result+'"';
end;
function truncate(const S: string): string;
var
  SearchStr, Patt, NewStr, NewPattern: string;
  Offset: Integer;
begin
                                      {[ENQ]<VAR>}
    SearchStr := __StringReplace({StringReplace(}S{,#5,'',[rfReplaceAll])},'$',#5,[rfReplaceAll]);
    Patt := #92; {\}

  NewStr := SearchStr;
  Result := '';
  while SearchStr <> '' do
  begin
    NewPattern := '';
    Offset := pos(Patt, SearchStr);
    if Offset = 0 then
    begin
      Result := Result + NewStr;
      Break;
    end;

      if Length(Copy(NewStr, Offset + 1, 1)) > 0 then
      case Ord(SearchStr[Offset +1]) of
        {\n}110: NewPattern := #13#10;
        {\t}116: NewPattern := #09;
        {\"}034: NewPattern := #34;
        {\\}092: NewPattern := #92;
        {\$}036: NewPattern := #36;
        {\f}102: NewPattern := #01;
        {\b}098: NewPattern := #02;

        else NewPattern := '';
      end;

      Result := Result + Copy(NewStr, 1, Offset - 1) + NewPattern;


    NewStr := Copy(NewStr, Offset + 2, MaxInt);

    SearchStr := Copy(SearchStr, Offset + Length(Patt) + 1, MaxInt);
  end;
end;

 function replace_vars(var __comp:TComp;str:string):string;var i:byte;begin
//__var
    result:=str;
    if __comp.__var_count=0 then exit;
    for i:=0 to __comp.__var_count-1 do begin

     result:=
     (

       __stringreplace_vars(
        result,__comp.__var_ident[i],__comp.__var_value[i],[rfReplaceAll],TRUE)
     );
     end;
end;

function get_var(var __vcomp:TComp;__var:string;__array:byte=0):string;var i:Byte; begin
    __vcomp.__error:=true;
    if __vcomp.__var_count=0 then exit;
    for i:=0 to __vcomp.__var_count-1 do
    if __vcomp.__var_ident[i]=__var then begin
        result:=__vcomp.__var_value[i][__array];
        __vcomp.__error:=false;
        __vcomp.__result:=i;
        exit;
    end;
end;
procedure del_var(var __comp:TComp;__var:string);var i:byte;begin
    _debug_print('del_var(__comp=<Invalid>;__var='+__var+')',true);
    get_var(__comp,__var);
    if __comp.__error =true then exit;
    
    if __comp.__result>0 then dec(__comp.__var_count);

    if __comp.__var_count = __comp.__result then begin
        __comp.__var_ident[__comp.__result]:='';
       for i:=0 to 255 do __comp.__var_value[__comp.__result][i]:='';

        exit;
    end;


        __comp.__var_ident[__comp.__result]:=__comp.__var_ident[__comp.__var_count];
        __comp.__var_value[__comp.__result]:=__comp.__var_value[__comp.__var_count];

        __comp.__var_ident[__comp.__var_count]:='';
        for i:=0 to 255 do __comp.__var_value[__comp.__var_count][i]:='';



end;
procedure set_var(var __vcomp:TComp;__var,__value:string);var _arr:byte;begin
    _debug_print('set_var(__comp=<Invalid>;__var='+__var+';__value='+__value+')',true);
    _arr:=0;
    //parse __var   ($h or $h[2])
    if ((pos('[',__var)>0)and(pos(']',__var)>0))then begin //yep!! this is array

       if rightstr(__var,1)=']' then delete(__var,length(__var),1);
       _arr:=byte(safe_strtoint(copy(__var,pos('[',__var)+1,length(__var))));

        __var:=copy(__var,1,pos('[',__var)-1);

    end;

    get_var(__vcomp,__var,_arr);
    if __vcomp.__error =true then begin
        __vcomp.__var_ident[__vcomp.__var_count]:=__var;
        __vcomp.__var_value[__vcomp.__var_count][_arr]:=__value;
        inc(__vcomp.__var_count);
    end else begin
        __vcomp.__var_value[__vcomp.__result][_arr]:=__value;
    end;

end;
function RunExternalFunc(Dll,Func:string):string;var _h:THandle;_f:TFunction;begin
     result:='';
    _h:=LoadLibrary(PAnsiChar(Dll));
    if _h < HINSTANCE_ERROR then exit;
    @_f:=GetProcAddress(_h,PAnsiChar(Func));
    if Assigned(_f) then result:=inttostr(_f);
    FreeLibrary(_h);
end;
procedure RunExternalProc(Dll,Func:string);var _h:THandle;_p:TProcedure;begin

    _h:=LoadLibrary(PAnsiChar(Dll));
    if _h<=0 then exit;
    @_p:=GetProcAddress(_h,PAnsiChar(Func));
    if Assigned(_p) then _p();
    FreeLibrary(_h);
end;
function rand(rand_from,rand_to:integer):integer;
var X ,RES:integer;
begin
randomize;
x:=abs(rand_from-(rand_to+1));
RES:=random(x);
rand:=RES + rand_from;
{ old random : [0 >= X >= RANGE]  }

end;

function _str(str:string;x:integer):string;var i:integer;begin
    result:='';
    for i:=1 to x do result:=result+str;
end;
function _trim(const S: string): string;
var
  I, L: Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and ((S[I]=Char(9)) or (S[I]=Char(32))) do Inc(I);
  if I > L then Result := '' else
  begin
    while S[L] <= ' ' do Dec(L);
    Result := Copy(S, I, L - I + 1);
  end;
end;
function get_word_count(str:string):integer;var word:boolean;x:integer;begin
  str:=_trim(str);
  str:=stringReplace(str,#9,#32,[rfReplaceAll]);
  if length(str)=0 then begin result:=0;exit;end;
  word:=true;
  result:=1;
  for x:=0 to length(str)do
      if str[x]=' ' then (if word then begin inc(result);word:=false;end else word:=false) else word:=true;

end;
function first_word(str:string):string;var y:integer;begin
    str:=_trim(str)+' ';
    str:=stringReplace(str,#9,#32,[rfReplaceAll]);
    for y:=0 to(length(str))do
      if str[y]=' ' then begin result:=_trim(copy(str,1,y));exit;end;
end;

function last_word(str:string):string;var q:integer;begin
    str:=_trim(str);
    str:=stringReplace(str,#9,#32,[rfReplaceAll]);
    for q:=length(str)downto(0)do
      if str[q]=' ' then begin result:=_trim(copy(str,q,length(str)));exit;end;
end;

function get_word(str:string;count:integer):string;var word:boolean;word_str:string;z,wc:integer;begin
     if length(str)=0 then exit;
     str:=_trim(str);
     str:=stringReplace(str,#9,#32,[rfReplaceAll]);
     if count>get_word_count(str) then exit;
     if count=1 then begin result:=first_word(str);exit;end;
     word:=true;
     wc:=1;
     for z:=0 to length(str)do begin
      if str[z]=' ' then (if word then begin word_str:=_trim(copy(str,z+1,length(str)));inc(wc);word:=false;end else word:=false) else word:=true;
      if wc=count then begin result:=first_word(word_str);exit;end;
     end;
end;function DosToWin(source:string):string ;
var T:string; a:integer; i:integer; C:char;
begin
  for i:=1 to length(source) do begin
    C := source[i];
    if ord(C) <128 then
      T := T + C
    else begin
      a := pos(C,wDOS);
      if a = 0 then
        T := T + '?'
      else
        T := T + copy(wWIN,a,1);
      end;
  end;

  result := T;
end;



function WinToDos(source:string):string ;
var T:string; a:integer; i:integer; C:char;
begin
  for i:=1 to length(source) do begin
    C := source[i];
    if ord(C) <128 then
      T := T + C
    else begin
      a := pos(C,wWIN);
      if a = 0 then
        T := T + '?'
      else
        T := T + copy(wDOS,a,1);
      end;
  end;

  result := T;
end;

 function comp_statement(statement:string):string;
procedure rep(rep_from:string;rep_to:integer);begin
    statement:=__stringreplace(statement,#5'_'+rep_from,inttostr(rep_to),[rfReplaceAll]);
end;
procedure reps(rep_from:string;rep_to:string);begin
    statement:=__stringreplace(statement,#5'_'+rep_from,'"'+rep_to+'"',[rfReplaceAll],TRUE);
end;
begin
rep('MB_OK',$00000000);
rep('MB_OKCANCEL',$00000001);
rep('MB_ABORTRETRYIGNORE',$00000002);
rep('MB_YESNOCANCEL',$00000003);
rep('MB_YESNO',$00000004);
rep('MB_RETRYCANCEL',$00000005);
rep('MB_ICONHAND',$00000010);
rep('MB_ICONQUESTION',$00000020);
rep('MB_ICONEXCLAMATION',$00000030);
rep('MB_ICONASTERISK',$00000040);
rep('MB_USERICON',$00000080);
rep('MB_ICONWARNING',MB_ICONEXCLAMATION);
rep('MB_ICONERROR',MB_ICONHAND);
rep('MB_ICONINFORMATION',MB_ICONASTERISK);
rep('MB_ICONSTOP',MB_ICONHAND);
rep('MB_DEFBUTTON1',$00000000);
rep('MB_DEFBUTTON2',$00000100);
rep('MB_DEFBUTTON3',$00000200);
rep('MB_DEFBUTTON4',$00000300);
rep('MB_APPLMODAL',$00000000);
rep('MB_SYSTEMMODAL',$00001000);
rep('MB_TASKMODAL',$00002000);
rep('MB_HELP',$00004000);
rep('MB_NOFOCUS',$00008000);
rep('MB_SETFOREGROUND',$00010000);
rep('MB_DEFAULT_DESKTOP_ONLY',$00020000);
rep('MB_TOPMOST',$00040000);
rep('MB_RIGHT',$00080000);
rep('MB_RTLREADING',$00100000);
rep('MB_SERVICE_NOTIFICATION',$00200000);
rep('MB_SERVICE_NOTIFICATION_NT3X',$00040000);
rep('MB_TYPEMASK',$0000000F);
rep('MB_ICONMASK',$000000F0);
rep('MB_DEFMASK',$00000F00);
rep('MB_MODEMASK',$00003000);
rep('MB_MISCMASK',$0000C000);
rep('ID_OK',1);
rep('ID_CANCEL',2);
rep('ID_ABORT',3);
rep('ID_RETRY',4);
rep('ID_IGNORE',5);
rep('ID_YES',6);
rep('ID_NO',7);
rep('ID_CLOSE',8);
rep('ID_HELP',9);
rep('ID_TRYAGAIN',10);
rep('ID_CONTINUE',11);

rep('SW_HIDE',0);
rep('SW_SHOWNORMAL',1);
rep('SW_NORMAL',1);
rep('SW_SHOWMINIMIZED',2);
rep('SW_SHOWMAXIMIZED',3);
rep('SW_MAXIMIZE',3);
rep('SW_SHOWNOACTIVATE',4);
rep('SW_SHOW',5);
rep('SW_MINIMIZE',6);
rep('SW_SHOWMINNOACTIVE',7);
rep('SW_SHOWNA',8);
rep('SW_RESTORE',9);
rep('SW_SHOWDEFAULT',10);

rep('FOREGROUND_BLACK',0);
rep('FOREGROUND_NAVY',1);
rep('FOREGROUND_GREEN',2);
rep('FOREGROUND_TEAL',3);
rep('FOREGROUND_MAROON',4);
rep('FOREGROUND_PURPLE',5);
rep('FOREGROUND_OLIVE',6);
rep('FOREGROUND_SILVER',7);
rep('FOREGROUND_GRAY',8);
rep('FOREGROUND_BLUE',9);
rep('FOREGROUND_LIME',10);
rep('FOREGROUND_AQUA',11);
rep('FOREGROUND_RED',12);
rep('FOREGROUND_FUCHSIA',13);
rep('FOREGROUND_YELLOW',14);
rep('FOREGROUND_WHITE',15);

rep('BACKGROUND_BLACK',(16*0));
rep('BACKGROUND_NAVY',(16*1));
rep('BACKGROUND_GREEN',(16*2));
rep('BACKGROUND_TEAL',(16*3));
rep('BACKGROUND_MAROON',(16*4));
rep('BACKGROUND_PURPLE',(16*5));
rep('BACKGROUND_OLIVE',(16*6));
rep('BACKGROUND_SILVER',(16*7));
rep('BACKGROUND_GRAY',(16*8));
rep('BACKGROUND_BLUE',(16*9));
rep('BACKGROUND_LIME',(16*10));
rep('BACKGROUND_AQUA',(16*11));
rep('BACKGROUND_RED',(16*12));
rep('BACKGROUND_FUCHSIA',(16*13));
rep('BACKGROUND_YELLOW',(16*14));
rep('BACKGROUND_WHITE',(16*15));



rep('CW_USEDEFAULT',DWORD($80000000));
rep('CW_DESKTOPCENTER',$FFFFFF);

rep('WS_OVERLAPPED',0);
rep('WS_POPUP',DWORD($80000000));
rep('WS_CHILD',$40000000);
rep('WS_MINIMIZE',$20000000);
rep('WS_VISIBLE',$10000000);
rep('WS_DISABLED',$8000000);
rep('WS_CLIPSIBLINGS',$4000000);
rep('WS_CLIPCHILDREN',$2000000);
rep('WS_MAXIMIZE',$1000000);
rep('WS_CAPTION',$C00000);
rep('WS_BORDER',$800000);
rep('WS_DLGFRAME',$400000);
rep('WS_VSCROLL',$200000);
rep('WS_HSCROLL',$100000);
rep('WS_SYSMENU',$80000);
rep('WS_THICKFRAME',$40000);
rep('WS_GROUP',$20000);
rep('WS_TABSTOP',$10000);

rep('WS_MINIMIZEBOX',$20000);
rep('WS_MAXIMIZEBOX',$10000);

rep('WS_TILED',WS_OVERLAPPED);
rep('WS_ICONIC',WS_MINIMIZE);
rep('WS_SIZEBOX',WS_THICKFRAME);

rep('WS_OVERLAPPEDWINDOW',(0 or $C00000 or $80000 or $40000 or $20000 or $10000));
rep('WS_TILEDWINDOW',WS_OVERLAPPEDWINDOW);
rep('WS_POPUPWINDOW',(DWORD($80000000) or $800000 or $80000));
rep('WS_CHILDWINDOW',($40000000));

rep('WS_EX_DLGMODALFRAME',1);
rep('WS_EX_NOPARENTNOTIFY',4);
rep('WS_EX_TOPMOST',8);
rep('WS_EX_ACCEPTFILES',$10);
rep('WS_EX_TRANSPARENT',$20);
rep('WS_EX_MDICHILD',$40);
rep('WS_EX_TOOLWINDOW',$80);
rep('WS_EX_WINDOWEDGE',$100);
rep('WS_EX_CLIENTEDGE',$200);
rep('WS_EX_CONTEXTHELP',$400);

rep('WS_EX_RIGHT',$1000);
rep('WS_EX_LEFT',0);
rep('WS_EX_RTLREADING',$2000);
rep('WS_EX_LTRREADING',0);
rep('WS_EX_LEFTSCROLLBAR',$4000);
rep('WS_EX_RIGHTSCROLLBAR',0);

rep('WS_EX_CONTROLPARENT',$10000);
rep('WS_EX_STATICEDGE',$20000);
rep('WS_EX_APPWINDOW',$40000);

rep('WS_EX_LAYERED',$00080000);
rep('WS_EX_NOINHERITLAYOUT',$00100000); 
rep('WS_EX_LAYOUTRTL',$00400000);
rep('WS_EX_COMPOSITED',$02000000);
rep('WS_EX_NOACTIVATE',$08000000);


rep('BS_PUSHBUTTON',0);
rep('BS_DEFPUSHBUTTON',1);
rep('BS_CHECKBOX',2);
rep('BS_AUTOCHECKBOX',3);
rep('BS_RADIOBUTTON',4);
rep('BS_3STATE',5);
rep('BS_AUTO3STATE',6);
rep('BS_GROUPBOX',7);
rep('BS_USERBUTTON',8);
rep('BS_AUTORADIOBUTTON',9);
rep('BS_OWNERDRAW',11);
rep('BS_LEFTTEXT',$20);
rep('BS_TEXT',0);
rep('BS_ICON',$40);
rep('BS_BITMAP',$80);
rep('BS_LEFT',$100);
rep('BS_RIGHT',$200);
rep('BS_CENTER',768);
rep('BS_TOP',$400);
rep('BS_BOTTOM',$800);
rep('BS_VCENTER',3072);
rep('BS_PUSHLIKE',$1000);
rep('BS_MULTILINE',$2000);
rep('BS_NOTIFY',$4000);
rep('BS_FLAT',$8000);
rep('BS_RIGHTBUTTON',$20);

rep('BST_UNCHECKED',0);
rep('BST_CHECKED',1);
rep('BST_INDETERMINATE',2);
rep('BST_PUSHED',4);
rep('BST_FOCUS',8);

rep('SS_LEFT',0);
rep('SS_CENTER',1);
rep('SS_RIGHT',2);
rep('SS_ICON',3);
rep('SS_BLACKRECT',4);
rep('SS_GRAYRECT',5);
rep('SS_WHITERECT',6);
rep('SS_BLACKFRAME',7);
rep('SS_GRAYFRAME',8);
rep('SS_WHITEFRAME',9);
rep('SS_USERITEM',10);
rep('SS_SIMPLE',11);
rep('SS_LEFTNOWORDWRAP',12);
rep('SS_BITMAP',14);
rep('SS_OWNERDRAW',13);
rep('SS_ENHMETAFILE',15);
rep('SS_ETCHEDHORZ',$10);
rep('SS_ETCHEDVERT',17);
rep('SS_ETCHEDFRAME',18);
rep('SS_TYPEMASK',31);
rep('SS_NOPREFIX',$80);
rep('SS_NOTIFY',$100);
rep('SS_CENTERIMAGE',$200);
rep('SS_RIGHTJUST',$400);
rep('SS_REALSIZEIMAGE',$800);
rep('SS_SUNKEN',$1000);
rep('SS_ENDELLIPSIS',$4000);
rep('SS_PATHELLIPSIS',$8000);
rep('SS_WORDELLIPSIS',$C000);
rep('SS_ELLIPSISMASK',$C000);


rep('WM_NULL',$0000);
rep('WM_CREATE',$0001);
rep('WM_DESTROY',$0002);
rep('WM_MOVE',$0003);
rep('WM_SIZE',$0005);
rep('WM_ACTIVATE',$0006);
rep('WM_SETFOCUS',$0007);
rep('WM_KILLFOCUS',$0008);
rep('WM_ENABLE',$000A);
rep('WM_SETREDRAW',$000B);
rep('WM_SETTEXT',$000C);
rep('WM_GETTEXT',$000D);
rep('WM_GETTEXTLENGTH',$000E);
rep('WM_PAINT',$000F);
rep('WM_CLOSE',$0010);
rep('WM_QUERYENDSESSION',$0011);
rep('WM_QUIT',$0012);
rep('WM_QUERYOPEN',$0013);
rep('WM_ERASEBKGND',$0014);
rep('WM_SYSCOLORCHANGE',$0015);
rep('WM_ENDSESSION',$0016);
rep('WM_SYSTEMERROR',$0017);
rep('WM_SHOWWINDOW',$0018);
rep('WM_CTLCOLOR',$0019);
rep('WM_WININICHANGE',$001A);
rep('WM_SETTINGCHANGE',$001A);
rep('WM_DEVMODECHANGE',$001B);
rep('WM_ACTIVATEAPP',$001C);
rep('WM_FONTCHANGE',$001D);
rep('WM_TIMECHANGE',$001E);
rep('WM_CANCELMODE',$001F);
rep('WM_SETCURSOR',$0020);
rep('WM_MOUSEACTIVATE',$0021);
rep('WM_CHILDACTIVATE',$0022);
rep('WM_QUEUESYNC',$0023);
rep('WM_GETMINMAXINFO',$0024);
rep('WM_PAINTICON',$0026);
rep('WM_ICONERASEBKGND',$0027);
rep('WM_NEXTDLGCTL',$0028);
rep('WM_SPOOLERSTATUS',$002A);
rep('WM_DRAWITEM',$002B);
rep('WM_MEASUREITEM',$002C);
rep('WM_DELETEITEM',$002D);
rep('WM_VKEYTOITEM',$002E);
rep('WM_CHARTOITEM',$002F);
rep('WM_SETFONT',$0030);
rep('WM_GETFONT',$0031);
rep('WM_SETHOTKEY',$0032);
rep('WM_GETHOTKEY',$0033);
rep('WM_QUERYDRAGICON',$0037);
rep('WM_COMPAREITEM',$0039);
rep('WM_GETOBJECT',$003D);
rep('WM_COMPACTING',$0041);
rep('WM_COMMNOTIFY',$0044);

rep('WM_WINDOWPOSCHANGING',$0046);
rep('WM_WINDOWPOSCHANGED',$0047);
rep('WM_POWER',$0048);

rep('WM_COPYDATA',$004A);
rep('WM_CANCELJOURNAL',$004B);
rep('WM_NOTIFY',$004E);
rep('WM_INPUTLANGCHANGEREQUEST',$0050);
rep('WM_INPUTLANGCHANGE',$0051);
rep('WM_TCARD',$0052);
rep('WM_HELP',$0053);
rep('WM_USERCHANGED',$0054);
rep('WM_NOTIFYFORMAT',$0055);

rep('WM_CONTEXTMENU',$007B);
rep('WM_STYLECHANGING',$007C);
rep('WM_STYLECHANGED',$007D);
rep('WM_DISPLAYCHANGE',$007E);
rep('WM_GETICON',$007F);
rep('WM_SETICON',$0080);


rep('WM_KEYFIRST',$0100);
rep('WM_KEYDOWN',$0100);
rep('WM_KEYUP',$0101);
rep('WM_CHAR',$0102);
rep('WM_DEADCHAR',$0103);
rep('WM_SYSKEYDOWN',$0104);
rep('WM_SYSKEYUP',$0105);
rep('WM_SYSCHAR',$0106);
rep('WM_SYSDEADCHAR',$0107);
rep('WM_KEYLAST',$0108);

rep('WM_INITDIALOG',$0110);
rep('WM_COMMAND',$0111);
rep('WM_SYSCOMMAND',$0112);
rep('WM_TIMER',$0113);
rep('WM_HSCROLL',$0114);
rep('WM_VSCROLL',$0115);
rep('WM_INITMENU',$0116);
rep('WM_INITMENUPOPUP',$0117);
rep('WM_MENUSELECT',$011F);
rep('WM_MENUCHAR',$0120);
rep('WM_ENTERIDLE',$0121);
rep('WM_MENURBUTTONUP',$0122);
rep('WM_MENUDRAG',$0123);
rep('WM_MENUGETOBJECT',$0124);
rep('WM_UNINITMENUPOPUP',$0125);
rep('WM_MENUCOMMAND',$0126);
rep('WM_CHANGEUISTATE',$0127);
rep('WM_UPDATEUISTATE',$0128);
rep('WM_QUERYUISTATE',$0129);
rep('WM_CTLCOLORMSGBOX',$0132);
rep('WM_CTLCOLOREDIT',$0133);
rep('WM_CTLCOLORLISTBOX',$0134);
rep('WM_CTLCOLORBTN',$0135);
rep('WM_CTLCOLORDLG',$0136);
rep('WM_CTLCOLORSCROLLBAR',$0137);
rep('WM_CTLCOLORSTATIC',$0138);

rep('WM_MOUSEFIRST',$0200);
rep('WM_MOUSEMOVE',$0200);
rep('WM_LBUTTONDOWN',$0201);
rep('WM_LBUTTONUP',$0202);
rep('WM_LBUTTONDBLCLK',$0203);
rep('WM_RBUTTONDOWN',$0204);
rep('WM_RBUTTONUP',$0205);
rep('WM_RBUTTONDBLCLK',$0206);
rep('WM_MBUTTONDOWN',$0207);
rep('WM_MBUTTONUP',$0208);
rep('WM_MBUTTONDBLCLK',$0209);
rep('WM_MOUSEWHEEL',$020A);
rep('WM_MOUSELAST',$020A);

rep('WM_PARENTNOTIFY',$0210);
rep('WM_ENTERMENULOOP',$0211);
rep('WM_EXITMENULOOP',$0212);
rep('WM_NEXTMENU',$0213);

rep('WM_TRAYNOTIFY',WM_TRAYNOTIFY);


rep('MF_STRING',0);
rep('MF_BITMAP',4);
rep('MF_SEPARATOR',$800);
rep('MF_ENABLED',0);
rep('MF_GRAYED',1);
rep('MF_DISABLED',2);
rep('MF_UNCHECKED',0);
rep('MF_CHECKED',8);
rep('MF_USECHECKBITMAPS',$200);
rep('MF_POPUP',$10);

rep('NIM_ADD',$00000000);
rep('NIM_MODIFY',$00000001);
rep('NIM_DELETE',$00000002);


rep('MENU',0);
rep('POPUPMENU',1);

rep('SCREEN_WIDTH',1);
rep('SCREEN_HEIGHT',2);
rep('MOUSE_X',1);
rep('MOUSE_Y',2);

rep('WM_COMMAND',$0111);

rep('WM_USER',$0400);



rep('VK_LBUTTON',1);
rep('VK_RBUTTON',2);
rep('VK_CANCEL',3);
rep('VK_MBUTTON',4);
rep('VK_BACK',8);
rep('VK_TAB',9);
rep('VK_CLEAR',12);
rep('VK_RETURN',13);
rep('VK_SHIFT',$10);
rep('VK_CONTROL',17);
rep('VK_MENU',18);
rep('VK_PAUSE',19);
rep('VK_CAPITAL',20);
rep('VK_KANA',21);
rep('VK_HANGUL',21);
rep('VK_JUNJA',23);
rep('VK_FINAL',24);
rep('VK_HANJA',25);
rep('VK_KANJI',25);
rep('VK_CONVERT',28);
rep('VK_NONCONVERT',29);
rep('VK_ACCEPT',30);
rep('VK_MODECHANGE',31);
rep('VK_ESCAPE',27);
rep('VK_SPACE',$20);
rep('VK_PRIOR',33);
rep('VK_NEXT',34);
rep('VK_END',35);
rep('VK_HOME',36);
rep('VK_LEFT',37);
rep('VK_UP',38);
rep('VK_RIGHT',39);
rep('VK_DOWN',40);
rep('VK_SELECT',41);
rep('VK_PRINT',42);
rep('VK_EXECUTE',43);
rep('VK_SNAPSHOT',44);
rep('VK_INSERT',45);
rep('VK_DELETE',46);
rep('VK_HELP',47);
rep('VK_LWIN',91);
rep('VK_RWIN',92);
rep('VK_APPS',93);
rep('VK_NUMPAD0',96);
rep('VK_NUMPAD1',97);
rep('VK_NUMPAD2',98);
rep('VK_NUMPAD3',99);
rep('VK_NUMPAD4',100);
rep('VK_NUMPAD5',101);
rep('VK_NUMPAD6',102);
rep('VK_NUMPAD7',103);
rep('VK_NUMPAD8',104);
rep('VK_NUMPAD9',105);
rep('VK_MULTIPLY',106);
rep('VK_ADD',107);
rep('VK_SEPARATOR',108);
rep('VK_SUBTRACT',109);
rep('VK_DECIMAL',110);
rep('VK_DIVIDE',111);
rep('VK_F1',112);
rep('VK_F2',113);
rep('VK_F3',114);
rep('VK_F4',115);
rep('VK_F5',116);
rep('VK_F6',117);
rep('VK_F7',118);
rep('VK_F8',119);
rep('VK_F9',120);
rep('VK_F10',121);
rep('VK_F11',122);
rep('VK_F12',123);
rep('VK_F13',124);
rep('VK_F14',125);
rep('VK_F15',126);
rep('VK_F16',127);
rep('VK_F17',128);
rep('VK_F18',129);
rep('VK_F19',130);
rep('VK_F20',131);
rep('VK_F21',132);
rep('VK_F22',133);
rep('VK_F23',134);
rep('VK_F24',135);
rep('VK_NUMLOCK',144);
rep('VK_SCROLL',145);
rep('VK_LSHIFT',160);
rep('VK_RSHIFT',161);
rep('VK_LCONTROL',162);
rep('VK_RCONTROL',163);
rep('VK_LMENU',164);
rep('VK_RMENU',165);
rep('VK_PROCESSKEY',229);
rep('VK_ATTN',246);
rep('VK_CRSEL',247);
rep('VK_EXSEL',248);
rep('VK_EREOF',249);
rep('VK_PLAY',250);
rep('VK_ZOOM',251);
rep('VK_NONAME',252);
rep('VK_PA1',253);
rep('VK_OEM_CLEAR',254);



reps('CURRENT_FILE','"'+escape_string(ParamStr(1))+'"');
reps('SCRIPT_PROGRAM','"'+escape_string(ParamStr(0))+'"');
rep('HINSTANCE',hInstance);

reps('BUTTON','"BUTTON"');
reps('LABEL','"STATIC"');
reps('TEXTBOX','"EDIT"');


    result:=statement;

end;

 function comp_replace_all(__comp:TComp;str,t_line:string;acc:byte;t_file:string=''):string;begin
    //*--str:=stringreplace(str,'\\',char(20),[rfReplaceAll]);


    
    str := truncate(str);
	//*--str:=stringreplace(str,'\$',char(17),[rfReplaceAll]);
	  str:=replace_vars(__comp,str);
    str:=comp_statement(str);
    (*
    str:=stringreplace(str,#5'_VAR',{'"'+}escape_param({stringreplace(__var,'"','\"',[rfreplaceall])}){+'"'},[rfReplaceAll]);
    str:=stringreplace(str,#5'_FILE',{'"'+}escape_param({stringreplace(t_file,'"','\"',[rfreplaceall])}){+'"'},[rfReplaceAll]);
    str:=stringreplace(str,#5'_LINE',{'"'+}escape_param({stringreplace(t_line,'"','\"',[rfreplaceall])}){+'"'},[rfReplaceAll]);
    *)
    //*--str:=stringreplace(str,'$_ACC',{'"'+}escape_param(stringreplace(getacc(acc),'"','\"',[rfreplaceall])){+'"'},[rfReplaceAll]);


      // 05


    str:=__stringreplace(str,char(06),'"."',[rfReplaceAll]);

	result:=str;

	exit;

  
    //str:=__stringreplace(str,char(17),'$',[rfReplaceAll]);
    {
    str:=_StringReplace(str,'.',char(18),[rfReplaceAll]);
    str:=_StringReplace(str,'"'+char(18)+'"','',[rfReplaceAll]);
    str:= StringReplace(str,char(18),'.',[rfReplaceAll]);
    }
    str:=stringreplace(str,'\"',char(19),[rfReplaceAll]);
    result:=str;
end;

 function comp_get_param(var __comp:TComp;acc:byte;t_line:string;str:string):string;begin
//result:=str;
if length(str)=0 then exit;
//w:=0;
//d:=false;

      str:=_trim(str);
      str:=comp_replace_all(__comp,str,t_line,acc);
         //str:=stringreplace(str,char(20),'\',[rfReplaceAll]);
    result:='';
   if ((_pos('(',str)>0)and(str[length(str)]=')'))then begin
       result:=copy(str,_pos('(',str)+1,length(str));
       result:=copy(result,1,length(result)-1);
   end;

{
    for i:=1 to length(str)do begin
    if str[i]='"' then d:=not d;

     if str[i]='(' then inc(w);
      if w=level then begin
          param:=copy(str,i+1,_pos(')',copy(str,i+1,length(str)))-1);
          _op:='';
          for j:=i-1 downto 1 do
            if ((ord(str[j])>=64) and (ord(str[j])<=122))then
              _op:=_op+str[j] else break;
           op:='';
          for j:=length(_op) downto 1 do op:=op+_op[j];
          result:=param;
          //str:=stringreplace(str,op+'('+param+')',comp_op(formt,execute,acc,op,param),[]);
          exit;
      end;
    end;
}
end;

 function GetPM_count(str:string;limit_char:byte=44):DWORD;var op:boolean;f:word;begin
    result:=1;
    op:=false;
    for f:=1 to length(str)do begin
     if str[f]='"' then if copy(str,f-1,1)<>'\' then op:=not op;
     if op=false then if chr(limit_char)=str[f] then result:=result+1;

    end;
    if str='' then result:=0;
end;
function GetPM(str:string;xt_index:byte;limit_char:byte=44):string;
var sd:string;i:byte;
 begin
    result:='';
    if xt_index>getpm_count(str,limit_char) then exit;
    if str='' then exit;
    sd:=str;
    {if sd[1]<>chr(limit_char)then }sd:=chr(limit_char)+sd;
    if sd[length(sd)]<>chr(limit_char)then sd:=sd+chr(limit_char);
    i:=0;
    repeat
        inc(i);
        sd:=copy(sd,_pos(chr(limit_char),sd)+1,length(sd));
    until i=xt_index;

    result:=copy(sd,1,_pos(chr(limit_char),sd)-1);

end;


function string_compare(op,e1_s,e2_s:string):boolean;var e1,e2:integer;begin

  e1:=safe_strtoint(e1_s);
  e2:=safe_strtoint(e2_s);

 _debug_print('string_compare(op=['+op+'];e1='+inttostr(e1)+';e2='+inttostr(e2)+')',true);
result:=false;
    if op='==' then begin
     if e1=e2 then result:=true;
     if e1<>e2 then result:=false;
      exit;
    end;

    if op='<>' then begin
        if e1<>e2 then result:=true;
        if e1=e2 then result:=false;
        exit;
    end;

    if op='>>' then begin
        if e1>e2 then result:=true;
        if e1<=e2 then result:=false;
        exit;
    end;

    if op='<<' then begin
        if e1<e2 then result:=true;
        if e1>=e2 then result:=false;
        exit;
    end;
   if op='>=' then begin
        if e1>=e2 then result:=true;
        if e1<e2 then result:=false;
        exit;
    end;
    if op='<=' then begin
        if e1<=e2 then result:=true;
        if e1>e2 then result:=false;
        exit;
    end;

end;





// Trim Compilator v2.0


{
  $_VAR  [variable]
  $_LINE [current line]
  $_ACC  [current acc value]
  \"  ["]
  \n  [new line]
  \t  [tab]
}
function rs(input:string):string;begin

end;
function trim_comp_line(str:string):string;var j:cardinal;op:boolean;_str:string;begin
  _str:='';
  op:=false;
  for j:=1 to length(str)do begin

       if str[j]='"' then op:=not op;
       if ((str[j]=char(32))or(str[j]=char(09))) then
       (if op=true then _str:=_str+str[j])else
         _str:=_str+str[j];



    end;
     result:=_str;

end;
function DigitsOnly(instr:string):string;var i:integer;begin
result:='';
    for i:=1 to length(instr)do
    case instr[i]of
    '1','2','3','4','5','6','7','8','9','0'{,'.'}:result:=result+instr[i];
    end;
end;
function IsDigitsOnly(instr:string):boolean;var i:integer;begin
result:=true;
if length(instr)=0 then begin result:=false;exit;end;
    for i:=1 to length(instr)do
    case instr[i]of
    '1','2','3','4','5','6','7','8','9','0'{,'.'}:begin end;
    else result:=false;
    end;
end;
     // str must be
     // 1+2--2


// extracted from Math

function IntPower(const Base: Extended; const Exponent: Integer): Integer;
asm
        mov     ecx, eax
        cdq
        fld1                      { Result := 1 }
        xor     eax, edx
        sub     eax, edx          { eax := Abs(Exponent) }
        jz      @@3
        fld     Base
        jmp     @@2
@@1:    fmul    ST, ST            { X := Base * Base }
@@2:    shr     eax,1
        jnc     @@1
        fmul    ST(1),ST          { Result := Result * X }
        jnz     @@1
        fstp    st                { pop X from FPU stack }
        cmp     ecx, 0
        jge     @@3
        fld1
        fdivrp                    { Result := 1 / Result }
@@3:
        fwait
end;
function Power(const Base, Exponent: Integer): Integer;
begin
  if Exponent = 0 then
    Result := 1               { n**0 = 1 }
  else if (Base = 0) and (Exponent > 0) then
    Result := 0               { 0**n = 0, n > 0 }
  else //if (Frac(Exponent) = 0) and (Abs(Exponent) <= MaxInt) then
    Result := IntPower(Base, Integer(Trunc(Exponent)))
  //else
   // Result := Exp(Exponent * Ln(Base))
end;


function math_compiler(str:string):string;var _pos:integer;_str,e1,e2,opc:string;op:boolean;math:integer;i:integer;
function _add(e1,e2:string):string;begin result:=inttostr(safe_strtoint(e1)  +   safe_strtoint(e2));end;
function _sub(e1,e2:string):string;begin result:=inttostr(safe_strtoint(e1)  -   safe_strtoint(e2));end;
function _mul(e1,e2:string):string;begin result:=inttostr(safe_strtoint(e1)  *   safe_strtoint(e2));end;
function _div(e1,e2:string):string;begin result:=inttostr(safe_strtoint(e1) div  safe_strtoint(e2));end;
function _pow(e1,e2:string):string;begin result:=inttostr(power(safe_strtoint(e1),safe_strtoint(e2)));end;
function check_str():boolean;var i:integer;begin
    result:=true;
    for i:=1 to length(str) do case ord(str[i])of
        {0..9}48..57:;
        {/  *  -  +  ^}
        47,42,45,43,94:;
        else begin result:=false;exit;end;
    end;

end;
function pos_op(substr,str:string):integer;var i:integer;begin
								result:=0;
								for i:=1 to length(str) do begin
										if ((copy(str,i,length(substr))=substr)AND(isdigitsonly(copy(str,i-1,1))=true)) then begin
										result:=i;
										exit;
									end;
								end;

end;
function _gop(var _op:string):integer;var a:integer;begin
							  result:=0;
                              a:=pos('+',copy(str,_pos,length(str)));
                              if a >0 then begin _op:='+';result:=a;end;
                              a:=pos_op('-',copy(str,_pos,length(str)));
							  if ((result>0)and(result<a))then else
                              if a >0 then begin _op:='-';result:=a;end;
                              a:=pos('*',copy(str,_pos,length(str)));
                              if a >0 then begin _op:='*';result:=a;end;
                              a:=pos('/',copy(str,_pos,length(str)));
							  if ((result>0)and(result<a))then else
                              if a >0 then begin _op:='/';result:=a;end;
                              a:=pos('^',copy(str,_pos,length(str)));
                              if a >0 then begin _op:='^';result:=a;end;
end;
function _cmp(_op,e1,e2:string):string;var ep_s:array[1..2]of boolean;begin
							  ep_s[1]:=false;ep_s[2]:=false;
							  if copy(e1,1,1)='-' then begin delete(e1,1,1);ep_s[1]:=true;end;
							  if copy(e2,1,1)='-' then begin delete(e2,1,1);ep_s[2]:=true;end;

                              if isdigitsonly(e1)=false then e1:='0';
                              if isdigitsonly(e2)=false then e2:='0';
							  
							  if ep_s[1]=true then e1:='-'+e1;
							  if ep_s[2]=true then e2:='-'+e2;

                              if (safe_strtoint(e2)<>0)then
                              if _op='/' then result:=_div(e1,e2);
                              if _op='*' then result:=_mul(e1,e2);
                              if _op='-' then result:=_sub(e1,e2);
                              if _op='+' then result:=_add(e1,e2);
                              if _op='^' then result:=_pow(e1,e2);

end;

function math_count(input:string):word;var k:integer;begin
op:=false;
result:=0;
  for k:=1 to length(input)do begin
      if input[k]='"' then if copy(input,k-1,1)<>'\' then op:=not op;
      if ((input[k]='*')and(op=false))then inc(result);
      if ((input[k]='/')and(op=false))then inc(result);
      if ((input[k]='-')and(op=false)and(isdigitsonly(copy(input,k-1,1))=true))then inc(result);
      if ((input[k]='+')and(op=false))then inc(result);
      if ((input[k]='^')and(op=false))then inc(result);
  end;
end;

function check_char(str:string;offset:Integer):boolean;begin
    result:=false;
    if length(copy(str,offset,1))=0 then exit;

    case ord(str[offset])of
      48..57:result:=true;
      45:result:=check_char(str,offset-1);
    end;
end;


begin op:=false; _pos:=0;
// .

 result:=str;
 if check_str=false then exit;
 math:=-1;

while math<>0 do begin
 math:=math_count(str);

if math=0 then exit;

_pos:=1;
_pos:=_gop(opc);
//for j:=1 to math do begin
    e1:='';
    e2:='';

    for i:=_pos+1 to length(str)do
     if check_char(str,i)=true then e2:=e2+str[i] else break;
    for i:=_pos-1 downto 1 do
     if check_char(str,i)=true then e1:=str[i]+e1 else break;

     _str:=_cmp(opc,e1,e2);
    {if length(_str)>0 then} str:=stringreplace(str,e1+opc+e2,_str,[]);

    inc(_pos);
//end;
    result:=str;
end;

end;

/////////////////////////
function m_trim(source:String):String;var str_res:string;begin
     str_res:=Source;

     str_res:=StringReplace(str_res,Char(00),'',[rfReplaceAll]);
     str_res:=StringReplace(str_res,Char(01),'',[rfReplaceAll]);
     str_res:=StringReplace(str_res,Char(02),'',[rfReplaceAll]);
     str_res:=StringReplace(str_res,Char(03),'',[rfReplaceAll]);
     str_res:=StringReplace(str_res,Char(04),'',[rfReplaceAll]);
     str_res:=StringReplace(str_res,Char(05),'',[rfReplaceAll]);
     str_res:=StringReplace(str_res,Char(06),'',[rfReplaceAll]);
     str_res:=StringReplace(str_res,Char(07),'',[rfReplaceAll]);
     str_res:=StringReplace(str_res,Char(08),'',[rfReplaceAll]);
     //str_res:=StringReplace(str_res,Char(09),'',[rfReplaceAll]);
     str_res:=StringReplace(str_res,Char(11),'',[rfReplaceAll]);
     str_res:=StringReplace(str_res,Char(12),'',[rfReplaceAll]);
     str_res:=StringReplace(str_res,Char(14),'',[rfReplaceAll]);
     str_res:=StringReplace(str_res,Char(15),'',[rfReplaceAll]);
     str_res:=StringReplace(str_res,Char(16),'',[rfReplaceAll]);
     str_res:=StringReplace(str_res,Char(17),'',[rfReplaceAll]);
     str_res:=StringReplace(str_res,Char(18),'',[rfReplaceAll]);
     str_res:=StringReplace(str_res,Char(19),'',[rfReplaceAll]);
     str_res:=StringReplace(str_res,Char(20),'',[rfReplaceAll]);
     str_res:=StringReplace(str_res,Char(21),'',[rfReplaceAll]);
     str_res:=StringReplace(str_res,Char(22),'',[rfReplaceAll]);
     str_res:=StringReplace(str_res,Char(23),'',[rfReplaceAll]);
     str_res:=StringReplace(str_res,Char(24),'',[rfReplaceAll]);
     str_res:=StringReplace(str_res,Char(25),'',[rfReplaceAll]);
     str_res:=StringReplace(str_res,Char(26),'',[rfReplaceAll]);
     str_res:=StringReplace(str_res,Char(28),'',[rfReplaceAll]);
     str_res:=StringReplace(str_res,Char(29),'',[rfReplaceAll]);
     str_res:=StringReplace(str_res,Char(30),'',[rfReplaceAll]);
     str_res:=StringReplace(str_res,Char(31),'',[rfReplaceAll]);

     while(pos(char(27),str_res)>0)do
      delete(str_res,pos(char(27),str_res),2);

     Result:=str_res;
end;


//NEW UP

function fs(fn:string):Cardinal;var _h:THandle;begin
result:=0;
if fileexists(fn)=false then exit;
    _h:=FileOpen(fn,fmShareDenyNone);
    result:=GetFileSize(_h,nil);
    FileClose(_h);
end;
function TrimNulls(const Input: String): String;var i:Cardinal;begin
    result:='';
    for i:=1 to length(Input) do
    if Input[i]<>#0 then result:=result+Input[i];
end;
function FastBinaryRead(FileName:string;Offset:Integer=-1;Count:Integer=-1):String;var _h:Thandle;buff:array of char; _i:integer; begin
result:='';
 if fileexists(FileName)=false then exit;
 _h:=FileOpen(FileName,fmOpenRead or fmShareExclusive);

 if _h<=0 then exit;
 if Offset<>-1 then FileSeek(_h,Offset,0);
 if Count=  -1 then Count:=GetFileSize(_h,nil);
 SetLength(buff,count);
 FillChar(buff[0],count,#0);

 FileRead(_h,buff[0],Count);

 FileClose(_h);

 //CopyMemory(@result[1],@buff[0],Count);

 result:='';
 for _i:=0 to count-1 do result:=result+buff[_i];

end;
procedure FastBinaryWrite(FileName,Input:string;Offset:Integer=-1;Count:Integer=-1);var _h:Thandle;buff:array of char; begin
 if fileexists(FileName)=false then FileCreate(FileName);

 if count=-1 then count:=length(input);
 if length(input)>Count then input:=copy(input,1,count);

 _h:=FileOpen(FileName,fmOpenWrite or fmShareExclusive);

 if _h<=0 then exit;
 if Offset<>-1 then FileSeek(_h,Offset,0);

 SetLength(buff,Count);
 FillChar(buff[0],count,#0);
 Input:=input+StringOfChar(#0,Count);
 CopyMemory(@buff[0],PChar(input),Count);

 FileWrite(_h,buff[0],Count);

 FileClose(_h);



end;
function BinaryRead(FileName:string;Offset:Integer=-1;Count:Integer=-1):String;var F:File of char;ch:char;_end,_i:Integer;begin
 if fileexists(FileName)=false then exit;

 AssignFile(F,FileName);
 //if Assigned(F)=false then exit;

 ReSet(f);
 if Offset<>-1 then Seek(F,Offset);
 if Count<>-1 then _end:=Count else _end:=FileSize(F);

 result:='';
 for _i:=1 to _end do begin
  Read(f,ch);
  result:=result+ch;
 end;

 Close(f);
end;

{procedure BinaryAppend(FileName,Input:string);var F:File of char;ch:char;_end,_i:Integer;begin
// if fileexists(FileName)=false then exit;

 AssignFile(F,FileName);
 //if Assigned(F)=false then exit;

 //Append(F);
 if Offset<>-1 then Seek(F,Offset);
 if Count<>-1 then _end:=Count else _end:=FileSize(F);

 result:='';
 for _i:=1 to _end do begin
  Read(f,ch);
  result:=result+ch;
 end;

 Close(f);
end;   }


function _fbr(f:string;o,l:integer):string;begin
	if o=0 then o:=-1;
	if l=0 then l:=-1;
	result:=fastBinaryRead(f,o,l);
end;
procedure _fbw(f,v:string;o,l:integer);begin
	if o=0 then o:=-1;
	if l=0 then l:=-1;
	fastBinaryWrite(f,v,o,l);
end;
procedure _fba(f,v:string);begin
_fbw(f,_fbr(f,0,0)+v,0,0);
end;
function _fbcl(filename:string):Cardinal;var F:File of char;ch:char;_size,_i:Integer;begin
 result:=0;
 if fileexists(FileName)=false then exit;

 AssignFile(F,FileName);
 //if Assigned(F)=false then exit;
 {$I-}
 ReSet(f);
 {$I+}

 _size:=FileSize(F);
 if _size> 0 then result:=1;

 for _i:=1 to _size do begin
  Read(f,ch);
  if ch=#10 {LF} then inc(result);
 end;

 Close(f);

 end;
 function _fbsl(filename:string;line:Cardinal;value:string):String;var found:boolean;F:File of char;ch:char;_size,_i:Integer;ln:Cardinal;begin
 result:='';
 if fileexists(FileName)=false then exit;

 AssignFile(F,FileName);
 //if Assigned(F)=false then exit;
 {$I-}
 ReSet(f);
 {$I+}

 _size:=FileSize(F);
 ln:=1;
 found:=false;
 for _i:=1 to _size do begin
  Read(f,ch);
  if ch=#10 {LF} then begin inc(ln);continue;end;
  if ln=line then if found=false then found:=true;
  if ((ch=#10 {LF})and(found=true)) then break;
  if found=true then result:=result+ch;

 end;

 Close(f);

 result:=trim(result);

 end;

 function _fbgl(filename:string;line:Cardinal):String;var found:boolean;F:File of char;ch:char;ln:Cardinal;begin
 result:='';
 if fileexists(FileName)=false then exit;

 AssignFile(F,FileName);
 //if Assigned(F)=false then exit;
 {$I-}
 ReSet(f);
 {$I+}

// _size:=FileSize(F);
 ln:=1;
 found:=false;
 while not Eof(F) do begin
  Read(f,ch);
  if ((ch=#10 {LF})and(found=true)) then
   break;
  if ch=#10 {LF} then begin
   inc(ln);continue;end;
  if ln=line then if found=false then
   found:=true;
  if found=true then
   result:=result+ch;
 end;

 Close(f);

 result:=trim(result);

 end;

{
	fs			file_size(file)
	_fbw		file_write(file,value,offset,count)
	_fbr		file_read(file,offset,count)
	_fba	  	file_append(file,value)
	_fbgl 		file_get_line(lines,index)
	_fbsl		file_set_line(lines,index,value)
	_fblc   	file_lines(file)
	trimnulls	trim_nulls(string)

	$_NEW_LINE


}

function char_count(str,chr:string):cardinal;var i:cardinal;begin
    result:=0;
    for i:=1 to length(str)do
    if copy(str,i,length(chr))=chr then inc(result);
end;

function _r(var r:string):HKEY;begin


//TRegDataType = (rdUnknown, rdString, rdExpandString, rdInteger, rdBinary);

    r:=StringReplace(r,'/','\',[rfReplaceAll]);

    if copy(r,length(r),1)<>'\' then r:=r+'\';

    if pos('HKEY_CLASSES_ROOT\',uppercase(r))=1 then   r:=StringReplace(r,'HKEY_CLASSES_ROOT\','HKCR\',[rfIgnoreCase]);
    if pos('HKEY_CURRENT_USER\',uppercase(r))=1 then   r:=StringReplace(r,'HKEY_CURRENT_USER\','HKCU\',[rfIgnoreCase]);
    if pos('HKEY_LOCAL_MACHINE\',uppercase(r))=1 then  r:=StringReplace(r,'HKEY_LOCAL_MACHINE\','HKLM\',[rfIgnoreCase]);
    if pos('HKEY_USERS\',uppercase(r))=1 then          r:=StringReplace(r,'HKEY_USERS\','HKUS\',[rfIgnoreCase]);
    if pos('HKEY_CURRENT_CONFIG\',uppercase(r))=1 then r:=StringReplace(r,'HKEY_CURRENT_CONFIG\','HKCC\',[rfIgnoreCase]);
    if pos('HKU\',uppercase(r))=1 then                 r:=StringReplace(r,'HKU\','HKUS\',[rfIgnoreCase]);

    r:= uppercase(copy(r,1,5))+copy(r,6,length(r));

    if copy(r,1,5)='HKCR\' then result:=HKEY_CLASSES_ROOT;
    if copy(r,1,5)='HKCU\' then result:=HKEY_CURRENT_USER;
    if copy(r,1,5)='HKLM\' then result:=HKEY_LOCAL_MACHINE;
    if copy(r,1,5)='HKUS\' then result:=HKEY_USERS;
    if copy(r,1,5)='HKCC\' then result:=HKEY_CURRENT_CONFIG;

    r:=copy(r,6,length(r));
end;
function _rgv(r,k:string):string;var reg:TRegistry;rt:TRegDataType;begin
    if length(r)<4 then exit;

    reg:=tregistry.Create;

    reg.RootKey:=_r(r);
    reg.OpenKeyReadOnly(r);
    rt:=reg.GetDataType(k);
    case rt of
        rdString:  result:=reg.ReadString(k);
        rdInteger: result:=inttostr(reg.ReadInteger(k));
    end;
    reg.Free;

end;

procedure _rsv(r,k,v:String);var reg:TRegistry;begin
    if length(r)<4 then exit;
    reg:=tregistry.Create;

    reg.RootKey:=_r(r);

    reg.OpenKey(r,True);

    reg.WriteString(k,v);

    reg.Free;

end;

procedure _rdv(r,k:String);var reg:TRegistry;begin
    if length(r)<4 then exit;
    reg:=tregistry.Create;

    reg.RootKey:=_r(r);

    reg.OpenKey(r,True);

    reg.DeleteValue(k);

    reg.Free;

end;
procedure _rdk(r,k:String);var reg:TRegistry;begin
    if length(r)<4 then exit;
    reg:=tregistry.Create;

    reg.RootKey:=_r(r);

    reg.DeleteKey(k);

    reg.Free;

end;

procedure _rck(r,k:String);var reg:TRegistry;begin
    if length(r)<4 then exit;
    reg:=tregistry.Create;

    reg.RootKey:=_r(r);

    reg.CreateKey(k);

    reg.Free;

end;


  
/////////////////////////
function DigitsExcept(instr:string):string;var i:integer;begin
result:='';
    for i:=1 to length(instr)do
    case instr[i]of
    '1','2','3','4','5','6','7','8','9','0'{,'.'}:;
    else result:=result+instr[i];
    end;
end;
function IsFirstStr(str:string;sub_str:string):boolean;begin
    if copy(str,1,length(sub_str))=sub_str
    then result:=true else result:=false;
end;

{ API }

{

 si(param[
 paramp[
 
 }
function cbool(input:BOOL):string;begin
    if input=true then result:='1' else result:='0';
end;
function cint(input:Integer):string;begin
    result:=inttostr(input);
end;
function si(input:string):integer;begin
    result:=safe_strtoint(input);
end;
function sb(input:string):BOOL;begin
	if uppercase(input)='TRUE'  then result:=TRUE ;
	if uppercase(input)='FALSE' then result:=FALSE;
	
	if input='1'  then result:=TRUE ;
	if input='0' then  result:=FALSE;
end;

function cstr(input:PChar):String;begin
    result:='"'+input+'"';

end;
function _api(param:array of string):string;var formt:byte;a_str:string;paramp:array[1..32]of PChar;begin
a_str:=sysutils.LowerCase(param[0]);
result:='';
for formt:=1 to 32 do
if lowercase(param[formt])=#15 then paramp[formt]:=nil else paramp[formt]:=PChar(param[formt]);

try


 if a_str='freeresource' then begin result:=cbool(FreeResource(si(param[1])));exit;end;
 if a_str='freelibrary' then begin result:=cbool(FreeLibrary(si(param[1])));exit;end;
 if a_str='disablethreadlibrarycalls' then begin result:=cbool(DisableThreadLibraryCalls(si(param[1])));exit;end;
 if a_str='getversion' then begin result:=cint(GetVersion());exit;end;
 if a_str='globalalloc' then begin result:=cint(GlobalAlloc(si(param[1]),si(param[2])));exit;end;
 if a_str='globalrealloc' then begin result:=cint(GlobalReAlloc(si(param[1]),si(param[2]),si(param[3])));exit;end;
 if a_str='globalsize' then begin result:=cint(GlobalSize(si(param[1])));exit;end;
 if a_str='globalflags' then begin result:=cint(GlobalFlags(si(param[1])));exit;end;
 if a_str='globalunlock' then begin result:=cbool(GlobalUnlock(si(param[1])));exit;end;
 if a_str='globalfree' then begin result:=cint(GlobalFree(si(param[1])));exit;end;
 if a_str='globalcompact' then begin result:=cint(GlobalCompact(si(param[1])));exit;end;
 if a_str='globalunwire' then begin result:=cbool(GlobalUnWire(si(param[1])));exit;end;
 if a_str='localcompact' then begin result:=cint(LocalCompact(si(param[1])));exit;end;
 if a_str='heapcreate' then begin result:=cint(HeapCreate(si(param[1]),si(param[2]),si(param[3])));exit;end;
 if a_str='heapdestroy' then begin result:=cbool(HeapDestroy(si(param[1])));exit;end;
 if a_str='heapcompact' then begin result:=cint(HeapCompact(si(param[1]),si(param[2])));exit;end;
 if a_str='getprocessheap' then begin result:=cint(GetProcessHeap());exit;end;
 if a_str='heaplock' then begin result:=cbool(HeapLock(si(param[1])));exit;end;
 if a_str='heapunlock' then begin result:=cbool(HeapUnlock(si(param[1])));exit;end;
 if a_str='getshortpathname' then begin result:=cint(GetShortPathName(paramp[1],paramp[2],si(param[3])));exit;end;
 if a_str='setprocessaffinitymask' then begin result:=cbool(SetProcessAffinityMask(si(param[1]),si(param[2])));exit;end;
 if a_str='setprocessworkingsetsize' then begin result:=cbool(SetProcessWorkingSetSize(si(param[1]),si(param[2]),si(param[3])));exit;end;
 if a_str='openprocess' then begin result:=cint(OpenProcess(si(param[1]),sb(param[2]),si(param[3])));exit;end;
 if a_str='getcurrentprocess' then begin result:=cint(GetCurrentProcess());exit;end;
 if a_str='getcurrentprocessid' then begin result:=cint(GetCurrentProcessId());exit;end;
 if a_str='terminateprocess' then begin result:=cbool(TerminateProcess(si(param[1]),si(param[2])));exit;end;
 if a_str='getenvironmentstrings' then begin result:=cstr(GetEnvironmentStrings());exit;end;
 if a_str='freeenvironmentstrings' then begin result:=cbool(FreeEnvironmentStrings(paramp[1]));exit;end;
 if a_str='switchtothread' then begin result:=cbool(SwitchToThread());exit;end;
 if a_str='getcurrentthread' then begin result:=cint(GetCurrentThread());exit;end;
 if a_str='getcurrentthreadid' then begin result:=cint(GetCurrentThreadId());exit;end;
 if a_str='setthreadaffinitymask' then begin result:=cint(SetThreadAffinityMask(si(param[1]),si(param[2])));exit;end;
 if a_str='setthreadidealprocessor' then begin result:=cbool(SetThreadIdealProcessor(si(param[1]),si(param[2])));exit;end;
 if a_str='setprocesspriorityboost' then begin result:=cbool(SetProcessPriorityBoost(si(param[1]),sb(param[2])));exit;end;
 if a_str='setthreadpriority' then begin result:=cbool(SetThreadPriority(si(param[1]),si(param[2])));exit;end;
 if a_str='getthreadpriority' then begin result:=cint(GetThreadPriority(si(param[1])));exit;end;
 if a_str='setthreadpriorityboost' then begin result:=cbool(SetThreadPriorityBoost(si(param[1]),sb(param[2])));exit;end;
 if a_str='terminatethread' then begin result:=cbool(TerminateThread(si(param[1]),si(param[2])));exit;end;
 if a_str='getlasterror' then begin result:=cint(GetLastError());exit;end;
 if a_str='createiocompletionport' then begin result:=cint(CreateIoCompletionPort(si(param[1]),si(param[2]),si(param[3]),si(param[4])));exit;end;
 if a_str='seterrormode' then begin result:=cint(SetErrorMode(si(param[1])));exit;end;
 if a_str='suspendthread' then begin result:=cint(SuspendThread(si(param[1])));exit;end;
 if a_str='resumethread' then begin result:=cint(ResumeThread(si(param[1])));exit;end;
 if a_str='continuedebugevent' then begin result:=cbool(ContinueDebugEvent(si(param[1]),si(param[2]),si(param[3])));exit;end;
 if a_str='debugactiveprocess' then begin result:=cbool(DebugActiveProcess(si(param[1])));exit;end;
 if a_str='setevent' then begin result:=cbool(SetEvent(si(param[1])));exit;end;
 if a_str='resetevent' then begin result:=cbool(ResetEvent(si(param[1])));exit;end;
 if a_str='pulseevent' then begin result:=cbool(PulseEvent(si(param[1])));exit;end;
 if a_str='releasemutex' then begin result:=cbool(ReleaseMutex(si(param[1])));exit;end;
 if a_str='waitforsingleobject' then begin result:=cint(WaitForSingleObject(si(param[1]),si(param[2])));exit;end;
 if a_str='globaldeleteatom' then begin result:=cint(GlobalDeleteAtom(si(param[1])));exit;end;
 if a_str='initatomtable' then begin result:=cbool(InitAtomTable(si(param[1])));exit;end;
 if a_str='deleteatom' then begin result:=cint(DeleteAtom(si(param[1])));exit;end;
 if a_str='sethandlecount' then begin result:=cint(SetHandleCount(si(param[1])));exit;end;
 if a_str='getlogicaldrives' then begin result:=cint(GetLogicalDrives());exit;end;
 if a_str='lockfile' then begin result:=cbool(LockFile(si(param[1]),si(param[2]),si(param[3]),si(param[4]),si(param[5])));exit;end;
 if a_str='unlockfile' then begin result:=cbool(UnlockFile(si(param[1]),si(param[2]),si(param[3]),si(param[4]),si(param[5])));exit;end;
 if a_str='getfiletype' then begin result:=cint(GetFileType(si(param[1])));exit;end;
 if a_str='getstdhandle' then begin result:=cint(GetStdHandle(si(param[1])));exit;end;
 if a_str='setstdhandle' then begin result:=cbool(SetStdHandle(si(param[1]),si(param[2])));exit;end;
 if a_str='flushfilebuffers' then begin result:=cbool(FlushFileBuffers(si(param[1])));exit;end;
 if a_str='setendoffile' then begin result:=cbool(SetEndOfFile(si(param[1])));exit;end;
 if a_str='findclose' then begin result:=cbool(Windows.FindClose(si(param[1])));exit;end;
 if a_str='closehandle' then begin result:=cbool(CloseHandle(si(param[1])));exit;end;
 if a_str='sethandleinformation' then begin result:=cbool(SetHandleInformation(si(param[1]),si(param[2]),si(param[3])));exit;end;
 if a_str='clearcommbreak' then begin result:=cbool(ClearCommBreak(si(param[1])));exit;end;
 if a_str='setupcomm' then begin result:=cbool(SetupComm(si(param[1]),si(param[2]),si(param[3])));exit;end;
 if a_str='escapecommfunction' then begin result:=cbool(EscapeCommFunction(si(param[1]),si(param[2])));exit;end;
 if a_str='purgecomm' then begin result:=cbool(PurgeComm(si(param[1]),si(param[2])));exit;end;
 if a_str='setcommbreak' then begin result:=cbool(SetCommBreak(si(param[1])));exit;end;
 if a_str='setcommmask' then begin result:=cbool(SetCommMask(si(param[1]),si(param[2])));exit;end;
 if a_str='settapeposition' then begin result:=cint(SetTapePosition(si(param[1]),si(param[2]),si(param[3]),si(param[4]),si(param[5]),sb(param[6])));exit;end;
 if a_str='preparetape' then begin result:=cint(PrepareTape(si(param[1]),si(param[2]),sb(param[3])));exit;end;
 if a_str='erasetape' then begin result:=cint(EraseTape(si(param[1]),si(param[2]),sb(param[3])));exit;end;
 if a_str='createtapepartition' then begin result:=cint(CreateTapePartition(si(param[1]),si(param[2]),si(param[3]),si(param[4])));exit;end;
 if a_str='writetapemark' then begin result:=cint(WriteTapemark(si(param[1]),si(param[2]),si(param[3]),sb(param[4])));exit;end;
 if a_str='gettapestatus' then begin result:=cint(GetTapeStatus(si(param[1])));exit;end;
 if a_str='beep' then begin result:=cbool(Windows.Beep(si(param[1]),si(param[2])));exit;end;
 if a_str='muldiv' then begin result:=cint(MulDiv(si(param[1]),si(param[2]),si(param[3])));exit;end;
 if a_str='isprocessorfeaturepresent' then begin result:=cbool(IsProcessorFeaturePresent(si(param[1])));exit;end;
 if a_str='gettickcount' then begin result:=cint(GetTickCount());exit;end;
 if a_str='setsystemtimeadjustment' then begin result:=cbool(SetSystemTimeAdjustment(si(param[1]),sb(param[2])));exit;end;
 if a_str='disconnectnamedpipe' then begin result:=cbool(DisconnectNamedPipe(si(param[1])));exit;end;
 if a_str='setmailslotinfo' then begin result:=cbool(SetMailslotInfo(si(param[1]),si(param[2])));exit;end;
// if a_str='encryptfile' then begin result:=cbool(EncryptFile(paramp[1]));exit;end;
// if a_str='decryptfile' then begin result:=cbool(DecryptFile(paramp[1],si(param[2])));exit;end;
 if a_str='lstrcmp' then begin result:=cint(lstrcmp(paramp[1],paramp[2]));exit;end;
 if a_str='lstrcmpi' then begin result:=cint(lstrcmpi(paramp[1],paramp[2]));exit;end;
 if a_str='lstrcpyn' then begin result:=cstr(lstrcpyn(paramp[1],paramp[2],si(param[3])));exit;end;
 if a_str='lstrcpy' then begin result:=cstr(lstrcpy(paramp[1],paramp[2]));exit;end;
 if a_str='lstrcat' then begin result:=cstr(lstrcat(paramp[1],paramp[2]));exit;end;
 if a_str='lstrlen' then begin result:=cint(lstrlen(paramp[1]));exit;end;
 if a_str='tlsalloc' then begin result:=cint(TlsAlloc());exit;end;
 if a_str='tlsfree' then begin result:=cbool(TlsFree(si(param[1])));exit;end;
 if a_str='sleepex' then begin result:=cint(SleepEx(si(param[1]),sb(param[2])));exit;end;
 if a_str='waitforsingleobjectex' then begin result:=cint(WaitForSingleObjectEx(si(param[1]),si(param[2]),sb(param[3])));exit;end;
 if a_str='signalobjectandwait' then begin result:=cbool(SignalObjectAndWait(si(param[1]),si(param[2]),si(param[3]),sb(param[4])));exit;end;
 if a_str='openmutex' then begin result:=cint(OpenMutex(si(param[1]),sb(param[2]),paramp[3]));exit;end;
 if a_str='openevent' then begin result:=cint(OpenEvent(si(param[1]),sb(param[2]),paramp[3]));exit;end;
 if a_str='opensemaphore' then begin result:=cint(OpenSemaphore(si(param[1]),sb(param[2]),paramp[3]));exit;end;
 if a_str='openwaitabletimer' then begin result:=cint(OpenWaitableTimer(si(param[1]),sb(param[2]),paramp[3]));exit;end;
 if a_str='cancelwaitabletimer' then begin result:=cbool(CancelWaitableTimer(si(param[1])));exit;end;
 if a_str='openfilemapping' then begin result:=cint(OpenFileMapping(si(param[1]),sb(param[2]),paramp[3]));exit;end;
 if a_str='loadlibrary' then begin result:=cint(LoadLibrary(paramp[1]));exit;end;
 if a_str='loadlibraryex' then begin result:=cint(LoadLibraryEx(paramp[1],si(param[2]),si(param[3])));exit;end;
 if a_str='getmodulehandle' then begin result:=cint(GetModuleHandle(paramp[1]));exit;end;
 if a_str='setprocessshutdownparameters' then begin result:=cbool(SetProcessShutdownParameters(si(param[1]),si(param[2])));exit;end;
 if a_str='getprocessversion' then begin result:=cint(GetProcessVersion(si(param[1])));exit;end;
 if a_str='getcommandline' then begin result:=cstr(GetCommandLine());exit;end;
 if a_str='setenvironmentvariable' then begin result:=cbool(SetEnvironmentVariable(paramp[1],paramp[2]));exit;end;
 if a_str='expandenvironmentstrings' then begin result:=cint(ExpandEnvironmentStrings(paramp[1],paramp[2],si(param[3])));exit;end;
 if a_str='beginupdateresource' then begin result:=cint(BeginUpdateResource(paramp[1],sb(param[2])));exit;end;
 if a_str='endupdateresource' then begin result:=cbool(EndUpdateResource(si(param[1]),sb(param[2])));exit;end;
 if a_str='endupdateresourcea' then begin result:=cbool(EndUpdateResourceA(si(param[1]),sb(param[2])));exit;end;
 if a_str='endupdateresourcew' then begin result:=cbool(EndUpdateResourceW(si(param[1]),sb(param[2])));exit;end;
 if a_str='globaladdatom' then begin result:=cint(GlobalAddAtom(paramp[1]));exit;end;
 if a_str='globalfindatom' then begin result:=cint(GlobalFindAtom(paramp[1]));exit;end;
 if a_str='globalgetatomname' then begin result:=cint(GlobalGetAtomName(si(param[1]),paramp[2],si(param[3])));exit;end;
 if a_str='addatom' then begin result:=cint(AddAtom(paramp[1]));exit;end;
 if a_str='findatom' then begin result:=cint(FindAtom(paramp[1]));exit;end;
 if a_str='getatomname' then begin result:=cint(GetAtomName(si(param[1]),paramp[2],si(param[3])));exit;end;
 if a_str='getprofileint' then begin result:=cint(GetProfileInt(paramp[1],paramp[2],si(param[3])));exit;end;
 if a_str='getprofilestring' then begin result:=cint(GetProfileString(paramp[1],paramp[2],paramp[3],paramp[4],si(param[5])));exit;end;
 if a_str='writeprofilestring' then begin result:=cbool(WriteProfileString(paramp[1],paramp[2],paramp[3]));exit;end;
 if a_str='getprofilesection' then begin result:=cint(GetProfileSection(paramp[1],paramp[2],si(param[3])));exit;end;
 if a_str='writeprofilesection' then begin result:=cbool(WriteProfileSection(paramp[1],paramp[2]));exit;end;
 if a_str='getprivateprofileint' then begin result:=cint(GetPrivateProfileInt(paramp[1],paramp[2],si(param[3]),paramp[4]));exit;end;
 if a_str='getprivateprofilestring' then begin result:=cint(GetPrivateProfileString(paramp[1],paramp[2],paramp[3],paramp[4],si(param[5]),paramp[6]));exit;end;
 if a_str='writeprivateprofilestring' then begin result:=cbool(WritePrivateProfileString(paramp[1],paramp[2],paramp[3],paramp[4]));exit;end;
 if a_str='getprivateprofilesection' then begin result:=cint(GetPrivateProfileSection(paramp[1],paramp[2],si(param[3]),paramp[4]));exit;end;
 if a_str='writeprivateprofilesection' then begin result:=cbool(WritePrivateProfileSection(paramp[1],paramp[2],paramp[3]));exit;end;
 if a_str='getprivateprofilesectionnames' then begin result:=cint(GetPrivateProfileSectionNames(paramp[1],si(param[2]),paramp[3]));exit;end;
 if a_str='getdrivetype' then begin result:=cint(GetDriveType(paramp[1]));exit;end;
 if a_str='getsystemdirectory' then begin result:=cint(GetSystemDirectory(paramp[1],si(param[2])));exit;end;
 if a_str='gettemppath' then begin result:=cint(GetTempPath(si(param[1]),paramp[2]));exit;end;
 if a_str='gettempfilename' then begin result:=cint(GetTempFileName(paramp[1],paramp[2],si(param[3]),paramp[4]));exit;end;
 if a_str='getwindowsdirectory' then begin result:=cint(GetWindowsDirectory(paramp[1],si(param[2])));exit;end;
 if a_str='setcurrentdirectory' then begin result:=cbool(SetCurrentDirectory(paramp[1]));exit;end;
 if a_str='getcurrentdirectory' then begin result:=cint(GetCurrentDirectory(si(param[1]),paramp[2]));exit;end;
 if a_str='removedirectory' then begin result:=cbool(RemoveDirectory(paramp[1]));exit;end;
 if a_str='definedosdevice' then begin result:=cbool(DefineDosDevice(si(param[1]),paramp[2],paramp[3]));exit;end;
 if a_str='querydosdevice' then begin result:=cint(QueryDosDevice(paramp[1],paramp[2],si(param[3])));exit;end;
 if a_str='setfileattributes' then begin result:=cbool(SetFileAttributes(paramp[1],si(param[2])));exit;end;
 if a_str='getfileattributes' then begin result:=cint(GetFileAttributes(paramp[1]));exit;end;
 if a_str='getcompressedfilesize' then begin result:=cint(GetCompressedFileSize(paramp[1],pdword(si(param[2]))));exit;end;
 if a_str='deletefile' then begin result:=cbool(DeleteFile(paramp[1]));exit;end;
 if a_str='copyfile' then begin result:=cbool(CopyFile(paramp[1],paramp[2],sb(param[3])));exit;end;
 if a_str='movefile' then begin result:=cbool(MoveFile(paramp[1],paramp[2]));exit;end;
 if a_str='movefileex' then begin result:=cbool(MoveFileEx(paramp[1],paramp[2],si(param[3])));exit;end;
 if a_str='getnamedpipehandlestate' then begin result:=cbool(GetNamedPipeHandleState(si(param[1]),pdword(si(param[2])),pdword(si(param[3])),pdword(si(param[4])),pdword(si(param[5])),paramp[6],si(param[7])));exit;end;
 if a_str='waitnamedpipe' then begin result:=cbool(WaitNamedPipe(paramp[1],si(param[2])));exit;end;
 if a_str='arefileapisansi' then begin result:=cbool(AreFileApisANSI());exit;end;
 if a_str='cancelio' then begin result:=cbool(CancelIo(si(param[1])));exit;end;
 if a_str='cleareventlog' then begin result:=cbool(ClearEventLog(si(param[1]),paramp[2]));exit;end;
 if a_str='backupeventlog' then begin result:=cbool(BackupEventLog(si(param[1]),paramp[2]));exit;end;
 if a_str='closeeventlog' then begin result:=cbool(CloseEventLog(si(param[1])));exit;end;
 if a_str='deregistereventsource' then begin result:=cbool(DeregisterEventSource(si(param[1])));exit;end;
 if a_str='notifychangeeventlog' then begin result:=cbool(NotifyChangeEventLog(si(param[1]),si(param[2])));exit;end;
 if a_str='openeventlog' then begin result:=cint(OpenEventLog(paramp[1],paramp[2]));exit;end;
 if a_str='registereventsource' then begin result:=cint(RegisterEventSource(paramp[1],paramp[2]));exit;end;
 if a_str='openbackupeventlog' then begin result:=cint(OpenBackupEventLog(paramp[1],paramp[2]));exit;end;
 if a_str='impersonatenamedpipeclient' then begin result:=cbool(ImpersonateNamedPipeClient(si(param[1])));exit;end;
 if a_str='reverttoself' then begin result:=cbool(RevertToSelf());exit;end;
 if a_str='areallaccessesgranted' then begin result:=cbool(AreAllAccessesGranted(si(param[1]),si(param[2])));exit;end;
 if a_str='areanyaccessesgranted' then begin result:=cbool(AreAnyAccessesGranted(si(param[1]),si(param[2])));exit;end;
 if a_str='findfirstchangenotification' then begin result:=cint(FindFirstChangeNotification(paramp[1],sb(param[2]),si(param[3])));exit;end;
 if a_str='findnextchangenotification' then begin result:=cbool(FindNextChangeNotification(si(param[1])));exit;end;
 if a_str='findclosechangenotification' then begin result:=cbool(FindCloseChangeNotification(si(param[1])));exit;end;
 if a_str='setpriorityclass' then begin result:=cbool(SetPriorityClass(si(param[1]),si(param[2])));exit;end;
 if a_str='getpriorityclass' then begin result:=cint(GetPriorityClass(si(param[1])));exit;end;
 if a_str='isbadstringptr' then begin result:=cbool(IsBadStringPtr(paramp[1],si(param[2])));exit;end;
 if a_str='setcomputername' then begin result:=cbool(SetComputerName(paramp[1]));exit;end;
 if a_str='impersonateloggedonuser' then begin result:=cbool(ImpersonateLoggedOnUser(si(param[1])));exit;end;
 if a_str='setsystempowerstate' then begin result:=cbool(SetSystemPowerState(sb(param[1]),sb(param[2])));exit;end;
 if a_str='addfontresource' then begin result:=cint(AddFontResource(paramp[1]));exit;end;
 if a_str='arc' then begin result:=cbool(Arc(si(param[1]),si(param[2]),si(param[3]),si(param[4]),si(param[5]),si(param[6]),si(param[7]),si(param[8]),si(param[9])));exit;end;
 if a_str='bitblt' then begin result:=cbool(BitBlt(si(param[1]),si(param[2]),si(param[3]),si(param[4]),si(param[5]),si(param[6]),si(param[7]),si(param[8]),si(param[9])));exit;end;
 if a_str='canceldc' then begin result:=cbool(CancelDC(si(param[1])));exit;end;
 if a_str='chord' then begin result:=cbool(Chord(si(param[1]),si(param[2]),si(param[3]),si(param[4]),si(param[5]),si(param[6]),si(param[7]),si(param[8]),si(param[9])));exit;end;
 if a_str='createcompatibledc' then begin result:=cint(CreateCompatibleDC(si(param[1])));exit;end;
 if a_str='createmetafile' then begin result:=cint(CreateMetaFile(paramp[1]));exit;end;
 if a_str='createscalablefontresource' then begin result:=cbool(CreateScalableFontResource(si(param[1]),paramp[2],paramp[3],paramp[4]));exit;end;
 if a_str='deletedc' then begin result:=cbool(DeleteDC(si(param[1])));exit;end;
 if a_str='ellipse' then begin result:=cbool(Ellipse(si(param[1]),si(param[2]),si(param[3]),si(param[4]),si(param[5])));exit;end;
 if a_str='excludecliprect' then begin result:=cint(ExcludeClipRect(si(param[1]),si(param[2]),si(param[3]),si(param[4]),si(param[5])));exit;end;
 if a_str='getrop2' then begin result:=cint(GetROP2(si(param[1])));exit;end;
 if a_str='getbkmode' then begin result:=cint(GetBkMode(si(param[1])));exit;end;
 if a_str='getdevicecaps' then begin result:=cint(GetDeviceCaps(si(param[1]),si(param[2])));exit;end;
 if a_str='getgraphicsmode' then begin result:=cint(GetGraphicsMode(si(param[1])));exit;end;
 if a_str='getmapmode' then begin result:=cint(GetMapMode(si(param[1])));exit;end;
 if a_str='getpixelformat' then begin result:=cint(GetPixelFormat(si(param[1])));exit;end;
 if a_str='getpolyfillmode' then begin result:=cint(GetPolyFillMode(si(param[1])));exit;end;
 if a_str='getstretchbltmode' then begin result:=cint(GetStretchBltMode(si(param[1])));exit;end;
 if a_str='getsystempaletteuse' then begin result:=cint(GetSystemPaletteUse(si(param[1])));exit;end;
 if a_str='gettextcharacterextra' then begin result:=cint(GetTextCharacterExtra(si(param[1])));exit;end;
 if a_str='gettextalign' then begin result:=cint(GetTextAlign(si(param[1])));exit;end;
 if a_str='gettextcharset' then begin result:=cint(GetTextCharset(si(param[1])));exit;end;
 if a_str='getfontlanguageinfo' then begin result:=cint(GetFontLanguageInfo(si(param[1])));exit;end;
 if a_str='removefontmemresourceex' then begin result:=cbool(RemoveFontMemResourceEx(si(param[1])));exit;end;
 if a_str='intersectcliprect' then begin result:=cint(IntersectClipRect(si(param[1]),si(param[2]),si(param[3]),si(param[4]),si(param[5])));exit;end;
 if a_str='lineto' then begin result:=cbool(LineTo(si(param[1]),si(param[2]),si(param[3])));exit;end;
 if a_str='offsetcliprgn' then begin result:=cint(OffsetClipRgn(si(param[1]),si(param[2]),si(param[3])));exit;end;
 if a_str='patblt' then begin result:=cbool(PatBlt(si(param[1]),si(param[2]),si(param[3]),si(param[4]),si(param[5]),si(param[6])));exit;end;
 if a_str='pie' then begin result:=cbool(Pie(si(param[1]),si(param[2]),si(param[3]),si(param[4]),si(param[5]),si(param[6]),si(param[7]),si(param[8]),si(param[9])));exit;end;
 if a_str='ptvisible' then begin result:=cbool(PtVisible(si(param[1]),si(param[2]),si(param[3])));exit;end;
 if a_str='rectangle' then begin result:=cbool(Rectangle(si(param[1]),si(param[2]),si(param[3]),si(param[4]),si(param[5])));exit;end;
 if a_str='restoredc' then begin result:=cbool(RestoreDC(si(param[1]),si(param[2])));exit;end;
 if a_str='realizepalette' then begin result:=cint(RealizePalette(si(param[1])));exit;end;
 if a_str='removefontresource' then begin result:=cbool(RemoveFontResource(paramp[1]));exit;end;
 if a_str='roundrect' then begin result:=cbool(RoundRect(si(param[1]),si(param[2]),si(param[3]),si(param[4]),si(param[5]),si(param[6]),si(param[7])));exit;end;
 if a_str='savedc' then begin result:=cint(SaveDC(si(param[1])));exit;end;
 if a_str='setmetargn' then begin result:=cint(SetMetaRgn(si(param[1])));exit;end;
 if a_str='setbkmode' then begin result:=cint(SetBkMode(si(param[1]),si(param[2])));exit;end;
 if a_str='setmapperflags' then begin result:=cint(SetMapperFlags(si(param[1]),si(param[2])));exit;end;
 if a_str='setgraphicsmode' then begin result:=cint(SetGraphicsMode(si(param[1]),si(param[2])));exit;end;
 if a_str='setmapmode' then begin result:=cint(SetMapMode(si(param[1]),si(param[2])));exit;end;
 if a_str='setpolyfillmode' then begin result:=cint(SetPolyFillMode(si(param[1]),si(param[2])));exit;end;
 if a_str='stretchblt' then begin result:=cbool(StretchBlt(si(param[1]),si(param[2]),si(param[3]),si(param[4]),si(param[5]),si(param[6]),si(param[7]),si(param[8]),si(param[9]),si(param[10]),si(param[11])));exit;end;
 if a_str='setrop2' then begin result:=cint(SetROP2(si(param[1]),si(param[2])));exit;end;
 if a_str='setstretchbltmode' then begin result:=cint(SetStretchBltMode(si(param[1]),si(param[2])));exit;end;
 if a_str='setsystempaletteuse' then begin result:=cint(SetSystemPaletteUse(si(param[1]),si(param[2])));exit;end;
 if a_str='settextcharacterextra' then begin result:=cint(SetTextCharacterExtra(si(param[1]),si(param[2])));exit;end;
 if a_str='settextalign' then begin result:=cint(SetTextAlign(si(param[1]),si(param[2])));exit;end;
 if a_str='settextjustification' then begin result:=cint(SetTextJustification(si(param[1]),si(param[2]),si(param[3])));exit;end;
 if a_str='updatecolors' then begin result:=cbool(UpdateColors(si(param[1])));exit;end;
 if a_str='transparentblt' then begin result:=cbool(TransparentBlt(si(param[1]),si(param[2]),si(param[3]),si(param[4]),si(param[5]),si(param[6]),si(param[7]),si(param[8]),si(param[9]),si(param[10]),si(param[11])));exit;end;
 if a_str='gdicomment' then begin result:=cbool(GdiComment(si(param[1]),si(param[2]),paramp[3]));exit;end;
// if a_str='polypolyline' then begin result:=cbool(PolyPolyline(si(param[1]),si(param[2]),si(param[3]),si(param[4])));exit;end;
 if a_str='enddoc' then begin result:=cint(EndDoc(si(param[1])));exit;end;
 if a_str='startpage' then begin result:=cint(StartPage(si(param[1])));exit;end;
 if a_str='endpage' then begin result:=cint(EndPage(si(param[1])));exit;end;
 if a_str='abortdoc' then begin result:=cint(AbortDoc(si(param[1])));exit;end;
 if a_str='abortpath' then begin result:=cbool(AbortPath(si(param[1])));exit;end;
 if a_str='arcto' then begin result:=cbool(ArcTo(si(param[1]),si(param[2]),si(param[3]),si(param[4]),si(param[5]),si(param[6]),si(param[7]),si(param[8]),si(param[9])));exit;end;
 if a_str='beginpath' then begin result:=cbool(BeginPath(si(param[1])));exit;end;
 if a_str='closefigure' then begin result:=cbool(CloseFigure(si(param[1])));exit;end;
 if a_str='endpath' then begin result:=cbool(EndPath(si(param[1])));exit;end;
 if a_str='fillpath' then begin result:=cbool(FillPath(si(param[1])));exit;end;
 if a_str='flattenpath' then begin result:=cbool(FlattenPath(si(param[1])));exit;end;
// if a_str='polydraw' then begin result:=cbool(PolyDraw(si(param[1]),si(param[2]),si(param[3]),si(param[4])));exit;end;
 if a_str='selectclippath' then begin result:=cbool(SelectClipPath(si(param[1]),si(param[2])));exit;end;
 if a_str='setarcdirection' then begin result:=cint(SetArcDirection(si(param[1]),si(param[2])));exit;end;
 if a_str='strokeandfillpath' then begin result:=cbool(StrokeAndFillPath(si(param[1])));exit;end;
 if a_str='strokepath' then begin result:=cbool(StrokePath(si(param[1])));exit;end;
 if a_str='widenpath' then begin result:=cbool(WidenPath(si(param[1])));exit;end;
 if a_str='getarcdirection' then begin result:=cint(GetArcDirection(si(param[1])));exit;end;
 if a_str='textout' then begin result:=cbool(TextOut(si(param[1]),si(param[2]),si(param[3]),paramp[4],si(param[5])));exit;end;
// if a_str='polytextout' then begin result:=cbool(PolyTextOut(si(param[1]),si(param[2]),si(param[3])));exit;end;
// if a_str='polytextouta' then begin result:=cbool(PolyTextOutA(si(param[1]),si(param[2]),si(param[3])));exit;end;
// if a_str='polytextoutw' then begin result:=cbool(PolyTextOutW(si(param[1]),si(param[2]),si(param[3])));exit;end;
// if a_str='polybezier' then begin result:=cbool(PolyBezier(si(param[1]),si(param[2]),si(param[3])));exit;end;
// if a_str='polybezierto' then begin result:=cbool(PolyBezierTo(si(param[1]),si(param[2]),si(param[3])));exit;end;
// if a_str='polylineto' then begin result:=cbool(PolyLineTo(si(param[1]),si(param[2]),si(param[3])));exit;end;
 if a_str='gettextface' then begin result:=cint(GetTextFace(si(param[1]),si(param[2]),paramp[3]));exit;end;
 if a_str='gdiflush' then begin result:=cbool(GdiFlush());exit;end;
 if a_str='gdisetbatchlimit' then begin result:=cint(GdiSetBatchLimit(si(param[1])));exit;end;
 if a_str='gdigetbatchlimit' then begin result:=cint(GdiGetBatchLimit());exit;end;
 if a_str='seticmmode' then begin result:=cint(SetICMMode(si(param[1]),si(param[2])));exit;end;
 if a_str='getcolorspace' then begin result:=cint(GetColorSpace(si(param[1])));exit;end;
 if a_str='seticmprofile' then begin result:=cbool(SetICMProfile(si(param[1]),paramp[2]));exit;end;
 if a_str='colormatchtotarget' then begin result:=cbool(ColorMatchToTarget(si(param[1]),si(param[2]),si(param[3])));exit;end;
 if a_str='updateicmregkey' then begin result:=cbool(UpdateICMRegKey(si(param[1]),paramp[2],paramp[3],si(param[4])));exit;end;
 if a_str='wglgetcurrentdc' then begin result:=cint(wglGetCurrentDC());exit;end;
 if a_str='wglusefontbitmaps' then begin result:=cbool(wglUseFontBitmaps(si(param[1]),si(param[2]),si(param[3]),si(param[4])));exit;end;
 if a_str='wglusefontbitmapsa' then begin result:=cbool(wglUseFontBitmapsA(si(param[1]),si(param[2]),si(param[3]),si(param[4])));exit;end;
 if a_str='wglusefontbitmapsw' then begin result:=cbool(wglUseFontBitmapsW(si(param[1]),si(param[2]),si(param[3]),si(param[4])));exit;end;
 if a_str='swapbuffers' then begin result:=cbool(SwapBuffers(si(param[1])));exit;end;
 if a_str='wglrealizelayerpalette' then begin result:=cbool(wglRealizeLayerPalette(si(param[1]),si(param[2]),sb(param[3])));exit;end;
 if a_str='wsprintf' then begin result:=cint(wsprintf(paramp[1],paramp[2]));exit;end;
 if a_str='getkeyboardlayoutname' then begin result:=cbool(GetKeyboardLayoutName(paramp[1]));exit;end;
 if a_str='registerwindowmessage' then begin result:=cint(RegisterWindowMessage(paramp[1]));exit;end;
 if a_str='setmessagequeue' then begin result:=cbool(SetMessageQueue(si(param[1])));exit;end;
 if a_str='registerhotkey' then begin result:=cbool(RegisterHotKey(si(param[1]),si(param[2]),si(param[3]),si(param[4])));exit;end;
 if a_str='unregisterhotkey' then begin result:=cbool(UnregisterHotKey(si(param[1]),si(param[2])));exit;end;
 if a_str='exitwindowsex' then begin result:=cbool(ExitWindowsEx(si(param[1]),si(param[2])));exit;end;
 if a_str='swapmousebutton' then begin result:=cbool(SwapMouseButton(sb(param[1])));exit;end;
 if a_str='getmessagepos' then begin result:=cint(GetMessagePos());exit;end;
 if a_str='setmessageextrainfo' then begin result:=cint(SetMessageExtraInfo(si(param[1])));exit;end;
 if a_str='sendnotifymessage' then begin result:=cbool(SendNotifyMessage(si(param[1]),si(param[2]),si(param[3]),si(param[4])));exit;end;
 if a_str='sendnotifymessagea' then begin result:=cbool(SendNotifyMessageA(si(param[1]),si(param[2]),si(param[3]),si(param[4])));exit;end;
 if a_str='sendnotifymessagew' then begin result:=cbool(SendNotifyMessageW(si(param[1]),si(param[2]),si(param[3]),si(param[4])));exit;end;
 if a_str='postmessage' then begin result:=cbool(PostMessage(si(param[1]),si(param[2]),si(param[3]),si(param[4])));exit;end;
 if a_str='postmessagea' then begin result:=cbool(PostMessageA(si(param[1]),si(param[2]),si(param[3]),si(param[4])));exit;end;
 if a_str='postmessagew' then begin result:=cbool(PostMessageW(si(param[1]),si(param[2]),si(param[3]),si(param[4])));exit;end;
 if a_str='sendmessage' then begin result:=cint(SendMessage(si(param[1]),si(param[2]),si(param[3]),si(param[4])));exit;end;
 if a_str='sendmessagea' then begin result:=cint(SendMessageA(si(param[1]),si(param[2]),si(param[3]),si(param[4])));exit;end;
 if a_str='sendmessagew' then begin result:=cint(SendMessageW(si(param[1]),si(param[2]),si(param[3]),si(param[4])));exit;end;
 if a_str='postthreadmessage' then begin result:=cbool(PostThreadMessage(si(param[1]),si(param[2]),si(param[3]),si(param[4])));exit;end;
 if a_str='postthreadmessagea' then begin result:=cbool(PostThreadMessageA(si(param[1]),si(param[2]),si(param[3]),si(param[4])));exit;end;
 if a_str='postthreadmessagew' then begin result:=cbool(PostThreadMessageW(si(param[1]),si(param[2]),si(param[3]),si(param[4])));exit;end;
 if a_str='attachthreadinput' then begin result:=cbool(AttachThreadInput(si(param[1]),si(param[2]),sb(param[3])));exit;end;
 if a_str='waitmessage' then begin result:=cbool(WaitMessage());exit;end;
 if a_str='waitforinputidle' then begin result:=cint(WaitForInputIdle(si(param[1]),si(param[2])));exit;end;
 if a_str='insendmessage' then begin result:=cbool(InSendMessage());exit;end;
 if a_str='getdoubleclicktime' then begin result:=cint(GetDoubleClickTime());exit;end;
 if a_str='setdoubleclicktime' then begin result:=cbool(SetDoubleClickTime(si(param[1])));exit;end;
 if a_str='iswindow' then begin result:=cbool(IsWindow(si(param[1])));exit;end;
 if a_str='ischild' then begin result:=cbool(IsChild(si(param[1]),si(param[2])));exit;end;
 if a_str='destroywindow' then begin result:=cbool(DestroyWindow(si(param[1])));exit;end;
 if a_str='showwindow' then begin result:=cbool(ShowWindow(si(param[1]),si(param[2])));exit;end;
 if a_str='animatewindow' then begin result:=cbool(AnimateWindow(si(param[1]),si(param[2]),si(param[3])));exit;end;
 if a_str='showwindowasync' then begin result:=cbool(ShowWindowAsync(si(param[1]),si(param[2])));exit;end;
 if a_str='flashwindow' then begin result:=cbool(FlashWindow(si(param[1]),sb(param[2])));exit;end;
 if a_str='showownedpopups' then begin result:=cbool(ShowOwnedPopups(si(param[1]),sb(param[2])));exit;end;
 if a_str='openicon' then begin result:=cbool(OpenIcon(si(param[1])));exit;end;
 if a_str='closewindow' then begin result:=cbool(CloseWindow(si(param[1])));exit;end;
 if a_str='movewindow' then begin result:=cbool(MoveWindow(si(param[1]),si(param[2]),si(param[3]),si(param[4]),si(param[5]),sb(param[6])));exit;end;
 if a_str='setwindowpos' then begin result:=cbool(SetWindowPos(si(param[1]),si(param[2]),si(param[3]),si(param[4]),si(param[5]),si(param[6]),si(param[7])));exit;end;
 if a_str='iswindowvisible' then begin result:=cbool(IsWindowVisible(si(param[1])));exit;end;
 if a_str='isiconic' then begin result:=cbool(IsIconic(si(param[1])));exit;end;
 if a_str='anypopup' then begin result:=cbool(AnyPopup());exit;end;
 if a_str='bringwindowtotop' then begin result:=cbool(BringWindowToTop(si(param[1])));exit;end;
 if a_str='iszoomed' then begin result:=cbool(IsZoomed(si(param[1])));exit;end;
 if a_str='enddialog' then begin result:=cbool(EndDialog(si(param[1]),si(param[2])));exit;end;
 if a_str='getdlgitem' then begin result:=cint(GetDlgItem(si(param[1]),si(param[2])));exit;end;
 if a_str='setdlgitemint' then begin result:=cbool(SetDlgItemInt(si(param[1]),si(param[2]),si(param[3]),sb(param[4])));exit;end;
 if a_str='setdlgitemtext' then begin result:=cbool(SetDlgItemText(si(param[1]),si(param[2]),paramp[3]));exit;end;
 if a_str='getdlgitemtext' then begin result:=cint(GetDlgItemText(si(param[1]),si(param[2]),paramp[3],si(param[4])));exit;end;
 if a_str='checkdlgbutton' then begin result:=cbool(CheckDlgButton(si(param[1]),si(param[2]),si(param[3])));exit;end;
 if a_str='checkradiobutton' then begin result:=cbool(CheckRadioButton(si(param[1]),si(param[2]),si(param[3]),si(param[4])));exit;end;
 if a_str='isdlgbuttonchecked' then begin result:=cint(IsDlgButtonChecked(si(param[1]),si(param[2])));exit;end;
 if a_str='getnextdlggroupitem' then begin result:=cint(GetNextDlgGroupItem(si(param[1]),si(param[2]),sb(param[3])));exit;end;
 if a_str='getnextdlgtabitem' then begin result:=cint(GetNextDlgTabItem(si(param[1]),si(param[2]),sb(param[3])));exit;end;
 if a_str='getdlgctrlid' then begin result:=cint(GetDlgCtrlID(si(param[1])));exit;end;
 if a_str='openclipboard' then begin result:=cbool(OpenClipboard(si(param[1])));exit;end;
 if a_str='closeclipboard' then begin result:=cbool(CloseClipboard());exit;end;
 if a_str='getclipboardsequencenumber' then begin result:=cint(GetClipboardSequenceNumber());exit;end;
 if a_str='getclipboardowner' then begin result:=cint(GetClipboardOwner());exit;end;
 if a_str='setclipboardviewer' then begin result:=cint(SetClipboardViewer(si(param[1])));exit;end;
 if a_str='getclipboardviewer' then begin result:=cint(GetClipboardViewer());exit;end;
 if a_str='changeclipboardchain' then begin result:=cbool(ChangeClipboardChain(si(param[1]),si(param[2])));exit;end;
 if a_str='setclipboarddata' then begin result:=cint(SetClipboardData(si(param[1]),si(param[2])));exit;end;
 if a_str='getclipboarddata' then begin result:=cint(GetClipboardData(si(param[1])));exit;end;
 if a_str='registerclipboardformat' then begin result:=cint(RegisterClipboardFormat(paramp[1]));exit;end;
 if a_str='countclipboardformats' then begin result:=cint(CountClipboardFormats());exit;end;
 if a_str='enumclipboardformats' then begin result:=cint(EnumClipboardFormats(si(param[1])));exit;end;
 if a_str='getclipboardformatname' then begin result:=cint(GetClipboardFormatName(si(param[1]),paramp[2],si(param[3])));exit;end;
 if a_str='emptyclipboard' then begin result:=cbool(EmptyClipboard());exit;end;
 if a_str='isclipboardformatavailable' then begin result:=cbool(IsClipboardFormatAvailable(si(param[1])));exit;end;
 if a_str='getopenclipboardwindow' then begin result:=cint(GetOpenClipboardWindow());exit;end;
 if a_str='chartooem' then begin result:=cbool(CharToOem(paramp[1],paramp[2]));exit;end;
 if a_str='oemtochar' then begin result:=cbool(OemToChar(paramp[1],paramp[2]));exit;end;
 if a_str='chartooembuff' then begin result:=cbool(CharToOemBuff(paramp[1],paramp[2],si(param[3])));exit;end;
 if a_str='oemtocharbuff' then begin result:=cbool(OemToCharBuff(paramp[1],paramp[2],si(param[3])));exit;end;
 if a_str='charupper' then begin result:=cstr(CharUpper(paramp[1]));exit;end;
 if a_str='charupperbuff' then begin result:=cint(CharUpperBuff(paramp[1],si(param[2])));exit;end;
 if a_str='charlower' then begin result:=cstr(CharLower(paramp[1]));exit;end;
 if a_str='charlowerbuff' then begin result:=cint(CharLowerBuff(paramp[1],si(param[2])));exit;end;
 if a_str='charnext' then begin result:=cstr(CharNext(paramp[1]));exit;end;
 if a_str='charprev' then begin result:=cstr(CharPrev(paramp[1],paramp[2]));exit;end;
 if a_str='setfocus' then begin result:=cint(SetFocus(si(param[1])));exit;end;
 if a_str='getactivewindow' then begin result:=cint(GetActiveWindow());exit;end;
 if a_str='getfocus' then begin result:=cint(GetFocus());exit;end;
 if a_str='getkbcodepage' then begin result:=cint(GetKBCodePage());exit;end;
 if a_str='getkeyboardtype' then begin result:=cint(GetKeyboardType(si(param[1])));exit;end;
 if a_str='oemkeyscan' then begin result:=cint(OemKeyScan(si(param[1])));exit;end;
 if a_str='mapvirtualkey' then begin result:=cint(MapVirtualKey(si(param[1]),si(param[2])));exit;end;
 if a_str='mapvirtualkeya' then begin result:=cint(MapVirtualKeyA(si(param[1]),si(param[2])));exit;end;
 if a_str='mapvirtualkeyw' then begin result:=cint(MapVirtualKeyW(si(param[1]),si(param[2])));exit;end;
 if a_str='getinputstate' then begin result:=cbool(GetInputState());exit;end;
 if a_str='getqueuestatus' then begin result:=cint(GetQueueStatus(si(param[1])));exit;end;
 if a_str='getcapture' then begin result:=cint(GetCapture());exit;end;
 if a_str='setcapture' then begin result:=cint(SetCapture(si(param[1])));exit;end;
 if a_str='releasecapture' then begin result:=cbool(ReleaseCapture());exit;end;
 if a_str='killtimer' then begin result:=cbool(KillTimer(si(param[1]),si(param[2])));exit;end;
 if a_str='iswindowunicode' then begin result:=cbool(IsWindowUnicode(si(param[1])));exit;end;
 if a_str='enablewindow' then begin result:=cbool(EnableWindow(si(param[1]),sb(param[2])));exit;end;
 if a_str='iswindowenabled' then begin result:=cbool(IsWindowEnabled(si(param[1])));exit;end;
 if a_str='getsystemmetrics' then begin result:=cint(GetSystemMetrics(si(param[1])));exit;end;
 if a_str='drawmenubar' then begin result:=cbool(DrawMenuBar(si(param[1])));exit;end;
 if a_str='endmenu' then begin result:=cbool(EndMenu());exit;end;
 if a_str='updatewindow' then begin result:=cbool(UpdateWindow(si(param[1])));exit;end;
 if a_str='setactivewindow' then begin result:=cint(SetActiveWindow(si(param[1])));exit;end;
 if a_str='getforegroundwindow' then begin result:=cint(GetForegroundWindow());exit;end;
 if a_str='paintdesktop' then begin result:=cbool(PaintDesktop(si(param[1])));exit;end;
 if a_str='setforegroundwindow' then begin result:=cbool(SetForegroundWindow(si(param[1])));exit;end;
 if a_str='windowfromdc' then begin result:=cint(WindowFromDC(si(param[1])));exit;end;
 if a_str='getdc' then begin result:=cint(GetDC(si(param[1])));exit;end;
 if a_str='getwindowdc' then begin result:=cint(GetWindowDC(si(param[1])));exit;end;
 if a_str='releasedc' then begin result:=cint(ReleaseDC(si(param[1]),si(param[2])));exit;end;
 if a_str='excludeupdatergn' then begin result:=cint(ExcludeUpdateRgn(si(param[1]),si(param[2])));exit;end;
 if a_str='lockwindowupdate' then begin result:=cbool(LockWindowUpdate(si(param[1])));exit;end;
 if a_str='setscrollpos' then begin result:=cint(SetScrollPos(si(param[1]),si(param[2]),si(param[3]),sb(param[4])));exit;end;
 if a_str='getscrollpos' then begin result:=cint(GetScrollPos(si(param[1]),si(param[2])));exit;end;
 if a_str='setscrollrange' then begin result:=cbool(SetScrollRange(si(param[1]),si(param[2]),si(param[3]),si(param[4]),sb(param[5])));exit;end;
 if a_str='showscrollbar' then begin result:=cbool(ShowScrollBar(si(param[1]),si(param[2]),sb(param[3])));exit;end;
 if a_str='enablescrollbar' then begin result:=cbool(EnableScrollBar(si(param[1]),si(param[2]),si(param[3])));exit;end;
 if a_str='setprop' then begin result:=cbool(SetProp(si(param[1]),paramp[2],si(param[3])));exit;end;
 if a_str='getprop' then begin result:=cint(GetProp(si(param[1]),paramp[2]));exit;end;
 if a_str='removeprop' then begin result:=cint(RemoveProp(si(param[1]),paramp[2]));exit;end;
 if a_str='setwindowtext' then begin result:=cbool(SetWindowText(si(param[1]),paramp[2]));exit;end;
 if a_str='getwindowtext' then begin result:=cint(GetWindowText(si(param[1]),paramp[2],si(param[3])));exit;end;
 if a_str='getwindowtextlength' then begin result:=cint(GetWindowTextLength(si(param[1])));exit;end;
 if a_str='getwindowtextlengtha' then begin result:=cint(GetWindowTextLengthA(si(param[1])));exit;end;
 if a_str='getwindowtextlengthw' then begin result:=cint(GetWindowTextLengthW(si(param[1])));exit;end;
 if a_str='setwindowcontexthelpid' then begin result:=cbool(SetWindowContextHelpId(si(param[1]),si(param[2])));exit;end;
 if a_str='getwindowcontexthelpid' then begin result:=cint(GetWindowContextHelpId(si(param[1])));exit;end;
 if a_str='messagebox' then begin result:=cint(MessageBox(si(param[1]),paramp[2],paramp[3],si(param[4])));exit;end;
 if a_str='messageboxex' then begin result:=cint(MessageBoxEx(si(param[1]),paramp[2],paramp[3],si(param[4]),si(param[5])));exit;end;
 if a_str='messagebeep' then begin result:=cbool(MessageBeep(si(param[1])));exit;end;
 if a_str='showcursor' then begin result:=cint(ShowCursor(sb(param[1])));exit;end;
 if a_str='setcursorpos' then begin result:=cbool(SetCursorPos(si(param[1]),si(param[2])));exit;end;
 if a_str='getcaretblinktime' then begin result:=cint(GetCaretBlinkTime());exit;end;
 if a_str='setcaretblinktime' then begin result:=cbool(SetCaretBlinkTime(si(param[1])));exit;end;
 if a_str='destroycaret' then begin result:=cbool(DestroyCaret());exit;end;
 if a_str='hidecaret' then begin result:=cbool(HideCaret(si(param[1])));exit;end;
 if a_str='showcaret' then begin result:=cbool(ShowCaret(si(param[1])));exit;end;
 if a_str='setcaretpos' then begin result:=cbool(SetCaretPos(si(param[1]),si(param[2])));exit;end;
 if a_str='getsyscolor' then begin result:=cint(GetSysColor(si(param[1])));exit;end;
 if a_str='getwindowword' then begin result:=cint(GetWindowWord(si(param[1]),si(param[2])));exit;end;
 if a_str='setwindowword' then begin result:=cint(SetWindowWord(si(param[1]),si(param[2]),si(param[3])));exit;end;
 if a_str='getclassword' then begin result:=cint(GetClassWord(si(param[1]),si(param[2])));exit;end;
 if a_str='setclassword' then begin result:=cint(SetClassWord(si(param[1]),si(param[2]),si(param[3])));exit;end;
 if a_str='getclasslong' then begin result:=cint(GetClassLong(si(param[1]),si(param[2])));exit;end;
 if a_str='getclasslonga' then begin result:=cint(GetClassLongA(si(param[1]),si(param[2])));exit;end;
 if a_str='getclasslongw' then begin result:=cint(GetClassLongW(si(param[1]),si(param[2])));exit;end;
 if a_str='getdesktopwindow' then begin result:=cint(GetDesktopWindow());exit;end;
 if a_str='getparent' then begin result:=cint(GetParent(si(param[1])));exit;end;
 if a_str='setparent' then begin result:=cint(SetParent(si(param[1]),si(param[2])));exit;end;
 if a_str='findwindow' then begin result:=cint(FindWindow(paramp[1],paramp[2]));exit;end;
 if a_str='findwindowex' then begin result:=cint(FindWindowEx(si(param[1]),si(param[2]),paramp[3],paramp[4]));exit;end;
 if a_str='getclassname' then begin result:=cint(GetClassName(si(param[1]),paramp[2],si(param[3])));exit;end;
 if a_str='getnextwindow' then begin result:=cint(GetNextWindow(si(param[1]),si(param[2])));exit;end;
 if a_str='getlastactivepopup' then begin result:=cint(GetLastActivePopup(si(param[1])));exit;end;
 if a_str='getwindow' then begin result:=cint(GetWindow(si(param[1]),si(param[2])));exit;end;
 if a_str='copyimage' then begin result:=cint(CopyImage(si(param[1]),si(param[2]),si(param[3]),si(param[4]),si(param[5])));exit;end;
 if a_str='dlgdirlist' then begin result:=cint(DlgDirList(si(param[1]),paramp[2],si(param[3]),si(param[4]),si(param[5])));exit;end;
 if a_str='dlgdirselectex' then begin result:=cbool(DlgDirSelectEx(si(param[1]),paramp[2],si(param[3]),si(param[4])));exit;end;
 if a_str='dlgdirlistcombobox' then begin result:=cint(DlgDirListComboBox(si(param[1]),paramp[2],si(param[3]),si(param[4]),si(param[5])));exit;end;
 if a_str='dlgdirselectcomboboxex' then begin result:=cbool(DlgDirSelectComboBoxEx(si(param[1]),paramp[2],si(param[3]),si(param[4])));exit;end;
 if a_str='arrangeiconicwindows' then begin result:=cint(ArrangeIconicWindows(si(param[1])));exit;end;
 if a_str='winhelp' then begin result:=cbool(WinHelp(si(param[1]),paramp[2],si(param[3]),si(param[4])));exit;end;
 if a_str='getguiresources' then begin result:=cint(GetGuiResources(si(param[1]),si(param[2])));exit;end;
 if a_str='unhookwinevent' then begin result:=cbool(UnhookWinEvent(si(param[1])));exit;end;
 if a_str='getancestor' then begin result:=cint(GetAncestor(si(param[1]),si(param[2])));exit;end;
 if a_str='realgetwindowclass' then begin result:=cint(RealGetWindowClass(si(param[1]),paramp[2],si(param[3])));exit;end;
 if a_str='getlistboxinfo' then begin result:=cint(GetListBoxInfo(si(param[1])));exit;end;
 if a_str='lockworkstation' then begin result:=cbool(LockWorkStation());exit;end;
 if a_str='userhandlegrantaccess' then begin result:=cbool(UserHandleGrantAccess(si(param[1]),si(param[2])));exit;end;
 if a_str='isvalidcodepage' then begin result:=cbool(IsValidCodePage(si(param[1])));exit;end;
 if a_str='getacp' then begin result:=cint(GetACP());exit;end;
 if a_str='getoemcp' then begin result:=cint(GetOEMCP());exit;end;
 if a_str='foldstring' then begin result:=cint(FoldString(si(param[1]),paramp[2],si(param[3]),paramp[4],si(param[5])));exit;end;
 if a_str='setconsolemode' then begin result:=cbool(SetConsoleMode(si(param[1]),si(param[2])));exit;end;
 if a_str='setconsoleactivescreenbuffer' then begin result:=cbool(SetConsoleActiveScreenBuffer(si(param[1])));exit;end;
 if a_str='flushconsoleinputbuffer' then begin result:=cbool(FlushConsoleInputBuffer(si(param[1])));exit;end;
 if a_str='setconsoletextattribute' then begin result:=cbool(SetConsoleTextAttribute(si(param[1]),si(param[2])));exit;end;
 if a_str='generateconsolectrlevent' then begin result:=cbool(GenerateConsoleCtrlEvent(si(param[1]),si(param[2])));exit;end;
 if a_str='allocconsole' then begin result:=cbool(AllocConsole());exit;end;
 if a_str='freeconsole' then begin result:=cbool(FreeConsole());exit;end;
 if a_str='getconsoletitle' then begin result:=cint(GetConsoleTitle(paramp[1],si(param[2])));exit;end;
 if a_str='setconsoletitle' then begin result:=cbool(SetConsoleTitle(paramp[1]));exit;end;
 if a_str='getconsolecp' then begin result:=cint(GetConsoleCP());exit;end;
 if a_str='setconsolecp' then begin result:=cbool(SetConsoleCP(si(param[1])));exit;end;
 if a_str='getconsoleoutputcp' then begin result:=cint(GetConsoleOutputCP());exit;end;
 if a_str='setconsoleoutputcp' then begin result:=cbool(SetConsoleOutputCP(si(param[1])));exit;end;
 if a_str='verlanguagename' then begin result:=cint(VerLanguageName(si(param[1]),paramp[2],si(param[3])));exit;end;
 if a_str='initiatesystemshutdown' then begin result:=cbool(InitiateSystemShutdown(paramp[1],paramp[2],si(param[3]),sb(param[4]),sb(param[5])));exit;end;
 if a_str='abortsystemshutdown' then begin result:=cbool(AbortSystemShutdown(paramp[1]));exit;end;
 if a_str='wnetaddconnection' then begin result:=cint(WNetAddConnection(paramp[1],paramp[2],paramp[3]));exit;end;
 if a_str='wnetcancelconnection' then begin result:=cint(WNetCancelConnection(paramp[1],sb(param[2])));exit;end;
 if a_str='wnetcancelconnection2' then begin result:=cint(WNetCancelConnection2(paramp[1],si(param[2]),sb(param[3])));exit;end;
 if a_str='wnetconnectiondialog' then begin result:=cint(WNetConnectionDialog(si(param[1]),si(param[2])));exit;end;
 if a_str='wnetdisconnectdialog' then begin result:=cint(WNetDisconnectDialog(si(param[1]),si(param[2])));exit;end;
 if a_str='wnetcloseenum' then begin result:=cint(WNetCloseEnum(si(param[1])));exit;end;
 if a_str='impersonateddeclientwindow' then begin result:=cbool(ImpersonateDdeClientWindow(si(param[1]),si(param[2])));exit;end;



except
      _debug_print('Error: '+inttostr(getlasterror),true);
  end;


end;





///////////////


function func_exists(__comp_vars:TComp;__func:string):boolean;var z:byte;begin
    __func:=lowercase(__func);
    result:=false;
    for z:=0 to __comp_vars.__func_count-1 do
    if isfirststr(lowercase(__comp_vars.__func_ident[z]),__func+'(')=true then begin
    result:=true;
    exit;
    end;
end;
function get_func_array(input:string):string;begin
    //input:   <Func>([Var1[,Var2]])

    result:=copy(input,pos('(',input)+1,length(input));

    result:=copy(result,1,length(result)-1);

      result:=stringreplace(result,'$',#5,[rfReplaceAll]);
end;
function call_func(var __comp_vars:TComp;__func:string;__param:string=''):string;var z:byte;begin
    if __comp_vars.__func_count=0 then exit;

    __func:=lowercase(__func);
    for z:=0 to __comp_vars.__func_count-1 do
    if isfirststr(lowercase(__comp_vars.__func_ident[z]),__func+'(')=true then begin
      __comp_vars.__RETURN:='';
      script.comp_execute_script_from_strings(__comp_vars,__comp_vars.__func_body[z],true,get_func_array(__comp_vars.__func_ident[z]),__param);
      result:=__comp_vars.__RETURN;
      exit;
    end;
end;

function _int2str(input:string):string;var i:cardinal;op:boolean;begin
    // "string".666    will_be    "string"."666"
    result:='';
    op:=false;

    for i:=1 to length(input)do begin
        if copy(input,i,1)='"' then if copy(input,i-1,1)<>'\' then begin result:=result+'"';op:=not op;continue;end;

        if copy(input,i,1)='.' then if op=false then begin result:=result+'."';continue;end;

        result:=result+copy(input,i,1);
    end;

    if copy(result,1,1)='"' then if copy(result,length(result),1)<>'"' then result:=result+'"';
    result:=___stringreplace(result,'"."',char(06),[rfReplaceAll],true);

   { input:=___stringreplaceX2(input,'.',char(06),[rfReplaceAll],false);
     input:=___stringreplace(input,'."',char(06),[rfReplaceAll],false);
     input:=___stringreplace(input,'".',char(06),[rfReplaceAll],false);
   }

end;

function par(__comp:TComp;input:string;SaveType:Boolean=False):string;var is_string:boolean;begin

    if copy(input,1,1)='"' then is_string:=true else is_string:=false;
    input:=___stringreplace(input,'"."',char(06),[rfReplaceAll],true);
    input:=___stringreplaceX2(input,'.',char(06),[rfReplaceAll],false);
    input:=___stringreplace(input,'."',char(06),[rfReplaceAll],false);
    input:=___stringreplace(input,'".',char(06),[rfReplaceAll],false);


input := truncate(input);
input:=replace_vars(__comp,input);
input:=comp_statement(input);
input:= math_compiler(input);

//old

input:=_stringreplace(input,'null',#15,[rfIgnoreCase,rfReplaceAll]);
input:=StringReplace(input,#5,'$',[rfReplaceAll]);
     if is_string then input:=_int2str(input);

if SaveType=false then input:=escape_string(input);


    result:=stringreplace(



 input,


 #6,'',[rfReplaceAll]);

 //result:=_stringreplace(result,#15,'null',[rfReplaceAll]);


end;

procedure console_w(const input:string);var i:cardinal;begin
    //SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),safe_strtoint(param[1]));
    if length(input)=0 then exit; 
    for i:=1 to length(input)do
    case ord(input[i])of
    {f}1:SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),safe_strtoint('$'+copy(input,i+1,1)));
    {b}2:SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),safe_strtoint('$'+copy(input,i+1,1))*(16));
    else if ((copy(input,i-1,1)<>#1)and(copy(input,i-1,1)<>#2))then write(input[i]);
    end;

end;
function IntToByte(i:integer):Byte;begin
    if ((0<=i) and(i<=255)) then result:=i else result:=255;
end;
procedure __TIMER(hwnd : HWND;uMsg : UINT;idEvent : UINT;dwTime : DWORD);stdcall;var b:byte;begin
    for b:=0 to 255 do
    if TIMER_ARRAY[b].ID=idEvent then
    call_func(__main_comp,TIMER_ARRAY[b].CallbackFunc);

end;
function __GUI_FUNC(hWnd: HWND; Msg: UINT; WParam: WPARAM; LParam: LPARAM): UINT; stdcall;var _res:string;b:byte;begin
result:=Integer(True);

if __MAIN_COMP.__HALT then begin
    //Result := DefWindowProc(hWnd,Msg,wParam,lParam);
    //Windows.DestroyWindow(hwnd);
    
    exit;
end;

case Msg of
{WM_CREATE} $0001,
//{WM_MOVE} $0003,
//{WM_SIZE} $0005,
{WM_ACTIVATE} $0006,
{WM_SETFOCUS} $0007,
{WM_KILLFOCUS} $0008,
{WM_CLOSE} $0010,
{WM_QUERYENDSESSION} $0011,
{WM_QUIT} $0012,
{WM_ENDSESSION} $0016,
{WM_SYSTEMERROR} $0017,
{WM_CONTEXTMENU} $007B,
{WM_USER} $0400,
{WM_COMMAND} $0111,
{WM_CHAR} $0102,
//{WM_INITDIALOG} $0110,//RESERVED FOR GUI_DIALOG
{WM_SYSCOMMAND} $0112,
{WM_TIMER} $0113,
{WM_INITMENU} $0116,
{WM_INITMENUPOPUP} $0117,
{WM_MENUSELECT} $011F,
{WM_MENUCHAR} $0120,
{WM_MENUCOMMAND} $0126,
{WM_LBUTTONDOWN} $0201,
{WM_LBUTTONUP} $0202,
{WM_LBUTTONDBLCLK} $0203,
{WM_RBUTTONDOWN} $0204,
{WM_RBUTTONUP} $0205,
{WM_RBUTTONDBLCLK} $0206,
{WM_MBUTTONDOWN} $0207,
{WM_MBUTTONUP} $0208,
{WM_MBUTTONDBLCLK} $0209,
{WM_MOUSEWHEEL} $020A,
WM_TRAYNOTIFY
: begin
 for b:=0 to 255 do
 if CBF_ARRAY[b].Handle=hwnd then  begin
                                // $window,$message,$lparam,$id

 if LOWORD( wParam )=0 then
 _res:=call_func(__MAIN_COMP,CBF_ARRAY[b].CallBackFunc,inttostr(hwnd)+','+inttostr(msg)+','+inttostr(lparam)+','+inttostr(GetWindowContextHelpId(lparam)))
else
 _res:=call_func(__MAIN_COMP,CBF_ARRAY[b].CallBackFunc,inttostr(hwnd)+','+inttostr(msg)+','+inttostr(lparam)+','+inttostr(LOWORD( wParam )));

  if length(_res)=0 then
 Result := DefWindowProc(hWnd,Msg,wParam,lParam)else


  break; exit;end;
   Result := DefWindowProc(hWnd,Msg,wParam,lParam);
 end;
 {WM_INITDIALOG} $0110: CBF_ARRAY[byte(lparam)].Handle:=hwnd;
 else  Result := DefWindowProc(hWnd,Msg,wParam,lParam); //else

 end;
 end;
function comp_op(var __comp:TComp;var formt:byte;var execute:ShortInt;acc:byte;operator:string;parameters:string):string;



var CCI:TConsoleCursorInfo;_c:boolean;_con:TCoord;i:cardinal;buff:PChar;  hSnapshoot: THandle; pe32: TProcessEntry32; param:array[1..255]of string; begin

 result:='';

 for i:=1 to 255 do param[i]:='';
if getpm_count(parameters)>255 then
param[1]:='TOO_MUCH_PARAMETERS' else
for i:=1 to getpm_count(parameters) do
 param[i]:=par(__comp,Getpm(parameters,i));

    _debug_print('comp_op(operator='+operator+';parameters='+parameters+')',true);
   operator:=uppercase(operator);
   __temp_s:='';
   __temp_i:=0;
   try

   if func_exists(__comp,operator)=true then begin

       result:=call_func(__comp,operator,parameters);
       exit;

   end;



   if operator='API' then begin

        result:=_api(param);
   exit;
   end;

    for i:=1 to 255 do if param[i]=#15 then param[i]:='';

    if operator='' then begin

        result:=math_compiler(parameters);
        exit;
    end;
	//tray_icon($handle,$icon,$tip,$state);
	//tray_icon_show_balloon($handle,$title,$text,$icon)
	//tray_icon_hide_balloon($handle)
   if operator='TRAY_ICON' then begin
      result:='';
	  FillChar(IconData, SizeOf(IconData), 0);
	  IconData.cbSize := SizeOf(TNotifyIconDataEx);
	  IconData.hIcon:=safe_strtoint(param[2]);
	  IconData.hWnd :=safe_strtoint(param[1]);
	  StrPCopy(IconData.szTip, param[3]);
	  IconData.uId := 1;
	  IconData.uFlags := NIF_ICON + NIF_MESSAGE + NIF_TIP;
	  IconData.uCallbackMessage := WM_TRAYNOTIFY;

	  Shell_NotifyIcon(safe_strtoint(param[4]),@IconData);
   
   exit;end;
   
if operator='TRAY_ICON_HIDE_BALLOON' then begin
      result:='';
	  FillChar(IconData, SizeOf(IconData), 0);
	  IconData.cbSize := SizeOf(TNotifyIconDataEx);
	  IconData.hWnd :=safe_strtoint(param[1]);

    IconData.uFlags := IconData.uFlags or NIF_INFO;
    StrPCopy(IconData.szInfo, '');


   Shell_NotifyIcon(NIM_MODIFY,@IconData);
exit;end;
   if operator='TRAY_ICON_SHOW_BALLOON' then begin
      result:='';  
   (*FillChar(IconData, SizeOf(IconData), 0);
	  IconData.cbSize := SizeOf(TNotifyIconDataEx);
	  IconData.hWnd :=safe_strtoint(param[1]);
    IconData.uFlags := IconData.uFlags or NIF_INFO;     *)
    StrPCopy(IconData.szInfo, '');


   Shell_NotifyIcon(NIM_MODIFY,@IconData);



    IconData.uFlags := IconData.uFlags or NIF_INFO;
    StrLCopy(IconData.szInfo, PChar(param[3]), SizeOf(IconData.szInfo)-1);
    StrLCopy(IconData.szInfoTitle, PChar(param[2]), SizeOf(IconData.szInfoTitle)-1);
    IconData.TimeoutOrVersion.uTimeout := 10 * 1000;
    IconData.dwInfoFlags := safe_strtoint(param[4]);

    Shell_NotifyIcon(NIM_MODIFY,@IconData);

    IconData.uFlags := NIF_ICON + NIF_MESSAGE + NIF_TIP;   
   
   exit;end;
   

   if operator='MENU_CREATE' then begin
         if safe_strtoint(param[1])=0 then //MENU
         result :=Inttostr(CreateMenu) else result:=Inttostr(CreatePopupMenu);
         AddHandle(__comp,safe_StrToInt(Result));
   exit;end;

   if operator='MATH_COMPILER' then begin
         result :=math_compiler(param[1]);

   exit;end;

   if operator='MENU_APPEND' then begin
         result:='';
         for i:=3 to getpm_count(parameters)do
         AppendMenu(safe_strtoint(param[1]),safe_strtoint(param[2]),
         safe_strtoint(getpm(param[i],2)),PChar(getpm(param[i],1)));

   exit;end;

   if operator='MENU_SET' then begin
         result:=cbool(SetMenu(safe_strtoint(param[1]),safe_strtoint(param[2])));


   exit;end;

   if operator='LIBRARY_LOAD' then begin
         result:=inttostr(LoadLibrary(pChar(param[1])));

         AddHandle(__comp,safe_StrToInt(Result));
   exit;end;

   if operator='LIBRARY_LOAD_ICON' then begin
         if safe_strtoint(param[2])=0 then
         result:=inttostr(windows.LoadIcon(safe_strtoint(param[1]),PChar(param[2])))
         else result:=inttostr(windows.LoadIcon(safe_strtoint(param[1]),PChar(safe_strtoint(param[2]))));

         AddHandle(__comp,safe_StrToInt(Result));
   exit;end;

   if operator='LIBRARY_LOAD_CURSOR' then begin
         if safe_strtoint(param[2])=0 then
         result:=inttostr(windows.LoadCursor(safe_strtoint(param[1]),PChar(param[2])))
         else result:=inttostr(windows.LoadCursor(safe_strtoint(param[1]),PChar(safe_strtoint(param[2]))));

         AddHandle(__comp,safe_StrToInt(Result));
   exit;end;

   if operator='LIBRARY_LOAD_BITMAP' then begin
         if safe_strtoint(param[2])=0 then
         result:=inttostr(windows.LoadBitmap(safe_strtoint(param[1]),PChar(param[2])))
         else result:=inttostr(windows.LoadBitmap(safe_strtoint(param[1]),PChar(safe_strtoint(param[2]))));

         AddHandle(__comp,safe_StrToInt(Result));
   exit;end;

   if operator='LIBRARY_LOAD_MENU' then begin
         if safe_strtoint(param[2])=0 then
         result:=inttostr(windows.LoadMenu(safe_strtoint(param[1]),PChar(param[2])))
         else result:=inttostr(windows.LoadMenu(safe_strtoint(param[1]),PChar(safe_strtoint(param[2]))));

         AddHandle(__comp,safe_StrToInt(Result));
   exit;end;

   if operator='LIBRARY_FREE' then begin
         result:=cbool(FreeLibrary(safe_strtoint(param[1])));

         //RemoveHandle(__comp,safe_StrToInt(safe_strtoint(param[1])));
   exit;end;


   if operator='TIMER_KILL' then begin
           result:='0';
           for i:=0 to 255 do
           if TIMER_ARRAY[i].ID =safe_strtoint(param[1]) then begin
               TIMER_ARRAY[i].Active :=false;
               KillTimer(0,TIMER_ARRAY[i].ID);
               result:='1';
               break;
           end;
       exit;
   end;

   if operator='TIMER_CREATE' then begin
              result:='';
              for i:=0 to 255 do
                   if TIMER_ARRAY[Byte(i)].Active=false then begin

                       TIMER_ARRAY[Byte(i)].Interval:=safe_strtoint(param[1]);
                       TIMER_ARRAY[Byte(i)].CallbackFunc:=param[2];
                       TIMER_ARRAY[Byte(i)].ID:=SetTimer(0,Byte(i),TIMER_ARRAY[i].Interval,@__TIMER);
                       if TIMER_ARRAY[Byte(i)].ID >0 then TIMER_ARRAY[Byte(i)].Active :=true;
                       result:=inttostr(TIMER_ARRAY[Byte(i)].ID);
                       break;
                   end;
              AddHandle(__comp,safe_StrToInt(Result));
              exit;
    end;

   if operator='HALT' then begin
              if allow_halt=true then halt;
              exit;
    end;

   if operator='SHELL_ABOUT' then begin
              result:='';
              ShellAbout(safe_strtoint(param[1]),pchar(param[2]),pchar(param[3]),safe_strtoint(param[4]));
              exit;
    end;


   if operator='EXIT' then begin
              execute:=-1;
              result:='';
              exit;
    end;

   if operator='BREAK' then begin
              execute:=-2;
              result:='';
              exit;
    end;

   if operator='CONTINUE' then begin
              execute:=-3;
              result:='';
              exit;
    end;

   if operator='RETURN' then begin
        __COMP.__RETURN:=script._execute_line(__comp,param[1]);
        __COMP.__result:=177; //RETURN_V
        execute:=-1;
        exit;
   end;



   ////**************    *****************\\\\\\\\\\\\\
   if operator='REP' then begin
       result:='';
       for i:=1 to getpm_count(parameters)do
            result:=result+param[i];
       exit;

	  exit;
   end;

   if operator='CONSOLE' then begin
     result:='';
      if param[1]='1' then _c:=true;
      if param[1]='0' then _c:=false;
      if uppercase(param[1])='TRUE' then _c:=true;
      if uppercase(param[1])='FALSE' then _c:=false;
	  if _c=true then begin
	    __CONSOLE:=THANDLE(AllocConsole);
      AddHandle(__comp,__CONSOLE);
	    SetConsoleMode(GetStdHandle(STD_OUTPUT_HANDLE),ENABLE_PROCESSED_OUTPUT);
	  end else begin
		FreeConsole;
    __CONSOLE:=0;
	  end;

	  exit;
   end;
   
   if operator='CONSOLE_SET_TITLE' then begin
        result:='';
		SetConsoleTitle(PAnsiChar(param[1]));
	  
	  exit;
   end;

   if operator='CONSOLE_GET_TITLE' then begin
        result:='';
        __temp_s:=_str(#0,1024);
		   GetConsoleTitle(@__temp_s[1],length(__temp_s));
    result:=TrimNulls(__temp_s);
	  
	  exit;
   end;
      if operator='CONSOLE_SET_CARET' then begin
        result:='';
		windows.GetConsoleCursorInfo(GetStdHandle(STD_OUTPUT_HANDLE),cci);
		_c:=cci.bVisible;
	  if param[1]='1' then _c:=true;
      if param[1]='0' then _c:=false;
      if uppercase(param[1])='TRUE' then _c:=true;
      if uppercase(param[1])='FALSE' then _c:=false;
		if safe_strtoint(param[2])>0 then cci.dwSize:=safe_strtoint(param[2]);
        cci.bVisible :=_c;
		SetConsoleCursorInfo(GetStdHandle(STD_OUTPUT_HANDLE), CCI);
	  
	  exit;
   end;

   if operator='CONSOLE_SET_MODE' then begin
        result:='';
		SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),safe_strtoint(param[1]));

	  exit;
   end;

   if operator='CLOSE' then begin 
        result:='';
		    __comp.__HALT:=true;
        execute:=-1;
        //CloseHandles(__comp); //if so ...

	  exit;
   end;

   if operator='SCREEN_GET' then begin
        result:='';
        Windows.GetWindowRect(Windows.GetDesktopWindow,__PUBLIC.Rect);
        if safe_strtoint(param[1])=0 then result:=inttostr(__public.Rect.Right*__public.Rect.Bottom);
        if safe_strtoint(param[1])=1 then result:=inttostr(__public.Rect.Right);
        if safe_strtoint(param[1])=2 then result:=inttostr(__public.Rect.Bottom);

	  exit;
   end;

   if operator='MOUSE_GET' then begin
        result:='';
        Windows.GetCursorPos(__public.Rect.TopLeft);
        if safe_strtoint(param[1])=0 then result:=inttostr(__public.Rect.TopLeft.X*__public.Rect.TopLeft.Y);
        if safe_strtoint(param[1])=1 then result:=inttostr(__public.Rect.TopLeft.X);
        if safe_strtoint(param[1])=2 then result:=inttostr(__public.Rect.TopLeft.Y);

	  exit;
   end;
   if operator='MOUSE_SET' then begin
        result:='';
        Windows.SetCursorPos(safe_strtoint(param[1]),safe_strtoint(param[2]));

	  exit;
   end;

   if operator='KEYBOARD_GET' then begin
         result:=inttostr(GetAsyncKeyState(safe_strtoint(param[1])));

	  exit;
   end;

   if operator='CONSOLE_SET_POSITION' then begin
        result:='';

        _con.X:=safe_strtoint(param[1]);
        _con.Y:=safe_strtoint(param[2]);
		SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE),_con);

	  exit;
   end;

   if operator='CONSOLE_CLEAR' then begin
        result:='';
		cls;
	  
	  exit;
   end;
   if operator='CONSOLE_READ' then begin
     readln(__TEMP_S);
     result:=__TEMP_S;
     exit;
   end;
   if operator='CONSOLE_WRITE' then begin
              result:='';
              console_w(param[1]);
              exit;
    end;

   if operator='INT2HEX' then begin

     result:='"'+IntToHex(safe_strtoint(param[1]),safe_strtoint(param[2]))+'"';
     exit;
   end;

   if operator='PROMPT' then begin
     readln(__TEMP_S);
     result:=__TEMP_S;
     exit;
   end;

   if operator='LAUNCH' then begin
      result:='';
      if param[3]='1' then _c:=true;
      if param[3]='0' then _c:=false;
      if uppercase(param[3])='TRUE' then _c:=true;
      if uppercase(param[3])='FALSE' then _c:=false;

      launch(param[1],param[2],_c,safe_strtoint(param[4]));
      exit;
   end;

   if operator='REGISTRY_GET_VALUE' then begin
       result:='"'+_rgv(param[1],param[2])+'"';
        exit;
   end;

   if operator='EXTRACT_FILE_NAME' then begin
       result:='"'+SysUtils.ExtractFileName(param[1])+'"';
        exit;
   end;

   if operator='EXTRACT_FILE_PATH' then begin
       result:='"'+SysUtils.ExtractFilePath(param[1])+'"';
        exit;
   end;

   if operator='EXTRACT_FILE_EXT' then begin
       result:='"'+SysUtils.ExtractFileExt(param[1])+'"';
        exit;
   end;

   if operator='CHANGE_FILE_EXT' then begin
       result:='"'+SysUtils.ChangeFileExt(param[1],param[2])+'"';
        exit;
   end;



   if operator='REGISTRY_SET_VALUE' then begin
       result:='';
       _rsv(param[1],param[2],param[3]);
        exit;
   end;
   if operator='REGISTRY_DELETE_VALUE' then begin
       result:='';
       _rdv(param[1],param[2]);
        exit;
   end;
   if operator='REGISTRY_DELETE_KEY' then begin
       result:='';
       _rdk(param[1],param[2]);
        exit;
   end;
   if operator='REGISTRY_CREATE_KEY' then begin
       result:='';
       _rck(param[1],param[2]);
        exit;
   end;

   if operator='SLEEP' then begin
       result:='';
       sysutils.Sleep(safe_strtoint(param[1])); 
        exit;
   end;

   if operator='FILE_SIZE' then begin
       result:=inttostr(fs(param[1]));
        exit;
   end;

   if operator='FILE_WRITE' then begin
       result:='';
       _fbw(param[1],param[2],safe_strtoint(param[3]),safe_strtoint(param[4]));
        exit;
   end;
   if operator='FILE_APPEND' then begin
       result:='';
       _fba(param[1],param[2]);
        exit;
   end;
   if operator='FILE_LINES' then begin
       result:=inttostr(_fbcl(param[1]));
        exit;
   end;
   if operator='FILE_COPY' then begin
       result:='';
       windows.CopyFile(PANSICHAR(param[1]),PANSICHAR(param[2]),False);
        exit;
   end;
   if operator='FILE_MOVE' then begin
       result:='';
       windows.MoveFile(PANSICHAR(param[1]),PANSICHAR(param[2]));
        exit;
   end;
   if operator='FILE_DELETE' then begin
       result:='';
       windows.DeleteFile(PANSICHAR(param[1]));
        exit;
   end;
   if operator='FILE_GET_LINE' then begin
       result:='"'+_fbgl(param[1],safe_strtoint(param[2]))+'"';
        exit;
   end;
   if operator='FILE_READ' then begin
       result:='"'+_fbr(param[1],safe_strtoint(param[2]),safe_strtoint(param[3]))+'"';
        exit;
   end;
   if operator='TRIM_NULLS' then begin
       result:='"'+TrimNulls(param[1])+'"';
        exit;
   end;
   if operator='MESSAGE' then begin
       if safe_strtoint(param[4])=0 then
       param[4]:=inttostr(GetDesktopWindow);
       result:=inttostr(windows.MessageBox(safe_strtoint(param[4]),pansichar(param[1]),pansichar(param[2]),safe_strtoint(param[3])));
        exit;
   end;

   if operator='SYSTEM' then begin
       result:='"'+system(param[1])+'"';
        exit;
   end;
   if operator='STRING_REVERSE' then begin
       result:='"'+strutils.ReverseString(param[1])+'"';
        exit;
   end;

   if operator='POS_EX' then begin
       result:=inttostr(strutils.PosEx(param[1],param[2],safe_strtoint(param[3])) );
        exit;
   end;


   if operator='EXPERT' then begin
       _c:=true;
       if uppercase(param[1])='TRUE' then __EXPERT:=1;
       if uppercase(param[1])='FALSE' then __EXPERT:=0;;
       if param[1]='1' then __EXPERT:=1;
       if param[1]='0' then __EXPERT:=0;
       result:='';
        exit;
   end;




    if operator='INPUT' then begin
       result:='"'+inputboxa(param[1],param[2],param[3])+'"';
        exit;
   end;
   if operator='VAR' then begin
       result:='';
       __var:=param[1];
       exit;
   end;

   if operator='EXECUTE' then begin
       result:='';
       script.comp_execute_script(param[1],result);
       if safe_strtoint(param[2])=0 then execute:=-1;
       exit;
   end;


   if operator='STRING' then begin
       result:='"'+_str(param[1],safe_strtoint(param[2]))+'"';
       exit;
   end;


   if operator='EXTERNAL_FUNCTION' then begin
       result:=RunExternalFunc(param[1],param[2]);
       exit;
   end;

   if operator='EXTERNAL_PROCEDURE' then begin
       result:='';
       RunExternalProc(param[1],param[2]);
       exit;
   end;

   if operator='COMPARE' then begin
       _c:=string_compare(param[2],param[1],param[3]);
       if _c=true then result:='1' else result:='0';
       exit;
   end;

   if operator='IS_FIRST_STRING' then begin
       _c:=isfirststr(param[1],param[2]);
       if _c=true then result:='1' else result:='0';
       exit;
   end;

  if operator='FILE_EXISTS' then begin
       _c:=fileexists(param[1]);
       if _c=true then result:='1' else result:='0';
       exit;
   end;
   if operator='WINEXEC' then begin
       //_c:=fileexists(param[1]);
       result:='';
       winexec(pansichar(param[1]),safe_strtoint(param[2]));
       exit;
   end;
   if operator='DIR_EXISTS' then begin
       _c:=directoryexists(param[1]);
       if _c=true then result:='1' else result:='0';
       exit;
   end;

   if operator='IS_DIGITS_ONLY' then begin
       _c:=isdigitsonly(param[1]);
       if _c=true then result:='1' else result:='0';
       exit;
   end;

   if operator='RAND' then begin
       result:=inttostr(rand(safe_strtoint(param[1]),safe_strtoint(param[2])));
       exit;
   end;


   if operator='CHAR' then begin
       result:='';
       for i:=1 to getpm_count(parameters)do
            result:=result+char(safe_strtoint(param[i]));
       result:='"'+result+'"';
       exit;
   end;
   if operator='ASC' then begin
       result:='';
       for i:=1 to getpm_count(parameters)do
            if length(param[i])>=1 then
            result:=inttostr(ord(param[i][1]));
       exit;
   end;
     if operator='PRINT' then begin
              result:='';
              write(param[1]);
              exit;
    end;
   if operator='RIGHT_STRING' then begin
              result:='"'+rightstr(param[1],safe_strtoint(param[2]))+'"';
              exit;
    end;
    if operator='LEFT_STRING' then begin
              result:='"'+leftstr(param[1],safe_strtoint(param[2]))+'"';
              exit;
    end;

   if operator='EXIT_EQUALS' then begin
              if param[1]=param[2] then execute:=-1;
              result:='';
              exit;
    end;


   if operator='EXIT_NOT_EQUALS' then begin
              if param[1]<>param[2] then execute:=-1;
              result:='';
              exit;
    end;

    if operator='BREAK_LINE' then begin
              execute:=0;
              result:='';
              exit;
    end;
    if operator='BREAK_LINE_EQUALS' then begin
              if param[1]=param[2] then execute:=0;
              result:='';
              exit;
    end;


    if operator='CHAR_COUNT' then begin
              result:=inttostr(char_count(param[1],param[2]));
              exit;
    end;



    if operator='BREAK_LINE_NOT_EQUALS' then begin
              if param[1]<>param[2] then execute:=0;
              result:='';
              exit;
    end;

    if operator='LENGTH' then begin
              result:=inttostr(length(param[1]));
              exit;
    end;

    if operator='COPY' then begin
              if safe_strtoint(param[3])=0 then param[3]:=inttostr(length(param[1]));
              result:='"'+copy(param[1],safe_strtoint(param[2]),safe_strtoint(param[3]))+'"';
              exit;
    end;

    if operator='STRING_REPLACE' then begin
              result:='"'+stringreplace(param[1],param[2],param[3],[rfReplaceAll,rfIgnoreCase])+'"';
              exit;
    end;

    if operator='UPPER_CASE' then begin
              result:='"'+UpperCase(param[1])+'"';
              exit;
    end;

    if operator='LOWER_CASE' then begin
              result:='"'+LowerCase(param[1])+'"';
              exit;
    end;


    if operator='GET_WORD' then begin
              result:='"'+get_word(param[1],safe_strtoint(param[2]))+'"';
              exit;
    end;

    if operator='GET_WORD_COUNT' then begin
              result:=inttostr(get_word_count(param[1]));
              exit;
    end;

    if operator='TRIM' then begin
              result:='"'+_trim(param[1])+'"';
              exit;
    end;

   if operator='M_TRIM' then begin
              result:='"'+m_trim(param[1])+'"';
              exit;
    end;

   if operator='ENVIRON' then begin
              result:='"'+sysutils.GetEnvironmentVariable(param[1])+'"';
              exit;
    end;
       if operator='DIR' then begin
              result:='"'+sysutils.GetCurrentDir+'"';
              exit;
    end;
    if operator='CHDIR' then begin
              result:='';
              sysutils.SetCurrentDir(param[1]);
              exit;
    end;

   if operator='TAB' then begin

              result:='"'+stringreplace(param[1],char(09),_str(char(32),safe_strtoint(param[2])),[rfReplaceAll]) +'"';
              exit;
    end;

    if operator='TRIM32' then begin
              result:='"'+trim(param[1])+'"';
              exit;
    end;

    if operator='DIGITS_ONLY' then begin
              result:='"'+digitsonly(param[1])+'"';
              exit;
    end;

    if operator='DIGITS_EXCEPT' then begin
              result:='"'+digitsexcept(param[1])+'"';
              exit;
    end;

    if operator='POS' then begin
              result:=inttostr(pos(param[1],param[2]));
              exit;
    end;


    // addons
    if operator='MD5' then begin
              result:='"'+md5(param[1])+'"';
              exit;
    end;

    if operator='MD5_FILE' then begin
              result:='"'+md5(fastBinaryRead(param[1]))+'"';
              exit;
    end;
    if operator='PROCESS_GET_PID' then begin
              result:=IntToStr(ProcToPID(param[1]));
              exit;
    end;

    if operator='PROCESS_GET_PROCESS' then begin
              result:='"'+PIDToProc(safe_strtoint(param[1]))+'"';
              exit;
    end;
    if operator='PROCESS_GET_FILE' then begin
              result:='"'+GetFullPIDExePath(safe_strtoint(param[1]))+'"';
              exit;
    end;
    if operator='PROCESS_GET_PID_FROM_FILE' then begin
              result:=IntToStr(exepathtoPID(param[1]));
              exit;
    end;
    if operator='PROCESS_KILL' then begin
              result:=cbool(
              terminateprocess(
              openprocess(PROCESS_ALL_ACCESS,false,safe_strtoint(param[1]))
              ,safe_strtoint(param[2])
              )
              );     // AddHandle(__comp,safe_StrToInt(Result));
              exit;
    end;

    if operator='FILE_LOCK' then begin
              result:=IntToStr(fileopen(param[1],fmShareExclusive));
              AddHandle(__comp,safe_StrToInt(Result));
              exit;
    end;
    if operator='FILE_UNLOCK' then begin
              result:='';
              FileClose(safe_strtoint(param[1]));
              exit;
    end;

    if operator='RGB' then begin
             result:=inttoStr(RGB(safe_strtoint(param[1]),safe_strtoint(param[2]),safe_strtoint(param[3])));

    exit;end;

   if operator='IDLE' then begin
		result:='';
      //windows.ZeroMemory(@__main_comp,SizeOf(__Main_comp));
		  __MAIN_COMP:=__Comp;
      __MAIN_COMP.__HALT:=FALSE;
		  While ((__MAIN_COMP.__HALT=FALSE)and(GetMessage(Msg,0,0,0))) do begin
			sleep(1);
			TranslateMessage(Msg);
			DispatchMessage(Msg);
		  end;

   exit;
   end;

	if operator='GUI_WINDOW' then begin
		FillChar(_WndClass, SizeOf(_WndClass), 0);

		 _WndClass.hInstance      := SysInit.hInstance;
		 _WndClass.lpszClassName  := PChar(param[1]);
		 _WndClass.lpfnWndProc    := @__GUI_FUNC;
     _WndClass.hbrBackground:=COLOR_BTNFACE+1;
     if safe_strtoint(param[10])=0 then 
	 _WndClass.hCursor :=      LoadCursor(0,IDC_ARROW)
	 else _WndClass.hCursor :=safe_strtoint(param[10]);    
     if safe_strtoint(param[8])>0 then
	 _WndClass.hIcon:=safe_strtoint(param[8]);
		 result:=inttostr(Windows.RegisterClass(_WndClass));

     AddHandle(__comp,safe_StrToInt(Result));
		 //__MAIN_COMP:=0;
      __MAIN_COMP:=__Comp;
     for i:=0 to 255 do
     if CBF_ARRAY[Byte(i)].Active=false then begin
       CBF_ARRAY[Byte(i)].CallBackFunc:=param[11];

       Windows.GetWindowRect(Windows.GetDesktopWindow,__PUBLIC.Rect);
       if safe_strtoint(param[4])=$FFFFFF then
       param[4]:=inttostr((__public.Rect.Right- safe_strtoint(param[6])) div 2 );
       if safe_strtoint(param[5])=$FFFFFF then
       param[5]:=inttostr((__public.Rect.Bottom - safe_strtoint(param[7])) div 2);

      CBF_ARRAY[Byte(i)].Handle:= CreateWindow(PChar(param[1]),PChar(param[2]),safe_strtoint(param[3]),
		               safe_strtoint(param[4]),safe_strtoint(param[5]),safe_strtoint(param[6]),safe_strtoint(param[7]),safe_strtoint(param[9]),0,hInstance,nil);
      if CBF_ARRAY[Byte(i)].Handle>0 then  CBF_ARRAY[Byte(i)].Active:=true;
		 result:=inttostr(CBF_ARRAY[i].Handle);
     AddHandle(__comp,safe_StrToInt(Result));
		 Windows.ShowWindow(CBF_ARRAY[Byte(i)].Handle,SW_SHOW);
		 UpdateWindow(CBF_ARRAY[Byte(i)].Handle);
     break;
     end;



		 exit;
   end;
   if operator='GUI_DIALOGBOX' then begin
   __MAIN_COMP:=__Comp;
     for i:=0 to 255 do
     if CBF_ARRAY[Byte(i)].Active=false then begin
       CBF_ARRAY[Byte(i)].CallBackFunc:=param[4];
      CBF_ARRAY[Byte(i)].Handle:= $FFFFFF;
      CBF_ARRAY[Byte(i)].Active:=True;


             if safe_strtoint(param[2])=0 then
             result:=IntToStr(Windows.DialogBoxParam(safe_strtoint(param[1]),PChar(param[2]),safe_strtoint(param[3]),@__GUI_FUNC,I))
             else
             result:=IntToStr(Windows.DialogBoxParam(safe_strtoint(param[1]),PChar(safe_strtoint(param[2])),safe_strtoint(param[3]),@__GUI_FUNC,I));

             break;end;

   exit;end;

   if operator='GUI_CREATEDIALOG' then begin
   __MAIN_COMP:=__Comp;
     for i:=0 to 255 do
     if CBF_ARRAY[Byte(i)].Active=false then begin
      CBF_ARRAY[Byte(i)].CallBackFunc:=param[4];
      CBF_ARRAY[Byte(i)].Handle:= $FFFFFF;
      CBF_ARRAY[Byte(i)].Active:=True;


             if safe_strtoint(param[2])=0 then
             result:=IntToStr(Windows.CreateDialogParam(safe_strtoint(param[1]),PChar(param[2]),safe_strtoint(param[3]),@__GUI_FUNC,I))
             else
             result:=IntToStr(Windows.CreateDialogParam(safe_strtoint(param[1]),PChar(safe_strtoint(param[2])),safe_strtoint(param[3]),@__GUI_FUNC,I));
             AddHandle(__comp,safe_StrToInt(Result));
             break;end;

   exit;end;

   if operator='GUI_CLOSEDIALOG' then begin
             result:=cbool(EndDialog(safe_strtoint(param[1]),safe_strtoint(param[2])));

             //RemoveHandle(__comp,safe_StrToInt(param[1]));
   exit;end;

   if operator='GUI_CONTROL' then begin
		result:=inttostr(CreateWindow(PChar(param[2]),PChar(param[3]),safe_strtoint(param[5]),
    safe_strtoint(param[6]),safe_strtoint(param[7]),safe_strtoint(param[8]),safe_strtoint(param[9]),
    safe_strtoint(param[1]),safe_strtoint(param[4]),hInstance,nil));
    AddHandle(__comp,safe_StrToInt(Result));

    //Windows.SetWindowContextHelpId(safe_strtoint(result),safe_strtoint(param[4]));

   exit;end;

/////////////////////////
  // gui_getid($hwnd)
  // gui_set($hwnd,$id,$text)
  // gui_get($hwnd,$id)

if operator='GUI_GETID' then begin
   result:=inttostr(windows.GetDlgCtrlID(safe_strtoint(param[1])));
exit;end;

if operator='GUI_SET' then begin
   result:=cbool(windows.SetDlgItemText(safe_strtoint(param[1]),safe_strtoint(param[2]),PChar(param[3])) );
exit;end;

if operator='GUI_GET' then begin

   i:=MAX_BUFFER_LENGTH;

   buff:=StrAlloc(i);
   windows.GetDlgItemText(safe_strtoint(param[1]),safe_strtoint(param[2]),buff,i);
   if i>MAX_BUFFER_LENGTH then begin buff:=StrAlloc(i);windows.GetDlgItemText(safe_strtoint(param[1]),safe_strtoint(param[2]),buff,i);end;
   result:=StrPas(buff);

exit;end;


/////////////////////////


   if operator='GUI_SHOW' then begin
		result:=cbool(ShowWindow(safe_Strtoint(param[1]),SW_SHOW));
   exit;
   end;
   

    if operator='GUI_HIDE' then begin
		result:=cbool(ShowWindow(safe_Strtoint(param[1]),SW_HIDE));
   exit;
   end;
    if operator='GUI_CLOSE' then begin
		result:=cbool(DestroyWindow(safe_Strtoint(param[1])));
   exit;
   end;

    if operator='PROCESS_ENUM' then begin
              result:='';

  hSnapshoot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if (hSnapshoot = -1) then exit;
  pe32.dwSize := SizeOf(TProcessEntry32);
  if (Process32First(hSnapshoot, pe32)) then repeat

        call_func(__comp,param[1],inttostr(pe32.th32ProcessID)+',"'+pe32.szExeFile+'"');

    until
      not Process32Next(hSnapshoot, pe32);
  CloseHandle (hSnapshoot);


              result:='1';
              exit;
    end;



    if @CustomScriptFunction<>nil then _c:=CustomScriptFunction(operator,param,result);
   if _c=true then exit;

       result:=#0;
       _debug_print('Unknown: '+operator,true,true);
     except
            result:=#0;
       _debug_print('Error at: '+operator,true,true);
     end;
 end;

procedure comp_sub_line(var __comp:TComp;var formt:byte;var execute:ShortInt;acc:byte;t_line:string;t_line_index:integer;var str:string;level:integer);var i,j,h,w:integer;param,op,_op:string;d:boolean;begin
if length(str)=0 then exit;
w:=0;
d:=false;




    for i:=1 to length(str)do begin
    if str[i]='"' then d:=not d;

     if str[i]='(' then if d=false then inc(w);
      if w=level then begin
          param:=copy(str,i+1,_pos(')',copy(str,i+1,length(str)))-1);
          _op:='';
          for j:=i-1 downto 1 do 
            //if ((ord(str[j])>=64) and (ord(str[j])<=122))then
            if( ((ord(str[j])>=48)and(ord(str[j])<=57)) or ((ord(str[j])>=64) and (ord(str[j])<=122))  ) then
              _op:=_op+str[j] else break;
           op:='';
          for j:=length(_op) downto 1 do op:=op+_op[j];
             if length(__comp.__use[__comp.__level])=0 then
          str:=stringreplace(str,op+'('+param+')',untr(comp_op(__comp,formt,execute,acc,op,param)),[])
             else begin // use <op>{}
             _op:=comp_op(__comp,formt,execute,acc,__comp.__use[__comp.__level]+'_'+op,param);
             //if _op=#0 then
             //_op:=comp_op(__comp,formt,execute,acc,__comp.__use[__comp.__level]+op,param);
             if _op<>#0 then begin
             str:=stringreplace(str,op+'('+param+')',untr(_op),[]);
             end else
             str:=stringreplace(str,op+'('+param+')',untr(comp_op(__comp,formt,execute,acc,op,param)),[]);
             end;

          exit;
      end;
    end;
end;

 function comp_line(var __comp:TComp; var formt:byte;var execute:ShortInt;t_line:string;t_line_index:integer;str:string;line,acc:integer;stop_on_line:boolean=false;t_file:string=''):string;var _from_,_to_,for_var:integer;_var_:string;i,h,j,c,w:integer;_alfa_:cardinal;_op,_reverse:boolean; equals,op1,op2:string;
procedure set_debug_point(var __comp:TComp);var i:integer;begin
     __comp.__debug_point:=0;
     for i:=0 to __comp.__current_code_line do
     if pos(#7,__comp.__code.Strings[i])=1 then
     inc(__comp.__debug_point);
end;
procedure rep(_operator:string);begin
    str:=stringreplace(str,_operator,uppercase(_operator),[rfReplaceAll,rfIgnoreCase]);
end;
begin

if __comp.__level=255 then __comp.__level:=0;
if ((acc>255)or(acc<0)) then exit;
    str:=m_trim(trim(str));




   // str:=___stringreplace(str,'"','',[rfReplaceAll],false);
    if length(str)=0 then exit;
    if execute=0 then exit;
    if copy(str,1,2)='//' then exit;
    if str='/*' then begin __comp.__comments:=true;exit;end;
    if str='*/' then begin __comp.__comments:=false;exit;end;
    if __comp.__comments=true then exit;

    //__comp.__cycle

    //////**
    //******

    if str='{' then begin inc(__comp.__level);
    __comp.__statement[__comp.__level]:=__comp.__statement[0{__comp.__level-1}];
    exit;end;
    if str='}' then begin dec(__comp.__level);exit;end;
    if __comp.__level>0 then if __comp.__statement[__comp.__level]=false then exit;


    //debug_point()


    //
if pos(#7,str)=1 then begin
  stop_on_line:=true;
  //__comp.__code.Text  __comp.__current_code_line
end;

if stop_on_line then if paramcount>0 then begin
  set_debug_point(__comp);
 _debug_print( 'debug_point(point='+inttostr(__comp.__debug_point)+';script="'+paramstr(1)+'")',true,false,true);

end;


/////////////////////////



    if ((uppercase(copy(str,1,3))<>'USE')and(uppercase(copy(str,1,2))<>'IF')and(uppercase(copy(str,1,4))<>'ELSE')and(uppercase(copy(str,1,3))<>'FOR')and(uppercase(copy(str,1,5))<>'WHILE')and(uppercase(copy(str,1,6))<>'SWITCH'))then
    if length(str)>0 then if str[length(str)]<>';' then begin _debug_print('Missing [;] > '+str+' <',true,true);exit;end;
    if line<>-1 then if t_line_index<>line then exit;
	if uppercase(str)='CONTINUE;' then str:='continue();';
	if uppercase(str)='BREAK;' then str:='break();';
	if uppercase(str)='EXIT;' then str:='exit();';
  if uppercase(str)='HALT;' then str:='halt();';
if uppercase(str)='IDLE;' then str:='idle();';

  if ((isfirststr(uppercase(str),'RETURN')=true)and(_pos('(',str)<=0)) then begin
      if str[length(str)]=';' then delete(str,length(str),1);
      str:='return('+copy(str,length('RETURN')+1,length(str))+');';

// return()
// swith()
// if()
// use()
// for()
// while()

  end;
  //if uppercase(str)='RETURN;' then str:='return();';



    _op:=false;
    c:=0;
    w:=0;
//*-- str:=stringreplace(str,'\"',char(19),[rfReplaceAll]);
    for i:=1 to length(str)do begin
     if str[i]='"' then if copy(str,i-1,1)<>'\' then _op:=not _op;
     if _op=false then begin
      if str[i]='(' then inc(c);
      if str[i]='(' then inc(w);
      if str[i]=')' then dec(c);
     end;
    end;

    if c<>0 then begin
    if c>0 then _debug_print('Missing [)] > '+str+' <',true,true);
    if c<0 then _debug_print('Missing [(] > '+str+' <',true,true);
    exit;end;

    str:=__stringreplace(str,'$',#5,[rfReplaceAll]);

    str:=___stringreplace(str,'"+"','+',[rfReplaceAll],True,False);
    str:=___stringreplace(str,'"-"','-',[rfReplaceAll],True,False);
    str:=___stringreplace(str,'"/"','/',[rfReplaceAll],True,False);
    str:=___stringreplace(str,'"*"','*',[rfReplaceAll],True,False);
    str:=___stringreplace(str,'"^"','^',[rfReplaceAll],True,False);


    if ((uppercase(copy(str,1,3))<>'USE')and(uppercase(copy(str,1,2))<>'IF')and(uppercase(copy(str,1,4))<>'ELSE')and(copy(str,1,1)<>#5)and(uppercase(copy(str,1,3))<>'FOR')and(uppercase(copy(str,1,5))<>'WHILE')and(uppercase(copy(str,1,6))<>'SWITCH')) then delete(str,length(str),1)else
    begin






        if uppercase(copy(str,1,3))='USE' then begin










    __comp.__statement[__comp.__level+1]:=true;
    __comp.__use[__comp.__level+1]:=comp_get_param(__comp,acc,t_line,str);
    __comp.__statement[0]:=__comp.__statement[__comp.__level+1];

    end;







    if uppercase(copy(str,1,2))='IF' then begin


    equals:='';
    str:=comp_get_param(__comp,acc,t_line,str);

    str:=_stringreplace(str,',==,',',"==",',[]);
    str:=_stringreplace(str,',<>,',',"<>",',[]);
    str:=_stringreplace(str,',>>,',',">>",',[]);
    str:=_stringreplace(str,',<<,',',"<<",',[]);
    str:=_stringreplace(str,',>=,',',">=",',[]);
    str:=_stringreplace(str,',<=,',',"<=",',[]);

    if _pos('==',str)>0 then equals:='==';
    if _pos('<>',str)>0 then equals:='<>';
    if _pos('>>',str)>0 then equals:='>>';
    if _pos('<<',str)>0 then equals:='<<';
    if _pos('>=',str)>0 then equals:='>=';
    if _pos('<=',str)>0 then equals:='<=';


    if length(equals)=0 then begin
      str:=str+'>>0';
      equals:='>>';
    end;

    str:=_stringreplace(str,'==','?',[]);
    str:=_stringreplace(str,'<>','?',[]);
    str:=_stringreplace(str,'>>','?',[]);
    str:=_stringreplace(str,'<<','?',[]);
    str:=_stringreplace(str,'>=','?',[]);
    str:=_stringreplace(str,'<=','?',[]);



    op1:=script._execute_line(__comp,getpm(str,1,63),t_line,t_line_index,-1);
    op2:=script._execute_line(__comp,getpm(str,2,63),t_line,t_line_index,-1);



    if uppercase(op1)='TRUE' then op1:='1';
    if uppercase(op2)='TRUE' then op2:='1';
    if uppercase(op1)='FALSE' then op1:='0';
    if uppercase(op2)='FALSE' then op2:='0';
    if uppercase(op1)='NULL' then op1:=#0;
    if uppercase(op2)='NULL' then op2:=#0;
    __comp.__statement[__comp.__level+1]:=string_compare(equals,escape_string(op1),escape_string(op2));
    __comp.__use[__comp.__level+1]:='';
    __comp.__statement[0]:=__comp.__statement[__comp.__level+1];
    end;
    if uppercase(copy(str,1,3))='FOR' then begin
        w:=0;
        if RightStr(uppercase(str),length('REVERSE'))='REVERSE' then
        _reverse:=true else _reverse:=false;

        if _reverse=true then
        str:=_stringreplace(str,'REVERSE','',[rfIgnoreCase]);

        str:=copy(str,pos('(',str)+1,length(str));
        delete(str,length(str),1);
        _var_:=getpm(str,1,44);
        //str:=str);
        str:=comp_replace_all(__comp,str,t_line,acc);
        _from_:=safe_strtoint(script._execute_line(__comp,getpm(str,2,44)));
        //comp_line(__comp,formt,execute,t_line,t_line_index,getpm(str,2,44),line,acc,False));
        _to_:=safe_strtoint(script._execute_line(__comp,getpm(str,3,44)));
        //comp_line(__comp,formt,execute,t_line,t_line_index,getpm(str,3,44),line,acc,False));

        //__comp.__statement[__comp.__level+1]:=true;
        //inc(__comp.__level);

        for i:=__comp.__current_code_line+2 to __comp.__code.Count-1 do begin
            __comp.__code.Strings[i]:=trim_comp_line(__comp.__code.Strings[i]);
            if __comp.__code.Strings[i]='{' then inc(w);
            if __comp.__code.Strings[i]='}' then dec(w);

            //if w=0 then form1._debug_print(__comp.__code.Strings[i],true);
            if w=-1 then begin w:=i;break;end;
        end;
        i:=__comp.__current_code_line+2;


        if _reverse =false then
        for for_var:=(_from_) to (_to_) do begin
            set_var(__comp,(_var_),inttostr(for_var));
            for _alfa_:=i to w-1 do begin
             j:=execute;
              __comp.__current_code_line:=_alfa_;
              if length(__comp.__code.Strings[_alfa_])>0 then
              comp_line(__comp,formt,execute,t_line,t_line_index,__comp.__code.Strings[_alfa_],line,acc);
               //form1._debug_print(__comp.__code.Strings[i],true);
               if execute <0 then break;
              end;
              h:=execute;
              if execute<-1 then execute:=j;

           if h=-1 then break;
           if h=-2 then break;
           if h=-3 then continue;
       end else

     for for_var:=(_from_) downto (_to_) do begin
            set_var(__comp,(_var_),inttostr(for_var));
            for _alfa_:=i to w-1 do begin
             j:=execute;
              __comp.__current_code_line:=_alfa_;
              if length(__comp.__code.Strings[_alfa_])>0 then
              comp_line(__comp,formt,execute,t_line,t_line_index,__comp.__code.Strings[_alfa_],line,acc);
               //form1._debug_print(__comp.__code.Strings[i],true);
               if execute <0 then break;
              end;
              h:=execute;
              if execute<-1 then execute:=j;

           if h=-1 then break;
           if h=-2 then break;
           if h=-3 then continue;
       end;


        __comp.__statement[__comp.__level+1]:=false;
        __comp.__use[__comp.__level+1]:='';
        __comp.__statement[0]:=__comp.__statement[__comp.__level+1];
        //inc(__comp.__cycle);
    end;
    if uppercase(copy(str,1,5))='WHILE' then begin





             w:=0;
        str:=copy(str,pos('(',str)+1,length(str));
        delete(str,length(str),1);
        _var_:=str;
        //str:=str);



    equals:='';
    //str:=comp_replace_all(__comp,str,t_line,acc);

    if _pos('==',str)>0 then equals:='==';
    if _pos('<>',str)>0 then equals:='<>';
    if _pos('>>',str)>0 then equals:='>>';
    if _pos('<<',str)>0 then equals:='<<';
    if _pos('>=',str)>0 then equals:='>=';
    if _pos('<=',str)>0 then equals:='<=';

    if length(equals)=0 then begin
      str:=str+'>>0';
      equals:='>>';
    end;

    str:=__stringreplace(str,'==','?',[]);
    str:=__stringreplace(str,'<>','?',[]);
    str:=__stringreplace(str,'>>','?',[]);
    str:=__stringreplace(str,'<<','?',[]);
    str:=__stringreplace(str,'>=','?',[]);
    str:=__stringreplace(str,'<=','?',[]);



        for i:=__comp.__current_code_line+2 to __comp.__code.Count-1 do begin
            __comp.__code.Strings[i]:=trim_comp_line(__comp.__code.Strings[i]);
            if __comp.__code.Strings[i]='{' then inc(w);
            if __comp.__code.Strings[i]='}' then dec(w);

            //if w=0 then form1._debug_print(__comp.__code.Strings[i],true);
            if w=-1 then begin w:=i;break;end;
        end;
        i:=__comp.__current_code_line+2;

        // does not working correctly ...


         //__comp.__statement[__comp.__level+1]:=true;



    
        while
        (string_compare(


        equals,

        escape_string(script._execute_line(__comp,comp_replace_all(__comp,getpm(str,1,63),t_line,acc)))

        ,

        escape_string(script._execute_line(__comp,comp_replace_all(__comp,getpm(str,2,63),t_line,acc)))



        )=true) do
        begin

            for _alfa_:=i to w-1 do begin
            j:=execute;
              __comp.__current_code_line:=_alfa_;
              if length(__comp.__code.Strings[_alfa_])>0 then
              comp_line(__comp,formt,execute,t_line,t_line_index,__comp.__code.Strings[_alfa_],line,acc);
               //form1._debug_print(__comp.__code.Strings[i],true);
              if execute <0 then break;
              end;

              h:=execute;
              if execute<-1 then execute:=j;

           if h=-1 then break;
           if h=-2 then break;
           if h=-3 then continue;
       end;






        __comp.__statement[__comp.__level+1]:=false;
        __comp.__use[__comp.__level+1]:='';
        __comp.__statement[0]:=__comp.__statement[__comp.__level+1];
         //inc(__comp.__cycle);

    end;if(uppercase(copy(str,1,6))='SWITCH')then begin
       //str:=comp_replace_all(__comp,str,t_line,acc);
       //switch(_var_)
      _var_:=copy(str,pos('(',str)+1,length(str));
      delete(_var_,length(_var_),1);

       w:=0;

              for i:=__comp.__current_code_line+2 to __comp.__code.Count-1 do begin
            __comp.__code.Strings[i]:=trim_comp_line(__comp.__code.Strings[i]);
            if __comp.__code.Strings[i]='{' then inc(w);
            if __comp.__code.Strings[i]='}' then dec(w);

            //if w=0 then form1._debug_print(__comp.__code.Strings[i],true);
            if w=-1 then begin w:=i;break;end;
        end;
        i:=__comp.__current_code_line+2;

            for _alfa_:=i to w-1 do

              if _pos(':',__comp.__code.Strings[_alfa_])>0 then begin
              __comp.__code.Strings[_alfa_]:=
              'if('+_var_+'=='+copy(__comp.__code.Strings[_alfa_],1,_pos(':',__comp.__code.Strings[_alfa_])-1)+')';

//              form1._debug_print(__comp.__code.Strings[_alfa_],true);



              end;
              


           __comp.__statement[__comp.__level+1]:=true;
           __comp.__use[__comp.__level+1]:='';
        __comp.__statement[0]:=__comp.__statement[__comp.__level+1];

    end;
    if uppercase(copy(str,1,4))='ELSE' then begin
        __comp.__statement[__comp.__level+1]:=not __comp.__statement[__comp.__level+1];
        __comp.__use[__comp.__level+1]:='';
        __comp.__statement[0]:=__comp.__statement[__comp.__level+1];
    end;

    if copy(str,1,1)=#5{'$'} then begin
        if pos('=',str)>0 then begin
            str:=_stringreplace(str,'=NULL','='+#0,[rfIgnoreCase]);
            set_var(__comp,#5+copy(str,2,pos('=',str)-2),comp_line(__comp,formt,execute,t_line,t_line_index,comp_replace_all(__comp,copy(str,pos('=',str)+1,length(str)),t_line,acc),line,acc,false));
        end else result:=str;
    end;

    exit;
    end;


    //////////////////////

//    str:=stringreplace(str,char(18),'%',[rfReplaceAll]);
   if ((copy(str,1,1)='"')and(copy(str,length(str),1)='"')) then begin

       result:=comp_replace_all(__comp,copy(str,2,length(str)-2),t_line,acc); //
       exit;
   end;

    for c:=w downto 1 do
    comp_sub_line(__comp,formt,execute,acc,t_line,t_line_index,str,c);


    // 05
    str:=math_compiler(str);
    str:=___stringreplace(str,'"."',char(06),[rfReplaceAll],true);
    str:=___stringreplaceX2(str,'.',char(06),[rfReplaceAll],false);
    str:=___stringreplace(str,'."',char(06),[rfReplaceAll],false);
    str:=___stringreplace(str,'".',char(06),[rfReplaceAll],true);

    str:=stringreplace(str,char(06),'"."',[rfReplaceAll]);
{
$t = "."
$t = $r."\""

}
    str:={escape_string(}___stringreplace(str,'"."','',[rfReplaceAll],false){)};


    //if length(str)=0 then set_acc:=false;

    {if set_acc=true then
    SetACC(acc,str) else }
    result:=str;

end;

procedure ZeroComp(var __comp:TComp);var i:byte;begin
    __comp.__statement[0]:=true;
    __comp.__level:=0;
    __comp.__comments:=false;
    __comp.__var_count:=0;
    __comp.__cycle:=0;
	__comp.__error:=false;
	__comp.__result:=0;
   __comp.__func_count:=0;
   __comp.__return:='';
   __comp.__switch_level:=0;
   __comp.__current_code_line:=0;
   __comp.__debug_point:=0;
   __comp.__hwnds:=TList.Create;
   __comp.__HALT:=false;
  for i:=0 to 255 do begin
      __comp.__statement[i]:=True;
      __comp.__var_ident[i]:='';
      __comp.__var_value[i][0]:='';
      __comp.__func_ident[i]:='';
      __comp.__func_body[i]:='';
  end;
end;

procedure ZeroVarComp(var __comp:TComp);var i:byte;begin
    __comp.__var_count:=0;
  for i:=0 to 255 do begin
      __comp.__var_ident[i]:='';
      __comp.__var_value[i][0]:='';
  end;
end;

 function tscript._execute_line(__comp_vars:TComp;str:string;T_LINE:STRING='';T_LINE_INDEX:INTEGER=0;l:integer=-1):string;var execute:ShortInt; formt:byte;{__comp_vars:TComp;}
last_l:integer;_str:string;a,i,j:integer;op,delim:boolean;begin
//ZeroComp(__comp_vars);
  //Lines:=TStringList.Create;
  op:=false;
  delim:=false;
  last_l:=-1;
  _str:='';
  execute:=1;
       _str:='';
       for j:=1 to length(str)do begin

       if str[j]='"' then op:=not op;
       if ((str[j]=char(32))or(str[j]=char(9))) then
       (if op=true then
       _str:=_str+str[j])
       else
         _str:=_str+str[j];


    end;
    //str:=stringreplace(_str,char(9),'',[rfReplaceAll]);




       {if _pos(':',str)>0 then begin
         if '_'=copy(str,1,_pos('^',str)-1)then
         l:=-1 else
         //l:=safe_strtoint(digitsonly(copy(str,1,pos('^',str))));
         a:=safe_strtoint(digitsonly(copy(str,_pos('^',str),_pos(':',str))));
         if last_l<>l then execute:=1;
         if l=-1 then execute:=1;
         last_l:=l;
         //comp_line(execute,t_line,t_line_index,copy(str,pos(':',str_lines.Strings[i])+1,length(str_lines.Strings[i])),l,a);
       end else begin
         //if length(str)>0 then comp_line(execute,t_line,t_line_index,str_lines.Strings[i],l,a);
       end;
         }


    if length(_str)=0 then exit;
    if _str[length(str)]<>';' then _str:=_str+';';

    execute:=1;

    result:=comp_line(__comp_vars,formt,execute,t_line,t_line_index,_str,l,0,false);




end;

procedure erase_array_s(var source:array of string);var z:byte; begin
    for z:=0 to 255 do source[z]:='';
end;
procedure copy_array_s(const source:array of string;var dest:array of string);var z:byte; begin
    for z:=0 to 255 do dest[z]:=source[z];
end;

function ar_func(input:string):string;var i:cardinal;begin
    result:='';
    input:=copy(input,length('func')+1,length(input));
    for i:=1 to length(input) do result:=result+_trim(input[i]);

    if pos('(',result)<=0 then result:=result+'()';
end;
procedure fill_func(var __comp_vars:TComp);var func_id:byte;i,l:cardinal;func,comment:boolean;begin

    erase_array_s(__comp_vars.__func_ident);
    erase_array_s(__comp_vars.__func_body);
    __comp_vars.__func_count:=0;
    l:=0;
    func:=false;
    comment:=false;
    for i:=0 to __comp_vars.__code.Count-1 do begin
        if trim(__comp_vars.__code.Strings[i])='{' then begin inc(l);end;
        if trim(__comp_vars.__code.Strings[i])='}' then begin dec(l);end;
        if trim(__comp_vars.__code.Strings[i])='/*' then comment:=true;
        if trim(__comp_vars.__code.Strings[i])='*/' then comment:=false;

        if comment=true then continue;

        if func=true then begin
            if l=0 then begin func:=false;{if func_exists(__comp_vars,)} inc(__comp_vars.__func_count);continue;end;
            if ((l=1)and(trim(__comp_vars.__code.Strings[i])='{')) then continue;
            __comp_vars.__func_body[__comp_vars.__func_count]:=__comp_vars.__func_body[__comp_vars.__func_count]+_trim(__comp_vars.__code.Strings[i]);
        end;

        if ((isfirststr(trim(lowercase(__comp_vars.__code.Strings[i])),'func ')=true)and(l=0)) then begin
            func:=true;
            __comp_vars.__func_ident[__comp_vars.__func_count]:=ar_func(trim(__comp_vars.__code.Strings[i]));

            continue;
        end;
    end;
  // showmessage(__comp_vars.__func_body[0]);
end;




Function FowardComments(Input:String):String;var a,b:Integer;begin

 //delete(Input,_pos('//',input),posex(#10,input,_pos('//',input)));


 a:=1;
while a>0 do begin
 a:=_pos('//',input);
 if a=0 then break;

 b:=posex(#10,input,a);
 if b>0 then b:=b-a+1 else b:=Length(Input);

 delete(input,a,b);
end;


 a:=1;
while a>0 do begin
    a:=_pos('/*',Input);
    if a=0 then break;

    b:=_pos('*/',Input);

    if b>0 then b:=b-a+2 else b:=Length(Input);
    delete(Input,a,b);

end;

Result:=Input;
end;
function include(pcode:string):string;
procedure inc_this (inF:string);var _inF,inc_text:string;begin
 _inf:=trim(copy(inf,2,length(inf)));
 if copy(_inf,1,1)='"' then delete(_inf,1,1);
 if copy(_inf,length(_inf),1)='"' then delete(_inf,length(_inf),1);

 if copy(_inf,1,1)='<' then delete(_inf,1,1);
 if copy(_inf,length(_inf),1)='>' then delete(_inf,length(_inf),1);

 inc_text:=FastBinaryRead(_inf);
pcode:=_StringReplace(pcode,inF,inc_text,[]);
end;
begin
    pcode:=_StringReplace(pcode,'#include','#',[rfReplaceAll,rfIgnoreCase]);
    while _pos('#',pcode)>0 do begin
        inc_this( copy(pcode,_pos('#',pcode),__posex(chr(10),pcode,_pos('#',pcode))-_pos('#',pcode)) );
    end;

    result:=pcode;
end;
function PrepareCode(pcode:string):string;begin

 // all to (10)

pcode:=stringReplace(pcode,char(13),char(10),[rfReplaceAll]);
pcode:=stringReplace(pcode,char(10)+char(10),char(10),[rfReplaceAll]);

  pcode:=FowardComments(pcode);

 pcode:=include(pcode);

  pcode:=FowardComments(pcode);
 // include engine




 ////////////
pcode:=stringReplace(pcode,char(13)+char(10),' ',[rfReplaceAll]);
pcode:=stringReplace(pcode,char(13),' ',[rfReplaceAll]);
pcode:=stringReplace(pcode,char(10),' ',[rfReplaceAll]);
pcode:=_stringReplace(pcode,';',';'+char(10),[rfReplaceAll]);
pcode:=_stringReplace(pcode,'{',char(10)+'{'+char(10),[rfReplaceAll]);
pcode:=_stringReplace(pcode,'}',char(10)+'}'+char(10),[rfReplaceAll]);

pcode:=_stringReplace(pcode,'->','_',[rfReplaceAll]);

//pcode:=_stringReplace(pcode,'//',char(10)+'//',[rfReplaceAll]);
//pcode:=_stringReplace(pcode,'/*',char(10)+'/*'+char(10),[rfReplaceAll]);
//pcode:=_stringReplace(pcode,'*/',char(10)+'*/'+char(10),[rfReplaceAll]);

 result:=pcode;

end;
function is_accurate_allow(str,substr:string):boolean;begin
    //str = if   (a==b)     substr=if

    //auto complete if for while switch return use  ()
    
    str:=trim(uppercase(str));
    substr:=trim(uppercase(substr));
     result:=false;
    if isfirststr(str,substr)=false then exit;
    if '('<>leftstr(trim(copy(str,length(substr)+1,length(str))),1) then
    result:=true;
end;
function __accurate_add(str:string):string;begin
 result:=str;

 if is_accurate_allow(str,'use') then begin
 insert('(',result,4);
 insert(')',result,length(result)+1);
 end;

 if is_accurate_allow(str,'if') then begin
 insert('(',result,3);
 insert(')',result,length(result)+1);
 end;

 if is_accurate_allow(str,'switch') then begin
 insert('(',result,7);
 insert(')',result,length(result)+1);
 end;

 if is_accurate_allow(str,'while') then begin
 insert('(',result,6);
 insert(')',result,length(result)+1);
 end;

 if is_accurate_allow(str,'for') then begin
 insert('(',result,4);
 insert(')',result,length(result)+1);
 end;

 
end;
procedure comp_lines(var __comp_vars:TComp;str_lines:TStrings;is_func:boolean=false;__header:string='';__param:string='');var execute:ShortInt;last_l:integer;_str:string;l,a,i,j:integer;formt:byte;op,delim:boolean;{__comp_vars:TComp;}begin

//ZeroComp(__comp_vars);
{
copy_array_s(__comp_vars.__var_ident,__default_vars.__var_ident);
copy_array_s(__comp_vars.__var_value,__default_vars.__var_value);
__comp_vars.__var_count:=__default_vars.__var_count;
}

(*  for i:=0 to str_lines.Count-1 do begin
  if copy(trim(str_lines.strings[i]),1,2)='//' then
  str_lines.Strings[i]:='';
  if pos('//',str_lines.strings[i])>0 then str_lines.Strings[i]:=str_lines.Strings[i]+';';
  end;
*)
  //Lines:=TStringList.Create;

 str_lines.text:=PrepareCode(str_lines.text);
 __comp_vars.__code:=str_lines;


if is_func=false then begin
fill_func(__comp_vars);

  if __comp_vars.__func_count>0 then begin //$argc,$argv
    __comp_vars.__return:=call_func(__comp_vars,'main',inttostr(ParamCount-1));
    exit;
  end;

end;



  for i:=1 to getpm_count(__header)do
   set_var(__comp_vars,getpm(__header,i),par(__comp_vars,getpm(__param,i),TRUE));

  op:=false;
  delim:=false;
  last_l:=-1;
  __comp_vars.__code:=str_lines;
  for i:=0 to str_lines.Count-1 do begin
   execute:=1;
   if length(trim(str_lines.strings[i]))=0 then continue;
   if copy(str_lines.Strings[i],1,2)='//' then continue;
  _str:='';
  op:=false;
       str_lines.Strings[i]:=__accurate_add(_trim(str_lines.Strings[i]));
  for j:=1 to length(str_lines.Strings[i])do begin



       if str_lines.Strings[i][j]='"' then if copy(str_lines.Strings[i],j-1,1)<>'\' then op:=not op;
       if ((str_lines.Strings[i][j]=char(32))or(str_lines.Strings[i][j]=char(09))) then
       (if op=true then _str:=_str+str_lines.Strings[i][j])else
         _str:=_str+str_lines.Strings[i][j];



    end;
     __comp_vars.__code.Strings[i]:=_str;

     __comp_vars.__current_code_line:=i;
     if pos(#7,_str)=1 then begin inc(__comp_vars.__debug_point); delim:=true;delete(_str,1,1); end else delim:=false;
     comp_line(__comp_vars,formt,execute,'',0,_str,-1,0,delim);
     if __comp_vars.__code.Count <> str_lines.Count then __comp_vars.__code:=str_lines;
     if ((execute=-1)or(__comp_vars.__HALT)) then exit;
    //str_lines.Strings[i]:=stringreplace(_str,char(9),'',[rfReplaceAll]);
  end;


  end;








  procedure tscript.comp_execute_script_from_strings(var __comp:TComp;st:string;is_func:boolean=false;__header:string='';__param:string='');var _st:TStrings;var i:byte;begin
      _st:=TStringList.Create;
      _st.Text :=st;
      comp_lines(__comp,_st,is_func,__header,__param);

    for i:=1 to getpm_count(__header)do
     del_var(__comp,getpm(__header,i));
  end;

  function tscript.comp_execute_script(const fn:string;var return:string):boolean;var _st:TStrings;__comp:TComp;begin
      if fileexists(fn)=false then exit;
      _st:=TStringList.Create;
      _st.LoadFromFile(fn);
      ZeroComp(__comp);
      comp_lines(__comp,_st);
      return:=__comp.__return;
  end;

  procedure tscript.comp_execute_line(const line:string);var _st:TStrings;__comp:TComp;begin
      _st:=TStringList.Create;
      _st.Text:=line;
      ZeroComp(__comp);
      comp_lines(__comp,_st);
  end;

function tscript.comp_execute_func(const fn:string;const func:string;const param:string;var output:string):boolean;var _st:TStrings;__comp:TComp;begin
result:=false;
      if fileexists(fn)=false then exit;
      _st:=TStringList.Create;
      _st.LoadFromFile(fn);
      ZeroComp(__comp);
    _st.text:=PrepareCode(_st.text);
    __comp.__code:=_st;



  fill_func(__comp);

  if __comp.__func_count=0 then exit;
  output:=call_func(__comp,func,param);
  result:=true;
end;


initialization


   InitCommonControls;
   Script:=TScript.Create;
   __EXPERT:=0;
   __CONSOLE:=0;

  CustomScriptFunction:=nil;
  DebugOutputFunction:=nil;



end.





