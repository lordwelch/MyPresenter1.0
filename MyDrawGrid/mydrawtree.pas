unit myDrawTree;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, VirtualTrees;

type
  TmyDrawTree = class(TVirtualDrawTree)
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
  {$I mydrawtree_icon.lrs}
  RegisterComponents('Virtual Controls',[TmyDrawTree]);
end;

end.
