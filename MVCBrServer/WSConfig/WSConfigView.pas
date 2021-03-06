{ //************************************************************// }
{ //                                                            // }
{ //         C�digo gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 03/03/2017 11:35:23                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresenta��o ao usu�rio
/// deve esta associado a um controller onde ocorrer�
/// a troca de informa��es e comunica��o com os Models
/// </summary>
unit WSConfigView;

interface

uses
{$IFDEF LINUX} {$ELSE} {$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}{$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.ObjectConfigList,
  MVCBr.View,
  System.JSON,
{$IFDEF LINUX}
{$ELSE}
  VCL.Controls, VCL.StdCtrls, {$ENDIF}
  MVCBr.FormView, MVCBr.Controller;

type
  TWSConfigView = class;

  /// Interface para a VIEW
  IWSConfigView = interface(IView)
    ['{3DCAFC16-0A94-403F-8EAA-F328F6588A66}']
    // incluir especializacoes aqui
    function ThisAs: TWSConfigView;
    function GetConfig: TJsonValue;
    function GetServer: TJsonValue;
    function ConnectionString: string;
    function GetPort: integer;
  end;

  /// Object Factory que implementa a interface da VIEW
  TWSConfigView = class(TFormFactory { TFORM } , IView, IThisAs<TWSConfigView>,
    IWSConfigView, IViewAs<IWSConfigView>)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    driverid: TComboBox;
    Label2: TLabel;
    Server: TEdit;
    Label3: TLabel;
    Database: TEdit;
    Label4: TLabel;
    user_name: TEdit;
    Label5: TLabel;
    Password: TEdit;
    Button1: TButton;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    WSPort: TEdit;
    Label7: TLabel;
    vendorlib: TEdit;
    procedure Button1Click(Sender: TObject);
  private
  protected
    FList: TObjectConfigModel;
    procedure AfterConstruction; override;
    destructor destroy; override;
    procedure AddControls;
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function This: TObject; override;
    function ThisAs: TWSConfigView;
    function ViewAs: IWSConfigView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function UpdateView: IView; override;
    function GetConfig: TJsonValue;
    function GetServer: TJsonValue;
    function ConnectionString: string;
    function GetPort: integer;
  end;

Implementation

{$IFDEF LINUX}
{$ELSE}
{$R *.DFM}
{$ENDIF}

uses OData.Interf, System.JSON.helper;

function TWSConfigView.UpdateView: IView;
begin
  result := self;
  { codigo para atualizar a View vai aqui... }
end;

function TWSConfigView.ViewAs: IWSConfigView;
begin
  result := self;
end;

function TWSConfigView.GetConfig: TJsonValue;
var
  j: TJsonObject;
begin
  j := TJsonObject.create() as TJsonObject;
  j.addPair('connection', GetServer);
  result := j;
end;

function TWSConfigView.GetPort: integer;
begin
  result := strToIntDef(WSPort.Text, 8080);
end;

function TWSConfigView.GetServer: TJsonValue;
var
  j: TJsonObject;
  str: TStringList;
begin
  str := TStringList.create;
  try
    str.LoadFromFile(FList.FileName);
    j := TJsonObject.ParseJSONValue(str.Text) as TJsonObject;
    try
      result := TJsonObject.ParseJSONValue(j.GetValue('Config').ToJSON);
      /// workaroud avoid memory leak
    finally
      j.free;
    end;
  finally
    str.free;
  end;
end;

class function TWSConfigView.New(aController: IController): IView;
begin
  result := TWSConfigView.create(nil);
  result.Controller(aController);
end;

/// adiciona os componentes a serem gravados na configura��o em uma lista
///
procedure TWSConfigView.AddControls;
begin
{$IFDEF LINUX}
  WSPort := TEdit.create(self);
  WSPort.Name := 'WSPort';
  WSPort.Text := '8080';
  driverid := TComboBox.create(self);
  driverid.Name := 'driverid';
  driverid.Text := 'FB';
  Server := TEdit.create(self);
  Server.Name := 'server';
  Server.Text := 'DbMVCBr';
  Database := TEdit.create(self);
  Database.Name := 'database';
  Database.Text := 'mvcbr';
  user_name := TEdit.create(self);
  user_name.Name := 'user_name';
  user_name.Text := 'SYSDBA';
  Password := TEdit.create(self);
  Password.Name := 'password';
  Password.Text := 'masterkey';

  vendorlib := TEdit.create(self);
  vendorlib.Name := 'vendorlib';
  vendorlib.Text := '';

{$ENDIF}
  /// dados do servidor
  FList.Add(WSPort);
  /// conex�es de Banco de Dados
  FList.Add(driverid);
  FList.Add(Server);
  FList.Add(Database);
  FList.Add(user_name);
  FList.Add(Password);
  FList.Add(vendorlib);
end;

/// escreve os dados no arquivo de configura��o
procedure TWSConfigView.AfterConstruction;
begin
  inherited;
  FList := TObjectConfigModel.create(self);
  FList.FileName := GetODataConfigFilePath + 'MVCBrServer.config';
  AddControls;
  try
    if not fileExists(FList.FileName, false) then
      FList.WriteConfig
    else
      FList.ReadConfig;
  except
  end;
end;

procedure TWSConfigView.Button1Click(Sender: TObject);
begin
  FList.WriteConfig;
{$IFDEF LINUX}
{$ELSE}
  close;
{$ENDIF}
end;

/// inicializa o controller do VIEW
function TWSConfigView.ConnectionString: string;
begin
  with GetServer do
    try
      result := asString;
    finally
      free;
    end;
end;

function TWSConfigView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
end;

destructor TWSConfigView.destroy;
begin
  if assigned(FList) then
    FList.free;
  inherited;
end;

function TWSConfigView.This: TObject;
begin
  result := inherited This;
end;

function TWSConfigView.ThisAs: TWSConfigView;
begin
  result := self;
end;

function TWSConfigView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
