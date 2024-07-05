unit SkeletonUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Generics.Collections, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Math;

type

  TSkeleton = class (TObject)
    private
      tName           : string;
      tAvg            : double;
      tHowMuchTaken   : integer;
      function GetAvg: double;
      function GetHowMuchTaken: integer;
      function GetName: string;
      procedure SetHowMuchTaken(const Value: integer);
      procedure SetName(const Value: string);
      procedure SetAvg(const Value: double);
      function getListLine: string;
    public
      procedure updateAvg(newNote: double);
      property Name: string read tName write tName;
      property Avg: double read tAvg write tAvg;
      property HowMuchTaken: integer read tHowMuchTaken write tHowMuchTaken;
      property ListLine: string read getListLine;
      constructor Create(tName: string);

  end;

implementation

constructor TSkeleton.Create(tName: string);
begin
  SetName(tName);
  SetAvg(0.0);
  SetHowMuchTaken(0);
end;

function TSkeleton.GetAvg: double;
begin
  Result := tAvg;
end;

function TSkeleton.GetHowMuchTaken: integer;
begin
  Result := tHowMuchTaken;
end;

function TSkeleton.getListLine: string;
begin
  Result := self.GetName + ', ' + floattostr(self.GetAvg);
end;

function TSkeleton.GetName: string;
begin
  Result := tName;
end;

procedure TSkeleton.SetAvg(const Value: double);
begin
  tAvg := Value;
end;

procedure TSkeleton.SetHowMuchTaken(const Value: integer);
begin
  tHowMuchTaken := Value;
end;

procedure TSkeleton.SetName(const Value: string);
begin
  tName := Value;
end;

procedure TSkeleton.updateAvg(newNote: double);
begin
  self.tAvg := ((self.tAvg * self.tHowMuchTaken) + newNote) / (self.tHowMuchTaken+1);
end;

end.
