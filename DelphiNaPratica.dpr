program DelphiNaPratica;

uses
  Vcl.Forms,
  UPrincipalView in 'View\UPrincipalView.pas' {frmPrincipal},
  UClientesView in 'View\UClientesView.pas' {frmClientes},
  UEndereco in 'Model\UEndereco.pas',
  UCliente in 'Model\UCliente.pas',
  UClienteDAO in 'Model\UClienteDAO.pas',
  UClienteController in 'Controller\UClienteController.pas',
  UEstadoTelaUtil in 'Model\Util\UEstadoTelaUtil.pas',
  UMensagemUtil in 'Model\Util\UMensagemUtil.pas',
  UConexao in 'Model\BD\UConexao.pas',
  UConsultaAPI in 'Model\UConsultaAPI.pas',
  UFornecedorView in 'View\UFornecedorView.pas' {frmFornecedor},
  UFornecedor in 'Model\UFornecedor.pas',
  UFornecedorDAO in 'Model\UFornecedorDAO.pas',
  UFornecedorController in 'Controller\UFornecedorController.pas',
  UValidaCampos in 'Model\UValidaCampos.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
