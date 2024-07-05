unit LectureUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Generics.Collections, Math, SkeletonUnit;

type
  TLecture = class (TSkeleton)
    public
      function getTextLine: string;
      property TextLine:string read getTextLine;
      constructor Create(aName: string);

  end;

implementation

{ TLecture }

constructor TLecture.Create(aName: string);
begin
  inherited Create(aName);
end;

function TLecture.getTextLine: string;
begin
  Result := GetName + '/' + floattostr(GetAvg) + '/' + inttostr(GetHowMuchTaken);
end;


end.
