unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ActnList, StdCtrls, data_hub, MyDrawGrid;

type

  { TForm1 }

  TForm1 = class(TForm)
    ActionList1: TActionList;
    Editable: TAction;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    Grid: TMyDrawGrid;
    TAAbout: TAction;
    TAClose: TAction;
    TAExit: TAction;
    TANext: TAction;
    TAOpen: TAction;
    TAOpenScript: TAction;
    TAPrevious: TAction;
    TASave: TAction;
    TASaveAs: TAction;
    procedure TAAboutExecute(Sender: TObject);
    procedure TAExitExecute(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.TAExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TForm1.TAAboutExecute(Sender: TObject);
begin
  About();
end;

end.

