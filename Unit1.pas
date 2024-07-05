unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Generics.Collections, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Math, NotesUnit;

type
  TmainForm = class(TForm)
    studentListBox: TListBox;
    addStudentBtn: TButton;
    removeStudentBtn: TButton;
    lectureListBox: TListBox;
    addLectureBtn: TButton;
    removeLectureBtn: TButton;
    assignNoteBtn: TButton;
    procedure addStudentBtnClick(Sender: TObject);
    procedure removeStudentBtnClick(Sender: TObject);
    procedure addLectureBtnClick(Sender: TObject);
    procedure removeLectureBtnClick(Sender: TObject);
    procedure assignNoteBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    tNotes     : TNotes;
    const textFileName: string = 'marti.txt';
  public
    { Public declarations }
  end;

var
  mainForm: TmainForm;

implementation

{$R *.dfm}
{
procedure fillListBoxes;
var
  i               : Integer;
  studentList,
  lectureList     : TListBox;
begin
  studentList := mainForm.studentListBox;
  lectureList := mainForm.lectureListBox;

  studentList.Clear;
  lectureList.Clear;

  for i := 0 to Math.Max(mainForm.students.Count, mainForm.lectures.Count) - 1 do
  begin
    if (i < mainForm.students.Count) and (mainForm.students.ToArray[i].GetName <> '') then
      studentList.AddItem(mainForm.students.toArray[i].GetListLine, nil);
    if (i < mainForm.lectures.Count) and (mainForm.lectures.ToArray[i].GetName <> '') then
      lectureList.AddItem(mainForm.lectures.toArray[i].GetListLine, nil);
  end;

  studentList.Refresh;
  lectureList.Refresh;
end;
}
procedure TmainForm.addLectureBtnClick(Sender: TObject);
var
  lectureName: string;
begin
  lectureName := inputbox('Add Lecture', '', '');
  if lectureName = '' then
    showmessage('Invalid lecture!')
  else
  begin
    tNotes.AddLecture(lectureName);
    lectureListBox.AddItem(lectureName + ', 0.0', nil);
  end;

end;

procedure TmainForm.addStudentBtnClick(Sender: TObject);
var
  studentName: string;
  student: TStudent;
begin
  studentName := inputbox('Add Student', '', '');
  if studentName = '' then
    showmessage('Invalid student name!')
  else
  begin
    student := TStudent.Create(studentName);
    students.Add(student);
    studentListBox.AddItem(studentName + ', 0.0', nil);
  end;
end;

procedure TmainForm.assignNoteBtnClick(Sender: TObject);
var
  newNote: double;
  theStudent: TStudent;
  theLecture: TLecture;
  i: Integer;
  isNewNote: boolean;
begin

  if (studentListBox.ItemIndex = -1) or
    (lectureListBox.ItemIndex = -1) then
  begin
    ShowMessage('Student or Lecture not selected!');
    Exit;
  end;

  // Get note from user
  newNote := StrToFloat(inputBox('Assign Note', '', ''));
  theStudent := students.toArray[studentListBox.ItemIndex];
  theLecture := lectures.toArray[lectureListBox.ItemIndex];

  // update old note
  isNewNote := True;
  for i := 0 to theStudent.GetLectureNames.Count -1 do
  begin
    if theStudent.GetLectureNames.Items[i] = theLecture.GetName then
    begin
      theStudent.GetNotes.Items[i] := newNote;
      isNewNote := False;
      break;
    end;
  end;
  addOrUpdateNote


  if isNewNote then
  begin
    // theStudent.UpdateAvgForNewNote(newNote);
    // theLecture.UpdateAvgForNewNote(newNote);
  end
  else
  begin
    // theStudent.updateAvg(newNote);
    // theLecture.updateAvg(newNote);
  end;

  // update listBoxes
  fillListBoxes;
end;

procedure TmainForm.FormCreate(Sender: TObject);
var
  myFile: textFile;
  line, newData: string;
  i, flag: Integer;
  onStudent: boolean;
  newLecture: TLecture;
  newStudent: TStudent;
begin
  newData := '';
  onStudent := False;

  students := TList<TStudent>.Create;
  lectures := TList<TLecture>.Create;
  notes := TList<TNote>.Create;

  assignFile(myFile, textFileName);

  if not FileExists(textFileName) then
    Exit;

  Reset(myFile);

  while not Eof(myFile) do
  begin
    Readln(myFile, line);
    newData := '';
    flag := 0;

    if line = '--' then
    begin
      onStudent := True;
      continue;
    end;

    if not onStudent then
    begin
      // LECTURE
      newLecture := TLecture.Create('');
      for i := 1 to line.Length do
      begin
        if line[i] = '/' then
        begin
          if flag = 0 then
            newLecture.SetName(newData);
          if flag = 1 then
            newLecture.SetAvg(strtofloat(newData));
          if flag = 2 then
            newLecture.SetHowMuchTaken(strtoint(newData));
          inc(flag);
          newData := '';
          continue;
        end;
        newData := newData + line[i];
      end;
      lectures.Add(newLecture);
    end;
    if onStudent then
    begin
      // STUDENT
      newStudent := TStudent.Create('');
      for i := 1 to line.Length do
      begin
        if line[i] = '/' then
        begin
          if flag = 0 then
            newStudent.SetName(newData);
          if flag = 1 then
            newStudent.SetAvg(strtofloat(newData));
          if flag = 2 then
            newStudent.SetHowMuchTaken(strtoint(newData));
          if flag = 3 then
            newStudent.AddNote(strtofloat(newData));

          if flag <> 3 then
            inc(flag);

          newData := '';
          continue;
        end;
        if line[i] = '\' then
        begin
          newStudent.AddLecture(newData);
          newData:= '';
          continue;
        end;
        newData := newData + line[i];
      end;
      students.Add(newStudent);
    end;

  end;

  closeFile(myFile);
  fillListBoxes;
end;

procedure TmainForm.FormDestroy(Sender: TObject);
var
  myFile: textFile;
  line: string;
  i: Integer;
  j: Integer;
begin

  assignFile(myFile, 'marti.txt');
  ReWrite(myFile);

  // LECTURE
  for i := 0 to lectures.Count-1 do
  begin

    if lectures.toArray[i].GetName = '' then
      continue;
    writeln(myFile, lectures.toArray[i].TextLine);
  end;

  // write --
  writeln(myFile, '--');

  // STUDENT
  for i := 0 to students.Count-1 do
  begin
    if students.toArray[i].GetName = '' then
      continue;

    line := students.toArray[i].TextLine;

    for j := 0 to students.toArray[i].GetNotes.Count-1 do
    begin
      line := line + students.toArray[i].GetLectureNames.Items[j] + '\' + floattostr(students.toArray[i].GetNotes.Items[j]) + '/';
    end;
    writeln(myFile, line);

  end;

  CloseFile(myFile);
end;

procedure TmainForm.removeLectureBtnClick(Sender: TObject);
var
  i, j                : integer;
  noteCount           : double;
  deletedLecture      : TLecture;
begin

  if lectureListBox.ItemIndex = -1 then
  begin
    ShowMessage('Lecture not selected!');
    Exit;
  end;

  deletedLecture := lectures.ToArray[lectureListBox.ItemIndex];

  for i := 0 to students.Count-1 do
  begin
    if students.toArray[i].GetLectureNames.IndexOf(deletedLecture.GetName) <> -1 then
    begin
      noteCount := 0;
      for j := 0 to students.toArray[i].GetNotes.Count-1 do
      begin
        noteCount := noteCount + students.toArray[i].GetNotes.Items[j];
      end;

      var theStudent: TStudent := students.toArray[i];

      // theStudent.UpdateAvgForNoteDeletion(0);
      theStudent.GetNotes.Items[theStudent.GetLectureNames.IndexOf(deletedLecture.GetName)] := 0;
      theStudent.GetLectureNames.Items[theStudent.GetLectureNames.IndexOf(deletedLecture.GetName)] := '';
    end;
  end;

  lectures.Remove(deletedLecture);
  lectureListBox.DeleteSelected;
  deletedLecture.Free;

  fillListBoxes;

end;

procedure TmainForm.removeStudentBtnClick(Sender: TObject);
var
  i: integer;
  theNote: double;
  lectureName: string;
  theStudent: TStudent;
  theLecture: TLecture;
begin

  if studentListBox.ItemIndex = -1 then
  begin
    ShowMessage('Student not selected!');
    Exit;
  end;

  theStudent := students.toArray[studentListBox.ItemIndex];

  for i := 0 to theStudent.HowMuchTaken-1 do
  begin
    lectureName := theStudent.GetLectureNames.Items[i];
    theNote := theStudent.GetNotes.Items[i];

    if lectureName = '' then
      continue;

    theLecture := getLectureFromName(lectureName);

    // theLecture.UpdateAvgForNoteDeletion(theNote);
    end;

  students.remove(students.ToArray[studentlistbox.ItemIndex]);
  studentListBox.DeleteSelected;
  theStudent.Free;

  fillListBoxes;
end;

end.
// note parts are fully broken
// fillListBox doesn't do anything try to remove it
