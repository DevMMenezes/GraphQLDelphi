unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdHTTP, IdSSLOpenSSL, Vcl.StdCtrls,
  System.JSON, RESTRequest4D;

type
  TfrmGraphQL = class(TForm)
    btnNativo: TButton;
    btnComponente: TButton;
    procedure btnNativoClick(Sender: TObject);
    procedure btnComponenteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGraphQL: TfrmGraphQL;

implementation

{$R *.dfm}

procedure TfrmGraphQL.btnNativoClick(Sender: TObject);
var
  IdHTTP: TIdHTTP;
  SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
  Response: string;
  JSON: TJSONObject;
  JsonToSend: TStringStream;
begin
  IdHTTP := TIdHTTP.Create(nil);
  SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  JSON := TJSONObject.Create;

  try
    with IdHTTP do
    begin
      SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create();
      SSLHandler.SSLOptions.SSLVersions :=
        [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
      IOHandler := SSLHandler;
      ConnectTimeout := 30000;
      HandleRedirects := True;
      AllowCookies := True;
      RedirectMaximum := 10;
      HTTPOptions := [hoKeepOrigProtocol];

      Request.Clear;
      Request.CustomHeaders.Clear;
      Request.UserAgent :=
        'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; Acoo Browser; GTB5; Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1) ; Maxthon; InfoPath.1; .NET CLR 3.5.30729; .NET CLR 3.0.30618)';
      Request.AcceptCharSet := 'UTF-8, *;q=0.8';
      Request.AcceptEncoding := 'gzip, deflate, br';
      Request.ContentType := 'application/json';
      Request.BasicAuthentication := False;
    end;

    JSON.AddPair('query', '{company{ceo}roadster{apoapsis_au}}');

    JsonToSend := TStringStream.Create(JSON.ToString);

    Response := IdHTTP.Post('https://spacex-production.up.railway.app/',
      JsonToSend);

    showmessage(Response);
  finally
    IdHTTP.Free;
    SSLHandler.Free;
    JSON.Free;
  end;
end;

procedure TfrmGraphQL.btnComponenteClick(Sender: TObject);
var
  JSON: TJSONObject;
  LResponse: IResponse;
  Lista: TStringList;
begin
  JSON := TJSONObject.Create;
  Lista := TStringList.Create;

  Lista.Add('ceo');
  Lista.Add('coo');

  JSON.AddPair('query', '{company{' + Lista.Text + '}roadster{apoapsis_au}}');

  LResponse := TRequest.New.BaseURL('https://spacex-production.up.railway.app/')
    .ContentType('application/json').AddBody(JSON).Post;

  showmessage(LResponse.Content);
end;

end.
