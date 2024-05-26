unit UValidaCampos;

interface

uses
   SysUtils, Classes, Vcl.Forms, ACBrValidador;

type
   TValidaDados = Class
      private
         vValidadoAcBr : TACBrValidador;
      public
         constructor Create;
         function ValidaCNPJ(pCNPJ : String) : Boolean;
      published
         class function getInstancia : TValidaDados;
   End;

implementation

var
   _instance : TValidaDados;

{ TValidaDados }

constructor TValidaDados.Create;
begin
   inherited Create;
end;

class function TValidaDados.getInstancia: TValidaDados;
begin
   if _instance = nil then
      _instance := TValidaDados.Create;

   Result := _instance;
end;

function TValidaDados.ValidaCNPJ(pCNPJ: String): Boolean;
var
   xCNPJ : String;
begin
   Result := False;
   if vValidadoAcBr = nil then
      vValidadoAcBr := TACBrValidador.Create(nil);
   try
      xCNPJ := StringReplace(pCNPJ, '.', EmptyStr, [rfReplaceAll]);
      xCNPJ := StringReplace(xCNPJ, '/', EmptyStr, [rfReplaceAll]);
      xCNPJ := StringReplace(xCNPJ, '-', EmptyStr, [rfReplaceAll]);
      try
         if pCNPJ <> EmptyStr then
         begin
            vValidadoAcBr.Documento := xCNPJ;
            vValidadoAcBr.TipoDocto := docCNPJ;

            if not vValidadoAcBr.Validar then
            begin
              Result := False;
              Exit;
            end;
            Result := True;
         end;
      finally
         if vValidadoAcBr <> nil then
            FreeAndNil(vValidadoAcBr);
      end;
   except
      on e:exception do
      begin
         raise Exception.Create('Falha ao validar CNPJ: ' + e.Message);
      end;
   end;
end;

end.
