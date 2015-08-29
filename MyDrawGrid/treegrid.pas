unit treegrid;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ComCtrls;

type
  TTreegrid = class(TCustomTreeView)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  {$I treegrid_icon.lrs}
  RegisterComponents('Common Controls',[TTreegrid]);
end;

end.
