unit resize1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LCLProc, BGRABitmap, BGRABitmapTypes;

  function ResizeImage(bitm: TBGRABitmap; width, height: Integer; KeepBitmapSize: Boolean = True; Center: Boolean = True): TBGRABitmap;

implementation

function ResizeImage(bitm: TBGRABitmap; width, height: Integer;
  KeepBitmapSize: Boolean; Center: Boolean): TBGRABitmap;
var
  newwidth, newheight: integer;
  centerbgra, resbgra: TBGRABitmap;
begin
  newwidth:=0;
  newheight:=0;
  centerbgra:=Nil;
  resbgra:=Nil;
  if (bitm.Height <> Height) or ( bitm.Width <> Width) then
    begin
      newwidth:=Width;
      if (round((bitm.Height / bitm.Width)*newwidth)) <= Height then
        begin
        newheight:= round((bitm.Height / bitm.Width)*newwidth);

        end
      else
        begin
          newheight:=Height;

          newwidth:= round((bitm.Width / bitm.Height)*newheight)
        end

    end
  else
    begin
      newheight:=Height;
      newwidth:=Width

    end;
  if KeepBitmapSize = False then
    begin
      centerbgra:=TBGRABitmap.Create(newwidth, newheight, BGRABlack);
      center:=False;
    end
  else
    centerbgra:=TBGRABitmap.Create(width, height, BGRABlack);
  if center then
    begin
      centerbgra.PutImage((width-newwidth) div 2, (height-newheight) div 2, bitm.Resample(newwidth, newheight), dmSet);
      resbgra:=centerbgra;
      centerbgra:=Nil;
      Result:=TBGRABitmap(resbgra.Duplicate(True));
    end
  else
    begin
      centerbgra.PutImage(0, 0, bitm.Resample(newwidth, newheight), dmSet);
      resbgra:=centerbgra;
      centerbgra:=Nil;

      Result:=TBGRABitmap(resbgra.Duplicate(True))
    end;
    FreeThenNil(resbgra);
end;

end.

