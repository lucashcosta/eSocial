{******************************************************************************}
{ Projeto: Componente ACBreSocial                                              }
{  Biblioteca multiplataforma de componentes Delphi para envio dos eventos do  }
{ eSocial - http://www.esocial.gov.br/                                         }
{                                                                              }
{ Direitos Autorais Reservados (c) 2008 Wemerson Souto                         }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{                                                                              }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 27/10/2015: Jean Carlo Cantu, Tiago Ravache
|*  - Doa��o do componente para o Projeto ACBr
|* 01/03/2016: Guilherme Costa
|*  - Passado o namespace para gera��o no cabe�alho
******************************************************************************}
{$I ACBr.inc}

unit eSocial_S1030;

interface

uses
  SysUtils, Classes, DateUtils, Controls,
  eSocial_Common, eSocial_Conversao,
  pcnConversao,
  ACBreSocialGerador;

type
  TS1030Collection = class;
  TS1030CollectionItem = class;
  TEvtTabCargo = class;
  TIdeCargo = class;
  TDadosCargo = class;
  TInfoCargo = class;
  TLeiCargo = class;
  TCargoPublico = class;

  TS1030Collection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TS1030CollectionItem;
    procedure SetItem(Index: Integer; Value: TS1030CollectionItem);
  public
    function Add: TS1030CollectionItem;
    property Items[Index: Integer]: TS1030CollectionItem read GetItem write SetItem; default;
  end;

  TS1030CollectionItem = class(TCollectionItem)
  private
    FTipoEvento: TTipoEvento;
    FEvtTabCargo: TEvtTabCargo;
    procedure setEvtTabCargo(const Value: TEvtTabCargo);
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
  published
    property TipoEvento: TTipoEvento read FTipoEvento;
    property EvtTabCargo: TEvtTabCargo read FEvtTabCargo write setEvtTabCargo;
  end;

  TEvtTabCargo = class(TeSocialEvento)
  private
    FModoLancamento: TModoLancamento;
    fIdeEvento: TIdeEvento;
    fIdeEmpregador: TIdeEmpregador;
    fInfoCargo: TInfoCargo;

    {Geradores espec�ficos da classe}
    procedure gerarIdeCargo();
    procedure gerarLeiCargo();
    procedure gerarCargoPublico();
    procedure gerarDadosCargo();
  public
    constructor Create(AACBreSocial: TObject);overload;
    destructor Destroy; override;

    function GerarXML: boolean; override;

    property ModoLancamento: TModoLancamento read FModoLancamento write FModoLancamento;
    property IdeEvento: TIdeEvento read fIdeEvento write fIdeEvento;
    property IdeEmpregador: TIdeEmpregador read fIdeEmpregador write fIdeEmpregador;
    property InfoCargo: TInfoCargo read fInfoCargo write fInfoCargo;
  end;

  TIdeCargo = class(TPersistent)
   private
    FCodCargo : string;
    FIniValid : string;
    FFimValid : string;
  public
    property CodCargo: string read FCodCargo write FCodCargo;
    property iniValid: string read FIniValid write FIniValid;
    property fimValid: string read FFimValid write FFimValid;
  end;

  TDadosCargo = class(TPersistent)
   private
    FNmCargo: string;
    FCodCBO: string;
    FCargoPublico: TCargoPublico;
    function getCargoPublico: TCargoPublico;
  public
    constructor create;
    destructor destroy; override;
    function cargoPublicInst(): Boolean;

    property nmCargo: string read FNmCargo write FNmCargo;
    property codCBO: string read FCodCBO write FCodCBO;
    property cargoPublico: TCargoPublico read getCargoPublico write FCargoPublico;
  end;

  TInfoCargo = class(TPersistent)
   private
    FIdeCargo: TIdeCargo;
    FDadosCargo: TDadosCargo;
    FNovaValidade: TidePeriodo;
    function getDadosCargo: TDadosCargo;
    function getNovaValidade: TidePeriodo;
  public
    constructor create;
    destructor destroy; override;
    function dadosCargoInst(): Boolean;
    function novaValidadeInst(): Boolean;

    property IdeCargo: TIdeCargo read FIdeCargo write FIdeCargo;
    property DadosCargo: TDadosCargo read getDadosCargo write FDadosCargo;
    property NovaValidade: TidePeriodo read getNovaValidade write FNovaValidade;
  end;

  TLeiCargo = class(TPersistent)
   private
    FNrLei: string;
    FDtLei: TDate;
    FSitCargo: tpSitCargo;
  public
    property nrLei: string read FNrLei write FNrLei;
    property dtLei: TDate read FDtLei write FDtLei;
    property sitCargo: tpSitCargo read FSitCargo write FSitCargo;
  end;

  TCargoPublico = class(TPersistent)
  private
    FAcumCargo: tpAcumCargo;
    FContagemEsp: tpContagemEsp;
    FDedicExcl: tpSimNao;
    FLeiCargo: TLeiCargo;
  public
    constructor create;
    destructor destroy; override;

    property acumCargo: tpAcumCargo read FAcumCargo write FAcumCargo; 
    property contagemEsp: tpContagemEsp read FContagemEsp write FContagemEsp;
    property dedicExcl: tpSimNao read FDedicExcl write FDedicExcl;
    property leiCargo: TLeiCargo read FLeiCargo write FLeiCargo;
  end;

implementation

uses
  eSocial_Tabelas;

{ TS1030Collection }

function TS1030Collection.Add: TS1030CollectionItem;
begin
  Result := TS1030CollectionItem(inherited Add);
  Result.Create(TComponent(Self.Owner));
end;

function TS1030Collection.GetItem(Index: Integer): TS1030CollectionItem;
begin
  Result := TS1030CollectionItem(inherited GetItem(Index));
end;

procedure TS1030Collection.SetItem(Index: Integer;
  Value: TS1030CollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TS1030CollectionItem }

constructor TS1030CollectionItem.Create(AOwner: TComponent);
begin
  FTipoEvento := teS1030;
  FEvtTabCargo := TEvtTabCargo.Create(AOwner);
end;

destructor TS1030CollectionItem.Destroy;
begin
  FEvtTabCargo.Free;
  inherited;
end;

procedure TS1030CollectionItem.setEvtTabCargo(const Value: TEvtTabCargo);
begin
  FEvtTabCargo.Assign(Value);
end;

{ TInfoCargo }

constructor TInfoCargo.create;
begin
  FIdeCargo := TIdeCargo.Create;
  FDadosCargo := nil;
  FNovaValidade := nil;
end;

function TInfoCargo.dadosCargoInst: Boolean;
begin
  Result := Assigned(FDadosCargo);
end;

destructor TInfoCargo.destroy;
begin
  FIdeCargo.Free;
  FreeAndNil(FDadosCargo);
  FreeAndNil(FNovaValidade);
  inherited;
end;

function TInfoCargo.getDadosCargo: TDadosCargo;
begin
  if Not(Assigned(FDadosCargo)) then
    FDadosCargo := TDadosCargo.create;
  Result := FDadosCargo;
end;

function TInfoCargo.getNovaValidade: TidePeriodo;
begin
  if Not(Assigned(FNovaValidade)) then
    FNovaValidade := TIdePeriodo.Create;
  Result := FNovaValidade;
end;

function TInfoCargo.novaValidadeInst: Boolean;
begin
  Result := Assigned(FNovaValidade);
end;

{ TEvtTabCargo }

constructor TEvtTabCargo.Create(AACBreSocial: TObject);
begin
  inherited;
  fIdeEvento := TIdeEvento.Create;
  fIdeEmpregador := TIdeEmpregador.Create;
  fInfoCargo := TInfoCargo.Create;
end;

destructor TEvtTabCargo.Destroy;
begin
  fIdeEvento.Free;
  fIdeEmpregador.Free;
  fInfoCargo.Free;
  inherited;
end;

procedure TEvtTabCargo.gerarCargoPublico;
begin
  if (infoCargo.DadosCargo.cargoPublicInst()) then
  begin
    Gerador.wGrupo('cargoPublico');
      Gerador.wCampo(tcStr, '', 'acumCargo', 0, 0, 0, eSAcumCargoToStr(infoCargo.DadosCargo.cargoPublico.acumCargo));
      Gerador.wCampo(tcStr, '', 'contagemEsp', 0, 0, 0, eSContagemEspToStr(infoCargo.DadosCargo.cargoPublico.contagemEsp));
      Gerador.wCampo(tcStr, '', 'dedicExcl', 0, 0, 0, eSSimNaoToStr(infoCargo.DadosCargo.cargoPublico.dedicExcl));
      gerarLeiCargo();
    Gerador.wGrupo('/cargoPublico');
  end;
end;

procedure TEvtTabCargo.gerarDadosCargo;
begin
  Gerador.wGrupo('dadosCargo');
    Gerador.wCampo(tcStr, '', 'nmCargo', 0, 0, 0, self.InfoCargo.dadosCargo.nmCargo);
    Gerador.wCampo(tcStr, '', 'codCBO', 0, 0, 0, self.InfoCargo.dadosCargo.codCBO);
    gerarCargoPublico();
  Gerador.wGrupo('/dadosCargo');
end;

procedure TEvtTabCargo.gerarIdeCargo;
begin
  Gerador.wGrupo('ideCargo');
    Gerador.wCampo(tcStr, '', 'codCargo', 0, 0, 0, infoCargo.ideCargo.CodCargo);
    Gerador.wCampo(tcStr, '', 'iniValid', 0, 0, 0, infoCargo.ideCargo.iniValid);
    Gerador.wCampo(tcStr, '', 'fimValid', 0, 0, 0, infoCargo.ideCargo.fimValid);
  Gerador.wGrupo('/ideCargo');
end;

procedure TEvtTabCargo.gerarLeiCargo;
begin
  Gerador.wGrupo('leiCargo');
    Gerador.wCampo(tcStr, '', 'nrLei', 0, 0, 0, infoCargo.DadosCargo.cargoPublico.leiCargo.nrLei);
    Gerador.wCampo(tcDat, '', 'dtLei', 0, 0, 0, infoCargo.DadosCargo.cargoPublico.leiCargo.dtLei);
    Gerador.wCampo(tcStr, '', 'sitCargo', 0, 0, 0, eStpSitCargoToStr(infoCargo.DadosCargo.cargoPublico.leiCargo.sitCargo));
  Gerador.wGrupo('/leiCargo');
end;

function TEvtTabCargo.GerarXML: boolean;
begin
  try
    gerarCabecalho('evtTabCargo');
    Gerador.wGrupo('evtTabCargo Id="'+ GerarChaveEsocial(now, self.ideEmpregador.NrInsc, 0) +'"');
      //gerarIdVersao(self);
      gerarIdeEvento(self.IdeEvento);
      gerarIdeEmpregador(self.IdeEmpregador);
      Gerador.wGrupo('infoCargo');
      gerarModoAbertura(Self.ModoLancamento);
        gerarIdeCargo();
        if Self.ModoLancamento <> mlExclusao then
        begin
          gerarDadosCargo();
          if Self.ModoLancamento = mlAlteracao then
            if (InfoCargo.novaValidadeInst()) then
              GerarIdePeriodo(self.InfoCargo.NovaValidade, 'novaValidade');
        end;
      gerarModoFechamento(Self.ModoLancamento);
    Gerador.wGrupo('/infoCargo');
    Gerador.wGrupo('/evtTabCargo');
    GerarRodape;

    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtTabCargo');
    Validar('evtTabCargo');
  except on e:exception do
    raise Exception.Create(e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

{ TCargoPublico }

constructor TCargoPublico.create;
begin
  FLeiCargo := TLeiCargo.Create;
end;

destructor TCargoPublico.destroy;
begin
  FLeiCargo.Free;
  inherited;
end;

{ TDadosCargo }

function TDadosCargo.cargoPublicInst: Boolean;
begin
  Result := Assigned(FCargoPublico);
end;

constructor TDadosCargo.create;
begin
  FCargoPublico := nil;
end;

destructor TDadosCargo.destroy;
begin
  FreeAndNil(FCargoPublico);
  inherited;
end;

function TDadosCargo.getCargoPublico: TCargoPublico;
begin
  if Not(Assigned(FCargoPublico)) then
    FCargoPublico := TCargoPublico.create;
  Result := FCargoPublico;
end;

end.
 
