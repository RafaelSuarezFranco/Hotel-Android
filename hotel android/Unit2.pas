unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.DateTimeCtrls,    System.DateUtils,
  FMX.ListBox, FMX.Edit, FMX.ComboEdit;

type
  TPantallaMes = class(TForm)
    Label2: TLabel;
    DateEdit1: TDateEdit;
    SpeedButton1: TSpeedButton;
    Image1: TImage;
    SpeedButton2: TSpeedButton;
    Image2: TImage;
    Label3: TLabel;
    ComboBox1: TComboBox;
    Panel1: TPanel;
    Label4: TLabel;
    Rectangle1: TRectangle;
    Label1: TLabel;
    SpeedButton3: TSpeedButton;
    Image3: TImage;
    procedure FormActivate(Sender: TObject);
    function DevolverDiasMes(): Integer;
    function DevolverDiaSemana(): Integer;
    procedure CargarMes();
    procedure PulsarBotonDia(Sender: TObject);
    procedure ActualizarColores2();
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure DateEdit1Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PantallaMes: TPantallaMes;
  HabitacionSeleccionada: Integer;
  FechaSeleccionada: TDate;
  diaSeleccionado: integer;
  PanelesDia: Array of TRectangle;
  //BotonesDia: Array of TButton;
  HabitacionesTodas: Array of Integer; //contiene los nº de habitaciones
  indiceHabitacion: integer;

  LongMonthNames : Array[1..12] of string;

implementation

{$R *.fmx}
  Uses
    Unit1, Unit3, Unit4;

procedure TPantallaMes.Button2Click(Sender: TObject);
var
i: integer;
begin
      {
      Panel1.DeleteChildren;
      //primero borrar el calendario
      if Length(PanelesDia) > 0 then
      begin
       for i := 0 to Length(PanelesDia)-1 do
          begin
          PanelesDia[i].Visible := false;
          end;
      end;
        }
end;

procedure TPantallaMes.FormActivate(Sender: TObject);
var
i: integer;
 cantidadHabitaciones: integer;
begin

  LongMonthNames[1] := 'Enero';
  LongMonthNames[2] := 'Febrero';
  LongMonthNames[3] := 'Marzo';
  LongMonthNames[4] := 'Abril';
  LongMonthNames[5] := 'Mayo';
  LongMonthNames[6] := 'Junio';
  LongMonthNames[7] := 'Julio';
  LongMonthNames[8] := 'Agosto';
  LongMonthNames[9] := 'Septiembre';
  LongMonthNames[10] := 'Octubre';
  LongMonthNames[11] := 'Noviembre';
  LongMonthNames[12] := 'Deciembre';

   Combobox1.OnChange := nil;
   //debo quitar y reasignar este procedure al onChange del combobox cada vez que se activa, por algún motivo, ese prodecimiento
   //estaba causando un access violation al crear el combobox.

   FechaSeleccionada := Principal.DevolverFechaSeleccionada;
   HabitacionSeleccionada := Principal.DevolverHabitacionSeleccionada;
   DateEdit1.Date := FechaSeleccionada;

//COMBO HABITACIONES
 // en este caso no vamos a llamar al generador de combos de Tablas porque queremos que al crearse se seleccione una habitación
 //concreta (aunque podríamos crearlo y luego seleccionarlo aquí haciendo otra búsqueda)

   i:=0;
    cantidadHabitaciones:= Tablas.MyTableHabitaciones.RecordCount;
    SetLength(Habitacionestodas, cantidadHabitaciones);

    Combobox1.Items.Clear;

    Tablas.MyTableHabitaciones.First;
      while not  Tablas.MyTableHabitaciones.Eof do
        begin
          Habitacionestodas[i]:= Tablas.MyTableHabitacionesnumero.Value;
          Combobox1.Items.Add(IntToStr(Tablas.MyTableHabitacionesnumero.Value));
          if HabitacionSeleccionada = Tablas.MyTableHabitacionesnumero.Value then
            begin
              Combobox1.ItemIndex := i; //seleccionamos el de la habitación actual
            end;

          i:=i+1;
          Tablas.MyTableHabitaciones.Next;
        end;
   Combobox1.OnChange := ComboBox1Change;
   cargarMes();
end;



function TPantallaMes.DevolverDiasMes(): Integer;
var
mes: integer;
mesnum: integer;
añonum: integer;
  begin
    mesnum:=MonthOfTheYear(FechaSeleccionada);
    añonum:=YearOf(FechaSeleccionada);

    mes:= DaysInAMonth(añonum, mesnum); //devuelve la cantidad de días de cierto mes.

    DevolverDiasMes := mes;
  end;


//en segundo lugar, qué día de la semana empieza el día 1.

procedure TPantallaMes.DateEdit1Change(Sender: TObject);
begin
FechaSeleccionada:= DateEdit1.Date;
CargarMes();
end;

function TPantallaMes.DevolverDiaSemana(): Integer;
var
dia: integer;
mesnum: integer;
añonum: integer;
begin
    mesnum:=MonthOfTheYear(FechaSeleccionada);
    añonum:=YearOf(FechaSeleccionada);
    dia:= DayOfTheWeek(EncodeDate(añonum, mesnum, 1));
    //devuelve el índice del día de semana (1 = lunes) del primer dia de mes
    //nos sirve para posicionar el primer dia en el calendario.
    DevolverDiaSemana := dia;
end;




//se encarga de borrar y crear los paneles del mes, de manera que queden ordenados y colocados como si se
//tratase de un calendario real

procedure TPantallaMes.CargarMes();
var

PanelDia: TRectangle;
LabelDia: TLabel;
i: integer;    //cantidad de dias
fila: integer;
cantidadDias: integer;
diasemana: integer;
dia: integer;

mes: string;
begin
  //esconder el panel y mostrarlo cuando termina de cargar parece que añade bastante velocidad de carga.
  panel1.visible := false;




      //primero borrar el calendario
      if Length(PanelesDia) > 0 then
      begin
       for i := 0 to Length(PanelesDia)-1 do
          begin
          PanelesDia[i].Free;
          end;
      end;

          Panel1.DeleteChildren;

    //creación de los días (paneles)
     dia:=1;
     i:= 1;
     fila := 0;
     diasemana:= DevolverDiaSemana - 1; //nos interesa que el lunes sea 0

     cantidadDias:= DevolverDiasMes();
     SetLength(PanelesDia, cantidadDias);



    for i:= 0 to (cantidadDias-1) do   //la cantidad de dias se especifica aquí
     begin
      if (diasemana mod 7 = 0) and (i <> 0) then
        begin
          fila:= fila + 1;
          diasemana := diasemana - 7;
        end;

        PanelDia:=TRectangle.create(self);
        PanelDia.Parent:=Panel1;
        PanelDia.Width := 50;
        PanelDia.Height := 50;
        PanelDia.Tag:=dia;
        PanelDia.position.Y:=fila*50;
        PanelDia.Position.X:=diasemana*50;

        //PanelDia.ParentBackground:= false;
        //PanelDia.StyleElements := [seBorder]; // esta línea hace que tarden en cargar bastante más.

        LabelDia:=TLabel.create(self);
        LabelDia.Parent:=PanelDia;
        LabelDia.Text:='Día '+Inttostr(dia);
        LabelDia.Position.Y:=5;
        LabelDia.Position.X:=5;
        LabelDia.StyledSettings := LabelDia.StyledSettings - [TStyledSetting.Size];
        LabelDia.TextSettings.Font.Size := 13;
        LabelDia.Height := 20;

        dia := dia + 1;
        diasemana:= diasemana +1;
        PanelesDia[i]:= PanelDia; //guardamos los paneles en un array global
        //BotonesDia[i]:=BotonDia;
    end;

    //en este caso, cada panel abre el formulario de administración de un día concreto
      for i := 0 to (Length(PanelesDia) - 1) do
      begin
         //BotonesDia[i].OnClick := PulsarBotonDia;
         PanelesDia[i].OnClick := PulsarBotonDia;
      end;

     DateEdit1.date := FechaSeleccionada;

     mes := LongMonthNames[MonthOfTheYear(FechaSeleccionada)];
     Label4.Text:= mes + ' ' + IntToStr(YearOf(FechaSeleccionada));
     ActualizarColores2();

   panel1.visible := true;
end;


procedure TPantallaMes.ComboBox1Change(Sender: TObject);
begin
 HabitacionSeleccionada:= StrToInt(Combobox1.Items[Combobox1.ItemIndex]);
 CargarMes();
end;

//click en el panel, abre el formulario diario

procedure TPantallaMes.PulsarBotonDia(Sender: TObject);
var
panel : TPanel;
boton : TButton;
begin
  panel := TPanel(Sender);
  diaSeleccionado := panel.Tag;


  FormularioDiario.dia:= diaSeleccionado;
  FormularioDiario.mes:= MonthOfTheYear(FechaSeleccionada);
  FormularioDiario.año:= YearOf(FechaSeleccionada);
  FormularioDiario.Habitacion := HabitacionSeleccionada;
  FormularioDiario.origen := 'pantallames';
  FormularioDiario.show();

end;




procedure TPantallaMes.SpeedButton1Click(Sender: TObject);
begin
FechaSeleccionada:= IncMonth(FechaSeleccionada, 1);
CargarMes();
end;

procedure TPantallaMes.SpeedButton2Click(Sender: TObject);
begin
FechaSeleccionada:= IncMonth(FechaSeleccionada, -1);
CargarMes();
end;

procedure TPantallaMes.SpeedButton3Click(Sender: TObject);
begin
 PantallaMes.Close;
end;

//pinta los paneles según las reservas, ocupaciones y temporadas

procedure TPantallaMes.ActualizarColores2();
var
i: integer;
fecha: TDate;
stringFecha: String;
mes: String;
dia: String;
año: String;
begin
   i:=0;
   fecha:=FechaSeleccionada;
   año:=  IntToStr(YearOf(fecha));
   mes:= IntToStr(MonthOfTheYear(fecha));
   if length(mes) < 2 then  //hay que formatear dias y meses para que tengan 2 dígitos
    mes:= '0'+ mes;

   //construimos el año y mes, pero el dia se lo vamos pasando uno a uno
   stringFecha := año+'-'+mes+'-';//+IntToStr(DayOfTheMonth(fecha));

    //ponemos todos en verde (habitaciones libres)
    for i := 0 to Length(PanelesDia)-1 do
    begin
      PanelesDia[i].Fill.Color:=TAlphaColorRec.Greenyellow;
    end;




    //COLOREAR TEMPORADAS

   for i := 0 to Length(PanelesDia)-1 do
     begin
      dia:= IntToStr(i+1);
        if length(dia) < 2 then
          dia:= '0'+ dia;

      //buscamos si la fecha se encuentra entre la fecha inicio y la fecha fin de algún registro
      Tablas.MyQuery1.Close;
      Tablas.MyQuery1.SQL.Text := 'select * from temporadas where fechainicio<='+quotedStr(stringFecha+dia)+' and fechafin>='+quotedStr(stringFecha+dia);
      Tablas.MyQuery1.Open;

     if Tablas.MyQuery1.Locate('nombretemporada', 'media', []) then
      begin
         PanelesDia[i].Fill.Color:=TAlphaColorRec.Green;
      end;

     if Tablas.MyQuery1.Locate('nombretemporada', 'alta', []) then
      begin
         PanelesDia[i].Fill.Color:=TAlphaColorRec.Darkgreen;
      end;


     end;


    // COLOREAR RESERVAS
    Tablas.MyQuery1.Close;
    Tablas.MyQuery1.SQL.Text := 'select * from entradas where estado='+quotedstr('reservada')+' and numerohabitacion='+quotedStr(IntToStr(HabitacionSeleccionada));
    Tablas.MyQuery1.Open;
    //Label1.text:=  quotedStr(stringFecha+'01');

   for i := 0 to Length(PanelesDia)-1 do
     begin
        dia:= IntToStr(i+1); //hay que formatear dias y meses para que tengan 2 dígitos
        if length(dia) < 2 then
         dia:= '0'+ dia;
      //Label1.Text:=  quotedStr(stringFecha+dia);
      if Tablas.MyQuery1.Locate('fecha', EncodeDate(StrToInt(año),StrToInt(mes),StrToInt(dia)), []) then
      //recorremos cada dia del mes para la habitacion seleccionada
       begin
         PanelesDia[i].Fill.Color:=TAlphaColorRec.Yellow;
       end;

     end;

     //COLOREAR OCUPACIONES
    Tablas.MyQuery1.Close;
    Tablas.MyQuery1.SQL.Text := 'select * from entradas where estado='+quotedstr('ocupada')+' and numerohabitacion='+quotedStr(IntToStr(HabitacionSeleccionada));
    Tablas.MyQuery1.Open;


   for i := 0 to Length(PanelesDia)-1 do
     begin
      dia:= IntToStr(i+1);
        if length(dia) < 2 then
          dia:= '0'+ dia;

      if Tablas.MyQuery1.Locate('fecha',  EncodeDate(StrToInt(año),StrToInt(mes),StrToInt(dia)), []) then //si la habitación esta ocupada para la habitacion seleccionada
      begin
         PanelesDia[i].Fill.Color:=TAlphaColorRec.Red;
      end;

     end;




end;




end.
