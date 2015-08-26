unit treegrid;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ComCtrls;

type

  { TTreeGrid }

  TTreeGrid = class(TCustomTreeView)
   protected
     procedure DoPaint; override;
     procedure DoPaintNode(Node: TTreeNode); override;
  end;

implementation

{ TTreeGrid }

procedure TTreeGrid.DoPaint;
var
  a,HalfBorderWidth:integer;
  SpaceRect, DrawRect: TRect;
  Node: TTreeNode;
  InsertMarkRect: TRect;
begin
  if [tvsUpdating,tvsPainting] * FStates <> [] then Exit;
  Include(FStates, tvsPainting);
  try
    if Focused then
      Include(FStates,tvoFocusedPainting)
    else
      Exclude(FStates,tvoFocusedPainting);
    if (tvoAutoItemHeight in fOptions) then
      UpdateDefaultItemHeight;
    UpdateScrollbars;
    with Canvas do
    begin
      if IsCustomDrawn(dtControl, cdPrePaint) then
      begin
        DrawRect := ClientRect;
        if not CustomDraw(DrawRect, cdPrePaint) then exit;
      end;
      // draw nodes
      Node := TopItem;
      //write('[TCustomTreeView.DoPaint] A Node=',DbgS(Node));
      //if Node<>nil then DebugLn(' Node.Text=',Node.Text) else DebugLn('');
      while Node <> nil do
      begin
        if Node.Visible then
          DoPaintNode(Node);
        Node := Node.GetNextVisible;
        //write('[TCustomTreeView.DoPaint] B Node=',DbgS(Node));
        //if Node<>nil then DebugLn(' Node.Text=',Node.Text) else DebugLn('');
      end;
      SpaceRect := Rect(BorderWidth, BorderWidth,
                        (ClientWidth - ScrollBarWidth) - BorderWidth,
                        (ClientHeight - ScrollBarWidth) - BorderWidth);
      // draw insert mark for new root node
      if (InsertMarkType = tvimAsFirstChild) and (Items.Count = 0) then
      begin
        Pen.Color := FTreeLineColor;
        Brush.Color := FSelectedColor;
        InsertMarkRect := SpaceRect;
        InsertMarkRect.Bottom := InsertMarkRect.Top + 2;
        Rectangle(InsertMarkRect);
        SpaceRect.Top := InsertMarkRect.Bottom;
      end;
      // draw unused space below nodes
      Node := BottomItem;
      if Node <> nil then
        SpaceRect.Top := Node.Top + Node.Height - FScrolledTop + BorderWidth;
      //if Node<>nil then DebugLn('BottomItem=',BottomItem.text) else DebugLn('NO BOTTOMITEM!!!!!!!!!');
      // TWinControl(Parent).InvalidateRect(Self,SpaceRect,true);
      if (FBackgroundColor <> clNone) and (SpaceRect.Top < SpaceRect.Bottom) then
      begin
        //DebugLn('  SpaceRect=',SpaceRect.Left,',',SpaceRect.Top,',',SpaceRect.Right,',',SpaceRect.Bottom);
        Brush.Color := FBackgroundColor;
        FillRect(SpaceRect);
      end;
      // draw border
      HalfBorderWidth := BorderWidth shr 1;
      Pen.Color := clGray;
      for a := 0 to BorderWidth - 1 do
      begin
        if a = HalfBorderWidth then
          Pen.Color := clBlack;
        MoveTo(a, (ClientHeight-ScrollBarWidth) - 1 - a);
        LineTo(a, a);
        LineTo((ClientWidth - ScrollBarWidth) - 1 - a, a);
      end;
      Pen.Color := clWhite;
      for a := 0 to BorderWidth - 1 do
      begin
        if a = HalfBorderWidth then
          Pen.Color := clLtGray;
        MoveTo((ClientWidth - ScrollBarWidth) - 1 - a, a);
        LineTo((ClientWidth - ScrollBarWidth) - 1 - a, (ClientHeight - ScrollBarWidth) - 1 - a);
        LineTo(a, (ClientHeight-ScrollBarWidth) - 1 - a);
      end;
      if IsCustomDrawn(dtControl, cdPostPaint) then
      begin
        DrawRect := ClientRect;
        if not CustomDraw(DrawRect, cdPostPaint) then exit;
      end;
    end;
  finally
    Exclude(FStates, tvsPainting);
  end;
end;

procedure TTreeGrid.DoPaintNode(Node: TTreeNode);
var
  NodeRect: TRect;
  VertMid, VertDelta: integer;
  NodeSelected, HasExpandSign: boolean;

  function InvertColor(AColor: TColor): TColor;
  var Red, Green, Blue: integer;
  begin
    if AColor<>clHighlight then begin
      Result:=clWhite;
      Red:=(AColor shr 16) and $ff;
      Green:=(AColor shr 8) and $ff;
      Blue:=AColor and $ff;
      if Red+Green+Blue>$180 then
        Result:=clBlack;
      //DebugLn(['[TCustomTreeView.DoPaintNode.InvertColor] Result=',Result,' ',Red,',',Green,',',Blue]);
    end
    else
      Result := clHighlightText;
  end;

  procedure DrawVertLine(X, Y1, Y2: Integer);
  begin
    if Y1 > Y2 then
      Exit;
    if TreeLinePenStyle = psPattern then
    begin
      // TODO: implement psPattern support in the LCL
      Y1 := Y1 + VertDelta;
      while Y1 < Y2 do
      begin
        Canvas.Pixels[X, Y1] := TreeLineColor;
        inc(Y1, 2);
      end;
    end
    else
    begin
      Canvas.MoveTo(X, Y1);
      Canvas.LineTo(X, Y2);
    end;
  end;

  procedure DrawHorzLine(Y, X1, X2: Integer);
  begin
    if X1 > X2 then
      Exit;
    if TreeLinePenStyle = psPattern then
    begin
      // TODO: implement psPattern support in the LCL
      while X1 < X2 do
      begin
        Canvas.Pixels[X1, Y] := TreeLineColor;
        inc(X1, 2);
      end;
    end
    else
    begin
      Canvas.MoveTo(X1, Y);
      Canvas.LineTo(X2, Y);
    end;
  end;

  function DrawTreeLines(CurNode: TTreeNode): integer;
  // paints tree lines, returns indent
  var
    CurMid: integer;
  begin
    if (CurNode <> nil) and ((tvoShowRoot in Options) or (CurNode.Parent<>nil)) then
    begin
      Result := DrawTreeLines(CurNode.Parent);
      if ShowLines then
      begin
        CurMid := Result + (Indent shr 1);
        if CurNode = Node then
        begin
          // draw horizontal line
          if HasExpandSign then
            DrawHorzLine(VertMid, CurMid + FExpandSignSize div 2, Result + Indent)
          else
            DrawHorzLine(VertMid, CurMid, Result + Indent);
        end;

        if (CurNode.GetNextVisibleSibling <> nil) then
        begin
          // draw vertical line to next brother
          if (CurNode = Node) and HasExpandSign then
          begin
            if (Node.Parent = nil) and (Node.GetPrevSibling = nil) then
              DrawVertLine(CurMid, VertMid + FExpandSignSize div 2, NodeRect.Bottom)
            else
            begin
              DrawVertLine(CurMid, NodeRect.Top, Max(NodeRect.Top, VertMid - FExpandSignSize div 2));
              DrawVertLine(CurMid, VertMid + FExpandSignSize div 2 + VertDelta, NodeRect.Bottom);
            end;
          end
          else
          if (Node.Parent = nil) and (Node.GetPrevSibling = nil) then
            DrawVertLine(CurMid, VertMid + VertDelta, NodeRect.Bottom)
          else
            DrawVertLine(CurMid, NodeRect.Top, NodeRect.Bottom);
        end else
        if (CurNode = Node) then
        begin
          // draw vertical line from top to horizontal line
          if HasExpandSign then
          begin
            if ((InsertMarkNode = Node) and (InsertMarkType = tvimAsNextSibling)) then
            begin
              DrawVertLine(CurMid, NodeRect.Top, Max(NodeRect.Top, VertMid - FExpandSignSize div 2));
              DrawVertLine(CurMid, VertMid + FExpandSignSize div 2, NodeRect.Bottom - 1);
            end
            else
              DrawVertLine(CurMid, NodeRect.Top, VertMid - FExpandSignSize div 2);
          end
          else
          if ((InsertMarkNode = Node) and (InsertMarkType = tvimAsNextSibling)) then
            DrawVertLine(CurMid, NodeRect.Top, NodeRect.Bottom - 1)
          else
            DrawVertLine(CurMid, NodeRect.Top, VertMid);
        end;
      end;
      inc(Result, Indent);
    end else
    begin
      Result := BorderWidth - FScrolledLeft;
      if CurNode <> nil then // indent first level of tree with ShowRoot = false a bit
        inc(Result, Indent shr 2);
    end;
  end;

  procedure DrawExpandSign(MidX, MidY: integer; CollapseSign: boolean);
  const
    PlusMinusDetail: array[Boolean {Hot}, Boolean {Expanded}] of TThemedTreeview =
    (
      (ttGlyphClosed, ttGlyphOpened),
      (ttHotGlyphClosed, ttHotGlyphOpened)
    );
  var
    HalfSize, ALeft, ATop, ARight, ABottom: integer;
    Points: PPoint;
    Details: TThemedElementDetails;
    R: TRect;
    PrevColor: TColor;
  const
    cShiftHorzArrow = 2; //paint horz arrow N pixels upper than MidY
  begin
    HalfSize := FExpandSignSize div 2;
    if not Odd(FExpandSignSize) then
      Dec(HalfSize);
    ALeft := MidX - HalfSize;
    ATop := MidY - HalfSize;
    ARight := ALeft + FExpandSignSize;
    ABottom := ATop + FExpandSignSize;

    if Assigned(FOnCustomDrawArrow) then
    begin
      FOnCustomDrawArrow(Self, Rect(ALeft, ATop, ARight, ABottom), not CollapseSign);
      Exit
    end;

    with Canvas do
    begin
      Pen.Color := FExpandSignColor;
      Pen.Style := psSolid;
      case ExpandSignType of
      tvestTheme:
        begin
          // draw a themed expand sign. Todo: track hot
          R := Rect(ALeft, ATop, ARight + 1, ABottom + 1);
          Details := ThemeServices.GetElementDetails(PlusMinusDetail[False, CollapseSign]);
          ThemeServices.DrawElement(Canvas.Handle, Details, R, nil);
        end;
      tvestPlusMinus:
        begin
          // draw a plus or a minus sign
          R := Rect(ALeft, ATop, ARight, ABottom);
          Rectangle(R);
          MoveTo(R.Left + 2, MidY);
          LineTo(R.Right - 2, MidY);
          if not CollapseSign then
          begin
            MoveTo(MidX, R.Top + 2);
            LineTo(MidX, R.Bottom - 2);
	  end;
        end;
      tvestArrow,
      tvestArrowFill:
        begin
          // draw an arrow. down for collapse and right for expand
          R := Rect(ALeft, ATop, ARight, ABottom);
          GetMem(Points, SizeOf(TPoint) * 3);
          if CollapseSign then
          begin
            // draw an arrow down
            Points[0] := Point(R.Left, MidY - cShiftHorzArrow);
            Points[1] := Point(R.Right - 1, MidY - cShiftHorzArrow);
            Points[2] := Point(MidX, R.Bottom - 1 - cShiftHorzArrow);
          end else
          begin
            // draw an arrow right
            Points[0] := Point(MidX - 1, ATop);
            Points[1] := Point(R.Right - 2, MidY);
            Points[2] := Point(MidX - 1, R.Bottom - 1);
          end;

          if ExpandSignType = tvestArrowFill then
          begin
            PrevColor := Brush.Color;
            Brush.Color := ExpandSignColor;
          end;
          Polygon(Points, 3, False);
          if ExpandSignType = tvestArrowFill then
          begin
            Brush.Color := PrevColor;
          end;

          FreeMem(Points);
        end;
      end;
    end;
  end;

  procedure DrawInsertMark;
  var
    InsertMarkRect: TRect;
    x: Integer;
  begin
    case InsertMarkType of

    tvimAsFirstChild:
      if InsertMarkNode=Node then begin
        // draw insert mark for new first child
        with Canvas do begin
          // draw virtual tree line
          Pen.Color:=TreeLineColor;
          // Pen.Style:=TreeLinePenStyle; ToDo: not yet implemented in all widgetsets
          x:=Node.DisplayExpandSignRight+Indent div 2;
          MoveTo(x,NodeRect.Bottom-3);
          LineTo(x,NodeRect.Bottom-2);
          x:=Node.DisplayExpandSignRight+Indent;
          LineTo(x,NodeRect.Bottom-2);
          Pen.Style:=psSolid;

          // draw virtual rectangle
          Pen.Color:=TreeLineColor;
          Brush.Color:=FSelectedColor;
          InsertMarkRect:=Rect(x,NodeRect.Bottom-3,
                               NodeRect.Right,NodeRect.Bottom-1);
          Rectangle(InsertMarkRect);
        end;
      end;

    tvimAsPrevSibling:
      if InsertMarkNode=Node then begin
        // draw insert mark for new previous sibling
        with Canvas do begin
          // draw virtual tree line
          Pen.Color:=TreeLineColor;
          //Pen.Style:=TreeLinePenStyle; ToDo: not yet implemented in all widgetsets
          x:=Node.DisplayExpandSignLeft+Indent div 2;
          MoveTo(x,NodeRect.Top+1);
          x:=Node.DisplayExpandSignRight;
          LineTo(x,NodeRect.Top+1);
          Pen.Style:=psSolid;

          // draw virtual rectangle
          Pen.Color:=TreeLineColor;
          Brush.Color:=FSelectedColor;
          InsertMarkRect:=Rect(x,NodeRect.Top,
                               NodeRect.Right,NodeRect.Top+2);
          Rectangle(InsertMarkRect);
        end;
      end;

    tvimAsNextSibling:
      if InsertMarkNode=Node then begin
        // draw insert mark for new next sibling
        with Canvas do begin
          // draw virtual tree line
          Pen.Color:=TreeLineColor;
          //Pen.Style:=TreeLinePenStyle; ToDo: not yet implemented in all widgetsets
          x:=Node.DisplayExpandSignLeft+Indent div 2;
          MoveTo(x,NodeRect.Bottom-3);
          LineTo(x,NodeRect.Bottom-2);
          x:=Node.DisplayExpandSignRight;
          LineTo(x,NodeRect.Bottom-2);
          Pen.Style:=psSolid;

          // draw virtual rectangle
          Pen.Color:=TreeLineColor;
          Brush.Color:=FSelectedColor;
          InsertMarkRect:=Rect(x,NodeRect.Bottom-3,
                               NodeRect.Right,NodeRect.Bottom-1);
          Rectangle(InsertMarkRect);
        end;
      end;

    end;
  end;

  procedure DrawBackground(IsSelected: Boolean; ARect: TRect);
  var
    Details: TThemedElementDetails;
    CurBackgroundColor: TColor;
  begin
    if (tvoRowSelect in Options) and IsSelected then
      if tvoThemedDraw in Options then
      begin
        if tvoFocusedPainting in FStates then
          Details := ThemeServices.GetElementDetails(ttItemSelected)
        else
          Details := ThemeServices.GetElementDetails(ttItemSelectedNotFocus);
        if ThemeServices.HasTransparentParts(Details) then
        begin
          Canvas.Brush.Color := BackgroundColor;
          Canvas.FillRect(ARect);
        end;
        ThemeServices.DrawElement(Canvas.Handle, Details, ARect, nil);
        Exit;
      end
      else
        CurBackgroundColor := FSelectedColor
    else
      CurBackgroundColor := FBackgroundColor;
    if CurBackgroundColor <> clNone then
    begin
      Canvas.Brush.Color := CurBackgroundColor;
      Canvas.FillRect(ARect);
    end;
  end;

  procedure DrawNodeText(IsSelected: Boolean; NodeRect: TRect; AText: String);
  var
    Details: TThemedElementDetails;
  begin
    if IsSelected then
    begin
      if tvoFocusedPainting in FStates then
        Details := ThemeServices.GetElementDetails(ttItemSelected)
      else
        Details := ThemeServices.GetElementDetails(ttItemSelectedNotFocus);
      if not (tvoRowSelect in Options) then
        if (tvoThemedDraw in Options) then
          ThemeServices.DrawElement(Canvas.Handle, Details, NodeRect, nil)
        else
        begin
          Canvas.Brush.Color := FSelectedColor;
          Canvas.Font.Color := InvertColor(Brush.Color);
          Canvas.FillRect(NodeRect);
        end
      else
      if not (tvoThemedDraw in Options) then
      begin
        //Canvas.Font.Color := Font.Color;
        Canvas.Brush.Color := FSelectedColor;
        Canvas.Font.Color := InvertColor(Brush.Color);
        Canvas.FillRect(NodeRect);
      end;
    end
    else
      Details := ThemeServices.GetElementDetails(ttItemNormal);

    if (tvoThemedDraw in Options) then
      ThemeServices.DrawText(Canvas, Details, AText, NodeRect, DT_CENTER or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX, 0)
    else
      DrawText(Canvas.Handle, PChar(AText), -1, NodeRect, DT_CENTER or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX);
  end;


var
  x, ImgIndex: integer;
  CurTextRect: TRect;
  DrawState: TCustomDrawState;
  PaintImages: boolean;
  OverlayIndex: Integer;
begin
  NodeRect := Node.DisplayRect(False);
  if (NodeRect.Bottom < 0) or (NodeRect.Top >= (ClientHeight - ScrollBarWidth)) then
    Exit;
  NodeSelected := (Node.Selected) or (Node.MultiSelected);
  Canvas.Font.Color := Font.Color;
  PaintImages := True;
  if IsCustomDrawn(dtItem, cdPrePaint) then
  begin
    DrawState := [];
    if NodeSelected then
      Include(DrawState, cdsSelected);
    if Node.Focused then
      Include(DrawState, cdsFocused);
    if Node.MultiSelected then
      Include(DrawState, cdsMarked);
    if not CustomDrawItem(Node, DrawState, cdPrePaint, PaintImages) then Exit;
  end;

  VertMid := (NodeRect.Top + NodeRect.Bottom) div 2;
  HasExpandSign := ShowButtons and Node.HasChildren and ((tvoShowRoot in Options) or (Node.Parent <> nil));
  VertDelta := Ord(FDefItemHeight and 3 = 2);
  //DebugLn(['[TCustomTreeView.DoPaintNode] Node=',DbgS(Node),' Node.Text=',Node.Text,' NodeRect=',NodeRect.Left,',',NodeRect.Top,',',NodeRect.Right,',',NodeRect.Bottom,' VertMid=',VertMid]);
  with Canvas do
  begin
    // draw background
    DrawBackground(NodeSelected, NodeRect);

    // draw tree lines
    Pen.Color := TreeLineColor;
    Pen.Style := TreeLinePenStyle;
    x := DrawTreeLines(Node);
    Pen.Style := psSolid;

    // draw expand sign
    if HasExpandSign then
      DrawExpandSign(x - Indent + (Indent shr 1), VertMid, Node.Expanded);

    // draw state icon
    if (StateImages <> nil) then
    begin
      if (Node.StateIndex >= 0) and (Node.StateIndex < StateImages.Count) then
      begin
        if PaintImages then
          StateImages.Draw(Canvas, x + 1, (NodeRect.Top + NodeRect.Bottom - StateImages.Height) div 2,
            Node.StateIndex, True);
        Inc(x, StateImages.Width + 2);
      end;
    end;

    // draw icon
    if (Images <> nil) then
    begin
      if FSelectedNode <> Node then
      begin
      	GetImageIndex(Node);
        ImgIndex := Node.ImageIndex
      end
      else
      begin
      	GetSelectedIndex(Node);
        ImgIndex := Node.SelectedIndex;
      end;
      if (ImgIndex >= 0) and (ImgIndex < Images.Count) then
      begin
        if PaintImages then
        begin
      	  if (Node.OverlayIndex >= 0) then begin
            OverlayIndex:=Node.OverlayIndex;
            if Images.HasOverlays then begin
              Images.DrawOverlay(Canvas, x + 1, (NodeRect.Top + NodeRect.Bottom - Images.Height) div 2,
                 ImgIndex, OverlayIndex, Node.FNodeEffect);
            end else begin
              // draw the Overlay using the image from the list
              // set an Overlay
              Images.OverLay(OverlayIndex,0);
              // draw overlay
              Images.DrawOverlay(Canvas, x + 1, (NodeRect.Top + NodeRect.Bottom - Images.Height) div 2,
                 ImgIndex, 0, Node.FNodeEffect);
              // reset the Overlay
              Images.OverLay(-1,0);
            end;
          end
          else begin
            Images.Draw(Canvas, x + 1, (NodeRect.Top + NodeRect.Bottom - Images.Height) div 2,
               ImgIndex, Node.FNodeEffect);
          end;
       end;
       Inc(x, Images.Width + 2);
      end;
    end;

    // draw text
    if Node.Text <> '' then
    begin
      CurTextRect := NodeRect;
      CurTextRect.Left := x;
      CurTextRect.Right := x + TextWidth(Node.Text) + Indent div 2;
      DrawNodeText(NodeSelected, CurTextRect, Node.Text);
    end;

    // draw separator
    if (tvoShowSeparators in FOptions) then
    begin
      Pen.Color:=SeparatorColor;
      MoveTo(NodeRect.Left,NodeRect.Bottom-1);
      LineTo(NodeRect.Right,NodeRect.Bottom-1);
    end;

    // draw insert mark
    DrawInsertMark;
  end;
  PaintImages := true;
  if IsCustomDrawn(dtItem, cdPostPaint) then
  begin
    DrawState:=[];
    if Node.Selected then
      Include(DrawState,cdsSelected);
    if Node.Focused then
      Include(DrawState,cdsFocused);
    if Node.MultiSelected then
      Include(DrawState,cdsMarked);
    if not CustomDrawItem(Node,DrawState,cdPostPaint,PaintImages) then exit;
  end;
end;

end.

