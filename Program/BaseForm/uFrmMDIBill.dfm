inherited frmMDIBill: TfrmMDIBill
  Caption = 'frmMDIBill'
  FormStyle = fsNormal
  PixelsPerInch = 96
  TextHeight = 13
  inherited splOP: TSplitter
    Top = 157
    Height = 160
  end
  inherited pnlTop: TPanel
    Height = 113
    object pnlBillTitle: TPanel
      Left = 1
      Top = 1
      Width = 734
      Height = 32
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        734
        32)
      object lblBillTitle: TcxLabel
        Left = 16
        Top = 0
        AutoSize = False
        Caption = 'lblBillTitle'
        ParentFont = False
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -24
        Style.Font.Name = 'MS Sans Serif'
        Style.Font.Style = []
        Style.IsFontAssigned = True
        Height = 32
        Width = 137
      end
      object edtBillNumber: TcxButtonEdit
        Left = 512
        Top = 8
        Anchors = [akTop, akRight]
        Properties.Buttons = <
          item
            Kind = bkEllipsis
          end>
        TabOrder = 1
        Width = 209
      end
      object deBillDate: TcxDateEdit
        Left = 328
        Top = 8
        Anchors = [akTop, akRight]
        EditValue = 36892d
        Properties.DateButtons = [btnClear, btnToday]
        TabOrder = 2
        Width = 121
      end
      object lblBillDate: TcxLabel
        Left = 272
        Top = 10
        Anchors = [akTop, akRight]
        Caption = #24405#21333#26085#26399
      end
      object lblBillNumber: TcxLabel
        Left = 456
        Top = 10
        Anchors = [akTop, akRight]
        Caption = #21333#25454#32534#21495
      end
    end
    object pnlBillMaster: TPanel
      Left = 1
      Top = 33
      Width = 734
      Height = 79
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
    end
  end
  inherited gridMainShow: TcxGrid
    Top = 157
    Height = 160
    inherited gridTVMainShow: TcxGridTableView
      OptionsView.GroupByBox = False
    end
  end
  inherited actlstEvent: TActionList
    object actNewBill: TAction
      Caption = #26032#22686#21333#25454
    end
    object actSaveDraft: TAction
      Caption = #23384#20026#33609#31295
      OnExecute = actSaveDraftExecute
    end
    object actSaveSettle: TAction
      Caption = #30452#25509#36807#36134
      OnExecute = actSaveSettleExecute
    end
    object actSelectBill: TAction
      Caption = #36873#21333
    end
  end
  inherited imglstBtn: TcxImageList
    FormatVersion = 1
    ImageInfo = <
      item
        Image.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000000000000000
          000E00000013000000170000001A0000001A0000001A0000001A0000001A0000
          001A0000001A0000001A0000001A0000001A0000001600000008000000000000
          001C482501A27A3E02CC7A3E02CC7A3E02CC7A3E02CC7A3E02CC7A3E02CC7A3E
          02CC783D02CA6A3601B54523018C0E0700480000002B00000010000000000000
          00007D4104CCFFC02BFFFFB812FFFFB811FFFFB70FFFFFB70EFFFFB60CFFFFB6
          0BFFFEB40AFFEBA40BF8BD7B0AE77C4305C11E10014100000000000000000000
          0000814507CCFFCD50FFFFC332FFFFC12CFFFFBF26FFFFBC1EFFFFBA18FFFFB8
          12FFFFB70EFFFFB406FFFFB303FFE09A0DF37F4708C1140B0120000000000000
          000064370899864A0ACC864A0ACC864A0ACC864A0ACC864A0ACC864A0ACC864A
          0ACC91540DD1BA7B14E3F9B20EFDFFB304FFC28011E6532D067E000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000120A021B5E350A8ABC7E1AE3FCB20CFFEAA718F879440DB2000000000000
          000000000000000000004126095C6D400E990000000000000000000000000000
          000000000000130B021B995D17D1F3B126FFF3B127FF8F5312CA000000000000
          00000000000043280A5C955916CC955916CC0000000000000000000000000000
          000000000000140C031B9D621DD1E8AC39FFE9AD3AFF935816CA000000000000
          0000462B0D5C9A5F1BCCEABD73FF9A5F1BCC0000000000000000000000000000
          0000150D041B6840128ABD863BE3DB9E3EFFD9A149F8875318B200000000492E
          0E5CA1651FCCF5C77BFFF5C77BFFA1651FCCA1651FCCA1651FCCA1651FCCA165
          1FCCA86E27D1C18D44E3DBA658FDD99F50FFC69146E6633E137E3A250C48A66A
          23CCF7CB7FFFEFB468FFF3BF73FFF6CA7EFFF6C97DFFF6C87CFFF6C87CFFF6C7
          7BFFF5C478FFF1BB6FFFF1B86CFFE4B368F3A06927C11A1106203C270E48AB6F
          27CCFFE498FFF4BE72FFF6C77BFFF8CF83FFF8CF83FFF8CE82FFF8CE82FFF8CD
          81FFF8CD81FFEEC277F8D5A359E7A46E2AC136230C4100000000000000004F34
          135CB0742ACCFFE599FFFDD78BFFB0742ACCB0742ACCB0742ACCB0742ACCB074
          2ACCAE732ACA9A6525B26D481A7E1B1207200000000000000000000000000000
          00005136155CB4782ECCFFE599FFB4782ECC0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000005338165CB87C31CCB87C31CC0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000005439175C8C5F26990000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
      end
      item
        Image.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000002020103483A21573C311C480000000000000000000000000000
          00004337214B4D3F255501010102000000000000000000000000000000000000
          0000010101024E3D2060C89A4AEEC2984EE33F341F4B0000000000000000463A
          234FD3A959E5DCAE58EC5343265C010101010000000000000000000000000000
          000045361B59C0923FEED3A047FFD9A952FFC69F59E14136234B4539254ECFA7
          5EE4EBB95EFFEDB959FFDCAC53EC4C3E21550000000000000000000000000000
          00003E301851B98C3BE9D09E45FFD9A953FFE1B361FFD0A964E8D4AD66E9EABB
          66FFE9B75DFFEAB657FFD5A750E745371E4D0000000000000000000000000000
          00000000010142331A55BB8E41E7D8A751FFDEAF5CFFE3B562FFE6B864FFE9B9
          63FFE7B65BFFCFA250E5483A1F52000000000000000000000000000000000000
          0000000000000000000043341B55C5984AEDDBAB55FFDFAF5AFFE3B35DFFE6B5
          5DFFD2A655EB46381E5100000000000000000000000000000000000000000000
          000000000000000000003B2E154FBC8F3FEBD6A44CFFDCAA53FFDFAE56FFE3B0
          56FFCD9F4DE93E31194B00000000000000000000000000000000000000000000
          0000000000003729104EAC7E2EE4C69236FFCD993EFFD4A146FFDAA64BFFDDA9
          4CFFDAA444FFBF903BE13D2F154B000000000000000000000000000000000000
          000033250C4CA2711FE5BB8425FFC18C2DFFC79234FFBC8C38EBC1913CECD19B
          3AFFD19936FFD59C36FFBE8D34E23B2D13480000000000000000000000000000
          00003F2D0E5EA6731BF1B47D1EFFBB8425FFAD7E29E53E2F145241311455B583
          2BE7CC942EFFD09731FFC69133EF4937175A0000000000000000000000000000
          00000201010345300E67A6731AF1A1711DE639290D510000000000000000402F
          1155B6832AE8BF8B2DEF4E3A1663010101020000000000000000000000000000
          000000000000020201043E2C0C5E35250B4F0000000000000000000000000000
          00013E2D10524633125C02020103000000000000000000000000000000000000
          0000000000000000000001000001000000000000000000000000000000000000
          0000010000010100000100000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
      end
      item
        Image.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000000000070000
          000B0000000C0000000C0000000C0000000C0000000C0000000C0000000C0201
          00120F08003C10080043090500270000000B0000000B0000000720140B4E4F34
          1B9452361C9852361C9852361B9852351B9852341B9852341B9853361B985637
          17A1937242E2AE946EEE6E4B1CC252351B9750331A9420140A4E593C2193D19A
          54FFDEA95DFFDDA75CFFDDA659FFDDA457FFDDA254FFD99D4FFFBE843AFFB277
          29FFC6AB82FFE9E5DEFFAF7B33FFB97D31FFC0823AFF5A3B1F935B40278FE1B9
          74FFF5D58AFFF4D288FFF4D184FFF4CE80FFF4CD7CFFE7BC69FFB79052FFC4AA
          81FFDACDB8FFEDEBE7FFC9B18DFFBEA173FFB58139FF5D40268F5A432C8FE1C0
          7DFFF5DB92FFF4D990FFF3D78DFFF3D487FFF3D281FFE5BE68FFC8AB7CFFEDE9
          E2FFF3F1EDFFF8F7F7FFEFEBE4FFE1D6C5FFB88843FF5B42298F5A45328FE3C7
          8FFFF7E4A9FFF6E3A7FFF5E1A4FFF5DD9DFFF3DA95FFEDCE84FFCCA65BFFC59D
          53FFD4BD97FFF5F0E9FFBF9754FFCAA053FFC99950FF5A442F8F5948388FE5CE
          A3FFF8EDC2FFF8ECC1FFF7EBBDFFF6E8B6FFF5E4ADFFF4E0A3FFF4DD9CFFE6C8
          7FFFCBAF82FFE5DAC9FFCAA35BFFF3D285FFE2BA77FF5946348F584A3D8FE7D4
          B2FFFAF4D5FFF9F3D4FFF9F2D1FFF8F0CBFFF6ECC2FFF5E7B8FFF4E4AFFFECD8
          9EFFCBAC6BFFC9A96AFFD9BB78FFF2D999FFE2C187FF5848398F574C428FE8D9
          BCFFFCF9E0FFFBF7DEFFFAF6DDFFF9F4D8FFF7F1D0FFF5EEC7FFF4EABFFFF3E7
          B8FFF3E6B5FFF2E3B0FFF2E1ADFFF2DFAAFFE4C896FF574B3F8F564E468FEADB
          C1FFFDFAE4FFFCF9E2FFFBF8E1FFFAF6DDFFF8F3D7FFF6F0CFFFF4EDC8FFF3EB
          C1FFF2E9BDFFF2E7BAFFF2E5B7FFF2E4B5FFE5CDA0FF564D438F514C4786EBE2
          CDFFFEFCE7FFFDFBE6FFFDFAE4FFFBF8E0FFFAF5DBFFF8F3D5FFF6F0CFFFF5EF
          CAFFF4EDC7FFF4ECC4FFF4EBC2FFF5EAC0FFE4D4B1FF504B45861F1E1D339291
          8BC4C8C7C2FFC8C7C2FFC8C7C1FFC7C7C0FFC7C6BFFFC7C5BEFFC7C5BDFFC7C5
          BDFFC7C5BCFFC7C5BBFFC7C5BBFFC5C3B9FF89867FC51C1B1A33000000003232
          326CC3C3C4FADCDCDCFFDCDCDDFFDCDCDDFFDCDCDDFFDDDDDEFFD6D6D7FECDCD
          CEFDCDCDCEFDCDCDCEFDCFCFD0FEC0C0C1FB3232326D00000000000000000D0D
          0D24545454A2E3E3E3FDF4F4F4FFF3F3F3FFF3F3F3FFEAEAEAFE777777BF3636
          366F3636366B3737376C3737376C333333690F0F0F2600000000000000000000
          0000232323508E8E8ECA999999CE989898CE999999CE8D8D8DCA232323540000
          0000000000000000000000000000000000000000000000000000000000000000
          0000020202080505051704040418040404180404041805050517020202080000
          0000000000000000000000000000000000000000000000000000}
      end
      item
        Image.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000000000000000
          0000000000000705020B1815101E1C1B181F15100A1F15100A1F1C1B181F1D1C
          1A1F1D1C1A1F1C1B181F15110A1F151008200D0A051401000001000000000000
          00000F0C0617644B279AB49E7DE0CFC5B1E29B7949E29B7949E2CFC3AFE2D6CF
          BEE2D6CFBEE2CFC3AFE29B7A4AE296713BE5775A30B50D0A0514000000000D0A
          0613725732A9AA8147FFD0B995FFEDE3D1FFB28D58FFB28D58FFECE1CEFFF5EE
          DFFFF5EEDFFFECE1CEFFB28E5AFEA07943EE92703FDA15100920000000004839
          2268AF8852FCAF8850FFD5C09FFFF3ECDEFFBFA072FFBFA072FFF2EADBFFF9F5
          EBFFF9F5EBFFF1E9D9FFB79462FC917143D28E6E42CC16110A20000000005B48
          2E7FB6915CFFB5905AFFD5BF9EFFF4EDE1FFEDE3D2FFEDE3D2FFF3ECDFFFF4ED
          E0FFF5EEE1FFEDE3D2FFBD9B6BFFA48352E69B7B4ED917120C20000000005D4B
          317FBA9662FFBA9662FFBE9C6AFFC2A173FFC2A273FFC2A273FFC2A172FFC2A1
          72FFC2A172FFC1A070FFBB9764FFB99562FEA38456E017120C1F000000005E4D
          337FBD9A67FFBD9967FFBC9966FFBC9865FFBC9865FFBC9865FFBC9865FFBC98
          65FFBC9865FFBC9865FFBD9967FFBD9A67FFA8885BE217130D1F00000000604E
          357FC09D6BFFC09D6CFFC4A373FFC5A677FFC5A677FFC5A677FFC5A677FFC5A6
          77FFC5A677FFC5A577FFC19F6FFFC09D6BFFAA8B5FE217130D1F000000006150
          377FC2A06EFFC6A678FFD9C5A3FFD6C19EFFD6C19EFFD6C19EFFD6C19EFFD6C1
          9EFFD6C19EFFD8C4A3FFD2B891FFC29F6EFFAC8E62E218130D1F000000006251
          397FC4A272FFCAAB7FFFE1D0B4FFD9C5A5FFD9C6A5FFD9C6A5FFD9C6A5FFD9C6
          A5FFD9C5A5FFDDCBADFFD9C3A0FFC4A271FFAF9066E218140E1F000000006353
          3B7FC6A576FFCCAE83FFE5D5BBFFDFCCAFFFDFCCAFFFDFCCAFFFDFCCAFFFDFCC
          AFFFDFCCAFFFE2D1B6FFDBC6A5FFC6A575FFAF9369E218140E1F000000006454
          3D7FC8A879FFCEB186FFE8D9C3FFE3D2B7FFE3D2B8FFE3D2B8FFE3D2B8FFE3D2
          B8FFE3D1B7FFE6D6BFFFDDC9AAFFC8A778FFB2956CE218140F1F000000006555
          3E7FCAAA7CFFD0B389FFEADDC8FFE6D6BEFFE6D6BEFFE6D6BEFFE6D6BEFFE6D6
          BEFFE6D6BEFFE9DBC5FFDFCCAEFFCAA97BFFB3986EE219150F1F000000006656
          3F7FCBAB7EFFD1B58CFFEDE0CDFFE8D9C3FFE8D9C3FFE8D9C3FFE8D9C3FFE8D9
          C3FFE8D9C3FFEBDECAFFE1CEB2FFCBAB7DFFB59870E219150F1F000000004A3F
          2E5DB39770E0B79D77E2C7B79EE2C8B79FE2C8B79FE2C8B79FE2C8B79FE2C8B7
          9FE2C8B79FE2C9B8A1E2C0AA8CE2B69971E490795AB4100D0A14000000000605
          040817140E1D19150F1F18140E1F18140E1F18140E1F18140E1F18140E1F1814
          0E1F18140E1F18140E1F18140E1F1A161020100D0A1401010001}
      end
      item
        Image.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000000000010101
          010301010105020202080303030C0404040F0505051105050512050505120505
          0512040404100303040D0303030A0202020601010104000000020404040F0909
          09201313133E1C1C1C582020216723232371252526792626277D2727287E2626
          277B242425752121226C1818185E0F0F0F530B0B0C3207070717090909202525
          2661838486D4AAACADF1ABACADF3AAACAEF5AAACAEF7AAACAEF7AAACADF7AAAC
          AEF7ACADAFF69D9EA0F26E6F6FE64C4C4CD5161616700F0F0F330101010B4344
          4580D9DBDDFFE8E9EAFFC7C8C8FFD7D8D9FFE1E1E2FFDCDCDDFFE9E9EAFFD7D8
          D9FFCDCECFFFC4C6C6FFC3C3C3FF5F5F5FB909090A3707070717000000004445
          477ADEE0E2FFE2E3E4FFA7A7A8FFC5C5C6FFDBDBDCFFD4D4D6FFDADADCFFADAD
          AEFF848485FFA3A3A3FFAAAAAAF21313135A0000000C00000002000000004843
          3A7AD3C8B6FFDED2BFFFD7CBB7FFDACEBBFFDACEBCFFDACDBAFFDACEBBFFB8B2
          A9FFC7C7C8FFD0D0D0FF858483F42D2D2DA50505053900000000000000004F43
          317CE0C79FFFD6C2A4FFBEB29EFFC4B6A0FFE1CAA7FFC9B9A1FFD0BEA2FFA8A2
          98FFEFEFEFFFFDFDFDFFCACAC9F94141418B0101011300000000000000005044
          327CE6CDA5FFC5B8A5FF959698FFA19F9BFFE1CBACFFC7BAA5FFCFBFA7FFA6A1
          9AFFEFEFEFFFE0DFDDFF897F70E10C0A07210000000000000000000000005044
          327CE7CDA5FFCBBDA7FFA19F9BFFACA79EFFE2CDACFFBFB4A3FFC9BBA5FFA09D
          99FFCDCCC9FFC1B39EFFA18C6BDD0D0B071A0000000000000000000000004C42
          337BD9C4A3FFE1CDAEFFDBC8ACFFDCC9ACFFE2CEAEFFDDCAACFFE0CCADFFAFA5
          96FFAFA595FFDDC8A8FFA49275DD0D0A071A0000000000000000000000004743
          3F79DFD4C6FFEFE4D4FFEFE3D4FFEFE3D4FFEEE3D4FFEFE3D4FFEFE3D4FFE9DE
          D0FFEBDFD1FFEFE3D4FF9F978DD90A0909180000000000000000000000006040
          1B7DDF9648FFE59A4BFFE49A4BFFE49A4BFFE49A4BFFE49A4BFFE49A4AFFE59C
          4DFFE6A054FFE69E52FFB87C37E0130D051B0000000000000000000000006D44
          167FEBA862FFEFAD6DFFEEAD6CFFEEAD6CFFEEAD6CFFEEAD6CFFEEAD6CFFEFB2
          75FFF5CFA8FFF3C191FFCA883FE3170D011C0000000000000000000000005738
          146BE2AB6BFDEDBE8CFFEDBE8BFFEDBE8BFFEDBE8BFFEDBE8BFFEDBD8AFFEDC0
          8FFFF1CDA6FFEEC496FFB07A3CCE100A01150000000000000000000000000E09
          0313583A166C6E491E806D481D7F6D481D7F6D481D7F6D481D7F6D481D7F6D48
          1D7F6D481C7F6A461B7E31200B3F000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
      end>
  end
  inherited bmList: TdxBarManager
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    Left = 692
    DockControlHeights = (
      0
      0
      44
      0)
    inherited barTool: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'btnNewBill'
        end
        item
          Visible = True
          ItemName = 'btnSelectBill'
        end
        item
          Visible = True
          ItemName = 'btnSave'
        end
        item
          Visible = True
          ItemName = 'btnClose'
        end>
    end
    object btnNewBill: TdxBarLargeButton
      Action = actNewBill
      Category = 0
      LargeImageIndex = 2
      AutoGrayScale = False
      SyncImageIndex = False
      ImageIndex = 2
    end
    object btnSaveDraft: TdxBarButton
      Action = actSaveDraft
      Category = 0
    end
    object btnSaveSettle: TdxBarButton
      Action = actSaveSettle
      Category = 0
    end
    object btnSave: TdxBarLargeButton
      Caption = #20445#23384
      Category = 0
      Hint = #20445#23384
      Visible = ivAlways
      ButtonStyle = bsDropDown
      DropDownMenu = bpmSave
      LargeImageIndex = 3
      AutoGrayScale = False
      SyncImageIndex = False
      ImageIndex = 3
    end
    object btnSelectBill: TdxBarLargeButton
      Action = actSelectBill
      Category = 0
      LargeImageIndex = 4
      AutoGrayScale = False
      SyncImageIndex = False
      ImageIndex = 4
    end
  end
  object bpmSave: TdxBarPopupMenu
    BarManager = bmList
    ItemLinks = <
      item
        Visible = True
        ItemName = 'btnSaveDraft'
      end
      item
        Visible = True
        ItemName = 'btnSaveSettle'
      end>
    UseOwnFont = False
    Left = 265
    Top = 121
  end
end
