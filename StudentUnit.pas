unit StudentUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Generics.Collections, Vcl.Graphics, Math, SkeletonUnit;

type
  TStudent = class (TSkeleton)
      public
        function getTextLine: string;
        property TextLine: string read getTextLine;
        constructor Create(tName: string);
    end;

implementation

{ TStudent }

constructor TStudent.Create(tName: string);
begin
  inherited Create(tName);
end;

function TStudent.getTextLine: string;
begin
  Result := GetName+'/'+floattostr(GetAvg)+'/'+inttostr(GetHowMuchTaken)+'/';
end;

end.
