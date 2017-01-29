// Unit de abstra��o de acesso a camada de banco de dados ligado a Data.DB
// Utilizar para fazer heran�a para os drivers de conex�o
// Por: Amarildo Lacerda
// Historico:
//           + 29/01/2017 - Criada a primeira versao
unit MVCBr.DatabaseModel.Interf;

interface

uses MVCBr.Interf, MVCBr.PersistentModel;

type

  TDatabaseModelAbstract = class;

  // IDatabaseModel Interface que implementa a conexao de persistencao ao banco de dados
  IDatabaseModel = interface(IPersistentModel)
    ['{26FC1185-D137-42B5-BA64-3D2D1D22E65F}']
    function This: TDatabaseModelAbstract;
  end;

  // IQueryModel<T> Interface para acesso a Query
  // onde  T � o tipo de objeto query assocado a interface
  IQueryModel<T> = interface
    ['{32E8A447-B035-4ABD-BA27-59017411E018}']
    // Tabela a selecionar
    function Table(Const ATable: string): IQueryModel<T>;
    // Colunas
    function Columns(const AColumns: string): IQueryModel<T>;
    // where
    function Where(Const AWhere: string): IQueryModel<T>;
    // Order by
    function OrderBy(Const AOrderBY: string): IQueryModel<T>;
    // Join
    function Join(const AJoin: string): IQueryModel<T>;
    // GroupBy
    function GroupBy(Const AGroup: string): IQueryModel<T>;

    // Retorna o MODEL associado ao query
    function GetModel: IDatabaseModel;
    // Atribui o MODEL associado
    procedure SetModel( const AModel:IDatabaseModel);
    // Retorna a instancia da Query associada
    function Query:T;
  end;


  TDatabaseModelAbstract = class(TPersistentModelFactory, IDatabaseModel)
  public
    // Na heran�a � necessario indicar o retorno para THIS
    function This: TDatabaseModelAbstract; virtual;
  end;

implementation

{ TDatabaseModelAbstract }

function TDatabaseModelAbstract.This: TDatabaseModelAbstract;
begin
  result := nil;
end;


end.

