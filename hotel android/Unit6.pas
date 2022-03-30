unit Unit6;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls, FMX.DialogService,
  FMX.Controls.Presentation, FMX.Edit, FMX.Objects;

type
  TAltaCliente = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    Rectangle1: TRectangle;
    Label4: TLabel;
    SpeedButton3: TSpeedButton;
    Image3: TImage;
    procedure Button1Click(Sender: TObject);
    procedure ImportarIdentificador(id: String);
    function AltaEnCaliente(identificador: String): boolean;
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AltaCliente: TAltaCliente;
  identificador: string;
implementation

{$R *.fmx}
  uses
  Unit3;


procedure TAltaCliente.Button1Click(Sender: TObject);
var
identificador: String;
begin

identificador:= Edit1.Text;

  if (Edit1.Text <> '') and (Edit2.Text <> '') and (Edit3.Text <> '') then
    begin
     if not Tablas.MyTableClientes.Locate('identificador', identificador, []) then
     begin
        Tablas.MyTableClientes.Append;
        Tablas.MyTableClientesidentificador.Value := Edit1.Text;
        Tablas.MyTableClientesnombre.Value := Edit2.Text;
        Tablas.MyTableClientesapellidos.Value := Edit3.Text;
        //como estamos usando un edit normal (para hacerlo readonly) debemos introducir el dato a mano.
        Tablas.MyTableClientes.Post;
        showmessage('Nuevo cliente dado de alta.');
        AltaCliente.Close;
     end else
     begin
       showmessage('El identificador de cliente ya existe, por favor, introduzca otro.');
     end;

    end else
    begin
      showmessage('Por favor, rellena todos los campos');
    end;


end;


// para mostrar el id que hemos introducido desde el formulario

procedure TAltaCliente.ImportarIdentificador(id: String);
begin
    Edit1.Text := id;
    identificador := id;
end;



procedure TAltaCliente.SpeedButton3Click(Sender: TObject);
begin
  AltaCliente.Close;
end;

//se llama desde los formularios, se encarga de consultar si el id de cliente introducido al hacer una
//reserva existe, y si no, da la opción de crear uno nuevo (lo cual da paso a abrir este formulario)

function TAltaCliente.AltaEnCaliente(identificador: String): boolean;
var
seleccion: integer;
nombre: string;
apellidos: string;
begin
  nombre := '';
  apellidos := '';

  if not Tablas.MyTableClientes.Locate('identificador', identificador, []) then
    begin
      TDialogService.MessageDialog('No existe un cliente con el identificador especificado. ¿Desea crear un nuevo cliente?',
      TMsgDlgType.mtConfirmation, FMX.Dialogs.mbYesNo, TMsgDlgBtn.mbNo, 0,
              procedure(const AResult: TModalResult)
              begin
                if AResult = mrYes then
                 begin
                      //AltaCliente.Show;
                      seleccion := 1;
                      //AltaEnCaliente := true;
                       while nombre = '' do
                        begin

                        TDialogService.InputQuery( 'Please enter some info:', ['Info'], ['default-value'],
                          procedure (const AResult : TModalResult; const values: array of string)
                          begin
                            if AResult<>mrOk then begin
                              Exit;
                            end;
                            //- Perform success action here.
                          ShowMessage( Values[0] );
                          end
                         );


                          InputBox('Nombre del cliente:','Nombre','',
                          procedure(const AResult: TModalResult; const AValue: string)
                          begin
                            nombre := AValue;
                          end
                          );
                        end;

                       while apellidos = '' do
                        begin

                        InputBox('Apellidos del cliente:','Apellido','',
                          procedure(const AResult: TModalResult; const AValue: string)
                          begin
                            apellidos := AValue;
                          end
                          );
                        end;
                         Tablas.MyTableClientes.Append;
                          Tablas.MyTableClientesidentificador.Value := identificador;
                          Tablas.MyTableClientesnombre.Value := nombre;
                          Tablas.MyTableClientesapellidos.Value := apellidos;
                          //como estamos usando un edit normal (para hacerlo readonly) debemos introducir el dato a mano.
                          Tablas.MyTableClientes.Post;
                          showmessage('Nuevo cliente dado de alta.');


                 end;
                if AResult = mrNo then
                  begin
                      seleccion := 0;
                     //AltaEnCaliente := false;
                  end;


              end);
      if seleccion = 1 then  AltaEnCaliente := true;
      if seleccion = 0 then  AltaEnCaliente := false;



    {seleccion := messagedlg('No existe un cliente con el identificador especificado. ¿Desea crear un nuevo cliente?',mtConfirmation , mbOKCancel, 0);
    if seleccion = mrCancel then
       begin
         AltaEnCaliente := false;
      end;

    if seleccion = mrOK then
      begin
        Tablas.MyTableClientes.Append;
        AltaCliente.Show;
        AltaEnCaliente := true;
      end;
     }
    end
    else
    begin
       AltaEnCaliente := true;
    end;

end;




end.
