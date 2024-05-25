unit UClientesView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons, PngBitBtn, Vcl.Mask, UEstadoTelaUtil;

type
  TfrmClientes = class(TForm)
    sbrBarra: TStatusBar;
    pnlBotao: TPanel;
    pnlCorpo: TPanel;
    grbCad: TGroupBox;
    lblId: TLabel;
    edtId: TEdit;
    lblNome: TLabel;
    edtNome: TEdit;
    chkAtivo: TCheckBox;
    btnSair: TPngBitBtn;
    btnConfirmar: TPngBitBtn;
    btnIncluir: TPngBitBtn;
    btnAlterar: TPngBitBtn;
    btnExcluir: TPngBitBtn;
    btnConsultar: TPngBitBtn;
    grbEnd: TGroupBox;
    lblCidade: TLabel;
    lblEndereco: TLabel;
    edtCidade: TEdit;
    edtEndereco: TEdit;
    lblUF: TLabel;
    edtUF: TEdit;
    lblCEP: TLabel;
    mskCep: TMaskEdit;
    lblNumero: TLabel;
    edtNumero: TEdit;
    procedure btnSairClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure edtIdExit(Sender: TObject);
  private
     { Private declarations }
     vKey : Word;

     vEstadoTela : TEstadoTela;

     procedure DefineEstadoTela;
     procedure LimpaTela;
     procedure HabilitaCampos(pOpcao : Boolean);

     function ProcessaConfirmacao : Boolean;
     function ProcessaInclusao    : Boolean;
     function ProcessaCliente     : Boolean;
     function ProcessaPessoa      : Boolean;
     function ValidaCliente       : Boolean;
  public
     { Public declarations }
  end;

var
  frmClientes: TfrmClientes;

implementation

uses
   UPrincipalView, UMensagemUtil;

{$R *.dfm}

procedure TfrmClientes.btnAlterarClick(Sender: TObject);
begin
   vEstadoTela := etAlterar;
   DefineEstadoTela;
end;

procedure TfrmClientes.btnConfirmarClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmClientes.btnConsultarClick(Sender: TObject);
begin
   vEstadoTela := etConsultar;
   DefineEstadoTela;
end;

procedure TfrmClientes.btnExcluirClick(Sender: TObject);
begin
   vEstadoTela := etExcluir;
   DefineEstadoTela;
end;

procedure TfrmClientes.btnIncluirClick(Sender: TObject);
begin
   vEstadoTela := etIncluir;
   DefineEstadoTela;
end;

procedure TfrmClientes.btnSairClick(Sender: TObject);
begin
   if (vEstadoTela <> etPadrao)then
   begin
      if TMensagemUtil.Pergunta(Self, 'Deseja realmente abortar essa opera��o?') then
      begin
         vEstadoTela := etPadrao;
         DefineEstadoTela;
      end;
   end
   else
      Close;
end;

procedure TfrmClientes.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action      := CaFree;
   frmClientes := Nil;
   frmPrincipal.sbrBarraStatus.Panels[1].Text := EmptyStr;
end;

procedure TfrmClientes.FormCreate(Sender: TObject);
begin
   vEstadoTela := etPadrao;
end;

procedure TfrmClientes.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := Key;

   case vKey of
      VK_RETURN:
      begin
         Perform(WM_NextDlgCtl, 0, 0);
      end;

      VK_ESCAPE:
      begin
         if (vEstadoTela <> etPadrao)then
         begin
            if TMensagemUtil.Pergunta(Self, 'Deseja realmente abortar essa opera��o?') then
            begin
               vEstadoTela := etPadrao;
               DefineEstadoTela;
            end;
         end
         else
         begin
            if TMensagemUtil.Pergunta(Self, 'Deseja sair da rotina?') then
               Close;
         end;
      end;
   end;
end;

procedure TfrmClientes.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := VK_CLEAR;
end;

procedure TfrmClientes.FormShow(Sender: TObject);
begin
   DefineEstadoTela;
end;

procedure TfrmClientes.LimpaTela;
var
   i : Integer;
begin
   for i := 0 to pred (ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit) .Text := EmptyStr;

      if (Components[i] is TMaskEdit) then
         (Components[i] as TMaskEdit) .Text := EmptyStr;

      if (Components[i] is TCheckBox) then
         (Components[i] as TCheckBox) .Checked := False;
   end;
end;

function TfrmClientes.ProcessaConfirmacao: Boolean;
begin
   Result := False;
   try
      case vEstadoTela of
         etIncluir   : Result := ProcessaInclusao;
         //etAlterar   : Result := ProcessaAlteracao;
      end;

      if not Result then
         Exit;
   except
      on E:Exception do
         Application.MessageBox(PWideChar('Ocorreu o seguinte problema' + #13 +
         E.Message), 'Alerta', MB_ICONERROR);
   end;

   Result := True;
end;

function TfrmClientes.ProcessaInclusao: Boolean;
begin
   try
      Result := False;

      if ProcessaCliente then
      begin
         TMensagemUtil.Informacao(Self, 'Cliente cadastrado com sucesso.');

         vEstadoTela := etPadrao;
         DefineEstadoTela;

         Result := True;
      end;
   except
      on e: Exception do
      begin
         raise Exception.Create(
         'Faha ao incluir os dados do cliente: ' + #13 +
         e.Message);
      end;
   end;
end;

function TfrmClientes.ProcessaPessoa: Boolean;
begin
   try
      Result := False;

      if not ValidaCliente then
         Exit;

      {if vEstadoTela = etIncluir then
      begin
         if vObjCliente <> nil then
            FreeAndNil(vObjCliente);

         if vObjCliente = nil then
            vObjCliente := TCliente.Create;
      end
      else
      if vEstadoTela = etAlterar then
      begin
         if vObjCliente = nil then
            vObjCliente := TCliente.Create;
      end;

      if vObjCliente = nil then
            Exit;

      vObjCliente.Nome       := edtNome.Text;
      vObjCliente.Endereco   := edtEndereco.Text;
      vObjCliente.Bairro     := edtBairro.Text;
      vObjCliente.Cidade     := edtCidade.Text;
      vObjCliente.Estado     := cmbEstado.Text;
      vObjCliente.TipoPessoa := IntToStr(rgpTipoPessoa.ItemIndex);
      vObjCliente.CPFCNPJ    := mskCPFCNPJ.Text;}

      Result := True;
   except
      on e:exception do
      begin
         raise Exception.Create('Falha ao processar dados do cliente' + #13 +
         e.Message);
      end;
   end;
end;

function TfrmClientes.ValidaCliente: Boolean;
begin
   Result := False;

   if edtNome.Text = EmptyStr then
   begin
      TMensagemUtil.Alerta(Self, 'Nome do Cliente n�o pode ficar em branco.');

      if edtNome.CanFocus then
         edtNome.SetFocus;
      Exit;
   end;

   Result := True;
end;

function TfrmClientes.ProcessaCliente: Boolean;
begin
   try
      if ProcessaPessoa then
      begin
         //TPessoaController.getInstancia.GravaPessoa(vObjCliente);
         Result := True;
      end;
   except
      on e:Exception do
      begin
         TMensagemUtil.Alerta(Self, 'Erro ao processar cliente:'#13 + e.Message);
      end;
   end;
end;

procedure TfrmClientes.HabilitaCampos(pOpcao: Boolean);
var
   i : Integer;
begin
   for i := 0 to pred(ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Enabled := pOpcao;

      if (Components[i] is TMaskEdit) then
         (Components[i] as TMaskEdit) .Enabled := pOpcao;

      if (Components[i] is TCheckBox) then
         (Components[i] as TCheckBox) .Enabled := pOpcao;
   end;
end;

procedure TfrmClientes.DefineEstadoTela;
begin
   btnIncluir.Enabled   := (vEstadoTela in [etPadrao]);
   btnAlterar.Enabled   := (vEstadoTela in [etPadrao]);
   btnExcluir.Enabled   := (vEstadoTela in [etPadrao]);
   btnConsultar.Enabled := (vEstadoTela in [etPadrao]);

   btnConfirmar.Enabled :=
      vEstadoTela in [etIncluir, etAlterar, etExcluir, etConsultar];

   case vEstadoTela of
      etPadrao:
      begin
        HabilitaCampos(False);
        LimpaTela;

        sbrBarra.Panels[0].Text := EmptyStr;

        if (frmClientes <> nil) and
           (frmClientes.Active) and
           (btnIncluir.CanFocus) then
           btnIncluir.SetFocus;

           Application.ProcessMessages;
      end;

      etIncluir:
      begin
         sbrBarra.Panels[0].Text := 'Inclus�o';
         HabilitaCampos(True);

         edtId.Enabled    := False;
         chkAtivo.Checked := True;

         if edtNome.CanFocus then
            edtNome.SetFocus;
      end;

   end;
end;

procedure TfrmClientes.edtIdExit(Sender: TObject);
begin
   if vKey = VK_RETURN then
   begin
      //ProcessaConsulta;
   end;

   vKey := VK_CLEAR;
end;

end.