{* ***************************************************************************************

\Program    Upload code for microcontroller - Version 1.0

\brief      Upload code with input parameters to microcontroller ESP8266 WEMOS D1

\author     Anh Tu Nguyen

\date       06.01.2020

\note       (C) Copyright imess GmbH

            Contents and presentations are protected world-wide.

            Any kind of using, copying etc. is prohibited without prior permission.

            All rights - incl. industrial property rights - are reserved.

*************************************************************************************** *}

unit upload;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Registry, Mask, ShellApi, StrUtils, FileCtrl, IdIcmpClient;

type
  TuploadForm = class(TForm)
    btnCreateFile: TButton;
    edtWifiPassword: TEdit;
    lbWifiPassword: TLabel;
    lbIPAddress: TLabel;
    lbGateway: TLabel;
    lbSubnet: TLabel;
    lbCOMPort: TLabel;
    lbWifiSSID: TLabel;
    edtWifiSSID: TEdit;
    cbComPort: TComboBox;
    meditIPAddress: TMaskEdit;
    meditGateWay: TMaskEdit;
    meditSubnet: TMaskEdit;
    lbPort: TLabel;
    meditPort: TMaskEdit;
    procedure SearchComPort;
    procedure FormCreate(Sender: TObject);
    procedure ButtonUploadClick(Sender: TObject);
    procedure CreateSourceCode(WifiSSID, WifiPassword, IPAddress, Port, Gateway, Subnet: string);
    procedure CreateBatchFile(comPort: string);
    function CheckUploadCodeSuccessful: Integer;
    function CheckInputAddressEmpty(InputParameter: string): Integer;
    function ValidateIP(IP4: string): Integer;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  uploadForm: TuploadForm;

implementation

{$R *.dfm}

//-------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------
procedure TuploadForm.SearchComPort;
// This procedure searchs available serial port in current computer
var
   reg: TRegistry;
   st: Tstrings;
   i: Integer;
begin
   reg:=TRegistry.Create;
   try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKey('hardware\devicemap\serialcomm', False);
    st := TstringList.Create;
    try
      reg.GetValueNames(st);
      for i := 0 to st.Count - 1 do
        cbComPort.Items.Add(reg.Readstring(st.strings[i]));
    finally
      st.Free;
    end;
    reg.CloseKey;
  finally
    reg.Free;
  end;

end;

//-------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------
procedure TuploadForm.FormCreate(Sender: TObject);
// This procedure create upload form
begin
   SearchComPort;
   meditIPAddress.EditMask := '!099.099.099.099;1; ';
   meditGateWay.EditMask := '!099.099.099.099;1; ';
   meditSubnet.EditMask := '!099.099.099.099;1; ';
end;

//-------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------
procedure TuploadForm.ButtonUploadClick(Sender: TObject);
// This procedure runs when button Upload is clicked
var
  wifiSSID: string;
  wifiPassword: string;
  ipAddress: string;
  gateWay: string;
  subnet: string;
  port: string;
  comPort: string;
begin
  //Get input info 
   wifiSSID := edtWifiSSID.Text;
   wifiPassword := edtWifiPassword.Text;
   ipAddress := meditIPAddress.Text;
   port := meditPort.Text;
   gateWay := meditGateWay.Text;
   subnet := meditSubnet.Text;
   comPort := cbComPort.Text;
   
   //Check if string input empty
   if (wifiSSID = '') or (wifiPassword = '') or (ipAddress = '') or (gateWay = '') or (subnet = '') or (port = '') or (comPort = '') then
   begin
       Application.MessageBox('Input parameters empty!', 'Error', MB_ICONERROR);
   end
   else
   begin
     if(CheckInputAddressEmpty(ipAddress) <> 0) then
     begin
        if (CheckInputAddressEmpty(gateWay) <> 0)then
        begin
             if (CheckInputAddressEmpty(subnet) <> 0) then
             begin
                   CreateSourceCode(wifiSSID, wifiPassword, ipAddress, port, gateWay, subnet) ;
                   CreateBatchFile(comPort);
                   ShellExecute(Application.Handle, 'open', PChar(GetCurrentDir+'\batchFile.cmd'), nil, nil, SW_NORMAL);
             end
             else
                 Application.MessageBox('Not correct Subnet!', 'Error', MB_ICONERROR);
        end
        else
            Application.MessageBox('Not correct Gateway!', 'Error', MB_ICONERROR);
     end
     else
        Application.MessageBox('Not correct IP Address!', 'Error', MB_ICONERROR);
   end;

   {*if CheckUploadCodeSuccessful = 0 then
     begin
       ShowMessage('Upload code successful!');
     end
   else
     begin
       ShowMessage('Error!!!');
     end;
   *}
   //ShellExecute(Application.Handle, 'explore', 'C:\Windows', nil, nil, SW_SHOWNORMAL);
end;

//-------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------
procedure TuploadForm.CreateSourceCode(wifiSSID, wifiPassword, ipAddress, port,
  gateWay, subnet: string);
// This procedure creates source code for microcontroller
// Input: "wifiSSID"      : wifi name
//        "wifiPassword"  : wifi password
//        "ipAddress"     : static IP Address of microcontroller
//        "port"          : serial port
//        "gateWay"       : router IP
//        "subnet"        : network subnet
var
  sampleFile: TextFile;
  sourceCode: TextFile;
  line: string;
begin
   //Save input info to source code for microcontroller
   AssignFile(sampleFile, 'sampleCode');
   Reset(sampleFile);
   AssignFile(sourceCode, GetCurrentDir+'\cli\sourceCode\sourceCode.ino');
   ReWrite(sourceCode);

   //Replace , to . and remove space
   ipAddress := StringReplace(ipAddress, '.', ',', [rfReplaceAll]);
   ipAddress := StringReplace(ipAddress, ' ', '', [rfReplaceAll]);

   gateWay := StringReplace(gateWay, '.', ',', [rfReplaceAll]);
   gateWay := StringReplace(gateWay, ' ', '', [rfReplaceAll]);

   subnet := StringReplace(subnet, '.', ',', [rfReplaceAll]);
   subnet := StringReplace(subnet, ' ', '', [rfReplaceAll]);

   port := StringReplace(port, ' ', '', [rfReplaceAll]);
   
   while not Eof(sampleFile) do
    begin
      ReadLn(sampleFile, line);

      if AnsiContainsStr(line,'testWLAN') then
        begin
          line := StringReplace(line, 'testWLAN', wifiSSID, [rfReplaceAll]);
        end
      else if AnsiContainsStr(line,'testPassword') then
        begin
          line := StringReplace(line, 'testPassword', wifiPassword, [rfReplaceAll]);
        end
      else if AnsiContainsStr(line,'ip(192,168,11,98)') then
        begin
          line := StringReplace(line, '192,168,11,98', ipAddress, [rfReplaceAll]);
        end
      else if AnsiContainsStr(line,'gateway(192,168,11,241)') then
        begin
          line := StringReplace(line, '192,168,11,241', gateWay, [rfReplaceAll]);
        end
      else if AnsiContainsStr(line, 'server(80)') then
        begin
          line := StringReplace(line, '80', port, [rfReplaceAll]);
        end
      else if AnsiContainsStr(line,'subnet(255,255,255,0)') then
        begin
          line := StringReplace(line, '255,255,255,0', subnet, [rfReplaceAll]);
        end;

      WriteLn(sourceCode, line);
    end;

   CloseFile(sampleFile);
   CloseFile(sourceCode);

   //ShowMessage('CREATE FILE DONE!');
end;

//-------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------
function TuploadForm.CheckInputAddressEmpty(inputParameter: string): Integer;
// This function checks input IP Address, Gateway, Subnet, if it is empty
// Input: "inputParameter": string of input parameter
// Result: 0, correct Address, 1, incorrect Address
begin
  //Replace space
  inputParameter := StringReplace(inputParameter, ' ', '', [rfReplaceAll]);
  if(Length(inputParameter) > 3) then
    begin
        result := ValidateIP(inputParameter);
    end
  else result := 1; //Not correct
end;

//-------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------
function TuploadForm.ValidateIP(iP4: string): Integer;
// This function checks IP Address, Gateway, Subnet, if it is correct
// Input: "ip4": string of IP Address, Gateway or Subnet
// Result: 0, correct Address, 1, incorrect Address
var
  octet : String;
  dots, I : Integer;
begin
  //ip4 := IP4+'.'; //add a dot. We use a dot to trigger the Octet check, so need the last one
  dots := 0;
  octet := '0';

  for I := 1 To Length(iP4) do
    begin
    if iP4[I] in ['0'..'9','.'] then
      begin
      if iP4[I] = '.' then //found a dot so inc dots and check octet value
        begin
        Inc(dots);
          If (length(octet) =1) Or (StrToInt(octet) > 255) Then
            dots := 5; //Either there's no number or it's higher than 255 so push dots out of range
            octet := '0'; // Reset to check the next octet
        end // End of IP4[I] is a dot
      else // Else IP4[I] is not a dot so
          octet := octet + iP4[I]; // Add the next character to the octet
      end // End of IP4[I] is not a dot
    else // Else IP4[I] Is not in CheckSet so
      dots := 5; // Push dots out of range
    end;

  if dots = 4 then
    result := 0 // The only way that Dots will equal 4 is if we passed all the tests
  else
    result := 1

end;

//-------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------
procedure TuploadForm.CreateBatchFile(comPort: string);
// This procedure creates batch file to upload code
// Input: "comPort": Selected Serial Port
var
  sampleBatchFile: TextFile;
  batchFile: TextFile;
  line: string;
begin
   AssignFile(sampleBatchFile, 'sampleBatch');
   Reset(sampleBatchFile);
   AssignFile(batchFile, GetCurrentDir+'\batchFile.cmd');
   ReWrite(batchFile);

   while not Eof(sampleBatchFile) do
    begin
      ReadLn(sampleBatchFile, line);

      if AnsiContainsText(line, 'C:\Users\Admin\Desktop\Upload code program') then
        begin
          line := StringReplace(line, 'C:\Users\Admin\Desktop\Upload code program', GetCurrentDir, [rfReplaceAll]);
        end
      else if AnsiContainsText(line, 'COMPort') then
        begin
          line := StringReplace(line, 'COMPort', comPort, [rfReplaceAll]);
        end;
      WriteLn(batchFile, line);
    end;

   CloseFile(sampleBatchFile);
   CloseFile(batchFile);
end;

//-------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------
function TuploadForm.CheckUploadCodeSuccessful: Integer;
var
  idIcmpClient: TIdIcmpClient;
  port: string;
begin
  {*idIcmpClient := TIdIcmpClient.Create(nil);
  idIcmpClient.Host := meditIPAddress.Text;

  port := meditPort.Text;
  port := StringReplace(port, ' ', '', [rfReplaceAll]);
  idIcmpClient.Port := StrToInt(port);

  try
    idIcmpClient.Ping;
  except
    result:=-1;
    idIcmpClient.Free;
  end;

  if idicmpclient.ReplyStatus.ReplyStatusType = rsEcho then
    //result:=idIcmpClient.ReplyStatus.MsRoundTripTime
    begin
       result := 0;
    end
  else
    begin
      result:=-1;
    end;

  idIcmpClient.Free; *}
end;

end.
