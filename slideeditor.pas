unit slideeditor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, MyDrawGrid, BGRABitmapTypes, BGRABitmap, BGRAGraphicControl;

type

  { TfrmSlideEditor }

  TfrmSlideEditor = class(TForm)
    CellImage: TBGRAGraphicControl;
    Button1: TButton;
    selectimage: TBGRAGraphicControl;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
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
  ComboBox1.Clear;
  ComboBox2.Clear;
  for i:=1 to Form1.Grid.RowCount-1 do
    ComboBox1.Items.Add(IntToStr(i));
  i:=0;
  if Length(GridImageList) > 0 then
    for i:=0 to Length(GridImageList)-1 do
      ComboBox2.Items.Add(IntToStr(i));
end;

procedure TfrmSlideEditor.ComboBox1Change(Sender: TObject);
begin
  CellImage.Bitmap.PutImage(0, 0, form1.Grid.CellImage[2, StrToInt(ComboBox1.Text)]^.Resample(selectimage.Width, selectimage.Height), dmSet);
  CellImage.Invalidate;
end;

procedure TfrmSlideEditor.Button1Click(Sender: TObject);
var i, x: Integer;
begin
  i:=StrToInt(ComboBox1.Text);
  X:=StrToInt(ComboBox2.Text);
  Form1.Grid.CellImage[2, i]:=@GridImageList[x];
  CellImage.Invalidate;
  selectimage.Invalidate;
end;

procedure TfrmSlideEditor.ComboBox2Change(Sender: TObject);
//var test1: TBGRABitmap;
begin
  try
  //test1:=TBGRABitmap.Create;
  Form1.Memo1.Append('load');
  //test1.PutImage(0, 0, , dmSet);;
  Form1.Memo1.Append('put');
  selectimage.Bitmap.PutImage(0, 0, GridImageList[StrToInt(ComboBox2.Text)].Resample(selectimage.Width, selectimage.Height), dmSet);
  Form1.Memo1.Append('paint');
  selectimage.Invalidate;
  finally
    //test1.Free;
  end;
end;

//initialization
//  {$I slideeditor.lrs}

end.
