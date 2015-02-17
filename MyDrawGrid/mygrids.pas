unit mygrids;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, PasLibVlcClassUnit, BGRABitmap, BGRABitmapTypes, LCLProc;
type
  Slide = record
    Img: TBGRABitmap;
    Text, Note, video, ImgPath: String;
    IsVideo: Boolean;
  end;
  image1 = record
    Img: TBGRABitmap;
    ImgPath: String;
  end;

 { TSlide }

 TSlide=class
   private
   protected
   FSlide: Slide;
   public
   constructor create(); //override;
   constructor create(aImg: TBGRABitmap; Path: String); //override;
   //constructor create(aText: string; aNote: string=''); //override
   constructor create(aText: string; aNote: string=' '; aVideo: string=''); //override
   constructor create(aText, aNote, Path: string; aImg: TBGRABitmap); //override;
   constructor create(aText, aNote, aVideo, Path: string; aImg: TBGRABitmap);// override;
   constructor create(aColor:TBGRAPixel); //override;
   destructor  Destroy; override;

   property Text: string read FSlide.Text write FSlide.Text;
   property Note: String read FSlide.Note write FSlide.Note;
   property IsVideo: Boolean read FSlide.IsVideo write FSlide.IsVideo;
   property Video: String read FSlide.Video write FSlide.Video;
   property Image: TBGRABitmap read FSlide.Img write FSlide.Img;
   property ImgPath: String read FSlide.ImgPath write FSlide.ImgPath;

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
    ImgPath := 'black.png';
    end;
end;

constructor TSlide.create(aImg: TBGRABitmap; Path: String);
begin
  inherited create;
    with FSlide do
    begin
    Img:=aImg;
    Note:=' ';
    Text:=' ';
    isvideo:=False;
    video:=' ';
    ImgPath := Path;
    end;
end;

{constructor TSlide.create(aText:string; aNote: string);
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
end; }

constructor TSlide.create(aText, aNote, aVideo: string);
begin
  inherited create;
  with FSlide do
  begin
  Img:=TBGRABitmap.Create(1, 1, BGRABlack);
  Note:=aNote;
  Text:=aText;
  isvideo:=False;
  video:=aVideo;
  ImgPath := ' ';
  end;
end;

constructor TSlide.create(aText, aNote, Path: string; aImg: TBGRABitmap);
begin
  inherited create;
  with FSlide do
  begin
  Img:=aImg;
  Note:=aNote;
  Text:=aText;
  isvideo:=False;
  video:=' ';
  ImgPath := Path;
  end;
end;

constructor TSlide.create(aText, aNote, aVideo, Path: string; aImg: TBGRABitmap);
begin
  inherited create;
  with FSlide do
  begin
  Img:=aImg;
  Note:=aNote;
  Text:=aText;
  isvideo:=True;
  video:=aVideo;
  ImgPath := Path;
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
    ImgPath := 'black.png';
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
  ImgPath := ' ';
  end;

end;

end.

