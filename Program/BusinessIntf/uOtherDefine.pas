{***************************
一些其它相关信息
mx 2015-10-11
****************************}

unit uOtherDefine;

interface

uses DBClient, Classes, uParamObject;

type
  TIDDisplayText= class(TStringList)        //ID和显示对应关系
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

