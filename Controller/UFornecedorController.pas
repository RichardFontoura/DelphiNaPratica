unit UFornecedorController;

interface

uses
   SysUtils, Math, StrUtils, UConexao, UFornecedor;

type
   TFornecedorController = Class
      public
         constructor Create;
         function GravaFornecedor(pFornecedor : TForncedor) : Boolean;
         function ExcluiFornecedor(pFornecedor : TForncedor) : Boolean;
         function BuscaFornecedor(pFornecedor : Integer) : TForncedor;
         function PesquisaFornecedor(pNome : String) : TColForncedor;
         function RetornaUltimoID(pFornecedor: String): TForncedor;
      published
         class function getInstancia : TFornecedorController;
   end;

implementation

uses
   UFornecedorDAO;

var
   _instance : TFornecedorController;

{ TFornecedorController }

constructor TFornecedorController.Create;
begin
   inherited Create;
end;

class function TFornecedorController.getInstancia: TFornecedorController;
begin
   if _instance = nil then
      _instance := TFornecedorController.Create;

   Result := _instance;
end;

function TFornecedorController.GravaFornecedor(
  pFornecedor: TForncedor): Boolean;
var
   xForncedorDAO : TForncedorDAO;
begin
   try
      try
         Result := False;

         xForncedorDAO := TForncedorDAO.Create(TConexao.get.getConn);

         if pFornecedor.Id = 0 then
         begin
            xForncedorDAO.Insere(pFornecedor);
         end
         else
         begin
            xForncedorDAO.Update(pFornecedor);
         end;
      finally
         if xForncedorDAO <> nil then
            FreeAndNil(xForncedorDAO);
      end;
   except
      on e:exception do
         raise Exception.Create(e.Message);
   end;
end;

function TFornecedorController.BuscaFornecedor(
  pFornecedor: Integer): TForncedor;
var
   xForncedorDAO : TForncedorDAO;
begin
   try
      try
         Result := nil;

         xForncedorDAO := TForncedorDAO.Create(TConexao.get.getConn);

         Result := xForncedorDAO.Retorna(pFornecedor);
      finally
         if (xForncedorDAO <> nil) then
            FreeAndNil(xForncedorDAO);
      end;
   except
      on e:exception do
      begin
         raise Exception.Create('Falha ao buscar dados de Fornecedor');
      end;
   end;
end;

function TFornecedorController.ExcluiFornecedor(
  pFornecedor: TForncedor): Boolean;
var
   xForncedorDAO : TForncedorDAO;
begin
   try
      try
         Result := False;

         xForncedorDAO := TForncedorDAO.Create(TConexao.get.getConn);

         if (pFornecedor.Id = 0) then
         begin
            Exit
         end
         else
         begin
            xForncedorDAO.Deleta(pFornecedor.Id);
         end;

         Result := True;
      finally
         if xForncedorDAO <> nil then
            FreeAndNil(xForncedorDAO);
      end;
   except
      on e:Exception do
      begin
         raise Exception.Create(
            'Falha ao excluir os dados de fornecedor: '#13 + e.Message);
      end;
   end;
end;

function TFornecedorController.PesquisaFornecedor(pNome: String): TColForncedor;
var
   xForncedorDAO : TForncedorDAO;
   xCondicao  : String;
begin
   try
      try
         Result := nil;

         xForncedorDAO := TForncedorDAO.Create(TConexao.get.getConn);

         xCondicao :=
            ifthen(pNome <> EmptyStr,
               'WHERE   '#13 +
               '    (NOME LIKE ''%' + pNome + '%'' )'#13+
               'ORDER BY Id', EmptyStr);

         Result := xForncedorDAO.RetornaColecao(xCondicao);
      finally
         if (xForncedorDAO <> nil) then
            FreeAndNil(xForncedorDAO);
      end;
   except
      on e:exception do
      begin
         raise Exception.Create(
            'Falha ao buscar dados no banco de dados'#13 + e.Message);
      end;
   end;
end;

function TFornecedorController.RetornaUltimoID(pFornecedor: String): TForncedor;
var
   xForncedorDAO : TForncedorDAO;
begin
   try
      try
         Result := nil;

         xForncedorDAO := TForncedorDAO.Create(TConexao.get.getConn);

         Result := xForncedorDAO.RetornaUltimoId(pFornecedor);
      finally
         if (xForncedorDAO <> nil) then
            FreeAndNil(xForncedorDAO);
      end;
   except
      on e:exception do
      begin
         raise Exception.Create('Falha ao buscar dados de fornecedor');
      end;
   end;
end;

end.
