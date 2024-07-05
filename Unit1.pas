unit Unit1;

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

  TLecture = class (TSkeleton)
    private
      function getTextLine: string;
    public
      property TextLine:string read getTextLine;
  end;

  TStudent = class (TSkeleton)
    private
      tLectureNames : TList<string>;
      tNotes        : TList<double>;
      function getTextLine: string;
    public
      procedure addLectureAndNote(tLecture: TLecture; tNote: double);
      procedure addLecture(tLectureName: string);
      procedure addNote(tNote: double);
      procedure AddLectureName(const Value: string);
      function GetLectureNames: TList<string>;
      function GetNotes: TList<double>;
      property TextLine: string read getTextLine;
      constructor Create(tName: string);
  end;

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
    lectures: TList<TLecture>;
    students: TList<TStudent>;
    const textFileName: string = 'marti.txt';
  public
    { Public declarations }
  end;

var
  mainForm: TmainForm;

implementation

{$R *.dfm}

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
    if i < mainForm.students.Count then
      studentList.AddItem(mainForm.students.ExtractAt(i).getTextLine, nil);
    if i < mainForm.lectures.Count then
      lectureList.AddItem(mainForm.lectures.ExtractAt(i).getTextLine, nil);
  end;

  studentList.Refresh;
  lectureList.Refresh;
end;

function sliceUntilComma(value: string): string;
var
  i: Integer;
  finalProduct: string;
begin
  for i := 1 to value.LastIndexOf(',') do
    finalProduct := finalProduct + value[i];

  Result := finalProduct;
end;

function getStudentIndex(name: string): integer;
var
  i: Integer;
begin
  for i := 0 to mainForm.students.Count - 1 do
  begin
    if mainForm.students[i].getName = name then
    begin
      Result := i;
      break;
    end;

  end;
end;

function getLectureIndex(name: string): integer;
var
  i: integer;
begin
  for i := 0 to mainForm.lectures.Count - 1 do
  begin
    if mainForm.lectures[i].getName = name then
    begin
      Result := i;
      break;
    end;
  end;
end;

procedure TmainForm.addLectureBtnClick(Sender: TObject);
var
  lectureName: string;
  lecture: TLecture;
  begin
  lectureName := inputbox('Add Lecture', '', '');
  if lectureName = '' then
    showmessage('Invalid lecture!')
  else
  begin
    lecture := TLecture.Create(lectureName);
    lectures.Add(lecture);
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
  theNote: double;
  theStudent: TStudent;
  theLecture: TLecture;
begin

  if (studentListBox.Items[studentListBox.ItemIndex] = '') or
    (lectureListBox.Items[lectureListBox.ItemIndex] = '') then
  begin
    ShowMessage('Student or Lecture not selected!');
    Exit;
  end;

  // Get note from user
  theNote := StrToFloat(inputBox('Assign Note', '', ''));

  theStudent := students.ExtractAt(getStudentIndex(sliceUntilComma(studentListBox.Items[studentListBox.ItemIndex])));
  theLecture := lectures.ExtractAt(getLectureIndex(sliceUntilComma(lectureListBox.Items[lectureListBox.ItemIndex])));
  showmessage('2');
  // update avg notes
  theStudent.UpdateAvg(theNote);
  theLecture.UpdateAvg(theNote);

  if theStudent.tLectureNames.IndexOf(theLecture.GetName) = -1 then
    theStudent.addLectureAndNote(theLecture, theNote);

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
    if lectures.ExtractAt(i).GetName = '' then
      continue;
    showmessage(lectures.ExtractAt(i).TextLine);
    writeln(myFile, lectures.ExtractAt(i).TextLine);
  end;

  // write --
  writeln(myFile, '--');

  // STUDENT
  for i := 0 to students.Count-1 do
  begin
    if students.ExtractAt(i).GetName = '' then
      continue;

    line := students.ExtractAt(i).TextLine;

    for j := 0 to students.ExtractAt(i).GetNotes.Count-1 do
    begin
      line := line + students.ExtractAt(i).GetLectureNames.Items[j] + '\' + floattostr(students.ExtractAt(i).GetNotes.Items[j]) + '/';
    end;
    showmessage(line);
    writeln(myFile, line);

  end;

  CloseFile(myFile);
end;

procedure TmainForm.removeLectureBtnClick(Sender: TObject);
var
  i: integer;
  noteCount: double;
  deletedLectureName: string;
  j: Integer;
begin

  if lectureListBox.Items[lectureListBox.ItemIndex] = '' then
  begin
    ShowMessage('Lecture not selected!');
    Exit;
  end;

  deletedLectureName := lectures[getLectureIndex(sliceUntilComma(lectureListBox.Items[lectureListBox.ItemIndex]))].GetName;
  lectures[getLectureIndex(sliceUntilComma(lectureListBox.Items[lectureListBox.ItemIndex]))].SetName('');
  lectureListBox.DeleteSelected;

  for i := 0 to students.Count-1 do
  begin
    if students[i].GetLectureNames.IndexOf(deletedLectureName) <> -1 then
    begin
      students[i].GetNotes.Items[students[i].GetLectureNames.IndexOf(deletedLectureName)] := 0;
      students[i].GetLectureNames.Items[students[i].GetLectureNames.IndexOf(deletedLectureName)] := '';
      students[i].SetHowMuchTaken(students[i].GetHowMuchTaken-1);
      if students[i].GetHowMuchTaken > 0 then
      begin
        noteCount := 0;
        for j := 0 to students[i].GetNotes.Count-1 do
        begin
          noteCount := noteCount + students[i].GetNotes.Items[j];
        end;
        students[i].SetAvg(noteCount / students[i].GetHowMuchTaken);
      end
      else
        students[i].SetAvg(0);
    end;
  end;

  fillListBoxes;

end;

procedure TmainForm.removeStudentBtnClick(Sender: TObject);
var
  i: integer;
  theNote: double;
  deletedStudentName, lectureName: string;
  theStudent: TStudent;
  theLecture: TLecture;
begin

  if studentListBox.Items[studentListBox.ItemIndex] = '' then
  begin
    ShowMessage('Student not selected!');
    Exit;
  end;

  theStudent := students[getStudentIndex(sliceUntilComma(studentListBox.Items[studentListBox.ItemIndex]))];
  deletedStudentName := theStudent.GetName;
  theStudent.SetName('');
  studentListBox.DeleteSelected;

  for i := 0 to theStudent.GetHowMuchTaken-1 do
  begin
    lectureName := theStudent.GetLectureNames.Items[i];
    theNote := theStudent.GetNotes.Items[i];

    if lectureName = '' then
      continue;

    // take the lecture
    theLecture := lectures[getLectureIndex(lectureName)];

    // dec studentNumber by 1
    theLecture.SetHowMuchTaken(theLecture.GetHowMuchTaken-1);

    // if studentNumber is 0 avg is 0
    // else dec theNote from avg * studentNumber
    if theLecture.GetHowMuchTaken = 0 then
      theLecture.SetAvg(0)
    else
    begin
      theLecture.SetAvg(((theLecture.GetAvg * (theLecture.GetHowMuchTaken+1)) - theNote) / theLecture.GetHowMuchTaken);
    end;

  end;

  fillListBoxes;
end;

{ TLecture }

function TLecture.getTextLine: string;
begin
  Result := tName + '/' + floattostr(tAvg) + '/' + inttostr(tHowMuchTaken);
end;

{ TSkeleton }

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

{ TStudent }

procedure TStudent.addLecture(tLectureName: string);
begin
  self.tLectureNames.Add(tLectureName);
end;

procedure TStudent.addLectureAndNote(tLecture: TLecture; tNote: double);
begin
    SetHowMuchTaken(self.GetHowMuchTaken+1);
    tLecture.SetHowMuchTaken(tLecture.GetHowMuchTaken+1);
    tLectureNames.Add(tLecture.GetName);
    tNotes.Add(tNote);
end;

procedure TStudent.AddLectureName(const Value: string);
begin
  self.tLectureNames.Add(Value);
end;

procedure TStudent.addNote(tNote: double);
begin
  self.tNotes.Add(tNote);
end;

constructor TStudent.Create(tName: string);
begin
  inherited Create(tName);
  tLectureNames := TList<string>.Create;
  tNotes := TList<double>.Create;
end;

function TStudent.GetLectureNames: TList<string>;
begin
  Result := self.tLectureNames;
end;

function TStudent.GetNotes: TList<double>;
begin
  Result := self.tNotes;
end;

function TStudent.getTextLine: string;
begin
  Result := GetName+'/'+floattostr(GetAvg)+'/'+inttostr(GetHowMuchTaken)+'/';
end;

end.
// addLectureBtnClick, addStudentBtnClick -> merge into 1 function
// removeLectureBtnClick, removeStudentBtnClick -> sadelestir
// take classes to another unit

// text ten okurken atlayarak okuyor
// text e kaydederken atlayarak kaydediyor
// assign note da ve remove da ekran bosaliyor
