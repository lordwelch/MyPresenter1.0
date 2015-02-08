unit MyDrawGrid;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Grids, LCLProc,
  BGRABitmap, BGRABitmapTypes, resize, mygrids, PasLibVlcClassUnit;

type

  PBGRABitmap = ^TBGRABitmap;

  { TMyDrawGrid }

  TMyDrawGrid = class(TCustomdrawGrid)
  private
    { Private declarations }
    FTextStyle: TTextStyle;
    FModified: boolean;
    FRow,FCol: Integer;
    BlankBitmap: TBGRABitmap;
    function GetTextStyle():TTextStyle;
    procedure SetImage(ACol, ARow: Integer; AValue: TBGRABitmap);
    procedure SetCells(ACol, ARow: Integer; const AValue: TSlide);
    function GetCells(ACol, ARow: Integer): TSlide;  overload;
    procedure SetTextStyle(ATextStyle:TTextStyle);
  protected
    { Protected declarations }
    function GetSlideText(ACol, ARow: Integer): string;

    function GetImage(ACol, ARow: Integer): TBGRABitmap;
    procedure SetSlideText(ACol, ARow: Integer; aValue: string);
    procedure DrawCell(aCol,aRow: Integer; aRect: TRect; aState:TGridDrawState); override;
    procedure paint; override;

  public
    { Public declarations }
    procedure InvalidateCell(aCol, aRow: Integer); overload;
    constructor Create(AOwner: TComponent); override;
    property TextStyle: TTextStyle read GetTextStyle write SetTextStyle;
    property Cells[ACol, ARow: Integer]: TSlide read GetCells write SetCells;
    property SlideText[ACol, ARow: Integer]: string read GetSlideText write SetSlideText;
    property CellImage[ACol, ARow: Integer]: TBGRABitmap read GetImage write SetImage;
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
    property DefaultDrawing{ Default False};

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
  BlankBitmap:=TBGRABitmap.Create(1, 1, clBlack);
  with FTextStyle do
  begin
    Alignment := taCenter;
    Layout := tlCenter;
    Wordbreak := true;
  end;
end;

procedure TMyDrawGrid.DrawCell(aCol, aRow: Integer; aRect: TRect;
  aState: TGridDrawState);
var
  //iheight: Integer = 0;
  //iwidth: Integer = 0;
  Cheight: Integer = 0;
  Cwidth: Integer = 0;
  PBitmap: PBGRABitmap = nil;
  bitmap: TBitmap;
begin
  bitmap:= TBitmap.Create();
  PrepareCanvas(ACol, ARow, aState);
  DrawFillRect(Canvas, aRect);
  DrawCellGrid(ACol,ARow,aRect,aState);
  if ACol = 0 then
    if ARow > 0 then
      Canvas.textrect(aRect, 0, 0, ('Slide ' + inttostr(ARow)), textstyle);
      if acol > 0 then
       canvas.TextRect(aRect, 0, 0, SlideText[ACol, ARow], textstyle);
  if (ACol=2) and (ARow<>0) then
    begin
      //PBitmap:=CellImage[ACol, ARow];
      if PBitmap <> nil then
        begin
          Cwidth:=ColWidths[ACol];
          Cheight:=RowHeights[ARow];
          if (Cwidth <> 0) or (Cheight<>0) then
            bitmap:=ResizeImage(CellImage[ACol, ARow], Cwidth, Cheight, True, True).Bitmap;
          //DebugLn('Width : draw: ARow: '+IntToStr(ARow)+',  '+IntToStr(bitmap.Width));
          //DebugLn('Height: draw: '+IntToStr(bitmap.Height));
          //DebugLn('Width : ptrdraw: '+IntToStr(PBitmap^.Width));
          //DebugLn('Height: ptrdraw: '+IntToStr(PBitmap^.Height));
          canvas.Draw(aRect.Left,aRect.Top, bitmap);
        end;
    end;
  bitmap.Free;
  {if PBitmap<>nil then
    PBitmap:=nil; }
end;

function TMyDrawGrid.GetCells(ACol, ARow: Integer): TSlide;
var
   C: PCellProps;
begin

  C:=FGrid.Celda[ACol,ARow];
  if C<>nil then Result:=TSlide(C^ .Data)
  else Result:=TSlide.create(BGRABlack);
end;

function TMyDrawGrid.GetImage(ACol, ARow: Integer): TBGRABitmap;
var
   C: PCellProps;
begin
   Result:=BlankBitmap;
  C:=FGrid.Celda[ACol,ARow];
  if C<>nil then Result:=TSlide(C^.Data).Image;
end;

procedure TMyDrawGrid.SetSlideText(ACol, ARow: Integer; aValue: string);
var
  C: PCellProps;
  S: TSlide;
  txt: String;
begin
  txt:=aValue;
  C:= FGrid.Celda[ACol,ARow];
  if C<>nil then
    begin
      if C^.Text<>nil then
        StrDispose(C^.Text);
      C^.Text:=StrNew(pchar(txt));
      TSlide(C^.Data).Text:=txt;
    end
  else
    begin
      S:=TSlide.create(txt);
      SetCells(ACol, ARow, S);
      S.Free;
    end;
end;

procedure TMyDrawGrid.SetImage(ACol, ARow: Integer; AValue: TBGRABitmap);
var
  C: PCellProps;
  S: TSlide;
  //strslide, strnote, strvid: string;
begin
  C:= FGrid.Celda[aCol,aRow];
  if C<>nil then
  begin
    with S do
    begin
    S:=GetCells(ACol, ARow);
    Image.Free;
    Image:=AValue;
    SetCells(ACol, ARow, S);
    end;
    S.Free;
  end
  else
  begin
  S:=TSlide.create(aValue);
  SetCells(ACol, ARow, S);
  S.Free;
  end;
end;

function TMyDrawGrid.GetTextStyle(): TTextStyle;
begin
   Result:=FTextStyle;
end;

procedure TMyDrawGrid.SetTextStyle(ATextStyle: TTextStyle);
begin
   FTextStyle:=ATextStyle;
end;

function TMyDrawGrid.GetSlideText(ACol, ARow: Integer): string;
  var
   C: PCellProps;
begin
  C:=FGrid.Celda[ACol,ARow];
  if C<>nil then Result:=C^.Text
  else Result:='';
end;

procedure TMyDrawGrid.paint;
begin
  inherited;
end;

procedure TMyDrawGrid.InvalidateCell(aCol, aRow: Integer);
begin
  inherited InvalidateCell(ACol, ARow);
end;

procedure TMyDrawGrid.SetCells(ACol, ARow: Integer; const AValue: TSlide);
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
      C^.Text:=StrNew(pchar(aValue.Text));
      if C^.Data<>nil then
        C^.Data.Free;
      C^.Data:=AValue;

      UpdateCell;
      FModified := True;
    end
  else
    begin
      New(C);
      C^.Data:=AValue;
      C^.Text:=StrNew(pchar(AValue.Text));
      C^.Attr:=nil;
      FGrid.Celda[ACol,ARow]:=C;
      UpdateCell;
      FModified := True;
    end;
end;

{ TMyDrawGrid }



end.
end.
