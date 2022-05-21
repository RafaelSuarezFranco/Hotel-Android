unit Unit4;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,  System.DateUtils,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,  FMX.DialogService,
  FMX.Edit, FMX.Layouts, FMX.Controls.Presentation, FMX.Objects;

type
  TFormularioDiario = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label33: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Label4: TLabel;
    Label5: TLabel;
    ScrollBox1: TScrollBox;
    Label66: TLabel;
    Edit1: TEdit;
    Label77: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    Label6: TLabel;
    Label7: TLabel;
    Label3: TLabel;
    Rectangle1: TRectangle;
    ScrollBox2: TScrollBox;
    Rectangle2: TRectangle;
    Label8: TLabel;
    SpeedButton3: TSpeedButton;
    Image3: TImage;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    function actualizarServicios(): Boolean;
    procedure borrarServicios();
    procedure RecalcularPrecio(Sender: TObject);
    procedure ActualizarPrecioTabla();
    procedure FormCreate(Sender: TObject);
    procedure AltaEnCaliente(identificador: String);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    dia: integer;
    mes: integer;
    año: integer;
    Habitacion: Integer;
    origen: string; //variable de control para saber si venimos de principal o pantallames. es importante
    //para controlar si debemos refrescar o no la pantallames, porque puede dar un invalid pointer si el origen
    //es la pantalla ppal (y no se ha inicializado la pantalla mes).
  end;

var
  FormularioDiario: TFormularioDiario;
  Estado: String;
  Fecha: TDate;
  //Habitacion: Integer;
  Cliente: String;
  Preciofinal: Double;
  fechabusqueda: String;
  PrecioBase: Double;
  TemporadaPrecio: Double;
  PrecioCalculado: Double;

  CheckboxServicios: Array of TCheckbox;
  NombresServicios: Array of String;
  ServiciosContratados: Array of Boolean;
  PreciosServicios: Array of Double;

  DiaPasado: Boolean;

  NuevoEstado: String;
  NuevoCliente: String;
implementation

{$R *.fmx}

uses
  Unit1, Unit2, Unit3, Unit6;

 //único botón del formulario, guardará los cambios realizados siempre y cuando sean válidos

procedure TFormularioDiario.Button1Click(Sender: TObject);
var
precio: double;
seleccion: integer;
accionRealizada: boolean;
accionCancelada: boolean;
serviciosCambiados: boolean;
clienteValido: boolean;
accionValida: boolean;

nombre: string;
apellidos: string;

begin
  accionRealizada:= false;
  clienteValido:= true;
  accionValida:= true;

  //en esta versión por algún motivo al aceptar el radiobutton se pone en libre, por lo que tengo que guardar el nuevo estado
  //preventivamente para no perderlo.
  NuevoEstado := '1';
  if RadioButton2.IsChecked then  NuevoEstado := '2';
  if RadioButton3.IsChecked then  NuevoEstado := '3';

  NuevoCliente := Edit1.Text;

 // ANULAR RESERVA (O BORRAR OCUPACIÓN) si vamos a liberar una habitacion, significa que vamos a borrar su registro
 // a la vez, copiaremos el registro en el historico de entradas
  if (RadioButton1.IsChecked) and (Estado <> 'libre') then
    begin
      accionCancelada:=false;
      // en primer lugar, si es una ocupación, solo podemos borrarla si es del día de hoy (o futura)
    if (Estado = 'ocupada') and (DiaPasado = true) then
     begin
          showmessage('No se puede borrar una ocupación que ya ha ocurrido en el pasado.')
     end else
     begin  //por el contrario, las reservas pasadas si se pueden anular (o marcar como ocupadas)

     TDialogService.MessageDialog('Vas a dejar libre una habitación que estaba reservada/ocupada. Esto borrará su registro y los correspondientes datos. ¿Estás seguro?',
      TMsgDlgType.mtConfirmation,
     FMX.Dialogs.mbYesNo, TMsgDlgBtn.mbNo, 0,
     procedure(const AResult: TModalResult)
      begin

        if AResult = mrYes then
         begin

         BorrarServicios;

         //en caso de que tengamos reserva y ocupación, habría que migrar los dos registros al histórico.
         Tablas.MyQuery1.Close;
         Tablas.MyQuery1.SQL.Text:= 'Select * from entradas where numerohabitacion='+IntToStr(Habitacion)+' and fecha = '+quotedStr(fechabusqueda);
         Tablas.MyQuery1.Open;

         Tablas.MyQuery1.First;
          while not Tablas.MyQuery1.Eof do
           begin       //añadir al histórico
              Tablas.MyTableHistoricoentradas.Append;
              Tablas.MyTableHistoricoentradasnumerohabitacion.value := Habitacion;
              Tablas.MyTableHistoricoentradasfecha.Value := Fecha;
              Tablas.MyTableHistoricoentradascliente.Value := Cliente;
              Tablas.MyTableHistoricoentradaspreciofinal.Value := PrecioFinal;
              Tablas.MyTableHistoricoentradasestado.Value := Tablas.MyQuery1.FieldByName('estado').AsString;
              Tablas.MyTableHistoricoentradas.Post;

              Tablas.MyQuery1.Next;
           end;


        //borrar de la tabla

         Tablas.MyTableEntradas.Filtered:=True;
         Tablas.MyTableEntradas.Filter:='numerohabitacion='+IntToStr(Habitacion);
         Tablas.MyTableEntradas.First;

        while not Tablas.MyTableEntradas.eof do
           begin
          //borramos las entradas de esta habitacion para esta fecha
          if Tablas.MyTableEntradasFecha.Value = Fecha then
            begin
            Tablas.MyTableEntradas.Delete;
            end
            else
            begin
              Tablas.MyTableEntradas.Next;
            end;

          end;
        ShowMessage('El registro de esta habitación para la fecha concreta ha sido borrado.');
        Tablas.MyTableEntradas.Filtered:=False;
        accionRealizada := true;
        FormularioDiario.Close;
        if origen = 'pantallames' then PantallaMes.cargarMes;
        end;
       if AResult = mrNo then
        begin
           ShowMessage('Acción cancelada.');
        end;

      end
     );
       {
      seleccion := messagedlg('Vas a dejar libre una habitación que estaba reservada/ocupada. Esto borrará su registro y los correspondientes datos. ¿Estás seguro?',System.UITypes.TMsgDlgType.mtWarning , mbOKCancel, 0);

      if seleccion = mrCancel then
      begin
       ShowMessage('Acción cancelada.');
      end;

       if seleccion = mrOK then
       begin

       BorrarServicios;

       //en caso de que tengamos reserva y ocupación, habría que migrar los dos registros al histórico.
       Tablas.MyQuery1.Close;
       Tablas.MyQuery1.SQL.Text:= 'Select * from entradas where numerohabitacion='+IntToStr(Habitacion)+' and fecha = '+quotedStr(fechabusqueda);
       Tablas.MyQuery1.Open;

       Tablas.MyQuery1.First;
       while not Tablas.MyQuery1.Eof do
        begin       //añadir al histórico
          Tablas.MyTableHistoricoentradas.Append;
          Tablas.MyTableHistoricoentradasnumerohabitacion.value := Habitacion;
          Tablas.MyTableHistoricoentradasfecha.Value := Fecha;
          Tablas.MyTableHistoricoentradascliente.Value := Cliente;
          Tablas.MyTableHistoricoentradaspreciofinal.Value := PrecioFinal;
          Tablas.MyTableHistoricoentradasestado.Value := Tablas.MyQuery1.FieldByName('estado').AsString;
          Tablas.MyTableHistoricoentradas.Post;

          Tablas.MyQuery1.Next;
        end;


        //borrar de la tabla

       Tablas.MyTableEntradas.Filtered:=True;
       Tablas.MyTableEntradas.Filter:='numerohabitacion='+IntToStr(Habitacion);
       Tablas.MyTableEntradas.First;

        while not Tablas.MyTableEntradas.eof do
         begin
          //borramos las entradas de esta habitacion para esta fecha
          if Tablas.MyTableEntradasFecha.Value = Fecha then
            begin
            Tablas.MyTableEntradas.Delete;
            end
            else
            begin
              Tablas.MyTableEntradas.Next;
            end;

          end;
        ShowMessage('El registro de esta habitación para la fecha concreta ha sido borrado.');
        Tablas.MyTableEntradas.Filtered:=False;
        accionRealizada := true;
       end;
        }
      end;

    end;





    // RESERVAR/0CUPAR UNA HABITACION QUE ESTABA LIBRE  (caso contrario al anterior)
    if (RadioButton1.IsChecked = false) and (Estado = 'libre') then
      begin
       //checkeamos que los necesarios estén rellenos
        if Edit1.Text = '' then
          begin
            Showmessage('El campo del cliente no puede estar vacío.');
            accionValida := false;
          end;



        if (RadioButton2.IsChecked) and (DiaPasado = True) then
          begin
            Showmessage('No se puede reservar en un día pasado');
            accionValida := false;
          end;

       //vamos a ser generosos y pensar que al usuario se le podría haber olvidado marcar una ocupación que ya ha pasado
       //con una semana de margen. Por tanto, solo podemos marcar de libre a ocupada si es hoy, o como mucho, hace 7 días
        if (RadioButton3.IsChecked) then
          begin
            if (Fecha > Now()) or (Fecha < IncDay(Now(), -8)) then
            begin
            Showmessage('Solo se puede marcar una habitación libre como ocupada en el día presente, o como muy tarde, con 7 días de retraso');
            accionValida := false;
            end;
          end;
        // esta condición no va en perjuicio de que cualquier reserva que quede en el pasado pueda ser marcada como libre u ocupada.

          if not Tablas.MyTableClientes.Locate('identificador', Edit1.Text, []) then
                begin
                  clienteValido := false;
                end else
                begin
                  clienteValido := true;
                end;

        if accionValida then
          begin






           if clienteValido = true then
            begin

             TDialogService.MessageDialog('¿Confirmar Reserva/ocupación?', TMsgDlgType.mtConfirmation,
              FMX.Dialogs.mbYesNo, TMsgDlgBtn.mbNo, 0,
              procedure(const AResult: TModalResult)
              begin
                if AResult = mrYes then
                 begin
                       try
                        precio:= strtofloat(Edit2.Text);

                        Tablas.MyTableEntradas.append;
                        Tablas.MyTableEntradasnumerohabitacion.Value := Habitacion;
                        Tablas.MyTableEntradasfecha.Value := Fecha;

                        if ( NuevoEstado = '2') then
                           begin
                          Tablas.MyTableEntradasestado.Value:= 'reservada';
                          end;

                        if  (NuevoEstado = '3') then
                           begin
                            Tablas.MyTableEntradasestado.Value:= 'ocupada';
                          end;

                        Tablas.MyTableEntradascliente.Value:= NuevoCliente;
                        PrecioFinal:= PrecioBase + TemporadaPrecio; //calcular el precio final con servicios, etc.
                        Tablas.MyTableEntradaspreciofinal.Value := precio; //el precio es lo que aparezca en el tedit,
                        // que de base es el precio final calculado, pero puede ser cambiado manualmente.

                        if precio < 0 then //si se intenta guardar el registro con precio menor o igual a 0
                          begin
                             showmessage('Error: El precio final no puede ser menor que 0');
                           end
                           else
                           begin
                             Tablas.MyTableEntradas.post;

                             accionRealizada:= True;
                              FormularioDiario.Close;
                              if origen = 'pantallames' then PantallaMes.cargarMes;
                           end;

                        except
                          showmessage('El precio debe ser de tipo numérico.');
                         end;
                  if AResult = mrNo then
                      begin
                         ShowMessage('Acción cancelada.');
                          accionCancelada := true;
                      end;
                  //mrYes: seleccion:=1;
                  //mrNo:  seleccion:=0;
                end;
              end);

            {seleccion := messagedlg('¿Confirmar Reserva (u ocupación)?',System.UITypes.TMsgDlgType.mtConfirmation , mbOKCancel, 0);

            if seleccion = 0 then
              begin
                ShowMessage('Acción cancelada.');
                accionCancelada := true;
              end;

            if seleccion = 1 then
              begin
                try
                precio:= strtofloat(Edit2.Text);

                Tablas.MyTableEntradas.append;
                Tablas.MyTableEntradasnumerohabitacion.Value := Habitacion;
                Tablas.MyTableEntradasfecha.Value := Fecha;

                if ( NuevoEstado = '2') then
                   begin
                  Tablas.MyTableEntradasestado.Value:= 'reservada';
                  end;

                if  (NuevoEstado = '3') then
                   begin
                    Tablas.MyTableEntradasestado.Value:= 'ocupada';
                  end;

                Tablas.MyTableEntradascliente.Value:= NuevoCliente;
                PrecioFinal:= PrecioBase + TemporadaPrecio; //calcular el precio final con servicios, etc.
                Tablas.MyTableEntradaspreciofinal.Value := precio; //el precio es lo que aparezca en el tedit,
                // que de base es el precio final calculado, pero puede ser cambiado manualmente.

                if precio < 0 then //si se intenta guardar el registro con precio menor o igual a 0
                  begin
                     showmessage('Error: El precio final no puede ser menor que 0');
                   end
                   else
                   begin
                     Tablas.MyTableEntradas.post;

                     accionRealizada:= True;
                   end;

                except
                  showmessage('El precio debe ser de tipo numérico.');
                 end;
              end;
              }
             end else
             begin
               showmessage('Por favor, introduce un identificador de un cliente existente.');
             end;

          end;

      end;

    //OCUPAR UNA HABITACION QUE ESTABA RESERVADA (¿hemos quedado en que crea un nuevo registro a parte del de la reserva?)
    //tambien hemos establecido que solo podemos pasar de reservada o ocupada si es hoy, o pasado.
    if (RadioButton3.IsChecked) and (Estado = 'reservada') and (Fecha < Now()) then
      begin
        try
           precio:= strtofloat(Edit2.Text);

          Tablas.MyTableEntradas.append;

          Tablas.MyTableEntradasnumerohabitacion.Value := Habitacion;
          Tablas.MyTableEntradasfecha.Value := Fecha;
          Tablas.MyTableEntradasestado.Value:= 'ocupada';

          Tablas.MyTableEntradascliente.Value:= Cliente; //usamos el cliente almacenado, en caso de que escribamos algo distinto.
          PrecioFinal:= PrecioBase + TemporadaPrecio; //calcular el precio final con servicios, etc.
          Tablas.MyTableEntradaspreciofinal.Value := precio;

          Tablas.MyTableEntradas.post;

          accionRealizada:= true;
        except
          showmessage('El campo precio debe ser un numérico.');
        end;
      end;
    if (RadioButton3.IsChecked) and (Estado = 'reservada') and (Fecha > Now()) then
      begin
         showmessage('No se puede marcar como ocupada una reserva que está en el futuro.  ');
      end;


    //PASAR DE OCUPACIÓN A RESERVA? no lo creo
    if (RadioButton2.IsChecked) and (Estado = 'ocupada') then
    begin
      showmessage('Estás intentado reservar una habitación ocupada. Si quieres reservar la habitación, libérala primero (Marca "libre")');
    end;


    //CAMBIAR SERVICIOS

    serviciosCambiados:= ActualizarServicios;
    if serviciosCambiados then accionRealizada := True;

    ActualizarPrecioTabla(); //siempre que pulsemos el boton, el precio se actualizará con lo que haya en el spinner

    if accionRealizada = True then
    begin
     //cerramos y actualizamos la pantalla del mes (y la principal, si hemos actualizado el día de hoy).
     FormularioDiario.Close;
     if origen = 'pantallames' then PantallaMes.cargarMes;
     Principal.cargarDia;
    end;


end;



//se encarga inicializar el formulario con los datos del registro pertienente, si lo hubiera.
//la idea de este formulario es jugar con el estado actual y compararlos con los cambios que se hagan en dicho
//formulario.

procedure TFormularioDiario.FormActivate(Sender: TObject);
var
i: integer;

diabusqueda: String;
mesbusqueda: String;

servicioCheck: TCheckbox;

begin


  Fecha:= EncodeDate(año, mes, dia); //Tdate del formulario

  if Fecha < IncDay(Now(), -1) then
  begin
    DiaPasado:= True;
  end else
  begin
    DiaPasado:= False;
  end;

  //borrar los checkboxs y recrearlos, puede dar errores si hay muchos y se crean más de la cuenta
    if Length(CheckboxServicios) > 0 then
      begin
       for i := 0 to Length(CheckboxServicios)-1 do
          begin
          CheckboxServicios[i].Visible := false;
          CheckboxServicios[i].Free;
          end;
      end;


  for i := (Scrollbox2.ChildrenCount - 1) downto 0 do
  begin
    Scrollbox2.Children[i].Free;
  end;


  diabusqueda := IntToStr(dia);
  mesbusqueda := IntToStr(mes);
  if length(diabusqueda) < 2 then
    diabusqueda:= '0'+ diabusqueda;
    if length(mesbusqueda) < 2 then
    mesbusqueda:= '0'+ mesbusqueda;
  fechabusqueda:= IntToStr(año)+'-'+mesbusqueda+'-'+diabusqueda;  //fecha formateada para buscarla con SQL

  //buscamos en la tabla con en nº y fecha seleccionados, con lo que vamos encontrando, vamos rellenando el formulario

  //la idea de este formulario es guardar el estado actual cuando se ejecuta el activate (en función de fecha y habitación seleccionada)
  //y luego al pulsar el botón, comparar ese estado con lo que se ha seleccionado en el formulario.
  Tablas.MyQuery1.Close;
  Tablas.MyQuery1.SQL.Text:= 'Select * from entradas where numerohabitacion='+IntToStr(Habitacion)+' and fecha = '+quotedStr(fechabusqueda);
  Tablas.MyQuery1.Open;

  Estado:= 'libre';
  Cliente:= '';

  Preciofinal:=Tablas.MyQuery1.FieldByName('preciofinal').AsFloat;

  if Tablas.MyQuery1.Locate('estado', 'reservada', []) then
    begin
    Estado := 'reservada';
    Cliente:= Tablas.MyQuery1.FieldByName('cliente').AsString;
    end;

   //si hay dos registros, uno de reserva y otro de ocupacion, consideramos el de ocupación
  if Tablas.MyQuery1.Locate('estado', 'ocupada', []) then
    begin
     Estado := 'ocupada';
      Cliente:= Tablas.MyQuery1.FieldByName('cliente').AsString;
    end;

    //sacamos el precio adicional por temporada
    TemporadaPrecio:=0; //por defecto es baja y no sumamos nada.
    Tablas.MyQuery1.Close;
    Tablas.MyQuery1.SQL.Text := 'select * from temporadas where fechainicio<='+quotedStr(fechabusqueda)+' and fechafin>='+quotedStr(fechabusqueda);
    Tablas.MyQuery1.Open;
      if Tablas.MyQuery1.Locate('nombretemporada', 'alta', []) then
      begin
         TemporadaPrecio:=Tablas.MyQuery1.FieldByName('precioadicional').AsFloat;
      end;
       if Tablas.MyQuery1.Locate('nombretemporada', 'media', []) then
      begin
         TemporadaPrecio:=Tablas.MyQuery1.FieldByName('precioadicional').AsFloat;
      end;

    if Estado = 'libre' then
    begin
      RadioButton1.IsChecked := true;
      ScrollBox1.Visible := False;
    end
    else
    begin
      ScrollBox1.Visible := True;
    end;

    if Estado = 'reservada' then
      RadioButton2.IsChecked := true;
    if Estado = 'ocupada' then
      RadioButton3.IsChecked := true;



    Label6.Text:= IntToStr(Habitacion);
    Label7.Text:= DateToStr(Fecha);
    Edit1.Text:=Cliente;


    //SERVICIOS

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
        servicioCheck.Parent:=ScrollBox2;

        servicioCheck.Tag:=i;
        servicioCheck.Position.Y:=i*40;//+50;
        servicioCheck.Position.X:=5;//15;
        servicioCheck.Text:=nombresServicios[i] + ' ('+FloatToStr(Tablas.MyTableServiciosprecioservicio.Value)+'€)';
        servicioCheck.Width:= 180;

        PreciosServicios[i] := Tablas.MyTableServiciosprecioservicio.Value;
        CheckboxServicios[i]:= servicioCheck;

        CheckboxServicios[i].OnClick := RecalcularPrecio;

        Tablas.MyTableServicios.Next;
        i:=i+1;
       end;


       //hay que checkear aquellos que tengan un registro en la tabla entradasservicios

      Tablas.MyQuery1.Close;
      Tablas.MyQuery1.SQL.Text := 'select * from entradasservicios where fecha='+quotedStr(fechabusqueda)+' and numerohabitacion='+IntToStr(Habitacion);
      Tablas.MyQuery1.Open;

       for i := 0 to Length(nombresServicios)-1 do
        begin
           if Tablas.MyQuery1.locate('nombreservicio', nombresServicios[i], []) then
            begin
               serviciosContratados[i]:=True;
               //los que tuvieran un registro (estaban contratados) aparecerán checkeados.
               CheckboxServicios[i].isChecked:=True;
            end
            else
            begin
               serviciosContratados[i]:=False;
            end;

        end;
      //de esta manera tenemos guardado el estado actual de los servicios, si cambiamos los checkbox, al salir, los
      //comparamos y sabemos cual tenemos que añadir o quitar de entradasservicios.




   //si la habitación estaba libre, mostramos su precio base de la tabla de habitaciones.

    Tablas.MyTableHabitaciones.Filtered:=True;
    Tablas.MyTableHabitaciones.Filter:= 'numero='+IntTostr(Habitacion);
    PrecioBase:=Tablas.MyTableHabitacionespreciobase.Value; //en cualquier caso nos interesa guardar el precio base de la habitación
    Tablas.MyTableHabitaciones.Filtered:=False;

    PrecioCalculado := PrecioBase + TemporadaPrecio;

    if Estado = 'libre' then
     begin
        Label3.Text:= FloatToStr(Round(PrecioCalculado*100)/100);
        edit2.Text := FloatToStr(Round(PrecioCalculado*100)/100);
        PrecioCalculado := PrecioBase + TemporadaPrecio;
     end
     else
     begin
        Label3.Text:=FloatToStr(PrecioFinal); //si no estaba libre, mostramos su precio final (que incluirá servicios o lo que hubiera)
        Label3.Text:= FloatToStr(Round(PrecioFinal*100)/100);
        edit2.Text := FloatToStr(Round(PrecioFinal*100)/100);
        PrecioCalculado := PrecioFinal;
     end;

end;







procedure TFormularioDiario.FormCreate(Sender: TObject);
begin

end;

//GESTIÓN DE SERVICIOS (borrarlos, crearlos)


//este procedimiento es exclusivo para cuando vamos a liberar una habitación,
// dado que hay que borrar todos sus servicios

procedure TFormularioDiario.BorrarServicios();
begin
  Tablas.MyTableEntradasservicios.Filtered:=True;
    Tablas.MyTableEntradasservicios.Filter:='numerohabitacion='+IntToStr(Habitacion);
    Tablas.MyTableEntradasservicios.First;
    while not Tablas.MyTableEntradasservicios.eof do
      begin
        if Tablas.MyTableEntradasserviciosfecha.Value = Fecha then
          begin
          //borramos los registros de esta habitación para la fecha concreta.
            Tablas.MyTableEntradasservicios.Delete;

          end
          else
          begin
          //esto hay que meterlo en un else porque si borra algo, se salta el siguiente
            Tablas.MyTableEntradasservicios.next;
          end;

      end;
    Tablas.MyTableEntradasservicios.Filtered:=False;

end;


//en cualquier otro caso, debemos comparar cada servicio cada vez que marcamos/desmarcamos algo

function TFormularioDiario.ActualizarServicios(): Boolean;
var  //PROBABLEMENTE HAY QUE PULIR LAS OPCIONES DE ESTA FUNCIÓN
i: integer;
servicioscambiados: boolean;
begin
  servicioscambiados:= false;
  //solo daremos de alta servicios si la habitación no va a estar libre. Es decir, si el radio botón está en libre, (se encarga el procedimiento anterior)
  //borramos los registros, en caso contrario, borramos o creamos dependiendo de cada caso.
if RadioButton1.IsChecked = false then
  begin
    for i := 0 to Length(CheckboxServicios)-1 do
      begin
        if serviciosContratados[i] <> CheckboxServicios[i].isChecked then //si lo que habia difiere de lo que el checkbox marca
           begin
             servicioscambiados := True;
            //caso 1: estaba contratado y vamos a borrarlo.
            if serviciosContratados[i] then
              begin

                 Tablas.MyTableEntradasservicios.Filtered:=True;
                 Tablas.MyTableEntradasservicios.Filter:='numerohabitacion='+IntToStr(Habitacion);
                 Tablas.MyTableEntradasservicios.First;
                  while not Tablas.MyTableEntradasservicios.eof do
                    begin
                      if (Tablas.MyTableEntradasserviciosfecha.Value = Fecha) and (Tablas.MyTableEntradasserviciosnombreservicio.Value = nombresServicios[i]) then
                        begin
                          Tablas.MyTableEntradasservicios.Delete; //borramos un registro con el nombre del servicio que queremos quitar.
                        end
                        else
                        begin
                          Tablas.MyTableEntradasservicios.next;
                        end;

                    end;
                  Tablas.MyTableEntradasservicios.Filtered:=False;

              end;
             //caso 2: no estaba contratado y vamos a darlo de alta.
            if not serviciosContratados[i] then
              begin
                Tablas.MyTableEntradasservicios.Append;
                Tablas.MyTableEntradasserviciosnumerohabitacion.Value := Habitacion;
                Tablas.MyTableEntradasserviciosfecha.Value := Fecha;
                Tablas.MyTableEntradasserviciosnombreservicio.Value := nombresServicios[i];
                Tablas.MyTableEntradasservicios.Post;
              end;

           end;
      end;

   if (RadioButton1.IsChecked = false) and (Estado = 'libre') and (Edit1.Text = '') then
      servicioscambiados:=false; //corrige un pequeño error por el cual si una habitacion libre se intenta
      //reservar con unos servicios pero no se mete el nombre de cliente, simplemente se guardan los servicios
      //(pero no se hace la reserva porque falta el cliente)

  end;
  ActualizarServicios := servicioscambiados;//devolvemos si hemos cambiado o no algo.

end;


//recalcula en caliente el precio final, si cambiamos los servicios seleccionados

procedure TFormularioDiario.RecalcularPrecio(Sender: TObject);
var
  i: integer;
 checkbox: TCheckbox;
begin
   checkbox := TCheckbox(Sender);
   i := checkbox.Tag;
   //si checkeamos un servicio, sumamos
   if  CheckboxServicios[i].isChecked = false then
    begin
      PrecioCalculado := PrecioCalculado + PreciosServicios[i];

      edit2.Text := FloatToStr(Round(PrecioCalculado*100)/100);
    end;
    //si desmarcamos un servicio, restamos
     if  CheckboxServicios[i].isChecked = true then
    begin
      PrecioCalculado := PrecioCalculado - PreciosServicios[i];

      edit2.Text := FloatToStr(Round(PrecioCalculado*100)/100);
    end;



end;



procedure TFormularioDiario.SpeedButton3Click(Sender: TObject);
begin
  FormularioDiario.Close;
end;

//permite hacer un update del precio, si una vez ocupado/reservado, queremos cambiarlo

procedure TFormularioDiario.ActualizarPrecioTabla();
var
precio: double;
begin
  try
    precio:= strtofloat(Edit2.Text);

  if precio <> Preciofinal then  //si hemos cambiado el precio de alguna manera, hay que actualizarlo.
   begin
   if precio >= 0 then //si se intenta guardar el registro con precio menor o igual a 0, no dejamos
      begin
        Tablas.MyTableEntradas.Filtered := True;
        Tablas.MyTableEntradas.Filter := 'numerohabitacion='+IntToStr(Habitacion);
        Tablas.MyTableEntradas.First;
        while not  Tablas.MyTableEntradas.eof do
          begin
            if Tablas.MyTableEntradasfecha.Value = Fecha then
              begin
                Tablas.MyTableEntradas.Edit;
                Tablas.MyTableEntradaspreciofinal.Value := precio;
                Tablas.MyTableEntradas.Post;
              end;

             Tablas.MyTableEntradas.Next;
          end;
        Tablas.MyTableEntradas.Filtered := False;
      end else
      begin
       showmessage('El precio no puede ser menor que 0');
      end;
   end;


  except
   showmessage('Error al actualizar precio. Por favor, no introduzcas datos no numéricos en el campo precio.');
  end;

end;







procedure TFormularioDiario.AltaEnCaliente(identificador: String) ;
var
seleccion: integer;
nombre: string;
apellidos: string;
begin
  nombre := '';
  apellidos := '';

  if not Tablas.MyTableClientes.Locate('identificador', identificador, []) then
    begin

              while nombre = '' do
                        begin

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
                          Tablas.MyTableClientesidentificador.Value := Edit1.Text;
                          Tablas.MyTableClientesnombre.Value := nombre;
                          Tablas.MyTableClientesapellidos.Value := apellidos;
                          //como estamos usando un edit normal (para hacerlo readonly) debemos introducir el dato a mano.
                          Tablas.MyTableClientes.Post;
                          showmessage('Nuevo cliente dado de alta.');




      //if seleccion = 1 then  AltaEnCaliente := true;
      //if seleccion = 0 then  AltaEnCaliente := false;



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
      // AltaEnCaliente := true;
    end;

end;



end.
