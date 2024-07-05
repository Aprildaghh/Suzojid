unit NotesUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Generics.Collections, Vcl.Graphics, StudentUnit, LectureUnit, NoteUnit;

type
  TNotes = class (TObject)
    private
      tNotes      : TList<TNote>;
      tStudents   : TList<TStudent>;
      tLecture    : TList<TLecture>;
    public
      procedure AddLecture(tName: string);

      constructor Create;
  end;

implementation

{ TNotes }

procedure TNotes.AddLecture(tName: string);
begin
//
end;

constructor TNotes.Create;
begin
  inherited Create;
  tNotes := TList<TNote>.Create;
  tStudents := TList<TStudent>.Create;
  tLecture := TList<TLecture>.Create;
end;

end.
