unit Unit8;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,   System.DateUtils,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.DateTimeCtrls, FMX.Edit,
  FMX.EditBox, FMX.SpinBox, FMX.Objects;

type
  TAltaTemporada = class(TForm)
    DateEdit1: TDateEdit;
    DateEdit2: TDateEdit;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    SpinBox1: TSpinBox;
    Label3: TLabel;
    Label4: TLabel;
    Rectangle1: TRectangle;
    Label5: TLabel;
    SpeedButton3: TSpeedButton;
    Image3: TImage;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AltaTemporada: TAltaTemporada;

implementation

{$R *.fmx}
uses
  Unit3;




//botón para confirmar la creación de temporada

procedure TAltaTemporada.Button1Click(Sender: TObject);
var
fechainicio: TDate;
fechafin: TDate;
nombre: string;
precio: double;

iteradorfecha: TDate;
stringFecha: String;

registroValido: boolean;

begin
  registroValido := true;

  fechainicio:= DateEdit1.Date;
  fechafin:= DateEdit2.Date;
  if RadioButton1.IsChecked = true then nombre := 'media';
  if RadioButton2.IsChecked = true then nombre := 'alta';
  precio := StrToFloat(SpinBox1.Text);

    //validaciones pertinentes

  if fechainicio > fechafin then
    begin
       showmessage('La fecha de inicio no puede ser mayor a la fecha de fin');
       registroValido := false;
    end;
     //comprobamos que el periodo indicado no se solapa con otro ya existente.

     //debemos ir dia por dia comprobando si alguno coincide dentro de alguna temporada.

    iteradorfecha:= fechainicio;
  if registroValido then
  begin


    while iteradorfecha <= fechafin do
      begin

        stringFecha := Tablas.formatearFechaSQL(iteradorfecha);

        Tablas.MyQuery1.Close;
        Tablas.MyQuery1.SQL.Text := 'select * from temporadas where fechainicio<='+quotedStr(stringFecha)+' and fechafin>='+quotedStr(stringFecha);
        Tablas.MyQuery1.Open;

        if Tablas.MyQuery1.RecordCount > 0 then registroValido:= false;


        iteradorfecha := IncDay(iteradorfecha, 1);
      end;

  end;

  //si la temporada es válida

  if registroValido then
    begin
      showmessage('Se ha creado la temporada.');
      Tablas.MyTableTemporadas.Append;
      Tablas.MyTableTemporadasfechainicio.Value := fechainicio;
      Tablas.MyTableTemporadasfechafin.Value := fechafin;
      Tablas.MyTableTemporadasnombretemporada.Value := nombre;
      Tablas.MyTableTemporadasprecioadicional.Value := precio;
      Tablas.MyTableTemporadas.Post;

      AltaTemporada.Close;
    end else
    begin
      showmessage('El periodo introducido se cruza con una temporada existente.');
    end;

end;



procedure TAltaTemporada.FormActivate(Sender: TObject);
begin
  DateEdit1.Date := Now();
  DateEdit2.Date := Now();
end;



procedure TAltaTemporada.SpeedButton3Click(Sender: TObject);
begin
   AltaTemporada.Close;
end;

end.