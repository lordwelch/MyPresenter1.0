unit Data;

{$mode objfpc}{$H+}

interface

uses
  cmem, Classes, SysUtils, Grids, laz2_DOM, laz2_XMLWrite, laz2_XMLRead, BGRABitmap,
  BGRABitmapTypes, Graphics, Forms, Dialogs, resize, mygrids;

type
  TBGRABitmapArray = array of TBGRACustomBitmap;


var
  CurrentSlide, NextSlide, goEditingIndex: Integer;
  //AHeight, AWidth: Array of Integer;
  TextOutline: Real;
  TextStyle: TTextStyle;
  ImagePath, SGridOptions, SupportedImages: TStringList; //file path for images
  GridOptions: TGridOptions;
  GridImageList: array of TBGRABitmapArray;
  Background: TBGRABitmap;
  AColor: TBGRAPixel;
  MonitorPro: TMonitor;
  Monitornum: Integer;

  procedure ShowSett();
  procedure ShowAbt();
  procedure ShowPrjctr();
  procedure readXML(Filename: string);
  procedure SaveXML();
  procedure GetScreens();
  procedure LoadSupportedImages();
  procedure LoadImages();
  procedure FreeImage();
  function SortFiles(List: TStrings):TStrings; overload;
  function SortFiles(List: array of string):TStrings; overload;




implementation
  uses settings, Projector, uabout, main_code;

procedure ShowSett;
begin
  FrmSettings.Show;
end;

procedure ShowAbt;
begin
  frmAbout.Show;
end;

procedure ShowPrjctr;
begin
  frmProjector.Show;
end;

procedure readXML(Filename: string);
var
  PassNode: TDOMNode;
  Doc: TXMLDocument;
  NodeText: AnsiString;
begin
  if not (FileExists(Filename)) then
     SaveXML();
  try
        // Read in xml file from disk
    ReadXMLFile(Doc, filename);

        // print the Slide_font node
    PassNode := Doc.DocumentElement.FirstChild.FindNode('Slide_font');
      NodeText := PassNode.FirstChild.NodeValue;
        Form1.Memo1.Append('Slide Font: ' + NodeText);
          FrmSettings.SlideFont.Font.Name := NodeText;
      NodeText := PassNode.Attributes.GetNamedItem('Size').TextContent;
        Form1.Memo1.Append('Slide Font Size: ' + NodeText);
          FrmSettings.SlideFont.Font.Size := StrToInt(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Bold').TextContent;
        Form1.Memo1.Append('Slide Font Bold: ' + NodeText);
          FrmSettings.SlideFont.Font.Bold := StrToBool(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Italic').TextContent;
        Form1.Memo1.Append('Slide Font Italic: ' + NodeText);
          FrmSettings.SlideFont.Font.Italic := StrToBool(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Underline').TextContent;
        Form1.Memo1.Append('Slide Font Underline: ' + NodeText);
          FrmSettings.SlideFont.Font.Underline := StrToBool(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Color').TextContent;
        Form1.Memo1.Append('Slide Font Color: ' + NodeText);
          AColor := StrToBGRA(NodeText);

        // print the Grid_font node
    PassNode := Doc.DocumentElement.FirstChild.FindNode('Grid_font');
      NodeText := PassNode.FirstChild.NodeValue;
        Form1.Memo1.Append('Grid Font: ' + NodeText);
         FrmSettings.GridFont.Font.Name := NodeText;
      NodeText := PassNode.Attributes.GetNamedItem('Size').TextContent;
        Form1.Memo1.Append('Grid Font Size: ' + NodeText);
          FrmSettings.GridFont.Font.Size := StrToInt(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Bold').TextContent;
        Form1.Memo1.Append('Grid Font Bold: ' + NodeText);
          FrmSettings.GridFont.Font.Bold := StrToBool(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Italic').TextContent;
        Form1.Memo1.Append('Grid Font Italic: ' + NodeText);
          FrmSettings.GridFont.Font.Italic := StrToBool(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Underline').TextContent;
        Form1.Memo1.Append('Grid Font Underline: ' + NodeText);
          FrmSettings.GridFont.Font.Underline := StrToBool(NodeText);

    Form1.Grid.Font := FrmSettings.GridFont.Font;


        // Retrieve the "Text outline" node
    PassNode := Doc.DocumentElement.FirstChild.FindNode('Text_outline');
      NodeText := PassNode.FirstChild.NodeValue;
        Form1.Memo1.Append('Outline Width: ' + NodeText);
          FrmSettings.SpinEdit3.Value:=StrToFloat(NodeText);

    if not (Doc.DocumentElement.FirstChild.FindNode('Grid_options') = nil) then
      begin
        PassNode := Doc.DocumentElement.FirstChild.FindNode('Grid_options');
        if PassNode.HasChildNodes then
          NodeText := PassNode.FirstChild.NodeValue;
            if NodeText = 'goEditing' then
              begin
              {  Form1.Memo1.Append('GridOptions: On');
                Form1.Grid.Options:= GridOptions + [goEditing];
                Form1.Grid.AutoEdit:=True;
                FrmSettings.Button3.Tag:=0;
                FrmSettings.Button3.Caption := 'make read-only';}
                FrmSettings.btnEditableClick(FrmSettings.btnEditable);
              end
            else
              Form1.Memo1.Append('GridOptions: Off');
     end;
  finally
        // finally, free the document
    Doc.Free;
  end;
end;

procedure SaveXML;
var
  Doc: TXMLDocument;
  RootNode, ElementNode,ItemNode,TextNode: TDOMNode;
  //i: integer;
begin
  try
        // Create a document
    Doc := TXMLDocument.Create;
        // Create a root node
    RootNode := Doc.CreateElement('Root');
    Doc.AppendChild(RootNode);
    RootNode:= Doc.DocumentElement;
        // Create settings
    ElementNode:=Doc.CreateElement('Settings');
        //writeln('Settings');

        //save font of text on the slide
    ItemNode:=Doc.CreateElement('Slide_font');
    TDOMElement(ItemNode).SetAttribute('Size', IntToStr(FrmSettings.SlideFont.Font.Size));
    TDOMElement(ItemNode).SetAttribute('Bold', BoolToStr(FrmSettings.SlideFont.Font.Bold, '1', '0'));
    TDOMElement(ItemNode).SetAttribute('Italic', BoolToStr(FrmSettings.SlideFont.Font.Italic, '1', '0'));
    TDOMElement(ItemNode).SetAttribute('Underline', BoolToStr(FrmSettings.SlideFont.Font.Underline, '1', '0'));
    TDOMElement(ItemNode).SetAttribute('Color', BGRAToStr(AColor));
    TextNode:=Doc.CreateTextNode(FrmSettings.SlideFont.Font.Name);
    ItemNode.AppendChild(TextNode);
    ElementNode.AppendChild(ItemNode);

        //save font of text in grid
    ItemNode:=Doc.CreateElement('Grid_font');
    TDOMElement(ItemNode).SetAttribute('Size', IntToStr(FrmSettings.GridFont.Font.Size));

    TDOMElement(ItemNode).SetAttribute('Bold', BoolToStr(FrmSettings.GridFont.Font.Bold, '1', '0'));
    TDOMElement(ItemNode).SetAttribute('Italic', BoolToStr(FrmSettings.GridFont.Font.Italic, '1', '0'));
    TDOMElement(ItemNode).SetAttribute('Underline', BoolToStr(FrmSettings.GridFont.Font.Underline, '1', '0'));
    TextNode:=Doc.CreateTextNode(FrmSettings.GridFont.Font.Name);
    ItemNode.AppendChild(TextNode);
    ElementNode.AppendChild(ItemNode);

        //save the grid options
    if goEditingIndex = 0 then
    begin
      ItemNode:=Doc.CreateElement('Grid_options'); TextNode:=Doc.CreateTextNode(SGridOptions.ValueFromIndex[goEditingIndex]);
      ItemNode.AppendChild(TextNode);
      ElementNode.AppendChild(ItemNode);
    end;

        //width of the outline surrounding text
    ItemNode:=Doc.CreateElement('Text_outline'); TextNode:=Doc.CreateTextNode(FrmSettings.SpinEdit3.ValueToStr(FrmSettings.SpinEdit3.Value));
    ItemNode.AppendChild(TextNode);
    ElementNode.AppendChild(ItemNode);

        //save path of image
    {if ImagePath.Count > 0 then
    begin
      for i := 0 to ImagePath.Count do
      begin
      //writeln('loop');
        //TDOMElement(ElementNode).SetAttribute('id', IntToStr(i));
        ItemNode:=Doc.CreateElement('Image'+ IntToStr(i));
        TDOMElement(ItemNode).SetAttribute('Attr1', IntToStr(i));
        TDOMElement(ItemNode).SetAttribute('Attr2', IntToStr(i));
        TextNode:=Doc.CreateTextNode(ImagePath.Strings[i]);
        ItemNode.AppendChild(TextNode);
        ElementNode.AppendChild(ItemNode);
        //RootNode.AppendChild(ElementNode);
      end;
    end; }

    RootNode.AppendChild(ElementNode);

        // Save XML
    WriteXMLFile(Doc,'TestXML_v2.xml');
  finally
    Doc.Free;
  end;
end;

procedure GetScreens;
var numMonitors, Monitors: Integer;
begin
  Screen.UpdateMonitors;
  Screen.UpdateScreen;
  numMonitors := Screen.MonitorCount;
  if numMonitors > 1 then
    Monitors := StrToInt(InputBox('Monitor selection', 'please select a monitor' + IntToStr(numMonitors), '1'))
  else
    begin
    ShowMessage('No second monitor!!! :-(');
    Monitors := 0
    end;
  Monitornum:=Monitors;
  MonitorPro := Screen.Monitors[Monitors];
  Form1.Memo1.Append(IntToStr(MonitorPro.Left));

end;

procedure LoadSupportedImages;
begin
  SupportedImages:= TStringList.Create;
  SupportedImages.Duplicates:=dupIgnore;
  with SupportedImages do
  begin
    Add('.jpg');
    Add('.jpeg');
    Add('.png');
    Add('.gif');
    Add('.pcx');
    Add('.bmp');
    Add('.ico');
    Add('.cur');
    Add('.pdn');
    Add('.lzp');
    Add('.ora');
    Add('.psd');
    Add('.tga');
    Add('.tif');
    Add('.tiff');
    Add('.xwd');
    Add('.xpm');
  end;
  form1.OpenDialog1.Filter:='Supported Images|*.jpg;*.jpeg;*.png;*.gif;*.pcx;*.bmp;*.ico;*.cur;*.pdn;*.lzp;*.ora;*.psd;*.tga;*.tif;*.tiff;*.xwd;*.xpm';
end;

procedure LoadImages();
var
  i, gridint: Integer;
  LoadBGRA, PutBGRA: TBGRABitmap;
begin
  gridint:=(Length(GridImageList[0]));
  SetLength(GridImageList, 2, gridint+ImagePath.Count);
  for i := 0 to (ImagePath.Count - 1) do
    begin

      try
      LoadBGRA:=TBGRABitmap.Create(ImagePath.Strings[i]);
      Application.ProcessMessages;
      Form1.Memo1.Append(ImagePath.Strings[i]);

      Application.ProcessMessages;

      GridImageList[0, i+gridint]:=TBGRABitmap.Create(MonitorPro.Width, MonitorPro.Height);
      //GridImageList[1, i+gridint]:=TBGRABitmap.Create(Form1.Grid.Columns[1].Width, Form1.Grid.RowHeights[1]);
      AColor:= BGRABlack;
      PutBGRA:=TBGRABitmap.Create(MonitorPro.Width, MonitorPro.Height, AColor);
      PutBGRA.PutImage(0, 0, ResizeImage(LoadBGRA, MonitorPro.Width, MonitorPro.Height), dmSet);
      GridImageList[0, (i+gridint)].PutImage(0, 0, PutBGRA, dmSet);
      GridImageList[1, (i+gridint)]:=ResizeImage(LoadBGRA, Form1.Grid.Columns[1].Width, Form1.Grid.RowHeights[1], false, false);
      //.add((PutBGRA).Bitmap, nil);
      Form1.Memo1.Append(IntToStr(i));
      Form1.Grid.InsertColRow(False, Form1.Grid.RowCount);
      Form1.Grid.CellImage[1, Form1.Grid.RowCount-1]:=TBGRABitmap(GridImageList[0, (i+gridint)]);
      Form1.Grid.CellImage[2, Form1.Grid.RowCount-1]:=TBGRABitmap(GridImageList[1, (i+gridint)]);
      //AHeight[i+LenH]:=height;
      //AWidth[i+LenW]:=width;
      finally
        PutBGRA.Free;
      LoadBGRA.Free;
      end;
    end;
  //Form1.Memo1.Append('');
  //Form1.Memo1.Append('height: ' + IntToStr(GridImageList.Height) + 'width: ' + IntToStr(GridImageList.Width));
  //Form1.Memo1.Append(IntToStr(GridImageList.Count));
  Form1.Memo1.Append('done');
  i:=0;
end;

procedure FreeImage;
var i: Integer;
begin
  for i:=0 to Length(GridImageList[0])-1 do
    GridImageList[0, i].Free;
  for i:=0 to Length(GridImageList[1])-1 do
    GridImageList[1, i].Free;
  SetLength(GridImageList, 0, 0);
end;

function SortFiles(List: TStrings): TStrings;
  var i: Integer;
  ext: string;
begin
  for i := 0 to (List.Count - 1) do
  begin
    form1.Memo1.Append('item: ' + IntToStr(i));
    ext := ExtractFileExt(List.Names[i]);
    Delete(ext, 1, 2);
    ext:=LowerCase(ext);
    if (SupportedImages.IndexOf('.' + ext) <> -1) then
      begin
        Form1.Memo1.Append('Error: ' + IntToStr(i) + '.' + ext);
        List.Delete(i);
        //ImagePath.Add(List[i])
      end;
  end;

  Result:= List;
end;

function SortFiles(List: array of string): TStrings;
  var i: Integer;
  ext, comp: string;
  list1: TStrings;
begin
  list1:= TStringList.Create;
 { for i := 0 to (Length(List) - 1) do
  begin
    ext := ExtractFileExt(List[i]);
    Delete(ext, 1, 1);
    comp:=LowerCase(ext);
    if SupportedImages.IndexOf('.' + comp) <> -1 then
     begin
     Form1.Memo1.Append(IntToStr(i) + '.' + ext);
     list1.Add(list[i]);
     end;
  end;}
  list1.AddStrings(List);
  SortFiles(list1);
  Result:= List1;
end;

end.
