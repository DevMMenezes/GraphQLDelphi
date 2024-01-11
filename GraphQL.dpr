program GraphQL;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {frmGraphQL};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmGraphQL, frmGraphQL);
  Application.Run;
end.
