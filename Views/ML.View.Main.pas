unit ML.View.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TMainView = class(TForm)
    Label1: TLabel;
  private
    procedure DoRequestBackgroundLocationPermission;
    function GetBasePermissions: TArray<string>;
    function HasBasePermissions: Boolean;
    procedure RequestBackgroundLocationPermission;
    procedure RequestForegroundLocationPermission;
    procedure RequestPermissions;
    procedure Start;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  MainView: TMainView;

implementation

{$R *.fmx}

uses
  System.Permissions,
  DW.Consts.Android, DW.Permissions.Helpers,
  ML.Core;

{ TMainView }

constructor TMainView.Create(AOwner: TComponent);
begin
  inherited;
  RequestPermissions;
end;

function TMainView.GetBasePermissions: TArray<string>;
begin
  Result := [cPermissionAccessCoarseLocation, cPermissionAccessFineLocation];
end;

function TMainView.HasBasePermissions: Boolean;
begin
  Result := PermissionsService.IsEveryPermissionGranted(GetBasePermissions);
end;

procedure TMainView.RequestPermissions;
begin
  if HasBasePermissions then
    RequestBackgroundLocationPermission
  else
    RequestForegroundLocationPermission;
end;

procedure TMainView.RequestForegroundLocationPermission;
begin
  PermissionsService.RequestPermissions(GetBasePermissions,
    procedure(const APermissions: TPermissionArray; const AGrantResults: TPermissionStatusArray)
    begin
      if AGrantResults.AreAllGranted then
        RequestBackgroundLocationPermission;
      // else Show location updates will not work message
    end
  );
end;

procedure TMainView.RequestBackgroundLocationPermission;
begin
  if TOSVersion.Check(10) then
    DoRequestBackgroundLocationPermission
  else
    Start;
end;

procedure TMainView.Start;
begin
  TCore.Create(Self);
end;

procedure TMainView.DoRequestBackgroundLocationPermission;
begin
  PermissionsService.RequestPermissions([cPermissionAccessBackgroundLocation],
    procedure(const APermissions: TPermissionArray; const AGrantResults: TPermissionStatusArray)
    begin
      if AGrantResults.AreAllGranted then
        Start;
      // else show that location updates will not occur in the background
    end
  );
end;

end.
