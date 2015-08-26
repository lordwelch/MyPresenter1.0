program mps;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, LResources, main, projection, song, treegrid;

{$R *.res}

begin
  {$I images.lrs}
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmProjection, frmProjection);
  Application.CreateForm(TfrmSong, frmSong);
  Application.Run;
end.

