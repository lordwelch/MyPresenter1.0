unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, StdCtrls, EditBtn, Buttons, MyDrawGrid, BGRAResizeSpeedButton, data,
  ActnList, Menus, treegrid;

type

  { TForm1 }

  TForm1 = class(TForm)
    TAAddNew: TAction;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MnuCreateSong: TMenuItem;
    MnuExit: TMenuItem;
    MnuNew: TMenuItem;
    MnuSpace1: TMenuItem;
    MnuOpen: TMenuItem;
    MnuRecent: TMenuItem;
    MnuSave: TMenuItem;
    MnuSaveAs: TMenuItem;
    MnuClose: TMenuItem;
    MnuSpace2: TMenuItem;
    TARowDel: TAction;
    ActionList1: TActionList;
    BGRAResizeSpeedButton1: TBGRAResizeSpeedButton;
    BGRAResizeSpeedButton2: TBGRAResizeSpeedButton;
    Button1: TButton;
    EditButton1: TEditButton;
    Memo1: TMemo;
    Memo2: TMemo;
    IGrid: TMyDrawGrid;
    Notebook1: TNotebook;
    OpenImgDialog: TOpenDialog;
    PageControl1: TPageControl;
    Panel1: TPanel;
    TreeView1: TTreeGrid;
    procedure Action1Execute(Sender: TObject);
    procedure BGRAResizeSpeedButton1Click(Sender: TObject);
    procedure BGRAResizeSpeedButton2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure EditButton1ButtonClick(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
    procedure FormShow(Sender: TObject);
    procedure IGridGetEditText(Sender: TObject; ACol, ARow: Integer;
      var Value: string);
    procedure IGridSelectEditor(Sender: TObject; aCol, aRow: Integer;
      var Editor: TWinControl);
    procedure IGridSelection(Sender: TObject; aCol, aRow: Integer);
    procedure IGridSetEditText(Sender: TObject; ACol, ARow: Integer;
      const {%H-}Value: string);
    procedure TAAddNewExecute(Sender: TObject);
    procedure TARowDelExecute(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  SelRow, SelCol: Integer;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.IGridGetEditText(Sender: TObject; ACol, ARow: Integer;
  var Value: string);
begin
  Value :=  IGrid.SlideText[ARow];
  Memo1.Text := IGrid.SlideText[ARow];
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  showProjection;
end;

procedure TForm1.EditButton1ButtonClick(Sender: TObject);
begin
  setSlide(StrToInt(EditButton1.Text));
end;

procedure TForm1.FormDropFiles(Sender: TObject;
  const FileNames: array of String);
var i: Integer;
  z: Integer = 0;
  s: Boolean;
begin
  for i := 0 to Length(FileNames)-1 do
    begin
      //Application.ProcessMessages;
      s:=SupportedImageList.Find(ExtractFileExt(FileNames[i]), z);
      if s then
        AddImage(FileNames[i]);
      Memo2.Append('test' + IntToStr(i)+' '+SupportedImageList.Strings[z]);
      Memo2.Append(BoolToStr(s, True)+'"'+ExtractFileExt(FileNames[i])+'" '+IntToStr(z));
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  OpenImageDialog();
end;

procedure TForm1.BGRAResizeSpeedButton1Click(Sender: TObject);
begin
  setSlide(currSlideIndex+1);
end;

procedure TForm1.Action1Execute(Sender: TObject);
begin

end;

procedure TForm1.BGRAResizeSpeedButton2Click(Sender: TObject);
begin
  setSlide(currSlideIndex-1);
end;

procedure TForm1.IGridSelectEditor(Sender: TObject; aCol, aRow: Integer;
  var Editor: TWinControl);
begin
  if IGrid.Col = 1 then
  begin
    Editor := Memo1;
    Memo1.BoundsRect := IGrid.CellRect(aCol, aRow)
  end else
    Editor := Nil;
end;

procedure TForm1.IGridSelection(Sender: TObject; aCol, aRow: Integer);
begin
  SelRow := aRow;
  SelCol := aCol;
end;

procedure TForm1.IGridSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: string);
begin
  IGrid.SlideText[ARow] := Memo1.Text;
end;

procedure TForm1.TAAddNewExecute(Sender: TObject);
begin
  showSong();
end;

procedure TForm1.TARowDelExecute(Sender: TObject);
begin
  if SelCol = 2 then
    IGrid.DeleteRow(SelRow);
end;

end.

