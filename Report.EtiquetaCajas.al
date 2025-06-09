report 56029 "Etiqueta Cajas"
{
    // ------------------------------------------------------------------------
    // No.         Firma   Fecha             Descripcion
    // ------------------------------------------------------------------------
    // #337        PLB     22/10/2013        Poder imprimir varias etiquetas al mismo tiempo
    // $001        JML     26/09/2014        Reprogramo la parte del fichero .bat porque da error de seguridad

    ProcessingOnly = true;

    dataset
    {
        dataitem("Cab. Packing Registrado"; "Cab. Packing Registrado")
        {
            dataitem("Lin. Packing Registrada"; "Lin. Packing Registrada")
            {
                DataItemLink = "No." = FIELD("No.");

                trigger OnAfterGetRecord()
                begin
                    //+#337
                    /**********************************************************************
                    UsrSetUp.GET(USERID);
                    UsrSetUp.TESTFIELD("Puerto Impresora Etiquetas");
                    UsrSetUp.TESTFIELD("Tipo Conexion Impr. Etiquetas");
                    UsrSetUp.TESTFIELD("Nombre Maquina Etiqueta Caja");
                    UsrSetUp.TESTFIELD("Nombre Impresora. Etiq. Caja");
                    ConfSant.GET;
                    ConfSant.TESTFIELD("Directorio temporal etiquetas");
                    CompInf.GET;
                    
                    RWAL.RESET;
                    RWAL.SETRANGE(RWAL."No.","Lin. Packing Registrada"."No. Picking");
                    IF RWAL.FINDFIRST THEN
                      BEGIN
                        IF RWAL."Source Type" = 37 THEN
                          BEGIN
                            SSH.RESET;
                            SSH.SETCURRENTKEY("Order No.");
                            SSH.SETRANGE("Order No.",RWAL."Source No.");
                            IF SSH.FINDFIRST THEN
                              BEGIN
                                IF PostCodes.GET(SSH."Sell-to Post Code",SSH."Sell-to City") THEN
                                  BEGIN
                                    Nombre := SSH."Sell-to Customer Name";
                                    Direccion := SSH."Ship-to Address";
                                    Direccion2 := SSH."Ship-to Address 2";
                                    Provincia := PostCodes.County;
                                    Departamento := PostCodes.Colonia;
                                    IF Pais.GET(SSH."Sell-to Country/Region Code") THEN;
                                    Ciudad := SSH."Ship-to City" +' - '+Provincia +' - '+Departamento+' - '+Pais.Name;
                                  END
                              END
                            ELSE
                              BEGIN
                                SH.RESET;
                                SH.SETCURRENTKEY("Document Type","No.");
                                SH.SETRANGE("Document Type",SH."Document Type"::Order);
                                SH.SETRANGE("No.",RWAL."Source No.");
                                IF SH.FINDFIRST THEN
                                    IF PostCodes.GET(SH."Sell-to Post Code",SH."Sell-to City") THEN
                                      BEGIN
                                        Nombre := SH."Sell-to Customer Name";
                                        Direccion := SH."Ship-to Address";
                                        Direccion2 := SH."Ship-to Address 2";
                                        Provincia := PostCodes.County;
                                        Departamento := PostCodes.Colonia;
                                        IF Pais.GET(SH."Sell-to Country/Region Code") THEN;
                                        Ciudad := SH."Ship-to City" +' - '+Provincia +' - '+Departamento+' - '+Pais.Name;
                                      END;
                              END;
                          END;
                      END;
                    
                    IF RWAL."Source Type" = 5741 THEN
                      BEGIN
                        TSH.RESET;
                        TSH.SETCURRENTKEY("Transfer Order No.");
                        TSH.SETRANGE("Transfer Order No.",RWAL."Source No.");
                        IF TSH.FINDFIRST THEN
                          BEGIN
                            IF PostCodes.GET(TSH."Transfer-to Post Code",TSH."Transfer-to City") THEN
                              BEGIN
                                Nombre := TSH."Transfer-to Name";
                                Direccion := TSH."Transfer-to Address";
                                Direccion2 := TSH."Transfer-to Address 2";
                                Provincia := PostCodes.County;
                                Departamento := PostCodes.Colonia;
                                //Ciudad := TSH."Transfer-to City";
                                IF Pais.GET(TSH."Trsf.-to Country/Region Code") THEN;
                                Ciudad := TSH."Transfer-to City" +' - '+Provincia +' - '+Departamento+' - '+Pais.Name;
                              END
                          END
                        ELSE
                          BEGIN
                            TH.RESET;
                            TH.SETRANGE("No.",RWAL."Source No.");
                            IF TH.FINDFIRST THEN
                              IF PostCodes.GET(TSH."Transfer-to Post Code",TSH."Transfer-to City") THEN
                                BEGIN
                                  Nombre := TSH."Transfer-to Name";
                                  Direccion := TSH."Transfer-to Address";
                                  Direccion2 := TSH."Transfer-to Address 2";
                                  Provincia := PostCodes.County;
                                  Departamento := PostCodes.Colonia;
                                  //Ciudad := TSH."Transfer-to City";
                                  IF Pais.GET(TSH."Trsf.-to Country/Region Code") THEN;
                                  Ciudad := TSH."Transfer-to City" +' - '+Provincia +' - '+Departamento+' - '+Pais.Name;
                                END
                          END;
                      END;
                    IF NOT FileOut.CREATE(ConfSant."Directorio temporal etiquetas"+FORMAT(USERID)+'.txt') THEN
                    FileOut.OPEN(ConfSant."Directorio temporal etiquetas"+FORMAT(USERID)+'.txt');
                    
                    FileOut.CREATEOUTSTREAM(StreamOut);
                    **********************************************************************/
                    //-#337

                    StreamOut.WriteText('^XA');
                    StreamOut.WriteText();
                    StreamOut.WriteText('^FO40,20^A0N,35,28^FD' + UpperCase(CompInf.Name) + '^FS');
                    StreamOut.WriteText();
                    StreamOut.WriteText('^FO590,20^A0N,25,28^FD' + 'Fecha: ' + Format(WorkDate) + '^FS');
                    StreamOut.WriteText('^FO40,60^A0N,35,20^FD' + txt006 + '^FS');
                    StreamOut.WriteText();
                    StreamOut.WriteText('^FO225,100^A0N,45,80^FD' + RWAL."Source No." + '^FS');
                    StreamOut.WriteText();
                    StreamOut.WriteText('^FO40,130^A0N,35,28^FD--------------------------------^FS');
                    StreamOut.WriteText();
                    StreamOut.WriteText('^FO40,160^A0N,25,28^FD' + 'Destinatario:' + '^FS');
                    StreamOut.WriteText();
                    StreamOut.WriteText('^FO40,185^A0N,35,28^FD' + Nombre + '^FS');
                    StreamOut.WriteText();
                    StreamOut.WriteText('^FO40,220^A0N,25,28^FD' + Direccion + '^FS');
                    StreamOut.WriteText();
                    StreamOut.WriteText('^FO40,250^A0N,25,28^FD' + Ciudad + '^FS');
                    StreamOut.WriteText();
                    StreamOut.WriteText('^FO40,280^A0N,25,28^FD' + Direccion2 + '^FS');
                    StreamOut.WriteText();

                    //Cantidad de Bultos
                    I := 0;
                    N := 0;

                    LPR.Reset;
                    LPR.SetRange("No.", "No.");
                    CantBult := LPR.Count;
                    if LPR.FindSet then
                        repeat
                            if (LPR."No." = "No.") and (LPR."No. Caja" = "No. Caja") then begin
                                I := 1;
                                N += 1;
                            end
                            else
                                N += 1;
                            LPR.Next;
                        until I = 1;

                    StreamOut.WriteText('^FO40,330^A0N,55,100^FD' + 'BULTO ' + Format(N) + '/' + Format(CantBult) + '^FS');
                    StreamOut.WriteText();
                    StreamOut.WriteText('^FO40,415^A0N,35,28^FD--------------------------------^FS');
                    StreamOut.WriteText();
                    CalcFields("Total de Productos");
                    StreamOut.WriteText('^FO240,395^A0N,35,28^FD' + 'Este bulto contiene ' + Format("Total de Productos") + ' ejemplares' + '^FS');
                    StreamOut.WriteText();

                    Contador := 415;
                    ContCajReg.Reset;
                    ContCajReg.SetRange("No. Packing", "No.");
                    ContCajReg.SetRange("No. Caja", "No. Caja");
                    if ContCajReg.FindSet then
                        repeat
                            Contador += 30;
                            ICR.Reset;
                            ICR.SetRange(ICR."Item No.", ContCajReg."No. Producto");
                            ICR.SetRange(ICR."Reference Type", ICR."Reference Type"::"Bar Code");
                            if ICR.FindFirst then
                                StreamOut.WriteText('^FO40,' + Format(Contador) + '^A0N,25,28^FD' + Format(ICR."Reference No.") + '^FS')
                            else
                                StreamOut.WriteText('^FO40,' + Format(Contador) + '^A0N,25,28^FD' + Format(ContCajReg."No. Producto") + '^FS');

                            StreamOut.WriteText();

                            StreamOut.WriteText('^FO240,' + Format(Contador) + '^A0N,25,28^FD' + Format(CopyStr(ContCajReg.Descripcion, 1, 32)) + '^FS');
                            StreamOut.WriteText();
                            StreamOut.WriteText('^FO730,' + Format(Contador) + '^A0N,25,28^FD' + Format(ContCajReg.Cantidad) + '^FS');
                            StreamOut.WriteText();
                        until ContCajReg.Next = 0;
                    StreamOut.WriteText('^XZ');
                    StreamOut.WriteText();

                    //+#337
                    /**********************************************************************
                    FileOut.CLOSE;
                    
                    IF ISSERVICETIER THEN
                      BEGIN
                        //El archivo fue creado en la carpeta C: del ServiceTier
                        //Por lo cual hay que pasarlo a la maquina local. Debe ser pasado a la carpeta temporal
                        //para evitar que al copiarse despliegue un cuadro de dialogo
                        MagicPath := FORMAT(USERID)+'.txt';
                        FileToDownload := ConfSant."Directorio temporal etiquetas"+FORMAT(USERID)+'.txt';
                        FileVar.OPEN(FileToDownload);
                        FileVar.CREATEINSTREAM(IStream);
                        DOWNLOADFROMSTREAM(IStream,'','<TEMP>', 'Text file(*.txt)|*.txt',MagicPath);
                        FileVar.CLOSE;
                    
                    
                        //Luego de copiado a al temporal, lo llevamos a una carpeta con un Path entendible
                        //por el automation wSHShell
                        CREATE(FileSystemObject,TRUE,TRUE);
                        DestinationFileName := ConfSant."Directorio temporal etiquetas"+FORMAT(USERID)+'.txt';
                        IF FileSystemObject.FileExists(DestinationFileName) THEN
                          FileSystemObject.DeleteFile(DestinationFileName,TRUE);
                        FileSystemObject.CopyFile(MagicPath,DestinationFileName);
                        FileSystemObject.DeleteFile(MagicPath,TRUE);
                        CLEAR(FileSystemObject);
                      END;
                    
                    
                    FileOut1.CREATE(ConfSant."Directorio temporal etiquetas"+FORMAT(USERID)+'.txt');
                    FileOut1.CREATEOUTSTREAM(StreamOut1);
                    IF UsrSetUp."Tipo Conexion Impr. Etiquetas" = UsrSetUp."Tipo Conexion Impr. Etiquetas"::"Terminal Service" THEN
                      BEGIN
                      //  StreamOut1.WRITETEXT('Net use '+ UsrSetUp."Puerto Impresora Etiquetas"+': '+'/DELETE');
                      //  StreamOut1.WRITETEXT();
                        StreamOut1.WRITETEXT('Net use '+UsrSetUp."Puerto Impresora Etiquetas"+' \\'+UsrSetUp."Nombre Maquina Etiqueta Caja"
                         +'\'+UsrSetUp."Nombre Impresora. Etiq. Caja" +' /PERSISTENT:Yes');
                        StreamOut1.WRITETEXT();
                       // ****Para que las impresora funcione en LPT1 hay que hacerle un Spooler por Windows****
                      END;
                    
                    
                    
                    StreamOut1.WRITETEXT('copy '+ConfSant."Directorio temporal etiquetas"+FORMAT(USERID)+'.txt'+' '
                    + UsrSetUp."Puerto Impresora Etiquetas");
                    StreamOut1.WRITETEXT();
                    FileOut1.CLOSE;
                    
                    IF ISSERVICETIER THEN
                      BEGIN
                        //El archivo fue creado en la carpeta C: del ServiceTier
                        //Por lo cual hay que pasarlo a la maquina local. Debe ser pasado a la carpeta temporal
                        //para evitar que al copiarse despliegue un cuadro de dialogo
                        MagicPathBat := FORMAT(USERID)+'.txt';
                        FileToDownload := ConfSant."Directorio temporal etiquetas"+FORMAT(USERID)+'.txt';
                        FileVar.OPEN(FileToDownload);
                        FileVar.CREATEINSTREAM(IStream);
                        DOWNLOADFROMSTREAM(IStream,'','<TEMP>', 'Text file(*.txt)|*.txt',MagicPathBat);
                        FileVar.CLOSE;
                    
                    
                        //Luego de copiado a al temporal, lo llevamos a una carpeta con un Path entendible
                        //por el automation wSHShell
                        CREATE(FileSystemObject,TRUE,TRUE);
                        DestinationFileName := ConfSant."Directorio temporal etiquetas"+FORMAT(USERID)+'.txt';
                        IF FileSystemObject.FileExists(DestinationFileName) THEN
                          FileSystemObject.DeleteFile(DestinationFileName,TRUE);
                        FileSystemObject.CopyFile(MagicPathBat,DestinationFileName);
                        FileSystemObject.DeleteFile(MagicPathBat,TRUE);
                        CLEAR(FileSystemObject);
                      END;
                    
                    CREATE(wSHShell,TRUE,ISSERVICETIER);
                    wSHShell.Run(ConfSant."Directorio temporal etiquetas"+FORMAT(USERID)+'.txt',dummyInt,_runModally);
                    CLEAR(wSHShell);
                    **********************************************************************/
                    //-#337

                end;
            }

            trigger OnAfterGetRecord()
            begin
                RWAL.Reset;
                RWAL.SetRange("No.", "Picking No.");
                if RWAL.FindFirst then begin
                    if RWAL."Source Type" = 37 then begin
                        SSH.Reset;
                        SSH.SetCurrentKey("Order No.");
                        SSH.SetRange("Order No.", RWAL."Source No.");
                        if SSH.FindFirst then begin
                            if PostCodes.Get(SSH."Sell-to Post Code", SSH."Sell-to City") then begin
                                Nombre := SSH."Sell-to Customer Name";
                                Direccion := SSH."Ship-to Address";
                                Direccion2 := SSH."Ship-to Address 2";
                                Provincia := PostCodes.County;
                                Departamento := PostCodes.Colonia;
                                if Pais.Get(SSH."Sell-to Country/Region Code") then;
                                Ciudad := SSH."Ship-to City" + ' - ' + Provincia + ' - ' + Departamento + ' - ' + Pais.Name;
                            end
                        end
                        else begin
                            SH.Reset;
                            SH.SetCurrentKey("Document Type", "No.");
                            SH.SetRange("Document Type", SH."Document Type"::Order);
                            SH.SetRange("No.", RWAL."Source No.");
                            if SH.FindFirst then
                                if PostCodes.Get(SH."Sell-to Post Code", SH."Sell-to City") then begin
                                    Nombre := SH."Sell-to Customer Name";
                                    Direccion := SH."Ship-to Address";
                                    Direccion2 := SH."Ship-to Address 2";
                                    Provincia := PostCodes.County;
                                    Departamento := PostCodes.Colonia;
                                    if Pais.Get(SH."Sell-to Country/Region Code") then;
                                    Ciudad := SH."Ship-to City" + ' - ' + Provincia + ' - ' + Departamento + ' - ' + Pais.Name;
                                end;
                        end;
                    end;

                    if RWAL."Source Type" = 5741 then begin
                        TSH.Reset;
                        TSH.SetCurrentKey("Transfer Order No.");
                        TSH.SetRange("Transfer Order No.", RWAL."Source No.");
                        if TSH.FindFirst then begin
                            if PostCodes.Get(TSH."Transfer-to Post Code", TSH."Transfer-to City") then begin
                                Nombre := TSH."Transfer-to Name";
                                Direccion := TSH."Transfer-to Address";
                                Direccion2 := TSH."Transfer-to Address 2";
                                Provincia := PostCodes.County;
                                Departamento := PostCodes.Colonia;
                                //Ciudad := TSH."Transfer-to City";
                                if Pais.Get(TSH."Trsf.-to Country/Region Code") then;
                                Ciudad := TSH."Transfer-to City" + ' - ' + Provincia + ' - ' + Departamento + ' - ' + Pais.Name;
                            end
                        end
                        else begin
                            TH.Reset;
                            TH.SetRange("No.", RWAL."Source No.");
                            if TH.FindFirst then
                                if PostCodes.Get(TSH."Transfer-to Post Code", TSH."Transfer-to City") then begin
                                    Nombre := TSH."Transfer-to Name";
                                    Direccion := TSH."Transfer-to Address";
                                    Direccion2 := TSH."Transfer-to Address 2";
                                    Provincia := PostCodes.County;
                                    Departamento := PostCodes.Colonia;
                                    //Ciudad := TSH."Transfer-to City";
                                    if Pais.Get(TSH."Trsf.-to Country/Region Code") then;
                                    Ciudad := TSH."Transfer-to City" + ' - ' + Provincia + ' - ' + Departamento + ' - ' + Pais.Name;
                                end
                        end;
                    end;
                end;
            end;

            trigger OnPostDataItem()
            var
                texComando: Text;
                texFrom: Text;
                texTo: Text;
            begin
                /*      FileOut.Close; */

              
                //El archivo fue creado en la carpeta C: del ServiceTier
                //Por lo cual hay que pasarlo a la maquina local. Debe ser pasado a la carpeta temporal
                //para evitar que al copiarse despliegue un cuadro de dialogo
                MagicPath := Format(FormatUser(UserId)) + '.txt';
                FileToDownload := ConfSant."Directorio temporal etiquetas" + Format(FormatUser(UserId)) + '.txt';
                /*                  FileVar.Open(FileToDownload);
                                  FileVar.CreateInStream(IStream);
                                  DownloadFromStream(IStream, '', '<TEMP>', 'Text file(*.txt)|*.txt', MagicPath);
                                  FileVar.Close; */


                //Luego de copiado a al temporal, lo llevamos a una carpeta con un Path entendible
                //por el automation wSHShell
                //Comentado Create(FileSystemObject, true, true);
                DestinationFileName := ConfSant."Directorio temporal etiquetas" + Format(FormatUser(UserId)) + '.txt';
                /*if FileSystemObject.FileExists(DestinationFileName) then //Comentado
                    FileSystemObject.DeleteFile(DestinationFileName, true);
                FileSystemObject.CopyFile(MagicPath, DestinationFileName);
                FileSystemObject.DeleteFile(MagicPath, true);
                Clear(FileSystemObject);*/
               

                /*  $001
                FileOut1.CREATE(ConfSant."Directorio temporal etiquetas"+FORMAT(USERID)+'.bat');
                FileOut1.CREATEOUTSTREAM(StreamOut1);
                IF UsrSetUp."Tipo Conexion Impr. Etiquetas" = UsrSetUp."Tipo Conexion Impr. Etiquetas"::"Terminal Service" THEN BEGIN
                  StreamOut1.WRITETEXT('Net use '+UsrSetUp."Puerto Impresora Etiquetas"+' \\'+UsrSetUp."Nombre Maquina Etiqueta Caja"
                   +'\'+UsrSetUp."Nombre Impresora. Etiq. Caja" +' /PERSISTENT:Yes');
                  StreamOut1.WRITETEXT();
                 // ****Para que las impresora funcione en LPT1 hay que hacerle un Spooler por Windows****
                END;
                
                StreamOut1.WRITETEXT('copy '+ConfSant."Directorio temporal etiquetas"+FORMAT(USERID)+'.txt'+' '
                + UsrSetUp."Puerto Impresora Etiquetas");
                StreamOut1.WRITETEXT();
                FileOut1.CLOSE;
                
                IF ISSERVICETIER THEN BEGIN
                  //El archivo fue creado en la carpeta C: del ServiceTier
                  //Por lo cual hay que pasarlo a la maquina local. Debe ser pasado a la carpeta temporal
                  //para evitar que al copiarse despliegue un cuadro de dialogo
                  MagicPathBat := FORMAT(USERID)+'.cmd';
                  FileToDownload := ConfSant."Directorio temporal etiquetas"+FORMAT(USERID)+'.cmd';
                  FileVar.OPEN(FileToDownload);
                  FileVar.CREATEINSTREAM(IStream);
                  DOWNLOADFROMSTREAM(IStream,'','<TEMP>', 'Text file(*.cmd)|*.cmd',MagicPathBat);
                  FileVar.CLOSE;
                
                
                  //Luego de copiado a al temporal, lo llevamos a una carpeta con un Path entendible
                  //por el automation wSHShell
                  CREATE(FileSystemObject,TRUE,TRUE);
                  DestinationFileName := ConfSant."Directorio temporal etiquetas"+FORMAT(USERID)+'.cmd';
                  IF FileSystemObject.FileExists(DestinationFileName) THEN
                    FileSystemObject.DeleteFile(DestinationFileName,TRUE);
                  FileSystemObject.CopyFile(MagicPathBat,DestinationFileName);
                  FileSystemObject.DeleteFile(MagicPathBat,TRUE);
                  CLEAR(FileSystemObject);
                END;
                
                CREATE(wSHShell,TRUE,ISSERVICETIER);
                wSHShell.Run(ConfSant."Directorio temporal etiquetas"+FORMAT(USERID)+'.cmd',dummyInt,_runModally);
                CLEAR(wSHShell);
                */

                //Comentado Create(wSHShell, true, IsServiceTier);
                if UsrSetUp."Tipo Conexion Impr. Etiquetas" = UsrSetUp."Tipo Conexion Impr. Etiquetas"::"Terminal Service" then begin
                    texComando := 'cmd /c Net use ' + UsrSetUp."Puerto Impresora Etiquetas" + ' \\' + UsrSetUp."Nombre Maquina Etiqueta Caja" + '\' + UsrSetUp."Nombre Impresora. Etiq. Caja" + ' /PERSISTENT:Yes';
                    //Comentado wSHShell.Run(texComando, dummyInt, _runModally);
                end;

                texComando := 'cmd /c copy ' + ConfSant."Directorio temporal etiquetas" + Format(FormatUser(UserId)) + '.txt' + ' ' + UsrSetUp."Puerto Impresora Etiquetas";
                //Comentado wSHShell.Run(texComando, dummyInt, _runModally);
                //Comentado Clear(wSHShell);
                //$001

            end;

            trigger OnPreDataItem()
            begin
                //+#337
                // Se ha añadido este dataitem

                if FilterNo <> '' then
                    SetFilter("No.", FilterNo);

                UsrSetUp.Get(UserId);
                UsrSetUp.TestField("Puerto Impresora Etiquetas");
                UsrSetUp.TestField("Tipo Conexion Impr. Etiquetas");
                if UsrSetUp."Tipo Conexion Impr. Etiquetas" = UsrSetUp."Tipo Conexion Impr. Etiquetas"::"Terminal Service" then begin
                    UsrSetUp.TestField("Nombre Maquina Etiqueta Caja");
                    UsrSetUp.TestField("Nombre Impresora. Etiq. Caja");
                end;
                ConfSant.Get;
                ConfSant.TestField("Directorio temporal etiquetas");
                CompInf.Get;

                /*                if not FileOut.Create(ConfSant."Directorio temporal etiquetas" + Format(FormatUser(UserId)) + '.txt') then
                                   FileOut.Open(ConfSant."Directorio temporal etiquetas" + Format(FormatUser(UserId)) + '.txt');

                               FileOut.CreateOutStream(StreamOut); */
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        FilterNo := "Cab. Packing Registrado".GetFilter("No.");
        if FilterNo = '' then
            FilterNo := "Lin. Packing Registrada".GetFilter("No.");
    end;

    var
        afile2: File;
        afile3: File;
        CommandProcessor: Text[1024];
        Variable1: Text[30];
        Variable2: Text[30];
        iShell: Integer;
        CompInf: Record "Company Information";
        Cust: Record Customer;
        RWAH: Record "Registered Whse. Activity Hdr.";
        RWAL: Record "Registered Whse. Activity Line";
        CPR: Record "Cab. Packing Registrado";
        LPR: Record "Lin. Packing Registrada";
        CantBult: Integer;
        I: Integer;
        N: Integer;
        ContCajReg: Record "Contenido Cajas Packing Reg.";
        Contador: Integer;
        ICR: Record "Item Reference";
        UsrSetUp: Record "User Setup";
        Pais: Record "Country/Region";
        //Comentado wSHShell: Automation;
        _commandLine: Text[100];
        _runModally: Boolean;
        dummyInt: Integer;
        StreamOut: OutStream;
        FileOut: File;
        StreamIn: InStream;
        FileIn: File;
        Error001: Label 'The File Could Not be Open';
        FileOut1: File;
        StreamOut1: OutStream;
        TextLine: Text[200];
        Direccion: Text[100];
        ToFile: Variant;
        ReturnValue: Boolean;
        Text006: Label 'Export';
        Text007: Label 'Import';
        Text009: Label 'All Files (*.*)|*.*';
        FuncSant: Codeunit "Funciones Santillana";
        Nombre: Text[1024];
        Posicion: Integer;
        Longitud: Integer;
        NombreCompleto: Text[1024];
        MagicPath: Text[180];
        FileToDownload: Text[180];
        FileVar: File;
        IStream: InStream;
        MagicPathBat: Text[180];
        //Comentado FileSystemObject: Automation;
        DestinationFileName: Text[200];
        txt005: Label 'c:\etiquetas\';
        ConfSant: Record "Config. Empresa";
        Alm: Record Location;
        SSH: Record "Sales Shipment Header";
        TSH: Record "Transfer Shipment Header";
        PostCodes: Record "Post Code";
        Provincia: Text[200];
        Departamento: Text[200];
        Direccion2: Text[200];
        Ciudad: Text[200];
        txt006: Label 'CENTRO DISTRIBUCION';
        SH: Record "Sales Header";
        TH: Record "Transfer Header";
        FilterNo: Text[250];


    procedure FormatUser(codPrmUsuario: Code[50]): Code[50]
    begin
        exit(DelChr(codPrmUsuario, '=', '\'));
    end;
}

