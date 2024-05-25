unit UConexao;

interface

uses
   ZAbstractConnection, ZConnection, SysUtils, Forms, Classes;

type
   TConexao = Class
      private
         vConexao   : TZConnection;
         vCaminhoBD : String;

         constructor CreatePrivate;
      public
         constructor Create;
         class function get : TConexao;
         function getConn          : TZConnection;
         function getCaminhoBanco  : String;
         function createConnection : TZConnection;
   End;

implementation

var
   _Conexao : TConexao = nil;

{ TConexao }

constructor TConexao.Create;
begin
   raise Exception.Create('Para obter uma conexão. Utilize o método getInstance.');
end;

function TConexao.createConnection: TZConnection;
begin
   vCaminhoBD := ExtractFilePath(Application.ExeName) + 'Banco\CRUD.db';
   Result     := TZConnection.Create(nil);

   Result.Database       := vCaminhoBD;
   Result.HostName       := 'LOCALHOST';
   Result.Port           := 0;
   Result.Protocol       := 'sqlite';
   Result.ClientCodepage := 'UTF-8';

   try
      Result.Connected := True;
   except
      on e:exception do
      begin
         raise Exception.Create('Falha ao conectar ao banco de dados: ' + e.Message);
      end;
   end;
end;

constructor TConexao.CreatePrivate;
begin
   inherited Create;
end;

class function TConexao.get: TConexao;
begin
   if not Assigned(_Conexao) then
       _Conexao := TConexao.CreatePrivate;
    Result:= _Conexao;
end;

function TConexao.getCaminhoBanco: String;
begin
   vCaminhoBD := ExtractFilePath(Application.ExeName) + 'Banco\CRUD.db';
   Result := vCaminhoBD;
end;

function TConexao.getConn: TZConnection;
begin
   if Not Assigned(vConexao) then
      vConexao := createConnection;

   if not vConexao.Connected then
      vConexao.Connect;

   Result := vConexao;
end;

end.
