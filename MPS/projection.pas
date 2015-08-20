unit projection;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, BGRABitmap, data;

type

  { TfrmProjection }

  TfrmProjection = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    currProjection: TBGRABitmap;
  end;

var
  frmProjection: TfrmProjection;

implementation

{$R *.lfm}

{ TfrmProjection }

procedure TfrmProjection.FormCreate(Sender: TObject);
begin
  Init;
end;

procedure TfrmProjection.FormPaint(Sender: TObject);
//var bmp: TBGRABitmap;
begin
  if currProjection<>Nil then
    begin
      currProjection.Draw(Canvas, 0, 0, True)
    end;
end;

end.

