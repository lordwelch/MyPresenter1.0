unit log;

{$mode objfpc}{$H+}

interface

uses
  {$ifdef unix} cthreads, {$endif}Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Data;

type

  { TfrmLog }

  TfrmLog = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    procedure FormDestroy(Sender: TObject);
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
  //strlog.;
end;

procedure TfrmLog.FormDestroy(Sender: TObject);
begin
  strlog.Free;
end;

initialization
  {$I log.lrs}

end.

