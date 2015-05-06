unit resize;

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
        //DebugLn('resize: Height: '+IntToStr(newheight))
        end
      else
        begin
          newheight:=Height;
          //DebugLn('resize: Height: '+IntToStr(newheight));
          newwidth:= round((bitm.Width / bitm.Height)*newheight)
        end
      //DebugLn('height: '+IntToStr(bitm.Height) + ' width: ' + IntToStr(bitm.Width));
      //DebugLn('height: '+IntToStr(newheight) + ' width: ' + IntToStr(newwidth));
    end
  else
    begin
      newheight:=Height;
      newwidth:=Width
      //DebugLn('resize: Height: '+IntToStr(newheight))
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
      //DebugLn('true');
      //DebugLn('Height: '+IntToStr(height));
      //DebugLn('Width : '+IntToStr(width));
      //DebugLn('resize: Height: '+IntToStr(newheight));
      //DebugLn('resize: Width : '+IntToStr(newwidth));
      //DebugLn('y : '+IntToStr(height-newheight));
      //DebugLn('x : '+IntToStr(width-newwidth));
      centerbgra.PutImage((width-newwidth) div 2, (height-newheight) div 2, bitm.Resample(newwidth, newheight), dmSet);
      resbgra:=centerbgra;
      centerbgra:=Nil;
      //DebugLn('Height: '+IntToStr(resbgra.Height));
      //DebugLn('Width : '+IntToStr(resbgra.Width));
      //FreeThenNil(bitm);
      Result:=resbgra
    end
  else
    begin
      //DebugLn('false');
      //DebugLn('Height: '+IntToStr(height));
      //DebugLn('Width : '+IntToStr(width));
      //DebugLn('resize: Height: '+IntToStr(newheight));
      //DebugLn('resize: Width : '+IntToStr(newwidth));
      centerbgra.PutImage(0, 0, bitm.Resample(newwidth, newheight), dmSet);
      resbgra:=centerbgra;
      centerbgra:=Nil;
      //DebugLn('Height: '+IntToStr(resbgra.Height));
      //DebugLn('Width : '+IntToStr(resbgra.Width));
      //FreeThenNil(bitm);
      Result:=resbgra
    end;
end;

end.

