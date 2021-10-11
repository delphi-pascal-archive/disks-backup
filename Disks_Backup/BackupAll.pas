{ Ce logiciel permet de controler les sauvegardes de tout ou partie des disques/partitions d'un PC
  Il utilse DriveImageXml, logiciel gratuit de sauvegarde.
  Ce logiciel se trouve � : http://www.runtime.org/driveimage-xml.htm
  Il utilise �galement RunProcess, unit� qui permet de lancer une appli, et d'attendre
  la fin de celle-ci pour lancer la prochaine (incluse dans le zip).
  Il utilise aussi rmLibrary pour certaines proc�dures (incluse dans le zip).

  Le disque ou la partition qui re�oit les fichiers de sauvegarde doit s'appeler Backup

  Le nombre de fichiers de sauvegarde est mis � 2 � la premi�re utilisation du logiciel.
  Il est ensuite possible de changer ce nombre dans la colonne Nb en face du nom de
  chaque disque/partition du PC.

  Le nombre de fichiers de sauvegarde ainsi que l'emplacement du logiciel de backup
  sont sauvegard�s au moment de la fermeture du logiciel dans un fichier INI plac�
  dans le r�pertoire o� a �t� install� le logiciel BacupAll.exe.

  L'utilisateur doit entrer le r�pertoire du logiciel de sauvegarde DriveImageXml.exe
  Il faut choisir le r�pertoire de destination des sauvegardes sur le disque Backup.
  Sans choix le programme prendra le premier de la liste.
  S'il n'existe aucun r�pertoire, il sera demand� un nom, et ce r�pertoire sera cr��.
  C'est sous ce r�pertoire que seront cr��s les sous-r�pertoires de sauvegarde des disques et partitions.
  Il est possible de cr�er d'autres r�pertoires de sauvegarde.

  On peut �galement choisir le taux de compression:
  -Aucun (le temps d'�criture est rapide)
  -Faible (le temps d'�criture est un peu moins rapide)
  -Fort (le temps d'�criture est plus lent)

  Ensuite le programme �crira les fichiers de sauvegarde dans le sous-r�pertoire dont le
  nom correspond au nom du disque ou partition en cours de sauvegarde.
  Ce r�pertoire sera cr�� la premi�re fois s'il n'existe pas.
}

unit BackupAll;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniFiles, rmLibrary, RunProcess,
  ExtCtrls, ShellAPI, CheckLst, Grids, ValEdit;


type
  TBackupForm = class(TForm)
    Label1: TLabel;
    GOButton: TButton;
    Quitbtn: TButton;
    DixDirEdit: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    NbBackListBox: TValueListEditor;
    Label4: TLabel;
    ChoixDix: TButton;
    OpenDialog1: TOpenDialog;
    AjoutButton: TButton;
    RadioGroup1: TRadioGroup;
    Label5: TLabel;
    Label6: TLabel;
    TheMemo: TMemo;
    HelpDIXBtn: TButton;
    DriveListBox: TCheckListBox;
    DirectoryListBox: TListBox;
    NoCompress: TRadioButton;
    FastCompress: TRadioButton;
    SlowCompress: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GOButtonClick(Sender: TObject);
    procedure QuitbtnClick(Sender: TObject);
    procedure Del_File(S,ind : string);
    procedure Ren_File(S,ind : string);
    procedure NbBackListBoxValidate(Sender: TObject; ACol, ARow: Integer;
      const KeyName, KeyValue: String);
    procedure ChoixDixClick(Sender: TObject);
    procedure FreeAll;
    procedure DirectoryListBoxClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure AjoutButtonClick(Sender: TObject);
    procedure HelpDIXBtnClick(Sender: TObject);
  private
    FRunProc: TRunProcess;
    procedure ProcBegin(Sender: TObject);
    procedure ProcEnd(Sender: TObject);
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

var
  BackupForm: TBackupForm;

implementation

{$R *.dfm}

var BackupLetter : string; {Lettre du disque de backup}
    BackupDir : string;
    DriveLetter : string; {Lettre du disque en cours de backup}
    DisquesList : TStringList; {Liste de tous les diques pr�sents sur ce PC}
    AllCommands : TStringList; {Liste de toutes les commandes � ex�cuter}
    TheDrvList : TStringList; {Liste des lettres de disques avec leur nombre de backup sous la forme C=2}
    CommandNb : Integer; {le nombre de commandes DriveImageXml � ex�cuter}
    ActNb : Integer; {le num�ro en cours des commandes DriveImageXml � ex�cuter}
    main_dir : string; {le r�pertoire o� se trouve le logiciel BackupAll}
    TheIniFile : TIniFile; {le fichier ini qui contient les infos n�c�ssaires au programme BackupAll}
    TheCommand : string; {L'�criture de la sauvegarde en cours pour affichage}

const
   Tab: char = Chr(9); {d�limiteur}

procedure TBackupForm.FormCreate(Sender: TObject);
var
  Tmp: array [0..104] of Char;
  S, la, lb : string;
  P: PChar;
  i : Integer;
  FirstTime : Boolean;
  max, Flags: DWORD;
  Buf: array [0..MAX_PATH] of Char;
  Res: TSearchRec;
  EOFound : Boolean;
begin
  main_dir := ExtractFilePath(application.exename);
  TheIniFile := TIniFile.Create(main_dir + 'backupall.ini');
  DixDirEdit.Text := TheIniFile.ReadString('dixdir','dir','');
  BackupLetter := '';
  DisquesList := TStringList.Create;
  AllCommands := TStringList.Create;
  TheDrvList := TStringList.Create;
  FRunProc := TRunProcess.Create(Self); {Cr�ation du process qui lance une application, et attend qu'elle soit}
  FRunProc.OnProcessBegin := ProcBegin; {termin�e avant de lancer la prochaine}
  FRunProc.OnProcessEnd := ProcEnd;
  try
    TheIniFile.ReadSectionValues('nbbackup',TheDrvList);
    if TheDrvList.Count>0 then FirstTime := False else FirstTime := True;
    GetLogicalDriveStrings(SizeOf(Tmp), Tmp); {Detection de tous les disques (physiques ou logiques) du PC}
    P := Tmp;                                 

    i := 0;
    while P^ <> #0 do
    begin
      S := P;
      Inc(P, 4);

      if GetDriveType(PChar(S))=DRIVE_FIXED then
      begin
         GetVolumeInformation(PChar(S), Buf, sizeof(Buf), nil, max, Flags, nil, 0);
         la := StrPas(buf);
         if LowerCase(la)='backup' then
         begin
           BackupLetter := S;
         end else
         begin
            DriveListBox.Items.Add(la+' ('+S[1]+')');
            DisquesList.Add(S+tab+la);
            lb := TheIniFile.ReadString('nbbackup',S[1],'2');
            NbBackListBox.Strings.Add(S[1]+'='+lb);
            if not FirstTime then TheDrvList.Strings[i] := TheDrvList.Strings[i] + Tab + lb
            else TheDrvList.Add(S[1]+'=2'+Tab+'2');
            inc(i);
         end;
      end;
    end;
  finally
  end;
  if BackupLetter='' then
  begin
    MessageDlg('Allumer le disque Backup',mtInformation,[mbOk], 0);
    FreeAll;
    Halt;
  end;
  DirectoryListBox.Items.Add('Disque '+BackupLetter);
  BackupDir := BackupLetter;

  {On cheche les r�pertoires principaux du disque de sauvegarde}
  EOFound:= False;
  if FindFirst(BackupLetter+'*.*', faDirectory, Res) < 0 then
    exit
  else
  while not EOFound do
  begin
    if (Trim(Res.Name)<>'') and (Res.Attr=8208) then DirectoryListBox.Items.Add(Res.Name) ;
    EOFound:= FindNext(Res) <> 0;
  end;
  FindClose(Res) ;
end;

procedure TBackupForm.FreeAll;
begin
  DisquesList.Free;
  AllCommands.Free;
  TheDrvList.Free;
  FRunProc.Destroy;
  TheIniFile.Free;
end;

procedure TBackupForm.FormClose(Sender: TObject; var Action: TCloseAction);
var i : Integer;
    la, lb : string;
begin
  for i := 0 to NbBackListBox.Strings.Count-1 do  {Mise � jour du fichier ini}
  begin
    la := Copy(NbBackListBox.Strings[i],1,Pos('=',NbBackListBox.Strings[i])-1);
    lb := Copy(NbBackListBox.Strings[i],Pos('=',NbBackListBox.Strings[i])+1,Length(NbBackListBox.Strings[i]));
    TheIniFile.WriteString('nbbackup',la,lb);
  end;
  TheIniFile.WriteString('dixdir','dir',DixDirEdit.Text);
  FreeAll;
end;

{S'il n'y a pas de r�pertoire principal, on demmande }
procedure TBackupForm.FormActivate(Sender: TObject);
var ll : string;
begin
  if DirectoryListBox.Items.Count = 1 then
  begin
    ll := '';
    InputQuery('R�pertoire','Veuillez donner le nom d''un r�pertoire principal de sauvegarde',ll);
    if ll='' then Exit;
    BackupDir := BackupLetter+ll+'\';
    {I+}
    ChDir(BackupDir);
    if IOResult<>0 then
    begin
      MkDir(BackupDir);
      ChDir(BackupDir);
      DirectoryListBox.Items.Add(ll);
      DirectoryListBox.ItemIndex := 1;
    end;
    {I-}
  end;
  if CountSections(BackupDir,'\') = 1 then
  begin
    BackupDir := BackupLetter+DirectoryListBox.Items.Strings[1]+'\';
  end;
  DirectoryListBox.ItemIndex := 1;
end;

{Actions � effectuer au d�but de chaque commande et affichage dans le Memo}
procedure TBackupForm.ProcBegin(Sender: TObject);
var ll, l1, l2  : string;
begin
  ll := AllCommands.Strings[ActNb]; {D�marrage de la liste des commandes}
  l1 := Copy(ll,Pos('/b',ll)+2,1);
  l2 := Copy(ll,Pos('/t',ll)+2,Length(ll));
  l2 := Copy(l2,1,Pos('\Drive_',l2)-1);
  TheCommand := 'Ecriture des fichiers '+l2+'\Drive_'+l1+'_OK1.dat et .xml';
  TheMemo.Lines.Add(TheCommand);
  TheMemo.Refresh;
  Inc(ActNb);
end;

{Actions � effectuer � la fin de chaque commande}
procedure TBackupForm.ProcEnd(Sender: TObject);
begin
  if ActNb<=CommandNb then  {Continuation ou fin de la liste des commandes}
  begin
    TheMemo.Lines[ActNb-1] := TheCommand + ' OK';
    Thememo.Refresh;
    FRunProc.CommandLine := AllCommands.Strings[ActNb];
    FRunProc.Execute;
  end else
  begin
    TheMemo.Lines[ActNb-1] := TheCommand + ' OK';
    TheMemo.Lines.Add(' ');
    TheMemo.Lines.Add('Job termin�');
    TheMemo.Refresh;
    AllCommands.Clear;
  end;
end;

procedure TBackupForm.Del_File(S,ind : string);
begin
  DeleteFile(DriveLetter+'\Drive_'+S+'_OK'+ind+'.dat');
  DeleteFile(DriveLetter+'\Drive_'+S+'_OK'+ind+'.xml');
end;

procedure TBackupForm.Ren_File(S,ind : string);
var ll : string;
begin
  ll := DriveLetter+'\Drive_'+S+'_OK'+ind+'.dat';
  if FileExists(ll) then Del_File(S,ind);
  RenameFile(DriveLetter+'\Drive_'+S+'_OK'+inttostr(strtoint(ind)-1)+'.dat',DriveLetter+'\Drive_'+S+'_OK'+ind+'.dat');
  RenameFile(DriveLetter+'\Drive_'+S+'_OK'+inttostr(strtoint(ind)-1)+'.xml',DriveLetter+'\Drive_'+S+'_OK'+ind+'.xml');
end;

procedure TBackupForm.AjoutButtonClick(Sender: TObject);
var ll : string;
begin
  ll := '';
  InputQuery('R�pertoire','Veuillez donner le nom du nouveau r�pertoire principal de sauvegarde',ll);
  if ll='' then Exit;
  BackupDir := BackupLetter+ll+'\';
  {I+}
  ChDir(BackupDir);
  if IOResult<>0 then
  begin
    MkDir(BackupDir);
    ChDir(BackupDir);
    DirectoryListBox.Items.Add(ll);
    DirectoryListBox.ItemIndex := DirectoryListBox.Count;
  end;
  {I-}
end;

procedure TBackupForm.GOButtonClick(Sender: TObject);
var i, j : Integer;
    S, la, Compress : string;
    BeforeInt, AfterInt : Integer;
begin
  if Trim(DixDirEdit.Text)='' then
  begin
    MessageDlg('Mettre le r�pertoire de DriveImage XML',mtInformation,[mbOk], 0);
    Exit;
  end;

  AllCommands.Clear;
  TheMemo.Clear;

  if NoCompress.Checked then Compress := ''
  else if FastCompress.Checked then Compress := '1'
  else if SlowCompress.Checked then Compress := '2';

  for i:=0 to DriveListBox.Items.Count-1 do
  begin
    if DriveListBox.Checked[i] then
    begin
      la := ParseSection(TheDrvList.Strings[i],1,Tab);
      BeforeInt := StrToInt(ParseSection(la,2,'='));
      AfterInt := StrToInt(ParseSection(TheDrvList.Strings[i],2,Tab));
      DriveLetter := DisquesList.Strings[i];
      S := DriveLetter[1];
      DriveLetter := BackupDir+ParseSection(DriveLetter,2,Tab);
      {$I-}
      ChDir(DriveLetter);
      if IOResult<>0 then
      begin
        MkDir(DriveLetter);
      end;
      {$I+}

      {On �fface �ventuellement les fichiers en trop}
      {si il y a eu un changement de nombre de sauvegardes}
      for j := AfterInt+1 to BeforeInt do
      begin
        la := DriveLetter+'\Drive_'+S+'_OK'+IntToStr(j)+'.dat';
        if FileExists(la) then Del_File(S,IntToStr(j));
      end;

      {on renomme les fichiers restants(3->4, 2->3, 1->2...)}
      for j := AfterInt downto 2 do
      begin
        la := DriveLetter+'\Drive_'+S+'_OK'+IntToStr(j-1)+'.dat';
        if FileExists(la) then Ren_File(S,IntToStr(j));
      end;

      {On met � jour le fichier des disques/partitions TheDrvList}
      if AfterInt <> BeforeInt then
        TheDrvList.Strings[i] := S[1]+'='+IntTostr(AfterInt)+Tab+IntTostr(AfterInt);

      {On pr�pare les commandes de backup}
      la := DixDirEdit.Text+' /c'+Compress+' /s- /v /b'+S+'/t'+DriveLetter+'\Drive_'+S+'_OK1';
      AllCommands.Add(la);
    end;
  end;

  if AllCommands.Count = 0 then
  begin
    ShowMessage('Aucun disque n''a �t� choisi pour sauvegarder');
    Exit;
  end;

  CommandNb := AllCommands.Count-1;
  ActNb := 0;
  FRunProc.CommandLine := AllCommands.Strings[ActNb];
  FRunProc.Execute;
end;

procedure TBackupForm.QuitbtnClick(Sender: TObject);
begin
  Close;
end;

{Mise en forme du nombre de backup initial et nouveau dans TheDrvList}
{Si le r�sultat n'est pas un chiffre positif, on met 1}
procedure TBackupForm.NbBackListBoxValidate(Sender: TObject; ACol,
  ARow: Integer; const KeyName, KeyValue: String);
var la : string;
    Res, Thecode : Integer;
begin
  la := ParseSection(TheDrvList.Strings[Arow-1],1,Tab);
  Val(KeyValue,res,Thecode);
  if (Thecode <> 0) or (Res < 1) then
  begin
    NbBackListBox.Strings[ARow-1] := KeyName+'='+'1';
    TheDrvList.Strings[Arow-1] := la + Tab + '1';
  end else
    TheDrvList.Strings[Arow-1] := la + Tab + KeyValue;
end;

{Choix du r�pertoire du logiciel DriveImageXml (DIX)}
procedure TBackupForm.ChoixDixClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    DixDirEdit.Text := OpenDialog1.FileName;
  end;
end;

procedure TBackupForm.DirectoryListBoxClick(Sender: TObject);
begin
  BackupDir := BackupLetter+DirectoryListBox.Items.Strings[DirectoryListBox.ItemIndex];
  if BackupDir[Length(BackupDir)]<>'\' then BackUpDir := BackupDir + '\';
end;

procedure TBackupForm.HelpDIXBtnClick(Sender: TObject);
var ll : string;
begin
  ll := ChangeFileExt(DixDirEdit.Text,'.chm');
  ShellExecute(Handle,'open',PAnsiChar(ll),nil,nil,SW_SHOWNORMAL);
end;

end.
