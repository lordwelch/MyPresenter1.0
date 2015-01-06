unit main_code;

{$mode objfpc}{$H+}

interface

uses
  cmem, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  LCLType, StdCtrls, ExtCtrls, ActnList, StdActns, Data,
  MyDrawGrid, BCButton, Projector, Grids, settings, slideeditor;

type

  { TForm1 }

  TForm1 = class(TForm)
    TAClose: TAction;
    Editable: TAction;
    Open: TAction;
    TANext: TAction;
    TAPrevious: TAction;
    ActionList1: TActionList;
    BCButton1: TBCButton;
    BCButton2: TBCButton;
    Button1: TButton;
    EditCopy1: TEditCopy;
    MainMenu1: TMainMenu;
    GridEditor1: TMemo;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem26: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    Grid: TMyDrawGrid;
    OpenDialog1: TOpenDialog;
    procedure BCButton2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TACloseExecute(Sender: TObject);
    procedure EditableExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
    procedure GridEditingDone(Sender: TObject);
    procedure GridEditor1EditingDone(Sender: TObject);
    procedure GridGetEditText(Sender: TObject; ACol, ARow: Integer;
      var Value: string);
    procedure GridSelectEditor(Sender: TObject; aCol, aRow: Integer;
      var Editor: TWinControl);
    procedure GridSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem26Click(Sender: TObject);
    procedure MenuItem25Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure NextSlideExecute(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  LoadSupportedImages();
  {GridImageList := TBGRAImageList.Create(Grid);
  with GridImageList do
  begin
    Height:=Monitor.Height;
    Width:=Monitor.Width;
  end;  }
  CurrentSlide := 0;
  NextSlide := 1;
  GetScreens();

end;

procedure TForm1.FormDropFiles(Sender: TObject; const FileNames: array of String);
begin
  memo1.Append('drop');
  ImagePath.AddStrings(SortFiles(FileNames));
  Memo1.Append('debug: LoadImages()');
  LoadImages();
end;

procedure TForm1.GridEditingDone(Sender: TObject);
begin

end;

procedure TForm1.GridEditor1EditingDone(Sender: TObject);
begin
  grid.Cells[Grid.Col, grid.Row]:=GridEditor1.Text;
end;

procedure TForm1.GridGetEditText(Sender: TObject; ACol, ARow: Integer;
  var Value: string);
begin
  Value:=Grid.Cells[ACol, ARow];
end;

procedure TForm1.GridSelectEditor(Sender: TObject; aCol, aRow: Integer;
  var Editor: TWinControl);
begin
  GridEditor1.BoundsRect:=grid.CellRect(aCol,aRow);
  GridEditor1.Text:=grid.Cells[aCol,aRow];
  Editor:=GridEditor1;
end;

procedure TForm1.GridSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: string);
begin
  grid.Cells[ACol,ARow]:=Value;
end;

procedure TForm1.MenuItem10Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.MenuItem26Click(Sender: TObject);
begin
  ShowSett();
end;

procedure TForm1.MenuItem25Click(Sender: TObject);
begin
  ShowAbt();
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    begin
      ImagePath.AddStrings(SortFiles(OpenDialog1.Files));
      LoadImages();
    end;
end;

procedure TForm1.MenuItem8Click(Sender: TObject);
begin
  ImagePath.Clear;
  FreeAndNil(GridImageList);
  Grid.Clear;
  Memo1.Clear;
  with grid do
  begin
    ColCount:=2;
    FixedCols:=1;
    RowCount:=5;
    FixedRows:=1;
  end;
  frmProjector.Invalidate;
end;

procedure TForm1.NextSlideExecute(Sender: TObject);
begin
  if TAction(Sender).Tag = 1 then
    begin
    if CurrentSlide < (ImagePath.Count - 1) then
      begin
      CurrentSlide+=1;
      Memo1.Append('next')
      end
    end
  else
    if CurrentSlide >= 1 then
      begin
      CurrentSlide-=1;
      Memo1.Append('previous');
      end;

       //setslidetext(textSlidesgrid.Cells[x, y]);
  frmProjector.BGRAGraphicControl1.Invalidate;
end;

procedure TForm1.BCButton2Click(Sender: TObject);
begin
  ShowPrjctr();
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  frmSlideEditor.Show;
end;

procedure TForm1.TACloseExecute(Sender: TObject);
begin
  MenuItem8Click(Sender);
end;

procedure TForm1.EditableExecute(Sender: TObject);
begin
  FrmSettings.btnEditableClick(FrmSettings.btnEditable);
end;

end.
