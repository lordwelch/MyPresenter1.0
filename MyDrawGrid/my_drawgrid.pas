{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit my_drawgrid;

interface

uses
  MyDrawGrid, mygrids, resize, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('MyDrawGrid', @MyDrawGrid.Register);
end;

initialization
  RegisterPackage('my_drawgrid', @Register);
end.
