unit UFornecedorView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Mask, Vcl.StdCtrls, Vcl.Buttons,
  PngBitBtn, Vcl.ExtCtrls, Vcl.ComCtrls, UestadoTelaUtil;

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
  private
    { Private declarations }
     vKey : Word;

     vEstadoTela : TEstadoTela;
  public
    { Public declarations }
  end;

var
  frmFornecedor: TfrmFornecedor;

implementation

uses
   UPrincipalView, UMensagemUtil, UEndereco, UConsultaAPI;

{$R *.dfm}

procedure TfrmFornecedor.btnSairClick(Sender: TObject);
begin
   if (vEstadoTela <> etPadrao)then
   begin
      if TMensagemUtil.Pergunta(Self, 'Deseja realmente abortar essa operação?') then
      begin
         vEstadoTela := etPadrao;
         //DefineEstadoTela;
      end;
   end
   else
      Close;
end;

procedure TfrmFornecedor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action        := CaFree;
   frmFornecedor := Nil;
   frmPrincipal.sbrBarraStatus.Panels[1].Text := EmptyStr;
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
               //DefineEstadoTela;
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

end.
