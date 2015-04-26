program Main;

{$mode objfpc}{$H+}

uses
  {$ifdef unix} cthreads, {$endif} heaptrc, Interfaces, // this includes the LCL widgetset
  Forms, main_code, settings, Projector,
  slideeditor, PasLibVlcPlayer, Unit1;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmSettings, frmSettings);
  Application.CreateForm(TfrmProjector, frmProjector);
  Application.CreateForm(TfrmSlideEditor, frmSlideEditor);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
