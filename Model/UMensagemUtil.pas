unit UMensagemUtil;

interface

uses
   Windows, Forms;

type
   TMensagemUtil = Class
      public
         class function Alerta    (pForm : TCustomForm; pMessagem : String) : Integer;
         class function Erro      (pForm : TCustomForm; pMessagem : String) : Integer;
         class function Informacao(pForm : TCustomForm; pMessagem : String) : Integer;
         class function Pergunta  (pForm : TCustomForm; pMessagem : String) : Boolean;
   End;

implementation


{ TMessagemUtil }

class function TMensagemUtil.Alerta(pForm: TCustomForm;
  pMessagem: String): Integer;
begin
   Result := MessageBox(pForm.Handle, PChar(pMessagem), 'Alerta', MB_ICONWARNING);
end;

class function TMensagemUtil.Erro(pForm: TCustomForm;
  pMessagem: String): Integer;
begin
   Result := MessageBox(pForm.Handle, PChar(pMessagem), 'Erro', MB_ICONERROR);
end;

class function TMensagemUtil.Informacao(pForm: TCustomForm;
  pMessagem: String): Integer;
begin
   Result := MessageBox(pForm.Handle, PChar(pMessagem), 'Informação', MB_ICONINFORMATION);
end;

class function TMensagemUtil.Pergunta(pForm: TCustomForm;
  pMessagem: String): Boolean;
begin
   Result := MessageBox(pForm.Handle, PChar(pMessagem), 'Confirmação',
      MB_ICONQUESTION or MB_YESNO) = IDYES;
end;

end.
