object FrmSamples: TFrmSamples
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'DataSet Serialize - Samples'
  ClientHeight = 571
  ClientWidth = 994
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pclDataSetSerialize: TPageControl
    Left = 0
    Top = 0
    Width = 994
    Height = 571
    ActivePage = tabDataSet
    Align = alClient
    TabOrder = 0
    object tabDataSet: TTabSheet
      Caption = 'DataSet'
      object Splitter1: TSplitter
        Left = 481
        Top = 0
        Width = 9
        Height = 543
        ExplicitLeft = 472
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 481
        Height = 543
        Align = alLeft
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        object Label2: TLabel
          Left = 8
          Top = 12
          Width = 27
          Height = 13
          Caption = 'Name'
        end
        object Label3: TLabel
          Left = 264
          Top = 12
          Width = 39
          Height = 13
          Caption = 'Country'
        end
        object DBGrid1: TDBGrid
          Left = 0
          Top = 120
          Width = 481
          Height = 423
          Align = alBottom
          DataSource = dsDataSet
          TabOrder = 0
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
              Width = 250
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'COUNTRY'
              Width = 145
              Visible = True
            end>
        end
        object edtName: TEdit
          Left = 8
          Top = 31
          Width = 250
          Height = 21
          TabOrder = 1
        end
        object edtCountry: TEdit
          Left = 264
          Top = 31
          Width = 124
          Height = 21
          TabOrder = 2
        end
        object Button2: TButton
          Left = 394
          Top = 29
          Width = 81
          Height = 25
          Caption = 'Append'
          TabOrder = 3
          OnClick = Button2Click
        end
        object Panel3: TPanel
          Left = 0
          Top = 79
          Width = 481
          Height = 41
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 4
          object Button1: TButton
            Left = 155
            Top = 0
            Width = 171
            Height = 41
            Align = alClient
            Caption = 'ToJSONArray'
            TabOrder = 0
            OnClick = Button1Click
          end
          object Button3: TButton
            Left = 326
            Top = 0
            Width = 155
            Height = 41
            Align = alRight
            Caption = 'SaveStructure'
            TabOrder = 1
            OnClick = Button3Click
          end
          object Button4: TButton
            Left = 0
            Top = 0
            Width = 155
            Height = 41
            Align = alLeft
            Caption = 'ToJSONObject'
            TabOrder = 2
            OnClick = Button4Click
          end
        end
      end
      object Panel2: TPanel
        Left = 490
        Top = 0
        Width = 496
        Height = 543
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel2'
        TabOrder = 1
        object mmDataSet: TMemo
          Left = 0
          Top = 0
          Width = 496
          Height = 543
          Align = alClient
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
    object tabJSON: TTabSheet
      Caption = 'JSON'
      ImageIndex = 1
      object Splitter2: TSplitter
        Left = 481
        Top = 0
        Width = 9
        Height = 543
        ExplicitLeft = 475
        ExplicitTop = 16
      end
      object DBGridStructure: TDBGrid
        Left = 490
        Top = 0
        Width = 496
        Height = 543
        Align = alClient
        DataSource = dsJSON
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 481
        Height = 543
        Align = alLeft
        TabOrder = 1
        object mmJSONArray: TMemo
          Left = 1
          Top = 336
          Width = 479
          Height = 117
          Align = alTop
          Lines.Strings = (
            '['
            '  {'
            '    "NAME": "Vinicius Sanchez",'
            '    "COUNTRY": "Brazil"'
            '  },'
            '  {'
            '    "NAME": "Julio Cesar Senha",'
            '    "COUNTRY": "Brazil"'
            '  },'
            '  {'
            '    "NAME": "Mateus Vicente",'
            '    "COUNTRY": "Brazil"'
            '  },'
            '  {'
            '    "NAME": "Eduardo Viana Pessoa",'
            '    "COUNTRY": "Brazil"'
            '  },'
            '  {'
            '    "NAME": "Alan Carlos Echer",'
            '    "COUNTRY": "Brazil"'
            '  },'
            '  {'
            '    "NAME": "Luis Gustavo de Miranda",'
            '    "COUNTRY": "Brazil"'
            '  },'
            '  {'
            '    "NAME": "Fagner Granella",'
            '    "COUNTRY": "Brazil"'
            '  }'
            ']')
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
        object Panel5: TPanel
          Left = 1
          Top = 308
          Width = 479
          Height = 28
          Align = alTop
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 1
          ExplicitTop = 273
          object Button7: TButton
            Left = 0
            Top = 0
            Width = 479
            Height = 28
            Align = alClient
            Caption = 'Load from JSON Array'
            TabOrder = 0
            OnClick = Button7Click
          end
        end
        object Panel8: TPanel
          Left = 1
          Top = 453
          Width = 479
          Height = 28
          Align = alTop
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 2
          object Button8: TButton
            Left = 0
            Top = 0
            Width = 479
            Height = 28
            Align = alClient
            Caption = 'Merge (Edit current record)'
            TabOrder = 0
            OnClick = Button8Click
          end
        end
        object mmMerge: TMemo
          Left = 1
          Top = 481
          Width = 479
          Height = 62
          Align = alTop
          Lines.Strings = (
            '{'
            '  "NAME": "Vinicius",'
            '  "COUNTRY": "United States"'
            '}')
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 3
        end
        object Panel9: TPanel
          Left = 1
          Top = 1
          Width = 479
          Height = 307
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 4
          object Panel10: TPanel
            Left = 193
            Top = 0
            Width = 286
            Height = 307
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            ExplicitLeft = 0
            ExplicitWidth = 144
            ExplicitHeight = 272
            object mmJSONObject: TMemo
              Left = 0
              Top = 28
              Width = 286
              Height = 71
              Align = alClient
              Lines.Strings = (
                '{'
                '  "NAME": "Vinicius Sanchez",'
                '  "COUNTRY": "Brazil"'
                '}')
              ReadOnly = True
              ScrollBars = ssVertical
              TabOrder = 0
              ExplicitHeight = 101
            end
            object Panel6: TPanel
              Left = 0
              Top = 0
              Width = 286
              Height = 28
              Align = alTop
              BevelOuter = bvNone
              ParentBackground = False
              TabOrder = 1
              ExplicitLeft = 2
              ExplicitTop = 9
              ExplicitWidth = 183
              object Button6: TButton
                Left = 0
                Top = 0
                Width = 286
                Height = 28
                Align = alClient
                Caption = 'Load from JSON Object'
                TabOrder = 0
                OnClick = Button6Click
                ExplicitWidth = 183
              end
            end
            object mmValidateJSON: TMemo
              Left = 0
              Top = 127
              Width = 286
              Height = 58
              Align = alBottom
              Lines.Strings = (
                '{'
                '  "COUNTRY": "Brazil"'
                '}')
              ReadOnly = True
              ScrollBars = ssVertical
              TabOrder = 2
              ExplicitTop = 138
            end
            object Panel12: TPanel
              Left = 0
              Top = 99
              Width = 286
              Height = 28
              Align = alBottom
              BevelOuter = bvNone
              ParentBackground = False
              TabOrder = 3
              ExplicitTop = 8
              object Button9: TButton
                Left = 0
                Top = 0
                Width = 286
                Height = 28
                Align = alClient
                Caption = 'Validate JSON'
                TabOrder = 0
                OnClick = Button9Click
              end
            end
            object mmJSONArrayValidate: TMemo
              Left = 0
              Top = 185
              Width = 286
              Height = 122
              Align = alBottom
              ReadOnly = True
              ScrollBars = ssVertical
              TabOrder = 4
              ExplicitTop = 184
            end
          end
          object Panel13: TPanel
            Left = 0
            Top = 0
            Width = 193
            Height = 307
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 1
            ExplicitHeight = 272
            object Panel7: TPanel
              Left = 0
              Top = 0
              Width = 193
              Height = 28
              Align = alTop
              BevelOuter = bvNone
              ParentBackground = False
              TabOrder = 0
              ExplicitTop = 8
              ExplicitWidth = 479
              object Button5: TButton
                Left = 0
                Top = 0
                Width = 193
                Height = 28
                Align = alClient
                Caption = 'Load structure'
                TabOrder = 0
                OnClick = Button5Click
                ExplicitWidth = 479
              end
            end
            object mmStructure: TMemo
              Left = 0
              Top = 28
              Width = 193
              Height = 279
              Align = alClient
              Lines.Strings = (
                '['
                '  {'
                '    "FieldName": "ID",'
                '    "DisplayLabel": "Id",'
                '    "DataType": "ftInteger",'
                '    "Size": 0,'
                '    "Key": false,'
                '    "Origin": "",'
                '    "Required": true,'
                '    "Visible": true'
                '  },'
                '  {'
                '    "FieldName": "NAME",'
                '    "DisplayLabel": "Name",'
                '    "DataType": "ftString",'
                '    "Size": 100,'
                '    "Key": false,'
                '    "Origin": "",'
                '    "Required": true,'
                '    "Visible": true'
                '  },'
                '  {'
                '    "FieldName": "COUNTRY",'
                '    "DisplayLabel": "Country",'
                '    "DataType": "ftString",'
                '    "Size": 60,'
                '    "Key": false,'
                '    "Origin": "",'
                '    "Required": false,'
                '    "Visible": false'
                '  }'
                ']')
              ReadOnly = True
              ScrollBars = ssVertical
              TabOrder = 1
              ExplicitTop = -111
              ExplicitWidth = 479
              ExplicitHeight = 152
            end
          end
        end
      end
    end
  end
  object mtDataSet: TFDMemTable
    AfterInsert = mtDataSetAfterInsert
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 912
    Top = 496
    object mtDataSetID: TIntegerField
      DisplayLabel = 'Id'
      FieldName = 'ID'
      Required = True
    end
    object mtDataSetNAME: TStringField
      DisplayLabel = 'Name'
      FieldName = 'NAME'
      Required = True
      Size = 100
    end
    object mtDataSetCOUNTRY: TStringField
      DisplayLabel = 'Country'
      FieldName = 'COUNTRY'
      Visible = False
      Size = 60
    end
  end
  object dsDataSet: TDataSource
    DataSet = mtDataSet
    Left = 880
    Top = 496
  end
  object mtJSON: TFDMemTable
    AfterInsert = mtJSONAfterInsert
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 816
    Top = 496
  end
  object dsJSON: TDataSource
    DataSet = mtJSON
    Left = 784
    Top = 496
  end
end
