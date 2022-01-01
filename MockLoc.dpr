program MockLoc;

uses
  System.StartUpCopy,
  FMX.Forms,
  ML.View.Main in 'Views\ML.View.Main.pas' {MainView},
  ML.Core in 'Core\ML.Core.pas' {Core: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainView, MainView);
  Application.Run;
end.
