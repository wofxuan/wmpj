{***************************
һЩ���������Ϣ
mx 2015-10-11
****************************}

unit uOtherDefine;

interface

uses DBClient, Classes, uParamObject;

type
  TIDDisplayText= class(TStringList)        //ID����ʾ��Ӧ��ϵ
  public
    procedure AddItem(AID, ADisplayText: string);
  end;

implementation

{ TIDDisplayText }

procedure TIDDisplayText.AddItem(AID, ADisplayText: string);
begin
  Add(AID + '=' + ADisplayText);
end;

end.

