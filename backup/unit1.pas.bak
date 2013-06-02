unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, ComCtrls, ShellCtrls, process;

type

  { TForm1 }

  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    StatusBar1: TStatusBar;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    function get_current_directory() : String;
    procedure write_status_message(status : String);
    function check_for_needed_files():boolean;
    procedure start_adb_daemon();
    procedure stop_adb_daemon();
    procedure adb_pull();
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  current_directory : String; //viariable which gets the name of the current directory to access the required componnents
  java_path : String;
  sudo_path : String;
  adb_path : String;
  sox_path : String;
  adb_started : boolean;
implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.MenuItem1Click(Sender: TObject);
begin

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  adb_started := false;
  write_status_message('----Starting GAPKMAN----');
  write_status_message('[TRY] getting current directory');
  //save the path in the variable working_directory
  current_directory := get_current_directory();
  write_status_message('[FINISHED] get current directory');
  //check if all needed files are there
  write_status_message('[CHECK] needed files in "other" directory (they should be there)');
  if check_for_needed_files() then write_status_message('[SUCCESS] needed files in "other"')
  else write_status_message('[ERROR] missing files; please check');
  write_status_message('[CHECK] needed executables on your system');
  if (java_path <> '') AND (sudo_path <> '') AND (adb_path <> '') {AND (sox_path <> '')} then
  begin
    write_status_message('[FOUND] java at: ' + java_path);
    write_status_message('[FOUND] sudo at: ' + sudo_path);
    write_status_message('[FOUND]  adb at: ' + adb_path);
    {write_status_message('[FOUND]  sox at: ' + sox_path);}
    write_status_message('[FINISHED] all executables found!');
    start_adb_daemon();
    write_status_message('[READY] GAPKMAN');
  end
  else
  begin
    write_status_message('[ERROR] missing executables; please check!');
  end;

end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  stop_adb_daemon();
end;



//function which gets the path of the current directory
function TForm1.get_current_directory() : String;
begin
  //read current directory per GetCurrentDirectory
  result := GetCurrentDir();
end;

//procedure to display status messages in statusbar
procedure TForm1.write_status_message(status:String);
begin
  //write last status into memo component
  Memo1.Lines.Add(StatusBar1.SimpleText);
  //write new status into statusbar
  StatusBar1.SimpleText := status;
end;


//function which search for all needed files
function TForm1.check_for_needed_files():boolean;
var P : TProcess;
  S : TStringList;
  i : Integer;
  j : Integer;
  check : Integer;
  files : array[0..6] of string;
  programfiles : array[0..3] of string;
begin
  check := 0;
  //initializing the names of needed files
  files[0] := '7za';
  files[1] := 'aapt';
  files[2] := 'apktool.jar';
  files[3] := 'optipng';
  files[4] := 'signapk.jar';
  files[5] := 'testkey.pk8';
  files[6] := 'testkey.x509.pem';
  //to be sure, that all needed files are there, we will run a ls command and validate the output
  P := TProcess.create(nil);
  S := TStringList.Create();
  P.CommandLine:='ls';
  P.CurrentDirectory:= current_directory + '/other';
  P.Options:=[poWaitOnExit, poUsePipes];
  P.execute;
  //check output
  S.LoadFromStream(P.output);
  for i := 0 to S.Count-1 do
  begin
    for j := 0 to 6 do
    begin
     if S[i] = files[j] then check := check +1;
    end;
  end;
  P.Free;
  S.Free;

  //search for more required files
  java_path := FindDefaultExecutablePath('java');
  sudo_path := FindDefaultExecutablePath('sudo');
  adb_path  := FindDefaultExecutablePath('adb');
  {sox_path  := FindDefaultExecutablePath('sox');}//sox removed, because this function is not includet yet
  if check = 7 then result := true
  else result := false;
end;


//procedure which starts the adb daemon
procedure TForm1.start_adb_daemon();
var P : TProcess;
  S : TStringList;
  i : Integer;
begin
  //lets creating the adb process
  P := TProcess.create(nil);
  S := TStringList.create();
  //get path to adb-executable from variable
  P.CommandLine:= adb_path+ ' start-server';
  P.Options:=[poWaitOnExit, poUsePipes];
  P.Execute();
  S.LoadFromStream(P.output);
  write_status_message('[START] adb-daemon');
  //read output from adb-command
  for i:=0 to S.Count-1 do
  begin
   write_status_message(S[i]);
  end;
  adb_started := true;
  P.Free;
  S.Free;

end;


//procedure which stops the adb-daemon
procedure TForm1.stop_adb_daemon();
var P : TProcess;
  S : TStringList;
  i : Integer;
begin
  if adb_started then
  begin
  //lets create the process
  P := TProcess.create(nil);
  S := TStringList.create();
  //get adb_path ffrom variable
  P.CommandLine:=  adb_path + ' kill-server';
  P.Options := [poWaitonExit, poUsePipes];
  P.execute();
  S.LoadFromStream(P.output);
  for i := 0 to S.count-1 do
  begin
   write_status_message(S[i]);
  end;
  P.Free;
  S.Free;

  end
  else;
end;


//procedure which runs the adb pull command
procedure TForm1.adb_pull();
var P : TProcess;
  S : tStringList;
  i : Integer;
  pull_from : String;
begin
{  P := TProcess.create(nil);
  S := TStringList.create();
  InputBox('ertse', 'zweite', pull_from);
 }
end;

end.

