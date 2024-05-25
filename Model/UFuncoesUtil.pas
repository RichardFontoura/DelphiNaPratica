unit UFuncoesUtil;

interface

uses
   SysUtils, Classes;

type
   TFuncoes = Class
      public
         class function StrZero(pValor: String; pTamanho: Integer): String;
         class function PadL(pString: String; pTamanho: Integer): String;
         class function RetornaEspaco(pTamanho: Integer): String;
   End;

implementation

{ TFuncoes }

class function TFuncoes.PadL(pString: String; pTamanho: Integer): String;
var
   xRetorno : String;
   X : Integer;
begin
   xRetorno := '';

   For X := 1 To Length(pString) Do
   Begin
      xRetorno := Copy(pString, Length(pString) - (X-1), 1) + xRetorno;
      If X = pTamanho Then
         Break;
   End;

   Result := RetornaEspaco(pTamanho-Length(xRetorno)) + xRetorno;
end;

class function TFuncoes.RetornaEspaco(pTamanho: Integer): String;
var
  x : Integer;
Begin
   Result := '';
   For x := 1 To pTamanho Do
      Begin
         Result := Result + ' ';
      End;
end;

class function TFuncoes.StrZero(pValor: String; pTamanho: Integer): String;
var
   xRetorno : String;
begin
   xRetorno := TrimLeft(TrimRight(pValor));
   If Length(xRetorno) > pTamanho Then
      xRetorno := PadL(xRetorno, pTamanho);

   While Length(xRetorno) < pTamanho Do
         xRetorno := '0' + xRetorno;

   Result := xRetorno;
end;

end.
