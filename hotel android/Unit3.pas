unit Unit3;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Data.DB,  System.DateUtils,
  MyAccess, MemDS, DBAccess, FMX.ListBox, FMX.Controls.Presentation,
 //  FireDAC.Comp.Client, Vcl.StdCtrls,
 IdGlobal, IdHash, System.RegularExpressions,  IdHashMessageDigest,
  //Androidapi.JNI.GraphicsContentViewText, Androidapi.JNIBridge, Androidapi.JNI.JavaTypes, FMX.Helpers.Android, Androidapi.JNI.Net, Androidapi.JNI.Os, Androidapi.IOUtils,
{  Androidapi.JNI.GraphicsContentViewText,
   Androidapi.JNI.App,
   Androidapi.JNIBridge,
   Androidapi.JNI.JavaTypes,
   Androidapi.Helpers,
   Androidapi.JNI.Net,
   Androidapi.JNI.Os,
   Androidapi.IOUtils,  }
  FMX.StdCtrls;

type
  TTablas = class(TForm)
    MyConnection12: TMyConnection;
    MyTableClientes: TMyTable;
    MyTableClientesid: TIntegerField;
    MyTableClientesidentificador: TStringField;
    MyTableClientesnombre: TStringField;
    MyTableClientesapellidos: TStringField;
    MyTableEntradas: TMyTable;
    MyTableEntradasservicios: TMyTable;
    MyTableHabitaciones: TMyTable;
    MyTableHistoricoentradas: TMyTable;
    MyTableServicios: TMyTable;
    MyTableTemporadas: TMyTable;
    MyQuery1: TMyQuery;
    MyTableEntradasid: TIntegerField;
    MyTableEntradasnumerohabitacion: TIntegerField;
    MyTableEntradasfecha: TDateField;
    MyTableEntradasestado: TStringField;
    MyTableEntradascliente: TStringField;
    MyTableEntradaspreciofinal: TFloatField;
    MyTableEntradasserviciosid: TIntegerField;
    MyTableEntradasserviciosnumerohabitacion: TIntegerField;
    MyTableEntradasserviciosfecha: TDateField;
    MyTableEntradasserviciosnombreservicio: TStringField;
    MyTableHabitacionesid: TIntegerField;
    MyTableHabitacionesnumero: TIntegerField;
    MyTableHabitacionestipo: TStringField;
    MyTableHabitacionespreciobase: TFloatField;
    MyTableHistoricoentradasid: TIntegerField;
    MyTableHistoricoentradasnumerohabitacion: TIntegerField;
    MyTableHistoricoentradasfecha: TDateField;
    MyTableHistoricoentradascliente: TStringField;
    MyTableHistoricoentradaspreciofinal: TFloatField;
    MyTableHistoricoentradasestado: TStringField;
    MyTableServiciosid: TIntegerField;
    MyTableServiciosnombreservicio: TStringField;
    MyTableServiciosprecioservicio: TFloatField;
    MyTableTemporadasid: TIntegerField;
    MyTableTemporadasfechainicio: TDateField;
    MyTableTemporadasfechafin: TDateField;
    MyTableTemporadasnombretemporada: TStringField;
    MyTableTemporadasprecioadicional: TFloatField;
    MyConnection1: TMyConnection;
    Label1: TLabel;
    Label2: TLabel;
    MyTableUsuarios: TMyTable;
    MyTableUsuariosid: TIntegerField;
    MyTableUsuariosusuario: TStringField;
    MyTableUsuarioscorreo: TStringField;
    MyTableUsuarioscliente: TStringField;
    MyTableUsuariosperfil: TStringField;
    MyTableUsuariospassword: TStringField;
    function formatearFechaSQL(fecha: TDate): String;
    function rellenarComboHabitaciones(combo: TCombobox):TComboBox;
    function passwordHash(password: String): String;
    function IsMatch(const Input, Pattern: string): boolean;
    function emailFormatoValido(const EmailAddress: string): boolean;
    function EncriptarString(const S :String; Key: Word): String;
    function DesencriptarString(const S: String; Key: Word): String;
  //  function CreateEmail(const Recipient, Subject, Content, Attachment: string);
  {procedure wwEmail(
   const Recipients: Array of String;
   const ccRecipients: Array of String;
   const bccRecipients: Array of String;
   Subject, Content,
   AttachmentPath: string;
   mimeTypeStr: string = ''); //; Protocol: TwwMailProtocol=TwwMailProtocol.Ole);  }
  private
    { Private declarations }
  public
    { Public declarations }

  //datos del usuario logeado.
    perfil: string;
    cliente: string;
    usuario: string;
    passwordcorreo: string;
  end;

var
  Tablas: TTablas;

implementation

{$R *.fmx}


//formatea una fecha de tipo TDate a una String que se pueda usar en las FDQueries.

function TTablas.formatearFechaSQL(fecha: TDate): String;
  var
  diabusqueda: String;
  mesbusqueda: String;
  fechabusqueda: String;
begin
    diabusqueda := IntToStr(DayOfTheMonth(fecha));
    mesbusqueda := IntToStr(MonthOfTheYear(fecha));
    if length(diabusqueda) < 2 then
        diabusqueda:= '0'+ diabusqueda;
    if length(mesbusqueda) < 2 then
        mesbusqueda:= '0'+ mesbusqueda;
    fechabusqueda:= IntToStr(YearOf(fecha))+'-'+mesbusqueda+'-'+diabusqueda;  //fecha formateada para buscarla con SQL

    formatearFechaSQL := fechabusqueda;
end;



//recibe un combobox a rellenar, lo vacía y lo rellena con los números de habitación.

function TTablas.rellenarComboHabitaciones(combo: TComboBox):TComboBox;
  var
cantidadHabitaciones: integer;
i : integer;
begin
    i:=0;
    cantidadHabitaciones:= Tablas.MyTableHabitaciones.RecordCount;

    combo.Items.Clear; //vaciar el combobox para rellenarlo con las habitaciones
    Tablas.MyTableHabitaciones.First;
      while not  Tablas.MyTableHabitaciones.Eof do
        begin
          combo.Items.Add(IntToStr(Tablas.MyTableHabitacionesnumero.Value));
          i:=i+1;
          Tablas.MyTableHabitaciones.Next;
        end;

    //combo.Style := csDropDownList; //readonly
    combo.ItemIndex := 0; //selecciona el primero

    rellenarComboHabitaciones := combo;
end;

 //convierte una cadena en un hash MD5

function TTablas.passwordHash(password: String): String;
var
    hashString : TIdHashMessageDigest5;
begin
 hashString  := nil;
    try
        hashString  := TIdHashMessageDigest5.Create;
        passwordHash := IdGlobal.IndyLowerCase ( hashString .HashStringAsHex ( password ) );
    finally
        hashString.Free;
    end;
end;








//validar el formato de un correo
function TTablas.IsMatch(const Input, Pattern: string): boolean;
begin
  Result := TRegEx.IsMatch(Input, Pattern);
end;


function TTablas.emailFormatoValido(const EmailAddress: string): boolean;
const
  EMAIL_REGEX = '^((?>[a-zA-Z\d!#$%&''*+\-/=?^_`{|}~]+\x20*|"((?=[\x01-\x7f])'
             +'[^"\\]|\\[\x01-\x7f])*"\x20*)*(?<angle><))?((?!\.)'
             +'(?>\.?[a-zA-Z\d!#$%&''*+\-/=?^_`{|}~]+)+|"((?=[\x01-\x7f])'
             +'[^"\\]|\\[\x01-\x7f])*")@(((?!-)[a-zA-Z\d\-]+(?<!-)\.)+[a-zA-Z]'
             +'{2,}|\[(((?(?<!\[)\.)(25[0-5]|2[0-4]\d|[01]?\d?\d))'
             +'{4}|[a-zA-Z\d\-]*[a-zA-Z\d]:((?=[\x01-\x7f])[^\\\[\]]|\\'
             +'[\x01-\x7f])+)\])(?(angle)>)$';
begin
  Result := IsMatch(EmailAddress, EMAIL_REGEX);
end;




//encriptar y desencriptar strings
const CKEY1 = 53761;
      CKEY2 = 32618;

function TTablas.EncriptarString(const S :String; Key: Word): String;
var   i          :Integer;
      RStr       :RawByteString;
      RStrB      :TBytes Absolute RStr;
begin
  Result:= '';
  RStr:= UTF8Encode(S);
  for i := 0 to Length(RStr)-1 do begin
    RStrB[i] := RStrB[i] xor (Key shr 8);
    Key := (RStrB[i] + Key) * CKEY1 + CKEY2;
  end;
  for i := 0 to Length(RStr)-1 do begin
    Result:= Result + IntToHex(RStrB[i], 2);
  end;
end;

function TTablas.DesencriptarString(const S: String; Key: Word): String;
var   i, tmpKey  :Integer;
      RStr       :RawByteString;
      RStrB      :TBytes Absolute RStr;
      tmpStr     :string;
begin
  tmpStr:= UpperCase(S);
  SetLength(RStr, Length(tmpStr) div 2);
  i:= 1;
  try
    while (i < Length(tmpStr)) do begin
      RStrB[i div 2]:= StrToInt('$' + tmpStr[i] + tmpStr[i+1]);
      Inc(i, 2);
    end;
  except
    Result:= '';
    Exit;
  end;
  for i := 0 to Length(RStr)-1 do begin
    tmpKey:= RStrB[i];
    RStrB[i] := RStrB[i] xor (Key shr 8);
    Key := (tmpKey + Key) * CKEY1 + CKEY2;
  end;
  Result:= UTF8Decode(RStr);
end;



 {
function TTablas.CreateEmail(const Recipient, Subject, Content,
 Attachment: string);
var
 Intent: JIntent;
 Uri: Jnet_Uri;
 AttachmentFile: JFile;
begin
 Intent := TJIntent.Create;
 Intent.setAction(TJIntent.JavaClass.ACTION_SEND);
 Intent.setFlags(TJIntent.JavaClass.FLAG_ACTIVITY_NEW_TASK);
 Intent.putExtra(TJIntent.JavaClass.EXTRA_EMAIL, (Recipient));
 Intent.putExtra(TJIntent.JavaClass.EXTRA_SUBJECT, (Subject));
 Intent.putExtra(TJIntent.JavaClass.EXTRA_TEXT, (Content));



 Intent.putExtra(TJIntent.JavaClass.EXTRA_STREAM,
   TJParcelable.Wrap((Uri as ILocalObject).GetObjectID));

 Intent.setType(('vnd.android.cursor.dir/email'));

 //SharedActivity.startActivity(Intent);
end;

 //CreateEmail('xxx@shaw.ca', 'Test Results', Memo1.Lines.text,'/sdcard/Download/Demo.pdf');

      }
         {
procedure TTablas.wwEmail(
   const Recipients: Array of String;
   const ccRecipients: Array of String;
   const bccRecipients: Array of String;
   subject, Content, AttachmentPath: string;
   mimeTypeStr: string = ''); //; Protocol: TwwMailProtocol=TwwMailProtocol.ole);
var
  Intent: JIntent;
  Uri: Jnet_Uri;
  AttachmentFile: JFile;
  i: integer;
  emailAddresses: TJavaObjectArray<JString>;
  ccAddresses: TJavaObjectArray<JString>;
  fileNameTemp: JString;
  CacheName: string;
  IntentChooser: JIntent;
  ChooserCaption: string;
begin
  Intent := TJIntent.Create;
  Intent.setAction(TJIntent.JavaClass.ACTION_Send);
  Intent.setFlags(TJIntent.JavaClass.FLAG_ACTIVITY_NEW_TASK);

  emailAddresses := TJavaObjectArray<JString>.Create(length(Recipients));
  for i := Low(Recipients) to High(Recipients) do
    emailAddresses.Items[i] := StringToJString(Recipients[i]);

  ccAddresses := TJavaObjectArray<JString>.Create(length(ccRecipients));
  for i := Low(ccRecipients) to High(ccRecipients) do
    ccAddresses.Items[i] := StringToJString(ccRecipients[i]);

  Intent.putExtra(TJIntent.JavaClass.EXTRA_EMAIL, emailAddresses);
  Intent.putExtra(TJIntent.JavaClass.EXTRA_CC, ccAddresses);
  Intent.putExtra(TJIntent.JavaClass.EXTRA_SUBJECT, StringToJString(subject));
  Intent.putExtra(TJIntent.JavaClass.EXTRA_TEXT, StringToJString(Content));

  // Just filename portion for android services
  if AttachmentPath<>'' then
  begin

    CacheName := GetExternalCacheDir + TPath.DirectorySeparatorChar +
      TPath.GetFileName(AttachmentPath);
    if FileExists(CacheName) then
     Tfile.Delete(CacheName);
    Tfile.Copy(AttachmentPath, CacheName);

    fileNameTemp := StringToJString(CacheName);
    AttachmentFile := TJFile.JavaClass.init(fileNameTemp);

    if AttachmentFile <> nil then // attachment found
    begin
      AttachmentFile.setReadable(True, false);
      if not TOSVersion.Check(7) then
      begin
        Uri := TJnet_Uri.JavaClass.fromFile(AttachmentFile);
        Intent.putExtra(TJIntent.JavaClass.EXTRA_STREAM,
          TJParcelable.Wrap((Uri as ILocalObject).GetObjectID));
      end
      else begin  // support android 24  and later
        Intent.setFlags(TJIntent.JavaClass.FLAG_GRANT_READ_URI_PERMISSION);
        Uri := TAndroidHelper.JFileToJURI(AttachmentFile);
        // 2/28/2020 - Missing this line before so attachment missing
        Intent.putExtra(TJIntent.JavaClass.EXTRA_STREAM,
          TJParcelable.Wrap((Uri as ILocalObject).GetObjectID));
      end;
//    Uri := FileProvider.getUriForFile(mReactContext,
//                mReactContext.getApplicationContext().getPackageName() + ".provider",
//                imageFile);
    end
  end;

  Intent.setType(StringToJString('vnd.android.cursor.dir/email'));

  ChooserCaption := 'Send To';
  IntentChooser := TJIntent.JavaClass.createChooser(Intent,
    StrToJCharSequence(ChooserCaption));
  TAndroidHelper.Activity.startActivityForResult(IntentChooser, 0);

end;
      }
end.
