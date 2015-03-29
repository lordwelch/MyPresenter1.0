unit thread;

{$mode objfpc}{$H+}

interface

uses
  {$ifdef unix} cthreads, {$endif}Classes, SysUtils, BGRABitmap, BGRABitmapTypes, mygrids, resize;
type

  { myThread }

  myThread=class(TThread)
    private
      LoadBGRA, list1, list2{, list3}: TBGRABitmap;
      img, img1: image1;
      List: TStringList;
      gridint, x, y, xwidth, yheight: Integer;
      str1: String;
      //procedure updateForm;
      procedure GetStrings;
      procedure GetGridInt;
      procedure SetImage;
      procedure done;
    protected
      procedure Execute; override;
      procedure DoTerminate; override;
    public
      freeing:Boolean;
      constructor Create(CreateSuspended: Boolean; const StackSize: SizeUInt =
        DefaultStackSize);
  end;

implementation
uses
  main_code, Data;

{ myThread }

{procedure myThread.updateForm;
begin

end; }

procedure myThread.GetStrings;
var i: Integer;
begin
  {$IFDEF UNIX} writeln('GetStrings'); {$ENDIF}
  for i := 0 to sttr.Count-1 do
    List.Append(sttr.Strings[i]);
  {$IFDEF UNIX} writeln('GetGridInt'); {$ENDIF}
  gridint:=Length(GridImageList[0]);
  SetLength(GridImageList, 3, sttr.Count-1+gridint);
  x := 1024 div 2;//Form1.Grid.Columns[1].Width;
  y := 768 div 2;//Form1.Grid.RowHeights[1];
  xwidth := MonitorPro.Width;
  yheight := MonitorPro.Height;
end;

procedure myThread.GetGridInt;
begin

end;

procedure myThread.SetImage;
begin
  {$IFDEF UNIX} writeln('SetImage'); {$ENDIF}
  GridImageList[0, gridint-1]:=TBGRABitmap(LoadBGRA.Duplicate(True));
  GridImageList[1, gridint-1]:=img.Img;
  GridImageList[2, gridint-1]:=img1.Img;

  Form1.Grid.InsertColRow(False, Form1.Grid.RowCount);
  Form1.Grid.SlideImage[1, Form1.Grid.RowCount-1] := img;

  Form1.Grid.SlideImage[2, Form1.Grid.RowCount-1] := img1;
  ImagePath.Add(str1);
  gridint+=1;

end;

procedure myThread.done;
begin

end;

procedure myThread.Execute;
var
  i: Integer;
  //List: TStringList;

begin
  LoadBGRA:=Nil;
  list1:=Nil;
  list2:=Nil;
  img.Img:=Nil;
  img1.Img:=Nil;
  List:=Nil;
  if not freeing then
  begin
  writeln('thread start');
  writeln(freeing);
  if List <> Nil then List.Free;
  List:= TStringList.Create;
  Synchronize(@GetStrings);

  //Synchronize(@GetGridInt);
  for i := 0 to (List.Count - 1) do
    begin
  str1 := List.Strings[i];
  if str1<>'' then
    begin
      try
        list1:= TBGRABitmap.Create(xwidth, yheight, BGRABlack);
        list2:= TBGRABitmap.Create(x, y, BGRABlack);
        {$IFDEF UNIX} writeln('test'); {$ENDIF}
        LoadBGRA:=TBGRABitmap.Create(str1);
        //frmlog.memo1.Append(str1);
        list1.PutImage(0, 0, ResizeImage(LoadBGRA, xwidth, yheight), dmSet);
        WriteLn('crap');
        list2.PutImage(0, 0, ResizeImage(LoadBGRA, x, y, false, false), dmSet);


        img.Img:=TBGRABitmap(list1.Duplicate(True));
        img.ImgPath := str1;

        img1.img:=TBGRABitmap(list2.Duplicate(True));
        img1.ImgPath:=str1;


      Synchronize(@SetImage);
      finally
      list1.Free;
      list2.Free;
      LoadBGRA.Free;
      end;
    end;
    end;
  FreeAndNil(List);
  Synchronize(@done);
  writeln(freeing);
  end;
end;

procedure myThread.DoTerminate;
begin
  {$IFDEF UNIX} writeln(freeing);
  writeln('Terminate'); {$ENDIF}
  inherited DoTerminate;
  thread1 := False;

end;

constructor myThread.Create(CreateSuspended: Boolean; const StackSize: SizeUInt
  );
begin
  inherited Create(CreateSuspended, StackSize);
  freeing := False;
  FreeOnTerminate := True;
end;

end.

