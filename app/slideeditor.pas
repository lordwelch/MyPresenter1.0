unit slideeditor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, resize, BGRABitmapTypes, BGRABitmap, BGRAGraphicControl, mygrids;

type

  { TfrmSlideEditor }

  TfrmSlideEditor = class(TForm)
    CellImage: TBGRAGraphicControl;
    Button1: TButton;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Memo1: TMemo;
    Memo2: TMemo;
    selectimage: TBGRAGraphicControl;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    procedure Button1Click(Sender: TObject);
    procedure CellImagePaint(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure ListBox1SelectionChange(Sender: TObject; User: boolean);
    procedure ListBox2SelectionChange(Sender: TObject; User: boolean);
    procedure Memo1EditingDone(Sender: TObject);
    procedure Memo1KeyPress(Sender: TObject; var Key: char);
    procedure selectimagePaint(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmSlideEditor: TfrmSlideEditor;

implementation
uses main_code, Data;

{$R *.lfm}

{ TfrmSlideEditor }

procedure TfrmSlideEditor.FormShow(Sender: TObject);
var i: Integer;
begin
  Memo1.Lines.Text:=Form1.Grid.SlideText[1, 1];
  //Memo2.Text:=Form1.Grid.SlideNote[1, 1];
  ListBox1.Clear;
  ListBox2.Clear;
  if Form1.Grid.RowCount >1 then
  begin
    for i:=1 to Form1.Grid.RowCount-1 do
      ListBox1.Items.Add(IntToStr(i));
  ListBox1.ItemIndex:=1;
  end;
  i:=0;
  if Length(GridImageList) > 0 then
  begin
  if Length(GridImageList[0]) > 0 then
    for i:=0 to Length(GridImageList[0])- 1 do
      ListBox2.Items.Add(IntToStr(i+1));
  end;
  ListBox2.ItemIndex:=0;
end;

procedure TfrmSlideEditor.ListBox1SelectionChange(Sender: TObject; User: boolean
  );
begin
  CellImage.Invalidate;
  Memo1.Lines.Text:=Form1.Grid.SlideText[1, ListBox1.ItemIndex];
end;

procedure TfrmSlideEditor.ListBox2SelectionChange(Sender: TObject; User: boolean
  );
begin
  selectimage.Invalidate;
end;

procedure TfrmSlideEditor.Memo1EditingDone(Sender: TObject);
begin
  Form1.Grid.SlideText[1, ListBox1.ItemIndex]:=Memo1.Lines.Text;
end;

procedure TfrmSlideEditor.Memo1KeyPress(Sender: TObject; var Key: char);
begin
  //TMemo(Sender).Text:=TMemo(Sender).Text+Key;
end;

procedure TfrmSlideEditor.selectimagePaint(Sender: TObject);
begin
  selectimage.Bitmap.PutImage(0, 0, ResizeImage(GridImageList[0, ListBox2.ItemIndex],selectimage.Width, selectimage.Height), dmSet);
end;

procedure TfrmSlideEditor.ComboBox1Change(Sender: TObject);
begin
  //CellImage.Bitmap.PutImage(0, 0, form1.Grid.CellImage[2, StrToInt(ListBox1.Text)].Resample(selectimage.Width, selectimage.Height), dmSet);
end;

procedure TfrmSlideEditor.Button1Click(Sender: TObject);
var i, x: Integer;
  img, img1: image1;
begin
  img.Img:=GridImageList[2, x];
  img.ImgPath := ImagePath.Names[i];
  img1.ImgPath := ImagePath.Names[i];
  img1.Img := GridImageList[1, x];
  i:=ListBox1.ItemIndex;
  X:=ListBox2.ItemIndex;
  Form1.Grid.SlideImage[2, i]:=img;

  Form1.Grid.SlideImage[1, i]:=img1;

  Form1.Grid.SlideText[1, i]:=Form1.Grid.SlideText[1, x];
  CellImage.Invalidate;
  selectimage.Invalidate;
  Memo1.Lines.Text:=Form1.Grid.SlideText[1, ListBox1.ItemIndex];
end;

procedure TfrmSlideEditor.CellImagePaint(Sender: TObject);
begin
  CellImage.Bitmap.PutImage(0, 0, ResizeImage(form1.Grid.SlideImage[1, ListBox1.ItemIndex].Img,selectimage.Width,selectimage.Height) , dmSet);
end;

procedure TfrmSlideEditor.ComboBox2Change(Sender: TObject);
//var test1: TBGRABitmap;
begin

end;

procedure TfrmSlideEditor.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  Form1.TANext.Enabled:=True;
  Form1.TAPrevious.Enabled:=True;
end;

//initialization
//  {$I slideeditor.lrs}

end.
