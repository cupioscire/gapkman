unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, process;

type

  { TForm1 }

  TForm1 = class(TForm)
    Label1: TLabel;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    function get_current_directory() : String;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  current_directory : String; //viariable which gets the name of the current directory to access the required componnents

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.MenuItem1Click(Sender: TObject);
begin

end;

procedure TForm1.FormCreate(Sender: TObject);

begin
  //save the path in the variable working_directory
  current_directory := get_current_directory();
  //give current directory out per label-component
  Label1.Caption := 'current directory: ' + current_directory;
end;



//function which gets the path of the current directory
function TForm1.get_current_directory() : String;
var P : TProcess;
  S : TStringList;
begin
   //create new process
  P := TProcess.Create(nil);
  //create new stringlist
  S := TStringlist.Create;
  //process run pwd command(linux)
  P.CommandLine := 'pwd';
  //process saves output of pwd in a stream and we will wait until pwd has finished
  P.Options := [poWaitOnExit, poUsePipes];
  //execute pwd process
  P.Execute;
  //loading output of pwd from output-stream
  S.LoadFromStream(P.Output);
  //S as stringlist should only have one string in it.
  //thats the path of our current directory
  result := S[0];
end;

end.

