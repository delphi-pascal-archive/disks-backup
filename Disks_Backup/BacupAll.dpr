program BacupAll;

uses
  Forms,
  BackupAll in 'BackupAll.pas' {BackupForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TBackupForm, BackupForm);
  Application.Run;
end.
