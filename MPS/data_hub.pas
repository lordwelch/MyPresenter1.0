unit data_hub;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

procedure About();
procedure readxmlcfg(Filename: string);
procedure savexmlcfg(Filename: string);
procedure saveXmlScript(Filename: String);

implementation

procedure About;
begin
  frmAbout.Show;
end;

procedure readxmlcfg(Filename: string);
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
        strlog.Append('Slide Font: ' + NodeText);
          FrmSettings.SlideFont.Font.Name := NodeText;
      NodeText := PassNode.Attributes.GetNamedItem('Size').TextContent;
        strlog.Append('Slide Font Size: ' + NodeText);
          FrmSettings.SlideFont.Font.Size := StrToInt(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Bold').TextContent;
        strlog.Append('Slide Font Bold: ' + NodeText);
          FrmSettings.SlideFont.Font.Bold := StrToBool(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Italic').TextContent;
        strlog.Append('Slide Font Italic: ' + NodeText);
          FrmSettings.SlideFont.Font.Italic := StrToBool(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Underline').TextContent;
        strlog.Append('Slide Font Underline: ' + NodeText);
          FrmSettings.SlideFont.Font.Underline := StrToBool(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Color').TextContent;
        strlog.Append('Slide Font Color: ' + NodeText);
          AColor := StrToBGRA(NodeText);

        // print the Grid_font node
    PassNode := Doc.DocumentElement.FindNode('Grid_font');
      NodeText := PassNode.FirstChild.NodeValue;
        strlog.Append('Grid Font: ' + NodeText);
         FrmSettings.GridFont.Font.Name := NodeText;
      NodeText := PassNode.Attributes.GetNamedItem('Size').TextContent;
        strlog.Append('Grid Font Size: ' + NodeText);
          FrmSettings.GridFont.Font.Size := StrToInt(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Bold').TextContent;
        strlog.Append('Grid Font Bold: ' + NodeText);
          FrmSettings.GridFont.Font.Bold := StrToBool(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Italic').TextContent;
        strlog.Append('Grid Font Italic: ' + NodeText);
          FrmSettings.GridFont.Font.Italic := StrToBool(NodeText);
      NodeText := PassNode.Attributes.GetNamedItem('Underline').TextContent;
        strlog.Append('Grid Font Underline: ' + NodeText);
          FrmSettings.GridFont.Font.Underline := StrToBool(NodeText);

    Form1.Grid.Font := FrmSettings.GridFont.Font;


        // Retrieve the "Text outline" node
    PassNode := Doc.DocumentElement.FindNode('Text_outline');
      NodeText := PassNode.FirstChild.NodeValue;
        strlog.Append('Outline Width: ' + NodeText);
          FrmSettings.SpinEdit3.Value:=StrToFloat(NodeText);

    if not (Doc.DocumentElement.FindNode('Grid_options') = nil) then
      begin
        PassNode := Doc.DocumentElement.FindNode('Grid_options');
        if PassNode.HasChildNodes then
          NodeText := PassNode.FirstChild.NodeValue;
            if NodeText = 'goEditing' then
              begin
              { Form1.Grid.Options:= GridOptions + [goEditing];
                Form1.Grid.AutoEdit:=True;
                FrmSettings.Button3.Tag:=0;
                FrmSettings.Button3.Caption := 'make read-only';}
                strlog.Append('GridOptions: On');
                FrmSettings.btnEditableClick(FrmSettings.btnEditable);
              end
            else
              strlog.Append('GridOptions: Off');
     end;
    //frmLog.Memo1.Lines.AddStrings(strlog);
  finally
        // finally, free the document
    Doc.Free;
  end;
end;

procedure savexmlcfg(Filename: string);
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
      TDOMElement(ItemNode).SetAttribute('ImageLocation', ImagePath.Strings[i-1]);
      debugln(ImagePath.Names[i-1]);
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

end.

