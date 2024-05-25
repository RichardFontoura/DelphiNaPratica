unit UCliente;

interface

uses
   SysUtils, Classes, UEndereco;

type
   TCliente = Class(TEndereco)
      private
         vId    : String;
         vNome  : String;
         vAtivo : Integer;
      public
         constructor Create;
      published
         property Id    : String  read vId    write vId;
         property Nome  : String  read vNome  write vNome;
         property Ativo : Integer read vAtivo write vAtivo;
   End;
   TColCliente = Class(TList)
      public
         function Retorna (pIndex : Integer) : TCliente;
         procedure Adiciona (pCliente : TCliente);
   End;

implementation

{ TCliente }

constructor TCliente.Create;
begin
   try
      inherited Create;
      Self.vId    := EmptyStr;
      Self.vNome  := EmptyStr;
      Self.vAtivo := 0;
   except
      on e:exception do
         raise Exception.Create(e.Message);
   end;
end;

{ TColCliente }

procedure TColCliente.Adiciona(pCliente: TCliente);
begin
   Self.Add(TCliente(pCliente));
end;

function TColCliente.Retorna(pIndex: Integer): TCliente;
begin
   Result := TCliente(Self[pIndex]);
end;

end.
