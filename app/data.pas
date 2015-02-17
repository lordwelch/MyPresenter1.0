unit Data;

{$mode objfpc}{$H+}

interface

uses
  cmem, Classes, SysUtils, Grids, laz2_DOM, laz2_XMLWrite, laz2_XMLRead, BGRABitmap,
  BGRABitmapTypes, Graphics, Forms, Dialogs, resize, mygrids, LCLProc;

type
  TBGRABitmapArray = array of TBGRABitmap;
  slidestrings = record
  SlideNotes, SlideVideos, SlideText: TStringList;
  end;


var
  CurrentSlide, NextSlide, goEditingIndex: Integer;
  //AHeight, AWidth: Array of Integer;
  TextOutline: Real;
  TextStyle: TTextStyle;
  ImagePath, SGridOptions, SupportedImages: TStringList; //file path for images
  GridOptions: TGridOptions;
  DialogOptions: TOpenOptions;
  GridImageList: array of TBGRABitmapArray;
  Background: TBGRABitmap;
  AColor, OutColor: TBGRAPixel;
  MonitorPro: TMonitor;
  Monitornum: Integer;
  strings: slidestrings;
  SlideFile: string;

  procedure ShowSett();
  procedure ShowAbt();
  procedure ShowPrjctr();
  procedure readXMLConfig(Filename: string);
  procedure SaveXMLConfig(Filename: string);
  procedure SaveXMLSlide(Filename: string);
  procedure readXMLSlide(Filename: string);
  procedure GetScreens();
  procedure LoadSupportedImages();
  procedure LoadImageList(str: TStringList);
  procedure LoadImage(str: string);
  procedure FreeImage();
  function SortFiles(List: String):String;



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

procedure readXMLConfig(Filename: string);
var
  PassNode: TDOMNode;
  Doc: TXMLDocument;
  NodeText: AnsiString;
begin
  if not (FileExists(Filename)) then
     SaveXMLConfig(Filename);
  try
        // Read in xml file from disk
    ReadXMLFile(Doc, filename);

        // print the Slide_font node
    PassNode := Doc.DocumentElement.FindNode('Slide_font');
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
    PassNode := Doc.DocumentElement.FindNode('Grid_font');
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
    PassNode := Doc.DocumentElement.FindNode('Text_outline');
      NodeText := PassNode.FirstChild.NodeValue;
        Form1.Memo1.Append('Outline Width: ' + NodeText);
          FrmSettings.SpinEdit3.Value:=StrToFloat(NodeText);

    if not (Doc.DocumentElement.FindNode('Grid_options') = nil) then
      begin
        PassNode := Doc.DocumentElement.FindNode('Grid_options');
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

procedure SaveXMLConfig(Filename: string);
var
  Doc: TXMLDocument;
  RootNode, ItemNode,TextNode: TDOMNode;
  //i: integer;
begin
  try
        // Create a document
    Doc := TXMLDocument.Create;
        // Create a root node
    RootNode := Doc.CreateElement('Settings');
    Doc.AppendChild(RootNode);
    RootNode:= Doc.DocumentElement;
        // Create settings
    //ElementNode:=Doc.CreateElement('Settings');
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
    //ElementNode.AppendChild(ItemNode);
    RootNode.AppendChild(ItemNode);

        //save font of text in grid
    ItemNode:=Doc.CreateElement('Grid_font');
    TDOMElement(ItemNode).SetAttribute('Size', IntToStr(FrmSettings.GridFont.Font.Size));

    TDOMElement(ItemNode).SetAttribute('Bold', BoolToStr(FrmSettings.GridFont.Font.Bold, '1', '0'));
    TDOMElement(ItemNode).SetAttribute('Italic', BoolToStr(FrmSettings.GridFont.Font.Italic, '1', '0'));
    TDOMElement(ItemNode).SetAttribute('Underline', BoolToStr(FrmSettings.GridFont.Font.Underline, '1', '0'));
    TextNode:=Doc.CreateTextNode(FrmSettings.GridFont.Font.Name);
    ItemNode.AppendChild(TextNode);
    //ElementNode.AppendChild(ItemNode);
    RootNode.AppendChild(ItemNode);

        //save the grid options
    if goEditingIndex = 0 then
    begin
      ItemNode:=Doc.CreateElement('Grid_options'); TextNode:=Doc.CreateTextNode(SGridOptions.ValueFromIndex[goEditingIndex]);
      ItemNode.AppendChild(TextNode);
      //ElementNode.AppendChild(ItemNode);
      RootNode.AppendChild(ItemNode);
    end;

        //width of the outline surrounding text
    ItemNode:=Doc.CreateElement('Text_outline'); TextNode:=Doc.CreateTextNode(FrmSettings.SpinEdit3.ValueToStr(FrmSettings.SpinEdit3.Value));
    ItemNode.AppendChild(TextNode);
    //ElementNode.AppendChild(ItemNode);
    RootNode.AppendChild(ItemNode);




    //RootNode.AppendChild(ElementNode);

        // Save XML
    WriteXMLFile(Doc,Filename);
  finally
    Doc.Free;
  end;
end;

procedure SaveXMLSlide(Filename: string);
var
  Doc: TXMLDocument;
  RootNode, ItemNode,TextNode: TDOMNode;
  x, i: integer;
  isVideo: Boolean;
begin
  try
    x:=Form1.Grid.RowCount-1;
        // Create a document
    Doc := TXMLDocument.Create;
        // Create a root node
    RootNode := Doc.CreateElement('Slides');
    Doc.AppendChild(RootNode);
    RootNode:= Doc.DocumentElement;
    TDOMElement(RootNode).SetAttribute('Count', IntToStr(x));
        // Create settings
    //ElementNode:=Doc.CreateElement('Settings');
        //writeln('Settings');

        //save font of text on the slide
    for i:=1 to x do
    begin
      ItemNode:=Doc.CreateElement('Slide_'+IntToStr(i));
      TDOMElement(ItemNode).SetAttribute('ImageLocation', ImagePath.Strings[i-1]);
      WriteLn(ImagePath.Names[i-1]);
      isVideo:=Form1.Grid.Cells[1, i].IsVideo;
      TDOMElement(ItemNode).SetAttribute('isVideo', BoolToStr(IsVideo, '1', '0'));
      if isVideo then
        TDOMElement(ItemNode).SetAttribute('VideoLocation', BoolToStr(FrmSettings.SlideFont.Font.Italic, '1', '0'));
      //TDOMElement(ItemNode).SetAttribute('Text', Form1.Grid.SlideText[1, i]);
      TDOMElement(ItemNode).SetAttribute('Note', form1.Grid.SlideNote[1, i]);
      //TDOMElement(ItemNode).SetAttribute('Color', BGRAToStr(AColor));
      //TextNode:=Doc.CreateTextNode(Form1.Grid.SlideText[1, i]);
      //ItemNode.AppendChild(TextNode);
      //ElementNode.AppendChild(ItemNode);
      TDOMElement(ItemNode).SetAttribute('Text', form1.Grid.SlideText[1, i]);
      RootNode.AppendChild(ItemNode);
    end;
    {
        //save font of text in grid
    ItemNode:=Doc.CreateElement('Grid_font');
    TDOMElement(ItemNode).SetAttribute('Size', IntToStr(FrmSettings.GridFont.Font.Size));

    TDOMElement(ItemNode).SetAttribute('Bold', BoolToStr(FrmSettings.GridFont.Font.Bold, '1', '0'));
    TDOMElement(ItemNode).SetAttribute('Italic', BoolToStr(FrmSettings.GridFont.Font.Italic, '1', '0'));
    TDOMElement(ItemNode).SetAttribute('Underline', BoolToStr(FrmSettings.GridFont.Font.Underline, '1', '0'));
    TextNode:=Doc.CreateTextNode(FrmSettings.GridFont.Font.Name);
    ItemNode.AppendChild(TextNode);
    //ElementNode.AppendChild(ItemNode);
    RootNode.AppendChild(ItemNode);

        //save the grid options
    if goEditingIndex = 0 then
    begin
      ItemNode:=Doc.CreateElement('Grid_options'); TextNode:=Doc.CreateTextNode(SGridOptions.ValueFromIndex[goEditingIndex]);
      ItemNode.AppendChild(TextNode);
      //ElementNode.AppendChild(ItemNode);
      RootNode.AppendChild(ItemNode);
    end;

        //width of the outline surrounding text
    ItemNode:=Doc.CreateElement('Text_outline'); TextNode:=Doc.CreateTextNode(FrmSettings.SpinEdit3.ValueToStr(FrmSettings.SpinEdit3.Value));
    ItemNode.AppendChild(TextNode);
    //ElementNode.AppendChild(ItemNode);
    RootNode.AppendChild(ItemNode);




    //RootNode.AppendChild(ElementNode);

        // Save XML                           }
    WriteXMLFile(Doc, Filename);
    SlideFile := Filename;
  finally
    Doc.Free;
  end;
end;

procedure readXMLSlide(Filename: string);
  function NewSlide(aNote, aText, aImg: string; aVideo: string = ' '; isVideo: Boolean = False): TSlide;
  var
    S: TSlide;
    img: TBGRABitmap;
    img1: image1;
  begin
    img:=TBGRABitmap.Create(aImg);
    if isVideo then
      S:=TSlide.create(aText, aNote, aVideo, TBGRABitmap(ResizeImage(img, MonitorPro.Width, MonitorPro.Height)))
    else S:=TSlide.create(aText, aNote, aImg, TBGRABitmap(ResizeImage(img, MonitorPro.Width, MonitorPro.Height)));
    Result:=S;
    img1.Img:=TBGRABitmap(ResizeImage(img, Form1.Grid.Columns[1].Width, Form1.Grid.RowHeights[1], false, false));
    img1.ImgPath := aImg;
    Form1.Grid.SlideImage[2, Form1.Grid.RowCount-1] := img1;
    img.Free;
  end;

var
  PassNode: TDOMNode;
  Doc: TXMLDocument;
  NodeText, NodeNote, NodeVideo, NodeImage: AnsiString;
  NodeIsVideo: Boolean;
  i, x: Integer;
begin
  if not (FileExists(Filename)) then
     SaveXMLSlide(Filename);
  try
        // Read in xml file from disk
    ReadXMLFile(Doc, filename);

        // print the Slide_font node
    PassNode := Doc.DocumentElement.FirstChild;
    //Write(doc.DocumentElement.Attributes.Item[0].TextContent);
    NodeText := Doc.DocumentElement.Attributes.Item[0].TextContent;
    x:=StrToInt(NodeText);

    for i:=1 to x do
    begin
    PassNode := Doc.DocumentElement.FindNode('Slide_'+IntToStr(i));
    NodeImage := PassNode.Attributes.GetNamedItem('ImageLocation').TextContent;
    NodeNote := PassNode.Attributes.GetNamedItem('Note').TextContent;
    NodeText := PassNode.Attributes.GetNamedItem('Text').TextContent;
    NodeIsVideo := StrToBool(PassNode.Attributes.GetNamedItem('isVideo').TextContent);
    if NodeIsVideo then
      NodeVideo := PassNode.Attributes.GetNamedItem('VideoLocation').TextContent;
    Form1.Grid.InsertColRow(False, Form1.Grid.RowCount);
    Form1.Grid.Cells[1, Form1.Grid.RowCount-1]:=NewSlide(NodeNote, NodeText, NodeImage);
    end;
     {
      NodeText := PassNode.FirstChild.NodeValue;

          FrmSettings.SlideFont.Font.Name := NodeText;
      NodeText := PassNode.Attributes.GetNamedItem('Size').TextContent;

          FrmSettings.SlideFont.Font.Size := StrToInt(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Bold').TextContent;

          FrmSettings.SlideFont.Font.Bold := StrToBool(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Italic').TextContent;

          FrmSettings.SlideFont.Font.Italic := StrToBool(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Underline').TextContent;

          FrmSettings.SlideFont.Font.Underline := StrToBool(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Color').TextContent;

          AColor := StrToBGRA(NodeText);

        // print the Grid_font node
    PassNode := Doc.DocumentElement.FindNode('Grid_font');
      NodeText := PassNode.FirstChild.NodeValue;

         FrmSettings.GridFont.Font.Name := NodeText;
      NodeText := PassNode.Attributes.GetNamedItem('Size').TextContent;

          FrmSettings.GridFont.Font.Size := StrToInt(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Bold').TextContent;

          FrmSettings.GridFont.Font.Bold := StrToBool(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Italic').TextContent;

          FrmSettings.GridFont.Font.Italic := StrToBool(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Underline').TextContent;

          FrmSettings.GridFont.Font.Underline := StrToBool(NodeText);

    Form1.Grid.Font := FrmSettings.GridFont.Font;


        // Retrieve the "Text outline" node
    PassNode := Doc.DocumentElement.FindNode('Text_outline');
      NodeText := PassNode.FirstChild.NodeValue;

          FrmSettings.SpinEdit3.Value:=StrToFloat(NodeText);

    if not (Doc.DocumentElement.FindNode('Grid_options') = nil) then
      begin
        PassNode := Doc.DocumentElement.FindNode('Grid_options');
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
     end;}
  finally
        // finally, free the document
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
var
  i: Integer;
  str1: String;
begin
  DialogOptions += [ofAllowMultiSelect];
  form1.OpenDialog1.Options := DialogOptions;
  if SupportedImages<>nil then
    SupportedImages.Free;
  SupportedImages:= TStringList.Create;
  SupportedImages.Duplicates:=dupIgnore;
  with SupportedImages do
  begin
    Add( '.jpg' );
    Add( '.jpeg');
    Add( '.png' );
    Add( '.gif' );
    Add( '.pcx' );
    Add( '.bmp' );
    Add( '.ico' );
    Add( '.cur' );
    Add( '.pdn' );
    Add( '.lzp' );
    Add( '.ora' );
    Add( '.psd' );
    Add( '.tga' );
    Add( '.tif' );
    Add( '.tiff');
    Add( '.xwd' );
    Add( '.xpm' );
  end;
  str1:='Supported Images|*.jpg';
  WriteLn(SupportedImages.Count);
  for i:= 1 to (SupportedImages.Count-1) do
    str1+=';*'+SupportedImages.Strings[i];
  Form1.OpenDialog1.Filter:=str1;
  WriteLn(Form1.OpenDialog1.Filter);
end;

procedure LoadImageList(str: TStringList);
var i: Integer;
begin
  for i := 0 to (str.Count - 1) do
    LoadImage(str.Strings[i]);
  Form1.Memo1.Append(IntToStr(str.Capacity)+' done');
end;

procedure LoadImage(str: string);
var
  gridint: Integer;
  LoadBGRA: TBGRABitmap;
  img, img1: image1;
  sttr: string;
begin
  sttr := SortFiles(str);
  if sttr<>'' then
    begin
      try
        gridint:=Length(GridImageList[0]);
        ImagePath.Add(str);
        SetLength(GridImageList, 3, 1+gridint);
        WriteLn(str);
        LoadBGRA:=TBGRABitmap.Create(str);
        Application.ProcessMessages;
        Form1.Memo1.Append(str);
         WriteLn(str+'1');
        GridImageList[0, gridint]:=TBGRABitmap(LoadBGRA.Duplicate(True));
        GridImageList[1, gridint]:=ResizeImage(LoadBGRA, MonitorPro.Width, MonitorPro.Height);
        GridImageList[2, gridint]:=ResizeImage(LoadBGRA, Form1.Grid.Columns[1].Width, Form1.Grid.RowHeights[1], false, false);
        img.Img:=GridImageList[1, gridint];
        img.ImgPath := str;
        Form1.Grid.InsertColRow(False, Form1.Grid.RowCount);
        Form1.Grid.SlideImage[1, Form1.Grid.RowCount-1]:=img;
        img1.img:=GridImageList[2, gridint];
        img1.ImgPath:=str;
        Form1.Grid.SlideImage[2, Form1.Grid.RowCount-1] := img1;

      finally
      LoadBGRA.Free;
      end;
    end;
end;

procedure FreeImage;
//var i: Integer;
begin
{  for i:=0 to Length(GridImageList[0])-1 do
    TBGRACustomBitmap(GridImageList[0, i]).destroy;
  for i:=0 to Length(GridImageList[1])-1 do
    TBGRACustomBitmap(GridImageList[1, i]).destroy;   }
  SetLength(GridImageList, 3, 1);
end;

function SortFiles(List: String): String;
  var ext: string;
begin
    ext := ExtractFileExt(List);
    Delete(ext, 1, 2);
    ext:=LowerCase(ext);
    if (SupportedImages.IndexOf('.' + ext) <> -1) then
      begin
        Form1.Memo1.Append('Error: ' + '.' + ext);
        Result:=''
        //ImagePath.Add(List[i])
      end
    else
      Result:= List;
end;

end.
