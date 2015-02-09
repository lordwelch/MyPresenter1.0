unit Projector;

{$mode objfpc}{$H+}

interface

uses
  cmem, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  Data, settings, BGRABitmap, BGRABitmapTypes, BGRATextFX, PasLibVlcPlayerUnit;

type

  { TfrmProjector }

  TfrmProjector = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmProjector: TfrmProjector;
  renderer: TBGRATextEffectFontRenderer;

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
  teststr: String;
  //x, y: Integer;
begin
  with renderer do
  begin
  renderer:=TBGRATextEffectFontRenderer.Create;
  OutlineWidth:=TextOutline;
  renderer.FontName:=FrmSettings.SlideFont.Font;

  end;




  //BGRAGraphicControl1.Bitmap.;
  teststr:=Form1.Grid.SlideText[1,(CurrentSlide)];
  SlideBitmap:=TBGRABitmap.Create(MonitorPro.Width, MonitorPro.Height, BGRABlack);
  SlideBitmap.PutImage(0, 0, form1.Grid.CellImage[1, CurrentSlide], dmSet);
  //AColor:=BGRAWhite;
  //y:= (Monitor.Height - AHeight[CurrentSlide]) div 2;
  //x:= (Monitor.Width - AWidth[CurrentSlide])div 2;

  SlideBitmap.TextRect(ClientRect, 0, 0, teststr, TextStyle, AColor);
  //SlideBitmap.TextOut(50, 50, teststr, AColor);
  SlideBitmap.Draw(Canvas, 0, 0, True);
  SlideBitmap.Free;

end;

end.
