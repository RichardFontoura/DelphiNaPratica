unit UConsultaAPI;

interface

uses
   REST.Types, REST.Client, REST.Json, System.JSON, SysUtils, Classes, Vcl.Forms,
   UEndereco, UMensagemUtil;

type
   TConsultaAPI = Class(TEndereco)
      private
         vClient   : TRESTClient;
         vResponse : TRESTResponse;
         vRequest  : TRESTRequest;
      public
         constructor Create;
         function BuscaCEP(pForm : TCustomForm; pCEP : String) : TEndereco;
      published
         class function getInstacia : TConsultaAPI;
   End;

implementation

var
   _instance : TConsultaAPI;

{ TConsultaCEP }

constructor TConsultaAPI.Create;
begin
   inherited Create;

   if vClient = nil then
      vClient := TRESTClient.Create(nil);

   if vResponse = nil then
      vResponse := TRESTResponse.Create(nil);

   if vRequest = nil then
   begin
      vRequest := TRESTRequest.Create(nil);

      vRequest.Client   := vClient;
      vRequest.Response := vResponse;
   end;
end;

class function TConsultaAPI.getInstacia: TConsultaAPI;
begin
   if _instance = nil then
      _instance := TConsultaAPI.Create;

   Result := _instance;
end;

function TConsultaAPI.BuscaCEP(pForm : TCustomForm; pCEP: String): TEndereco;
var
   xObjJson : TJSONObject;
   xCEP : String;
begin
   Result := nil;
   xCEP   := StringReplace(pCEP, '-', EmptyStr, [rfReplaceAll]);
   try
      vClient.BaseURL := 'https://brasilapi.com.br/api/cep/v1/' + xCEP;
      vRequest.Execute;

      if vResponse.StatusCode = 200 then
      begin
         xObjJson := TJSONObject.ParseJSONValue(vResponse.Content) as TJSONObject;
         try
            if Assigned(xObjJson) then
            begin
               Result := TEndereco.Create;

               Result.CEP      := xObjJson.GetValue('cep').Value;
               Result.UF       := xObjJson.GetValue('state').Value;
               Result.Cidade   := xObjJson.GetValue('city').Value;
               Result.Bairro   := xObjJson.GetValue('neighborhood').Value;
               Result.Endereco := xObjJson.GetValue('street').Value;
            end;
         finally
            if xObjJson <> nil then
               FreeAndNil(xObjJson);
         end;
      end
      else
      begin
         TMensagemUtil.Alerta(pForm, 'Falha ao consultar CEP! Varifique se o mesmo e um CEP valido!');
         Exit;
      end;
   except
      on e:exception do
      begin
         raise Exception.Create('Falha ao Buscar na API: ' + e.Message);
      end;
   end;
end;

end.
