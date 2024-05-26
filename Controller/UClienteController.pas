unit UClienteController;

interface

uses
   SysUtils, Math, StrUtils, UConexao, UCliente;

type
   TClienteController = Class
      public
         constructor Create;
         function GravaCliente(pCliente : TCliente) : Boolean;
         function ExcluiCliente(pCliente : TCliente) : Boolean;
         function BuscaCliente(pCliente : Integer) : TCliente;
         function PesquisaCliente(pNome : String) : TColCliente;
         function RetornaUltimoID(pCliente: String): TCliente;
      published
         class function getInstancia : TClienteController;
   end;

implementation

uses
   UClienteDAO;

var
   _instance : TClienteController;

{ TClienteController }

constructor TClienteController.Create;
begin
   inherited Create;
end;

class function TClienteController.getInstancia: TClienteController;
begin
   if _instance = nil then
      _instance := TClienteController.Create;

   Result := _instance;
end;

function TClienteController.GravaCliente(pCliente: TCliente): Boolean;
var
   xClienteDAO : TClienteDAO;
begin
   try
      try
         Result := False;

         xClienteDAO := TClienteDAO.Create(TConexao.get.getConn);

         if pCliente.Id = 0 then
         begin
            xClienteDAO.Insere(pCliente);
         end
         else
         begin
            xClienteDAO.Update(pCliente);
         end;
      finally
         if xClienteDAO <> nil then
            FreeAndNil(xClienteDAO);
      end;
   except
      on e:exception do
         raise Exception.Create(e.Message);
   end;
end;

function TClienteController.BuscaCliente(pCliente: Integer): TCliente;
var
   xClienteDAO : TClienteDAO;
begin
   try
      try
         Result := nil;

         xClienteDAO := TClienteDAO.Create(TConexao.get.getConn);

         Result := xClienteDAO.Retorna(pCliente);
      finally
         if (xClienteDAO <> nil) then
            FreeAndNil(xClienteDAO);
      end;
   except
      on e:exception do
      begin
         raise Exception.Create('Falha ao buscar dados da cliente');
      end;
   end;
end;

function TClienteController.RetornaUltimoID(pCliente: String): TCliente;
var
   xClienteDAO : TClienteDAO;
begin
   try
      try
         Result := nil;

         xClienteDAO := TClienteDAO.Create(TConexao.get.getConn);

         Result := xClienteDAO.RetornaUltimoId(pCliente);
      finally
         if (xClienteDAO <> nil) then
            FreeAndNil(xClienteDAO);
      end;
   except
      on e:exception do
      begin
         raise Exception.Create('Falha ao buscar dados da cliente');
      end;
   end;
end;

function TClienteController.ExcluiCliente(pCliente: TCliente): Boolean;
var
   xClienteDAO : TClienteDAO;
begin
   try
      try
         Result := False;

         xClienteDAO := TClienteDAO.Create(TConexao.get.getConn);

         if (pCliente.Id = 0) then
         begin
            Exit
         end
         else
         begin
            xClienteDAO.Deleta(pCliente.Id);
         end;

         Result := True;
      finally
         if xClienteDAO <> nil then
            FreeAndNil(xClienteDAO);
      end;
   except
      on e:Exception do
      begin
         raise Exception.Create(
            'Falha ao excluir os dados da cliente: '#13 + e.Message);
      end;
   end;
end;

function TClienteController.PesquisaCliente(pNome: String): TColCliente;
var
   xClienteDAO : TClienteDAO;
   xCondicao  : String;
begin
   try
      try
         Result := nil;

         xClienteDAO := TClienteDAO.Create(TConexao.get.getConn);

         xCondicao :=
            ifthen(pNome <> EmptyStr,
               'WHERE   '#13 +
               '    (NOME LIKE ''%' + pNome + '%'' )'#13+
               'ORDER BY Id', EmptyStr);

         Result := xClienteDAO.RetornaColecao(xCondicao);
      finally
         if (xClienteDAO <> nil) then
            FreeAndNil(xClienteDAO);
      end;
   except
      on e:exception do
      begin
         raise Exception.Create(
            'Falha ao buscar dados no banco de dados'#13 + e.Message);
      end;
   end;
end;

end.
