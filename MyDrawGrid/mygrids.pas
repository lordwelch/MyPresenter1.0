unit mygrids;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, PasLibVlcClassUnit, BGRABitmap, BGRABitmapTypes, LCLProc;
type
  Slide = record
    Img: TBGRABitmap;
    Text,Note: String;
    IsVideo: Boolean;
    Video: WideString;
  end;

 { TSlide }

 TSlide=class
   private
   protected
   FSlide: Slide;
   public
   constructor create(); //override;
   constructor create(aImg: TBGRABitmap); //override;
   constructor create(aText: string; aNote: string=''); //override
   constructor create(aText, aNote: string; aVideo: string=''); //override
   constructor create(aText, aNote: string; aImg: TBGRABitmap); //override;
   constructor create(aText, aNote, aVideo: string; aImg: TBGRABitmap);// override;
   constructor create(aColor:TBGRAPixel); //override;
   destructor  Destroy; override;

   property Text: string read FSlide.Text write FSlide.Text;
   property Note: String read FSlide.Note write FSlide.Note;
   property IsVideo: Boolean read FSlide.IsVideo write FSlide.IsVideo;
   property Video: WideString read FSlide.Video write FSlide.Video;
   property Image: TBGRABitmap read FSlide.Img write FSlide.Img;

end;
implementation

{ TSlide }

constructor TSlide.create;
begin
  inherited create;
    with FSlide do
    begin
    Img:=TBGRABitmap.Create(1,1);
    Note:=' ';
    Text:=' ';
    isvideo:=False;
    video:=' ';
    end;
end;

constructor TSlide.create(aImg: TBGRABitmap);
begin
  inherited create;
    with FSlide do
    begin
    Img:=aImg;
    Note:=' ';
    Text:=' ';
    isvideo:=False;
    video:=' ';
    end;
end;

constructor TSlide.create(aText:string; aNote: string);
begin
  inherited create;
  with FSlide do
  begin
  Img:=TBGRABitmap.Create(1, 1, BGRABlack);
  Note:=aNote;
  Text:=aText;
  isvideo:=False;
  video:=' ';
  end;
end;

constructor TSlide.create(aText, aNote, aVideo: string);
begin

end;

constructor TSlide.create(aText, aNote: string; aImg: TBGRABitmap);
begin
  inherited create;
  with FSlide do
  begin
  Img:=aImg;
  Note:=aNote;
  Text:=aText;
  isvideo:=False;
  video:=' ';
  end;
end;

constructor TSlide.create(aText, aNote, aVideo: string; aImg: TBGRABitmap);
begin
  inherited create;
  with FSlide do
  begin
  Img:=aImg;
  Note:=aNote;
  Text:=aText;
  isvideo:=True;
  video:=aVideo;
  end;
end;

constructor TSlide.create(aColor: TBGRAPixel);
begin
  inherited create;
    with FSlide do
    begin
    Img:=TBGRABitmap.Create(1,1, aColor);
    Note:=' ';
    Text:=' ';
    isvideo:=False;
    video:=' ';
    end;
end;

destructor TSlide.Destroy;
begin
  inherited Destroy;
  with FSlide do
  begin
  img.Free;
  Note:=' ';
  Text:=' ';
  isvideo:=False;
  video:=' ';
  end;

end;

end.

