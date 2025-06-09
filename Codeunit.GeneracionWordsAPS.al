codeunit 76034 "Generacion Words APS"
{

    trigger OnRun()
    begin
        //GeneraWordSolicitudAsistencia('STYE-000011'); Para pruebas
    end;

    var
        chrPruebas: Char;


    procedure GeneraWordSolicitudAsistencia(codPrmSolicitud: Code[20])
    var
        recCfgAPS: Record "Commercial Setup";
        recSolicitud: Record "Solicitud de Taller - Evento";
        recColegio: Record Contact;
        texDistrito: Text[100];
        texDireccion: Text[250];
        texPlantillaDot: Text[255];
        texNombreCampo: Text[100];
        intFila: Integer;
        i: Integer;
        Error001: Label 'Debe cargar una plantilla Word (.dot) para la generación de la Solicitud de Asistencia Ténica pedagógica.';
        Error002: Label 'Debe indicar la ruta donde guardar la Solicitud de Asistencia Ténica pedagógica.';
        Text001: Label 'Solicitud  %1 %2 %3 %4.doc';
        texRuta: Text[1024];
        Text002: Label 'El documento Word se ha generado y guardado en la ruta: ';
        tipoPlantilla: Option Solicitud,PPFF,VisitasCA;
    begin
        //fes mig
        /*
        tipoPlantilla := tipoPlantilla::Solicitud;
        CREATE(wdApp, FALSE, TRUE);
        
        recCfgAPS.GET;
        recCfgAPS.CALCFIELDS("Plantilla Word sol. asis. tec.");
        IF NOT recCfgAPS."Plantilla Word sol. asis. tec.".HASVALUE THEN
          ERROR(Error001);
        
        IF recCfgAPS."Ruta Word sol. asis. tex." = '' THEN
          ERROR(Error002);
        
        texPlantillaDot := GuardarPlantillaTemp(recCfgAPS,tipoPlantilla);
        wdDoc := wdApp.Documents.Add(texPlantillaDot);
        wdApp.ActiveDocument.Fields.Update;
        
        
        WITH recSolicitud DO BEGIN
          GET(codPrmSolicitud);
          IF recColegio.GET("Cod. Colegio") THEN BEGIN
            texDistrito := recColegio.Distritos;
            texDireccion := recColegio.Address;
          END;
        
          //Bucle que recorre todos los campos y asigna valores
          FOR i := 1 TO wdApp.ActiveDocument.Fields.Count DO BEGIN
        
            wdField := wdApp.ActiveDocument.Fields.Item(i);
            wdRange := wdField.Code;
        
            IF wdField.Type = 59 THEN BEGIN                                          //Solo campos tipo MailMerge
        
              texNombreCampo := ExtraerNombreCampo(wdRange.Text);
              wdRange := wdApp.ActiveDocument.Fields.Item(i).Result;
        
              CASE texNombreCampo OF
                'NombreEmpresa'         : wdRange.Text := COMPANYNAME;
                'TipoEvento'            : wdRange.Text := "Tipo de Evento" + ' - ' + TraerDescripcionTipoEvento("Tipo de Evento");
                'Delegacion'            : wdRange.Text := Delegacion + ' - ' + TraerDescripcionDelegacion(Delegacion);
                'NoSolicitud'           : wdRange.Text := "No. Solicitud";
                'FechaSolicitud'        : wdRange.Text := FORMAT("Fecha Solicitud");
                'Estado'                : wdRange.Text := FORMAT(recSolicitud.Status);
                'DescripcionSolicitud'  : wdRange.Text := Descripcion;
                'Expositor'             : wdRange.Text := "Cod. Expositor" + ' - ' + "Nombre expositor";
                'Esperados'             : wdRange.Text := FORMAT("Asistentes Esperados");
                'Promotor'              : wdRange.Text := "Cod. promotor" + ' - ' + "Nombre promotor";
                'Objetivo'              : wdRange.Text := "Objetivo promotor";
                'EventoProp'            : wdRange.Text := "Cod. evento" + ' - ' + "Descripcion evento";
                'EventoProg'            : wdRange.Text := "Cod. evento programado" + ' - ' + "Descripción evento programado";
                'Colegio'               : wdRange.Text := "Cod. Colegio" + ' - ' + "Nombre Colegio";
                'Distrito'              : wdRange.Text := texDistrito;
                'Local'                 : wdRange.Text := "Cod. Local" + ' - ' + TraerDescripcionLocal("Cod. Colegio","Cod. Local");
                'Nivel'                 : wdRange.Text := "Cod. Nivel" + ' - ' + TraerDescripcionNivel("Cod. Nivel");
                'Turno'                 : wdRange.Text := "Cod. Turno" + ' - ' + TraerDescripcionTurno("Cod. Turno");
                'Direccion'             : wdRange.Text := texDireccion;
                'Referencia'            : wdRange.Text := Referencia;
                'Telefono'              : wdRange.Text := "Telefono 1 Colegio" +', '+ "No. celular responsable";
                'CodRepresentante'      : wdRange.Text := "Cod. Docente responsable";
                'NombreRepresentante'   : wdRange.Text := "Nombre responsable";
                'TelefonoRepresentante' : wdRange.Text := "Telefono Responsable";
                'CelularRepresentante'  : wdRange.Text := "Celular Responsable";
                'CorreoRepresentante'   : wdRange.Text := "E-Mail Docente Responsable";
                'Observaciones'         : wdRange.Text := Observaciones;
                'Programacion'          : InsertarTablaProgamacion(recSolicitud,wdApp,wdRange);
                'Asistentes'            : InsertarTablaAsistentes(recSolicitud,wdApp,wdRange);
                'Textos'                : InsertarTablaTextos(recSolicitud,wdApp,wdRange);
                'Competencia'           : InsertarTablaCompetencia(recSolicitud,wdApp,wdRange);
                'MatRev'                : wdRange.Text := FORMAT(recSolicitud."Material para revisión");
              END;
            END;
          END;
        END;
        
        //wdApp.Visible := TRUE;
        
        texRuta := recCfgAPS."Ruta Word sol. asis. tex.";
        
        IF texRuta[STRLEN(texRuta)] <> '\' THEN
          texRuta := texRuta+'\';
        
        texRuta := texRuta+STRSUBSTNO(Text001,codPrmSolicitud,recSolicitud."Grupo de Negocio",COPYSTR(recSolicitud."Nombre expositor",1,25),
                                       FORMAT(recSolicitud.GetFechaProgramada(),0,'<Day,2>-<Month,2>-<Year>') );
        
        wdApp.ActiveDocument.Fields.Unlink;
        wdDoc.SaveAs(texRuta);
        wdDoc.Close;
        
        MESSAGE('%1 %2', Text002, texRuta);
        */
        //fes mig

    end;


    procedure ExtraerNombreCampo(texPrmNombre: Text[1024]): Text[100]
    var
        Text001: Label 'Tipo de campo %1 incorrecto';
        texTipoMerge: Label 'MERGEFIELD';
        intPos: Integer;
        texNombre: Text[100];
    begin
        intPos := StrPos(texPrmNombre, '\*');

        if intPos = 0 then
            Error(Text001, texPrmNombre);

        texNombre := CopyStr(texPrmNombre, 14, intPos - 16);
        exit(texNombre);
    end;

    local procedure InsertarTablaProgamacion(recPrmSolicitud: Record "Solicitud de Taller - Evento")
    var
        recProgramacion: Record "Programac. Talleres y Eventos";
        intFila: Integer;
        Text001: Label 'Propuesto';
        Text002: Label 'Fecha';
        Text003: Label 'Hora inicio';
        Text004: Label 'Hora final';
        recCabPlan: Record "Cab. Planif. Evento";
        Text005: Label 'Programado';
        Text006: Label 'Solo C.C.';
        Text007: Label 'Grado';
        Text008: Label 'Cant.';
        ncol: Integer;
        Text009: Label 'Horario';
    begin
        //fes mig
        /*
        //Genera Tabla con la programación
        intFila := 1;
        
        
        recCabPlan.RESET;
        recCabPlan.SETRANGE(recCabPlan."No. Solicitud", recPrmSolicitud."No. Solicitud");
        IF NOT recCabPlan.FINDSET THEN BEGIN
          autPrmRange.Text := '';
          EXIT;
        END;
        recProgramacion.RESET;
        recProgramacion.SETRANGE("Cod. Taller - Evento",recCabPlan."Cod. Taller - Evento");
        recProgramacion.SETRANGE("Tipo Evento",recCabPlan."Tipo Evento");
        recProgramacion.SETRANGE("Tipo de Expositor", recCabPlan."Tipo de Expositor");
        recProgramacion.SETRANGE(Expositor, recCabPlan.Expositor);
        recProgramacion.SETRANGE(Secuencia, recCabPlan.Secuencia);
        IF recProgramacion.FINDSET THEN BEGIN
        
          wdTable := autPrmApp.ActiveDocument.Tables.Add(autPrmRange, recProgramacion.COUNT+4, 8);
        
          wdTable.Cell(intFila,1).Range.InsertAfter(Text009);
          wdTable.Cell(intFila,1).Range.Bold := 1;
          wdTable.Cell(intFila,1).Range.Font.Size := 10;
          intFila += 1;
        
          wdTable.Cell(intFila,1).Range.InsertAfter(' ');
          wdTable.Cell(intFila,1).Range.Bold := 1;
          wdTable.Cell(intFila,1).Range.Font.Size := 8;
          intFila += 1;
        
          wdTable.Cell(intFila,1).Range.InsertAfter(Text001);
          wdTable.Cell(intFila,1).Range.Bold := 1;
          wdTable.Cell(intFila,1).Range.Font.Size := 8;
        
        
          wdTable.Cell(intFila,4).Range.InsertAfter(Text005);
          wdTable.Cell(intFila,4).Range.Bold := 1;
          wdTable.Cell(intFila,4).Range.Font.Size := 8;
        
          wdTable.Cell(intFila,7).Range.InsertAfter(Text006);
          wdTable.Cell(intFila,7).Range.Bold := 1;
          wdTable.Cell(intFila,7).Range.Font.Size := 8;
        
          wdTable.Cell(intFila,1).Range.Borders.Item(1).LineStyle :=  1;
          wdTable.Cell(intFila,1).Range.Borders.Item(2).LineStyle :=  1;
          wdTable.Cell(intFila,1).Range.Borders.Item(3).LineStyle :=  1;
          wdTable.Cell(intFila,2).Range.Borders.Item(1).LineStyle :=  1;
          wdTable.Cell(intFila,3).Range.Borders.Item(1).LineStyle :=  1;
          wdTable.Cell(intFila,4).Range.Borders.Item(1).LineStyle :=  1;
          wdTable.Cell(intFila,4).Range.Borders.Item(2).LineStyle :=  1;
          wdTable.Cell(intFila,4).Range.Borders.Item(3).LineStyle :=  1;
          wdTable.Cell(intFila,5).Range.Borders.Item(1).LineStyle :=  1;
          wdTable.Cell(intFila,6).Range.Borders.Item(1).LineStyle :=  1;
          wdTable.Cell(intFila,7).Range.Borders.Item(1).LineStyle :=  1;
          wdTable.Cell(intFila,7).Range.Borders.Item(2).LineStyle :=  1;
          wdTable.Cell(intFila,7).Range.Borders.Item(3).LineStyle :=  1;
          wdTable.Cell(intFila,8).Range.Borders.Item(1).LineStyle :=  1;
          wdTable.Cell(intFila,8).Range.Borders.Item(3).LineStyle :=  1;
          wdTable.Cell(intFila,8).Range.Borders.Item(4).LineStyle :=  1;
        
        
          intFila += 1;
        
          wdTable.Cell(intFila,1).Range.InsertAfter(Text002);
          wdTable.Cell(intFila,1).Range.Bold := 1;
          wdTable.Cell(intFila,1).Range.Font.Size := 8;
        
          wdTable.Cell(intFila,2).Range.InsertAfter(Text003);
          wdTable.Cell(intFila,2).Range.Bold := 1;
          wdTable.Cell(intFila,2).Range.Font.Size := 8;
        
          wdTable.Cell(intFila,3).Range.InsertAfter(Text004);
          wdTable.Cell(intFila,3).Range.Bold := 1;
          wdTable.Cell(intFila,3).Range.Font.Size := 8;
        
          wdTable.Cell(intFila,4).Range.InsertAfter(Text002);
          wdTable.Cell(intFila,4).Range.Bold := 1;
          wdTable.Cell(intFila,4).Range.Font.Size := 8;
        
          wdTable.Cell(intFila,5).Range.InsertAfter(Text003);
          wdTable.Cell(intFila,5).Range.Bold := 1;
          wdTable.Cell(intFila,5).Range.Font.Size := 8;
        
          wdTable.Cell(intFila,6).Range.InsertAfter(Text004);
          wdTable.Cell(intFila,6).Range.Bold := 1;
          wdTable.Cell(intFila,6).Range.Font.Size := 8;
        
          wdTable.Cell(intFila,7).Range.InsertAfter(Text007);
          wdTable.Cell(intFila,7).Range.Bold := 1;
          wdTable.Cell(intFila,7).Range.Font.Size := 8;
        
          wdTable.Cell(intFila,8).Range.InsertAfter(Text008);
          wdTable.Cell(intFila,8).Range.Bold := 1;
          wdTable.Cell(intFila,8).Range.Font.Size := 8;
        
          FOR ncol := 1 TO 8 DO BEGIN
            wdTable.Cell(intFila,ncol).Range.Borders.Item(1).LineStyle :=  1;
            wdTable.Cell(intFila,ncol).Range.Borders.Item(2).LineStyle :=  1;
            wdTable.Cell(intFila,ncol).Range.Borders.Item(3).LineStyle :=  1;
            wdTable.Cell(intFila,ncol).Range.Borders.Item(4).LineStyle :=  1;
          END;
        
          REPEAT
            intFila += 1;
            wdTable.Cell(intFila,1).Range.InsertAfter(FORMAT(recProgramacion."Fecha propuesta"));
            wdTable.Cell(intFila,2).Range.InsertAfter(FORMAT(recProgramacion."Hora Inicio Propuesta"));
            wdTable.Cell(intFila,3).Range.InsertAfter(FORMAT(recProgramacion."Hora Fin Propuesta"));
            wdTable.Cell(intFila,4).Range.InsertAfter(FORMAT(recProgramacion."Fecha programacion"));
            wdTable.Cell(intFila,5).Range.InsertAfter(FORMAT(recProgramacion."Hora de Inicio"));
            wdTable.Cell(intFila,6).Range.InsertAfter(FORMAT(recProgramacion."Hora Final"));
            IF recProgramacion."Cod. Grado" <> '' THEN BEGIN
              wdTable.Cell(intFila,7).Range.InsertAfter(FORMAT(recProgramacion."Cod. Grado"));
              wdTable.Cell(intFila,8).Range.InsertAfter(FORMAT(recProgramacion."Nro. De asistentes reales"));
            END;
            FOR ncol := 1 TO 8 DO BEGIN
              wdTable.Cell(intFila,ncol).Range.Font.Size := 8;
              wdTable.Cell(intFila,ncol).Range.Borders.Item(2).LineStyle :=  1;
              //wdTable.Cell(intFila,ncol).Range.Borders.Item(3).LineStyle :=  1;//INFERIOR
              wdTable.Cell(intFila,ncol).Range.Borders.Item(4).LineStyle :=  1;
            END;
        
          UNTIL recProgramacion.NEXT = 0;
          FOR ncol := 1 TO 8 DO
            wdTable.Cell(intFila,ncol).Range.Borders.Item(3).LineStyle :=  1;//INFERIOR
        
          wdTable.AutoFitBehavior := 1;  //Ajustar al contenido
        END
        ELSE
          autPrmRange.Text := '';
        */
        //fes mig

    end;

    local procedure InsertarTablaAsistentes2(recPrmSolicitud: Record "Solicitud de Taller - Evento")
    var
        recAsistentes: Record "Asistentes Talleres y Eventos";
        intFila: Integer;
        Text001: Label 'Asistentes';
        Text002: Label 'Cód. docente';
        Text003: Label 'Nombre';
        Text004: Label 'Nivel';
        recProgramacion: Record "Programac. Talleres y Eventos";
        recCabPlan: Record "Cab. Planif. Evento";
    begin
        //fes mig
        /*
        //Genera Tabla con la asistentes
        intFila := 1;
        
        recCabPlan.RESET;
        recCabPlan.SETRANGE(recCabPlan."No. Solicitud",recPrmSolicitud."No. Solicitud");
        IF NOT recCabPlan.FINDSET THEN
          EXIT;
        
        
        recProgramacion.RESET;
        recProgramacion.SETRANGE("Cod. Taller - Evento",recCabPlan."Cod. Taller - Evento");
        recProgramacion.SETRANGE("Tipo Evento",recCabPlan."Tipo Evento");
        recProgramacion.SETRANGE("Tipo de Expositor", recCabPlan."Tipo de Expositor");
        recProgramacion.SETRANGE(Expositor, recCabPlan.Expositor);
        recProgramacion.SETRANGE(Secuencia, recCabPlan.Secuencia);
        IF recProgramacion.FINDSET THEN BEGIN
          REPEAT
            recAsistentes.RESET;
            recAsistentes.SETRANGE("Cod. Taller - Evento",recPrmSolicitud."Cod. evento");
            recAsistentes.SETRANGE("Tipo Evento",recPrmSolicitud."Tipo de Evento");
            recAsistentes.SETRANGE("Tipo de Expositor", recCabPlan."Tipo de Expositor");
            recAsistentes.SETRANGE("Cod. Expositor", recCabPlan.Expositor);
            recAsistentes.SETRANGE(Secuencia, recCabPlan.Secuencia);
            IF recAsistentes.FINDSET THEN BEGIN
        
              wdTable := autPrmApp.ActiveDocument.Tables.Add(autPrmRange, recAsistentes.COUNT+1, 4);
              wdTable.Cell(intFila,1).Range.InsertAfter(Text001);
              wdTable.Cell(intFila,1).Range.Bold := 1;
              wdTable.Cell(intFila,1).Range.Font.Size := 10;
        
              wdTable.Cell(intFila,2).Range.InsertAfter(Text002);
              wdTable.Cell(intFila,2).Range.Bold := 1;
              wdTable.Cell(intFila,3).Range.InsertAfter(Text003);
              wdTable.Cell(intFila,3).Range.Bold := 1;
              wdTable.Cell(intFila,4).Range.InsertAfter(Text004);
              wdTable.Cell(intFila,4).Range.Bold := 1;
        
              REPEAT
                intFila += 1;
                wdTable.Cell(intFila,2).Range.InsertAfter(recAsistentes."Cod. Docente");
                wdTable.Cell(intFila,3).Range.InsertAfter(recAsistentes."Nombre Docente");
                wdTable.Cell(intFila,4).Range.InsertAfter(TraerNivelDocente(recAsistentes."Cod. Docente"));
              UNTIL recAsistentes.NEXT = 0;
        
              wdTable.AutoFitBehavior := 1;  //Ajustar al contenido
        
            END
            ELSE
              autPrmRange.Text := '';
          UNTIL recAsistentes.NEXT=0;
        END;
        */
        //fes mig

    end;

    local procedure InsertarTablaMaterial2(recPrmSolicitud: Record "Solicitud de Taller - Evento")
    var
        recMaterial: Record "Materiales Talleres y Eventos";
        intFila: Integer;
        Text001: Label 'Material';
        Text002: Label 'Código';
        Text003: Label 'Descripción';
        Text004: Label 'Grado';
    begin
        //fes mig
        /*
        //Genera Tabla con el Material
        intFila := 1;
        recMaterial.RESET;
        recMaterial.SETRANGE("Cod. Taller - Evento",recPrmSolicitud."Cod. evento");
        recMaterial.SETRANGE("Tipo Evento",recPrmSolicitud."Tipo de Evento");
        IF recMaterial.FINDSET THEN BEGIN
        
          wdTable := autPrmApp.ActiveDocument.Tables.Add(autPrmRange, recMaterial.COUNT+1, 4);
        
          wdTable.Cell(intFila,1).Range.InsertAfter(Text001);
          wdTable.Cell(intFila,1).Range.Bold := 1;
          wdTable.Cell(intFila,1).Range.Font.Size := 10;
        
          wdTable.Cell(intFila,2).Range.InsertAfter(Text002);
          wdTable.Cell(intFila,2).Range.Bold := 1;
          wdTable.Cell(intFila,3).Range.InsertAfter(Text003);
          wdTable.Cell(intFila,3).Range.Bold := 1;
          wdTable.Cell(intFila,4).Range.InsertAfter(Text004);
          wdTable.Cell(intFila,4).Range.Bold := 1;
        
          REPEAT
            intFila += 1;
            wdTable.Cell(intFila,2).Range.InsertAfter(recMaterial."Codigo Material");
            wdTable.Cell(intFila,3).Range.InsertAfter(recMaterial."Description Material");
            wdTable.Cell(intFila,4).Range.InsertAfter(TraerGradoMaterial(recMaterial));
          UNTIL recMaterial.NEXT = 0;
        
          wdTable.AutoFitBehavior := 1;  //Ajustar al contenido
        END
        ELSE
          autPrmRange.Text := '';
        */
        //fes mig

    end;

    local procedure TraerGradoMaterial(recPrmMaterial: Record "Materiales Talleres y Eventos"): Code[20]
    var
        recProducto: Record Item;
    begin
        if recPrmMaterial."Tipo de Material" = recPrmMaterial."Tipo de Material"::Producto then
            if recProducto.Get(recPrmMaterial."Codigo Material") then
                exit(recProducto."Nivel Escolar (Grado)");
    end;

    local procedure TraerDescripcionTurno(codPrmTurno: Code[20]): Text[100]
    var
        recTurno: Record "Datos auxiliares";
    begin
        if recTurno.Get(recTurno."Tipo registro"::Turnos, codPrmTurno) then
            exit(recTurno.Descripcion);
    end;

    local procedure TraerDescripcionLocal(codPrmColegio: Code[20]; codPrmLocal: Code[20]): Text[250]
    var
        recLocal: Record "Contact Alt. Address";
    begin
        if recLocal.Get(codPrmColegio, codPrmLocal) then
            exit(recLocal.Code + ' - ' + recLocal."Company Name" + ' - ' + recLocal.Address + ' - ' + recLocal.City);
    end;

    local procedure TraerDescripcionNivel(codPrmNivel: Code[20]): Text[100]
    var
        recNivel: Record "Nivel Educativo APS";
    begin
        if recNivel.Get(codPrmNivel) then
            exit(recNivel.Descripción);
    end;

    local procedure TraerDescripcionTipoEvento(codPrmTipoEvento: Code[20]): Text[100]
    var
        recTipoEvento: Record "Tipos de Eventos";
    begin
        if recTipoEvento.Get(codPrmTipoEvento) then
            exit(recTipoEvento.Descripcion);
    end;

    local procedure TraerNivelDocente(codPrmDocente: Code[20]): Text[100]
    var
        recDocente: Record Docentes;
        recNivel: Record "Nivel Educativo APS";
    begin
        if recDocente.Get(codPrmDocente) then
            if recNivel.Get(recDocente."Nivel Docente") then
                exit(recNivel.Descripción);
    end;


    procedure GuardarPlantillaTemp(var recCfgAPS: Record "Commercial Setup"; Tipo: Option Solicitud,PPFF,VisitasCA): Text[255]
    var
        Text001: Label 'Export to XML File';
        Text002: Label 'XML Files (*.xml)|*.xml|All Files (*.*)|*.*';
        Text003: Label 'Default.xml';
        filFile: File;
        texFileName: Text[255];
        outPlantilla: OutStream;
        insPlantilla: InStream;
        ServerFileName: Text[1024];
        Text0022: Label 'XML Files (*.xml)|*.xml|All Files (*.*)|*.*';
        ToFile: Text[1024];
        RBMgt: Codeunit "File Management";
    begin

        /* filFile.CreateTempFile;
        texFileName := filFile.Name;
        filFile.Close;

        filFile.Create(texFileName);
        filFile.CreateOutStream(outPlantilla);
        case Tipo of
            Tipo::Solicitud:
                recCfgAPS."Plantilla Word sol. asis. tec.".CreateInStream(insPlantilla);
            Tipo::PPFF:
                recCfgAPS."Plantilla Word ficha de PPFF".CreateInStream(insPlantilla);
            Tipo::VisitasCA:
                recCfgAPS."Plantilla Word Visitas C/A".CreateInStream(insPlantilla);
        end;
        CopyStream(outPlantilla, insPlantilla);
        filFile.Close;

        ToFile := Text003;
        Download(texFileName, Text001, Magicpath, Text002, ToFile); */


        exit(ToFile);
    end;


    procedure GeneraWordPPFF(codPrmSolicitud: Code[20])
    var
        recCfgAPS: Record "Commercial Setup";
        recSolicitud: Record "Solicitud de Taller - Evento";
        recColegio: Record Contact;
        texDistrito: Text[100];
        texDireccion: Text[250];
        texPlantillaDot: Text[255];
        texNombreCampo: Text[100];
        intFila: Integer;
        i: Integer;
        Error001: Label 'Debe cargar una plantilla Word (.dot) para la generación de la la ficha de PP.FF.';
        Error002: Label 'Debe indicar la ruta donde guardar la ficha de PP.FF.';
        Text001: Label 'Ficha de PPFF %1.doc';
        texRuta: Text[1024];
        Text002: Label 'El documento Word se ha generado y guardado en la ruta: ';
        tipoPlantilla: Option Solicitud,PPFF,VisitasCA;
        recCabPlan: Record "Cab. Planif. Evento";
        recProgramacion: Record "Programac. Talleres y Eventos";
        textFechaProg: Text[30];
        textHoraInicio: Text[30];
        textHoraFin: Text[30];
        ToFile: Text[255];
    begin
        //fes mig
        /*
        tipoPlantilla := tipoPlantilla::PPFF;
        CREATE(wdApp, FALSE, TRUE);
        
        recCfgAPS.GET;
        recCfgAPS.CALCFIELDS("Plantilla Word ficha de PPFF");
        IF NOT recCfgAPS."Plantilla Word ficha de PPFF".HASVALUE THEN
          ERROR(Error001);
        
        IF recCfgAPS."Ruta Word ficha de PPFF" = '' THEN
          ERROR(Error002);
        
        texPlantillaDot := GuardarPlantillaTemp(recCfgAPS,tipoPlantilla);
        wdDoc := wdApp.Documents.Add(texPlantillaDot);
        wdApp.ActiveDocument.Fields.Update;
        
        
        WITH recSolicitud DO BEGIN
          GET(codPrmSolicitud);
          IF recColegio.GET("Cod. Colegio") THEN BEGIN
            texDistrito := recColegio.Distritos;
            texDireccion := recColegio.Address +' '+ recColegio."Address 2";
          END;
        
          recCabPlan.RESET;
          recCabPlan.SETRANGE(recCabPlan."No. Solicitud",codPrmSolicitud);
          IF recCabPlan.FINDSET THEN BEGIN
            recProgramacion.RESET;
            recProgramacion.SETRANGE("Cod. Taller - Evento",recCabPlan."Cod. Taller - Evento");
            recProgramacion.SETRANGE("Tipo Evento",recCabPlan."Tipo Evento");
            recProgramacion.SETRANGE("Tipo de Expositor", recCabPlan."Tipo de Expositor");
            recProgramacion.SETRANGE(Expositor, recCabPlan.Expositor);
            recProgramacion.SETRANGE(Secuencia, recCabPlan.Secuencia);
            IF recProgramacion.FINDSET THEN BEGIN
              textFechaProg   := FORMAT(recProgramacion."Fecha programacion");
              textHoraInicio  := FORMAT(recProgramacion."Hora de Inicio");
              textHoraFin     := FORMAT(recProgramacion."Hora Final");
            END;
          END;
        
          //Bucle que recorre todos los campos y asigna valores
          FOR i := 1 TO wdApp.ActiveDocument.Fields.Count DO BEGIN
        
            wdField := wdApp.ActiveDocument.Fields.Item(i);
            wdRange := wdField.Code;
        
            IF wdField.Type = 59 THEN BEGIN                                          //Solo campos tipo MailMerge
              texNombreCampo := ExtraerNombreCampo(wdRange.Text);
              wdRange := wdApp.ActiveDocument.Fields.Item(i).Result;
              CASE texNombreCampo OF
                'NomPromotor'           : BEGIN wdRange.Text := "Nombre promotor"; END;
                'NomColegio'            : BEGIN wdRange.Text := "Nombre Colegio";  END;
                'Distrito'              : BEGIN wdRange.Text := texDistrito;  END;
                'NomSolicitante'        : BEGIN wdRange.Text := "Nombre responsable";  END;
                'EmailSolicitante'      : BEGIN wdRange.Text := "E-Mail Docente Responsable";  END;
                'NomTaller'             : BEGIN wdRange.Text := "Descripcion evento";    END;
                'FechaProg'             : BEGIN wdRange.Text := textFechaProg;  END;
                'Hini'                  : BEGIN wdRange.Text := textHoraInicio;  END;
                'Hfin'                  : BEGIN wdRange.Text := textHoraFin;  END;
                'Cargo'                 : BEGIN wdRange.Text := "Descripción Cargo Responsable";  END;
                'Telef'                 : BEGIN wdRange.Text := "Celular Responsable";  END;
                'NumSol'                : BEGIN wdRange.Text := codPrmSolicitud;  END;
                'Esp'                   : BEGIN wdRange.Text := FORMAT("Asistentes Esperados");  END;
              END;
            END;
          END;
        
        END;
        
        //wdApp.Visible := TRUE;
        
        texRuta := recCfgAPS."Ruta Word ficha de PPFF";
        IF texRuta[STRLEN(texRuta)] <> '\' THEN
          texRuta := texRuta+'\';
        texRuta := texRuta+STRSUBSTNO(Text001, codPrmSolicitud);
        
        wdApp.ActiveDocument.Fields.Unlink;
        wdDoc.SaveAs(texRuta);
        wdDoc.Close;
        
        MESSAGE('%1 %2', Text002, texRuta);
        */
        //fes mig

    end;


    procedure Magicpath(): Text[1024]
    begin
        exit('<TEMP>');   // MAGIC PATH makes sure we don't get a prompt
    end;


    procedure TraerDescripcionDelegacion(codDelegacion: Code[20]): Text[100]
    var
        recDelegacion: Record "Dimension Value";
    begin
        if codDelegacion = '' then
            exit('');
        if recDelegacion.Get('DELEGACION', codDelegacion) then
            exit(recDelegacion.Name);
    end;

    local procedure InsertarTablaAsistentes(recPrmSolicitud: Record "Solicitud de Taller - Evento")
    var
        recAsistentes: Record "Asistentes Talleres y Eventos";
        intFila: Integer;
        Text001: Label 'Asistentes';
        Text002: Label 'Especialidad';
        Text003: Label 'Grado';
        Text004: Label 'Nivel';
        recProgramacion: Record "Programac. Talleres y Eventos";
        recCabPlan: Record "Cab. Planif. Evento";
        recNivel: Record "Solicitud -  Nivel Asistente";
        recGrado: Record "Solicitud -  Grado Asistente";
        recEspec: Record "Solicitud -  Especialidad Asi.";
        lineas: Integer;
        nCol: Integer;
    begin
        //fes mig
        /*
        //Genera Tabla con la asistentes
        
        recNivel.SETRANGE(recNivel."No. Solicitud", recPrmSolicitud."No. Solicitud");
        lineas := recNivel.COUNT;
        recGrado.SETRANGE(recGrado."No. Solicitud", recPrmSolicitud."No. Solicitud");
        IF lineas < recGrado.COUNT THEN
          lineas := recGrado.COUNT;
        recEspec.SETRANGE(recEspec."No. Solicitud", recPrmSolicitud."No. Solicitud");
        IF lineas < recEspec.COUNT THEN
          lineas := recEspec.COUNT;
        
        IF lineas > 0 THEN BEGIN
        
          wdTable := autPrmApp.ActiveDocument.Tables.Add(autPrmRange, lineas+3, 3);
        
          intFila := 1;
        
          wdTable.Cell(intFila,1).Range.InsertAfter(Text001);
          wdTable.Cell(intFila,1).Range.Bold := 1;
          wdTable.Cell(intFila,1).Range.Font.Size := 10;
        
          intFila := 2;
          wdTable.Cell(intFila,1).Range.InsertAfter(' ');
          wdTable.Cell(intFila,1).Range.Bold := 1;
          wdTable.Cell(intFila,1).Range.Font.Size := 8;
        
          intFila := 3;
        
          wdTable.Cell(intFila,1).Range.InsertAfter(Text002);
          wdTable.Cell(intFila,1).Range.Bold := 1;
          wdTable.Cell(intFila,1).Range.Font.Size := 8;
          wdTable.Cell(intFila,2).Range.InsertAfter(Text003);
          wdTable.Cell(intFila,2).Range.Bold := 1;
          wdTable.Cell(intFila,2).Range.Font.Size := 8;
          wdTable.Cell(intFila,3).Range.InsertAfter(Text004);
          wdTable.Cell(intFila,3).Range.Bold := 1;
          wdTable.Cell(intFila,3).Range.Font.Size := 8;
        
          FOR nCol := 1 TO 3 DO BEGIN
            wdTable.Cell(intFila,nCol).Range.Borders.Item(1).LineStyle :=  1;
            wdTable.Cell(intFila,nCol).Range.Borders.Item(2).LineStyle :=  1;
            wdTable.Cell(intFila,nCol).Range.Borders.Item(3).LineStyle :=  1;
            wdTable.Cell(intFila,nCol).Range.Borders.Item(4).LineStyle :=  1;
          END;
        
          intFila := 3;
          IF recNivel.FINDSET THEN
           REPEAT
             intFila += 1;
             wdTable.Cell(intFila,1).Range.InsertAfter(recNivel.Descripción);
           UNTIL recNivel.NEXT=0;
        
          intFila := 3;
          IF recGrado.FINDSET THEN
           REPEAT
             intFila += 1;
             wdTable.Cell(intFila,2).Range.InsertAfter(recGrado.Descripción);
           UNTIL recGrado.NEXT=0;
        
          intFila := 3;
          IF recEspec.FINDSET THEN
           REPEAT
             intFila += 1;
             wdTable.Cell(intFila,3).Range.InsertAfter(recEspec.Descripción);
           UNTIL recEspec.NEXT=0;
        
        
          FOR intFila:=4 TO (lineas + 3) DO BEGIN
              FOR nCol := 1 TO 3 DO BEGIN
                wdTable.Cell(intFila,nCol).Range.Font.Size := 8;
                wdTable.Cell(intFila,nCol).Range.Borders.Item(2).LineStyle :=  1;
                wdTable.Cell(intFila,nCol).Range.Borders.Item(4).LineStyle :=  1;
              END;
          END;
        
          FOR nCol := 1 TO 3 DO
            wdTable.Cell(lineas + 3,nCol).Range.Borders.Item(3).LineStyle :=  1;//INFERIOR
        
          wdTable.AutoFitBehavior := 1;  //Ajustar al contenido
        END
        ELSE
          autPrmRange.Text := '';
        */
        //fes mig

    end;

    local procedure InsertarTablaTextos(recPrmSolicitud: Record "Solicitud de Taller - Evento")
    var
        intFila: Integer;
        Text001: Label 'Textos que utilizan';
        Text002: Label 'Editorial';
        Text003: Label 'Cód. Artículo';
        Text004: Label 'Descripción';
        recAdop: Record "Historico Adopciones";
        rGrupoCOL: Record "Grupo de Colegios";
        Text005: Label 'Grado';
        Text006: Label 'Hras. por sem.';
        nCol: Integer;
        wCount: Integer;
        recAdop2: Record "Historico Adopciones";
    begin
        //fes mig
        /*
        //Genera Tabla con los textos de Santillana
        intFila := 1;
        //
        recAdop.RESET;
        recAdop.SETCURRENTKEY("Cod. Colegio",Campana,Adopcion,"Cod. Editorial","Grupo de Negocio","Linea de negocio");
        IF (recPrmSolicitud."Grupo de Colegios") AND (recPrmSolicitud.Status > 1 ) THEN BEGIN
          rGrupoCOL.GET(recPrmSolicitud."Asociacion/Grupo");
          rGrupoCOL.CheckGrupo();
          recAdop.SETRANGE("Cod. Colegio",rGrupoCOL.GetColegios());
        END
        ELSE
          recAdop.SETRANGE("Cod. Colegio", recPrmSolicitud."Cod. Colegio");
        recAdop.SETFILTER(Adopcion,'<>%1',0);
        //recAdop.SETFILTER(recAdop."Cod. Nivel", recPrmSolicitud."Cod. Nivel");
        recAdop.CALCFIELDS("Item - Item Category Code");
        CASE recPrmSolicitud."Cod. Nivel" OF
           'INI' : BEGIN
                     recAdop.SETRANGE("Grupo de Negocio");//TODOS
                     recAdop.SETRANGE("Linea de negocio");//TODOS
                     recAdop.SETRANGE("Item - Item Category Code",'INI');
                   END;
           'PRI' : BEGIN
                     recAdop.SETRANGE("Grupo de Negocio",'SANTILLANA');
                     recAdop.SETRANGE("Linea de negocio",'01_TEXTO');
                     recAdop.SETRANGE("Item - Item Category Code",'PRI');
                   END;
           'SEC' : BEGIN
                     recAdop.SETRANGE("Grupo de Negocio",'SANTILLANA');
                     recAdop.SETRANGE("Linea de negocio",'01_TEXTO');
                     recAdop.SETRANGE("Item - Item Category Code",'SEC');
                   END;
           'ING' : BEGIN
                     recAdop.SETRANGE("Grupo de Negocio",'RICHMOND');
                     recAdop.SETRANGE("Linea de negocio",'02_IDIO_ING');
                     recAdop.SETFILTER("Item - Item Category Code",'%1|%2|%3|%4|%5','INI','PRI','SEC','SEI','VAR');
                   END;
           'ESI' : BEGIN
                     recAdop.SETRANGE("Grupo de Negocio",'RICHMOND');
                     recAdop.SETRANGE("Linea de negocio",'02_IDIO_ING');
                     recAdop.SETFILTER("Item - Item Category Code",'%1|%2|%3|%4|%5','INI','PRI','SEC','SEI','VAR');
                   END;
           'PLA' : BEGIN
                     recAdop.SETRANGE("Grupo de Negocio",'%1','PLAN LECTOR');
                     recAdop.SETRANGE("Linea de negocio");//TODOS
                     recAdop.SETRANGE("Item - Item Category Code");//TODOS
                     wCount := recAdop.COUNT;
                     recAdop.SETRANGE("Grupo de Negocio",'%1','SANTILLANA');
                     recAdop.SETRANGE("Linea de negocio",'01_TEXTO');
                     recAdop.SETRANGE("Item - Item Category Code",'PRI');
                     wCount += recAdop.COUNT;
                     IF wCount > 0 THEN
                       wCount +=  3;
                     recAdop.SETFILTER("Grupo de Negocio",'%1|%2','PLAN LECTOR','SANTILLANA');
                     recAdop.SETRANGE("Linea de negocio");//TODOS
                     recAdop.SETRANGE("Item - Item Category Code");//TODOS
                   END;
           'COM' : BEGIN
                     recAdop.SETRANGE("Grupo de Negocio");//TODOS
                     recAdop.SETRANGE("Linea de negocio");//TODOS
                     recAdop.SETRANGE("Item - Item Category Code");//TODOS
                   END;
        END;
        IF recAdop.FINDSET THEN BEGIN
          IF recPrmSolicitud."Cod. Nivel" <> 'PLA' THEN
            wCount := recAdop.COUNT+3;
          wdTable := autPrmApp.ActiveDocument.Tables.Add(autPrmRange, wCount, 5);
          intFila := 1;
        
          wdTable.Cell(intFila,1).Range.InsertAfter(Text001);
          wdTable.Cell(intFila,1).Range.Bold := 1;
          wdTable.Cell(intFila,1).Range.Font.Size := 10;
        
          intFila := 2;
          wdTable.Cell(intFila,1).Range.InsertAfter(' ');
          wdTable.Cell(intFila,1).Range.Bold := 1;
          wdTable.Cell(intFila,1).Range.Font.Size := 8;
        
          intFila := 3;
        
          wdTable.Cell(intFila,1).Range.InsertAfter(Text002);
          wdTable.Cell(intFila,1).Range.Bold := 1;
          wdTable.Cell(intFila,1).Range.Font.Size := 8;
          wdTable.Cell(intFila,2).Range.InsertAfter(Text003);
          wdTable.Cell(intFila,2).Range.Bold := 1;
          wdTable.Cell(intFila,2).Range.Font.Size := 8;
          wdTable.Cell(intFila,3).Range.InsertAfter(Text004);
          wdTable.Cell(intFila,3).Range.Bold := 1;
          wdTable.Cell(intFila,3).Range.Font.Size := 8;
          wdTable.Cell(intFila,4).Range.InsertAfter(Text005);
          wdTable.Cell(intFila,4).Range.Bold := 1;
          wdTable.Cell(intFila,4).Range.Font.Size := 8;
          wdTable.Cell(intFila,5).Range.InsertAfter(Text006);
          wdTable.Cell(intFila,5).Range.Bold := 1;
          wdTable.Cell(intFila,5).Range.Font.Size := 8;
        
          FOR nCol := 1 TO 5 DO BEGIN
            wdTable.Cell(intFila,nCol).Range.Borders.Item(1).LineStyle :=  1;
            wdTable.Cell(intFila,nCol).Range.Borders.Item(2).LineStyle :=  1;
            wdTable.Cell(intFila,nCol).Range.Borders.Item(3).LineStyle :=  1;
            wdTable.Cell(intFila,nCol).Range.Borders.Item(4).LineStyle :=  1;
          END;
        
          REPEAT
            recAdop.CALCFIELDS("Item - Item Category Code");
            IF (recPrmSolicitud."Cod. Nivel" <> 'PLA') OR
               ((recPrmSolicitud."Cod. Nivel" = 'PLA') AND (recAdop."Grupo de Negocio" = 'PLAN LECTOR')) OR
               ((recPrmSolicitud."Cod. Nivel" = 'PLA') AND (recAdop."Grupo de Negocio" = 'SANTILLANA') AND
                (recAdop."Linea de negocio" = '01_TEXTO') AND (recAdop."Item - Item Category Code" ='PRI')) THEN BEGIN
              intFila += 1;
              recAdop.CALCFIELDS("Nombre Editorial");
              wdTable.Cell(intFila,1).Range.InsertAfter(recAdop."Nombre Editorial");
              wdTable.Cell(intFila,2).Range.InsertAfter(recAdop."Cod. producto");
              wdTable.Cell(intFila,3).Range.InsertAfter(recAdop."Descripcion producto");
              wdTable.Cell(intFila,4).Range.InsertAfter(recAdop."Cod. Grado");
              FOR nCol := 1 TO 5 DO BEGIN
                wdTable.Cell(intFila,nCol).Range.Font.Size := 8;
                wdTable.Cell(intFila,nCol).Range.Borders.Item(2).LineStyle :=  1;
                wdTable.Cell(intFila,nCol).Range.Borders.Item(4).LineStyle :=  1;
              END;
            END;
          UNTIL recAdop.NEXT = 0;
        
          FOR nCol := 1 TO 5 DO
            wdTable.Cell(wCount+3,nCol).Range.Borders.Item(3).LineStyle :=  1;//INFERIOR
        
          wdTable.AutoFitBehavior := 1;  //Ajustar al contenido
        END
        ELSE
          autPrmRange.Text := '';
        */
        //fes mig

    end;

    local procedure InsertarTablaCompetencia(recPrmSolicitud: Record "Solicitud de Taller - Evento")
    var
        intFila: Integer;
        Text001: Label 'Textos de la Competencia';
        Text002: Label 'Editorial';
        Text003: Label 'Nombre Libro';
        Text004: Label 'Grado';
        Text005: Label 'Hras. por sem.';
        Text006: Label 'Año de la Comp.';
        nCol: Integer;
        recCompetencia: Record "Solicitud - Competencia";
    begin
        //fes mig
        /*
        //Genera Tabla con los textos de la competencia
        intFila := 1;
        //
        
        recCompetencia.SETRANGE("No. Solicitud", recPrmSolicitud."No. Solicitud");
        IF recCompetencia.FINDSET THEN BEGIN
          wdTable := autPrmApp.ActiveDocument.Tables.Add(autPrmRange, recCompetencia.COUNT+3, 5);
          intFila := 1;
        
          wdTable.Cell(intFila,1).Range.InsertAfter(Text001);
          wdTable.Cell(intFila,1).Range.Bold := 1;
          wdTable.Cell(intFila,1).Range.Font.Size := 10;
        
          intFila := 2;
          wdTable.Cell(intFila,1).Range.InsertAfter(' ');
          wdTable.Cell(intFila,1).Range.Bold := 1;
          wdTable.Cell(intFila,1).Range.Font.Size := 8;
        
          intFila := 3;
        
          wdTable.Cell(intFila,1).Range.InsertAfter(Text002);
          wdTable.Cell(intFila,1).Range.Bold := 1;
          wdTable.Cell(intFila,1).Range.Font.Size := 8;
          wdTable.Cell(intFila,2).Range.InsertAfter(Text003);
          wdTable.Cell(intFila,2).Range.Bold := 1;
          wdTable.Cell(intFila,2).Range.Font.Size := 8;
          wdTable.Cell(intFila,3).Range.InsertAfter(Text004);
          wdTable.Cell(intFila,3).Range.Bold := 1;
          wdTable.Cell(intFila,3).Range.Font.Size := 8;
          wdTable.Cell(intFila,4).Range.InsertAfter(Text005);
          wdTable.Cell(intFila,4).Range.Bold := 1;
          wdTable.Cell(intFila,4).Range.Font.Size := 8;
          wdTable.Cell(intFila,5).Range.InsertAfter(Text006);
          wdTable.Cell(intFila,5).Range.Bold := 1;
          wdTable.Cell(intFila,5).Range.Font.Size := 8;
        
          FOR nCol := 1 TO 5 DO BEGIN
            wdTable.Cell(intFila,nCol).Range.Borders.Item(1).LineStyle :=  1;
            wdTable.Cell(intFila,nCol).Range.Borders.Item(2).LineStyle :=  1;
            wdTable.Cell(intFila,nCol).Range.Borders.Item(3).LineStyle :=  1;
            wdTable.Cell(intFila,nCol).Range.Borders.Item(4).LineStyle :=  1;
          END;
        
          REPEAT
            intFila += 1;
            wdTable.Cell(intFila,1).Range.InsertAfter(recCompetencia."Nombre Editorial");
            wdTable.Cell(intFila,2).Range.InsertAfter(recCompetencia.Description);
            wdTable.Cell(intFila,3).Range.InsertAfter(recCompetencia."Cod. Grado");
            wdTable.Cell(intFila,4).Range.InsertAfter(FORMAT(recCompetencia."Horas a la semana"));
            wdTable.Cell(intFila,4).Range.InsertAfter(recCompetencia."Año Adopción");
            FOR nCol := 1 TO 5 DO BEGIN
              wdTable.Cell(intFila,nCol).Range.Font.Size := 8;
              wdTable.Cell(intFila,nCol).Range.Borders.Item(2).LineStyle :=  1;
              wdTable.Cell(intFila,nCol).Range.Borders.Item(4).LineStyle :=  1;
            END;
          UNTIL recCompetencia.NEXT = 0;
          FOR nCol := 1 TO 5 DO
            wdTable.Cell(recCompetencia.COUNT+3,nCol).Range.Borders.Item(3).LineStyle :=  1;//INFERIOR
        
          wdTable.AutoFitBehavior := 1;  //Ajustar al contenido
        END
        ELSE
          autPrmRange.Text := '';
        */
        //fes mig

    end;


    procedure GeneraWordVisitasCA(parConsultor: Code[20]; parNomConsultor: Text[90]; parFecha1: Date; parFecha2: Date; parDelegacion: Code[20]; parLn: Code[20]; parEstado: Option " ",Programada,Ejecutada)
    var
        recCfgAPS: Record "Commercial Setup";
        recColegio: Record Contact;
        texPlantillaDot: Text[255];
        texNombreCampo: Text[100];
        intFila: Integer;
        i: Integer;
        Error001: Label 'Debe cargar una plantilla Word (.dot) para la generación de las Visitas';
        Error002: Label 'Debe indicar la ruta donde guardar las Visitas.';
        Text001: Label 'Visitas de %1 (de %2 a %3).doc';
        texRuta: Text[1024];
        Text002: Label 'El documento Word se ha generado y guardado en la ruta: ';
        tipoPlantilla: Option Solicitud,PPFF,VisitasCA;
        recCab: Record "Cab. Visita Asesor/Consultor";
        ToFile: Text[255];
        Prog: Record "Prog. Visitas Asesor/Consultor";
        wAntVisita: Code[20];
        wAntFecha: Date;
        wAntCodigo: Code[20];
        wCodigo: Code[20];
        wNombre: Text[100];
        wFecha1: Date;
        wHorai1: Time;
        wHoraf1: Time;
        wIE1: Text[80];
        wTipoAcc1: Code[20];
        wFecha2: Date;
        wHorai2: Time;
        wHoraf2: Time;
        Err001: Label 'No existen visitas registradas.';
        wIE2: Text[80];
        wTipoAcc2: Code[20];
        ultReg: Boolean;
        totalVisitasCA: Integer;
    begin
        //fes mig
        /*
        CLEAR(wAntVisita);
        CLEAR(wAntFecha);
        CLEAR(wAntCodigo);
        CLEAR(ultReg);
        
        Prog.SETCURRENTKEY("Cod. Asesor/Consultor","Fecha Programada","No. Visita","Hora Inicio Programada","Hora Fin Programada",
                              Delegación,"Grupo Negocio");
        
        
        Prog.SETRANGE("Cod. Asesor/Consultor",parConsultor);
        
        IF (parFecha1 <>0D) AND (parFecha2 <> 0D) THEN
          Prog.SETRANGE("Fecha Programada",parFecha1,parFecha2)
        ELSE
          Prog.SETFILTER(Prog."Fecha Programada",'<>%1',0D);
        
        IF parDelegacion <> '' THEN
          Prog.SETRANGE(Delegación,parDelegacion);
        
        IF parLn <> '' THEN
          Prog.SETRANGE("Grupo Negocio", parLn);
        
        CASE parEstado OF
          parEstado::Programada : Prog.SETRANGE("Estado Visita",Prog."Estado Visita"::Programada);
          parEstado::Ejecutada  : Prog.SETRANGE("Estado Visita",Prog."Estado Visita"::Ejecutada);
        END;
        
        IF NOT Prog.FINDSET THEN
          ERROR(Err001);
        
        totalVisitasCA := TotalVisitas(Prog);
        
        
        tipoPlantilla := tipoPlantilla::VisitasCA;
        CREATE(wdApp, FALSE, TRUE);
        
        recCfgAPS.GET;
        recCfgAPS.CALCFIELDS("Plantilla Word Visitas C/A");
        IF NOT recCfgAPS."Plantilla Word Visitas C/A".HASVALUE THEN
          ERROR(Error001);
        
        IF recCfgAPS."Ruta Word Visitas C/A" = '' THEN
          ERROR(Error002);
        
        texPlantillaDot := GuardarPlantillaTemp(recCfgAPS,tipoPlantilla);
        wdDoc := wdApp.Documents.Add(texPlantillaDot);
        wdApp.ActiveDocument.Fields.Update;
        
        intFila := 0;
        
        FOR i := 1 TO wdApp.ActiveDocument.Fields.Count DO BEGIN
        
          wdField := wdApp.ActiveDocument.Fields.Item(i);
          wdRange := wdField.Code;
        
          IF wdField.Type = 59 THEN BEGIN                                          //Solo campos tipo MailMerge
        
            texNombreCampo := ExtraerNombreCampo(wdRange.Text);
            wdRange := wdApp.ActiveDocument.Fields.Item(i).Result;
        
            CASE texNombreCampo OF
              'Programacion'          :
                  BEGIN
                    InsertarTablaVisitas(wdApp,wdRange,Prog,parConsultor,parNomConsultor,parFecha1,parFecha2,intFila,totalVisitasCA);
                  END;
            END;
        
          END;
        
        END;
        
        
        //wdApp.Visible := TRUE;
        
        texRuta := recCfgAPS."Ruta Word Visitas C/A";
        IF texRuta[STRLEN(texRuta)] <> '\' THEN
          texRuta := texRuta+'\';
        texRuta := texRuta+STRSUBSTNO(Text001, parNomConsultor,FORMAT(parFecha1,0,'<Day,2>-<Month,2>-<Year>'),
                                               FORMAT(parFecha2,0,'<Day,2>-<Month,2>-<Year>'));
        
        
        wdApp.ActiveDocument.Fields.Unlink;
        wdDoc.SaveAs(texRuta);
        wdDoc.Close;
        
        MESSAGE('%1 %2', Text002, texRuta);
        //fes mig
        */

    end;

    local procedure InsertarTablaVisitas(var Prog: Record "Prog. Visitas Asesor/Consultor"; parCodigo: Code[20]; parNombre: Text[80]; parFecha1: Date; parFecha2: Date; var intFila: Integer; totalvis: Integer)
    var
        recProgramacion: Record "Programac. Talleres y Eventos";
        Text001: Label 'Propuesto';
        Text002: Label 'Fecha';
        Text003: Label 'Hora inicio';
        Text004: Label 'Hora final';
        recCabPlan: Record "Cab. Planif. Evento";
        Text005: Label 'Programado';
        Text006: Label 'Solo C.C.';
        Text007: Label 'Grado';
        Text008: Label 'Cant.';
        ncol: Integer;
        Text009: Label 'Horario';
        wAntVisita: Code[20];
        wAntFecha: Date;
        nVisita: Integer;
    begin
        //fes mig
        /*
        //Genera Tabla con la programación
        
        intFila :=1;
        CLEAR(wAntVisita);
        CLEAR(wAntFecha);
        ncol := 1;
        CLEAR(nVisita);
        wdTable := autPrmApp.ActiveDocument.Tables.Add(autPrmRange, ( ((ROUND(totalvis/2,1) * 17) +17) + ((ROUND(totalvis/6,1)*4)+4) ) , 2);
        //InsertarTablaCA(autPrmApp,autPrmRange,parCodigo,parNombre,parFecha1,parFecha2,intFila);
        IF Prog.FINDSET THEN BEGIN
          REPEAT
             IF (wAntVisita  <> Prog."No. Visita") OR (wAntFecha <> Prog."Fecha Programada") THEN BEGIN
               nVisita += 1;
               IF nVisita = 7 THEN
                 nVisita := 1;
               IF nVisita = 1 THEN
                 InsertarTablaCA(autPrmApp,autPrmRange,parCodigo,parNombre,parFecha1,parFecha2,intFila,wdTable);
               InsertCell(wdTable,intFila,ncol,' ',0,10,FALSE);
               InsertCell(wdTable,intFila + 1,ncol,Prog."No. Visita" + '                          Fecha:  ' +
                                                   FORMAT(Prog."Fecha Programada"),0,10,FALSE);
               InsertCell(wdTable,intFila + 2,ncol,' ',0,10,FALSE);
               InsertCell(wdTable,intFila + 3,ncol,'IE:  ' + Prog."Cod. Colegio" + ' - ' + Prog."Nombre Colegio" + ' - ' +
                                                   GetDistrito(Prog."No. Visita"),0,9,FALSE);
               InsertCell(wdTable,intFila + 4,ncol,' ',0,10,FALSE);
               InsertCell(wdTable,intFila + 5,ncol,'Hora de ingreso:  ' + FORMAT(Prog."Hora Inicio Programada"),0,10,FALSE);
               InsertCell(wdTable,intFila + 6,ncol,' ',0,10,FALSE);
               InsertCell(wdTable,intFila + 7,ncol,'Hora de salida:  ' + FORMAT(GetHoraFinal(Prog)),0,10,FALSE);
               InsertCell(wdTable,intFila + 8,ncol,' ',0,10,FALSE);
               InsertCell(wdTable,intFila + 9,ncol,'Firma y sello:  ',0,10,FALSE);
               InsertCell(wdTable,intFila + 10,ncol,' ',0,10,FALSE);
               InsertCell(wdTable,intFila + 11,ncol,'______________________________________',0,10,FALSE);
               InsertCell(wdTable,intFila + 12,ncol,' ' ,0,10,FALSE);
               InsertCell(wdTable,intFila + 13,ncol,'Nombre',0,10,FALSE);
               InsertCell(wdTable,intFila + 14,ncol,' ',0,10,FALSE);
               InsertCell(wdTable,intFila + 15,ncol,' ',0,10,FALSE);
               InsertCell(wdTable,intFila + 16,ncol,'Tipo de acción: ' + GetTipoEvento(Prog) + '   Equivalencia:  __________',0,10,FALSE);
               InsertCell(wdTable,intFila + 17,ncol,' ',0,10,FALSE);
               RecuadraCell(wdTable,intFila,intFila + 17,ncol);
               CASE ncol OF
                1 :
                  BEGIN
                    ncol := 2;
                  END;
                2 :
                  BEGIN
                    ncol := 1;
                    intFila += 18;
                  END;
               END;
              wAntVisita  := Prog."No. Visita";
              wAntFecha   := Prog."Fecha Programada";
             END;
          UNTIL Prog.NEXT=0;
        END
        ELSE
          autPrmRange.Text := '';
          //wdTable.AutoFitBehavior := 1;  //Ajustar al contenido
        
        */
        //fes mig

    end;

    local procedure InsertarTablaCA(parCodigo: Code[20]; parNombre: Text[80]; parFecha1: Date; parFecha2: Date; var intFila: Integer)
    var
        Text001: Label 'Propuesto';
        Text002: Label 'Fecha';
        Text003: Label 'Hora inicio';
        Text004: Label 'Hora final';
        Text005: Label 'Programado';
        Text006: Label 'Solo C.C.';
        Text007: Label 'Grado';
        Text008: Label 'Cant.';
        Text009: Label 'Horario';
        nFila: Integer;
        nCol: Integer;
    begin
        //fes mig
        /*
        //Genera Tabla con la programación
        
        //wdTable := autPrmApp.ActiveDocument.Tables.Add(autPrmRange, 4, 1);
        
        
        InsertCell(wdTable,intFila,1,'REGISTRO ',1,18,TRUE);
        InsertCell(wdTable,intFila,2,'VISITAS',1,18,FALSE);
        InsertCell(wdTable,intFila + 1,1,' ',1,8,TRUE);
        InsertCell(wdTable,intFila + 1,2,' ',1,8,FALSE);
        InsertCell(wdTable,intFila + 2,1, parNombre,1,11,TRUE);
        InsertCell(wdTable,intFila + 2,2,' ( ' + FORMAT(parFecha1) + ' - ' + FORMAT(parFecha2) + ' ) ',1,11,FALSE);
        InsertCell(wdTable,intFila + 3,1,' ',1,8,TRUE);
        InsertCell(wdTable,intFila + 3,2,' ',1,8,TRUE);
        
        FOR nFila := (intFila + 1) TO (intFila + 3) DO BEGIN
          FOR nCol := 1 TO 2 DO BEGIN
            IF nFila = (intFila + 1) THEN
              wdTable.Cell(nFila,nCol).Range.Borders.Item(1).LineStyle :=  1;
            IF nFila = (intFila + 3) THEN
              wdTable.Cell(nFila,nCol).Range.Borders.Item(3).LineStyle :=  1;
            IF nCol = 1 THEN
              wdTable.Cell(nFila,nCol).Range.Borders.Item(2).LineStyle :=  1;
            IF nCol = 2 THEN
              wdTable.Cell(nFila,nCol).Range.Borders.Item(4).LineStyle :=  1;
          END;
        END;
        
        intFila += 4;
        */
        //fes mig

    end;


    procedure GetHoraFinal(parProg: Record "Prog. Visitas Asesor/Consultor") rtnHora: Time
    var
        "Program": Record "Prog. Visitas Asesor/Consultor";
    begin

        Clear(rtnHora);
        "Program".SetCurrentKey("Cod. Asesor/Consultor", "Fecha Programada", "No. Visita", "Hora Inicio Programada", "Hora Fin Programada",
                              Delegación, "Grupo Negocio");
        //"Program".SETRANGE("Tipo Asesor/Consultor", parProg."Tipo Asesor/Consultor");
        "Program".SetRange("Cod. Asesor/Consultor", parProg."Cod. Asesor/Consultor");
        "Program".SetRange("Fecha Programada", parProg."Fecha Programada");
        "Program".SetRange("No. Visita", parProg."No. Visita");
        if "Program".FindLast then
            rtnHora := "Program"."Hora Fin Programada";
    end;


    procedure TotalVisitas(var Prog: Record "Prog. Visitas Asesor/Consultor") rtnVisitas: Integer
    var
        wAntVisita: Code[20];
        wAntFecha: Date;
    begin

        rtnVisitas := 0;
        Clear(wAntVisita);
        Clear(wAntFecha);
        if Prog.FindSet then
            repeat
                if (wAntVisita <> Prog."No. Visita") or (wAntFecha <> Prog."Fecha Programada") then begin
                    rtnVisitas += 1;
                    wAntVisita := Prog."No. Visita";
                    wAntFecha := Prog."Fecha Programada";
                end;
            until Prog.Next = 0;
    end;


    procedure InsertCell(Fila: Integer; Columna: Integer; Texto: Text[70]; Negrita: Integer; Size: Integer; Derecha: Boolean)
    begin
        //fes mig
        /*
        wdTable.Cell(Fila,Columna).Range.InsertAfter(Texto);
        wdTable.Cell(Fila,Columna).Range.Bold := Negrita;
        wdTable.Cell(Fila,Columna).Range.Font.Size := Size;
        IF Derecha THEN
          wdTable.Cell(Fila,Columna).Range.ParagraphFormat.Alignment := 2;
        */
        //fes mig

    end;


    procedure GetTipoEvento(parProg: Record "Prog. Visitas Asesor/Consultor") rtnTE: Code[20]
    var
        recCab: Record "Cab. Visita Asesor/Consultor";
    begin
        Clear(rtnTE);
        if recCab.Get(parProg."No. Visita") then
            rtnTE := recCab."Tipo Evento";
    end;


    procedure RecuadraCell(FilaIni: Integer; FilaFin: Integer; Columna: Integer)
    var
        nFila: Integer;
    begin
        //fes mig
        /*
        FOR nFila := FilaIni TO FilaFin DO BEGIN
           IF nFila = FilaIni THEN
             wdTable.Cell(nFila,Columna).Range.Borders.Item(1).LineStyle :=  1;
           IF nFila = FilaFin THEN
             wdTable.Cell(nFila,Columna).Range.Borders.Item(3).LineStyle :=  1;
           wdTable.Cell(nFila,Columna).Range.Borders.Item(2).LineStyle :=  1;
           wdTable.Cell(nFila,Columna).Range.Borders.Item(4).LineStyle :=  1;
        END;
        */
        //fes mig

    end;


    procedure GetDistrito(parVisita: Code[20]) rtnValue: Text[30]
    var
        rVisita: Record "Cab. Visita Asesor/Consultor";
    begin

        Clear(rtnValue);
        if rVisita.Get(parVisita) then
            rtnValue := rVisita."Distrito Colegio";
    end;
}

