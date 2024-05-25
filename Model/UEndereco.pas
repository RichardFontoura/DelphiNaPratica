unit UEndereco;

interface

uses
   SysUtils, Classes;

type
   TEndereco = Class
      private
         vCep      : String;
         vCidade   : String;
         vUF       : String;
         vEndereco : String;
         vNumero   : String;
         vBairro   : String;
      public
         constructor Create;
      published
         property CEP      : String read vCep      write vCep;
         property Cidade   : String read vCidade   write vCidade;
         property UF       : String read vUF       write vUF;
         property Endereco : String read vEndereco write vEndereco;
         property Numero   : String read vNumero   write vNumero;
         property Bairro   : String read vBairro   write vBairro;
   End;

implementation

{ TEndereco }

constructor TEndereco.Create;
begin
   try
      Self.vCep      := EmptyStr;
      Self.vCidade   := EmptyStr;
      Self.vUF       := EmptyStr;
      Self.vEndereco := EmptyStr;
      Self.vNumero   := EmptyStr;
      Self.Bairro    := EmptyStr;
   except
      on e:exception do
         raise Exception.Create(e.Message);
   end;
end;

end.
