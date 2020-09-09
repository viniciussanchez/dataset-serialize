object FrmSamples: TFrmSamples
  Left = 0
  Top = 0
  Caption = 'DataSet-Serialize - Samples'
  ClientHeight = 561
  ClientWidth = 984
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel9: TPanel
    Left = 0
    Top = 0
    Width = 984
    Height = 25
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Caption = '  Configuration'
    Color = 16091980
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 25
    Width = 984
    Height = 165
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 466
      Top = 8
      Width = 248
      Height = 13
      Caption = 'Format date (for export field type equals ftDate):'
    end
    object Label4: TLabel
      Left = 466
      Top = 56
      Width = 289
      Height = 13
      Caption = 'Format currency (for export field type equals ftCurrency):'
    end
    object chkDateInputIsUTC: TCheckBox
      Left = 10
      Top = 6
      Width = 300
      Height = 17
      Caption = 'Date input is UTC (time zone)'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = chkDateInputIsUTCClick
    end
    object chkExportNullValues: TCheckBox
      Left = 10
      Top = 29
      Width = 300
      Height = 17
      Caption = 'Export null values'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = chkExportNullValuesClick
    end
    object chkExportOnlyFieldsVisible: TCheckBox
      Left = 10
      Top = 52
      Width = 300
      Height = 17
      Caption = 'Export only fields visible'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = chkExportOnlyFieldsVisibleClick
    end
    object chkFieldNameLowerCamelCasePattern: TCheckBox
      Left = 10
      Top = 75
      Width = 300
      Height = 17
      Caption = 'Field name in lowerCamelCase pattern'
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = chkFieldNameLowerCamelCasePatternClick
    end
    object edtFormatDate: TEdit
      Left = 466
      Top = 27
      Width = 326
      Height = 21
      TabOrder = 4
      Text = 'YYYY-MM-DD'
    end
    object btnApplyFormatDate: TButton
      Left = 798
      Top = 25
      Width = 58
      Height = 25
      Caption = 'Apply'
      TabOrder = 5
      OnClick = btnApplyFormatDateClick
    end
    object edtFormatCurrency: TEdit
      Left = 466
      Top = 75
      Width = 326
      Height = 21
      TabOrder = 6
      Text = '0.00##'
    end
    object btnFormatCurrency: TButton
      Left = 798
      Top = 73
      Width = 58
      Height = 25
      Caption = 'Apply'
      TabOrder = 7
      OnClick = btnFormatCurrencyClick
    end
    object chkImportOnlyFieldsVisible: TCheckBox
      Left = 10
      Top = 98
      Width = 300
      Height = 17
      Caption = 'Import only fields visible'
      Checked = True
      State = cbChecked
      TabOrder = 8
      OnClick = chkImportOnlyFieldsVisibleClick
    end
    object chkExportEmptyDataSet: TCheckBox
      Left = 10
      Top = 121
      Width = 300
      Height = 17
      Caption = 'Export empty dataset'
      Checked = True
      State = cbChecked
      TabOrder = 9
      OnClick = chkExportEmptyDataSetClick
    end
    object chkExportChildDataSetAsJsonObject: TCheckBox
      Left = 10
      Top = 142
      Width = 300
      Height = 17
      Hint = 
        'Child dataset needs to have just one record, if child dataset ha' +
        's more than one record it became an jsonarray again'
      Caption = 'Export child dataset as json object'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 10
      OnClick = chkExportChildDataSetAsJsonObjectClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 190
    Width = 984
    Height = 371
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 171
    ExplicitHeight = 390
    object Panel4: TPanel
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 200
      Height = 371
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitHeight = 390
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 200
        Height = 25
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = '  Fields visbile'
        Color = 16091980
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
      object chbFields: TCheckListBox
        Left = 0
        Top = 25
        Width = 200
        Height = 346
        Align = alClient
        ItemHeight = 13
        TabOrder = 1
        OnClick = chbFieldsClick
        ExplicitHeight = 365
      end
    end
    object Panel6: TPanel
      AlignWithMargins = True
      Left = 202
      Top = 0
      Width = 439
      Height = 371
      Margins.Left = 2
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitHeight = 390
      object Panel7: TPanel
        Left = 0
        Top = 0
        Width = 439
        Height = 25
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = '  Records'
        Color = 16091980
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
      object DBGrid1: TDBGrid
        Left = 0
        Top = 25
        Width = 439
        Height = 152
        Align = alTop
        DataSource = dsUsers
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        ParentFont = False
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NAME'
            Title.Caption = 'Name'
            Width = 120
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DATE_BIRTH'
            Title.Caption = 'Birthday'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SALARY'
            Title.Caption = 'Salary'
            Width = 100
            Visible = True
          end>
      end
      object Button1: TButton
        Left = 0
        Top = 336
        Width = 439
        Height = 35
        Align = alBottom
        Caption = 'ToJSONArray'
        TabOrder = 2
        OnClick = Button1Click
        ExplicitTop = 355
      end
      object DBGrid2: TDBGrid
        Left = 0
        Top = 177
        Width = 439
        Height = 159
        Align = alClient
        DataSource = dsLog
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        ParentFont = False
        TabOrder = 3
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Title.Caption = 'Id'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'LOG'
            Title.Caption = 'Log'
            Width = 324
            Visible = True
          end>
      end
    end
    object Panel8: TPanel
      AlignWithMargins = True
      Left = 643
      Top = 0
      Width = 341
      Height = 371
      Margins.Left = 2
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      ExplicitHeight = 390
      object Panel10: TPanel
        Left = 0
        Top = 0
        Width = 341
        Height = 25
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = '  JSON'
        Color = 16091980
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
      object memoJSON: TMemo
        Left = 0
        Top = 25
        Width = 341
        Height = 346
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
        ExplicitHeight = 365
      end
    end
  end
  object dsUsers: TDataSource
    DataSet = mtUsers
    Left = 840
    Top = 375
  end
  object mtUsers: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 896
    Top = 375
    object mtUsersID: TIntegerField
      AutoGenerateValue = arAutoInc
      DisplayLabel = 'Id'
      FieldName = 'ID'
    end
    object mtUsersNAME: TStringField
      FieldName = 'NAME'
      Size = 100
    end
    object mtUsersDATE_BIRTH: TDateField
      FieldName = 'DATE_BIRTH'
    end
    object mtUsersSALARY: TCurrencyField
      FieldName = 'SALARY'
    end
  end
  object dsLog: TDataSource
    DataSet = mtLog
    Left = 840
    Top = 431
  end
  object mtLog: TFDMemTable
    IndexFieldNames = 'ID_USER'
    MasterSource = dsUsers
    MasterFields = 'ID'
    DetailFields = 'ID_USER'
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 896
    Top = 431
    object mtLogID: TIntegerField
      FieldName = 'ID'
    end
    object mtLogID_USER: TIntegerField
      FieldName = 'ID_USER'
    end
    object mtLogLOG: TStringField
      FieldName = 'LOG'
      Size = 250
    end
  end
end
