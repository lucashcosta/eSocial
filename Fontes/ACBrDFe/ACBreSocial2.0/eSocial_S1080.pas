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
|*  - Passado o namespace para gera��o do cabe�alho
******************************************************************************}
{$I ACBr.inc}

unit eSocial_S1080;

interface

uses
  SysUtils, Classes,
  eSocial_Common, eSocial_Conversao,
  pcnConversao,
  ACBreSocialGerador;

type
  TS1080Collection = class;
  TS1080CollectionItem = class;
  TEvtTabOperPort = class;
  TDadosOperPortuario = class;
  TInfoOperPortuario = class;
  TIdeOperPortuario = class;

  TS1080Collection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TS1080CollectionItem;
    procedure SetItem(Index: Integer; Value: TS1080CollectionItem);
  public
    function Add: TS1080CollectionItem;
    property Items[Index: Integer]: TS1080CollectionItem read GetItem write SetItem; default;
  end;

  TS1080CollectionItem = class(TCollectionItem)
  private
    FTipoEvento: TTipoEvento;
    FEvtTabOperPortuario: TEvtTabOperPort;
    procedure setEvtTabOperPortuario(const Value: TEvtTabOperPort);
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
  published
    property TipoEvento: TTipoEvento read FTipoEvento;
    property EvtTabOperPortuario: TEvtTabOperPort read FEvtTabOperPortuario write setEvtTabOperPortuario;
  end;

  TEvtTabOperPort = class(TESocialEvento)
  private
    FModoLancamento: TModoLancamento;
    fIdeEvento: TIdeEvento;
    fIdeEmpregador: TIdeEmpregador;
    fInfoOperPortuario: TInfoOperPortuario;

    {Geradores espec�ficos da classe}
    procedure gerarIdeOperPortuario();
    procedure gerarDadosOperPortuario();
  public
    constructor Create(AACBreSocial: TObject);overload;
    destructor  Destroy; override;

    function GerarXML: boolean; override;

    property ModoLancamento: TModoLancamento read FModoLancamento write FModoLancamento;
    property IdeEvento: TIdeEvento read fIdeEvento write fIdeEvento;
    property IdeEmpregador: TIdeEmpregador read fIdeEmpregador write fIdeEmpregador;
    property InfoOperPortuario: TInfoOperPortuario read fInfoOperPortuario write fInfoOperPortuario;
  end;

  TDadosOperPortuario = class(TPersistent)
  private
    FAliqRat: integer;
    FFap: Double;
    FAliqRatAjust: Double;
  public
    property aliqRat: integer read FAliqRat write FAliqRat;
    property fap: Double read FFap write FFap;
    property aliqRatAjust: Double read FAliqRatAjust write FAliqRatAjust;
  end;

  TIdeOperPortuario = class(TPersistent)
  private
    FCnpjOpPortuario: string;
    FIniValid: string;
    FFimValid : string;
  public
    property cnpjOpPortuario: string read FCnpjOpPortuario write FCnpjOpPortuario;
    property iniValid: string read FIniValid write FIniValid;
    property fimValid: string read FFimValid write FFimValid;
  end;

  TInfoOperPortuario = class(TPersistent)
  private
    FIdeOperPortuario: TIdeOperPortuario;
    FDadosOperPortuario: TDadosOperPortuario;
    FNovaValidade: TIdePeriodo;
    function getDadosOperPortuario: TDadosOperPortuario;
    function getNovaValidade: TIdePeriodo;
  public
    constructor create;
    destructor destroy; override;
    function dadosOperPortuarioInst(): Boolean;
    function novaValidadeInst(): Boolean;

    property ideOperPortuario: TIdeOperPortuario read FIdeOperPortuario write FIdeOperPortuario;
    property dadosOperPortuario: TDadosOperPortuario read getDadosOperPortuario write FDadosOperPortuario;
    property novaValidade: TIdePeriodo read getNovaValidade write FNovaValidade;
  end;


implementation

uses
  eSocial_Tabelas;

{ TS1080Collection }

function TS1080Collection.Add: TS1080CollectionItem;
begin
  Result := TS1080CollectionItem(inherited Add);
  Result.Create(TComponent(Self.Owner));
end;

function TS1080Collection.GetItem(Index: Integer): TS1080CollectionItem;
begin
  Result := TS1080CollectionItem(inherited GetItem(Index));
end;

procedure TS1080Collection.SetItem(Index: Integer;
  Value: TS1080CollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TS1080CollectionItem }

constructor TS1080CollectionItem.Create(AOwner: TComponent);
begin
  FTipoEvento := teS1080;
  FEvtTabOperPortuario := TEvtTabOperPort.Create(AOwner);
end;

destructor TS1080CollectionItem.Destroy;
begin
  FEvtTabOperPortuario.Free;
  inherited;
end;

procedure TS1080CollectionItem.setEvtTabOperPortuario(
  const Value: TEvtTabOperPort);
begin
  FEvtTabOperPortuario.Assign(Value);
end;

{ TInfoOperPortuario }

constructor TInfoOperPortuario.create;
begin
  FIdeOperPortuario := TIdeOperPortuario.Create;
  FDadosOperPortuario := nil;
  FNovaValidade := nil;
end;

function TInfoOperPortuario.dadosOperPortuarioInst: Boolean;
begin
  Result := Assigned(FDadosOperPortuario);
end;

destructor TInfoOperPortuario.destroy;
begin
  FIdeOperPortuario.Free;
  FreeAndNil(FDadosOperPortuario);
  FreeAndNil(FNovaValidade);
  inherited;
end;

function TInfoOperPortuario.getDadosOperPortuario: TDadosOperPortuario;
begin
  if Not(Assigned(FDadosOperPortuario)) then
    FDadosOperPortuario := TDadosOperPortuario.Create;  
  Result := FDadosOperPortuario;
end;

function TInfoOperPortuario.getNovaValidade: TIdePeriodo;
begin
  if Not(Assigned(FNovaValidade)) then
    FNovaValidade :=TIdePeriodo.Create;
  Result := FNovaValidade;
end;

function TInfoOperPortuario.novaValidadeInst: Boolean;
begin
  Result := Assigned(FNovaValidade);
end;

{ TEvtTabOperPortuario }

constructor TEvtTabOperPort.Create(AACBreSocial: TObject);
begin
  inherited;
  fIdeEvento := TIdeEvento.Create;
  fIdeEmpregador := TIdeEmpregador.Create;
  fInfoOperPortuario := TInfoOperPortuario.Create;
end;

destructor TEvtTabOperPort.Destroy;
begin
  fIdeEvento.Free;
  fIdeEmpregador.Free;
  fInfoOperPortuario.Free;
  inherited;
end;

procedure TEvtTabOperPort.gerarDadosOperPortuario;
begin
  Gerador.wGrupo('dadosOperPortuario');
    Gerador.wCampo(tcStr, '', 'aliqRat', 0, 0, 0, self.InfoOperPortuario.DadosOperPortuario.aliqRat);
    Gerador.wCampo(tcDe4, '', 'fap', 0, 0, 0, self.InfoOperPortuario.DadosOperPortuario.fap);
    Gerador.wCampo(tcDe4, '', 'aliqRatAjust', 0, 0, 0, self.InfoOperPortuario.DadosOperPortuario.aliqRatAjust);
  Gerador.wGrupo('/dadosOperPortuario');
end;

procedure TEvtTabOperPort.gerarIdeOperPortuario;
begin
  Gerador.wGrupo('ideOperPortuario');
    Gerador.wCampo(tcStr, '', 'cnpjOpPortuario', 0, 0, 0, self.InfoOperPortuario.IdeOperPortuario.cnpjOpPortuario);
    Gerador.wCampo(tcStr, '', 'iniValid', 0, 0, 0, self.InfoOperPortuario.IdeOperPortuario.iniValid);
    Gerador.wCampo(tcStr, '', 'fimValid', 0, 0, 0, self.InfoOperPortuario.IdeOperPortuario.fimValid);
  Gerador.wGrupo('/ideOperPortuario');
end;

function TEvtTabOperPort.GerarXML: boolean;
begin
  try
    gerarCabecalho('evtTabOperPort');
      Gerador.wGrupo('evtTabOperPort Id="'+ GerarChaveEsocial(now, self.ideEmpregador.NrInsc, 0) +'"');
        //gerarIdVersao(self);
        gerarIdeEvento(self.IdeEvento);
        gerarIdeEmpregador(self.IdeEmpregador);
        Gerador.wGrupo('infoOperPortuario');
          gerarModoAbertura(Self.ModoLancamento);
            gerarIdeOperPortuario();
            if Self.ModoLancamento <> mlExclusao then
            begin
              gerarDadosOperPortuario();
              if Self.ModoLancamento = mlAlteracao then
                if (InfoOperPortuario.novaValidadeInst()) then
                  GerarIdePeriodo(self.InfoOperPortuario.NovaValidade, 'novaValidade');
            end;
          gerarModoFechamento(Self.ModoLancamento);
        Gerador.wGrupo('/infoOperPortuario');
      Gerador.wGrupo('/evtTabOperPort');
    GerarRodape;

    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtTabOperPort');
    Validar('evtTabOperPort');
  except on e:exception do
    raise Exception.Create(e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

end.
 
