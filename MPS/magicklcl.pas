unit magicklcl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics;

procedure LoadMagickBitmap(FileName: string; Bmp: TBitmap); overload;
procedure LoadMagickBitmap(Strm: TMemoryStream; Bmp: TBitmap); overload;

implementation

uses magick_wand, ImageMagick, IntfGraphics, FPimage, LazUTF8;

procedure LoadMagickBitmapWand(Wand: PMagickWand; Bmp: TBitmap);
var
  img: Pimage;
  pack: PPixelPacket;
  limg: TLazIntfImage;
  i, j, wi, he: integer;
  colo: TFPColor;
begin
  img := GetImageFromMagickWand(wand);
  he := MagickGetImageHeight(wand);
  wi := MagickGetImageWidth(wand);
  limg := TLazIntfImage.Create(0, 0);
  try
    limg.DataDescription := GetDescriptionFromDevice(0, wi, he);
    pack := GetAuthenticPixels(img, 0, 0, wi, he, nil);
    for j := 0 to he - 1 do
      for i := 0 to wi - 1 do
      begin
        colo.red := pack^.red;
        colo.green := pack^.green;
        colo.blue := pack^.blue;
        colo.alpha := pack^.opacity;
        limg.Colors[i, j] := colo;
        Inc(pack);
      end;
    Bmp.LoadFromIntfImage(limg);
  finally
    limg.Free;
  end;
end;

procedure LoadMagickBitmap(FileName: string; Bmp: TBitmap);
var
  wand: PMagickWand;
  status: MagickBooleanType;
  description: PChar;
  severity: ExceptionType;
begin
  wand := NewMagickWand;
  try
    status := MagickReadImage(wand, PChar(UTF8ToSys(FileName)));
    if (status = MagickFalse) then
    begin
      description := MagickGetException(wand, @severity);
      raise Exception.Create(Format('An error ocurred. Description: %s',
        [description]));
      description := MagickRelinquishMemory(description);
    end else LoadMagickBitmapWand(wand, Bmp);
  finally
    wand := DestroyMagickWand(wand);
  end;
end;

procedure LoadMagickBitmap(Strm: TMemoryStream; Bmp: TBitmap);
var
  wand: PMagickWand;
  status: MagickBooleanType;
  description: PChar;
  severity: ExceptionType;
begin
  wand := NewMagickWand;
  try
    Strm.Position := 0;
    status := MagickReadImageBlob(wand, Strm.Memory, Strm.Size);
    if (status = MagickFalse) then
    begin
      description := MagickGetException(wand, @severity);
      raise Exception.Create(Format('An error ocurred. Description: %s',
        [description]));
      description := MagickRelinquishMemory(description);
    end else LoadMagickBitmapWand(wand, Bmp);
  finally
    wand := DestroyMagickWand(wand);
  end;
end;

initialization
  MagickWandGenesis;

finalization;
  MagickWandTerminus;

end.
