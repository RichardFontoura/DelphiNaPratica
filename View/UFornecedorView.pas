unit UFornecedorView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Mask, Vcl.StdCtrls, Vcl.Buttons,
  PngBitBtn, Vcl.ExtCtrls, Vcl.ComCtrls, UestadoTelaUtil, UFornecedor,
  UFornecedorController;

type
  TfrmFornecedor = class(TForm)
    sbrBarra: TStatusBar;
    pnlBotao: TPanel;
    btnSair: TPngBitBtn;
    btnConfirmar: TPngBitBtn;
    btnIncluir: TPngBitBtn;
    btnAlterar: TPngBitBtn;
    btnExcluir: TPngBitBtn;
    btnConsultar: TPngBitBtn;
    pnlCorpo: TPanel;
    grbFor: TGroupBox;
    lblId: TLabel;
    lblNome: TLabel;
    edtNome: TEdit;
    chkAtivo: TCheckBox;
    edtId: TEdit;
    grpDados: TGroupBox;
    lblEstado: TLabel;
    lblCidade: TLabel;
    lblCEP: TLabel;
    lblRua: TLabel;
    lblBairro: TLabel;
    edtUF: TEdit;
    edtCidade: TEdit;
    edtRua: TEdit;
    edtBairro: TEdit;
    mskCEP: TMaskEdit;
    lblCnpj: TLabel;
    mskCnpj: TMaskEdit;
    lblRazao: TLabel;
    edtRazao: TEdit;
    lblNumero: TLabel;
    edtNumero: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSairClick(Sender: TObject);
    procedure mskCEPExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure edtIdExit(Sender: TObject);
    procedure mskCnpjExit(Sender: TObject);
  private
    { Private declarations }
     vKey : Word;

     vEstadoTela    : TEstadoTela;
     vObjFornecedor : TForncedor;

     procedure DefineEstadoTela;
     procedure LimpaTela;
     procedure HabilitaCampos(pOpcao : Boolean);
     procedure CarregaDadosTela;

     function TrataFornecedorAtivo  : Integer;
     function RecebeFornecedorAtivo : Boolean;
     function ProcessaConfirmacao   : Boolean;
     function ProcessaInclusao      : Boolean;
     function ProcessaFornecedor    : Boolean;
     function ProcessaFornece       : Boolean;
     function ValidaFornecedor      : Boolean;
     function ProcessaConsulta      : Boolean;
     function ProcessaAlteracao     : Boolean;
     function ProcessaExclusao      : Boolean;
  public
    { Public declarations }
  end;

var
  frmFornecedor: TfrmFornecedor;

implementation

uses
   UPrincipalView, UMensagemUtil, UEndereco, UConsultaAPI, UValidaCampos;

{$R *.dfm}

procedure TfrmFornecedor.btnAlterarClick(Sender: TObject);
begin
   vEstadoTela := etAlterar;
   DefineEstadoTela;
end;

procedure TfrmFornecedor.btnConfirmarClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmFornecedor.btnConsultarClick(Sender: TObject);
begin
   vEstadoTela := etConsultar;
   DefineEstadoTela;
end;

procedure TfrmFornecedor.btnExcluirClick(Sender: TObject);
begin
   vEstadoTela := etExcluir;
   DefineEstadoTela;
end;

procedure TfrmFornecedor.btnIncluirClick(Sender: TObject);
begin
   vEstadoTela := etIncluir;
   DefineEstadoTela;
end;

procedure TfrmFornecedor.btnSairClick(Sender: TObject);
begin
   if (vEstadoTela <> etPadrao)then
   begin
      if TMensagemUtil.Pergunta(Self, 'Deseja realmente abortar essa operação?') then
      begin
         vEstadoTela := etPadrao;
         DefineEstadoTela;
      end;
   end
   else
      Close;
end;

procedure TfrmFornecedor.CarregaDadosTela;
begin
   if (vObjFornecedor = nil) then
      Exit;

   edtId.Text       := IntToStr(vObjFornecedor.Id);
   mskCnpj.Text     := vObjFornecedor.CNPJ;
   edtNome.Text     := vObjFornecedor.Nome;
   chkAtivo.Checked := RecebeFornecedorAtivo;
   edtRazao.Text    := vObjFornecedor.Razao;
   mskCep.Text      := vObjFornecedor.CEP;
   edtCidade.Text   := vObjFornecedor.Cidade;
   edtRua.Text      := vObjFornecedor.Endereco;
   edtUF.Text       := vObjFornecedor.UF;
   edtNumero.Text   := vObjFornecedor.Numero;
   edtBairro.Text   := vObjFornecedor.Bairro;
end;

procedure TfrmFornecedor.DefineEstadoTela;
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

         if (frmFornecedor <> nil) and
            (frmFornecedor.Active) and
            (btnIncluir.CanFocus) then
            btnIncluir.SetFocus;

         Application.ProcessMessages;
      end;

      etIncluir:
      begin
         sbrBarra.Panels[0].Text := 'Inclusão';
         HabilitaCampos(True);

         edtId.Enabled    := False;
         chkAtivo.Checked := True;

         if mskCnpj.CanFocus then
            mskCnpj.SetFocus;
      end;

      etAlterar:
      begin
         sbrBarra.Panels[0].Text := 'Alteração';
         HabilitaCampos(False);

         if (edtId.Text <> EmptyStr) then
         begin
            HabilitaCampos(True);

            edtId.Enabled    := False;
            btnAlterar.Enabled   := False;
            btnConfirmar.Enabled := True;
         end
         else
         begin
            edtId.Enabled := True;

            if (edtId.CanFocus) then
               edtId.SetFocus;
         end;
      end;

      etExcluir:
      begin
         sbrBarra.Panels[0].Text := 'Exclusão';
         if (edtId.Text <> EmptyStr) then
            ProcessaExclusao
         else
         begin
            edtId.Enabled := True;

            if (edtId.CanFocus) then
               edtId.SetFocus;
         end;
      end;

      etConsultar:
      begin
         sbrBarra.Panels[0].Text := 'Consulta';
         HabilitaCampos(False);

         if (edtId.Text <> EmptyStr) then
         begin
            edtId.Enabled    := False;
            btnAlterar.Enabled   := True;
            btnExcluir.Enabled   := True;
            btnConfirmar.Enabled := False;

            if btnAlterar.CanFocus then
               btnAlterar.SetFocus;
         end
         else
         begin
            edtId.Enabled := True;

            if edtId.CanFocus then
               edtId.SetFocus;
         end;
      end;

   end;
end;

procedure TfrmFornecedor.edtIdExit(Sender: TObject);
begin
   if vKey = VK_RETURN then
   begin
      ProcessaConsulta;
   end;

   vKey := VK_CLEAR;
end;

procedure TfrmFornecedor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action        := CaFree;
   frmFornecedor := Nil;
   frmPrincipal.sbrBarraStatus.Panels[1].Text := EmptyStr;
end;

procedure TfrmFornecedor.FormCreate(Sender: TObject);
begin
   vEstadoTela := etPadrao;
end;

procedure TfrmFornecedor.FormKeyDown(Sender: TObject; var Key: Word;
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
            if TMensagemUtil.Pergunta(Self, 'Deseja realmente abortar essa operação?') then
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

procedure TfrmFornecedor.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := VK_CLEAR;
end;

procedure TfrmFornecedor.FormShow(Sender: TObject);
begin
   DefineEstadoTela;
end;

procedure TfrmFornecedor.HabilitaCampos(pOpcao: Boolean);
var
   i : Integer;
begin
   for i := 0 to pred(ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Enabled := pOpcao;

      if (Components[i] is TMaskEdit) then
         (Components[i] as TMaskEdit).Enabled := pOpcao;

      if (Components[i] is TCheckBox) then
         (Components[i] as TCheckBox).Enabled := pOpcao;
   end;
end;

procedure TfrmFornecedor.LimpaTela;
var
   i : Integer;
begin
   for i := 0 to pred (ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Text := EmptyStr;

      if (Components[i] is TMaskEdit) then
         (Components[i] as TMaskEdit).Text := EmptyStr;

      if (Components[i] is TCheckBox) then
         (Components[i] as TCheckBox).Checked := False;
   end;
end;

procedure TfrmFornecedor.mskCEPExit(Sender: TObject);
var
   xObjConsulta : TEndereco;
begin
   if vKey = 13 then
   begin
      try
         try
            xObjConsulta := TConsultaAPI.getInstacia.BuscaCEP(Self, mskCep.Text);

            if xObjConsulta <> nil then
            begin
               edtCidade.Text := xObjConsulta.Cidade;
               edtRua.Text    := xObjConsulta.Endereco;
               edtUF.Text     := xObjConsulta.UF;
               edtBairro.Text := xObjConsulta.Bairro;
            end;
         except
            on e:Exception do
            begin
               raise Exception.Create('Falha ao conectar com a API!'#13 +
                  'Valide se o CEP inserido e realmente valido');
            end;
         end;
      finally
         if xObjConsulta <> nil then
            FreeAndNil(xObjConsulta);
      end;
   end;
end;

procedure TfrmFornecedor.mskCnpjExit(Sender: TObject);
var
   xValida : Boolean;
begin
   if vKey = 13 then
   begin
      xValida := TValidaDados.getInstancia.ValidaCNPJ(mskCnpj.Text);

      if not xValida then
      begin
         TMensagemUtil.Alerta(Self, 'Atenção: Este CNPJ não possui um formato valido!');
         mskCnpj.Text := EmptyStr;
         if mskCnpj.CanFocus then
            mskCnpj.SetFocus;
      end;
   end;
end;

function TfrmFornecedor.ProcessaAlteracao: Boolean;
begin
   try
      Result := False;

      if ProcessaFornecedor then
      begin
         TMensagemUtil.Informacao(Self, 'Dados alterados com sucesso');

         vEstadoTela := etPadrao;
         DefineEstadoTela;
         Result := True;
      end;
   except
      on e:exception do
      begin
         raise Exception.Create('Falha ao alterar dados de fornecedor' + e.Message);
      end;
   end;
end;

function TfrmFornecedor.ProcessaConfirmacao: Boolean;
begin
   Result := False;
   try
      case vEstadoTela of
         etIncluir   : Result := ProcessaInclusao;
         etAlterar   : Result := ProcessaAlteracao;
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

function TfrmFornecedor.ProcessaConsulta: Boolean;
begin
   try
      Result := False;

      if edtId.Text = EmptyStr then
      begin
         TMensagemUtil.Alerta(Self, 'Código do fornecedor não pode ficar em branco');

         if (edtId.CanFocus) then
            edtId.SetFocus;

         Exit;
      end;

      vObjFornecedor :=
         TForncedor(TFornecedorController.getInstancia.BuscaFornecedor(
           StrToIntDef(edtId.Text, 0)));

      if (vObjFornecedor <> nil) then
         CarregaDadosTela
      else
      begin
         TMensagemUtil.Alerta(Self, 'Nenhum fornecedor encontrado para o código informado');
         LimpaTela;

         if (edtId.CanFocus) then
            edtId.SetFocus;

         Exit;
      end;

      DefineEstadoTela;
      Result := True;
   except
      on e:Exception do
      begin
         raise Exception.Create('Falha ao consultar os dados de fornecedor'#13 +
         e.Message);
      end;
   end;
end;

function TfrmFornecedor.ProcessaExclusao: Boolean;
begin
   try
      Result := False;

      if vObjFornecedor = nil then
      begin
         TMensagemUtil.Alerta(Self,
            'Não foi possivel carregar todos os dados cadastrados do fornecedor');
         LimpaTela;
         vEstadoTela := etPadrao;
         DefineEstadoTela;
         Exit;
      end;

      try
         if TMensagemUtil.Pergunta(Self, 'Confirma a exclusão do fornecedor?') then
         begin
            Screen.Cursor := crHourGlass;
            TFornecedorController.getInstancia.ExcluiFornecedor(vObjFornecedor);

            TMensagemUtil.Informacao(Self, 'Fornecedor excluido com sucesso.');
         end
         else
         begin
            LimpaTela;
            vEstadoTela := etPadrao;
            DefineEstadoTela;
            Exit;
         end;
      finally
         Screen.Cursor := crDefault;
         Application.ProcessMessages;
      end;
      Result := True;

      LimpaTela;
      vEstadoTela := etPadrao;
      DefineEstadoTela;
   except
      on e:exception do
      begin
         raise Exception.Create('Falha ao excluir dados do fornecedor' + e.Message);
      end;
   end;
end;

function TfrmFornecedor.ProcessaFornece: Boolean;
begin
   try
      Result := False;

      if not ValidaFornecedor then
         Exit;

      if vEstadoTela = etIncluir then
      begin
         if vObjFornecedor <> nil then
            FreeAndNil(vObjFornecedor);

         if vObjFornecedor = nil then
            vObjFornecedor := TForncedor.Create;
      end
      else
      if vEstadoTela = etAlterar then
      begin
         if vObjFornecedor = nil then
            vObjFornecedor := TForncedor.Create;
      end;

      if vObjFornecedor = nil then
            Exit;

      vObjFornecedor.CNPJ     := mskCNPJ.Text;
      vObjFornecedor.Nome     := edtNome.Text;
      vObjFornecedor.Razao    := edtRazao.Text;
      vObjFornecedor.Ativo    := TrataFornecedorAtivo;
      vObjFornecedor.CEP      := mskCep.Text;
      vObjFornecedor.Cidade   := edtCidade.Text;
      vObjFornecedor.UF       := edtUF.Text;
      vObjFornecedor.Endereco := edtRua.Text;
      vObjFornecedor.Bairro   := edtBairro.Text;
      vObjFornecedor.Numero   := edtNumero.Text;

      Result := True;
   except
      on e:exception do
      begin
         raise Exception.Create('Falha ao processar dados do cliente' + #13 +
         e.Message);
      end;
   end;
end;

function TfrmFornecedor.ProcessaFornecedor: Boolean;
begin
   try
      if ProcessaFornece then
      begin
         TFornecedorController.getInstancia.GravaFornecedor(vObjFornecedor);
         Result := True;
      end;
   except
      on e:Exception do
      begin
         TMensagemUtil.Alerta(Self, 'Erro ao processar fornecedor:'#13 + e.Message);
      end;
   end;
end;

function TfrmFornecedor.ProcessaInclusao: Boolean;
begin
   try
      Result := False;

      if ProcessaFornecedor then
      begin
         vObjFornecedor :=
            TFornecedorController.getInstancia.RetornaUltimoID(
               'Id');

         TMensagemUtil.Informacao(Self, 'Fornecedor cadastrado com sucesso.'#13 +
         'Codigo Fornecedor: ' + IntToStr(vObjFornecedor.Id));

         vEstadoTela := etPadrao;
         DefineEstadoTela;

         vObjFornecedor.Id := 0;

         Result := True;
      end;
   except
      on e: Exception do
      begin
         raise Exception.Create(
         'Faha ao incluir os dados do fornecedor: ' + #13 +
         e.Message);
      end;
   end;
end;

function TfrmFornecedor.RecebeFornecedorAtivo: Boolean;
begin
   case vObjFornecedor.Ativo of
      0 : Result := False;
      1 : Result := True;
   end;
end;

function TfrmFornecedor.TrataFornecedorAtivo: Integer;
begin
   if chkAtivo.Checked then
      Result := 1
   else
      Result := 0;
end;

function TfrmFornecedor.ValidaFornecedor: Boolean;
begin
   Result := False;

   if edtNome.Text = EmptyStr then
   begin
      TMensagemUtil.Alerta(Self, 'Nome do Foornecedor não pode ficar em branco.');

      if edtNome.CanFocus then
         edtNome.SetFocus;
      Exit;
   end;

   if edtRazao.Text = EmptyStr then
   begin
      TMensagemUtil.Alerta(Self, 'A Razão Social não pode ficar em branco.');

      if edtRazao.CanFocus then
         edtRazao.SetFocus;
      Exit;
   end;

   if (mskCnpj.Text = EmptyStr) or
      (mskCnpj.Text = '  .   .   /    -  ') then
   begin
      TMensagemUtil.Alerta(Self, 'O CNPJ não pode ficar em branco.');

      if mskCnpj.CanFocus then
         mskCnpj.SetFocus;
      Exit;
   end;

   Result := True;
end;

end.
