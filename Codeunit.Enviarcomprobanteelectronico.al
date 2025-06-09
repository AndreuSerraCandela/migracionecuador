/*codeunit 55006 "Enviar comprobante electronico"
{
    // #35029 RRT, 12.11.2017: Poder ejecutar esta función desde NAS. Para ello hay que actualizar las variables a DotNet


    trigger OnRun()
    var
        c: Codeunit "Comprobantes electronicos";
    begin
        //fes mig (para ejecutar manual ver 2013r2. No aplica para WebClient
        /*
        //IF GUIALLOWED THEN BEGIN
        IF c._GUIALLOWED THEN BEGIN
          WinHTTP.open('POST',texURLRecepcion,0);
          WinHTTP.send(XMLRequestDoc);
        END
        //+35029
        ELSE BEGIN
          _WinHTTP.open('POST',texURLRecepcion,FALSE,'','');
          _WinHTTP.send(_XMLRequestDoc.OuterXml);
        END;
        //-35029
        *///fes mig-
/*

        //fes mig . Codificacion para Web Client BC
        _WinHTTP.open('POST', texURLRecepcion, false, '', '');
        _WinHTTP.send(_XMLRequestDoc.OuterXml);

    end;

    var
        WinHTTP: Automation;
        XMLRequestDoc: Automation;
        texURLRecepcion: Text;
        _XMLRequestDoc: DotNet XmlDocument;
                            _WinHTTP: DotNet XMLHTTPRequestClass;
                            HttpClient: DotNet HttpClient;


    procedure PasarParam(texPrmURL: Text; var prmXMLRequestDoc: Automation; var prmWinHTTP: Automation)
    begin
        texURLRecepcion := texPrmURL;
        XMLRequestDoc := prmXMLRequestDoc;
        WinHTTP := prmWinHTTP;
    end;


    procedure _PasarParam(texPrmURL: Text; var prmXMLRequestDoc: DotNet XmlDocument; var prmWinHTTP: DotNet XMLHTTPRequestClass)
    begin
        //+035029
        texURLRecepcion := texPrmURL;
        _XMLRequestDoc := prmXMLRequestDoc;
        _WinHTTP := prmWinHTTP;
    end;

    trigger _XMLRequestDoc::NodeInserting(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
    begin
    end;

    trigger _XMLRequestDoc::NodeInserted(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
    begin
    end;

    trigger _XMLRequestDoc::NodeRemoving(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
    begin
    end;

    trigger _XMLRequestDoc::NodeRemoved(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
    begin
    end;

    trigger _XMLRequestDoc::NodeChanging(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
    begin
    end;

    trigger _XMLRequestDoc::NodeChanged(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
    begin
    end;
}*/

