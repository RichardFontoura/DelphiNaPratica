program DelphiNaPratica;

uses
  Vcl.Forms,
  UPrincipalView in 'View\UPrincipalView.pas' {frmPrincipal},
  UConexao in 'Model\UConexao.pas',
  UClientesView in 'View\UClientesView.pas' {frmClientes},
  UFuncoesUtil in 'Model\UFuncoesUtil.pas',
  UEstadoTelaUtil in 'Model\UEstadoTelaUtil.pas',
  UMensagemUtil in 'Model\UMensagemUtil.pas',
  UEndereco in 'Model\UEndereco.pas',
  UCliente in 'Model\UCliente.pas',
  UClienteDAO in 'Model\UClienteDAO.pas',
  UClienteController in 'Controller\UClienteController.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
