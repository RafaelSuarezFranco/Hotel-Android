unit Unit5;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.DateUtils,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,  FMX.DialogService,
  FMX.Layouts, FMX.Edit, FMX.ListBox, FMX.Controls.Presentation,
  FMX.DateTimeCtrls;

type
  TFormularioPeriodo = class(TForm)
    DateEdit1: TDateEdit;
    DateEdit2: TDateEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ComboBox1: TComboBox;
    Label4: TLabel;
    Edit1: TEdit;
    ScrollBox1: TScrollBox;
    Label5: TLabel;
    Button1: TButton;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ModoReserva();
    procedure ModoAnular();
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormularioPeriodo: TFormularioPeriodo;

  Estado: String;
  Fechafin: TDate;
  Fechaicion: TDate;
  Habitacion: Integer;
  Cliente: String;
  {
  Preciofinal: Double;
  fechabusqueda: String;
  PrecioBase: Double;
  TemporadaPrecio: Double;
  PrecioCalculado: Double;
   }
  CheckboxServicios: Array of TCheckbox;
  NombresServicios: Array of String;
  ServiciosContratados: Array of Boolean;
  PreciosServicios: Array of Double;

  ModoDeFormulario: String;
implementation

{$R *.fmx}


   uses Unit1, Unit2, Unit3, Unit6;



 //botón único del formulario, ya sea para reservar u anular

procedure TFormularioPeriodo.Button1Click(Sender: TObject);
var
camposValidos: boolean;
registroValido: boolean;
clienteValido: boolean;
fechaentrada: TDate;
PrecioBase: Double;
PrecioTemporada: Double;
PrecioFinal: Double;
PrecioServiciosTotal: Double;
fechabusqueda: String;
habitacion: integer;

fecha1: TDate;
fecha2: TDate;

seleccion: integer;
i: integer;
begin
   seleccion := -1;
   habitacion := StrToInt(ComboBox1.Items[Combobox1.ItemIndex]);
   camposValidos:= true;
   registroValido:= true;
   clienteValido := true;
   PrecioTemporada := 0;
   PrecioServiciosTotal := 0;

   fecha1:= IncDay(DateEdit1.Date, -1); //había un problema a la hora de comparar fechas, tuve que ampliar el marco por arriba y por abajo para que funcione correctamente.
   fecha2:= IncDay(DateEdit2.Date, 1);

   //validaciones pertinentes

   if DateEdit1.Date > DateEdit2.Date then
    begin
      showmessage('La fecha de inicio no puede ser mayor a la fecha de fin');
       camposValidos := false;
       registroValido := false;
    end;

    if DateEdit1.Date < IncDay(Now(), -1) then //esto impedirá reservar o anular fechas pasadas (podemos reservar anular de hoy en adelante).
    begin
       showmessage('Solo se pueden reservar/anular reservas para el día de hoy en adelante.');
       camposValidos := false;
       registroValido := false;
    end;


   if (Edit1.Text = '') and (ModoDeFormulario = 'reserva') then
    begin
       showmessage('El campo de cliente no puede estar vacío');
       camposValidos := false;
       registroValido := false;
    end;

    if (Edit1.Text <> '') and (ModoDeFormulario = 'reserva') and (camposValidos = true) then
    begin

      //AltaCliente.ImportarIdentificador(Edit1.Text); //preventivamente, mandamos el identificador al formulario.
      //clienteValido := AltaCliente.AltaEnCaliente(Edit1.Text); //abre el alta de cliente si no existe.
      if not Tablas.MyTableClientes.Locate('identificador', Edit1.Text, []) then
                begin
                  clienteValido := false;
                end else
                begin
                  clienteValido := true;
                end;

    end;


  if not clienteValido then
    begin
      showmessage('Por favor, introduzca un identificador de cliente existente.');
       camposValidos := false;
       registroValido := false;
    end;


   //MODO RESERVA

   if (camposValidos) and (ModoDeFormulario = 'reserva') then
   begin

    //showmessage('Los campos son válidos.');
    //una vez los datos son correctos, hay que comprobar que no hayan reservas hechas entre las fechas selecconadas para la habitación
    Tablas.MyTableEntradas.Filtered := True;
    Tablas.MyTableEntradas.Filter := 'numerohabitacion='+ComboBox1.Items[Combobox1.ItemIndex];
    Tablas.MyTableEntradas.First;


    while not Tablas.MyTableEntradas.eof do
      begin

      if (Tablas.MyTableEntradasfecha.Value > fecha1) and (Tablas.MyTableEntradasfecha.Value < fecha2) then
        begin
             registroValido:= false;  //si hay alguna fecha ya reservada/ocupada
              Showmessage('Hay reservas/ocupaciones en el periodo especificado.');
              Exit;
         end;


        Tablas.MyTableEntradas.Next;
      end;

    Tablas.MyTableEntradas.Filtered := False;

     //comprobar qué servicios vamos a dar de alta
    for i := 0 to Length(CheckboxServicios)-1 do
      begin
        if CheckboxServicios[i].isChecked then
          begin
            ServiciosContratados[i] := true;
            PrecioServiciosTotal:= PrecioServiciosTotal + PreciosServicios[i];
          end
          else
          begin
            ServiciosContratados[i] := false;
          end;
      end;

    if registroValido = false then
      begin
         showmessage('Hay reservas/ocupaciones en el periodo seleccionado');
      end
      else
      begin

          fechaentrada:= DateEdit1.Date;
          while fechaentrada < fecha2 do
            begin
              Tablas.MyTableEntradas.Append;
              Tablas.MyTableEntradasnumerohabitacion.Value := StrToInt(ComboBox1.Items[Combobox1.ItemIndex]);
              Tablas.MyTableEntradasfecha.Value := fechaentrada;
              Tablas.MyTableEntradasestado.Value := 'reservada';
              Tablas.MyTableEntradascliente.Value := Edit1.Text;

              //precio base
              Tablas.MyTableHabitaciones.Filtered:=True;
              Tablas.MyTableHabitaciones.Filter:= 'numero='+(ComboBox1.Items[Combobox1.ItemIndex]);
              PrecioBase := Tablas.MyTableHabitacionespreciobase.Value; //necesitamos calcular el precio día a día, por si cambia por la temporada.
              Tablas.MyTableHabitaciones.Filtered:=False;

              //precio temporada

              fechabusqueda:= Tablas.formatearFechaSQL(fechaentrada);

              Tablas.MyQuery1.Close;
              Tablas.MyQuery1.SQL.Text := 'select * from temporadas where fechainicio<='+quotedStr(fechabusqueda)+' and fechafin>='+quotedStr(fechabusqueda);
              Tablas.MyQuery1.Open;

              PrecioTemporada:=Tablas.MyQuery1.FieldByName('precioadicional').AsFloat;

              PrecioFinal := PrecioBase + PrecioTemporada + PrecioServiciosTotal;


              Tablas.MyTableEntradasPrecioFinal.Value := PrecioFinal;
              Tablas.MyTableEntradas.Post;

              //crear registros de los servicios (seguimos dentro de registroValido = true)
              for i := 0 to Length(ServiciosContratados)-1 do  //por cada dia, añadimos un registro por cada servicio marcado.
                begin
                  if ServiciosContratados[i] then
                    begin
                      Tablas.MyTableEntradasservicios.append;
                      Tablas.MyTableEntradasserviciosnumerohabitacion.Value := StrToInt(ComboBox1.Items[Combobox1.ItemIndex]);
                      Tablas.MyTableEntradasserviciosfecha.Value := fechaentrada;
                      Tablas.MyTableEntradasserviciosnombreservicio.Value := NombresServicios[i];
                      Tablas.MyTableEntradasservicios.post;
                    end;

                end;


              fechaentrada := IncDay(fechaentrada, 1); //incrementar la fecha para iterar el bucle
            end;


          showmessage('Se ha reservado con éxito el periodo especificado.');
      end;

   end;

   //MODO ANULAR RESERVA
 if (camposValidos) and (ModoDeFormulario = 'anular') then
   begin

      TDialogService.MessageDialog('¿Anular Reservas/ocupaciones en el periodo especificado?', TMsgDlgType.mtConfirmation,
      FMX.Dialogs.mbYesNo, TMsgDlgBtn.mbNo, 0,
      procedure(const AResult: TModalResult)
      begin
        if AResult = mrYes then
          begin

          Tablas.MyTableEntradas.Filtered := True;
          Tablas.MyTableEntradas.Filter := 'numerohabitacion='+inttostr(habitacion);

          Tablas.MyTableEntradas.First;

          while not Tablas.MyTableEntradas.eof do
                begin

                if (Tablas.MyTableEntradasfecha.Value > fecha1) and (Tablas.MyTableEntradasfecha.Value < fecha2) then
                       begin

                        Tablas.MyTableHistoricoentradas.Append;  //añadir al histórico
                        Tablas.MyTableHistoricoentradasnumerohabitacion.value := habitacion;
                        Tablas.MyTableHistoricoentradasfecha.Value := Tablas.MyTableEntradasfecha.Value;
                        Tablas.MyTableHistoricoentradascliente.Value := Tablas.MyTableEntradascliente.Value;
                        Tablas.MyTableHistoricoentradaspreciofinal.Value := Tablas.MyTableEntradaspreciofinal.Value;
                        Tablas.MyTableHistoricoentradasestado.Value := Tablas.MyTableEntradasestado.Value;
                        Tablas.MyTableHistoricoentradas.Post;


                        Tablas.MyTableEntradas.Delete;
                       end
                       else
                       begin
                        Tablas.MyTableEntradas.Next;
                       end;

                end;

          //borrar los servicios contratados
          Tablas.MyTableentradasservicios.Filtered:= True;
          Tablas.MyTableentradasservicios.Filter:= 'numerohabitacion='+inttostr(habitacion);
          Tablas.MyTableentradasservicios.First;
          while not Tablas.MyTableentradasservicios.eof do
            begin
               if (Tablas.MyTableentradasserviciosfecha.Value > fecha1) and (Tablas.MyTableentradasserviciosfecha.Value < fecha2) then
                begin   //si la fecha está dentro del periodo de anulación (para la habitación concreta)
                   Tablas.MyTableentradasservicios.Delete;
                end
                else
                begin
                   Tablas.MyTableentradasservicios.Next;
                end;
            end;

          Tablas.MyTableentradasservicios.Filtered:= false;


          Tablas.MyTableEntradas.Filtered := False;

          showmessage('Todas las reservas y ocupaciones del periodo especificado se han anulado');
          registroValido := true;
           FormularioPeriodo.Close;  //cerramos y refrescamos todo
          Principal.cargarDia;

          end;
        if AResult = mrNo then
          begin
             ShowMessage('Acción cancelada.');
              registroValido := false;
          end;



      end);


   end;

   if registroValido then
    begin
      FormularioPeriodo.Close;  //cerramos y refrescamos todo
      Principal.cargarDia;
    end;


end;



//parecido al formulario diario, creamos los servicios, creamos combo de habitaciones, etc

procedure TFormularioPeriodo.FormActivate(Sender: TObject);
var
i: integer;
cantidadHabitaciones: integer;
servicioCheck: TCheckbox;
begin

//hay algunos elementos que no hace falta mostrar si estamos en modo de anular reservas
  if ModoDeFormulario = 'reserva' then
    begin
      Label5.Visible := True;
      Scrollbox1.Visible := True;
      Label4.Visible := True;
      Edit1.Visible := True;
    end;
  if ModoDeFormulario = 'anular' then
    begin
      Label5.Visible := False;
      Scrollbox1.Visible := False;
      Label4.Visible := False;
      Edit1.Visible := False;
    end;



//COMBO HABITACIONES

  Combobox1 := Tablas.rellenarComboHabitaciones(Combobox1);

   DateEdit1.Date := Now; //resetear el formulario al dia de hoy, sin cliente especificado.
   DateEdit2.Date := Now;
   Edit1.Text:= '';


    //SERVICIOS

    //borrar preventivamente los checkbox para que no se repitan
    if Length(CheckboxServicios) > 0 then
      begin
       for i := 0 to Length(CheckboxServicios)-1 do
          begin
          CheckboxServicios[i].Visible := false;
          CheckboxServicios[i].Free;
          end;
      end;


      SetLength(CheckboxServicios, Tablas.MyTableServicios.RecordCount);
      SetLength(nombresServicios, Tablas.MyTableServicios.RecordCount);
      SetLength(serviciosContratados, Tablas.MyTableServicios.RecordCount);
      SetLength(PreciosServicios, Tablas.MyTableServicios.RecordCount);
    //crear checkboxs de servicios.
    i:=0;
    Tablas.MyTableServicios.First;
    while not Tablas.MyTableServicios.Eof do
       begin
        nombresServicios[i] := Tablas.MyTableServiciosnombreservicio.Value;

        servicioCheck:=TCheckbox.create(self);
        servicioCheck.Parent:=Scrollbox1;

        servicioCheck.Tag:=i;
        servicioCheck.Position.Y:=i*20+5;
        servicioCheck.Position.X:=5;
        servicioCheck.Text:=nombresServicios[i] + ' ('+FloatToStr(Tablas.MyTableServiciosprecioservicio.Value)+'€ al día)';
        servicioCheck.Width:= 250;
        PreciosServicios[i] := Tablas.MyTableServiciosprecioservicio.Value;
        CheckboxServicios[i]:= servicioCheck;


        Tablas.MyTableServicios.Next;
        i:=i+1;
       end;


    if ModoDeFormulario = 'anular' then Button1.Text:= 'Anular';
    if ModoDeFormulario = 'reserva' then Button1.Text:= 'Reservar';

end;



//altera el propósito de este formulario

procedure TFormularioPeriodo.ModoReserva();
begin
  ModoDeFormulario:= 'reserva';
end;

procedure TFormularioPeriodo.ModoAnular();
begin
  ModoDeFormulario:= 'anular';
end;




end.
