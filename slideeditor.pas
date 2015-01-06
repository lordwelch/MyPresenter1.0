unit slideeditor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, MyDrawGrid, BGRABitmapTypes, BGRABitmap, BGRAGraphicControl;

type

  { TfrmSlideEditor }

  TfrmSlideEditor = class(TForm)
    BGRAGraphicControl1: TBGRAGraphicControl;
    BGRAGraphicControl2: TBGRAGraphicControl;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
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
  for i:=0 to Length(GridImageList)-1 do
    ComboBox2.Items.Add(IntToStr(i));
end;

procedure TfrmSlideEditor.ComboBox1Change(Sender: TObject);
begin
  BGRAGraphicControl1.Bitmap.PutImage(0, 0, form1.Grid.CellImage[2, StrToInt(ComboBox1.Text)]^, dmSet);
  BGRAGraphicControl1.Invalidate;
end;

procedure TfrmSlideEditor.ComboBox2Change(Sender: TObject);
var test1: TBGRABitmap;
begin
  //test1:=TBGRABitmap.Create;
  Form1.Memo1.Append('load');
  test1:=GridImageList[StrToInt(ComboBox2.Text)];
  Form1.Memo1.Append('put');
  BGRAGraphicControl2.Bitmap.PutImage(0, 0, test1.Resample(BGRAGraphicControl2.Width, BGRAGraphicControl2.Height), dmSet);
  Form1.Memo1.Append('paint');
  BGRAGraphicControl2.Invalidate;
  test1.Free;
end;

procedure TfrmSlideEditor.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  FreeAndNil(GridImageList);
end;

//initialization
//  {$I slideeditor.lrs}

end.
