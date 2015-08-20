unit song;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, FileCtrl, mygrids;

type

  { TfrmSong }

  TfrmSong = class(TForm)
    btnAdd: TButton;
    btnSave: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Memo1: TMemo;
    Panel1: TPanel;
    procedure btnAddClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Save();
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmSong: TfrmSong;
  sngtypes: TSongType;
  newSlide: TSongPart;
  newSong: TSong;
  imageStr: String;

implementation
uses data;

{$R *.lfm}

{ TfrmSong }

procedure TfrmSong.FormCreate(Sender: TObject);
begin
  sngtypes := Slide;
  newSlide := Nil;
  newSong := TSong.create();
end;

procedure TfrmSong.Save;
var i: Integer;
begin
  for i:=0 to newSong.Count-1 do
    begin
    AddSlide(TSongPart(newSong.Items[i]));
    //WriteLn(TSongPart(newSong.Items[i]).FText);
    //newsong.Items[i]:=Nil;
    end;
  //FreeAndNil(newSong);
  //newSong:=tSong.create;
end;

procedure TfrmSong.btnAddClick(Sender: TObject);
var
  png1: TPortableNetworkGraphic;
begin
  png1:=Nil;
  png1 := TPortableNetworkGraphic.Create;
  if newSlide = Nil then
    newSlide := TSongPart.create();
  png1.LoadFromLazarusResource(imageStr);
  newSlide.FImg.Assign(png1);
  //newSlide.FImg.LoadFromBitmapIfNeeded;
  newSlide.FText := Memo1.Text;
  newSong.Add(newSlide);
  newSlide := Nil;
  FreeAndNil(png1);
end;

procedure TfrmSong.btnSaveClick(Sender: TObject);
begin
  Save();
end;

procedure TfrmSong.ComboBox1Change(Sender: TObject);
var ans: string;
begin
  ans := ComboBox1.Items.Strings[ComboBox1.ItemIndex];
  case ans of
    'Slide': sngtypes:=Slide;
    'Intro': sngtypes:=Intro;
    'Verse': sngtypes:=Verse;
    'PreChorus': sngtypes:=PreChorus;
    'Chorus': sngtypes:=Chorus;
    'Bridge': sngtypes:=Bridge;
    'Conclusion': sngtypes:=Conclusion;
    'Solo': sngtypes:=Solo;
  end;
  newSlide.FSongType := sngtypes;
end;

procedure TfrmSong.ComboBox2Change(Sender: TObject);
begin
  imageStr := ComboBox2.Text;
end;

end.

