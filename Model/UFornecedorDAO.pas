unit UFornecedorDAO;

interface

uses
   ZAbstractConnection, ZConnection, ZAbstractRODataset, ZAbstractDataset,
   ZDataset, SimpleDS, DB, Classes, SysUtils, DateUtils, StdCtrls,
   UFornecedor;

type
   TForncedorDAO = Class
      private vConexao : TZConnection;

      function RetornaSQL         : String;
      function RetornaSQLComChave : String;
      function RetornaSQLInsert   : String;
      function RetornaSQLUpdate   : String;
      function RetornaSQLDeleta   : String;
   public
      constructor Create(pConexao : TZConnection);
      function RetornaColecao(pCondicao : String = '') : TColForncedor;
      function Retorna(pFornecedor : Integer) : TForncedor;
      function Insere(pFornecedor  : TForncedor) : Boolean;
      function InsereColecao(pFornecedor : TColForncedor) : Boolean;
      function Update(pFornecedor : TForncedor) : Boolean;
      function Deleta(pFornecedor : Integer) : Boolean;
      function UpdateColecao(pFornecedor : TColForncedor):Boolean;
      function RetornaUltimoId(pCondicao : String) : TForncedor;
   End;

implementation

{ TForncedorDAO }

constructor TForncedorDAO.Create(pConexao: TZConnection);
begin
   Self.vConexao := pConexao;
end;

function TForncedorDAO.RetornaSQL: String;
begin
   Result :=
      'SELECT          '#13 +
      '   Id,          '#13 +
      '   CNPJ,        '#13 +
      '   Nome,        '#13 +
      '   RazaoSocial, '#13 +
      '   Ativo,       '#13 +
      '   CEP,         '#13 +
      '   Cidade,      '#13 +
      '   UF,          '#13 +
      '   Rua,         '#13 +
      '   Bairro,      '#13 +
      '   Numero       '#13 +
      'FROM Fornecedores ';
end;

function TForncedorDAO.RetornaSQLComChave: String;
begin
   Result :=
      'SELECT            '#13 +
      '   Id,            '#13 +
      '   CNPJ,          '#13 +
      '   Nome,          '#13 +
      '   RazaoSocial,   '#13 +
      '   Ativo,         '#13 +
      '   CEP,           '#13 +
      '   Cidade,        '#13 +
      '   UF,            '#13 +
      '   Rua,           '#13 +
      '   Bairro,        '#13 +
      '   Numero         '#13 +
      'FROM Fornecedores '#13 +
      'WHERE Id = :Id';
end;

function TForncedorDAO.RetornaSQLDeleta: String;
begin
   Result :=
      'DELETE FROM Fornecedores '#13+
      'WHERE Id = :Id           ';
end;

function TForncedorDAO.RetornaSQLInsert: String;
begin
   Result :=
      'INSERT INTO Fornecedores( '#13 +
      '    Nome,                 '#13 +
      '    CNPJ,                 '#13 +
      '    Ativo,                '#13 +
      '    RazaoSocial,          '#13 +
      '    CEP,                  '#13 +
      '    Cidade,               '#13 +
      '    UF,                   '#13 +
      '    Rua,                  '#13 +
      '    Bairro,               '#13 +
      '    Numero                '#13 +
      ')                         '#13 +
      'VALUES(                   '#13 +
      '    :Nome,                '#13 +
      '    :CNPJ,                '#13 +
      '    :Ativo,               '#13 +
      '    :RazaoSocial,         '#13 +
      '    :CEP,                 '#13 +
      '    :Cidade,              '#13 +
      '    :UF,                  '#13 +
      '    :Rua,                 '#13 +
      '    :Bairro,              '#13 +
      '    :Numero               '#13 +
      ')                         ';
end;

function TForncedorDAO.RetornaSQLUpdate: String;
begin
   Result :=
      'UPDATE Fornecedores SET              '#13 +
      '    Nome              = :Nome,       '#13 +
      '    CNPJ              = :CNPJ,       '#13 +
      '    Ativo             = :Ativo,      '#13 +
      '    RazaoSocial       = :RazaoSocial,'#13 +
      '    CEP               = :CEP,        '#13 +
      '    Cidade            = :Cidade,     '#13 +
      '    UF                = :UF,         '#13 +
      '    Rua               = :Rua,        '#13 +
      '    Bairro            = :Bairro,     '#13 +
      '    Numero            = :Numero      '#13 +
      'WHERE Id = :Id                       ';
end;

function TForncedorDAO.RetornaUltimoId(pCondicao: String): TForncedor;
var
   xQry : TZQuery;
begin
   xQry := TZQuery.Create(Nil);
   try
      xQry.Connection := Self.vConexao;

      xQry.SQL.Text := 'SELECT last_insert_rowid() AS ' + pCondicao;;

      xQry.Open;

      if xQry.IsEmpty then
         exit;

      try
         Result := TForncedor.Create;

         Result.Id := xQry.FieldByName('Id').AsInteger;
      except
         on E: Exception do
         begin
            raise Exception.Create(
               'Ocorreu um erro ao tentar retornar os dados da '+
               Self.ClassName + '.' + #13 + 'Motivo: ' + e.Message);
         end;
      end;
   finally
      if xQry <> nil then
      begin
         xQry.Close;
         FreeAndNil(xQry);
      end;
   end;
end;

function TForncedorDAO.Update(pFornecedor: TForncedor): Boolean;
var
   xQry : TZQuery;
begin
   Result := False;

   xQry := TZQuery.Create(Nil);
   try
      xQry.Connection := Self.vConexao;

      xQry.SQL.Text := RetornaSQLUpdate;

      xQry.ParamByName('CNPJ'       ).AsString  := pFornecedor.CNPJ;
      xQry.ParamByName('Nome'       ).AsString  := pFornecedor.Nome;
      xQry.ParamByName('RazaoSocial').AsString  := pFornecedor.Razao;
      xQry.ParamByName('Ativo'      ).AsInteger := pFornecedor.Ativo;
      xQry.ParamByName('CEP'        ).AsString  := pFornecedor.CEP;
      xQry.ParamByName('Cidade'     ).AsString  := pFornecedor.Cidade;
      xQry.ParamByName('UF'         ).AsString  := pFornecedor.UF;
      xQry.ParamByName('Rua'        ).AsString  := pFornecedor.Endereco;
      xQry.ParamByName('Bairro'     ).AsString  := pFornecedor.Bairro;
      xQry.ParamByName('Numero'     ).AsString  := pFornecedor.Numero;

      xQry.ParamByName('Id').AsInteger  := pFornecedor.Id;

      try
         xQry.ExecSql;
      except
         on E: Exception do
         begin
            raise Exception.Create(
               'Ocorreu um erro ao tentar atualizar os dados da '+
               Self.ClassName + '.' + #13 + 'Motivo: ' + e.Message);
         end;
      end;
   finally
      if xQry <> nil then
      begin
         xQry.Close;
         FreeAndNil(xQry);
      end;
   end;
   Result := True;
end;

function TForncedorDAO.UpdateColecao(pFornecedor: TColForncedor): Boolean;
var
   xIndice : Integer;
begin
   Result := True;
   for xIndice := 0 to pFornecedor.Count -1 do
   begin
      if not Self.Update(pFornecedor.Retorna(xIndice)) then
      begin
         Result := False;
         exit;
      end;
   end;
end;

function TForncedorDAO.Deleta(pFornecedor: Integer): Boolean;
var
   xQryCep : TZQuery;
begin
   Result := False;
   xQryCep := TZQuery.Create(Nil);
   try
      xQryCep.Connection := Self.vConexao;

      xQryCep.SQL.Text := RetornaSQLDeleta;

      xQryCep.ParamByName('Id').AsInteger := pFornecedor;
      try
         xQryCep.ExecSql;
      except
         on E: Exception do
         begin
            raise Exception.Create(
               'Ocorreu um erro ao tentar apagar os dados da '+
               Self.ClassName + '.' + #13 + 'Motivo: ' + e.Message);
         end;
      end;
   finally
      if xQryCep <> nil then
      begin
         xQryCep.Close;
         FreeAndNil(xQryCep);
      end;
   end;
   Result := True;
end;

function TForncedorDAO.Insere(pFornecedor: TForncedor): Boolean;
var
   xQry    : TZQuery;
   xReturn : String;
begin
   Result  := False;
   xReturn := EmptyStr;
   xQry    := TZQuery.Create(Nil);
   try
      xQry.Connection := Self.vConexao;

      xQry.SQL.Text := RetornaSQLInsert;

      xQry.ParamByName('CNPJ'       ).AsString  := pFornecedor.CNPJ;
      xQry.ParamByName('Nome'       ).AsString  := pFornecedor.Nome;
      xQry.ParamByName('RazaoSocial').AsString  := pFornecedor.Razao;
      xQry.ParamByName('Ativo'      ).AsInteger := pFornecedor.Ativo;
      xQry.ParamByName('CEP'        ).AsString  := pFornecedor.CEP;
      xQry.ParamByName('Cidade'     ).AsString  := pFornecedor.Cidade;
      xQry.ParamByName('UF'         ).AsString  := pFornecedor.UF;
      xQry.ParamByName('Rua'        ).AsString  := pFornecedor.Endereco;
      xQry.ParamByName('Bairro'     ).AsString  := pFornecedor.Bairro;
      xQry.ParamByName('Numero'     ).AsString  := pFornecedor.Numero;

      try
         xQry.ExecSql;
      except
         on E: Exception do
         begin
            raise Exception.Create(
               'Ocorreu um erro ao tentar inserir os dados da '+
               Self.ClassName + '.' + #13 + 'Motivo: ' + e.Message);
         end;
      end;
   finally
      if xQry <> nil then
      begin
         xQry.Close;
         FreeAndNil(xQry);
      end;
   end;
   Result := True;
end;

function TForncedorDAO.InsereColecao(pFornecedor: TColForncedor): Boolean;
var
   xIndice : Integer;
begin
   Result := False;

   for xIndice := 0 to pFornecedor.Count -1 do
   begin
      if not Self.Insere(pFornecedor.Retorna(xIndice)) then
         exit;
   end;

   Result := True;
end;

function TForncedorDAO.Retorna(pFornecedor: Integer): TForncedor;
var
   xQry : TZQuery;
begin
   Result := Nil;
   xQry   := TZQuery.Create(Nil);
   try
      xQry.Connection := Self.vConexao;

      xQry.Sql.Text := RetornaSQLComChave;

      xQry.ParamByName('Id').AsInteger := pFornecedor;

      xQry.Open;

      if xQry.IsEmpty then
         exit;

      Result := TForncedor.Create;

      Result.Id       := xQry.FieldByName('Id'         ).AsInteger;
      Result.CNPJ     := xQry.FieldByName('CNPJ'       ).AsString;
      Result.Nome     := xQry.FieldByName('Nome'       ).AsString;
      Result.Razao    := xQry.FieldByName('RazaoSocial').AsString;
      Result.Ativo    := xQry.FieldByName('Ativo'      ).AsInteger;
      Result.CEP      := xQry.FieldByName('Cep'        ).AsString;
      Result.Cidade   := xQry.FieldByName('Cidade'     ).AsString;
      Result.UF       := xQry.FieldByName('UF'         ).AsString;
      Result.Endereco := xQry.FieldByName('Rua'        ).AsString;
      Result.Bairro   := xQry.FieldByName('Bairro'     ).AsString;
      Result.Numero   := xQry.FieldByName('Numero'     ).AsString;
   finally
      if xQry <> nil then
      begin
         xQry.Close;
         FreeAndNil(xQry);
      end;
   end;
end;

function TForncedorDAO.RetornaColecao(pCondicao: String): TColForncedor;
var
   xQry  : TZQuery;
   xFornecedor : TForncedor;
begin
   Result := nil;
   xQry   := TZQuery.Create(Nil);
   try
      xQry.Connection := Self.vConexao;

      xQry.SQL.Text   := RetornaSQL;

      if (pCondicao <> EmptyStr) then
      begin
         if (Pos('WHERE', UpperCase(pCondicao)) <= 0) then
            xQry.SQL.Add('WHERE' + pCondicao)
         else
            xQry.SQL.Add(pCondicao);
      end;

      xQry.Open;

      if xQry.IsEmpty then
         Exit;

      Result := TColForncedor.Create;

      while not(xQry).Eof do
      begin
         xFornecedor := TForncedor.Create;

         xFornecedor.Id       := xQry.FieldByName('Id'         ).AsInteger;
         xFornecedor.CNPJ     := xQry.FieldByName('CNPJ'       ).AsString;
         xFornecedor.Nome     := xQry.FieldByName('Nome'       ).AsString;
         xFornecedor.Razao    := xQry.FieldByName('RazaoSocial').AsString;
         xFornecedor.Ativo    := xQry.FieldByName('Ativo'      ).AsInteger;
         xFornecedor.CEP      := xQry.FieldByName('Cep'        ).AsString;
         xFornecedor.Cidade   := xQry.FieldByName('Cidade'     ).AsString;
         xFornecedor.UF       := xQry.FieldByName('UF'         ).AsString;
         xFornecedor.Endereco := xQry.FieldByName('Rua'        ).AsString;
         xFornecedor.Bairro   := xQry.FieldByName('Bairro'     ).AsString;
         xFornecedor.Numero   := xQry.FieldByName('Numero'     ).AsString;

         Result.Adiciona(xFornecedor);
         xQry.Next;
      end;
   finally
      if xQry <> nil then
      begin
         xQry.Close;
         FreeAndNil(xQry);
      end;
   end;
end;

end.
