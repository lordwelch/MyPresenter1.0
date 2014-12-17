program Main;

{$mode objfpc}{$H+}

uses
  cmem, Interfaces, // this includes the LCL widgetset
  Forms, bgrabitmappack, main_code, Data, VersionSupport, uabout, settings,
  Projector;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.CreateForm(TfrmSettings, frmSettings);
  Application.CreateForm(TfrmProjector, frmProjector);
  Application.Run;
end.

