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
    ExplicitWidth = 420
  end
  object Panel1: TPanel
    Left = 0
    Top = 25
    Width = 984
    Height = 230
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 31
    object Label1: TLabel
      Left = 10
      Top = 130
      Width = 248
      Height = 13
      Caption = 'Format date (for export field type equals ftDate):'
    end
    object Label4: TLabel
      Left = 10
      Top = 178
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
      Left = 10
      Top = 149
      Width = 326
      Height = 21
      TabOrder = 4
      Text = 'YYYY-MM-DD'
    end
    object btnApplyFormatDate: TButton
      Left = 342
      Top = 147
      Width = 58
      Height = 25
      Caption = 'Apply'
      TabOrder = 5
      OnClick = btnApplyFormatDateClick
    end
    object edtFormatCurrency: TEdit
      Left = 10
      Top = 197
      Width = 326
      Height = 21
      TabOrder = 6
      Text = '0.00##'
    end
    object btnFormatCurrency: TButton
      Left = 342
      Top = 195
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
  end
  object Panel3: TPanel
    Left = 0
    Top = 255
    Width = 984
    Height = 306
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitLeft = 352
    ExplicitTop = 392
    ExplicitWidth = 185
    ExplicitHeight = 41
    object Panel4: TPanel
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 200
      Height = 306
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitTop = 25
      ExplicitHeight = 281
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
        ExplicitTop = 8
        ExplicitWidth = 185
      end
      object chbFields: TCheckListBox
        Left = 0
        Top = 25
        Width = 200
        Height = 281
        Align = alClient
        ItemHeight = 13
        TabOrder = 1
        OnClick = chbFieldsClick
        ExplicitHeight = 251
      end
    end
    object Panel6: TPanel
      AlignWithMargins = True
      Left = 202
      Top = 0
      Width = 439
      Height = 306
      Margins.Left = 2
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 210
      ExplicitTop = 30
      ExplicitHeight = 271
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
        ExplicitWidth = 200
      end
      object DBGrid1: TDBGrid
        Left = 0
        Top = 25
        Width = 439
        Height = 246
        Align = alClient
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
        Top = 271
        Width = 439
        Height = 35
        Align = alBottom
        Caption = 'ToJSONArray'
        TabOrder = 2
        OnClick = Button1Click
        ExplicitTop = 25
      end
    end
    object Panel8: TPanel
      AlignWithMargins = True
      Left = 643
      Top = 0
      Width = 341
      Height = 306
      Margins.Left = 2
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      ExplicitLeft = 0
      ExplicitTop = 25
      ExplicitWidth = 200
      ExplicitHeight = 281
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
        ExplicitLeft = 1
        ExplicitTop = 1
        ExplicitWidth = 325
      end
      object memoJSON: TMemo
        Left = 0
        Top = 25
        Width = 341
        Height = 281
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
        ExplicitWidth = 542
        ExplicitHeight = 508
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
end
