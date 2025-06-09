codeunit 75006 "MdM Async Sender"
{
    TableNo = "Imp.MdM Cabecera";

    trigger OnRun()
    begin

        cAsingMng.TraspasaCab(Rec);
    end;

    var
        rConfMdM: Record "Configuracion MDM";
        txtRet: Label 'http://retornoAsincrono.santillanaBus';
        // XmlDoc: DotNet XmlDocument;
        // XmlNode: array[10] of DotNet XmlNode;
        NSUri: Label 'http://schemas.xmlsoap.org/soap/envelope/';
        Notif: Label 'http://NotificacionDatosalMDM.santillanaBus';
        NS: Label '', Locked = true;
        // XmlNType: DotNet XmlNodeType;
        // XmlAtrbt: DotNet XmlAttribute;
        // XmlAtrrbts: DotNet XmlAttributeCollection;
        MdEMgnt: Codeunit "MdE Management";
        cFileMng: Codeunit "File Management";
        NS2: Label 'inf';
        TClave: Label 'CLAVE';
        cAsingMng: Codeunit "MdM Async Manager";
        wErrorCode: Code[20];
        wErrorDescription: Text;
        TOrigen: Label 'NAV_BOL';


    procedure BuildXML(pwCab: Record "Imp.MdM Cabecera"; pwTipo: Option Insert,Update,Delete,Error)
    var
        lwNodeName: Text[30];
        lwTxt: Text[30];
        // XmlNsMgr: DotNet XmlNamespaceManager;
        // lwsoapEnvelope: DotNet XmlElement;
        MyDT: DateTime;
        lwInt: Integer;
        lwInt2: Integer;
        lwNumInt: Integer;
    begin
        // BuildXML

        // XmlDoc := XmlDoc.XmlDocument;

        case pwTipo of
            pwTipo::Insert:
                lwTxt := 'retornoInsert';
            pwTipo::Update:
                lwTxt := 'retornoUpdate';
            pwTipo::Delete:
                lwTxt := 'retornoDelete';
            pwTipo::Error:
                lwTxt := 'retornoError';
        end;
        //lwNodeName := 'ret:' + lwTxt;
        lwNodeName := lwTxt;

        /*  lwsoapEnvelope := XmlDoc.CreateElement('soapenv', 'Envelope', NSUri);
         //lwsoapEnvelope := XmlDoc.CreateElement('soapenv:Envelope');
         lwsoapEnvelope.SetAttribute('xmlns:ret', txtRet);
         //lwsoapEnvelope.SetAttribute('xmlns:soapenv', NSUri);

         XmlDoc.AppendChild(lwsoapEnvelope);
         //XmlNode[1] := XmlDoc.CreateNode('element', 'soapenv:Header', '');

         XmlNode[1] := XmlDoc.CreateNode(XmlNType.Element, 'soapenv', 'Header', NSUri);

         lwsoapEnvelope.AppendChild(XmlNode[1]);
         //XmlNode[1] := XmlDoc.CreateNode('element', 'soapenv:Body', '');
         XmlNode[1] := XmlDoc.CreateNode(XmlNType.Element, 'soapenv', 'Body', NSUri);
         lwsoapEnvelope.AppendChild(XmlNode[1]);
         AddElement2(1, lwNodeName, '', 'ret', txtRet); */

        AddElement2(2, 'mensaje', '', '', '');
        AddElement2(3, 'head', '', '', '');

        AddElement2(4, 'id_mensaje', pwCab.id_mensaje, '', ''); //de la cabecera recibida
        //AddElement2(4,'sistema_origen',  pwCab.sistema_origen, '','');
        //AddElement2(4,'sistema_origen',  TOrigen, '',''); // Valor fijo: NAV
        AddElement2(4, 'sistema_origen', cAsingMng.GetSistemaOrigen, '', ''); // Valor fijo: NAV

        AddElement2(4, 'pais_origen', pwCab.pais_origen, '', '');
        AddElement2(4, 'fecha_origen', Format(pwCab.fecha_origen), '', '');//de la cabecera recibida
        AddElement2(4, 'fecha', Format(CurrentDateTime), '', '');
        AddElement2(4, 'tipo', pwCab.tipo, '', ''); //de la cabecera recibida

        if pwTipo = pwTipo::Error then begin
            AddElement2(4, 'error', '', '', '');
            AddElement2(5, 'code', wErrorCode, '', '');
            AddElement2(5, 'level', '', '', '');
            AddElement2(5, 'description', wErrorDescription, '', '');
        end;

        // Reintentos
        /*
        pwCab.GetIntDates(lwInt2, lwInt, lwNumInt);
        lwNumInt:= pwCab.Attempt;
        
        
        AddElement2(4 ,'num_reintentos'            , FORMAT(lwNumInt),'','');
        AddElement2(4 ,'datetime_ultimo_reintento' , FORMAT(pwCab."Last Attempt"),'','');
        AddElement2(4 ,'nivel_reintento'           , FORMAT(lwInt2) ,'','');
        AddElement2(4 ,'estado_reintento'          , FORMAT(lwInt),'','');
        */

        AddElement2(3, 'body', '', '', '');

    end;


    procedure BuildXMLError(pwCab: Record "Imp.MdM Cabecera"; pwCode: Code[20]; pwDescription: Text)
    begin
        // BuildXMLError

        // JPT 28/01/2019
        // Controlamos que la longitud no supere los 250 caracteres
        pwDescription := CopyStr(pwDescription, 1, 250);
        wErrorCode := pwCode;
        wErrorDescription := pwDescription;

        BuildXML(pwCab, 3);

        /*
        AddElement2(4,'error','','','');
        AddElement2(5,'code' , pwCode,'','');
        AddElement2(5,'level', '','','');
        AddElement2(5,'description',pwDescription,'','');
        */

    end;


    procedure BuildXMLRequest(pwCab: Record "Imp.MdM Cabecera")
    var
        lrLinImp: Record "Imp.MdM Tabla";
        lrLinImpTmp: Record "Imp.MdM Tabla" temporary;
        lrLinField: Record "Imp.MdM Campos";
        lwCod: Text;
        lwCodMdM: Text;
        lcText001: Label 'Tablas_Referencia';
        lcText002: Label 'articulo';
        lwFieldName: Text;
        lwElemento: Text;
        lcText003: Label 'id';
        lwTipo: Option Insert,Update,Delete,Error;
        lwOK: Boolean;
        lwEsArticulo: Boolean;
        lwDevolver: Boolean;
    begin
        // BuildXMLRequest

        lwTipo := pwCab.Operacion;
        BuildXML(pwCab, lwTipo);

        /*         if lwTipo = lwTipo::Error then begin
                    AddElement(XmlNode[4], 'newCodes', '', '', '', XmlNode[6]);
                end
                else begin
                    AddElement(XmlNode[4], 'ok', '', '', '', XmlNode[5]);
                    AddElement(XmlNode[5], 'newCodes', '', '', '', XmlNode[6]);
                end; */

        Clear(lrLinImp);
        lrLinImp.SetCurrentKey("Id Cab.");
        lrLinImp.SetRange("Id Cab.", pwCab.Id);
        //lrLinImp.SETFILTER("Id Tabla", '<>%1', 90); // subtabla de 90, no se procesa
        //IF lrLinImp.FINDSET(FALSE) THEN BEGIN
        if lrLinImp.FindFirst then begin
            Clear(lrLinImpTmp);
            //REPEAT
            // No queremos que se devuelvan dos lineas de producto (GENERAL/ESPECIFICO)
            //lwOK := (lrLinImp."Id Tabla" <> lrLinImpTmp."Id Tabla") OR (lrLinImp.Code <> lrLinImpTmp.Code) OR (lrLinImpTmp."Code MdM" <> lrLinImpTmp."Code MdM");
            lwOK := true;
            lrLinImpTmp := lrLinImp;

            if lwOK then begin
                Clear(lwCod);
                Clear(lwCodMdM);

                /*       AddElement(XmlNode[6], 'newCodeForElement', '', '', '', XmlNode[7]); */
                /*
                IF lrLinImp."Id Tabla" IN [27, 90] THEN
                  AddElement(XmlNode[7],'element',lrLinImp."Nombre Elemento",'','','',XmlNode[8])
                ELSE
                  AddElement(XmlNode[7],'element','Tablas_Referencia','','','',XmlNode[8]);
                */

                lwEsArticulo := false;
                case lrLinImp."Id Tabla" of
                    27, 90:
                        lwEsArticulo := true;
                    -1:
                        begin // No Aplica
                            lwEsArticulo := lrLinImp.Tipo >= 30;
                        end;
                end;

                if lwEsArticulo then
                    lwElemento := lcText002
                else
                    lwElemento := lcText001;

                AddElement2(7, 'element', lwElemento, '', '');
                AddElement2(7, 'pk_fields', '', '', '');

                /*
                CLEAR(lrLinField);
                lrLinField.SETRANGE("Id Rel", lrLinImp.Id);
                lrLinField.SETRANGE(PK, TRUE);
                IF lrLinField.FINDSET THEN BEGIN
                  REPEAT
                    AddElement2(8,'pk_field','','','');
                    AddElement2(,'field_name'     , lrLinField."Nombre Elemento",'','');
                    lwCodMdM := lrLinField."MdM Value";
                    IF lwCodMdM = '' THEN
                      lwCodMdM := lrLinField.Value;
                    AddElement2(9,'received_value', lwCodMdM,'','');
                    AddElement2(9,'new_value'      , lrLinField.Value,'','');
                    AddElement2(9,'description'      , '','','');
                  UNTIL lrLinField.NEXT=0;
                END
                ELSE BEGIN
                  AddElement2(8,'pk_field','','','', XmlNode[9]);
                  AddElement2(9,'field_name'     , TClave,'');
                  lwCodMdM := lrLinImp."Code MdM";
                  IF lwCodMdM = '' THEN
                    lwCodMdM := lrLinImp.Code;
                  AddElement2(9,'received_value', lwCodMdM,'');
                  AddElement2(9,'new_value'      , lrLinImp.Code,'');
                  AddElement2(9,'description'      , '','');
                END;
                */

                if lwEsArticulo then
                    lwFieldName := lcText003
                else
                    lwFieldName := lrLinImp."Nombre Elemento";

                AddElement2(8, 'pk_field', '', '', '');
                AddElement2(9, 'field_name', lwFieldName, '', '');


                lwDevolver := lrLinImp."Id Tabla" <> -1;
                if (lrLinImp."Id Tabla" = 27) and (lrLinImp.Tipo = 3) then
                    lwDevolver := false;
                if lwEsArticulo and (lrLinImp."Id Tabla" <> 27) then
                    lwDevolver := false;
                //lwDevolver := lwDevolver AND (NOT(lrLinImp."Id Tabla" = 27) AND (lrLinImp.Tipo =3)); // Autores

                lwDevolver := lwDevolver and (pwCab.Operacion = pwCab.Operacion::Insert);
                if lwDevolver then begin // -1 = No Aplica
                    lwCodMdM := lrLinImp."Code MdM";
                    if lwCodMdM = '' then
                        lwCodMdM := lrLinImp.Code;
                    lwCod := lrLinImp.Code;
                end;

                AddElement2(9, 'received_value', lwCodMdM, '', '');
                AddElement2(9, 'new_value', lwCod, '', '');
                //AddElement2(9,'description'      , '','','');
            end;
            //UNTIL lrLinImp.NEXT=0;
        end;

    end;


    procedure Send(var prCab: Record "Imp.MdM Cabecera")
    var
        lwIsError: Boolean;
        lwFileName: Text[1024];
        lwResp: Text;
        lwURL: Text;
        lwXML: Text;
    begin
        // Send
        // pwError refiere a un error a la hora de procesar los datos
        // lwIsError refiere a un error en el envio de la respuesta asincrona
        // En ambos casos marcamos el registro con estado Error


        //lwFileName := TEMPORARYPATH + 'TempAsinc.XML';
        /*   lwFileName := cFileMng.ServerTempFileName('XML'); */

        lwXML := '';
        // Ahora no sacamos lo guardado sino que lo generamos cada vez
        /*
        prCab.CALCFIELDS("Send XML");
        IF (prCab."Send XML".HASVALUE) AND (prCab.Estado <> prCab.Estado::Pendiente) THEN BEGIN
          prCab."Send XML".EXPORT(lwFileName);
          //lwXML := AddEnvlp(GestFileText(lwFileName));
          lwXML := GestFileText(lwFileName);
          IF prCab.Entrada = prCab.Entrada::NOTIFICA THEN
               lwXML := AddEnvlp(lwXML);
        END
        ELSE BEGIN
        */
        begin
            case prCab.Entrada of
                prCab.Entrada::INT_WS:
                    begin
                        /*                         XmlDoc.Save(lwFileName);
                                                lwXML := XmlDoc.OuterXml; */
                    end;
                prCab.Entrada::NOTIFICA:
                    begin
                        SaveNotification(prCab);
                        /*               lwXML := XmlDoc.OuterXml;
                                      XmlDoc.Save(lwFileName); */
                    end;
            end;

            /*   prCab."Send XML".Import(lwFileName); */
        end;

        if not rConfMdM.Activo then
            rConfMdM.Get;
        if not rConfMdM.Pruebas then begin
            Clear(lwURL);
            case prCab.Entrada of
                prCab.Entrada::INT_WS:
                    begin
                        rConfMdM.TestField("URL Async Reply");
                        lwURL := rConfMdM."URL Async Reply";
                    end;
                prCab.Entrada::NOTIFICA:
                    begin
                        rConfMdM.TestField("URL Notif.MdM");
                        lwURL := rConfMdM."URL Notif.MdM";
                    end;
            end;

            //lwResp := MdEMgnt.SendPostRequestNoError(lwURL, '', lwXML, lwIsError);
            lwResp := MdEMgnt.SendPostRequest2(lwURL, '', lwXML, false, lwIsError);

            // JPT 24/01/2019 No hace falta insertar registro
            //MdEMgnt.CreateAsyncPostRequest('WS_RESPUESTA_MdM',lwURL, '', lwXML);

            if lwIsError then
                prCab."Estado Envio" := prCab."Estado Envio"::Error
            else
                prCab."Estado Envio" := prCab."Estado Envio"::Finalizado;

            SaveAsincResp(prCab, lwResp);
        end
        else begin
            if GuiAllowed then;
            // cFileMng.DownloadToFile(lwFileName, 'D:\TEMP\TEMP.XML');
        end;

        //prCab.MODIFY;

    end;


    procedure AddElement(var pwXmlNode: Text; NodeName: Text[250]; NodeText: Text[250]; Prefix: Text; NameSpace: Text[250]; var pwCreatedXMLNode: Text) ExitStatus: Integer
    begin
        //AddElement

        // ExitStatus := MdEMgnt.AddElement(pwXmlNode, NodeName, NodeText, Prefix, NameSpace, pwCreatedXMLNode);
    end;


    procedure AddElement2(pwIdNode: Integer; NodeName: Text[250]; NodeText: Text[250]; Prefix: Text; NameSpace: Text[250]) ExitStatus: Integer
    begin
        //AddElement2

        //ExitStatus := AddElement(XmlNode[pwIdNode], NodeName, NodeText, Prefix, NameSpace, XmlNode[pwIdNode + 1]);
    end;


    procedure SaveNotification(prCab: Record "Imp.MdM Cabecera") wTxt: Text
    var
        lrCab2: Record "Imp.MdM Cabecera";
        lwOutStrm: OutStream;
        lwFile: File;
        /*  lwsoapEnvelope: DotNet XmlElement; */
        lrLinImp: Record "Imp.MdM Tabla";
        lwOk: Boolean;
        lwValues: array[10] of Text;
        lwHavValues: array[10] of Boolean;
    begin
        // SaveNotification

        wTxt := '';

        if prCab.Entrada <> prCab.Entrada::NOTIFICA then
            exit;

        /*     XmlDoc := XmlDoc.XmlDocument;
            lwsoapEnvelope := XmlDoc.CreateElement('soapenv', 'Envelope', NSUri);
            lwsoapEnvelope.SetAttribute('xmlns:not', Notif);

            XmlDoc.AppendChild(lwsoapEnvelope);
            XmlNode[1] := XmlDoc.CreateNode(XmlNType.Element, 'soapenv', 'Header', NSUri);

            lwsoapEnvelope.AppendChild(XmlNode[1]);
            XmlNode[1] := XmlDoc.CreateNode(XmlNType.Element, 'soapenv', 'Body', NSUri);
            lwsoapEnvelope.AppendChild(XmlNode[1]);
            AddElement2(1, 'update', '', 'not', Notif); */

        AddElement2(2, 'mensaje', '', '', '');
        AddElement2(3, 'head', '', '', '');

        AddElement2(4, 'id_mensaje', prCab.id_mensaje, '', ''); //de la cabecera recibida
        AddElement2(4, 'sistema_origen', cAsingMng.GetSistemaOrigen, '', ''); // Valor fijo: NAV

        AddElement2(4, 'pais_origen', prCab.pais_origen, '', '');
        AddElement2(4, 'fecha_origen', Format(prCab.fecha_origen, 0, 9), '', '');//de la cabecera recibida

        AddElement2(4, 'fecha', Format(CurrentDateTime, 0, 9), '', '');
        AddElement2(4, 'tipo', prCab.tipo, '', ''); //de la cabecera recibida

        // Reintentos
        /*
        pwCab.GetIntDates(lwInt2, lwInt, lwNumInt);
        lwNumInt:= pwCab.Attempt;
        
        
        AddElement2(4 ,'num_reintentos'            , FORMAT(lwNumInt),'','');
        AddElement2(4 ,'datetime_ultimo_reintento' , FORMAT(pwCab."Last Attempt"),'','');
        AddElement2(4 ,'nivel_reintento'           , FORMAT(lwInt2) ,'','');
        AddElement2(4 ,'estado_reintento'          , FORMAT(lwInt),'','');
        */

        AddElement2(3, 'body', '', '', '');

        Clear(lrLinImp);
        lrLinImp.SetCurrentKey("Id Cab.");
        lrLinImp.SetRange("Id Cab.", prCab.Id);
        if lrLinImp.FindFirst then begin

            Clear(lwValues);
            Clear(lwHavValues);

            lwHavValues[1] := GetFieldValue(lrLinImp, -103, lwValues[1]); // Peso
            lwHavValues[2] := GetFieldValue(lrLinImp, 75008, lwValues[2]); // Fecha Almacen
            lwHavValues[3] := GetFieldValue(lrLinImp, 75009, lwValues[3]); // Fecha Comercializacion
            lwHavValues[4] := GetFieldValue(lrLinImp, -300, lwValues[4]); // Precio sin impuestos
            lwHavValues[5] := GetFieldValue(lrLinImp, -325, lwValues[5]); // Precio con impuestos
            lwHavValues[8] := GetFieldValue(lrLinImp, -501, lwValues[8]); // Moneda
            // Valores Auxiliares
            lwHavValues[6] := GetFieldValue(lrLinImp, 49, lwValues[6]); // Pais
            lwHavValues[7] := GetFieldValue(lrLinImp, 75005, lwValues[7]); // Sociedad


            if lwHavValues[1] then begin
                AddElement2(4, 'Articulos_GENERAL', '', '', '');
                AddElement2(5, 'Articulo_GENERAL', '', '', '');
                AddElement2(6, 'pk', '', '', '');
                // Informamos del valor Navision y no el MdM
                //AddElement2(7,'ID_Articulo', lrLinImp."Code MdM",'','');
                AddElement2(7, 'ID_Articulo', lrLinImp.Code, '', '');
                if lwHavValues[1] then // Peso
                    AddElement2(6, 'Peso', lwValues[1], '', '');
            end;

            lwOk := lwHavValues[2] or lwHavValues[3] or lwHavValues[4] or lwHavValues[5] or lwHavValues[6] or lwHavValues[7];
            if lwOk then begin
                AddElement2(4, 'Articulos_ESPEC', '', '', '');
                AddElement2(5, 'Articulo_ESPEC', '', '', '');
                AddElement2(6, 'pk', '', '', '');
                // Informamos del valor Navision y no el MdM
                //AddElement2(7,'ID_Articulo',lrLinImp."Code MdM",'','');
                AddElement2(7, 'ID_Articulo', lrLinImp.Code, '', '');
                if lwHavValues[6] then
                    AddElement2(7, 'COD_Pais', lwValues[6], '', '');
                if lwHavValues[7] then
                    AddElement2(7, 'COD_Sociedad', lwValues[7], '', '');
                if lwHavValues[2] then
                    AddElement2(6, 'Fecha_Almacen', lwValues[2], '', '');
                if lwHavValues[3] then
                    AddElement2(6, 'Fecha_Comercializacion', lwValues[3], '', '');
                if lwHavValues[4] or lwHavValues[5] then begin
                    AddElement2(6, 'Precio', '', '', '');
                    AddElement2(7, 'Precio_sin_Impuestos', lwValues[4], '', '');
                    AddElement2(7, 'Precio_con_Impuestos', lwValues[5], '', '');
                    AddElement2(7, 'COD_Moneda', lwValues[8], '', '');
                end;
            end;
        end;

        /*         wTxt := XmlDoc.OuterXml; */

    end;


    procedure GestFileText(pwFilename: Text) wTxt: Text
    var
        lrCab2: Record "Imp.MdM Cabecera";
        lwInStrm: InStream;
        lwFile: File;
        lwBuffer: Text[1024];
    begin
        // GestFileText

        // Pasamos el fichero a texto
        /* lwFile.Open(pwFilename);
        lwFile.CreateInStream(lwInStrm);
        while not lwInStrm.EOS do begin
            lwInStrm.ReadText(lwBuffer);
            wTxt += lwBuffer;
        end;
        lwFile.Close; */
    end;


    procedure AddEnvlp(pwText: Text) wReturn: Text
    var
    /*         TxEnv1: Label '<soapenv:Envelope>

        /*  <soapenv: Header/>

        <soapenv: Body>';
            TxEnv2: Label '</soapenv:Body>

         </soapenv: Envelope>'; */
    begin
        // AddEnvlp

        /*      v1 + pwText + TxEnv2; */
    end;


    procedure SaveAsincResp(var prCab: Record "Imp.MdM Cabecera"; pwText: Text)
    var
        lwOutStrm: OutStream;
    begin
        // SaveAsincResp
        // Guarda la respuesta Asincrona

        prCab."Send XML Reply".CreateOutStream(lwOutStrm);
        // Text(pwText);
    end;


    procedure GetFieldValue(prLinField: Record "Imp.MdM Tabla"; pwIdField: Integer; var pwValue: Text) wRet: Boolean
    var
        lrField: Record "Imp.MdM Campos";
    begin
        // GetFieldValue

        pwValue := '';

        Clear(lrField);
        wRet := lrField.Get(prLinField.Id, pwIdField);
        if wRet then
            pwValue := lrField.Value;
    end;

    /*  trigger XmlDoc::NodeInserting(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
     begin
     end;

     trigger XmlDoc::NodeInserted(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
     begin
     end;

     trigger XmlDoc::NodeRemoving(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
     begin
     end;

     trigger XmlDoc::NodeRemoved(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
     begin
     end;

     trigger XmlDoc::NodeChanging(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
     begin
     end;

     trigger XmlDoc::NodeChanged(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
     begin
     end; */
}

