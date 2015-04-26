unit MyDrawGrid;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, StdCtrls, Graphics, Dialogs, Grids, LCLProc,
  BGRABitmap, BGRABitmapTypes, resize, mygrids, PasLibVlcClassUnit;

type
  { TMyDrawGrid }

TMyDrawGrid = class(TCustomdrawGrid)
private
  { Private declarations }

  FTitleStyle: TTitleStyle;
  FTextStyle: TTextStyle;
  FModified: boolean;
  FRow,FCol: Integer;

  function CellNeedsCheckboxBitmaps(const aCol,aRow: Integer): boolean;
  procedure DrawCellCheckboxBitmaps(const aCol,aRow: Integer; const aRect: TRect);
  function  IsCellButtonColumn(ACell: TPoint): boolean;


  procedure SetSlideImage(ACol, ARow: Integer; AValue: TBGRABitmap);
  function GetSlideImage(ACol, ARow: Integer): TBGRABitmap;

  procedure SetCell(ACol, ARow: Integer; const AValue: TSlide);
  function GetCell(ACol, ARow: Integer): TSlide;

  function GetSlideText(ACol, ARow: Integer): string;
  procedure SetSlideText(ACol, ARow: Integer; aValue: string);

  function GetSlidePath(ACol, ARow: Integer): string;
  procedure SetSlidePath(ACol, ARow: Integer; aValue: string);

  procedure SetSlideNote(ACol, ARow: Integer; aValue: string);
  function GetSlideNote(ACol, ARow: Integer): string;
protected
  { Protected declarations }
  procedure DrawTextInCell(aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState); override;
public
  { Public declarations }
  FButtonDown: Boolean;
    FDownRow: Integer;
  constructor Create(AOwner: TComponent); override;
  //destructor Destroy; override;

  procedure Clear;

  procedure DefaultDrawCell(aCol, aRow: Integer; var aRect: TRect; aState: TGridDrawState); override;
  property Cells[ACol, ARow: Integer]: TSlide read GetCell write SetCell;
  property SlideText[ACol, ARow: Integer]: string read GetSlideText write SetSlideText;
  property SlideImage[ACol, ARow: Integer]: TBGRABitmap read GetSlideImage write SetSlideImage;
  property SlideNote[ACol, ARow: Integer]: string read GetSlideNote write SetSlideNote;
  property SlidePath[ACol, ARow: Integer]: string read GetSlidePath write SetSlidePath;

published
  { Published declarations }
  property Align;
  property AlternateColor;
  property Anchors;
  property AutoAdvance;
  property AutoEdit;
  property AutoFillColumns;
  //property BiDiMode;
  property BorderSpacing;
  property BorderStyle;
  property Color;
  property ColCount;
  property Columns;
  property ColumnClickSorts;
  //property Constraints;
  property DefaultColWidth;
  property DefaultRowHeight;
  property DragCursor;
  property DragKind;
  property DragMode;
  property Enabled;
  property ExtendedSelect;
  property FixedColor;
  property FixedCols;
  property FixedRows;
  property Flat;
  property Font;
  property GridLineWidth;
  property HeaderHotZones;
  property HeaderPushZones;
  property MouseWheelOption;
  property Options;
    //property ParentBiDiMode;
  property ParentColor default false;
  property ParentFont;
  property ParentShowHint;
  property PopupMenu;
  property RowCount;
  property ScrollBars;
  property ShowHint;
  property TabAdvance;
  property TabOrder;
  property TabStop;
  property TitleFont;
  property TitleImageList;
  property TitleStyle;
  property UseXORFeatures;
  property Visible;
  property VisibleColCount;
  property VisibleRowCount;

  property OnBeforeSelection;
  property OnCheckboxToggled;
  property OnClick;
  property OnColRowDeleted;
  property OnColRowExchanged;
  property OnColRowInserted;
  property OnColRowMoved;
  property OnCompareCells;
  property OnContextPopup;
  property OnDblClick;
  property OnDragDrop;
  property OnDragOver;
  property OnDrawCell;
  property OnEditButtonClick; deprecated;
  property OnButtonClick;
  property OnEditingDone;
  property OnEndDock;
  property OnEndDrag;
  property OnEnter;
  property OnExit;
  property OnGetCheckboxState;
  property OnGetEditMask;
  property OnGetEditText;
  property OnHeaderClick;
  property OnHeaderSized;
  property OnHeaderSizing;
  property OnKeyDown;
  property OnKeyPress;
  property OnKeyUp;
  property OnMouseDown;
  property OnMouseEnter;
  property OnMouseLeave;
  property OnMouseMove;
  property OnMouseUp;
  property OnMouseWheelDown;
  property OnMouseWheelUp;
  property OnPickListSelect;
  property OnPrepareCanvas;
  property OnSelectEditor;
  property OnSelection;
  property OnSelectCell;
  property OnSetCheckboxState;
  property OnSetEditText;
  property OnStartDock;
  property OnStartDrag;
  property OnTopleftChanged;
  property OnUserCheckboxBitmap;
  property OnUTF8KeyPress;
end;

procedure Register;

implementation

procedure Register;
begin
  {$I mydrawgrid_icon.lrs}
  RegisterComponents('Additional',[TMyDrawGrid]);
end;

{ TMyDrawGrid }

constructor TMyDrawGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  with FTextStyle do
  begin
    Alignment := taCenter;
    Layout := tlCenter;
    Wordbreak := true;
  end;
end;

{destructor TMyDrawGrid.Destroy;
begin
  //Clear;
  inherited Destroy;
end;                  }

procedure TMyDrawGrid.Clear;
{var
  i,x: Integer;
  C: PCellProps;  }
begin
  {for i:=0 to RowCount-1 do
    for x := 0 to ColCount-1 do  begin
      C:=FGrid.Celda[x,i];
      if C<> nil then
        FreeThenNil(C^.Data);
    end;           }
  Inherited clear;
end;

procedure TMyDrawGrid.DefaultDrawCell(aCol, aRow: Integer; var aRect: TRect;
  aState: TGridDrawState);
begin
  if goColSpanning in Options then CalcCellExtent(acol, arow, aRect);
  FTitleStyle:=tsLazarus;
  if (FTitleStyle=tsNative) and (gdFixed in AState) then
    DrawThemedCell(aCol, aRow, aRect, aState)
  else
    DrawFillRect(Canvas, aRect);

  if CellNeedsCheckboxBitmaps(aCol,aRow) then
    DrawCellCheckboxBitmaps(aCol,aRow,aRect)
  else
  begin
    if IsCellButtonColumn(Point(aCol,aRow)) then begin    //replaced!!!
    //if aCol=0 then begin
      DrawButtonCell(aCol,aRow,aRect,aState);
    end
    else begin
      if (goFixedRowNumbering in Options) and (ARow>=FixedRows) and (aCol=0) and
         (FixedCols>0)
      then
        DrawCellAutonumbering(aCol, aRow, aRect, ('Slide '+IntToStr(aRow-FixedRows+1)));
    end;
    //draw text
    if GetIsCellTitle(aCol, aRow) then
      DrawColumnText(aCol, aRow, aRect, aState)
    else
      DrawCellText(aCol,aRow,aRect,aState,GetSlideText(aCol, aRow));
  end;
end;

function TMyDrawGrid.GetCell(ACol, ARow: Integer): TSlide;
var
   C: PCellProps;
begin
  C:=Nil;
  C:=FGrid.Celda[ACol,ARow];
  if C = nil then
    SetCell(ARow, ACol, TSlide.create());
  C:=FGrid.Celda[ACol,ARow];
  Result:=(C^ .Data as TSlide);
  C:=Nil;
end;

function TMyDrawGrid.GetSlideImage(ACol, ARow: Integer): TBGRABitmap;
var
   C: PCellProps;
begin
  C:=Nil;
  C:=FGrid.Celda[ACol,ARow];
  if C = nil then
    SetSlideImage(ACol, ARow, TBGRABitmap.Create(1,1,BGRABlack));
  C:=FGrid.Celda[ACol,ARow];
  Result:=(C^.Data as TSlide).Img;
  C:=Nil;
end;

procedure TMyDrawGrid.SetSlideText(ACol, ARow: Integer; aValue: string);
  procedure UpdateCell;
  begin
    if EditorMode and (ACol=FCol)and(ARow=FRow) and
      not (gfEditorUpdateLock in GridFlags) then
    begin
      EditorDoSetValue;
    end;
    InvalidateCell(ACol, ARow);
  end;
var
  C: PCellProps;
begin
  C:=Nil;
  C:= FGrid.Celda[aCol,aRow];
  if C<>nil then
    begin
      if C^.Text<>nil then
        StrDispose(C^.Text);
      (C^.Data as TSlide).Text:=aValue;
    end
  else
    begin
      New(C);
      C^.Attr:=nil;
      C^.Text:=nil;
      C^.Data:=TSlide.create(aValue);
      FGrid.Celda[ACol,ARow]:=C;
      UpdateCell;
      FModified := True;
    end;
end;

function TMyDrawGrid.GetSlidePath(ACol, ARow: Integer): string;
var
   C: PCellProps;
begin
  C:=Nil;
  C:= FGrid.Celda[aCol,aRow];
  if C = nil then
    SetSlidePath(ACol, ARow, '');
  C:=FGrid.Celda[ACol,ARow];
  Result:=TSlide(C^.Data).Path;
  C:=Nil;
end;

procedure TMyDrawGrid.SetSlidePath(ACol, ARow: Integer; aValue: string);
var
  C: PCellProps;
begin
  C:=Nil;
  C:= FGrid.Celda[aCol,aRow];
  if C<>nil then
    begin
      if C^.Text<>nil then
        StrDispose(C^.Text);
      (C^.Data as TSlide).Path:=aValue
    end
  else
    begin
      New(C);
      C^.Attr:=nil;
      C^.Text:=nil;
      C^.Data:=TSlide.create('','',aValue);
      FGrid.Celda[ACol,ARow]:=C;
      FModified := True
    end;
    C:=Nil;
end;

procedure TMyDrawGrid.SetSlideNote(ACol, ARow: Integer; aValue: string);
var
  C: PCellProps;
begin
  C:=Nil;

  C:=FGrid.Celda[aCol,aRow];

  if C<>nil then
   (C^.Data as TSlide).Note := aValue
  else
    begin
      New(C);
      C^.Attr:=nil;
      C^.Text:=nil;
      C^.Data:=TSlide.create('', aValue);
      FGrid.Celda[ACol,ARow]:=C;
      FModified := True
    end;
  C:=Nil;
end;

function TMyDrawGrid.GetSlideNote(ACol, ARow: Integer): string;
var
   C: PCellProps;
begin
  C:=Nil;
  C:= FGrid.Celda[aCol,aRow];
  if C = nil then
    SetSlideNote(ACol, ARow, '');
  C:=FGrid.Celda[ACol,ARow];
  Result:=TSlide(C^.Data).Note;
  C:=Nil;
end;

procedure TMyDrawGrid.DrawTextInCell(aCol, aRow: Integer; aRect: TRect;
  aState: TGridDrawState);
var bmp: TBGRABitmap;
begin
  {bmp:=Nil;
  bmp:=TBGRABitmap.Create(aRect.Right-aRect.Left-1, aRect.Bottom-aRect.Top-1);

  bmp.CanvasBGRA.TextRect(Rect(1,1,bmp.Width,bmp.Height),0,0,GetSlideText(aCol, aRow));
  bmp.Draw(Canvas, aRect);
  FreeThenNil(bmp);  }
  Canvas.TextRect(aRect,aRect.Left,aRect.Top,GetSlideText(aCol, aRow));
end;

function TMyDrawGrid.CellNeedsCheckboxBitmaps(const aCol, aRow: Integer): boolean;
var
  C: TGridColumn;
begin
  Result := false;
  if (aRow>=FixedRows) and Columns.Enabled then begin
    C := ColumnFromGridColumn(aCol);
    result := (C<>nil) and (C.ButtonStyle=cbsCheckboxColumn)
  end;
end;

procedure TMyDrawGrid.DrawCellCheckboxBitmaps(const aCol, aRow: Integer;
  const aRect: TRect);
var
  AState: TCheckboxState;
begin
  AState := cbUnchecked;
  GetCheckBoxState(aCol, aRow, aState);
  DrawGridCheckboxBitmaps(aCol, aRow, aRect, aState);
end;

function TMyDrawGrid.IsCellButtonColumn(ACell: TPoint): boolean;
var
  Column: TGridColumn;
begin
  Column := ColumnFromGridColumn(ACell.X);
  result := (Column<>nil) and (Column.ButtonStyle=cbsButtonColumn) and
            (ACell.y>=FixedRows);
end;

procedure TMyDrawGrid.SetSlideImage(ACol, ARow: Integer; AValue: TBGRABitmap);
  procedure UpdateCell;
  begin
    if EditorMode and (ACol=FCol)and(ARow=FRow) and
      not (gfEditorUpdateLock in GridFlags) then
    begin
      EditorDoSetValue;
    end;
    InvalidateCell(ACol, ARow);
  end;
var
  C: PCellProps;
  S: TSlide;
begin
  S:=Nil;
  C:=Nil;
  C:= FGrid.Celda[aCol,aRow];
  if C<>nil then
  begin
    FreeThenNil((C^.Data as TSlide).Img);
    (C^.Data as TSlide).Img:=AValue;
  end
  else
  begin
    New(C);
    C^.Attr:=nil;
    C^.Text:=nil;
    C^.Data:=TSlide.create(AValue, 'Pending');
    FGrid.Celda[ACol,ARow]:=C;
    UpdateCell;
    FModified := True;
  end;
  C:=Nil;
  S:=Nil;
end;

function TMyDrawGrid.GetSlideText(ACol, ARow: Integer): string;
procedure UpdateCell;
begin
  if EditorMode and (ACol=FCol)and(ARow=FRow) and
    not (gfEditorUpdateLock in GridFlags) then
  begin
    EditorDoSetValue;
  end;
  InvalidateCell(ACol, ARow);
end;
  var
   C: PCellProps;
begin
  C:=FGrid.Celda[ACol,ARow];
  if C = nil then
    SetSlideText(ACol, ARow, '');
  C:=FGrid.Celda[ACol,ARow];
  Result:=TSlide(C^.Data).Text;
  C:=Nil;
end;

procedure TMyDrawGrid.SetCell(ACol, ARow: Integer; const AValue: TSlide);
  procedure UpdateCell;
  begin
    if EditorMode and (ACol=FCol)and(ARow=FRow) and
      not (gfEditorUpdateLock in GridFlags) then
    begin
      EditorDoSetValue;
    end;
    InvalidateCell(ACol, ARow);
  end;
var
  C: PCellProps;
begin
  C:= FGrid.Celda[ACol,ARow];
  if C<>nil then
    begin
      if C^.Text<>nil then
        StrDispose(C^.Text);
      if C^.Data<>nil then
        FreeThenNil(C^.Data);
      C^.Data:=AValue;

      UpdateCell;
      FModified := True;
    end
  else
    begin
      New(C);
      C^.Data:=AValue;
      C^.Text:=nil;
      C^.Attr:=nil;
      FGrid.Celda[ACol,ARow]:=C;
      UpdateCell;
      FModified := True;
    end;
    C:=Nil;
end;

{ TMyDrawGrid }
end.
