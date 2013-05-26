unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, ComCtrls, ShellCtrls, process;

type

  { TForm1 }

  TForm1 = class(TForm)
    Label1: TLabel;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    StatusBar1: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    function get_current_directory() : String;
    procedure write_status_message(status : String);
    function check_for_needed_files():boolean;
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
implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.MenuItem1Click(Sender: TObject);
begin

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  write_status_message('----Starting GAPKMAN----');
  write_status_message('->get current directory');
  //save the path in the variable working_directory
  current_directory := get_current_directory();
  //give current directory out per label-component
  Label1.Caption := 'current directory: ' + current_directory;
  write_status_message('-->finished: get current directory');
  //check if all needed files are there
  write_status_message('->check for all needed files in "other" directory (they should be there)');
  if check_for_needed_files() then write_status_message('-->SUCCESS!')
  else write_status_message('ERROR: missing files; please check');
  write_status_message('->check for all needed executables on the computer');
  if (java_path <> '') AND (sudo_path <> '') AND (adb_path <> '') AND (sox_path <> '') then
  begin
    write_status_message(' ->FOUND java at: ' + java_path);
    write_status_message(' ->FOUND sudo at: ' + sudo_path);
    write_status_message(' ->FOUND  adb at: ' + adb_path);
    write_status_message(' ->FOUND  sox at: ' + sox_path);
    write_status_message('-->all executables found!');
  end
  else
  begin
    write_status_message('-->ERROR: missing executables; please check!');
  end;
  write_status_message('GAPKMAN ready');
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
  sox_path  := FindDefaultExecutablePath('sox');
  if check = 7 then result := true
  else result := false;
end;

end.

