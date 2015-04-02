unit Projector;

{$mode objfpc}{$H+}

interface

uses
  {$ifdef unix} cthreads, {$endif}cmem, heaptrc, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  Data, settings, BGRABitmap, BGRABitmapTypes, BGRATextFX,  BGRAGradients, PasLibVlcPlayerUnit;

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
  Wordbreak:=true;
  Alignment:=taCenter;
  Layout:=tlCenter;
  end;
  OutColor:=BGRAWhite;
  frmProjector.BoundsRect:=MonitorPro.BoundsRect;
  //{$ifdef WINDOWS}
  WindowState:=wsFullScreen;
  //{$EndIf}
end;

procedure TfrmProjector.FormPaint(Sender: TObject);
var
  SlideBitmap: TBGRABitmap;
  teststr: String;
  renderer1: TBGRATextEffectFontRenderer;
 // shader: TPhongShading;
  //x, y: Integer;
begin
  SlideBitmap:=TBGRABitmap.Create(MonitorPro.Width, MonitorPro.Height, BGRABlack);
 // shader:=TPhongShading.Create;
  renderer1:=TBGRATextEffectFontRenderer.Create({shader, True});

  SlideBitmap.FontRenderer:=renderer1;
  renderer1.ShadowVisible := True;
  renderer1.OutlineVisible:=True;
  renderer1.OutlineColor:=OutColor;
  renderer1.OutlineWidth:=TextOutline;
  renderer1.FontEmHeight:=FrmSettings.SlideFont.Font.Size;
  //BGRAGraphicControl1.Bitmap.;
  //if (Form1.Grid.RowCount-1) > CurrentSlide then
    teststr:=Form1.Grid.SlideText[1,(CurrentSlide)];

  SlideBitmap.FontName := FrmSettings.SlideFont.Font.Name;
  SlideBitmap.FontFullHeight := FrmSettings.SlideFont.Font.Size;
  SlideBitmap.FontAntialias := True;
  SlideBitmap.FontQuality := fqFineAntialiasing;
  //if (Form1.Grid.RowCount-1) > CurrentSlide then
    //begin
    SlideBitmap.PutImage(0, 0, Form1.Grid.SlideImage[1, CurrentSlide].Img, dmSet);
    //CurrentSlide := 1;
    //end;
  //AColor:=BGRAWhite;
  //y:= (Monitor.Height - AHeight[CurrentSlide]) div 2;
  //x:= (Monitor.Width - AWidth[CurrentSlide])div 2;

  //with renderer1 do
  //begin


  //renderer1.FontName:=FrmSettings.SlideFont.Font.Name;



  //end;

  SlideBitmap.TextRect(ClientRect, 0, 0, teststr, TextStyle, AColor);
  //SlideBitmap.TextOut(50, 50, teststr, AColor);
  SlideBitmap.Draw(Canvas, 0, 0, True);
  SlideBitmap.Free;

end;


end.

