unit data_hub;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uabout, Laz2_DOM, laz2_xmlutils, laz2_XMLWrite, laz2_XMLRead,
  BGRABitmapTypes, LCLProc, Grids, Dialogs;

procedure LoadSupportedImages();
procedure About();
procedure ReadXMLcfg(Filename: string);
procedure SaveXMLcfg(Filename: string);
procedure SaveXMLScript(Filename: String);
procedure InitVars();

var
  path,SupportedImages: TStringList;
  GridEditable: Boolean;
  DialogOptions: TOpenOptions;
  GridOptions: TGridOptions;
  ScriptFile: String;
implementation
 uses Main;

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
  //debugln(IntToStr(SupportedImages.Count));
  for i:= 1 to (SupportedImages.Count-1) do
    str1+=';*'+SupportedImages.Strings[i];
  Form1.OpenDialog1.Filter:=str1;
  //debugln(Form1.OpenDialog1.Filter);
end;

procedure About;
begin
  frmAbout.Show;
end;

procedure ReadXMLcfg(Filename: string);
var
  PassNode: TDOMNode;
  Doc: TXMLDocument;
  NodeText: AnsiString;
begin
  if not (FileExists(Filename)) then
     SaveXMLcfg(Filename);
  try
        // Read in xml file from disk
    ReadXMLFile(Doc, filename);

        // print the Slide_font node
    PassNode := Doc.DocumentElement.FindNode('Slide_font');
      NodeText := PassNode.FirstChild.NodeValue;
        //strlog.Append('Slide Font: ' + NodeText);
          //FrmSettings.SlideFont.Font.Name := NodeText;
      NodeText := PassNode.Attributes.GetNamedItem('Size').TextContent;
        //strlog.Append('Slide Font Size: ' + NodeText);
          //FrmSettings.SlideFont.Font.Size := StrToInt(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Bold').TextContent;
        //strlog.Append('Slide Font Bold: ' + NodeText);
          //FrmSettings.SlideFont.Font.Bold := StrToBool(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Italic').TextContent;
        //strlog.Append('Slide Font Italic: ' + NodeText);
          //FrmSettings.SlideFont.Font.Italic := StrToBool(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Underline').TextContent;
        //strlog.Append('Slide Font Underline: ' + NodeText);
          //FrmSettings.SlideFont.Font.Underline := StrToBool(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Color').TextContent;
        //strlog.Append('Slide Font Color: ' + NodeText);
          //AColor := StrToBGRA(NodeText);

        // print the Grid_font node
    PassNode := Doc.DocumentElement.FindNode('Grid_font');
      NodeText := PassNode.FirstChild.NodeValue;
        //strlog.Append('Grid Font: ' + NodeText);
         //FrmSettings.GridFont.Font.Name := NodeText;
      NodeText := PassNode.Attributes.GetNamedItem('Size').TextContent;
        //strlog.Append('Grid Font Size: ' + NodeText);
          //FrmSettings.GridFont.Font.Size := StrToInt(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Bold').TextContent;
        //strlog.Append('Grid Font Bold: ' + NodeText);
          //FrmSettings.GridFont.Font.Bold := StrToBool(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Italic').TextContent;
        //strlog.Append('Grid Font Italic: ' + NodeText);
          //FrmSettings.GridFont.Font.Italic := StrToBool(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Underline').TextContent;
        //strlog.Append('Grid Font Underline: ' + NodeText);
          //FrmSettings.GridFont.Font.Underline := StrToBool(NodeText);

    //Form1.Grid.Font := FrmSettings.GridFont.Font;


        // Retrieve the "Text outline" node
    PassNode := Doc.DocumentElement.FindNode('Text_outline');
      NodeText := PassNode.FirstChild.NodeValue;
        //strlog.Append('Outline Width: ' + NodeText);
          //FrmSettings.SpinEdit3.Value:=StrToFloat(NodeText);

    if not (Doc.DocumentElement.FindNode('Grid_options') = nil) then
      begin
        PassNode := Doc.DocumentElement.FindNode('Grid_Editable');
        if PassNode.HasChildNodes then
        begin
          NodeText := PassNode.FirstChild.NodeValue;
          if StrToBool(NodeText) then
          begin
            Form1.Grid.Options:= GridOptions + [goEditing];
            Form1.Grid.AutoEdit:=True;
            ////FrmSettings.Button3.Tag:=0;
            ////FrmSettings.Button3.Caption := 'make read-only';}
            //strlog.Append('GridOptions: On');
            ////FrmSettings.btnEditableClick(//FrmSettings.btnEditable);
          end;
        end;
     end;
    //frmLog.Memo1.Lines.AddStrings(//strlog);
  finally
        // finally, free the document
    Doc.Free;
  end;
end;

procedure SaveXMLcfg(Filename: string);
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
    //TDOMElement(ItemNode).SetAttribute('Size', IntToStr(FrmSettings.SlideFont.Font.Size));
    //TDOMElement(ItemNode).SetAttribute('Bold', BoolToStr(FrmSettings.SlideFont.Font.Bold, '1', '0'));
    //TDOMElement(ItemNode).SetAttribute('Italic', BoolToStr(FrmSettings.SlideFont.Font.Italic, '1', '0'));
    //TDOMElement(ItemNode).SetAttribute('Underline', BoolToStr(FrmSettings.SlideFont.Font.Underline, '1', '0'));
    //TDOMElement(ItemNode).SetAttribute('Color', BGRAToStr(AColor));
    //TextNode:=Doc.CreateTextNode(FrmSettings.SlideFont.Font.Name);
    //ItemNode.AppendChild(TextNode);
    //ElementNode.AppendChild(ItemNode);
    RootNode.AppendChild(ItemNode);

        //save font of text in grid
    ItemNode:=Doc.CreateElement('Grid_font');
    //TDOMElement(ItemNode).SetAttribute('Size', IntToStr(FrmSettings.GridFont.Font.Size));

    //TDOMElement(ItemNode).SetAttribute('Bold', BoolToStr(FrmSettings.GridFont.Font.Bold, '1', '0'));
    //TDOMElement(ItemNode).SetAttribute('Italic', BoolToStr(FrmSettings.GridFont.Font.Italic, '1', '0'));
    //TDOMElement(ItemNode).SetAttribute('Underline', BoolToStr(FrmSettings.GridFont.Font.Underline, '1', '0'));
    //TextNode:=Doc.CreateTextNode(FrmSettings.GridFont.Font.Name);
    //ItemNode.AppendChild(TextNode);
    //ElementNode.AppendChild(ItemNode);
    RootNode.AppendChild(ItemNode);

        //save the grid options
   // if goEditingIndex = 0 then
    //begin
      ItemNode:=Doc.CreateElement('Grid_Editable');
      TextNode:=Doc.CreateTextNode(BoolToStr(GridEditable, '1', '0'));
      ItemNode.AppendChild(TextNode);
      //ElementNode.AppendChild(ItemNode);
      RootNode.AppendChild(ItemNode);
    //end;

        //width of the outline surrounding text
    //ItemNode:=Doc.CreateElement('Text_outline'); TextNode:=Doc.CreateTextNode(FrmSettings.SpinEdit3.ValueToStr(//FrmSettings.SpinEdit3.Value));
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

procedure saveXmlScript(Filename: String);
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
      TDOMElement(ItemNode).SetAttribute('ImageLocation', Path.Strings[i-1]);
      debugln(Path.Names[i-1]);
      isVideo:=Form1.Grid.Cells[1, i].IsVideo;
      TDOMElement(ItemNode).SetAttribute('isVideo', BoolToStr(IsVideo, '1', '0'));
      if isVideo then
        //TDOMElement(ItemNode).SetAttribute('VideoLocation', BoolToStr(FrmSettings.SlideFont.Font.Italic, '1', '0'));
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
    TextNode:=Doc.CreateTextNode(//FrmSettings.GridFont.Font.Name);
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
    ScriptFile := Filename;
  finally
    Doc.Free;
  end;
end;

procedure InitVars;
begin
  path:=TStringList.Create;
  GridEditable:=false;
  LoadSupportedImages;
end;

end.

