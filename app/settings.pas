unit settings;

{$mode objfpc}{$H+}

interface

uses
  cmem, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  LazFreeTypeFontCollection, Grids, Spin, BGRABitmap, BGRABitmapTypes, Data;

type

  { TFrmSettings }

  TFrmSettings = class(TForm)
    btnSlideFont: TButton;
    btnScreens: TButton;
    Button2: TButton;
    btnEditable: TButton;
    btSave: TButton;
    btnColor: TButton;
    ColorDialog1: TColorDialog;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    SpinEdit3: TFloatSpinEdit;
    FontDialog1: TFontDialog;
    Slide: TLabel;
    GridLable: TLabel;
    GridFont: TLabel;
    SlideFont: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    procedure btnSlideFontClick(Sender: TObject);
    procedure btnEditableClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure btnColorClick(Sender: TObject);
    procedure btnScreensClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FrmSettings: TFrmSettings;



implementation
uses main_code;
{$R *.lfm}

 { TfrmSettings }

procedure TFrmSettings.btnSlideFontClick(Sender: TObject);
begin
  if TButton(Sender).tag = 1 then
  begin
       if FontDialog1.execute then
          SlideFont.Font:=FontDialog1.Font;
       Slide.Caption:='Current slide font: '+SlideFont.Font.Name;
       ComboBox1.ItemIndex:=(ComboBox1.Items.IndexOf(SlideFont.Font.Name));
  end
  else
  begin
  if FontDialog1.execute then
     GridFont.Font:=FontDialog1.Font;
  GridLable.Caption:='Grid font:          '+GridFont.Font.Name;
  ComboBox2.ItemIndex:=(ComboBox2.Items.IndexOf(GridFont.Font.Name));
  Form1.Grid.Font := GridFont.Font
  end;
end;

procedure TFrmSettings.btnEditableClick(Sender: TObject);
begin
  if TButton(Sender).tag = 1 then
  begin
  GridOptions += [goEditing];
  Form1.Grid.Options:=GridOptions;
  SGridOptions.Insert(0,'goEditing');
  goEditingIndex := 0;
  Form1.Grid.AutoEdit:=True;
  TButton(Sender).Tag:=0;
  TButton(Sender).Caption := 'make read-only';
  end
  else
  begin
  GridOptions -= [goEditing];
  Form1.Grid.Options:=GridOptions;
  SGridOptions.Delete(goEditingIndex);
  goEditingIndex := 1;
  Form1.Grid.AutoEdit:=False;
  TButton(Sender).Tag:=1;
  TButton(Sender).Caption := 'make editable';
  end;

end;

procedure TFrmSettings.btSaveClick(Sender: TObject);
begin
  SaveXML();
end;

procedure TFrmSettings.btnColorClick(Sender: TObject);
begin
  if ColorDialog1.Execute then
    AColor:=ColorToBGRA(ColorDialog1.Color);
end;

procedure TFrmSettings.btnScreensClick(Sender: TObject);
begin
  GetScreens();
end;

procedure TFrmSettings.ComboBox1Change(Sender: TObject);
begin
  if TButton(sender).Tag = 1 then
    begin
      SlideFont.Font.Name := ComboBox1.Text;
      Slide.Caption:='Current slide font: '+SlideFont.Font.Name;
    end
    else
      begin
        GridFont.Font.Name := ComboBox2.Text;
        GridLable.Caption:='Grid font:          '+GridFont.Font.Name;
        Form1.Grid.Font:=GridFont.Font;
      end;

end;

  procedure TFrmSettings.FormCreate(Sender: TObject);
 begin
   goEditingIndex:=2;
   GridOptions:=Form1.Grid.Options;
   SGridOptions := TStringList.Create;
   readXML('TestXML_v2.xml');
        //create string list for image filenames and GridOptions
   ImagePath := TStringList.Create;



        //set spinedit to default values
   SpinEdit1.Value:=SlideFont.Font.Size;
                      //writeln(IntToStr(SlideFont.Font.FontData.Height));
   SpinEdit2.Value:=GridFont.Font.Size;

   //SpinEdit3.Value := textoutline;

        //assign font names to combobox
   ComboBox1.Items.Assign(screen.Fonts);
   ComboBox1.ItemIndex:=(ComboBox1.Items.IndexOf(SlideFont.Font.Name));

   ComboBox2.Items.Assign(screen.Fonts);
   ComboBox2.ItemIndex:=(ComboBox2.Items.IndexOf(GridFont.Font.Name));

        //set lables
    Slide.Caption:='Current slide font: '+SlideFont.Font.Name;
    //slidefont:=SlideFont.Font;

    GridLable.Caption:='Grid font:          '+GridFont.Font.Name;
    Form1.Grid.Font := GridFont.Font;

 end;

procedure TFrmSettings.SpinEdit1Change(Sender: TObject);
begin
  if TSpinEdit(Sender).tag = 1 then
  begin
  SlideFont.Font.Size:=SpinEdit1.Value;
  end
  else
  begin
  GridFont.Font.Size:=SpinEdit2.Value;
  Form1.Grid.Font:=GridFont.Font;
  end;
end;

procedure TFrmSettings.SpinEdit2Change(Sender: TObject);
begin
  textoutline:=SpinEdit3.Value;
end;

procedure TFrmSettings.FormDestroy(Sender: TObject);
begin
  SGridOptions.Free;
  ImagePath.Free;
  SupportedImages.Free;
end;

end.
