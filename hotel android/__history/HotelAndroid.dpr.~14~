program HotelAndroid;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit1 in 'Unit1.pas' {Principal},
  Unit2 in 'Unit2.pas' {PantallaMes},
  Unit3 in 'Unit3.pas' {Tablas},
  Unit4 in 'Unit4.pas' {FormularioDiario},
  Unit5 in 'Unit5.pas' {FormularioPeriodo},
  Unit6 in 'Unit6.pas' {AltaCliente},
  Unit7 in 'Unit7.pas' {AltaHabitacion},
  Unit8 in 'Unit8.pas' {AltaTemporada},
  Unit9 in 'Unit9.pas' {Login},
  Unit10 in 'Unit10.pas' {AltaUsuario};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TLogin, Login);
  Application.CreateForm(TPrincipal, Principal);
  Application.CreateForm(TPantallaMes, PantallaMes);
  Application.CreateForm(TTablas, Tablas);
  Application.CreateForm(TFormularioDiario, FormularioDiario);
  Application.CreateForm(TFormularioPeriodo, FormularioPeriodo);
  Application.CreateForm(TAltaCliente, AltaCliente);
  Application.CreateForm(TAltaHabitacion, AltaHabitacion);
  Application.CreateForm(TAltaTemporada, AltaTemporada);
  Application.CreateForm(TAltaUsuario, AltaUsuario);
  Application.Run;
end.
