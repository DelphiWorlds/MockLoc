unit ML.Core;

interface

uses
  System.SysUtils, System.Classes, System.Sensors,
  Androidapi.JNIBridge, Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.Location,
  DW.Androidapi.JNI.DWFusedLocation, DW.MultiReceiver.Android;

type
  TMockLocation = record
    Active: Boolean;
    Coords: TLocationCoord2D;
  end;

  TMockLocationEvent = procedure(Sender: TObject; const MockLocation: TMockLocation) of object;

  TMockLocationReceiver = class(TMultiReceiver)
  private
    const
      cActionMockLocation = 'ACTION_MOCK_LOCATION';
      cExtraActive = 'ACTIVE';
      cExtraLatitude = 'LATITUDE';
      cExtraLongitude = 'LONGITUDE';
  private
    FOnMockLocation: TMockLocationEvent;
    procedure DoMockLocation(const AMockLocation: TMockLocation);
  protected
    procedure ConfigureActions; override;
    procedure Receive(context: JContext; intent: JIntent); override;
  public
    constructor Create;
    property OnMockLocation: TMockLocationEvent read FOnMockLocation write FOnMockLocation;
  end;

  TCore = class;

  TFusedLocationClientDelegate = class(TJavaLocal, JDWFusedLocationClientDelegate)
  public
    { JDWFusedLocationClientDelegate }
    procedure onLocation(location: JLocation); cdecl;
    procedure onLocationUpdatesChange(active: Boolean); cdecl;
    procedure onSetMockLocationResult(location: JLocation); cdecl;
    procedure onSetMockModeResult(success: Boolean); cdecl;
  end;

  TCore = class(TDataModule)
  private
    FMockLocationReceiver: TMockLocationReceiver;
    FFusedLocationClient: JDWFusedLocationClient;
    FFusedLocationClientDelegate: JDWFusedLocationClientDelegate;
    procedure MockLocationReceiverMockLocationHandler(Sender: TObject; const AMockLocation: TMockLocation);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  Core: TCore;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  Androidapi.Helpers, Androidapi.JNI.JavaTypes,
  DW.OSLog,
  DW.Location.Types;

{ TMockLocationReceiver }

constructor TMockLocationReceiver.Create;
begin
  inherited Create(False);
end;

procedure TMockLocationReceiver.ConfigureActions;
begin
  IntentFilter.addAction(StringToJString(cActionMockLocation));
end;

procedure TMockLocationReceiver.Receive(context: JContext; intent: JIntent);
var
  LMockLocation: TMockLocation;
begin
  LMockLocation.Coords.Latitude := intent.getFloatExtra(StringToJString(cExtraLatitude), cInvalidLatitude);
  LMockLocation.Coords.Longitude := intent.getFloatExtra(StringToJString(cExtraLongitude), cInvalidLongitude);
  LMockLocation.Active := intent.getBooleanExtra(StringToJString(cExtraActive), True);
  if not LMockLocation.Active or ((LMockLocation.Coords.Latitude <> cInvalidLatitude) and (LMockLocation.Coords.Longitude <> cInvalidLongitude)) then
    DoMockLocation(LMockLocation)
  else
    TOSLog.d('> Invalid intent: %s', [JStringToString(intent.toUri(0))]);
end;

procedure TMockLocationReceiver.DoMockLocation(const AMockLocation: TMockLocation);
begin
  if Assigned(FOnMockLocation) then
    FOnMockLocation(Self, AMockLocation);
end;

{ TFusedLocationClientDelegate }

procedure TFusedLocationClientDelegate.onLocation(location: JLocation);
begin
  //
end;

procedure TFusedLocationClientDelegate.onLocationUpdatesChange(active: Boolean);
begin
  //
end;

procedure TFusedLocationClientDelegate.onSetMockLocationResult(location: JLocation);
begin
  //
end;

procedure TFusedLocationClientDelegate.onSetMockModeResult(success: Boolean);
begin
  //
end;

{ TCore }

constructor TCore.Create(AOwner: TComponent);
begin
  inherited;
  FMockLocationReceiver := TMockLocationReceiver.Create;
  FMockLocationReceiver.OnMockLocation := MockLocationReceiverMockLocationHandler;
  FFusedLocationClientDelegate := TFusedLocationClientDelegate.Create;
  FFusedLocationClient := TJDWFusedLocationClient.JavaClass.init(TAndroidHelper.Context, FFusedLocationClientDelegate);
end;

destructor TCore.Destroy;
begin
  FMockLocationReceiver.Free;
  inherited;
end;

procedure TCore.MockLocationReceiverMockLocationHandler(Sender: TObject; const AMockLocation: TMockLocation);
begin
  if AMockLocation.Active then
    FFusedLocationClient.setMockLocation(AMockLocation.Coords.Latitude, AMockLocation.Coords.Longitude)
  else
    FFusedLocationClient.setMockMode(False);
end;

end.
