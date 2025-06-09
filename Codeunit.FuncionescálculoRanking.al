codeunit 76014 "Funciones cálculo Ranking"
{

    trigger OnRun()
    begin
    end;

    var
        gCamp: Code[4];
        gHist: Boolean;
        gTipo: Option General,CVM;
        gDeleg: Code[20];
        recColegio: Record Contact;
        Text001: Label 'Calculando Ranking General ... \ Colegio #1###################';
        Ventana: Dialog;
        gTipoReporte: Option Todos,Colegios,Nidos;
        gGNeg: Option General,Santillana,Richmond,"Plan Lector";
        Text002: Label 'Calculando Ranking CVM ... \ Colegio #1###################';
        gFecha: Date;


    procedure CalcRanking(var tTrabajo: Record "Tabla trabajo Ranking"; parTipo: Option General,CVM; parCamp: Code[4]; parDeleg: Code[20]; parTipoReporte: Option Todos,Colegios,Nidos; parGNeg: Option General,Santillana,Richmond,"Plan Lector")
    begin

        gTipo := parTipo;
        gCamp := parCamp;
        gHist := EsCampHistorica;
        gDeleg := parDeleg;
        gTipoReporte := parTipoReporte;
        gGNeg := parGNeg;
        gFecha := Today;

        case gTipo of
            gTipo::CVM:
                begin
                    tTrabajo.SetRange(tTrabajo.Reporte, tTrabajo.Reporte::CVM);
                    tTrabajo.SetRange(tTrabajo.Campaña, gCamp);
                    if gDeleg <> '' then
                        tTrabajo.SetRange(tTrabajo.Delegación, gDeleg);
                    tTrabajo.DeleteAll;
                    Ventana.Open(Text002);
                end;
            gTipo::General:
                begin
                    tTrabajo.SetRange(tTrabajo.Reporte, tTrabajo.Reporte::General);
                    tTrabajo.SetRange(tTrabajo.Campaña, gCamp);
                    if gDeleg <> '' then
                        tTrabajo.SetRange(tTrabajo.Delegación, gDeleg);
                    tTrabajo.DeleteAll;
                    Ventana.Open(Text001);
                end;
        end;

        recColegio.Reset;
        if gDeleg <> '' then begin
            recColegio.SetCurrentKey(Región);
            recColegio.SetRange(Región, gDeleg);
        end;
        if recColegio.FindSet then
            repeat
                Ventana.Update(1, recColegio."No.");
                case gTipo of
                    gTipo::General:
                        begin
                            if ValidaTipoReporte then
                                if TieneAdopciones then
                                    InsertaTemporal(tTrabajo);
                        end;
                    gTipo::CVM:
                        begin
                            if ValidaTipoReporte then
                                if EnCartera then
                                    InsertaTemporal(tTrabajo);
                        end;
                end;
            until recColegio.Next = 0;
        OrdenarTemporal(tTrabajo);
        Ventana.Close;
    end;


    procedure TieneAdopciones() rtn: Boolean
    var
        recHistAdop: Record "Historico Adopciones";
        recAdop: Record "Colegio - Adopciones Detalle";
    begin

        if gHist then begin
            recHistAdop.Reset;
            recHistAdop.SetCurrentKey("Cod. Colegio", Campana, Adopcion, "Cod. Editorial", "Grupo de Negocio", "Linea de negocio");
            recHistAdop.SetFilter(Adopcion, '%1|%2', recHistAdop.Adopcion::Conquista, recHistAdop.Adopcion::Mantener);
            recHistAdop.SetRange(Campana, gCamp);
            recHistAdop.SetRange("Cod. Colegio", recColegio."No.");
            rtn := recHistAdop.FindFirst;
        end
        else begin
            recAdop.Reset;
            recAdop.SetCurrentKey("Cod. Colegio", "Grupo de Negocio", "Cod. Grado", "Cod. Turno", "Cod. Promotor", "Cod. Producto");
            recAdop.SetRange("Cod. Colegio", recColegio."No.");
            recAdop.SetFilter(Adopcion, '%1|%2', recAdop.Adopcion::Conquista, recAdop.Adopcion::Mantener);
            rtn := recAdop.FindFirst;
        end;
    end;


    procedure InsertaTemporal(var tTrabajo: Record "Tabla trabajo Ranking")
    begin

        tTrabajo.Init;

        case gTipo of
            gTipo::General:
                tTrabajo.Reporte := tTrabajo.Reporte::General;
            gTipo::CVM:
                tTrabajo.Reporte := tTrabajo.Reporte::CVM;
        end;
        tTrabajo.Campaña := gCamp;
        tTrabajo.FechaGen := gFecha;

        InsertaInfoColegio(tTrabajo);

        InsertaInfoCategorias(tTrabajo);

        InsertaInfoMontoBruto(tTrabajo);

        InsertaInfoMontoTotal(tTrabajo);

        InsertaInfoPorcxLinea(tTrabajo);

        tTrabajo.Insert;
    end;


    procedure InsertaInfoCategorias(var tTrabajo: Record "Tabla trabajo Ranking")
    var
        recCategoria: Record "Categorias CVM";
        recHistCategoria: Record "Histórico Categorias CVM";
    begin

        if not gHist then begin
            recCategoria.SetRange("Cod. Colegio", recColegio."No.");
            if recCategoria.FindSet then
                repeat
                    case recCategoria."Grupo Negocio" of
                        'SANTILLANA':
                            begin
                                case recCategoria."Cod. Nivel" of
                                    'GEN':
                                        tTrabajo."CVM TEXTO_GEN" := recCategoria.Categoria;
                                    'INI':
                                        tTrabajo."CVM TEXTO_INI" := recCategoria.Categoria;
                                    'PRI':
                                        tTrabajo."CVM TEXTO_PRI" := recCategoria.Categoria;
                                    'SEC':
                                        tTrabajo."CVM TEXTO_SEC" := recCategoria.Categoria;
                                end;
                            end;
                        'RICHMOND':
                            begin
                                case recCategoria."Cod. Nivel" of
                                    'GEN':
                                        tTrabajo.RICHMOND_GEN := recCategoria.Categoria;
                                    'INI':
                                        tTrabajo.RICHMOND_INI := recCategoria.Categoria;
                                    'PRI':
                                        tTrabajo.RICHMOND_PRI := recCategoria.Categoria;
                                    'SEC':
                                        tTrabajo.RICHMOND_SEC := recCategoria.Categoria;
                                end;
                            end;
                        'PLAN LECTOR':
                            begin
                                case recCategoria."Cod. Nivel" of
                                    'GEN':
                                        tTrabajo."PLAN LECTOR_GEN" := recCategoria.Categoria;
                                    'INI':
                                        tTrabajo."PLAN LECTOR_INI" := recCategoria.Categoria;
                                    'PRI':
                                        tTrabajo."PLAN LECTOR_PRI" := recCategoria.Categoria;
                                    'SEC':
                                        tTrabajo."PLAN LECTOR_SEC" := recCategoria.Categoria;
                                end;
                            end;
                        'SANTILLANA COMPARTIR':
                            begin
                                case recCategoria."Cod. Nivel" of
                                    'GEN':
                                        tTrabajo.COMPARTIR_GEN := recCategoria.Categoria;
                                    'INI':
                                        tTrabajo.COMPARTIR_INI := recCategoria.Categoria;
                                    'PRI':
                                        tTrabajo.COMPARTIR_PRI := recCategoria.Categoria;
                                    'SEC':
                                        tTrabajo.COMPARTIR_SEC := recCategoria.Categoria;
                                end;
                            end;
                        'GENERAL':
                            begin
                                if recCategoria."Cod. Nivel" = 'GEN' then
                                    tTrabajo."CVM GN" := recCategoria.Categoria;
                            end;
                    end;
                until recCategoria.Next = 0;
        end
        else begin
            recHistCategoria.Reset;
            recHistCategoria.SetRange(Campaña, gCamp);
            recHistCategoria.SetRange("Cod. Colegio", recColegio."No.");
            if recHistCategoria.FindSet then
                repeat
                    case recHistCategoria."Grupo Negocio" of
                        'SANTILLANA':
                            begin
                                case recHistCategoria."Cod. Nivel" of
                                    'GEN':
                                        tTrabajo."CVM TEXTO_GEN" := recHistCategoria.Categoria;
                                    'INI':
                                        tTrabajo."CVM TEXTO_INI" := recHistCategoria.Categoria;
                                    'PRI':
                                        tTrabajo."CVM TEXTO_PRI" := recHistCategoria.Categoria;
                                    'SEC':
                                        tTrabajo."CVM TEXTO_SEC" := recHistCategoria.Categoria;
                                end;
                            end;
                        'RICHMOND':
                            begin
                                case recHistCategoria."Cod. Nivel" of
                                    'GEN':
                                        tTrabajo.RICHMOND_GEN := recHistCategoria.Categoria;
                                    'INI':
                                        tTrabajo.RICHMOND_INI := recHistCategoria.Categoria;
                                    'PRI':
                                        tTrabajo.RICHMOND_PRI := recHistCategoria.Categoria;
                                    'SEC':
                                        tTrabajo.RICHMOND_SEC := recHistCategoria.Categoria;
                                end;
                            end;
                        'PLAN LECTOR':
                            begin
                                case recHistCategoria."Cod. Nivel" of
                                    'GEN':
                                        tTrabajo."PLAN LECTOR_GEN" := recHistCategoria.Categoria;
                                    'INI':
                                        tTrabajo."PLAN LECTOR_INI" := recHistCategoria.Categoria;
                                    'PRI':
                                        tTrabajo."PLAN LECTOR_PRI" := recHistCategoria.Categoria;
                                    'SEC':
                                        tTrabajo."PLAN LECTOR_SEC" := recHistCategoria.Categoria;
                                end;
                            end;
                        'SANTILLANA COMPARTIR':
                            begin
                                case recHistCategoria."Cod. Nivel" of
                                    'GEN':
                                        tTrabajo.COMPARTIR_GEN := recHistCategoria.Categoria;
                                    'INI':
                                        tTrabajo.COMPARTIR_INI := recHistCategoria.Categoria;
                                    'PRI':
                                        tTrabajo.COMPARTIR_PRI := recHistCategoria.Categoria;
                                    'SEC':
                                        tTrabajo.COMPARTIR_SEC := recHistCategoria.Categoria;
                                end;
                            end;
                        'GENERAL':
                            begin
                                if recHistCategoria."Cod. Nivel" = 'GEN' then
                                    tTrabajo."CVM GN" := recHistCategoria.Categoria;
                            end;
                    end;
                until recHistCategoria.Next = 0;


        end;
    end;


    procedure InsertaInfoMontoBruto(var tTrabajo: Record "Tabla trabajo Ranking")
    var
        recHistAdop: Record "Historico Adopciones";
        recAdop: Record "Colegio - Adopciones Detalle";
    begin


        if gHist then begin

            recHistAdop.Reset;
            recHistAdop.SetCurrentKey("Cod. Colegio", Campana, Adopcion, "Cod. Editorial", "Grupo de Negocio", "Linea de negocio");
            recHistAdop.SetFilter(Adopcion, '%1|%2', recHistAdop.Adopcion::Conquista, recHistAdop.Adopcion::Mantener);
            recHistAdop.SetRange(recHistAdop."Cod. Colegio", recColegio."No.");
            recHistAdop.SetRange(Campana, Format(gCamp));

            if (gGNeg = gGNeg::General) or (gGNeg = gGNeg::Santillana) then begin
                //INI
                recHistAdop.SetRange("Grupo de Negocio", 'SANTILLANA');
                recHistAdop.SetRange("Linea de negocio", '01_TEXTO');
                recHistAdop.SetRange("Item - Item Category Code", 'INI');
                recHistAdop.SetRange("Item - Product Group Code");
                if recHistAdop.FindSet then
                    repeat
                        recHistAdop.CalcFields("Sales Price - Unit Price");
                        tTrabajo."MONTO BRUTO_INI" += (recHistAdop."Adopcion Real" * recHistAdop."Sales Price - Unit Price");
                    until recHistAdop.Next = 0;

                //PRI
                recHistAdop.SetRange("Grupo de Negocio", 'SANTILLANA');
                recHistAdop.SetRange("Linea de negocio", '01_TEXTO');
                recHistAdop.SetRange("Item - Item Category Code", 'PRI');
                recHistAdop.SetFilter("Item - Product Group Code", '<>%1', 'LET');
                if recHistAdop.FindSet then
                    repeat
                        recHistAdop.CalcFields("Sales Price - Unit Price");
                        tTrabajo."MONTO BRUTO_PRI" += (recHistAdop."Adopcion Real" * recHistAdop."Sales Price - Unit Price");
                    until recHistAdop.Next = 0;

                //SEC
                recHistAdop.SetRange("Grupo de Negocio", 'SANTILLANA');
                recHistAdop.SetRange("Linea de negocio", '01_TEXTO');
                recHistAdop.SetRange("Item - Item Category Code", 'SEC');
                recHistAdop.SetRange("Item - Product Group Code");
                if recHistAdop.FindSet then
                    repeat
                        recHistAdop.CalcFields("Sales Price - Unit Price");
                        tTrabajo."MONTO BRUTO_SEC" += (recHistAdop."Adopcion Real" * recHistAdop."Sales Price - Unit Price");
                    until recHistAdop.Next = 0;

                //LETI
                recHistAdop.SetRange("Grupo de Negocio", 'SANTILLANA');
                recHistAdop.SetRange("Linea de negocio", '01_TEXTO');
                recHistAdop.SetRange("Item - Item Category Code", 'PRI');
                recHistAdop.SetRange("Item - Product Group Code", 'LET');
                if recHistAdop.FindSet then
                    repeat
                        recHistAdop.CalcFields("Sales Price - Unit Price");
                        tTrabajo."MONTO BRUTO_LETI" += (recHistAdop."Adopcion Real" * recHistAdop."Sales Price - Unit Price");
                    until recHistAdop.Next = 0;

                //BIBL
                recHistAdop.SetRange("Grupo de Negocio", 'SANTILLANA');
                recHistAdop.SetRange("Linea de negocio", '01_TEXTO');
                recHistAdop.SetRange("Item - Item Category Code", 'BB');
                recHistAdop.SetRange("Item - Product Group Code");
                if recHistAdop.FindSet then
                    repeat
                        recHistAdop.CalcFields("Sales Price - Unit Price");
                        tTrabajo."MONTO BRUTO_BIBL" += (recHistAdop."Adopcion Real" * recHistAdop."Sales Price - Unit Price");
                    until recHistAdop.Next = 0;
            end;

            if (gGNeg = gGNeg::General) or (gGNeg = gGNeg::Richmond) then begin
                //ING
                recHistAdop.SetRange("Grupo de Negocio", 'RICHMOND');
                recHistAdop.SetRange("Linea de negocio", '02_IDIO_ING');
                recHistAdop.SetFilter("Item - Item Category Code", '%1|%2|%3|%4', 'INI', 'PRI', 'SEC', 'SEI');
                recHistAdop.SetRange("Item - Product Group Code");
                if recHistAdop.FindSet then
                    repeat
                        recHistAdop.CalcFields("Sales Price - Unit Price");
                        tTrabajo."MONTO BRUTO_ING" += (recHistAdop."Adopcion Real" * recHistAdop."Sales Price - Unit Price");
                    until recHistAdop.Next = 0;

                //READ
                recHistAdop.SetRange("Grupo de Negocio", 'RICHMOND');
                recHistAdop.SetRange("Linea de negocio", '02_IDIO_ING');
                recHistAdop.SetRange("Item - Item Category Code", 'VAR');
                recHistAdop.SetRange("Item - Product Group Code");
                if recHistAdop.FindSet then
                    repeat
                        recHistAdop.CalcFields("Sales Price - Unit Price");
                        tTrabajo."MONTO BRUTO_READ" += (recHistAdop."Adopcion Real" * recHistAdop."Sales Price - Unit Price");
                    until recHistAdop.Next = 0;
            end;

            if (gGNeg = gGNeg::General) or (gGNeg = gGNeg::"Plan Lector") then begin
                //PLA
                recHistAdop.SetRange("Grupo de Negocio", 'PLAN LECTOR');
                recHistAdop.SetRange("Linea de negocio");
                recHistAdop.SetRange("Item - Item Category Code");
                recHistAdop.SetRange("Item - Product Group Code");
                if recHistAdop.FindSet then
                    repeat
                        recHistAdop.CalcFields("Sales Price - Unit Price");
                        tTrabajo."MONTO BRUTO_PLA" += (recHistAdop."Adopcion Real" * recHistAdop."Sales Price - Unit Price");
                    until recHistAdop.Next = 0;
            end;
        end
        else begin

            recAdop.Reset;
            recAdop.SetCurrentKey("Cod. Colegio", "Grupo de Negocio", "Cod. Grado", "Cod. Turno", "Cod. Promotor", "Cod. Producto");
            recAdop.SetRange("Cod. Colegio", recColegio."No.");
            recAdop.SetFilter(Adopcion, '%1|%2', recAdop.Adopcion::Conquista, recAdop.Adopcion::Mantener);

            if (gGNeg = gGNeg::General) or (gGNeg = gGNeg::Santillana) then begin
                //INI
                recAdop.SetRange("Grupo de Negocio", 'SANTILLANA');
                recAdop.SetRange("Linea de negocio", '01_TEXTO');
                recAdop.SetRange("Item - Item Category Code", 'INI');
                recAdop.SetRange("Item - Product Group Code");
                if recAdop.FindSet then
                    repeat
                        recAdop.CalcFields("Sales Price - Unit Price");
                        tTrabajo."MONTO BRUTO_INI" += (recAdop."Adopcion Real" * recAdop."Sales Price - Unit Price");
                    until recAdop.Next = 0;
                //PRI
                recAdop.SetRange("Grupo de Negocio", 'SANTILLANA');
                recAdop.SetRange("Linea de negocio", '01_TEXTO');
                recAdop.SetRange("Item - Item Category Code", 'PRI');
                recAdop.SetFilter("Item - Product Group Code", '<>%1', 'LET');
                if recAdop.FindSet then
                    repeat
                        recAdop.CalcFields("Sales Price - Unit Price");
                        tTrabajo."MONTO BRUTO_PRI" += (recAdop."Adopcion Real" * recAdop."Sales Price - Unit Price");
                    until recAdop.Next = 0;

                //SEC
                recAdop.SetRange("Grupo de Negocio", 'SANTILLANA');
                recAdop.SetRange("Linea de negocio", '01_TEXTO');
                recAdop.SetRange("Item - Item Category Code", 'SEC');
                recAdop.SetRange("Item - Product Group Code");
                if recAdop.FindSet then
                    repeat
                        recAdop.CalcFields("Sales Price - Unit Price");
                        tTrabajo."MONTO BRUTO_SEC" += (recAdop."Adopcion Real" * recAdop."Sales Price - Unit Price");
                    until recAdop.Next = 0;

                //LETI
                recAdop.SetRange("Grupo de Negocio", 'SANTILLANA');
                recAdop.SetRange("Linea de negocio", '01_TEXTO');
                recAdop.SetRange("Item - Item Category Code", 'PRI');
                recAdop.SetRange("Item - Product Group Code", 'LET');
                if recAdop.FindSet then
                    repeat
                        recAdop.CalcFields("Sales Price - Unit Price");
                        tTrabajo."MONTO BRUTO_LETI" += (recAdop."Adopcion Real" * recAdop."Sales Price - Unit Price");
                    until recAdop.Next = 0;

                //BIBL
                recAdop.SetRange("Grupo de Negocio", 'SANTILLANA');
                recAdop.SetRange("Linea de negocio", '01_TEXTO');
                recAdop.SetRange("Item - Item Category Code", 'BB');
                recAdop.SetRange("Item - Product Group Code");
                if recAdop.FindSet then
                    repeat
                        recAdop.CalcFields("Sales Price - Unit Price");
                        tTrabajo."MONTO BRUTO_BIBL" += (recAdop."Adopcion Real" * recAdop."Sales Price - Unit Price");
                    until recAdop.Next = 0;
            end;

            if (gGNeg = gGNeg::General) or (gGNeg = gGNeg::Richmond) then begin
                //ING
                recAdop.SetRange("Grupo de Negocio", 'RICHMOND');
                recAdop.SetRange("Linea de negocio", '02_IDIO_ING');
                recAdop.SetFilter("Item - Item Category Code", '%1|%2|%3|%4', 'INI', 'PRI', 'SEC', 'SEI');
                recAdop.SetRange("Item - Product Group Code");
                if recAdop.FindSet then
                    repeat
                        recAdop.CalcFields("Sales Price - Unit Price");
                        tTrabajo."MONTO BRUTO_ING" += (recAdop."Adopcion Real" * recAdop."Sales Price - Unit Price");
                    until recAdop.Next = 0;

                //READ
                recAdop.SetRange("Grupo de Negocio", 'RICHMOND');
                recAdop.SetRange("Linea de negocio", '02_IDIO_ING');
                recAdop.SetRange("Item - Item Category Code", 'VAR');
                recAdop.SetRange("Item - Product Group Code");
                if recAdop.FindSet then
                    repeat
                        recAdop.CalcFields("Sales Price - Unit Price");
                        tTrabajo."MONTO BRUTO_READ" += (recAdop."Adopcion Real" * recAdop."Sales Price - Unit Price");
                    until recAdop.Next = 0;
            end;

            if (gGNeg = gGNeg::General) or (gGNeg = gGNeg::"Plan Lector") then begin
                //PLA
                recAdop.SetRange("Grupo de Negocio", 'PLAN LECTOR');
                recAdop.SetRange("Linea de negocio");
                recAdop.SetRange("Item - Item Category Code");
                recAdop.SetRange("Item - Product Group Code");
                if recAdop.FindSet then
                    repeat
                        recAdop.CalcFields("Sales Price - Unit Price");
                        tTrabajo."MONTO BRUTO_PLA" += (recAdop."Adopcion Real" * recAdop."Sales Price - Unit Price");
                    until recAdop.Next = 0;
            end;

        end;

        //GEN

        tTrabajo."MONTO BRUTO_GENERAL" := tTrabajo."MONTO BRUTO_INI" + tTrabajo."MONTO BRUTO_PRI" +
                                             tTrabajo."MONTO BRUTO_SEC" + tTrabajo."MONTO BRUTO_ING" +
                                             tTrabajo."MONTO BRUTO_READ" + tTrabajo."MONTO BRUTO_PLA" +
                                             tTrabajo."MONTO BRUTO_LETI" + tTrabajo."MONTO BRUTO_DICC" +
                                             tTrabajo."MONTO BRUTO_BIBL";
    end;


    procedure EsCampHistorica() rtn: Boolean
    var
        recHistAdop: Record "Historico Adopciones";
    begin

        recHistAdop.Reset;
        recHistAdop.SetCurrentKey(Campana, "Cod. Colegio", "Linea de negocio");
        recHistAdop.SetRange(recHistAdop.Campana, gCamp);
        rtn := recHistAdop.FindFirst;
    end;


    procedure InsertaInfoMontoTotal(var tTrabajo: Record "Tabla trabajo Ranking")
    begin

        tTrabajo."MONTO TOTAL_ESPAÑOL" := tTrabajo."MONTO BRUTO_INI" + tTrabajo."MONTO BRUTO_PRI" + tTrabajo."MONTO BRUTO_SEC" +
                                          tTrabajo."MONTO BRUTO_DICC" + tTrabajo."MONTO BRUTO_BIBL";
        tTrabajo."MONTO TOTAL_INGLES" := tTrabajo."MONTO BRUTO_ING" + tTrabajo."MONTO BRUTO_READ";
        tTrabajo."MONTO TOTAL_PLAN LECTOR" := tTrabajo."MONTO BRUTO_PLA" + tTrabajo."MONTO BRUTO_LETI";
        tTrabajo."MONTO TOTAL_GENERAL" := tTrabajo."MONTO TOTAL_ESPAÑOL" + tTrabajo."MONTO TOTAL_INGLES" + tTrabajo."MONTO TOTAL_PLAN LECTOR";
    end;


    procedure InsertaInfoPorcxLinea(var tTrabajo: Record "Tabla trabajo Ranking")
    begin

        if tTrabajo."MONTO TOTAL_GENERAL" <> 0 then begin
            tTrabajo."PORC MONTO BRUTO_ESPAÑOL" := Round(tTrabajo."MONTO TOTAL_ESPAÑOL" / tTrabajo."MONTO TOTAL_GENERAL" * 100, 1);
            tTrabajo."PORC MONTO BRUTO_INGLES" := Round(tTrabajo."MONTO TOTAL_INGLES" / tTrabajo."MONTO TOTAL_GENERAL" * 100, 1);
            tTrabajo."PORC MONTO BRUTO_PLAN LECTOR" := Round(tTrabajo."MONTO TOTAL_PLAN LECTOR" / tTrabajo."MONTO TOTAL_GENERAL" * 100, 1);
            tTrabajo."PORC MONTO BRUTO_GENERAL" := 100;
        end;
    end;


    procedure InsertaInfoColegio(var tTrabajo: Record "Tabla trabajo Ranking")
    var
        recColegioNivel: Record "Colegio - Nivel";
        recHistColegioNivel: Record "Historico Colegio - Nivel";
    begin

        tTrabajo."Cod. Colegio" := recColegio."No.";
        tTrabajo."Nombre Colegio" := recColegio.Name;
        tTrabajo.Distrito := recColegio.Distritos;
        tTrabajo.Delegación := recColegio.Región;
        //tTrabajo."Cod. Zona"  :=
        if gTipo = gTipo::CVM then begin
            if TieneAdopciones then
                tTrabajo.Estado := tTrabajo.Estado::Usuario
            else
                tTrabajo.Estado := tTrabajo.Estado::"No Usuario";
        end;

        if EsNido then
            tTrabajo.Tipo := tTrabajo.Tipo::Nido
        else
            tTrabajo.Tipo := tTrabajo.Tipo::Colegio;
    end;


    procedure OrdenarTemporal(var tTrabajo: Record "Tabla trabajo Ranking")
    var
        wCont: Integer;
    begin

        Clear(wCont);
        case gTipo of
            gTipo::General:
                begin
                    tTrabajo.SetCurrentKey(Reporte, Campaña, Delegación, "MONTO TOTAL_GENERAL");
                    tTrabajo.Ascending(false)
                end;
            gTipo::CVM:
                tTrabajo.SetCurrentKey(Reporte, Campaña, Delegación, tTrabajo."CVM GN");
        end;
        if tTrabajo.FindFirst then
            repeat
                wCont += 1;
                tTrabajo."No. Orden" := wCont;
                tTrabajo.Modify;
            until tTrabajo.Next = 0;
    end;


    procedure ValidaTipoReporte() rtn: Boolean
    var
        recColegioNivel: Record "Colegio - Nivel";
        recHistColegioNivel: Record "Historico Colegio - Nivel";
    begin

        case gTipoReporte of
            gTipoReporte::Todos:
                rtn := true;
            gTipoReporte::Colegios:
                rtn := not (EsNido);
            gTipoReporte::Nidos:
                rtn := EsNido;
        end;
    end;


    procedure EnCartera() rtn: Boolean
    var
        recHistColNivel: Record "Historico Colegio - Nivel";
        recColNivel: Record "Colegio - Nivel";
    begin

        if gHist then begin
            recHistColNivel.Reset;
            recHistColNivel.SetRange(Campana, gCamp);
            recHistColNivel.SetRange("Cod. Colegio", recColegio."No.");
            recHistColNivel.SetFilter(Ruta, '<>%1&<>%2&<>%3&<>%4&<>%5', '199', '299', '399', '499', '799');
            rtn := recHistColNivel.FindFirst;
        end
        else begin
            recColNivel.Reset;
            recColNivel.SetRange("Cod. Colegio", recColegio."No.");
            recColNivel.SetFilter(Ruta, '<>%1&<>%2&<>%3&<>%4&<>%5', '199', '299', '399', '499', '799');
            rtn := recColNivel.FindFirst;
        end;
    end;


    procedure EsNido() rtn: Boolean
    var
        recColegioNivel: Record "Colegio - Nivel";
        recHistColegioNivel: Record "Historico Colegio - Nivel";
    begin

        rtn := false;
        if gHist then begin
            recHistColegioNivel.Reset;
            recHistColegioNivel.SetCurrentKey(Campana, "Cod. Colegio", "Cod. Nivel", Turno, Ruta);
            recHistColegioNivel.SetRange(Campana, Format(gCamp));
            recHistColegioNivel.SetRange("Cod. Colegio", recColegio."No.");
            if recHistColegioNivel.FindSet then begin
                if (recHistColegioNivel.Count = 1) then begin
                    if (recHistColegioNivel."Cod. Nivel" = 'INI') then
                        rtn := true;
                end
                else begin
                    recHistColegioNivel.SetRange("Cod. Nivel", 'INI');
                    if recHistColegioNivel.FindSet then begin
                        recHistColegioNivel.SetRange("Cod. Nivel", 'PRI');
                        if not recHistColegioNivel.FindSet then begin
                            recHistColegioNivel.SetFilter("Cod. Nivel", '<>%1', 'INI');
                            recHistColegioNivel.SetFilter(Ruta, '<>%1&<>%2&<>%3&<>%4&<>%5', '199', '299', '399', '499', '799');
                            if not recHistColegioNivel.FindSet then
                                rtn := true;
                        end;
                    end;
                end;
            end;
        end
        else begin
            recColegioNivel.Reset;
            recColegioNivel.SetRange("Cod. Colegio", recColegio."No.");
            if recColegioNivel.FindSet then begin
                if (recColegioNivel.Count = 1) then begin
                    if (recColegioNivel."Cod. Nivel" = 'INI') then
                        rtn := true;
                end
                else begin
                    recColegioNivel.SetRange("Cod. Nivel", 'INI');
                    if recColegioNivel.FindSet then begin
                        recColegioNivel.SetRange("Cod. Nivel", 'PRI');
                        if not recColegioNivel.FindSet then begin
                            recColegioNivel.SetFilter("Cod. Nivel", '<>%1', 'INI');
                            recColegioNivel.SetFilter(Ruta, '<>%1&<>%2&<>%3&<>%4&<>%5', '199', '299', '399', '499', '799');
                            if not recColegioNivel.FindSet then
                                rtn := true;
                        end;
                    end;
                end;
            end;
        end;
    end;
}

