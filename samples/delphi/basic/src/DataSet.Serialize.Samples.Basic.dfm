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
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 13
  object pclSamples: TPageControl
    Left = 0
    Top = 0
    Width = 984
    Height = 561
    ActivePage = tabDataSet
    Align = alClient
    MultiLine = True
    TabOrder = 0
    object tabDataSet: TTabSheet
      Caption = ' DataSet '
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
        object Splitter1: TSplitter
          Left = 425
          Top = 0
          Width = 9
          Height = 533
          ExplicitLeft = 448
          ExplicitHeight = 433
        end
        object Panel2: TPanel
          Left = 434
          Top = 0
          Width = 542
          Height = 533
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alClient
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 0
          object Panel4: TPanel
            Left = 0
            Top = 0
            Width = 542
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
          object memoDataSet: TMemo
            Left = 0
            Top = 25
            Width = 542
            Height = 508
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
          end
        end
        object Panel1: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 420
          Height = 533
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alLeft
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 1
          object Panel3: TPanel
            Left = 0
            Top = 0
            Width = 420
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
          end
          object Panel5: TPanel
            Left = 0
            Top = 25
            Width = 420
            Height = 55
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 1
            object Label2: TLabel
              Left = 13
              Top = 6
              Width = 29
              Height = 13
              Caption = 'Name'
            end
            object Label3: TLabel
              Left = 169
              Top = 6
              Width = 41
              Height = 13
              Caption = 'Country'
            end
            object edtName: TEdit
              Left = 13
              Top = 25
              Width = 150
              Height = 21
              TabOrder = 0
            end
            object edtCountry: TEdit
              Left = 169
              Top = 25
              Width = 150
              Height = 21
              TabOrder = 1
            end
            object Button2: TButton
              Left = 325
              Top = 23
              Width = 81
              Height = 25
              Caption = 'Append'
              TabOrder = 2
              OnClick = Button2Click
            end
          end
          object DBGrid1: TDBGrid
            Left = 0
            Top = 80
            Width = 420
            Height = 418
            Align = alClient
            DataSource = dsUsers
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
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
                Width = 150
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'COUNTRY'
                Width = 150
                Visible = True
              end>
          end
          object Panel6: TPanel
            Left = 0
            Top = 498
            Width = 420
            Height = 35
            Align = alBottom
            BevelOuter = bvNone
            TabOrder = 3
            object Button4: TButton
              Left = 0
              Top = 0
              Width = 140
              Height = 35
              Align = alLeft
              Caption = 'ToJSONObject'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnClick = Button4Click
            end
            object Button1: TButton
              Left = 140
              Top = 0
              Width = 140
              Height = 35
              Align = alClient
              Caption = 'ToJSONArray'
              TabOrder = 1
              OnClick = Button1Click
            end
            object Button3: TButton
              Left = 280
              Top = 0
              Width = 140
              Height = 35
              Align = alRight
              Caption = 'SaveStructure'
              TabOrder = 2
              OnClick = Button3Click
            end
          end
        end
      end
    end
    object tabJSON: TTabSheet
      Caption = '  JSON  '
      ImageIndex = 1
      object Panel13: TPanel
        Left = 0
        Top = 0
        Width = 976
        Height = 533
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel13'
        ParentBackground = False
        TabOrder = 0
        object Splitter2: TSplitter
          Left = 425
          Top = 0
          Width = 9
          Height = 533
          ExplicitLeft = 437
        end
        object Panel10: TPanel
          Left = 434
          Top = 0
          Width = 542
          Height = 533
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alClient
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 0
          object Panel11: TPanel
            Left = 0
            Top = 0
            Width = 542
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
          object Panel12: TPanel
            Left = 0
            Top = 25
            Width = 542
            Height = 288
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 1
            object memoJSONArray: TMemo
              Left = 0
              Top = 35
              Width = 542
              Height = 253
              Align = alClient
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Segoe UI'
              Font.Style = []
              Lines.Strings = (
                '['
                '  {'
                '    "id": 1,'
                '    "name": "Mateus Vicente",'
                '    "country": "Brazil"'
                '  },'
                '  {'
                '    "id": 2,'
                '    "name": "Vinicius Sanchez",'
                '    "country": "Brazil"'
                '  },'
                '  {'
                '    "id": 3,'
                '    "name": "Julio Senha",'
                '    "country": "Brazil"'
                '  },'
                '  {'
                '    "id": 4,'
                '    "name": "Andr'#233' Dias",'
                '    "country": "Brazil"'
                '  },'
                '  {'
                '    "id": 5,'
                '    "name": "Luis Gustavo",'
                '    "country": "Brazil"'
                '  },'
                '  {'
                '    "id": 6,'
                '    "name": "Jos'#233' Junior",'
                '    "country": "Brazil"'
                '  },'
                '  {'
                '    "id": 7,'
                '    "name": "Fagner Granella",'
                '    "country": "Brazil"'
                '  },'
                '  {'
                '    "id": 8,'
                '    "name": "Eduardo Viana",'
                '    "country": "Brazil"'
                '  },'
                '  {'
                '    "id": 9,'
                '    "name": "Alan Echer",'
                '    "country": "Brazil"'
                '  }'
                ']')
              ParentFont = False
              ReadOnly = True
              ScrollBars = ssVertical
              TabOrder = 0
            end
            object btnLoadJSONArray: TButton
              Left = 0
              Top = 0
              Width = 542
              Height = 35
              Align = alTop
              Caption = 'Load from JSON Array'
              TabOrder = 1
              OnClick = btnLoadJSONArrayClick
            end
          end
          object Panel14: TPanel
            Left = 0
            Top = 313
            Width = 542
            Height = 110
            Align = alBottom
            BevelOuter = bvNone
            TabOrder = 2
            object memoJSONObject: TMemo
              Left = 0
              Top = 35
              Width = 542
              Height = 75
              Align = alClient
              Lines.Strings = (
                '{'
                '  "name": "Caio Ariel",'
                '  "country": "Brazil"'
                '}')
              ReadOnly = True
              ScrollBars = ssVertical
              TabOrder = 0
            end
            object Button5: TButton
              Left = 0
              Top = 0
              Width = 542
              Height = 35
              Align = alTop
              Caption = 'Load from JSON Object'
              TabOrder = 1
              OnClick = Button5Click
            end
          end
          object Panel15: TPanel
            Left = 0
            Top = 423
            Width = 542
            Height = 110
            Align = alBottom
            BevelOuter = bvNone
            TabOrder = 3
            object Button6: TButton
              Left = 0
              Top = 0
              Width = 542
              Height = 35
              Align = alTop
              Caption = 'Merge (Edit current record)'
              TabOrder = 0
              OnClick = Button6Click
            end
            object memoMerge: TMemo
              Left = 0
              Top = 35
              Width = 542
              Height = 75
              Align = alClient
              Lines.Strings = (
                '{'
                '  "name": "Vitor Saves",'
                '  "country": "United States"'
                '}')
              ReadOnly = True
              ScrollBars = ssVertical
              TabOrder = 1
            end
          end
        end
        object Panel8: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 420
          Height = 533
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alLeft
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 1
          object Panel9: TPanel
            Left = 0
            Top = 0
            Width = 420
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
          end
          object DBGrid2: TDBGrid
            Left = 0
            Top = 25
            Width = 420
            Height = 508
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
                Width = 60
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'NAME'
                Title.Caption = 'Name'
                Width = 150
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'COUNTRY'
                Width = 150
                Visible = True
              end>
          end
        end
      end
    end
    object tabEmptyDataSet: TTabSheet
      Caption = 'Load empty DataSet'
      ImageIndex = 2
      object Panel16: TPanel
        Left = 0
        Top = 244
        Width = 976
        Height = 25
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'DataSet'
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
        Top = 294
        Width = 672
        Height = 239
        Align = alClient
        DataSource = dsEmpty
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
      end
      object memoEmpty: TMemo
        Left = 0
        Top = 25
        Width = 976
        Height = 219
        Align = alTop
        BorderStyle = bsNone
        Lines.Strings = (
          '['
          '  {'
          '    "ID": 3,'
          '    "DESCRICAO": "Coca Cola",'
          '    "ATIVO": true,'
          '    "PRECO": 2.50,'
          '    "CADASTRO": "03/08/1995",'
          
            '    "OBSERVACAO": "test test test test test test test test test ' +
            'test test test test test test test test test test test test test' +
            ' test test test test test test test test test test test test tes' +
            't test test test test '
          
            'test test test test test test test test test test test test test' +
            ' test test test test test test test test test test test test tes' +
            't test test test test test test test test test test test test te' +
            'st test test test test test '
          'test test test test test test test test test"'
          '  },'
          '  {'
          '    "ID": 1,'
          '    "DESCRICAO": "RedBull",'
          '    "ATIVO": false,'
          '    "PRECO": 2.39,'
          '    "CADASTRO": "21/04/1996",'
          
            '    "OBSERVACAO": "test test test test test test test test test ' +
            'test test test test test test test test test test test test test' +
            ' test test test test test test test test test test test test tes' +
            't test test test test '
          
            'test test test test test test test test test test test test test' +
            ' test test test test test test test test test test test test tes' +
            't test test test test test test test test test test test test te' +
            'st test test test test test '
          
            'test test test test test test test test test test test test test' +
            ' test test test test test test test test test test test test tes' +
            't test test test test test test test test test test test test te' +
            'st test test test test test '
          
            'test test test test test test test test test test test test test' +
            ' test test test test test test test test test test test test tes' +
            't test test test test test test test test test test test test te' +
            'st test test test test test '
          
            'test test test test test test test test test test test test test' +
            ' test test test test test test test test test test test test tes' +
            't test test test test test test test test test test test test te' +
            'st test test test test test '
          
            'test test test test test test test test test test test test test' +
            ' test test test test test test test test test test test test tes' +
            't test test test test test test test test test test test test te' +
            'st test test test test test '
          
            'test test test test test test test test test test test test test' +
            ' test test test test test test test test test test test test tes' +
            't test test test test test test test test test test test test te' +
            'st test test test test test '
          
            'test test test test test test test test test test test test test' +
            ' test test test test test test test test test test test test tes' +
            't test test test test test test test test test test test test te' +
            'st test test test test test '
          
            'test test test test test test test test test test test test test' +
            ' test test test test test test test test test test test test tes' +
            't test test test test test test test test test test test test te' +
            'st test test test test test '
          
            'test test test test test test test test test test test test test' +
            ' test test test test test test test test test test test test tes' +
            't test test test test test test test test test test test test te' +
            'st test test test test test '
          
            'test test test test test test test test test test test test test' +
            ' test test test test test test test test test test test test tes' +
            't test test test test test test test test test test test test te' +
            'st test test test test test '
          
            'test test test test test test test test test test test test test' +
            ' test test test test test test test test test test test test tes' +
            't test test test test test test test test test test test test te' +
            'st test test test test test '
          
            'test test test test test test test test test test test test test' +
            ' test test test test test test test test test test test test tes' +
            't test test test test test test test test test test test test te' +
            'st test test test test test '
          
            'test test test test test test test test test test test test test' +
            ' test test test test test test test test test test test test tes' +
            't test test test test test test test test test test test test te' +
            'st test test test test test '
          
            'test test test test test test test test test test test test test' +
            ' test test test test test test test test test test test test tes' +
            't test test test test test test test test test test test test te' +
            'st test test test test test '
          
            'test test test test test test test test test test test test test' +
            ' test test test test test test test test test test test test tes' +
            't test test test test test test test test test test test test te' +
            'st test test test test test '
          
            'test test test test test test test test test test test test test' +
            ' test test test test test test test test test test test test tes' +
            't test test test test test test test test test test test test te' +
            'st test test test test test '
          
            'test test test test test test test test test test test test test' +
            ' test test test test test test test test test test test test tes' +
            't test test test test test test test test test test test test te' +
            'st test test test test test '
          
            'test test test test test test test test test test test test test' +
            ' test test test test test test test test test test test test tes' +
            't test test te'
          
            'test test test test test test test test test test test test test' +
            ' test test test test test test test test test test"'
          '  }'
          ']')
        TabOrder = 2
      end
      object Panel17: TPanel
        Left = 0
        Top = 0
        Width = 976
        Height = 25
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = '  JSON String'
        Color = 16091980
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 3
      end
      object Button7: TButton
        Left = 0
        Top = 269
        Width = 976
        Height = 25
        Align = alTop
        Caption = 'Load from JSON string'
        TabOrder = 4
        OnClick = Button7Click
      end
      object mmDataType: TMemo
        Left = 672
        Top = 294
        Width = 304
        Height = 239
        Align = alRight
        TabOrder = 5
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
    object mtUsersCOUNTRY: TStringField
      DisplayLabel = 'Country'
      FieldName = 'COUNTRY'
      Size = 60
    end
  end
  object mtEmpty: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 776
    Top = 376
  end
  object dsEmpty: TDataSource
    DataSet = mtEmpty
    Left = 720
    Top = 376
  end
end
