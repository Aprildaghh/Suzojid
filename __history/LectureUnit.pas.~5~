unit LectureUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Generics.Collections, Vcl.Graphics, Math, SkeletonUnit;

type
  TLecture = class (TSkeleton)
    public
      function getTextLine: string;
      property TextLine:string read getTextLine;
  end;

implementation

{ TLecture }

function TLecture.getTextLine: string;
begin
  Result := GetName + '/' + floattostr(GetAvg) + '/' + inttostr(GetHowMuchTaken);
end;


end.
