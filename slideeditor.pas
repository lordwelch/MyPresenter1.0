unit slideeditor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  MyDrawGrid;

type

  { TfrmSlideEditor }

  TfrmSlideEditor = class(TForm)
    MyDrawGrid1: TMyDrawGrid;
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmSlideEditor: TfrmSlideEditor;

implementation
uses main_code;

{ TfrmSlideEditor }

procedure TfrmSlideEditor.FormShow(Sender: TObject);
begin
  MyDrawGrid1:=Form1.Grid;
end;

initialization
  {$I slideeditor.lrs}

end.

