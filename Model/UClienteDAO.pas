unit UClienteDAO;

interface

uses
   ZAbstractConnection, ZConnection, ZAbstractRODataset, ZAbstractDataset,
   ZDataset, SimpleDS, DB, Classes, SysUtils, DateUtils, StdCtrls,
   UCliente;

type
   TClienteDAO = Class
      private
         vConexao : TZConnection;

         function RetornaSQL         : String;
         function RetornaSQLComChave : String;
         function RetornaSQLInsert   : String;
         function RetornaSQLUpdate   : String;
         function RetornaSQLDeleta   : String;
      public
         constructor Create(pConexao : TZConnection);
         function RetornaColecao(pCondicao : String = '') : TColCliente;
         function Retorna(pCliente : Integer) : TCliente;
         function Insere(pCliente  : TCliente) : Boolean;
         function InsereColecao(pCliente : TColCliente) : Boolean;
         function Update(pCliente : TCliente) : Boolean;
         function Deleta(pCliente : Integer) : Boolean;
         function UpdateColecao(pCliente : TColCliente):Boolean;
         function RetornaUltimoId(pCondicao : String) : TCliente;
   End;

implementation

{ TClienteDAO }

constructor TClienteDAO.Create(pConexao: TZConnection);
begin
   Self.vConexao := pConexao;
end;

function TClienteDAO.RetornaSQL: String;
begin
   Result :=
      'SELECT       '#13 +
      '   Id,       '#13 +
      '   Nome,     '#13 +
      '   Ativo,    '#13 +
      '   CEP,      '#13 +
      '   Cidade,   '#13 +
      '   UF,       '#13 +
      '   Endereco, '#13 +
      '   Numero    '#13 +
      'FROM Cliente ';
end;

function TClienteDAO.RetornaSQLComChave: String;
begin
   Result :=
      'SELECT       '#13 +
      '   Id,       '#13 +
      '   Nome,     '#13 +
      '   Ativo,    '#13 +
      '   CEP,      '#13 +
      '   Cidade,   '#13 +
      '   UF,       '#13 +
      '   Endereco, '#13 +
      '   Numero    '#13 +
      'FROM Cliente '#13 +
      'WHERE Id = :Id';
end;

function TClienteDAO.RetornaSQLInsert: String;
begin
   Result :=
      'INSERT INTO Cliente(   '#13 +
      '    Nome,              '#13 +
      '    Ativo,             '#13 +
      '    CEP,               '#13 +
      '    Cidade,            '#13 +
      '    UF,                '#13 +
      '    Endereco,          '#13 +
      '    Numero             '#13 +
      ')                      '#13 +
      'VALUES(                '#13 +
      '    :Nome,             '#13 +
      '    :Ativo,            '#13 +
      '    :CEP,              '#13 +
      '    :Cidade,           '#13 +
      '    :UF,               '#13 +
      '    :Endereco,         '#13 +
      '    :Numero            '#13 +
      ')                      ';
end;

function TClienteDAO.RetornaSQLUpdate: String;
begin
   Result :=
      'UPDATE Cliente SET                   '#13 +
      '    Nome              = :Nome,       '#13 +
      '    Ativo             = :Ativo,      '#13 +
      '    CEP               = :CEP,        '#13 +
      '    Cidade            = :Cidade,     '#13 +
      '    UF                = :UF,         '#13 +
      '    Endereco          = :Endereco,   '#13 +
      '    Numero            = :Numero      '#13 +
      'WHERE Id = :Id                       ';
end;

function TClienteDAO.RetornaSQLDeleta: String;
begin
   Result :=
      'DELETE FROM Cliente '#13+
      'WHERE Id = :Id      ';
end;

function TClienteDAO.Insere(pCliente: TCliente): Boolean;
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

      xQry.ParamByName('Nome'     ).AsString  := pCliente.Nome;
      xQry.ParamByName('Ativo'    ).AsInteger := pCliente.Ativo;
      xQry.ParamByName('CEP'      ).AsString  := pCliente.CEP;
      xQry.ParamByName('Cidade'   ).AsString  := pCliente.Cidade;
      xQry.ParamByName('UF'       ).AsString  := pCliente.UF;
      xQry.ParamByName('Endereco' ).AsString  := pCliente.Endereco;
      xQry.ParamByName('Numero'   ).AsString  := pCliente.Numero;

      try
         xQry.ExecSql;
      except
         on E: Exception do
         begin
            raise Exception.Create(               'Ocorreu um erro ao tentar inserir os dados da '+               Self.ClassName + '.' + #13 + 'Motivo: ' + e.Message);
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

function TClienteDAO.InsereColecao(pCliente: TColCliente): Boolean;
var
   xIndice : Integer;
begin
   Result := False;

   for xIndice := 0 to pCliente.Count -1 do
   begin
      if not Self.Insere(pCliente.Retorna(xIndice)) then
         exit;
   end;

   Result := True;
end;

function TClienteDAO.RetornaUltimoId(pCondicao : String): TCliente;
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
         Result := TCliente.Create;

         Result.Id := xQry.FieldByName('Id').AsInteger;
      except
         on E: Exception do
         begin
            raise Exception.Create(               'Ocorreu um erro ao tentar retornar os dados da '+               Self.ClassName + '.' + #13 + 'Motivo: ' + e.Message);
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

function TClienteDAO.Retorna(pCliente : Integer) : TCliente;
var
   xQry : TZQuery;
begin
   Result := Nil;
   xQry   := TZQuery.Create(Nil);
   try
      xQry.Connection := Self.vConexao;

      xQry.Sql.Text := RetornaSQLComChave;

      xQry.ParamByName('Id').AsInteger := pCliente;

      xQry.Open;

      if xQry.IsEmpty then
         exit;

      Result := TCliente.Create;

      Result.Id       := xQry.FieldByName('Id'      ).AsInteger;
      Result.Nome     := xQry.FieldByName('Nome'    ).AsString;
      Result.Ativo    := xQry.FieldByName('Ativo'   ).AsInteger;
      Result.CEP      := xQry.FieldByName('Cep'     ).AsString;
      Result.Cidade   := xQry.FieldByName('Cidade'  ).AsString;
      Result.UF       := xQry.FieldByName('Uf'      ).AsString;
      Result.Endereco := xQry.FieldByName('Endereco').AsString;
      Result.Numero   := xQry.FieldByName('Numero'  ).AsString;
   finally
      if xQry <> nil then
      begin
         xQry.Close;
         FreeAndNil(xQry);
      end;
   end;
end;

function TClienteDAO.RetornaColecao(pCondicao: String): TColCliente;
var
   xQry  : TZQuery;
   xCliente : TCliente;
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

      Result := TColCliente.Create;

      while not(xQry).Eof do
      begin
         xCliente := TCliente.Create;

         xCliente.Id       := xQry.FieldByName('Id'      ).AsInteger;
         xCliente.Nome     := xQry.FieldByName('Nome'    ).AsString;
         xCliente.Ativo    := xQry.FieldByName('Ativo'   ).AsInteger;
         xCliente.CEP      := xQry.FieldByName('Cep'     ).AsString;
         xCliente.Cidade   := xQry.FieldByName('Cidade'  ).AsString;
         xCliente.UF       := xQry.FieldByName('Uf'      ).AsString;
         xCliente.Endereco := xQry.FieldByName('Endereco').AsString;
         xCliente.Numero   := xQry.FieldByName('Numero'  ).AsString;

         Result.Adiciona(xCliente);
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

function TClienteDAO.Deleta(pCliente : Integer): Boolean;
var
   xQryCep : TZQuery;
begin
   Result := False;
   xQryCep := TZQuery.Create(Nil);
   try
      xQryCep.Connection := Self.vConexao;

      xQryCep.SQL.Text := RetornaSQLDeleta;

      xQryCep.ParamByName('Id').AsInteger := pCliente;
      try
         xQryCep.ExecSql;
      except
         on E: Exception do
         begin
            raise Exception.Create(               'Ocorreu um erro ao tentar apagar os dados da '+               Self.ClassName + '.' + #13 + 'Motivo: ' + e.Message);
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

function TClienteDAO.Update(pCliente: TCliente): Boolean;
var
   xQry : TZQuery;
begin
   Result := False;

   xQry := TZQuery.Create(Nil);
   try
      xQry.Connection := Self.vConexao;

      xQry.SQL.Text := RetornaSQLUpdate;

      xQry.ParamByName('Nome'     ).AsString  := pCliente.Nome;
      xQry.ParamByName('Ativo'    ).AsInteger := pCliente.Ativo;
      xQry.ParamByName('CEP'      ).AsString  := pCliente.CEP;
      xQry.ParamByName('Cidade'   ).AsString  := pCliente.Cidade;
      xQry.ParamByName('UF'       ).AsString  := pCliente.UF;
      xQry.ParamByName('Endereco' ).AsString  := pCliente.Endereco;
      xQry.ParamByName('Numero'   ).AsString  := pCliente.Numero;

      xQry.ParamByName('Id').AsInteger  := pCliente.Id;

      try
         xQry.ExecSql;
      except
         on E: Exception do
         begin
            raise Exception.Create(               'Ocorreu um erro ao tentar atualizar os dados da '+               Self.ClassName + '.' + #13 + 'Motivo: ' + e.Message);
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

function TClienteDAO.UpdateColecao(pCliente: TColCliente): Boolean;
var
   xIndice : Integer;
begin
   Result := True;
   for xIndice := 0 to pCliente.Count -1 do
   begin
      if not Self.Update(pCliente.Retorna(xIndice)) then
      begin
         Result := False;
         exit;
      end;
   end;
end;

end.
