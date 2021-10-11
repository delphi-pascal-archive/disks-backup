object BackupForm: TBackupForm
  Left = 215
  Top = 122
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Disks Backup'
  ClientHeight = 522
  ClientWidth = 994
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 176
    Top = 8
    Width = 145
    Height = 32
    Caption = 'Choisir les disques ou partitions a sauvegarder'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 536
    Top = 16
    Width = 188
    Height = 16
    Caption = 'Repertoire de DriveImage XML:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 368
    Top = 16
    Width = 151
    Height = 16
    Caption = 'Nombre de sauvegardes'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label4: TLabel
    Left = 8
    Top = 8
    Width = 138
    Height = 32
    Caption = 'Choisir le repertoire de sauvegarde general'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label5: TLabel
    Left = 536
    Top = 72
    Width = 182
    Height = 16
    Caption = 'Choisir le taux de compression'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label6: TLabel
    Left = 536
    Top = 184
    Width = 217
    Height = 16
    Caption = 'Commandes en cours ou executees:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object GOButton: TButton
    Left = 176
    Top = 488
    Width = 185
    Height = 25
    Caption = 'Start backup'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = GOButtonClick
  end
  object Quitbtn: TButton
    Left = 536
    Top = 488
    Width = 449
    Height = 25
    Caption = 'Exit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = QuitbtnClick
  end
  object DixDirEdit: TEdit
    Left = 536
    Top = 40
    Width = 449
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object NbBackListBox: TValueListEditor
    Left = 400
    Top = 48
    Width = 81
    Height = 465
    DefaultRowHeight = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    TitleCaptions.Strings = (
      'HD'
      'Nb')
    OnValidate = NbBackListBoxValidate
    ColWidths = (
      36
      39)
  end
  object ChoixDix: TButton
    Left = 760
    Top = 8
    Width = 121
    Height = 25
    Caption = 'Directory'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = ChoixDixClick
  end
  object AjoutButton: TButton
    Left = 8
    Top = 488
    Width = 161
    Height = 25
    Caption = 'Add directory'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = AjoutButtonClick
  end
  object RadioGroup1: TRadioGroup
    Left = 536
    Top = 98
    Width = 449
    Height = 63
    Caption = ' Taux de compression '
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 6
  end
  object TheMemo: TMemo
    Left = 536
    Top = 208
    Width = 449
    Height = 273
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 7
    WordWrap = False
  end
  object HelpDIXBtn: TButton
    Left = 888
    Top = 8
    Width = 97
    Height = 25
    Caption = 'Help'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    OnClick = HelpDIXBtnClick
  end
  object DriveListBox: TCheckListBox
    Left = 176
    Top = 48
    Width = 185
    Height = 433
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ItemHeight = 20
    ParentFont = False
    TabOrder = 9
  end
  object DirectoryListBox: TListBox
    Left = 8
    Top = 48
    Width = 161
    Height = 433
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ItemHeight = 20
    ParentFont = False
    TabOrder = 10
    OnClick = DirectoryListBoxClick
  end
  object NoCompress: TRadioButton
    Left = 579
    Top = 123
    Width = 70
    Height = 21
    Caption = 'Aucun'
    Checked = True
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 11
    TabStop = True
  end
  object FastCompress: TRadioButton
    Left = 714
    Top = 123
    Width = 119
    Height = 21
    Caption = 'Faible (rapide)'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 12
  end
  object SlowCompress: TRadioButton
    Left = 878
    Top = 123
    Width = 83
    Height = 21
    Caption = 'Fort (lent)'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 13
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Fichiers executables|*.exe'
    Left = 16
    Top = 56
  end
end
