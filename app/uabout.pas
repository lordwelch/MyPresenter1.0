unit uabout;

{$mode objfpc}{$H+}

interface

uses
  {$ifdef unix} cthreads, {$endif}cmem, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, StdCtrls, VersionSupport;

type

  { TfrmAbout }

  TfrmAbout = class(TForm)
    Image1: TImage;
    lblver: TLabel;
    lblName: TLabel;
    Memo1: TMemo;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Version: TTabSheet;
    About: TTabSheet;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.lfm}

{ TfrmAbout }

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  lblver.Caption:='version ' + GetFileVersion;
  lblName.Caption:='My Presenter';
  lblver.AutoSize:=false;
  lblver.AutoSize:=true;
end;

end.
