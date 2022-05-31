unit Unit9;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.Objects, IdTCPConnection,
  IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase,
  IdSMTP, IdComponent, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, IdBaseComponent, IdMessage;

type
  TLogin = class(TForm)
    Image1: TImage;
    Label8: TLabel;
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Login: TLogin;

implementation

{$R *.fmx}

uses
  Unit3, Unit1, Unit10;

procedure TLogin.Button1Click(Sender: TObject);
var
conNombreUsuario:boolean;
conCorreo:boolean;
usuarioValido:boolean;
password:string;

  //nota: el botón tiene default = true para que al pulsar enter, se ejecute lo mismo del botón.

begin
//comprobar si el usuario existe, ya sea por correo o nombre usuario.
conNombreUsuario := false;
conCorreo:= false;
usuarioValido:= false;
password := Tablas.passwordHash(Edit2.Text);


  Tablas.MyTableUsuarios.Filtered := true;
  Tablas.MyTableUsuarios.Filter := 'usuario='+quotedstr(Edit1.Text);
  if Tablas.MyTableUsuarios.RecordCount > 0 then
    begin
      conNombreUsuario := true;

      Tablas.MyTableUsuarios.First;
      while not Tablas.MyTableUsuarios.Eof do
        begin
          if Tablas.MyTableUsuariospassword.Value = password then
            begin
              usuarioValido := true;
              Tablas.perfil := Tablas.MyTableUsuariosperfil.Value;
              Tablas.cliente := Tablas.MyTableUsuarioscliente.Value;
              Tablas.usuario := Tablas.MyTableUsuarioscliente.Value;
            end;

          Tablas.MyTableUsuarios.next;
        end;
    end;

  Tablas.MyTableUsuarios.Filtered := false;

 Tablas.MyTableUsuarios.Filtered := true;
  Tablas.MyTableUsuarios.Filter := 'correo='+quotedstr(Edit1.Text);
  if Tablas.MyTableUsuarios.RecordCount > 0 then
    begin
      conCorreo := true;
      Tablas.MyTableUsuarios.First;
      while not Tablas.MyTableUsuarios.Eof do
        begin
        if Tablas.MyTableUsuariospassword.Value = password then
            begin
              usuarioValido := true;
              Tablas.perfil := Tablas.MyTableUsuariosperfil.Value;
              Tablas.cliente := Tablas.MyTableUsuarioscliente.Value;
              Tablas.usuario := Tablas.MyTableUsuarioscliente.Value;
            end;
          Tablas.MyTableUsuarios.next;
        end;
    end;

  Tablas.MyTableUsuarios.Filtered := false;


  if (conNombreUsuario = false) and (conCorreo = false) then
    begin
      showmessage('El correo u nombre de usuario introducido no está registrado.');
    end else
    begin
      Tablas.usuario := Edit1.Text;

      if not usuarioValido then showmessage('Contraseña incorrecta.');
    end;


   if usuarioValido then
    begin
      //showmessage('Acceso concedido.');
      //Login.Close;
      Principal.Show;
    end;

end;

procedure TLogin.Button2Click(Sender: TObject);
begin
  AltaUsuario.Show;
end;

procedure TLogin.FormActivate(Sender: TObject);
begin
    Tablas.passwordcorreo := '689196A338B739E5BDA0FB';
 //apertura de tablas
    Tablas.MyTableHabitaciones.Open;
    Tablas.MyTableEntradas.Open;
    Tablas.MyQuery1.Open;
    Tablas.MyTableTemporadas.Open;
    Tablas.MyTableServicios.Open;
    Tablas.MyTableEntradasservicios.Open;
    Tablas.MyTableClientes.Open;
    Tablas.MyTableHistoricoentradas.Open;
    Tablas.MyTableUsuarios.Open;


end;

end.
