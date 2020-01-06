program UploadProgram;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Forms,
  upload in 'upload.pas' {uploadForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TuploadForm, uploadForm);
  Application.Run;
end.
