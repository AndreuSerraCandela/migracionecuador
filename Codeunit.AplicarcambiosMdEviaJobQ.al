codeunit 56206 "Aplicar cambios MdE via Job Q"
{
    // #81969  27/01/2018 PLB: Tarea programada para aplicar los cambios en los empleados que vienen del MdE según la fecha efectiva
    // #269159 21.01.2020 RRT: Se descartarán los registros que ya hanb sido ejecutados con error detectado. No tiene sentido que vuelvan a ejecutarse.

    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        MdEHistory: Record "Historial MdE";
        MdEHistory2: Record "Historial MdE";
        IsOk: Boolean;
        DescErrorArray: array[10] of Text;
        TipoErrorArray: array[10] of Text;
    begin
        IsOk := true;

        MdEHistory.SetCurrentKey(Aplicado, "Fecha efectiva");
        MdEHistory.SetRange(Aplicado, false);

        //+#269159
        //... Para que no se ejecute cada vez, si ya se ha detectado un error.
        MdEHistory.SetRange("Error proceso", false);
        //-#269159

        MdEHistory.SetRange("Fecha efectiva", 0D, Today);
        if MdEHistory.FindSet then
            repeat
                MdEHistory2 := MdEHistory;
                MdEHistory2.ApplyToEmployee;
                if not MdEHistory2.GetErrors(DescErrorArray, TipoErrorArray) then begin
                    IsOk := false;
                    MdEHistory2."Error proceso" := true;
                    MdEHistory2."Descripcion error" := CopyStr(DescErrorArray[1], 1, MaxStrLen(MdEHistory2."Descripcion error"));
                    MdEHistory2.Modify;

                    SendNotification(MdEHistory2);  //+#269159

                end;
            until MdEHistory.Next = 0;

        //+#269159
        //... El SendNotificacion() anterior no cubre todos los errores que se hubieran detectado.
        /*
        IF NOT IsOk THEN BEGIN
          MdEHistory.FINDLAST;
          SendNotification(MdEHistory);
        END;
        */
        //-#269159

    end;

    var
        ErrorText: Label 'Error message: %1';


    procedure SendNotification(var MdEHistory: Record "Historial MdE")
    var
        ConfEmp: Record "Config. Empresa";
        RecordLink: Record "Record Link";
        RecRef: RecordRef;
    begin
        ConfEmp.Get;
        if ConfEmp."Usuario notificaciones MdE" = '' then
            exit;

        RecRef.GetTable(MdEHistory);

        RecordLink."Link ID" := 0;
        RecordLink."Record ID" := RecRef.RecordId;
        RecordLink.Description := MdEHistory.TableCaption;
        SetURL(MdEHistory, RecordLink);
        RecordLink.Type := RecordLink.Type::Note;
        RecordLink.Created := CurrentDateTime;
        RecordLink."User ID" := UserId;
        RecordLink.Company := CompanyName;
        RecordLink.Notify := true;
        RecordLink."To User ID" := ConfEmp."Usuario notificaciones MdE";
        SetText(MdEHistory, RecordLink);
        RecordLink.Insert;
    end;

    local procedure SetURL(var MdEHistory: Record "Historial MdE"; var RecordLink: Record "Record Link")
    var
        Link: Text;
    begin
        // Generates a URL such as dynamicsnav://host:port/instance/company/runpage?page=672&$filter=
        // The intent is to open up the Job Queue Entries page and show the list of "my errors".
        // TODO: Leverage parameters ",JobQueueEntry,TRUE)" to take into account the filters, which will add the
        // following to the Url: &$filter=JobQueueEntry.Status IS 2 AND JobQueueEntry."User ID" IS <UserID>.
        // This will also require setting the filters on the record, such as:
        // SETFILTER(Status,'=3');
        // SETFILTER("Posting User ID",'=%1',"Posting User ID");
        Link := GetUrl(CLIENTTYPE::Default, CompanyName, OBJECTTYPE::Page, PAGE::"Lista Historial MdE") +
          StrSubstNo('&$filter=''%1''.''%2''%20IS%20''TRUE''%20AND%20''%1''.''%3''%20IS%20''FALSE''&mode=View',
            HtmlEncode(MdEHistory.TableName), HtmlEncode(MdEHistory.FieldName("Error proceso")), HtmlEncode(MdEHistory.FieldName(Aplicado)));

        RecordLink.URL1 := CopyStr(Link, 1, MaxStrLen(RecordLink.URL1));
    end;

    local procedure SetText(var MdEHistory: Record "Historial MdE"; var RecordLink: Record "Record Link")
    var

        OStr: OutStream;
        s: Text;
        lf: Text;
        c1: Char;
        c2: Char;
        x: Integer;
        y: Integer;
        i: Integer;
    begin
        c1 := 13;
        lf[1] := c1;

        s := StrSubstNo(ErrorText, MdEHistory."Descripcion error");
        /* 
                SystemUTF8Encoder := SystemUTF8Encoder.UTF8Encoding;
                SystemByteArray := SystemUTF8Encoder.GetBytes(s);

                RecordLink.Note.CreateOutStream(OStr);
                x := SystemByteArray.Length div 128;
                if x > 1 then
                    y := SystemByteArray.Length - 128 * (x - 1)
                else
                    y := SystemByteArray.Length;
                c1 := y;
                OStr.Write(c1);
                if x > 0 then begin
                    c2 := x;
                    OStr.Write(c2);
                end;
                for i := 0 to SystemByteArray.Length - 1 do begin
                    c1 := SystemByteArray.GetValue(i);
                    OStr.Write(c1);
                end; */
    end;

    local procedure HtmlEncode(InText: Text[1024]): Text[1024]
    var
        typeHelper: Codeunit "Type Helper";
    begin
        exit(typeHelper.HtmlEncode(InText));
    end;
}

