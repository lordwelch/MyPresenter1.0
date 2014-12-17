unit Projector;

{$mode objfpc}{$H+}

interface

uses
  cmem, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Data,
  BGRABitmap, BGRABitmapTypes, BGRAGraphicControl;

type

  { TfrmProjector }

  TfrmProjector = class(TForm)
    BGRAGraphicControl1: TBGRAGraphicControl;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmProjector: TfrmProjector;

implementation
  uses main_code;

{$R *.lfm}

{ TfrmProjector }

procedure TfrmProjector.FormCreate(Sender: TObject);
begin
  with TextStyle do
  begin
  SingleLine:=false;
  ShowPrefix:=true;
  Wordbreak:=false;
  Alignment:=taCenter;
  Layout:=tlCenter;
  end;
  frmProjector.BoundsRect:=MonitorPro.BoundsRect;
  {$ifdef WINDOWS}
  WindowState:=wsMaximized;
  {$EndIf}
end;

procedure TfrmProjector.FormPaint(Sender: TObject);
var
  SlideBitmap: TBGRABitmap;
  bitmap1: TBitmap;
  //x, y: Integer;
begin
  bitmap1:=TBitmap.Create;
  GridImageList.GetBitmap(CurrentSlide, bitmap1);
  SlideBitmap:=TBGRABitmap.Create(bitmap1);
  AColor:=BGRAWhite;
  //y:= (Monitor.Height - AHeight[CurrentSlide]) div 2;
  //x:= (Monitor.Width - AWidth[CurrentSlide])div 2;

  BGRAGraphicControl1.Bitmap.PutImage(0,0,SlideBitmap, dmset);
  BGRAGraphicControl1.Bitmap.TextRect(frmProjector.BoundsRect, 0, 0, Form1.Grid.Cells[1,(CurrentSlide+1)], TextStyle, AColor);
  //SlideBitmap.Draw(BGRAGraphicControl1.Canvas, 0, 0);
  SlideBitmap.Free;
  bitmap1.Free;
end;

end.
