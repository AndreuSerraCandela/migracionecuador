/*codeunit 76003 "Consultas DGII"
{

    trigger OnRun()
    var
        Datos: array[6] of Text[250];
    begin

        //BuscarRNC('130679355', Datos);
        /*
        ValidarRNC_NCF('1303297378','B0100000026', Datos);
        MESSAGE('CEDULA RNC: %1',        Datos[1]);
        MESSAGE('NOMBRE: %1',            Datos[2]);
        MESSAGE('NOMBRE COMERCIAL: %1',  Datos[3]);
        MESSAGE('NCF: %1',         Datos[4]);
        MESSAGE('ESTADO: %1',   Datos[5]);
        MESSAGE('VIGENCIA: %1',            Datos[6]);
        *//*
        DescargarListadoRNC;

    end;

    var
        Err001: Label 'Se debe especificar un número de NCF';
        Err002: Label 'Fiscal Document No. invalid or not authorized for this vendor';


    procedure BuscarRNC(NumeroDocumento: Text[30]; var Datos: array[6] of Text[250])
    var
        SystemNet: HttpClient;
        Headers: DotNet WebHeaderCollection;
        Url: Text[250];
        Parametros: Text[1024];
        StringHTML: BigText;
        PosInicial: Integer;
        Resultado: Text[1024];
        Error001: Label 'No se ha encontrado el RNC %1';
    begin
        NumeroDocumento := DelChr(NumeroDocumento, '=', '-. /_');

        // URL donde consultar los RNC
        Url := 'http://www.dgii.gov.do/app/WebApps/Consultas/rnc/RncWeb.aspx';

        // Parametros a enviar a la URL
        Parametros := '__EVENTTARGET=' + '&';
        Parametros += '__EVENTARGUMENT=' + '&';
        Parametros += '__LASTFOCUS=' + '&';
        Parametros += '__VIEWSTATE=/wEPDwUKMTY4ODczNzk2OA9kFgICAQ9kFgQCAQ8QZGQWAWZkAg0PZBYCAgMPPCsACwBkZHTpAYYQQIXs/JET7TFTjBqu3SYU' + '&';
        Parametros += '__EVENTVALIDATION=/wEWBgKl57TuAgKT04WJBAKM04WJBAKDvK/nCAKjwtmSBALGtP74CtBj1Z9nVylTy4C9Okzc2CBMDFcB' + '&';
        if StrLen(NumeroDocumento) = 9 then
            Parametros += 'rbtnlTipoBusqueda=0' + '&'
        else
            Parametros += 'rbtnlTipoBusqueda=1' + '&';
        Parametros += 'txtRncCed=' + NumeroDocumento + '&';
        Parametros += 'btnBuscaRncCed=Buscar';

        // Inicializamos .NET
        if IsNull(SystemNet) then SystemNet := SystemNet.WebClient;
        if IsNull(Headers) then Headers := Headers.WebHeaderCollection;

        // Configuramos los Headers
        Headers.Add('content-type', 'application/x-www-form-urlencoded');

        // Establecemos los headers al WebClinet
        SystemNet.Headers := Headers;

        // Obtenemos el resultado
        StringHTML.AddText(SystemNet.UploadString(Url, Parametros));

        // Otenemos la posición inicial donde buscar la información
        PosInicial := StringHTML.TextPos('<tr class="GridItemStyle">');

        // RNC no encontrado
        if (PosInicial = 0) then begin
            Message(Error001, NumeroDocumento);
            Clear(Datos);
            exit;
        end;

        // Guardamos los datos en otra variable
        StringHTML.GetSubText(StringHTML, (PosInicial + 28), 1024);
        StringHTML.GetSubText(Resultado, 1, (StringHTML.TextPos('</tr>') - 1));

        // Remplazamos caracteres innecesarios y lo separamos por comas
        Resultado := ReplaceString(Resultado, '&nbsp;', '');
        Resultado := ReplaceString(Resultado, '<td>', '');
        Resultado := ReplaceString(Resultado, '</td>', ',');

        Datos[1] := SelectStr(1, Resultado);
        Datos[2] := SelectStr(2, Resultado);
        Datos[3] := SelectStr(3, Resultado);
        Datos[4] := SelectStr(4, Resultado);
        Datos[5] := SelectStr(5, Resultado);
        Datos[6] := SelectStr(6, Resultado);
    end;


    procedure ValidaNCF(RNC: Text[19]; NCF: Code[30]; var Datos: array[6] of Text[250])
    var
        SystemNet: DotNet WebClient;
        Headers: DotNet WebHeaderCollection;
        Url: Text[250];
        Parametros: Text[1024];
        StringHTML: BigText;
        PosInicial: Integer;
        Resultado: Text[1024];
        Error001: Label 'NCF inválido para este proveedor';
        Parametrosb: BigText;
        AutXmlHttp: Automation;
        AutXmlDoc: Automation;
        XML: BigText;
        VarTXT: Text[1024];
        TxtXML: BigText;
    begin

        RNC := DelChr(RNC, '=', '-. /_');
        if NCF = '' then
            Error(Err001);
        //MDM

        Create(AutXmlHttp, false, true);
        AutXmlHttp.open('POST', 'http://www.dgii.gov.do/app/WebApps/Consultas/NCF/ConsultaNCF.aspx', 0); // If Username PWD then provide with comma separator else 0.
                                                                                                         //AutXmlHttp.setRequestHeader('Host','www.dgii.gov.do');
        AutXmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');



        TxtXML.AddText('txtNCF=' + NCF + '&__EVENTVALIDATION=%2FwEWBALj8K%2BgBQKm%2B57mDAKp%2B5qgBAKVq7KvCDEGa5SZ' +
        'M%2FdHHKkNzxdzF%2F0ZLFof&txtRNC=' + RNC + '&__VIEWSTATE=%2FwEPDwUJNTg1OTUyMDMyD2QWAgIDD2QWBAIBDw8WAh4EVGV4dAUBNRYE' +
        'HgpvbmtleXByZXNzBUhOdW1lcmljQm94X05TX0FkZE51bWVyaWNJdGVtKGV2ZW50LCAndHh0Uk5DJywgZmFsc2UsIHRydWUsIC0xLCAnLicsIC0xK' +
        'TseCG9uY2hhbmdlBRtOdW1lcmljQm94X05TX3R4dFJOQyhldmVudClkAgkPZBYCZg9kFgICAQ8PFgQeB1Zpc2libGVnHwAFVUVsIE7Dum1lcm8gZG' +
        'UgQ29tcHJvYmFudGUgRmlzY2FsIGluZ3Jlc2FkbyBubyBlcyBjb3JyZWN0byBvIG5vIGNvcnJlc3BvbmRlIGEgZXN0ZSBSTkNkZBgBBQpNdWx0aVZ' +
        'pZXcxDw9kZmRjNdd5z4ytNom4KYeTfDsG9WYhdg%3D%3D&btnConsultar=Consultar');
        AutXmlHttp.send(TxtXML);

        //MESSAGE(FORMAT(AutXmlHttp.status));

        if AutXmlHttp.status = 200 then begin
            XML.AddText(AutXmlHttp.responseText);
            if XML.TextPos('lblContribuyente') <> 0 then begin
                XML.GetSubText(VarTXT, XML.TextPos('lblContribuyente') + 18, 100);
                VarTXT := ReplaceString(VarTXT, '</span>', '');
                VarTXT := ReplaceString(VarTXT, '</td>', '');
                VarTXT := ReplaceString(VarTXT, '</tr>', '');
                Datos[3] := VarTXT;
            end
            else
                Error(Err002);


        end;
    end;


    procedure ReplaceString(String: Text[250]; FindWhat: Text[250]; ReplaceWith: Text[250]) NewString: Text[250]
    begin
        while StrPos(String, FindWhat) > 0 do
            String := DelStr(String, StrPos(String, FindWhat)) + ReplaceWith + CopyStr(String, StrPos(String, FindWhat) + StrLen(FindWhat));
        NewString := String;
    end;


    procedure ValidarRNC_NCF(RNC: Text[19]; NCF: Code[30]; var Datos: array[6] of Text[250])
    var
        SystemNet: DotNet WebClient;
        Headers: DotNet WebHeaderCollection;
        Url: Text[250];
        Parametros: Text[1024];
        StringHTML: BigText;
        PosInicial: Integer;
        Resultado: Text[1024];
        Error001: Label 'NCF inválido para este proveedor';
        Parametrosb: BigText;
        AutXmlHttp: Automation;
        AutXmlDoc: XmlDocument;
        XML: BigText;
        VarTXT: Text[1024];
        TxtXML: BigText;
        EVENTVALIDATION: Text;
        VIEWSTATE: Text;
    begin
        RNC := DelChr(RNC, '=', '-. /_');
        if NCF = '' then
            Error(Err001);
        //MDM

        Create(AutXmlHttp, false, true);
        AutXmlHttp.open('POST', 'http://www.dgii.gov.do/app/WebApps/ConsultasWeb/consultas/ncf.aspx', 0); // If Username PWD then provide with comma separator else 0.
        AutXmlHttp.setRequestHeader('Host', 'www.dgii.gov.do');
        AutXmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        //AutXmlHttp.setRequestHeader('cookie', '_ga=GA1.3.1579369244.1523032836; _gid=GA1.3.1971978671.1525804325; NSC_EHJJ_BQQ_MCWT=
        //ffffffffc3a0e52245525d5f4f58455e445a4a423660; NSC_bqq_p_EHJJ_TibsfQpjouefgbvmu=ffffffffc3a0e53e45525d5f4f58455e445a4a423660;
        // NSC_JOd5bct2ecdrcufb3zgbwxerx10cacu=ffffffffc3a0e53e45525d5f4f58455e445a4a423660');
        /*AutXmlHttp.setRequestHeader('accept-language', 'en-US,en;q=0.9,es-419;q=0.8,es;q=0.7');
        AutXmlHttp.setRequestHeader('accept-encoding', 'gzip, deflate');
        AutXmlHttp.setRequestHeader('referer', 'http://www.dgii.gov.do/app/WebApps/ConsultasWeb/consultas/ncf.aspx');
        AutXmlHttp.setRequestHeader('accept', '*//*');
        AutXmlHttp.setRequestHeader('content-type', 'application/x-www-form-urlencoded');
      AutXmlHttp.setRequestHeader('user-agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.139 Safari/537.36');
      AutXmlHttp.setRequestHeader('x-microsoftajax', 'Delta=true');
      AutXmlHttp.setRequestHeader('origin', 'http://www.dgii.gov.do');
      AutXmlHttp.setRequestHeader('cache-control', 'no-cache');

      EVENTVALIDATION := '/wEWBAL9wIfQCwK+9LSUBQLfnOXIDAKErv7SBt4AGLOl6Uygq6CAOxbDBgqfSXl5';

      VIEWSTATE := '/wEPDwUJNTM1NDc0MDQ5D2QWAmYPZBYCAgEPZBYCAgMPZBYCZg9kFgICAQ9kFgQCAQ8PFggeBFRleHQFG0VsIE5DRiBkaWdpdGFkbyBlcyB2w6FsaWRvLh4IQ3NzQ2xhc3MFEGxhYmVsIGxhYmVsLWluZm' +
      '8eBF8hU0ICAh4HVmlzaWJsZWdkZAILDw8WAh8DZ2QWDAIBDw8WAh8ABQkxMzAzODI5OTlkZAIDDw8WAh8ABSlESVNFTk8gWSBURUNOT0xPR0lBIEVNUFJFU0FSSUFMIEwgJiBNIFNSTGRkAgUPDxYCHwAFGkZBQ1RVUkFTIERFIENS' +
      'RURJVE8gRklTQ0FMZGQCBw8PFgIfAAULQjAxMDAwMDAwMTBkZAIJDw8WAh8ABQdWSUdFTlRFZGQCCw8PFgIfAAUKMzEvMTIvMjAxOWRkZJ1YJIt52JPHgjqa8oRveertehfP';
      *//*
        TxtXML.AddText('ctl00%24smMain=ctl00%24upMainMaster%7Cctl00%24cphMain%24btnConsultar&ctl00%24cphMain%24txtRNC=' + RNC + '&ctl00%24cphMain%24txtNCF=' + NCF + '&' +
        '__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=%2FwEPDwUJNTM1NDc0MDQ5D2QWAmYPZBYCAgEPZBYCAgMPZBYCZg9kFgICAQ9kFgQCAQ8PFggeBFRleHQFG0VsIE5DRiBkaWdpdGFkbyBlcyB2w6F' +
        'saWRvLh4IQ3NzQ2xhc3MFEGxhYmVsIGxhYmVsLWluZm8eBF8hU0ICAh4HVmlzaWJsZWdkZAILDw8WAh8DZ2QWDAIBDw8WAh8ABQkxMzAzODI5OTlkZAIDDw8WAh8ABSlESVNFTk8gWSBURUNOT0xPR0lBIEVN' +
        'UFJFU0FSSUFMIEwgJiBNIFNSTGRkAgUPDxYCHwAFGkZBQ1RVUkFTIERFIENSRURJVE8gRklTQ0FMZGQCBw8PFgIfAAULQjAxMDAwMDAwMTBkZAIJDw8WAh8ABQdWSUdFTlRFZGQCCw8PFgIfAAUKMzEvMTIvMj' +
        'AxOWRkZJ1YJIt52JPHgjqa8oRveertehfP&__EVENTVALIDATION=%2FwEWBAL9wIfQCwK%2B9LSUBQLfnOXIDAKErv7SBt4AGLOl6Uygq6CAOxbDBgqfSXl5&__ASYNCPOST=true&ctl00%24cphMain%24b' +
        'tnConsultar=Consultar');

        AutXmlHttp.send(TxtXML);

        //MESSAGE(FORMAT(AutXmlHttp.status));
        //MESSAGE(AutXmlHttp.responseText);
        if AutXmlHttp.status = 200 then begin
            Clear(XML);
            XML.AddText(AutXmlHttp.responseText);
            //GuardarXML(RNC,XML);
            if XML.TextPos('ctl00_cphMain_pResultado') <> 0 then begin
                XML.GetSubText(Datos[1], XML.TextPos('<span id="ctl00_cphMain_lblRncCedula">') + 38, 9);

                XML.GetSubText(Datos[2], XML.TextPos('<span id="ctl00_cphMain_lblRazonSocial">') + 40, 14);

                XML.GetSubText(Datos[3], XML.TextPos('<span id="ctl00_cphMain_lblTipoComprobante">') + 44, 26);

                XML.GetSubText(Datos[4], XML.TextPos('<span id="ctl00_cphMain_lblNCF">') + 32, 11);

                XML.GetSubText(Datos[5], XML.TextPos('<span id="ctl00_cphMain_lblEstado">') + 35, 7);

                XML.GetSubText(Datos[6], XML.TextPos('<span id="ctl00_cphMain_lblVigencia">') + 37, 10);


            end
            else
                Error(Err002);


        end;

    end;


    procedure GuardarXML(codPrmDoc: Code[20]; StringXMLTXT: BigText)
    var
        filSalida: File;
        outXML: OutStream;
    begin

        filSalida.Create('C:\Temp\' + codPrmDoc + '.txt');
        filSalida.CreateOutStream(outXML);
        StringXMLTXT.Write(outXML);
    end;


    procedure DescargarListadoRNC()
    var
        TempBlob: Codeunit "Temp Blob";
        IStream: InStream;
        FileName: Text;
        RBMgt: Codeunit "File Management";
        DirPath: Text;
        ResponseOutStream: OutStream;
        TempBlob2: Codeunit "Temp Blob";
        ResponseInStream: InStream;
        ResponseInStream2: InStream;
        RNCDGIIImport: XMLport "RNC DGII Import";
        RNCDGII: Record "RNC DGII";
        Window: Dialog;
        FileHandle: File;
        vartext: Text;
        StreamReader: DotNet StreamReader;
        SOH: Char;
        US: Char;
        Encoding: DotNet Encoding;
    begin

        Clear(DirPath);
        Clear(FileName);
        Clear(TempBlob);
        Clear(TempBlob2);

        FileName := 'DGII_RNC.ZIP';
        DirPath := 'C:\DGII_RNC_FILE\';

        if GuiAllowed then
            Window.Open('Descargando y Descomprimiendo Archivo RNC DGII. @1@@@@@@@@@@');

        if GuiAllowed then
            Window.Update(1, (1 / 5 * 10000) div 1);

        RNCDGII.DeleteAll;
        if GuiAllowed then
            Window.Update(1, (2 / 5 * 10000) div 1);

        TempBlob.CreateInStream(IStream);
        TempBlob.TryDownloadFromUrl('https://www.dgii.gov.do/app/WebApps/Consultas/RNC/DGII_RNC.zip');

        if GuiAllowed then
            Window.Update(1, (3 / 5 * 10000) div 1);

        RBMgt.ServerCreateDirectory(DirPath);
        RBMgt.DeleteServerFile(DirPath + FileName);
        RBMgt.BLOBExportToServerFile(TempBlob, DirPath + FileName);
        if RBMgt.ServerDirectoryExists(DirPath + 'TMP') then
            RBMgt.ServerRemoveDirectory(DirPath + 'TMP', true);

        if RBMgt.ExtractZipFile(DirPath + FileName, DirPath) then begin

            if GuiAllowed then
                Window.Update(1, (4 / 5 * 10000) div 1);

            Clear(TempBlob);//clean cache
            Clear(IStream);//clean cache

            // FileHandle.TEXTMODE(TRUE);
            //  FileHandle.WRITEMODE(TRUE);

            if FileHandle.Open(DirPath + 'TMP\DGII_RNC.TXT', TEXTENCODING::Windows) then begin

                FileHandle.CreateInStream(ResponseInStream);
                StreamReader := StreamReader.StreamReader(ResponseInStream, Encoding.GetEncoding('Windows-1252'), true);
                vartext := StreamReader.ReadToEnd();

                Clear(StreamReader);//clean cache
                Clear(ResponseInStream);//clean cache
                FileHandle.Close;
                Clear(FileHandle);//clean cache

                US := 31;
                SOH := 1;
                vartext := DelChr(vartext, '=', Format(US) + Format(SOH));

                TempBlob2.CreateOutStream(ResponseOutStream, TEXTENCODING::Windows);
                ResponseOutStream.WriteText(vartext);
                TempBlob2.CreateInStream(ResponseInStream2, TEXTENCODING::Windows);

                if GuiAllowed then
                    Window.Close;

                Clear(vartext);//clean cache
                Clear(ResponseOutStream);//clean cache

                RNCDGIIImport.SetSource(ResponseInStream2);
                RNCDGIIImport.Import;

            end;
        end;

    end;
}*/

