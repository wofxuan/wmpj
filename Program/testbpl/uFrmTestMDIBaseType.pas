unit uFrmTestMDIBaseType;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, cxStyles, cxCustomData,
  cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData,
  cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  uFrmMDIBaseType, DBClient, Menus, cxLookAndFeelPainters, cxButtons,
  ActnList;

type
  TFrmTestMDIBaseType = class(TfrmMDIBaseType)
  private
    { Private declarations }
    procedure IniGridField; override;
  protected

    
  public
    { Public declarations }
  end;

var
  TFrmTestMDIBaseType1: TFrmTestMDIBaseType;

implementation

{$R *.dfm}

{ TFrmTestMDIBaseType }

procedure TFrmTestMDIBaseType.IniGridField;
begin
  inherited;

end;

end.
