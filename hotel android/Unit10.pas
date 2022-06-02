unit Unit10;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,  System.Math,
  FMX.StdCtrls, FMX.Controls.Presentation,  IdSSLOpenSSL, IdMessage, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase,
   Data.DB,  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,       // Vcl.Mask,
 // IdSSLOpenSSL, IdMessage, IdBaseComponent, IdComponent, IdTCPConnection,
  IdSMTP, FMX.Edit
  ;

type
  TAltaUsuario = class(TForm)
    Rectangle1: TRectangle;
    Label4: TLabel;
    SpeedButton3: TSpeedButton;
    Image3: TImage;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IdMessage1: TIdMessage;
    IdSMTP1: TIdSMTP;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Button1: TButton;
    Edit8: TEdit;
    Label9: TLabel;
    Button2: TButton;
    procedure SpeedButton3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AltaUsuario: TAltaUsuario;

  codigoVerificacion : string;

implementation

{$R *.fmx}

uses
 Unit3;

procedure TAltaUsuario.Button1Click(Sender: TObject);
var
clienteValido: boolean;
clienteTieneUsuario: boolean; //no queremos que un cliente tenga varios usuarios.
registroValido: boolean;
correoValido: boolean;
crearNuevoCliente: boolean;

codigoInput: string;
begin

  registroValido := true;
  clienteValido := false;
  clienteTieneUsuario := false;
  crearNuevoCliente := false;

  Tablas.MyQuery1.Close;
  Tablas.MyQuery1.SQL.Text := 'select * from usuarios where cliente='+quotedstr(Edit3.Text);
  Tablas.MyQuery1.Open;

   if Tablas.MyQuery1.RecordCount > 0 then
    begin
      showmessage('El cliente especificado ya tiene un usuario en el sistema.');
      clienteTieneUsuario := true;
      registroValido := false;
    end;


  if (Edit1.Text = '') or (Edit2.Text = '') or (Edit3.Text = '') or
    (Edit6.Text = '') or (Edit7.Text = '') or (Edit8.Text = '') then
  begin
    showmessage('Por favor, rellena todos los campos');
    registroValido := false;
  end
  else
  begin

    //GESTION CLIENTE

    Tablas.MyQuery1.Close;
    Tablas.MyQuery1.SQL.Text := 'select * from clientes where identificador='+quotedstr(Edit3.Text);
    Tablas.MyQuery1.Open;

    if   Tablas.MyQuery1.RecordCount > 0 then //si existe el cliente, no queremos la info de nombre y apellido
      begin
        crearNuevoCliente := false;
        clienteValido := true;
      end else
      begin
        crearNuevoCliente := true;
          if (Edit4.Text = '') or (Edit5.Text = '') then
            begin
                showmessage('Por favor, rellene Nombre y Apellidos');
                registroValido := false;
            end else
            begin
                clienteValido := true;
            end;

      end;


  if(clienteTieneUsuario = false) then
    begin
     //si sabemos que no tiene usuario y que hemos introducido un cliente válido (ya sea creado o no) entonces seguimos.

    if (clienteValido = true) then
      begin

      //validar formato de correo.
        correoValido := Tablas.emailFormatoValido(Edit1.Text);
         if not correoValido then
          begin
            showmessage('El formato del correo no es válido.');
            registroValido := false;
          end;

      //validar si el correo o el usuario están repetidos.

        Tablas.MyQuery1.Close;
        Tablas.MyQuery1.SQL.Text := 'select * from usuarios where correo='+quotedstr(Edit1.Text);
        Tablas.MyQuery1.Open;

         if Tablas.MyQuery1.RecordCount > 0 then
          begin
            showmessage('Ya existe un usuario con el correo introducido.');
            registroValido := false;
          end;


        Tablas.MyQuery1.Close;
        Tablas.MyQuery1.SQL.Text := 'select * from usuarios where usuario='+quotedstr(Edit2.Text);
        Tablas.MyQuery1.Open;

         if Tablas.MyQuery1.RecordCount > 0 then
          begin
            showmessage('Ya existe un usuario con el nombre de usuario introducido.');
            registroValido := false;
          end;

      //comprobar que las contraseñas coinciden.
      if Edit6.Text <> Edit7.Text then
        begin
          showmessage('Las contraseñas no coinciden.');
          registroValido := false;
        end;

      end else
      begin
         registroValido := false;
      end;

    end else
    begin
       registroValido := false;
       showmessage('El cliente especificado ya tiene un usuario en el sistema.');
    end;
    {
    if Edit8.Text <> codigoVerificacion then
      begin
         registroValido := false;
         showmessage('El código de verificación no es correcto.');
         showmessage(codigoVerificacion);
      end;
         }

  end;

  if registroValido = true then
    begin
      Tablas.MyTableUsuarios.Append;
      Tablas.MyTableUsuarioscorreo.Value := Edit1.Text;
      Tablas.MyTableUsuariosusuario.Value := Edit2.Text;
      Tablas.MyTableUsuariospassword.Value := Tablas.passwordHash(Edit6.Text);
      Tablas.MyTableUsuarioscliente.Value := Edit3.Text;
      Tablas.MyTableUsuariosperfil.Value := 'cliente';
      Tablas.MyTableUsuarios.Post;


      if  crearNuevoCliente = true then
        begin
          Tablas.MyTableClientes.Append;
          Tablas.MyTableClientesidentificador.Value := Edit3.Text;
          Tablas.MyTableClientesnombre.Value := Edit4.Text;
          Tablas.MyTableClientesapellidos.Value := Edit5.Text;
          Tablas.MyTableClientes.Post;

          Showmessage('Cliente dado de alta.');
        end;

        Showmessage('Usuario creado con éxito.');

    end;


end;

procedure TAltaUsuario.Button2Click(Sender: TObject);
var
clienteValido: boolean;
clienteTieneUsuario: boolean;
registroValido: boolean;
correoValido: boolean;

codigoInput: string;
begin
  //Tablas.wwEmail(['mildoscientosveintisiete1227@gmail.com'], [], [], 'Codigo verificación Hotel RSF', 'Su código es:', '');

  IdMessage1.Clear;

// IO HANDLER SETTINGS //
  With IdSSLIOHandlerSocketOpenSSL1 do
  begin

    Destination := 'smtp.gmail.com:587';
    Host := 'smtp.gmail.com';
    //MaxLineAction := maException;
    Port := 587;
    SSLOptions.Method := sslvTLSv1;
    SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
    //SSLOptions.Method := sslvSSLv3;
    SSLOptions.Mode := sslmUnassigned;//sslmClient;
    SSLOptions.VerifyMode := [];
    SSLOptions.VerifyDepth := 0;
  end;
//SETTING SMTP COMPONENT DATA //

  IdSMTP1.Host := 'smtp.gmail.com';
  IdSMTP1.Port := 587;
  IdSMTP1.Username := 'hotelrafaelsuarezfranco@gmail.com';
  IdSMTP1.Password := Tablas.DesencriptarString(Tablas.passwordcorreo, 127);// 'hotelrsf127';
  IdSMTP1.IOHandler := IdSSLIOHandlerSocketOpenSSL1;
  //IdSMTP1.AuthType := satDefault;
IdSMTP1.UseTLS := utUseExplicitTLS;

  //validar formato de correo.
  correoValido := Tablas.emailFormatoValido(Edit1.Text);
  if not correoValido then
      begin
         showmessage('El formato del correo no es válido.');
         registroValido := false;
      end else
      begin
        registroValido := true;
      end;


  if registroValido then
    begin

          codigoVerificacion := inttostr(RandomRange(100000, 999999));

          IdMessage1.From.Address :=  'hotelrafaelsuarezfranco@gmail.com';
          IdMessage1.Recipients.EMailAddresses := Edit1.Text;
          IdMessage1.Subject := 'Confirmar cuenta de Hotel RSF';
          IdMessage1.Body.Text := 'Bienvenido al Hotel RSF. Su código de verificación es: '+codigoVerificacion;


          TRY
            IdSMTP1.Connect();
            IdSMTP1.Send(IdMessage1);
            ShowMessage('Se ha enviado el código al correo especificado.');


            IdSMTP1.Disconnect();
          except on e:Exception do
            begin
              ShowMessage(e.Message);
              IdSMTP1.Disconnect();
            end;
          END;


    end;


    if edit1.Text = '' then
      begin
          Showmessage('Para obtener el código de verificación, introduzca un correo válido y pulse "obtener código".');
      end;
end;



procedure TAltaUsuario.FormCreate(Sender: TObject);
begin
codigoVerificacion := 'xxxxxxxxxxxxxxxxx';
end;

procedure TAltaUsuario.SpeedButton3Click(Sender: TObject);
begin
  AltaUsuario.Close;
end;

end.
