unit mygrids;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, PasLibVlcClassUnit, BGRABitmap, BGRABitmapTypes, LCLProc, contnrs;
type
 { TSongPart }
 TSongType = (Slide, Intro, Verse, PreChorus, Chorus, Bridge, Conclusion, Solo);
 PSong = ^TSong;
 TSong = class(TFPObjectList)
   private
   protected
   commentI: IntegerArray;
   public
   themes, comments: TStrings;
   reseaseDate, modifyDate, copyDate: TDate;
   version: Double;
   ver, lang, copyrighht, key, vOrder: String;
   keywords, lines, authors: TStrings;
   ccliNo, transpo: Integer;
 end;

 TSongPart=class(TObject)
   private
   protected
   public
   ParentSong: PSong;
   FImg, FResImg, FThumb: TBGRABitmap;
   FText, FNote, FPath, FComments: String;
   FIsVideo, First, Last: Boolean;
   FSongType: TSongType;
   constructor create();
   constructor create(ParSong: PSong);
   constructor create(aColor:TBGRAPixel);
   constructor create(aText: string; aNote: string=''; MediaPath: string='');
   constructor create(aImg: TBGRABitmap; MediaPath: String);
   constructor create(aText, aNote, MediaPath: string; aImg: TBGRABitmap);
   destructor  Destroy; override;
end;
implementation

{ TSongPart }

constructor TSongPart.create;
begin
  FImg := TBGRABitmap.Create(1,1, BGRABlack);
  ParentSong := Nil;
  FResImg := Nil;
  FThumb := Nil;
  FNote := '';
  FText := '';
  FIsVideo := False;
  FPath := 'black.png';
end;

constructor TSongPart.create(ParSong: PSong);
begin
  ParentSong := ParSong;
  FImg := TBGRABitmap.Create(1,1, BGRABlack);
  FResImg := Nil;
  FThumb := Nil;
  FNote := '';
  FText := '';
  FIsVideo := False;
  FPath := 'black.png';
end;

constructor TSongPart.create(aImg: TBGRABitmap; MediaPath: String);
begin
  FImg := aImg;
  ParentSong := Nil;
  FThumb := Nil;
  FResImg := Nil;
  FNote := '';
  FText := '';
  FIsVideo := False;
  FPath := MediaPath;
end;

constructor TSongPart.create(aText, aNote, MediaPath: string);
begin
  FImg := TBGRABitmap.Create(1, 1, BGRABlack);
  ParentSong := Nil;
  FThumb := Nil;
  FResImg := Nil;
  FNote := aNote;
  FText := aText;
  FIsVideo := True;
  FPath := MediaPath;
end;

constructor TSongPart.create(aText, aNote, MediaPath: string; aImg: TBGRABitmap);
begin
  FImg := aImg;
  ParentSong := Nil;
  FThumb := Nil;
  FResImg := Nil;
  FNote := aNote;
  FText := aText;
  FIsVideo := False;
  FPath := MediaPath;
end;

constructor TSongPart.create(aColor: TBGRAPixel);
begin
  FImg := TBGRABitmap.Create(1,1, aColor);
  ParentSong := Nil;
  FThumb := Nil;
  FResImg := Nil;
  FNote := '';
  FText := '';
  FIsVideo := False;
  FPath := 'black.png';
end;

destructor TSongPart.Destroy;
begin
  if FImg<>Nil then
    FImg.Free;
  if FResImg<>Nil then
    FResImg.Free;
  if FThumb<>Nil then
    FThumb.Free;
  //Dispose(PSong);
  FNote := '';
  FText := '';
  FIsVideo := False;
  FPath := '';
  Inherited Destroy;
end;

end.

