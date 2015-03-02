program Main;

{$mode objfpc}{$H+}

uses
  {$ifdef unix} cthreads, {$endif}cmem, Interfaces, // this includes the LCL widgetset
  Forms, main_code, uabout, settings, Projector, slideeditor,
  PasLibVlcPlayer, log, thread;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.CreateForm(TfrmSettings, frmSettings);
  Application.CreateForm(TfrmProjector, frmProjector);
  Application.CreateForm(TfrmSlideEditor, frmSlideEditor);
  Application.CreateForm(TfrmLog, frmLog);
  Application.Run;
end.
