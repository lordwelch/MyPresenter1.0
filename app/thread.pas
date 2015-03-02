unit thread;

{$mode objfpc}{$H+}

interface

uses
  {$ifdef unix} cthreads, {$endif}Classes, SysUtils, BGRABitmap, mygrids, resize, LCLProc;
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
  debugln('GetStrings');
  for i := 0 to sttr.Count-1 do
    List.Append(sttr.Strings[i]);
end;

procedure myThread.GetGridInt;
begin
  debugln('GetGridInt');
  gridint:=Length(GridImageList[0]);
  SetLength(GridImageList, 3, 1+gridint);
  x := Form1.Grid.Columns[1].Width;
  y := Form1.Grid.RowHeights[1];
  xwidth := MonitorPro.Width;
  yheight := MonitorPro.Height;
end;

procedure myThread.SetImage;
begin
  debugln('SetImage');
  GridImageList[0, gridint]:=TBGRABitmap(LoadBGRA.Duplicate(True));
  GridImageList[1, gridint]:=img.Img;
  GridImageList[2, gridint]:=img1.Img;

  Form1.Grid.InsertColRow(False, Form1.Grid.RowCount);
  Form1.Grid.SlideImage[1, Form1.Grid.RowCount-1]:=img;

  Form1.Grid.SlideImage[2, Form1.Grid.RowCount-1] := img1;
  ImagePath.Add(str1);

end;

procedure myThread.done;
begin
  thread1 := False;
end;

procedure myThread.Execute;
var
  i: Integer;
  //List: TStringList;

begin
  //debugln(freeing);
  if not freeing then
  begin
  //debugln(freeing);
  if List <> nil then List.Free;
  List:= TStringList.Create;
  Synchronize(@GetStrings);


  for i := 0 to (List.Count - 1) do
    begin
  str1 := List.Strings[i];
  if str1<>'' then
    begin
      try
        Synchronize(@GetGridInt);

        LoadBGRA:=TBGRABitmap.Create(str1);
        //frmlog.memo1.Append(str1);
        list1 := ResizeImage(LoadBGRA, xwidth, yheight);
        list2 := ResizeImage(LoadBGRA, x, y, false, false);


        img.Img:=TBGRABitmap(list1.Duplicate(True));
        img.ImgPath := str1;

        img1.img:=TBGRABitmap(list2.Duplicate(True));
        img1.ImgPath:=str1;


      Synchronize(@SetImage);
      finally
      LoadBGRA.Free;
      list1.Free;
      list2.Free;
      Synchronize(@done);
      end;
    end;
    end;
  end;
  //debugln(freeing);
end;

procedure myThread.DoTerminate;
begin
  //debugln(freeing);
  debugln('Terminate');
  inherited DoTerminate;

end;

constructor myThread.Create(CreateSuspended: Boolean; const StackSize: SizeUInt
  );
begin
  inherited Create(CreateSuspended, StackSize);
  freeing := False;
  FreeOnTerminate := True;
end;

end.

