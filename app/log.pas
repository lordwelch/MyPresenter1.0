unit log;

{$mode objfpc}{$H+}

interface

uses
  {$ifdef unix} cthreads, {$endif} heaptrc, Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Data;

type

  { TfrmLog }

  TfrmLog = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmLog: TfrmLog;

implementation

{ TfrmLog }

procedure TfrmLog.FormShow(Sender: TObject);
begin
  Memo1.VertScrollBar.Tracking:=True;
  Memo1.Lines:=strlog;
end;

initialization
  {$I log.lrs}

end.

