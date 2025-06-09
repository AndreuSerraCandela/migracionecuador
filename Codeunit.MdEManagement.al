codeunit 56202 "MdE Management"
{
    // #101415 17/11/2017 PLB: Se ha separado la función SendAsyncPostRequest en dos:
    //                       CreateAsyncPostRequest
    //                       SendAsyncPostRequest
    // MdM JPT 25/09/17 Añadonueva función SendPostRequest2


    trigger OnRun()
    begin
    end;

    var
        ConfSant: Record "Config. Empresa";
        ErrorInsert: Label 'Sólo se puede crear "%1" desde el MdE.';
        ErrorModify: Label 'Sólo se puede modificar "%1" de la tabla "%2" desde el MdE.';
        ErrorDelete: Label 'Sólo se puede borrar "%1" desde el MdE.';
        AsyncProcQueue: Record "Async NAV WS Process Queue";


    procedure CreateAsyncPostRequest(ProcessCode: Code[50]; Url: Text[150]; SoapAction: Text[250]; Content: Text): Text
    var
        AsyncWS: Codeunit "Async MdX NAV WS";
        IsError: Boolean;
        ResponseMessage: Text;
        QueueId: Integer;
    begin
        //+#101415
        if not AsyncWS.StartNewQueue(ProcessCode, Url, SoapAction, Content, QueueId, ResponseMessage) then
            Error(ResponseMessage);

        AsyncProcQueue.Get(QueueId);
    end;


    procedure SendAsyncPostRequest(): Text
    var
        AsyncProcStarter: Codeunit "Async MdX Process Starter";
    begin
        //+#101415
        AsyncProcQueue.Modify;
        AsyncProcStarter.Run(AsyncProcQueue);
    end;


    procedure SendPostRequest(Url: Text[150]; SoapAction: Text[250]; Content: Text): Text
    var
        IsError: Boolean;
    begin
        exit(SendPostRequestLocal(Url, SoapAction, Content, false, IsError));
    end;


    procedure SendPostRequest2(Url: Text[150]; SoapAction: Text[250]; Content: Text; ShowError: Boolean; var IsError: Boolean): Text
    begin
        // MdM
        exit(SendPostRequestLocal(Url, SoapAction, Content, ShowError, IsError));
    end;


    procedure SendPostRequestNoError(Url: Text[150]; SoapAction: Text[250]; Content: Text; var IsError: Boolean): Text
    begin
        exit(SendPostRequestLocal(Url, SoapAction, Content, true, IsError));
    end;

    local procedure SendPostRequestLocal(Url: Text[150]; SoapAction: Text[250]; Content: Text; ShowError: Boolean; var IsError: Boolean) Response: Text
    var
        /*  HttpClient: DotNet HttpClient;
         Uri: DotNet Uri;
         HttpResponseMessage: DotNet HttpResponseMessage;
         StringContent: DotNet StringContent; */

        Status: Integer;
    begin
        /*  HttpClient := HttpClient.HttpClient();
         Uri := Uri.Uri(Url);
         HttpClient.BaseAddress(Uri);

         // Header
         //HttpClient.DefaultRequestHeaders.Add('Content-type', 'application/soap+xml; charset=utf-8'); // esta da error
         HttpClient.DefaultRequestHeaders.Add('SOAPAction', SoapAction);
         HttpClient.DefaultRequestHeaders.Add('Host', Uri.Host);


         StringContent := StringContent.StringContent(Content, TextEncoding.UTF8, 'application/soap+xml');

         //HttpClient.Timeout

         // Get response
         HttpResponseMessage := HttpClient.PostAsync(Uri, StringContent).Result;

         // Save data
         Status := HttpResponseMessage.StatusCode;
         Response := HttpResponseMessage.Content.ReadAsStringAsync().Result;

         // Check reponse status
         if (Status < 200) or (Status > 299) then begin
             if ShowError then
                 Error(Response)
             else
                 IsError := true;
         end; */
    end;


    procedure AddElement(var XMLNode: Text; NodeName: Text[250]; NodeText: Text[250]; Prefix: Text[250]; NSUri: Text[250]; var CreatedXMLNode: Text) ExitStatus: Integer
    var
    /*  NewChildNode: DotNet XmlNode;
     XmlNodeType: DotNet XmlNodeType; */
    begin
        /*  NewChildNode := XMLNode.OwnerDocument.CreateNode(XmlNodeType.Element, Prefix, NodeName, NSUri); */

        /*    if IsNull(NewChildNode) then begin
               ExitStatus := 50;
               exit;
           end; */

        /*   if NodeText <> '' then
              NewChildNode.InnerText := NodeText;

          XMLNode.AppendChild(NewChildNode);
          CreatedXMLNode := NewChildNode; */

        ExitStatus := 0;
    end;


    procedure FormatDateTime(Fecha: Date; Hora: Time) TxtFecha: Text[50]
    var
        DT: DateTime;
    begin
        DT := CreateDateTime(Fecha, Hora);
        TxtFecha := Format(DT, 0, 9);
        TxtFecha := CopyStr(TxtFecha, 1, 19); // eliminamos el último carácter (Z): 2016-06-30T22:00:00Z --> 2016-06-30T22:00:00
    end;


    procedure FormatDate(Fecha: Date) TxtFecha: Text[50]
    begin
        TxtFecha := Format(Fecha, 0, '<Year4>-<Month,2>-<Day,2>T00:00:00'); //2016-06-30T00:00:00
    end;


    procedure Employee_Insert(var Employee: Record Employee)
    begin
        ConfSant.Get;
        if ConfSant."MdE Activo" then
            Error(ErrorInsert, Employee.TableCaption);
    end;


    procedure Employee_Modify(var Rec: Record Employee; var xRec: Record Employee)
    var
        ConfCont: Record "General Ledger Setup";
    begin
        ConfSant.Get;

        if ConfSant."MdE Activo" then begin

            if Rec."First Name" <> xRec."First Name" then
                Error(ErrorModify, Rec.FieldCaption("First Name"), Rec.TableCaption);

            if Rec."Last Name" <> xRec."Last Name" then
                Error(ErrorModify, Rec.FieldCaption("Last Name"), Rec.TableCaption);

            if Rec."Second Last Name" <> xRec."Second Last Name" then
                Error(ErrorModify, Rec.FieldCaption("Second Last Name"), Rec.TableCaption);

            if Rec."Employment Date" <> xRec."Employment Date" then
                Error(ErrorModify, Rec.FieldCaption("Employment Date"), Rec.TableCaption);

            if Rec."Document Type" <> xRec."Document Type" then
                Error(ErrorModify, Rec.FieldCaption("Document Type"), Rec.TableCaption);

            if Rec."Document ID" <> xRec."Document ID" then
                Error(ErrorModify, Rec.FieldCaption("Document ID"), Rec.TableCaption);

            if Rec.Gender <> xRec.Gender then
                Error(ErrorModify, Rec.FieldCaption(Gender), Rec.TableCaption);

            if Rec."Estado civil" <> xRec."Estado civil" then
                Error(ErrorModify, Rec.FieldCaption("Estado civil"), Rec.TableCaption);

            if Rec."Birth Date" <> xRec."Birth Date" then
                Error(ErrorModify, Rec.FieldCaption("Birth Date"), Rec.TableCaption);

            if Rec.Nacionalidad <> xRec.Nacionalidad then
                Error(ErrorModify, Rec.FieldCaption(Nacionalidad), Rec.TableCaption);

            if Rec."Country/Region Code" <> xRec."Country/Region Code" then
                Error(ErrorModify, Rec.FieldCaption("Country/Region Code"), Rec.TableCaption);

            if Rec.Address <> xRec.Address then
                Error(ErrorModify, Rec.FieldCaption(Address), Rec.TableCaption);

            if Rec.City <> xRec.City then
                Error(ErrorModify, Rec.FieldCaption(City), Rec.TableCaption);

            if Rec."Post Code" <> xRec."Post Code" then
                Error(ErrorModify, Rec.FieldCaption("Post Code"), Rec.TableCaption);

            if Rec.County <> xRec.County then
                Error(ErrorModify, Rec.FieldCaption(County), Rec.TableCaption);

            if Rec."E-Mail" <> xRec."E-Mail" then
                Error(ErrorModify, Rec.FieldCaption("E-Mail"), Rec.TableCaption);

            if Rec."Phone No." <> xRec."Phone No." then
                Error(ErrorModify, Rec.FieldCaption("Phone No."), Rec.TableCaption);

            if ConfSant."Posicion MdE" = ConfSant."Posicion MdE"::"Puesto laboral" then
                if Rec."Job Type Code" <> xRec."Job Type Code" then
                    Error(ErrorModify, Rec.FieldCaption("Job Type Code"), Rec.TableCaption);

            if Rec."Working Center" <> xRec."Working Center" then
                Error(ErrorModify, Rec.FieldCaption("Working Center"), Rec.TableCaption);

            if Rec.Categoria <> xRec.Categoria then
                Error(ErrorModify, Rec.FieldCaption(Categoria), Rec.TableCaption);

            if Rec."Emplymt. Contract Code" <> xRec."Emplymt. Contract Code" then
                Error(ErrorModify, Rec.FieldCaption("Emplymt. Contract Code"), Rec.TableCaption);

            if ConfSant."Departamento MdE"::Division in [ConfSant."Departamento MdE", ConfSant."Division MdE", ConfSant."Area funcional MdE"] then
                if Rec.Departamento <> xRec.Departamento then
                    Error(ErrorModify, Rec.FieldCaption(Departamento), Rec.TableCaption);

            ConfCont.Get;

            if ConfCont."Global Dimension 1 Code" in [ConfSant."Dimension Departamento", ConfSant."Dimension Division", ConfSant."Dimension Area funcional"] then
                if Rec."Global Dimension 1 Code" <> xRec."Global Dimension 1 Code" then
                    Error(ErrorModify, Rec.FieldCaption("Global Dimension 1 Code"), Rec.TableCaption);

            if ConfCont."Global Dimension 2 Code" in [ConfSant."Dimension Departamento", ConfSant."Dimension Division", ConfSant."Dimension Area funcional"] then
                if Rec."Global Dimension 2 Code" <> xRec."Global Dimension 2 Code" then
                    Error(ErrorModify, Rec.FieldCaption("Global Dimension 2 Code"), Rec.TableCaption);

        end;
    end;


    procedure Employee_Delete(var Employee: Record Employee)
    begin
        ConfSant.Get;
        if ConfSant."MdE Activo" then
            Error(ErrorDelete, Employee.TableCaption);
    end;


    procedure Contrato_Insert(var Contrato: Record Contratos)
    begin
        ConfSant.Get;
        if ConfSant."MdE Activo" then
            Error(ErrorDelete, Contrato.TableCaption);
    end;


    procedure Contrato_Modify(var Rec: Record Contratos; var xRec: Record Contratos)
    begin
        ConfSant.Get;
        if ConfSant."MdE Activo" then begin

            if Rec."Cód. contrato" <> xRec."Cód. contrato" then
                Error(ErrorModify, Rec.FieldCaption("Cód. contrato"), Rec.TableCaption);

            if ConfSant."Posicion MdE" = ConfSant."Posicion MdE"::"Puesto laboral" then
                if Rec.Cargo <> xRec.Cargo then
                    Error(ErrorModify, Rec.FieldCaption(Cargo), Rec.TableCaption);

            if Rec."Cód. contrato" <> xRec."Cód. contrato" then
                Error(ErrorModify, Rec.FieldCaption("Cód. contrato"), Rec.TableCaption);

            if Rec."Fecha inicio" <> xRec."Fecha inicio" then
                Error(ErrorModify, Rec.FieldCaption("Fecha inicio"), Rec.TableCaption);

            if Rec."Fecha finalización" <> xRec."Fecha finalización" then
                Error(ErrorModify, Rec.FieldCaption("Fecha finalización"), Rec.TableCaption);

            // Activo no puede gestionarse por el MdE, el usuario lo hará manualmente
            //IF Rec.Activo <> xRec.Activo THEN
            //  ERROR(ErrorModify, Rec.FIELDCAPTION(Activo), Rec.TABLECAPTION);

            if Rec."Centro trabajo" <> xRec."Centro trabajo" then
                Error(ErrorModify, Rec.FieldCaption("Centro trabajo"), Rec.TableCaption);

        end;
    end;


    procedure Contrato_Delete(var Contrato: Record Contratos)
    begin
        ConfSant.Get;
        if ConfSant."MdE Activo" then
            Error(ErrorDelete, Contrato.TableCaption);
    end;


    procedure GetOutStrm(var OutStrm: OutStream)
    begin
        //+#101415
        AsyncProcQueue."Received Data".CreateOutStream(OutStrm);
    end;
}

