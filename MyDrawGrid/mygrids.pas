unit mygrids;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, PasLibVlcClassUnit, BGRABitmap, BGRABitmapTypes, LCLProc;
type
 { TSlide }

 TSlide=class(TObject)
   private
   protected
   public
   Img: TBGRABitmap;
   Text, Note, Path: String;
   IsVideo: Boolean;
   constructor create();
   constructor create(aColor:TBGRAPixel);
   constructor create(aText: string; aNote: string=''; MediaPath: string='');
   constructor create(aImg: TBGRABitmap; MediaPath: String);
   constructor create(aText, aNote, MediaPath: string; aImg: TBGRABitmap);
   destructor  Destroy; override;
end;
implementation

{ TSlide }

constructor TSlide.create;
begin
    Img:=TBGRABitmap.Create(1,1, BGRABlack);
    Note:='';
    Text:='';
    isvideo:=False;
    Path := 'black.png';
end;

constructor TSlide.create(aImg: TBGRABitmap; MediaPath: String);
begin
    Img:=aImg;
    Note:='';
    Text:='';
    isvideo:=False;
    Path := MediaPath;
end;

constructor TSlide.create(aText, aNote, MediaPath: string);
begin
  Img:=TBGRABitmap.Create(1, 1, BGRABlack);
  Note:=aNote;
  Text:=aText;
  isvideo:=True;
  Path := MediaPath;
end;

constructor TSlide.create(aText, aNote, MediaPath: string; aImg: TBGRABitmap);
begin
  Img:=aImg;
  Note:=aNote;
  Text:=aText;
  isvideo:=False;
  Path := MediaPath;
end;

constructor TSlide.create(aColor: TBGRAPixel);
begin
  Img:=TBGRABitmap.Create(1,1, aColor);
  Note:='';
  Text:='';
  isvideo:=False;
  Path := 'black.png';
end;

destructor TSlide.Destroy;
begin
  img.Free;
  Note:='';
  Text:='';
  isvideo:=False;
  Path := '';
  Inherited Destroy;
end;

end.

