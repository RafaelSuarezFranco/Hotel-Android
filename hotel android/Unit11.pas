unit Unit11;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Objects, FMX.Controls.Presentation;

type
  TAltaServicio = class(TForm)
    Rectangle1: TRectangle;
    Label4: TLabel;
    SpeedButton3: TSpeedButton;
    Image3: TImage;
    Edit1: TEdit;
    Edit2: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AltaServicio: TAltaServicio;

implementation

{$R *.fmx}

uses
  Unit3;

procedure TAltaServicio.Button1Click(Sender: TObject);
var
n: double;
existe: integer;
begin
  existe := 0;


  if (Edit1.Text = '') or (Edit2.Text = '') then
  begin
     showmessage('Por favor, introduce los dos campos.');
  end else
  begin

    try
      n := strtofloat(Edit2.Text);



          Tablas.MyTableServicios.Filtered := true;
          Tablas.MyTableServicios.Filter:= 'nombreservicio='+quotedstr(Edit1.Text);
          existe  := Tablas.MyTableServicios.RecordCount;
          Tablas.MyTableServicios.Filtered := false;

     if existe > 0 then
        begin
          showmessage('Ya existe un servicio con ese nombre, por favor, escoge otro.');
        end;

      if existe = 0 then
        begin
            Tablas.MyTableServicios.Append;
            Tablas.MyTableServiciosnombreservicio.Value := Edit1.Text;
            Tablas.MyTableServiciosprecioservicio.Value := StrToFloat(Edit2.Text);
            Tablas.MyTableServicios.Post;
            AltaServicio.Close;
        end;



    except
       showmessage('Introduce un número en el precio, por favor.')
    end;
  end;


end;


end.
