unit Unit7;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.EditBox, FMX.SpinBox, FMX.Controls.Presentation, FMX.Edit, FMX.Objects;

type
  TAltaHabitacion = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    SpinBox1: TSpinBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    Rectangle1: TRectangle;
    Label4: TLabel;
    SpeedButton3: TSpeedButton;
    Image3: TImage;
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AltaHabitacion: TAltaHabitacion;

implementation

{$R *.fmx}
   uses
   Unit1, Unit3;



//bot?n para confirmar la creaci?n de la habitaci?n.

procedure TAltaHabitacion.Button1Click(Sender: TObject);
var
nhabitacion: integer;
precio: double;
registroValido: boolean;
begin
  registroValido:=true;

  nhabitacion:= strtoint(SpinBox1.Text);
  try

   //validaciones pertinentes

    precio:= strtofloat(Edit1.Text);
    if precio < 0 then
      begin
        showmessage('El precio no puede ser negativo.');
        registroValido := false;
      end;
    if edit2.Text = '' then
      begin
        registroValido := false;
        showmessage('Por favor, introduce un tipo de habitaci?n.')
      end;
    if nhabitacion < 1 then
      begin
         registroValido := false;
         showmessage('El n? de habitaci?n no deber?a ser negativo o cero.');
      end;
  except
    registroValido:=false;
    showmessage('El precio debe ser un dato num?rico.');
  end;

  if Tablas.MyTableHabitaciones.Locate('numero', nhabitacion, []) then
    begin
       registroValido:=false;
        showmessage('El n? de habitaci?n ya existe, por favor, escoge otro.');
    end;


  //una vez hemos comprobado que todo est? correcto, creamos el registro
  if registroValido then
    begin
      Tablas.MyTableHabitaciones.Append;
      Tablas.MyTableHabitacionesnumero.value := nhabitacion;
      Tablas.MyTableHabitacionestipo.Value := Edit2.Text;
      Tablas.MyTableHabitacionespreciobase.Value := precio;
      Tablas.MyTableHabitaciones.Post;
      showmessage('Se ha creado la nueva habitaci?n.');
      AltaHabitacion.Close;
      //refrescamos la pantalla principal para que se vea la nueva habitaci?n
      Principal.CargarDia;
    end;

end;


procedure TAltaHabitacion.SpeedButton3Click(Sender: TObject);
begin
   AltaHabitacion.Close;
end;

end.
