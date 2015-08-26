unit data;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BGRABitmap, BGRABitmapTypes, Graphics, {%H-}resize1, Forms,
  Dialogs, magicklcl, mygrids, song;

var
  currImage: TBGRABitmap;
  currSlideIndex, slideIndex, monWidth, monHeight, monNum: Integer;
  newMon: Boolean;
  mon: TMonitor;
  monRect: TRect;
  currText, Supportedimages: String;
  SupportedImageList: TStringList;
  textStyle: TTextStyle;
  AColor: TBGRAPixel;


procedure init();
procedure SetMonitors();
procedure LoadSupportedImages();
procedure OpenImageDialog();
procedure AddImage(FileName:String; Song: Boolean = False);
procedure AddSlide(sld: TSongPart);
procedure setSlide(i: Integer);
procedure showProjection();
procedure showSong();
procedure saveSong();

implementation
uses main, projection;

procedure init;
begin
  SetMonitors();
  with textStyle do
  begin
    Alignment := taCenter;
    Layout := tlCenter;
    SingleLine := False;
    Clipping := False;
    ExpandTabs := True;
    ShowPrefix := True;
    Wordbreak := True;
    Opaque := False;
    SystemFont  := False;
    RightToLeft := False;
    EndEllipsis := False;
  end;
  SupportedImageList := TStringList.Create;
  LoadSupportedImages();
  frmProjection.currProjection := Nil;
  setSlide(0);
  currSlideIndex := 0;
  slideIndex := 0;
  currText := '';
  AColor := BGRAWhite;
  currImage := TBGRABitmap.Create(500, 500, BGRABlack);

end;

procedure SetMonitors;
var Monitors: Integer;
begin
  Screen.UpdateMonitors;
  Screen.UpdateScreen;
  monNum := Screen.MonitorCount;
  if monNum > 1 then
    Monitors := StrToInt(InputBox('Monitor selection', 'please select a monitor: (1-' + IntToStr(monNum)+')', '2'))
  else
    begin
    ShowMessage('No second monitor!!! :-(');
    Monitors := 1
    end;
  mon := Screen.Monitors[Monitors-1];
  monWidth := mon.Width;
  monHeight := mon.Height;
  monRect := mon.BoundsRect;
  frmProjection.BoundsRect := monRect;
  Form1.IGrid.ResizeSlideList(monWidth, monHeight)
end;

procedure LoadSupportedImages;
var
  i: Integer;
  str1: String;
begin
  //DialogOptions += [ofAllowMultiSelect];
  //form1.OpenDialog1.Options := DialogOptions;

  SupportedImageList.Duplicates := dupIgnore;
  with SupportedImageList do
  begin
    Add( '.jpg' );
    Add( '.jpeg');
    Add( '.png' );
    Add( '.gif' );
    Add( '.pcx' );
    Add( '.bmp' );
    Add( '.ico' );
    Add( '.cur' );
    Add( '.pdn' );
    Add( '.lzp' );
    Add( '.ora' );
    Add( '.psd' );
    Add( '.tga' );
    Add( '.tif' );
    Add( '.tiff');
    Add( '.xwd' );
    Add( '.xpm' );
  end;
  str1 := 'Supported Images|*.jpg';
  for i :=  1 to (SupportedImageList.Count-1) do
    str1+=';*.'+SupportedImageList.Strings[i];
  Supportedimages := str1;
  SupportedImageList.Sort;
end;

procedure OpenImageDialog;
begin
  with Form1 do
  begin
    OpenImgDialog.Filter := Supportedimages;
    if OpenImgDialog.Execute then
      AddImage(OpenImgDialog.FileName);
  end;
end;

procedure AddImage(FileName:String; Song: Boolean);
var
  TempBmp:TBitmap;
  TTempBmp: TBGRABitmap;
  i: Integer;
begin
  TempBmp := Nil;
  TempBmp := TBitmap.Create;
  magicklcl.LoadMagickBitmap(FileName, TempBmp);
  //Form1.Memo2.Append(IntToStr(TempBmp.Height));
  //Form1.Memo2.Append(IntToStr(TempBmp.Width));
  with Form1.IGrid do
  begin
    i := RowCount;
    //Form1.Memo2.Append(IntToStr(i));
    InsertColRow(False, i);
    TTempBmp := TBGRABitmap.Create(TempBmp);
    SlideFullImage[i] := TTempBmp;
    ResizeSlide(monWidth, monHeight, i);
    TTempBmp := Nil;
  end;
end;

procedure AddSlide(sld: TSongPart);
var newrow: Integer;
begin
  newrow:=Form1.IGrid.RowCount;
  Form1.IGrid.InsertColRow(False, newrow);
  Form1.IGrid.Cells[newrow]:=sld;
  Form1.IGrid.ResizeSlide(monWidth,monHeight,newrow);
  Form1.IGrid.Invalidate;
  Form1.Memo2.Append(Form1.IGrid.SlideText[newrow]);
end;

procedure setSlide(i:Integer);
var bmp1: TBGRABitmap;
begin
  slideIndex := i;
  if (slideIndex<1) then
    slideIndex := 1;
  if (slideIndex>Form1.IGrid.RowCount-1) then
    slideIndex := Form1.IGrid.RowCount-1;

  currText := Form1.IGrid.SlideText[slideIndex];


  if (currSlideIndex <> slideIndex) then
  begin
    bmp1 := TBGRABitmap(Form1.IGrid.SlideImage[slideIndex].Duplicate());
    if bmp1 <> Nil then
      begin
      if currImage<>Nil then
        FreeAndNil(currImage);
      currImage := bmp1;
      bmp1 := Nil;
      end;
  end;

  with frmProjection do
  begin
    if currProjection<>Nil then
      FreeAndNil(currProjection);
    currImage.FontHeight := 45;
    currImage.TextRect(Rect(0, 0, monWidth, monHeight), 0, 0, (currText{+IntToStr(i)}), textStyle, AColor);
    currProjection := TBGRABitmap(currImage.Duplicate(True));
    Invalidate;
  end;
  currSlideIndex := slideIndex;
end;

procedure showProjection;
begin
  frmProjection.Show;
end;

procedure showSong;
begin
  frmSong.Show;
end;

procedure saveSong;
begin

end;

end.

