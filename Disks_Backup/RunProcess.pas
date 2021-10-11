unit RunProcess;

interface

uses
  Windows, SysUtils, Classes, ExtCtrls;

type
  TRunProcess = class(TComponent)
  private
    { Info de d�marrage du processus }
    FStartInfo: TStartupInfo;
    { Infos sur le processus }
    FProcessInfo: TProcessInformation;
    { Ligne de commande � executer }
    FCommandLine: string;
    { R�pertoire par d�faut }
    FDefaultDir: string;
    { Handle d'attente }
    FWaitHandle: THandle;
    { Evenements }
    FOnProcessBegin: TNotifyEvent;
    FOnProcessEnd: TNotifyEvent;
  protected
    function IsProcessRunning: Boolean;
    procedure DoProcessEnd;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean;
    property ProcessInfo: TProcessInformation read FProcessInfo;
  published
    property CommandLine: string read FCommandLine write FCommandLine;
    property DefaultDir: string read FDefaultDir write FDefaultDir;
    property ProcessRunning: Boolean read IsProcessRunning;
    property OnProcessBegin: TNotifyEvent read FOnProcessBegin
     write FOnProcessBegin;
    property OnProcessEnd: TNotifyEvent read FOnProcessEnd
     write FOnProcessEnd;
  end;

implementation

{ D�claration des �l�ments n�c�ssaires pour l'attente -- }
type
  WaitOrTimerCallback = procedure (RunProc: TRunProcess;
   TimeOrWaitFired: Boolean); stdcall;

const
  WT_EXECUTEDEFAULT      = $00;
  WT_EXECUTEONLYONCE     = $08;
  WT_EXECUTELONGFUNCTION = $10;

function RegisterWaitForSingleObject(var phNewWaitObject: THandle;
 hObject: THandle; Callback: WaitOrTimerCallback; Context: Pointer;
 dwMilliseconds: Cardinal; dwFlags: Cardinal): Boolean; stdcall;
 external 'kernel32.dll';

function UnregisterWait(WaitHandle: THandle): Boolean; stdcall;
 external 'kernel32.dll';

{ -- Fin des d�lcarations }

procedure WaitCallback(RunProc: TRunProcess; TimeOrWaitFired: Boolean); stdcall;
begin
  RunProc.DoProcessEnd;
end;

constructor TRunProcess.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if not (csDesigning in ComponentState) then
    FDefaultDir := GetCurrentDir;
end;

destructor TRunProcess.Destroy;
begin
  if FWaitHandle <> 0 then
    UnregisterWait(FWaitHandle);
  inherited Destroy;
end;

function TRunProcess.Execute: Boolean;
begin
  {>> Ne pas executer plus d'une chose � la fois par composant }
  if IsProcessRunning then
    raise Exception.Create('Process is already running');

  {>> Remplit les infos }
  FillChar(FStartInfo, SizeOf(TStartupInfo), 0);
  FillChar(FProcessInfo, sizeOf(TProcessInformation), 0);
  FStartInfo.cb := SizeOf(TStartupInfo);

  {>> D�marre le processus }
  Result := CreateProcess(nil, PChar(FCommandLine), nil, nil, False, 0, nil,
   nil, FStartInfo, FProcessInfo);

  if Result then
  begin
    {>> D�marre l'attente }
    RegisterWaitForSingleObject(FWaitHandle, FProcessInfo.hProcess,
     WaitCallback, Self, INFINITE, WT_EXECUTEDEFAULT
     or WT_EXECUTELONGFUNCTION or WT_EXECUTEONLYONCE);

    {>> D�clanche l'�venement }
    if Assigned(FOnProcessBegin) then
      FOnProcessBegin(Self);
  end;
end;

function TRunProcess.IsProcessRunning: Boolean;
begin
  {>> Le processus tourne si la fonction d'attente �choue }
  Result := (FWaitHandle <> 0)
   and (WaitForSingleObject(FProcessInfo.hProcess, 0) = WAIT_TIMEOUT);
end;

procedure TRunProcess.DoProcessEnd;
begin
  {>> Arr�te l'attente }
  UnregisterWait(FWaitHandle);
  FWaitHandle := 0;

  {>> D�clenche l'�venement de fin }
  if Assigned(FOnProcessEnd) then
    FOnProcessEnd(Self);
end;


end.
