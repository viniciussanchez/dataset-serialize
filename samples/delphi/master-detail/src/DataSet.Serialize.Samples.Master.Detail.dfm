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
  object pclSamples: TPageControl
    Left = 0
    Top = 0
    Width = 984
    Height = 561
    ActivePage = tabArrayValue
    Align = alClient
    MultiLine = True
    TabOrder = 0
    object tabNestedJSON: TTabSheet
      Caption = ' Nested JSON'
      object Panel7: TPanel
        Left = 0
        Top = 0
        Width = 976
        Height = 533
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alClient
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 250
          Height = 533
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
          object memoJSONNested: TMemo
            Left = 0
            Top = 0
            Width = 250
            Height = 498
            Align = alClient
            Lines.Strings = (
              '['
              '  {'
              '    "name": "Brazil",'
              '    "sigle": "BRL",'
              '    "states": ['
              '      {'
              '        "name": "S'#227'o Paulo",'
              '        "sigle": "SP",'
              '        "cities": ['
              '          {'
              '            "name": "Fernand'#243'polis",'
              '            "zipCode": "15600-000"'
              '          },'
              '          {'
              '            "name": "Maced'#244'nia",'
              '            "zipCode": "15620-000"'
              '          },'
              '          {'
              '            "name": "Jales",'
              '            "zipCode": "14859-000"'
              '          },'
              '          {'
              '            "name": "S'#227'o Jos'#233' do Rio Preto",'
              '            "zipCode": "18450-450"'
              '          },'
              '          {'
              '            "name": "B'#225'lsamo",'
              '            "zipCode": "15140-000"'
              '          }'
              '        ]'
              '      },'
              '      {'
              '        "name": "Paran'#225'",'
              '        "sigle": "PR",'
              '        "cities": ['
              '          {'
              '            "name": "Maring'#225'",'
              '            "zipCode": "87050-000"'
              '          },'
              '          {'
              '            "name": "Londrina",'
              '            "zipCode": "86010-190"'
              '          }'
              '        ]'
              '      }'
              '    ]'
              '  },'
              '  {'
              '    "name": "United States",'
              '    "sigle": "USD",'
              '    "states": ['
              '      {'
              '        "name": "Texas",'
              '        "sigle": "TX",'
              '        "cities": ['
              '          {'
              '            "name": "Houston",'
              '            "zipCode": "77001"'
              '          },'
              '          {'
              '            "name": "Dalas",'
              '            "zipCode": "75001"'
              '          },'
              '          {'
              '            "name": "Austin",'
              '            "zipCode": "73301"'
              '          }'
              '        ]'
              '      },'
              '      {'
              '        "name": "California",'
              '        "sigle": "CA",'
              '        "cities": ['
              '          {'
              '            "name": "Los Angeles",'
              '            "zipCode": "90001"'
              '          },'
              '          {'
              '            "name": "San Diego",'
              '            "zipCode": "22434"'
              '          }'
              '        ]'
              '      }'
              '    ]'
              '  }'
              ']')
            ScrollBars = ssVertical
            TabOrder = 0
          end
          object btnLoadFromJSONArray: TButton
            Left = 0
            Top = 498
            Width = 250
            Height = 35
            Align = alBottom
            Caption = 'Load from JSONArray'
            TabOrder = 1
            OnClick = btnLoadFromJSONArrayClick
          end
        end
        object Panel3: TPanel
          Left = 726
          Top = 0
          Width = 250
          Height = 533
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 1
          object btnExportJSONArray: TButton
            Left = 0
            Top = 498
            Width = 250
            Height = 35
            Align = alBottom
            Caption = 'Export to JSONArray'
            TabOrder = 0
            OnClick = btnExportJSONArrayClick
          end
          object memoExportedDataSetNested: TMemo
            Left = 0
            Top = 0
            Width = 250
            Height = 498
            Align = alClient
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 1
            ExplicitLeft = 3
            ExplicitTop = -6
          end
        end
        object Panel5: TPanel
          AlignWithMargins = True
          Left = 252
          Top = 0
          Width = 472
          Height = 533
          Margins.Left = 2
          Margins.Top = 0
          Margins.Right = 2
          Margins.Bottom = 0
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 2
          object Panel6: TPanel
            Left = 0
            Top = 274
            Width = 472
            Height = 259
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            object Panel12: TPanel
              Left = 0
              Top = 0
              Width = 472
              Height = 25
              Align = alTop
              Alignment = taLeftJustify
              BevelOuter = bvNone
              Caption = '  Cities'
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
            object DBGrid3: TDBGrid
              Left = 0
              Top = 25
              Width = 472
              Height = 234
              Align = alClient
              DataSource = dsCities
              TabOrder = 1
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -11
              TitleFont.Name = 'Segoe UI'
              TitleFont.Style = []
              Columns = <
                item
                  Expanded = False
                  FieldName = 'NAME'
                  Title.Caption = 'Name'
                  Width = 290
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'ZIP_CODE'
                  Title.Caption = 'Zip code'
                  Width = 100
                  Visible = True
                end>
            end
          end
          object Panel8: TPanel
            Left = 0
            Top = 137
            Width = 472
            Height = 137
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 1
            object Panel13: TPanel
              Left = 0
              Top = 0
              Width = 472
              Height = 25
              Align = alTop
              Alignment = taLeftJustify
              BevelOuter = bvNone
              Caption = '  States'
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
              Width = 472
              Height = 112
              Align = alClient
              DataSource = dsStates
              TabOrder = 1
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -11
              TitleFont.Name = 'Segoe UI'
              TitleFont.Style = []
              Columns = <
                item
                  Expanded = False
                  FieldName = 'NAME'
                  Title.Caption = 'Name'
                  Width = 350
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'SIGLE'
                  Title.Alignment = taCenter
                  Title.Caption = 'Sigle'
                  Width = 40
                  Visible = True
                end>
            end
          end
          object Panel10: TPanel
            Left = 0
            Top = 0
            Width = 472
            Height = 137
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 2
            object Panel11: TPanel
              Left = 0
              Top = 0
              Width = 472
              Height = 25
              Align = alTop
              Alignment = taLeftJustify
              BevelOuter = bvNone
              Caption = '  Countries'
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
            object DBGrid2: TDBGrid
              Left = 0
              Top = 25
              Width = 472
              Height = 112
              Align = alClient
              DataSource = dsCountries
              TabOrder = 1
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -11
              TitleFont.Name = 'Segoe UI'
              TitleFont.Style = []
              Columns = <
                item
                  Expanded = False
                  FieldName = 'NAME'
                  Title.Caption = 'Name'
                  Width = 350
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'SIGLE'
                  Title.Alignment = taCenter
                  Title.Caption = 'Sigle'
                  Width = 40
                  Visible = True
                end>
            end
          end
        end
      end
    end
    object tabArrayValue: TTabSheet
      Caption = '  Array Value  '
      ImageIndex = 1
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 976
        Height = 533
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alClient
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        object Panel4: TPanel
          Left = 0
          Top = 0
          Width = 250
          Height = 533
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
          object memoArrayValue: TMemo
            Left = 0
            Top = 0
            Width = 250
            Height = 498
            Align = alClient
            Lines.Strings = (
              '['
              '  {'
              '    "id": 1,'
              '    "name": "Mateus Vicente",'
              '    "array": ['
              '      1,'
              '      2,'
              '      3,'
              '      4,'
              '      5,'
              '      6'
              '    ]'
              '  },'
              '  {'
              '    "id": 2,'
              '    "name": "Vinicius Sanchez",'
              '    "array": ['
              '      1,'
              '      2,'
              '      3,'
              '      4'
              '    ]'
              '  },'
              '  {'
              '    "id": 3,'
              '    "name": "Julio Cesar Senha",'
              '    "array": ['
              '      1,'
              '      2'
              '    ]'
              '  }'
              ']')
            ScrollBars = ssVertical
            TabOrder = 0
          end
          object btnLoadArrayFromJSONArray: TButton
            Left = 0
            Top = 498
            Width = 250
            Height = 35
            Align = alBottom
            Caption = 'Load from JSONArray'
            TabOrder = 1
            OnClick = btnLoadArrayFromJSONArrayClick
          end
        end
        object Panel9: TPanel
          AlignWithMargins = True
          Left = 252
          Top = 0
          Width = 472
          Height = 533
          Margins.Left = 2
          Margins.Top = 0
          Margins.Right = 2
          Margins.Bottom = 0
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          ExplicitWidth = 722
          object Panel16: TPanel
            Left = 0
            Top = 150
            Width = 472
            Height = 383
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            ExplicitWidth = 722
            object Panel17: TPanel
              Left = 0
              Top = 0
              Width = 472
              Height = 25
              Align = alTop
              Alignment = taLeftJustify
              BevelOuter = bvNone
              Caption = '  Values'
              Color = 16091980
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
              ExplicitWidth = 722
            end
            object DBGrid5: TDBGrid
              Left = 0
              Top = 25
              Width = 472
              Height = 358
              Align = alClient
              DataSource = dsArray
              TabOrder = 1
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -11
              TitleFont.Name = 'Segoe UI'
              TitleFont.Style = []
              Columns = <
                item
                  Expanded = False
                  FieldName = 'VALUE'
                  Title.Caption = 'Values'
                  Width = 173
                  Visible = True
                end>
            end
          end
          object Panel18: TPanel
            Left = 0
            Top = 0
            Width = 472
            Height = 150
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 1
            ExplicitWidth = 722
            object Panel19: TPanel
              Left = 0
              Top = 0
              Width = 472
              Height = 25
              Align = alTop
              Alignment = taLeftJustify
              BevelOuter = bvNone
              Caption = '  Users'
              Color = 16091980
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
              ExplicitWidth = 722
            end
            object DBGrid6: TDBGrid
              Left = 0
              Top = 25
              Width = 472
              Height = 125
              Align = alClient
              DataSource = dsUsers
              TabOrder = 1
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -11
              TitleFont.Name = 'Segoe UI'
              TitleFont.Style = []
              Columns = <
                item
                  Expanded = False
                  FieldName = 'ID'
                  Width = 60
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'NAME'
                  Title.Caption = 'Name'
                  Width = 600
                  Visible = True
                end>
            end
          end
        end
        object Panel14: TPanel
          Left = 726
          Top = 0
          Width = 250
          Height = 533
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 2
          object btnExportArrayValue: TButton
            Left = 0
            Top = 498
            Width = 250
            Height = 35
            Align = alBottom
            Caption = 'Export to JSONArray'
            TabOrder = 0
            OnClick = btnExportArrayValueClick
          end
          object memoExportArrayValue: TMemo
            Left = 0
            Top = 0
            Width = 250
            Height = 498
            Align = alClient
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 1
          end
        end
      end
    end
  end
  object mtCountries: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 648
    Top = 496
    object mtCountriesID: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'ID'
    end
    object mtCountriesNAME: TStringField
      FieldName = 'NAME'
      Size = 100
    end
    object mtCountriesSIGLE: TStringField
      Alignment = taCenter
      FieldName = 'SIGLE'
      Size = 3
    end
  end
  object dsCountries: TDataSource
    DataSet = mtCountries
    Left = 568
    Top = 496
  end
  object dsStates: TDataSource
    DataSet = mtStates
    Left = 568
    Top = 440
  end
  object mtStates: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 648
    Top = 440
    object mtStatesID: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'ID'
    end
    object mtStatesID_COUNTRY: TIntegerField
      FieldName = 'ID_COUNTRY'
    end
    object mtStatesNAME: TStringField
      FieldName = 'NAME'
      Size = 100
    end
    object mtStatesSIGLE: TStringField
      Alignment = taCenter
      FieldName = 'SIGLE'
      Size = 2
    end
  end
  object mtCities: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 648
    Top = 384
    object mtCitiesID: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'ID'
    end
    object mtCitiesID_STATE: TIntegerField
      FieldName = 'ID_STATE'
    end
    object mtCitiesNAME: TStringField
      FieldName = 'NAME'
      Size = 100
    end
    object mtCitiesZIP_CODE: TStringField
      FieldName = 'ZIP_CODE'
    end
  end
  object dsCities: TDataSource
    DataSet = mtCities
    Left = 568
    Top = 384
  end
  object mtUsers: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 824
    Top = 440
    object IntegerField1: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'ID'
    end
    object StringField1: TStringField
      FieldName = 'NAME'
      Size = 100
    end
    object mtUsersARRAY: TDataSetField
      FieldName = 'ARRAY'
    end
  end
  object dsUsers: TDataSource
    DataSet = mtUsers
    Left = 744
    Top = 440
  end
  object dsArray: TDataSource
    DataSet = mtArray
    Left = 744
    Top = 384
  end
  object mtArray: TFDMemTable
    DataSetField = mtUsersARRAY
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 824
    Top = 384
    object mtArrayVALUE: TIntegerField
      FieldName = 'VALUE'
    end
  end
end
