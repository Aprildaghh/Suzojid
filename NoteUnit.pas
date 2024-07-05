unit NoteUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Generics.Collections, Vcl.Graphics, StudentUnit, LectureUnit;

type
  TNote = class (TObject)
    protected
      tStudent  : TStudent;
      tLecture  : TLecture;
      tNote     : double;
    public
      property Student: TStudent read tStudent  write tStudent;
      property Lecture: TLecture read TLecture  write TLecture;
      property Note   : double   read tNote     write tNote;
      constructor Create; overload;
      constructor Create(tStudent: TStudent; tLecture: TLecture; tNote: double); overload;
  end;

implementation

{ TNote }

constructor TNote.Create(tStudent: TStudent; tLecture: TLecture; tNote: double);
begin
  Student := tStudent;
  Lecture := tLecture;
  Note := tNote;
end;

constructor TNote.Create;
begin
  // empty constructor
end;

end.
