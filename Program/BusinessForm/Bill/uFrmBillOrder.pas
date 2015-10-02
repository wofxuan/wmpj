unit uFrmBillOrder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDIBill, ComCtrls, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxDataStorage, cxEdit, dxBar, dxBarExtItems, cxClasses,
  ImgList, ActnList, DB, DBClient, cxGridLevel, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGrid,
  cxContainer, cxTreeView, ExtCtrls;

type
  TfrmMDIBill1 = class(TfrmMDIBill)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMDIBill1: TfrmMDIBill1;

implementation

{$R *.dfm}

end.
