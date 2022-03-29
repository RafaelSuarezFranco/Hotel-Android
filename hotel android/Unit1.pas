unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
   FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Data.SqlExpr, FMX.DateTimeCtrls,  System.DateUtils,
  FMX.Layouts, FMX.Objects, FMX.MultiView;

type
  TPrincipal = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    ScrollBox1: TScrollBox;
    DateEdit1: TDateEdit;
    SpeedButton1: TSpeedButton;
    Image1: TImage;
    SpeedButton2: TSpeedButton;
    Image2: TImage;
    Button3: TButton;
    Button4: TButton;
    MultiView1: TMultiView;
    Layout1: TLayout;
    Rectangle1: TRectangle;
    Button5: TButton;
    SpeedButton3: TSpeedButton;
    Image3: TImage;
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure DateEdit1Change(Sender: TObject);
    procedure CargarDia();
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure CrearHabitaciones();
    procedure ActualizarColores();
    procedure PulsarBotonHabitacion(Sender: TObject);
    function DevolverFechaSeleccionada():TDate;
    function DevolverHabitacionSeleccionada():Integer;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  Principal: TPrincipal;

  HabitacionesBD: Array of Integer;
  PanelesHabitaciones: Array of TRectangle;
  BotonesHabitaciones:  Array of TButton;
  Fechaseleccionada: TDate;
  HabitacionSeleccionada: Integer;


implementation

{$R *.fmx}
{$R *.iPhone55in.fmx IOS}
  uses
    Unit2, Unit3, Unit5, Unit6, Unit7;


procedure TPrincipal.Button1Click(Sender: TObject);
begin
  FormularioPeriodo.ModoReserva;
  FormularioPeriodo.Show;
end;

procedure TPrincipal.Button2Click(Sender: TObject);
begin
  FormularioPeriodo.ModoAnular;
  FormularioPeriodo.Show;
end;

procedure TPrincipal.Button3Click(Sender: TObject);
begin
   AltaCliente.Show;
end;

procedure TPrincipal.Button4Click(Sender: TObject);
begin
   NuevaHabitacion.show;
end;

procedure TPrincipal.DateEdit1Change(Sender: TObject);
begin
   Fechaseleccionada := DateEdit1.Date;
   CargarDia();
end;

procedure TPrincipal.FormActivate(Sender: TObject);
begin
  Tablas.MyTableClientes.Open;
  Tablas.MyTableHabitaciones.Open;
  Tablas.MyTableEntradas.Open;
  Tablas.MyTableEntradasservicios.Open;
  Tablas.MyTableHistoricoentradas.Open;
  Tablas.MyTableTemporadas.Open;
  Tablas.MyTableServicios.Open;
  Tablas.MyQuery1.Open;

  Fechaseleccionada := Now();

  CrearHabitaciones();
end;


procedure TPrincipal.SpeedButton1Click(Sender: TObject);
begin
      FechaSeleccionada := IncDay(FechaSeleccionada, -1);
     CargarDia();
end;

procedure TPrincipal.SpeedButton2Click(Sender: TObject);
begin
    FechaSeleccionada := IncDay(FechaSeleccionada, 1);
     CargarDia();
end;

procedure TPrincipal.SpeedButton3Click(Sender: TObject);
begin
    MultiView1.ShowMaster;
end;

procedure TPrincipal.CargarDia();
begin
    DateEdit1.Date := FechaSeleccionada;
    ActualizarColores();
end;

procedure TPrincipal.CrearHabitaciones();
var
PanelHabitacion : TRectangle;
BotonHabitacion : TButton;
LabelHabitacion : TLabel;
fila: integer;
columna: integer;
i: integer;
cantidadHabitaciones: integer;
begin
   cantidadHabitaciones:= Tablas.MyTableHabitaciones.RecordCount;  //esta variable recogera la cantidad de habitaciones de la bbdd
   SetLength(HabitacionesBD, cantidadHabitaciones);
   SetLength(BotonesHabitaciones, cantidadHabitaciones);
   SetLength(PanelesHabitaciones, cantidadHabitaciones);

     //primero borrar los paneles, vaciar el array.
  if Length(PanelesHabitaciones) > 0 then
      begin
       for i := 0 to Length(PanelesHabitaciones)-1 do
          begin
          PanelesHabitaciones[i].Free;
          end;
      end;

   //guardar los n� de habitaciones
    i:=0;


    Tablas.MyTableHabitaciones.First;

      while not Tablas.MyTableHabitaciones.Eof do //guardamos los numero de habitacion para ponerselo a los paneles y botones
        begin
          HabitacionesBD[i]:= Tablas.MyTableHabitacionesnumero.Value;
          i:=i+1;
          Tablas.MyTableHabitaciones.Next;
        end;


     //creaci�n de las habitaciones
     i:= 1;
     columna := 1;
     fila := 0;


    for i:=0 to (cantidadHabitaciones-1) do   //la cantidad de habitaciones se especifica aqu�
     begin
      if (i mod 2 = 0) and (i <> 0) then
        begin
          fila:= fila + 1;
          columna:= 1 ;
        end;

        PanelHabitacion:=TRectangle.create(self);
        PanelHabitacion.Parent:=ScrollBox1;
        PanelHabitacion.Width := 110;
        PanelHabitacion.Height := 110;
        PanelHabitacion.Tag:=HabitacionesBD[i];
        PanelHabitacion.Position.Y:=fila*110;
        PanelHabitacion.Position.X:=columna;
        //PanelHabitacion.Caption:='Habitaci�n'+Inttostr(HabitacionesBD[i]);
        //PanelHabitacion.ParentBackground:=false;
        PanelHabitacion.Fill.Color:=TAlphaColorRec.Greenyellow;

        LabelHabitacion:=TLabel.create(self);
        LabelHabitacion.Parent:=PanelHabitacion;
        LabelHabitacion.Text:='Habitaci�n '+IntToStr(HabitacionesBD[i]);
        LabelHabitacion.Position.Y:=5;
        LabelHabitacion.Position.X:=5;
        LabelHabitacion.StyledSettings := LabelHabitacion.StyledSettings - [TStyledSetting.Size];
        LabelHabitacion.TextSettings.Font.Size := 14;
        LabelHabitacion.Height := 30;

        BotonHabitacion:=TButton.create(self);
        BotonHabitacion.Parent:=PanelHabitacion;
        BotonHabitacion.Position.Y:=60;
        BotonHabitacion.Tag:=HabitacionesBD[i];
        BotonHabitacion.Position.X:=0;
        BotonHabitacion.Width:=110;
        BotonHabitacion.Height:=50;
        BotonHabitacion.Text:='Abrir mes';

        columna := columna + 110;
        PanelesHabitaciones[i]:= PanelHabitacion;
        BotonesHabitaciones[i]:=BotonHabitacion;
    end ;

    //cada bot�n abrir� la pantalla mes con la habitaci�n seleccionada
    for i := 0 to (Length(BotonesHabitaciones) - 1) do
      begin
         BotonesHabitaciones[i].OnClick := PulsarBotonHabitacion;
      end;

  cargarDia();
end;


procedure TPrincipal.PulsarBotonHabitacion(Sender: TObject);
var
boton : TButton;
begin
  boton := TButton(Sender);
  HabitacionSeleccionada := boton.Tag;
  PantallaMes.show();
end;



procedure TPrincipal.ActualizarColores();
var
i: integer;
fecha: TDate;
stringFecha: String;
begin
   i:=0;
   fecha:=FechaSeleccionada;
   stringFecha := IntToStr(YearOf(fecha))+'-'+IntToStr(MonthOfTheYear(fecha))+'-'+IntToStr(DayOfTheMonth(fecha));//hay que formatear la fecha

    //ponemos todos en verde (habitaciones libres)
    for i := 0 to Length(PanelesHabitaciones)-1 do
    begin
      PanelesHabitaciones[i].Fill.Color:=TAlphaColorRec.Greenyellow;
    end;



    // COLOREAR RESERVAS
    Tablas.MyQuery1.Close;
    Tablas.MyQuery1.SQL.Text := 'select * from entradas where estado='+quotedstr('reservada')+' and fecha='+quotedStr(stringFecha);
    Tablas.MyQuery1.Open;

   for i := 0 to Length(HabitacionesBD)-1 do
     begin
      if Tablas.MyQuery1.Locate('numerohabitacion', HabitacionesBD[i], []) then //si la habitaci�n esta reservada para la fecha seleccionada
       begin
         PanelesHabitaciones[i].Fill.Color:=TAlphaColorRec.Yellow;
       end;

     end;

     //COLOREAR OCUPACIONES
    Tablas.MyQuery1.Close;
    Tablas.MyQuery1.SQL.Text := 'select * from entradas where estado='+quotedstr('ocupada')+' and fecha='+quotedStr(stringFecha);
    Tablas.MyQuery1.Open;


   for i := 0 to Length(HabitacionesBD)-1 do
     begin
      if Tablas.MyQuery1.Locate('numerohabitacion', HabitacionesBD[i], []) then //si la habitaci�n esta reservada para la fecha seleccionada
      begin
         PanelesHabitaciones[i].Fill.Color:=TAlphaColorRec.Red;
      end;

     end;

end;


//usamos estas funciones para pasar la habitacion y fecha al otro form (pantalla mes)

function TPrincipal.DevolverFechaSeleccionada(): TDate;
begin
    DevolverFechaSeleccionada := FechaSeleccionada;
end;

function TPrincipal.DevolverHabitacionSeleccionada(): Integer;
begin
    DevolverHabitacionSeleccionada := HabitacionSeleccionada;
end;


end.