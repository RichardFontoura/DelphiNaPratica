unit UFornecedor;

interface

uses
   SysUtils, Classes, UEndereco;

type
   TForncedor = Class(TEndereco)
      private
         vId    : Integer;
         vCNPJ  : String;
         vNome  : String;
         vAtivo : Integer;
         vRazao : String;
      public
         constructor Create;
      published
         property Id    : Integer read vId    write vId;
         property CNPJ  : String  read vCNPJ  write vCNPJ;
         property Nome  : String  read vNome  write vNome;
         property Ativo : Integer read vAtivo write vAtivo;
         property Razao : String  read vRazao write vRazao;
   End;
   TColForncedor = Class(TList)
      public
         function Retorna (pIndex : Integer) : TForncedor;
         procedure Adiciona (pForncedor : TForncedor);
   End;

implementation

{ TForncedor }

constructor TForncedor.Create;
begin
   try
      inherited Create;
      vId    := 0;
      vCNPJ  := EmptyStr;
      vNome  := EmptyStr;
      vAtivo := 0;
      vRazao := EmptyStr;
   except
      on e:exception do
         raise Exception.Create(e.Message);
   end;
end;

{ TColForncedor }

procedure TColForncedor.Adiciona(pForncedor: TForncedor);
begin
   Self.Add(TForncedor(pForncedor));
end;

function TColForncedor.Retorna(pIndex: Integer): TForncedor;
begin
   Result := TForncedor(Self[pIndex]);
end;

end.
