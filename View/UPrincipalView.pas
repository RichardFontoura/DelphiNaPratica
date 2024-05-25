unit UPrincipalView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Buttons, PngSpeedButton;

type
  TfrmPrincipal = class(TForm)
    sbrBarraStatus: TStatusBar;
    menMenu: TMainMenu;
    menCadastros: TMenuItem;
    menSair: TMenuItem;
    menClientes: TMenuItem;
    menFornecedores: TMenuItem;
    pnlBotao: TPanel;
    btnClientes: TPngSpeedButton;
    btnFornecedor: TPngSpeedButton;
    btnSair: TPngSpeedButton;
    imgFundo: TImage;
    procedure menSairClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure menClientesClick(Sender: TObject);
    procedure btnClientesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnFornecedorClick(Sender: TObject);
    procedure menFornecedoresClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
   UConexao, UClientesView, UFornecedorView;

{$R *.dfm}

procedure TfrmPrincipal.btnSairClick(Sender: TObject);
begin
   Close;
end;

procedure TfrmPrincipal.menSairClick(Sender: TObject);
begin
   Close;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
   sbrBarraStatus.Panels[0].Text := 'Caminho Banco: ' + TConexao.get.getCaminhoBanco;
end;

procedure TfrmPrincipal.menClientesClick(Sender: TObject);
begin
   Screen.Cursor := crHourGlass;

   if frmClientes = nil then
      frmClientes := TfrmClientes.Create(Application);

   sbrBarraStatus.Panels[1].Text := 'Clientes';
   frmClientes.Show;

   Screen.Cursor := crArrow;
end;

procedure TfrmPrincipal.btnClientesClick(Sender: TObject);
begin
   Screen.Cursor := crHourGlass;

   if frmClientes = nil then
      frmClientes := TfrmClientes.Create(Application);

   sbrBarraStatus.Panels[1].Text := 'Clientes';
   frmClientes.Show;

   Screen.Cursor := crArrow;
end;

procedure TfrmPrincipal.btnFornecedorClick(Sender: TObject);
begin
   Screen.Cursor := crHourGlass;

   if frmFornecedor = nil then
      frmFornecedor := TfrmFornecedor.Create(Application);

   sbrBarraStatus.Panels[1].Text := 'Forncedores';
   frmFornecedor.Show;

   Screen.Cursor := crArrow;
end;

procedure TfrmPrincipal.menFornecedoresClick(Sender: TObject);
begin
   Screen.Cursor := crHourGlass;

   if frmFornecedor = nil then
      frmFornecedor := TfrmFornecedor.Create(Application);

   sbrBarraStatus.Panels[1].Text := 'Forncedores';
   frmFornecedor.Show;

   Screen.Cursor := crArrow;
end;

end.
