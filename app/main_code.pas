unit main_code;

{$mode objfpc}{$H+}

interface

uses
  cmem, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  LCLType, LCLProc, StdCtrls, ExtCtrls, ActnList, StdActns, Data, BCButton,
  PasLibVlcPlayerUnit, Projector, settings, slideeditor,
  MyDrawGrid, Grids, BGRABitmap;

type

  { TForm1 }

  TForm1 = class(TForm)
    TASaveAs: TAction;
    MenuItem27: TMenuItem;
    SaveDialog1: TSaveDialog;
    TAOpenScript: TAction;
    Button4: TButton;
    TASave: TAction;
    Button3: TButton;
    TAExit: TAction;
    PasLibVlcPlayer1: TPasLibVlcPlayer;
    TAClose: TAction;
    Editable: TAction;
    TAOpen: TAction;
    TANext: TAction;
    TAPrevious: TAction;
    ActionList1: TActionList;
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
    Button2: TButton;
    procedure BCButton2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MenuItem1Click(Sender: TObject);
    procedure TAExitExecute(Sender: TObject);
    procedure TAOpenExecute(Sender: TObject);
    procedure TACloseExecute(Sender: TObject);
    procedure EditableExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
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
    procedure TAOpenScriptExecute(Sender: TObject);
    procedure TASaveAsExecute(Sender: TObject);
    procedure TASaveExecute(Sender: TObject);
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
var i: Integer;
begin
  SlideFile := '';
  LoadSupportedImages();
  {GridImageList := TBGRAImageList.Create(Grid);
  with GridImageList do
  begin
    Height:=Monitor.Height;
    Width:=Monitor.Width;
  end;  }
  CurrentSlide := 1;
  NextSlide := 1;
  GetScreens();
  SetLength(GridImageList, 3, 1);
  for i:=0 to 2 do
    GridImageList[i, 0]:=TBGRABitmap.Create(1, 1, clBlack);
  Memo1.VertScrollBar.Tracking:=True;
  TAClose.Execute;

end;

procedure TForm1.FormDropFiles(Sender: TObject; const FileNames: array of String);
var i: Integer;
begin
  DebugLn('drop');
  for i:= 0 to Length(FileNames)-1 do
    LoadImage(FileNames[i]);
end;

procedure TForm1.GridEditor1EditingDone(Sender: TObject);
begin
  grid.SlideText[Grid.Col, grid.Row]:=GridEditor1.Text;
  frmProjector.Invalidate;
  TAPrevious.Enabled:=True;
  TANext.Enabled:=True;
end;

procedure TForm1.GridGetEditText(Sender: TObject; ACol, ARow: Integer;
  var Value: string);
begin
  Value:=Grid.SlideText[ACol, ARow];
end;

procedure TForm1.GridSelectEditor(Sender: TObject; aCol, aRow: Integer;
  var Editor: TWinControl);
begin
  TANext.Enabled:=False;
  TAPrevious.Enabled:=False;
  GridEditor1.BoundsRect:=grid.CellRect(aCol,aRow);
  GridEditor1.Text:=grid.SlideText[aCol,aRow];
  Editor:=GridEditor1;
end;

procedure TForm1.GridSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: string);
begin
  grid.Cells[ACol,ARow].Text:=Value;
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

end;

procedure TForm1.MenuItem8Click(Sender: TObject);
begin
end;

procedure TForm1.NextSlideExecute(Sender: TObject);
begin
  if TAction(Sender).Tag = 1 then
    begin
    if CurrentSlide < Grid.RowCount-1 then
      if (CurrentSlide >= (Grid.RowCount - 1)) then
        CurrentSlide:=(Grid.RowCount-1)
      else
        CurrentSlide+=1
    end
  else
    if CurrentSlide > 1 then
      CurrentSlide-=1;

  Memo1.Append(IntToStr(CurrentSlide));
       //setslidetext(textSlidesgrid.Cells[x, y]);
  frmProjector.Invalidate;
end;

procedure TForm1.TAOpenScriptExecute(Sender: TObject);

begin
  //if TAction(Sender).Tag = 4 then
    //TACloseExecute(Sender);
  OpenDialog1.Filter := 'slide script|*.mpss';
  DialogOptions -= [ofAllowMultiSelect];
  OpenDialog1.Options := DialogOptions;
  if OpenDialog1.Execute then
    SlideFile := OpenDialog1.FileName;
  readXMLSlide(SlideFile);
end;

procedure TForm1.TASaveAsExecute(Sender: TObject);
begin
  SaveDialog1.DefaultExt := 'mpss';
  if SaveDialog1.Execute then
    SlideFile:=SaveDialog1.FileName;
    SaveXMLSlide(SlideFile);
end;

procedure TForm1.TASaveExecute(Sender: TObject);
begin
  if SlideFile<>'' then
    SaveXMLSlide(SlideFile);
end;

procedure TForm1.BCButton2Click(Sender: TObject);
begin
  ShowPrjctr();
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  TAPrevious.Enabled:=False;
  TANext.Enabled:=False;
  frmSlideEditor.Show;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Grid.InsertColRow(False, Form1.Grid.RowCount);
  Grid.Cells[2, Form1.Grid.RowCount-1];
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  FreeImage();
end;

procedure TForm1.GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
    if ssCtrl in Shift then
      if Key = VK_RETURN then
        Form1.SetFocusedControl(Button1);
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin

end;

procedure TForm1.TAExitExecute(Sender: TObject);
begin
  //DebugLn('test');
  if frmProjector.Focused then
    frmProjector.Close;
end;

procedure TForm1.TAOpenExecute(Sender: TObject);
begin
  if OpenDialog1.Execute then
      LoadImageList(TStringList(OpenDialog1.Files));
end;

procedure TForm1.TACloseExecute(Sender: TObject);
var
  a,c:TGridColumn;
begin
  if ImagePath<>nil then ImagePath.Clear;
  Memo1.Clear;
  with grid do
  begin
    AutoFillColumns := False;
    Columns.Clear;
    Grid.Clear;
    C:=Columns.Add;
    C.SizePriority:=0;
    C.Width := 198;
    a:=Columns.Add;
    FixedCols:=1;
    RowCount := 1;
    //FixedRows:=1;
    AutoFillColumns := True;
  end;
  FreeImage();
  //frmProjector.Invalidate;
end;

procedure TForm1.EditableExecute(Sender: TObject);
begin
  FrmSettings.btnEditableClick(FrmSettings.btnEditable);
end;

end.
