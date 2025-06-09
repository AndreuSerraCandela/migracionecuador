codeunit 76074 "Registrar Ventas en Lote DsPOX"
{
    // $001 24/07/15 JML : Añado dimensiones por defecto POS
    // #44884  26/02/2016  MOI   En el proceso nocturno, si la factura o las lineas tiene un cupon este se tiene que marcar como pendiente FALSE.
    //                           En el proceso nocturno, si las lineas de la nota de credito tiene un cupon este se tiene que marcar como pendiente TRUE.
    // 
    // #65232  PLB 10/05/2017: Temas Varios DSPOS - Mejoras
    //            03/07/2017: Si no tiene pagos y el cliente permite venta a crédito, no guardar el error en la tabla
    // 
    // #76946  RRT 20.01.2018: Creación de la funcion localizada FinalProcesoRegistro()
    // #75918  RRT 15.03.2018: Testear exclusividad "Nº fiscal TPV" en Bolivia. Para que sea generico se establece una función en la CU del país para
    //            comprobar inconvenientes antes de registrar.
    // 
    // #116510 RRT 07.11.2018: Actualización de DS-POS en Honduras.
    //         #57166  28/09/16    JMB   :   Se actualiza los nº de serie al registrar el documento
    // 
    // #126073 RRT 22.04.2018: Seguimiento y registro del error que pudiera ocurrir al ejecutar FE() en Guatemala.
    // #201856 RRT 25.02.2018: Replantear el control cuando no han llegado los pagos.
    // #232158 RRT 27.06.2019: Adaptacion a FE 2.0
    // #232158 RRT 18.11.2019: En la empresa <ACTIVA EDUCA> de Guatemala la facturación electrónica debe ser con
    //             el metodo anterior. Se ha modificado la función Registro_Localizado()
    // 
    // #246745 RRT 29.07.2019: Que en la función TestIntegridad() se devuelva FALSE, si faltan datos de pagos o no se ha completado la transacción.
    // #257334 RRT 28.08.2019: Para prevenir errores en la liquidacion de un documento, se comprueba que todos los registros en <Transacciones TPV Caja> correspondan a la misma transaccion.
    // #273889 RRT 15.10.2019: Se quita el control sobre "Pagos TPV" temporalmente.
    // #348662 RRT 26.11.2020: Unificación de DS-POS.
    // #305288 RRT 10.03.2020: Revisar el test de integridad para Honduras.
    // #350950 RRT 23.12.2020: Se ha visto que no se estaba especificando el num. documento en el log de derrores.
    // #355717 RRT 21.01.2021: Adaptaciones para Ecuador.
    // #380380 RRT 10.05.2021: Ajuste para autorización SRI
    // #438130 RRT 20.01.2022: Permitir registrar documentos con importe CERO.
    // #514701 RRT 30.12.2022: Adaptaciones tras la migración a BC.

    Permissions = TableData "Sales Invoice Header" = rimd,
                  TableData "Sales Cr.Memo Header" = rimd;

    trigger OnRun()
    var
        rCabLog: Record "Cabecera Log Registro POS";
        Text000: Label 'Registrar Facturas en su Fecha.,Solicitar Nueva Fecha de Registro.';
        Text001: Label 'Se procederá a Registrar y Liquidar todas las ventas de Tienda\¿Desea Continuar?';
        Text002: Label 'Proceso Terminado';
        Error001: Label 'Cancelado a Petición del Usuario';
        CduPOS: Codeunit "Funciones Addin DSPos";
        Error002: Label 'Proceso Sólo Disponible en Servidor Central';
        recTPV: Record "Configuracion TPV";
        Seleccion: Integer;
        PagFecha: Page "Petición de Fecha";
        Error003: Label 'La fecha de registro no puede ser inferior a la fecha actual';
    begin
        //+999 PLB
        //IF USERID <> 'SANTILLANA-NAV\DYNASOFT' THEN
        //  ERROR('El sistema está en modo depuración, se está trabajando para resolver un problema con la liquidación del DSPos. En breve esta opción volverá a estar habilitada.');
        //-999 PLB


        if GuiAllowed then begin

            recTPV.SetRange("Usuario windows", CduPOS.TraerUsuarioWindows);
            if recTPV.FindFirst then
                Error(Error002);

            if not Confirm(Text001, false) then
                Error(Error001);

            Seleccion := StrMenu(Text000, 1);
            if Seleccion = 0 then
                Error(Error001);

            if Seleccion = 2 then begin
                Clear(PagFecha);
                PagFecha.LookupMode(true);

                if PagFecha.RunModal = ACTION::Yes then begin
                    wFechaProceso := PagFecha.DevolverFecha();
                    case true of
                        (wFechaProceso = 0D):
                            Error(Error001);
                        (wFechaProceso < Today):
                            Error(Error003);
                        (wFechaProceso < WorkDate):
                            Error(Error003);
                    end;
                end
                else
                    Error(Error001);

            end;

        end;

        BorrarDocumentosDuplicados;

        rCabLog.Init;
        rCabLog.Fecha := WorkDate;
        rCabLog."Hora Inicio" := FormatTime(Time);
        rCabLog.Insert(true);
        wNumLog := rCabLog."No. Log";

        RegistroNocturno();
        LiquidarRegistrados();

        rCabLog."Fecha Fin" := WorkDate;
        rCabLog."Hora Fin" := FormatTime(Time);
        rCabLog.Modify(false);

        //+76946
        Final_Localizado;
        //-76946


        if GuiAllowed then
            Message(Text002);
    end;

    var
        dlgProgreso: Dialog;
        wNumLog: Integer;
        wFechaProceso: Date;

        wFechaInicio: Date;
        wFechaFin: Date;


    procedure RegistroNocturno()
    var
        recCabVta: Record "Sales Header";
        intProcesados: Integer;
        intTotal: Integer;

        Text001: Label 'Registrando documentos DsPOS :\\Facturas @@@@@@@@@@@@@@@@@@@@1\Notas de crédito  @@@@@@@@@@@@@@@@@@@@2';
        Text002: Label 'Registrada Correctamente';
        Text003: Label ' Error Registro: %1';
        rParametros: Record "Param. CDU DsPOS";
        Text004: Label 'Liquidada Correctamente.';
        Text005: Label 'Error Liquidar Fac: %1';
        Text006: Label 'Registrada Correctamente.';
        Text007: Label 'Error Registro : %1';
        Text008: Label 'Liquidada Correctamente.';
        Text009: Label 'Error Liquidación NC: %1';
        rPagos: Record "Pagos TPV";
        rTiendas: Record Tiendas;
        rLinVta: Record "Sales Line";
        wPagoEncontrado: Boolean;
        rCliente: Record Customer;
        rTPV: Record "Configuracion TPV";
        Text010: Label 'La venta no tiene cobros asocidados y el cliente "%1" no tiene la marca "%2".';
        rTipoPago: Record "Formas de Pago";
        rTransCajaTPV: Record "Transacciones Caja TPV";
        SigTransaccion: Integer;
    begin

        if GuiAllowed then
            dlgProgreso.Open(Text001);

        wFechaInicio := DMY2Date(1, 12, 2022);
        wFechaFin := DMY2Date(31, 12, 2022);


        // with recCabVta do begin
        //     Reset;
        //     SetRange("Document Type", "Document Type"::Invoice);
        //     SetRange("Venta TPV", true);
        //     SetRange("Registrado TPV", true);
        //     SetRange("Posting Date", wFechaInicio, wFechaFin); //ATT.RRT.

        //     if FindSet then begin

        //         intTotal := Count;
        //         intProcesados := 0;

        //         repeat

        //             //+#201856
        //             //... Revisamos si están las líneas (y pagos¿?)
        //             //+#75918
        //             //IF TestRegistroViable(recCabVta) THEN BEGIN
        //             //-75918
        //             if TestRegistroViable(recCabVta) and TestIntegridad(recCabVta) then begin
        //                 //-#201856

        //                 ClearLastError;
        //                 AsignarDimensiones(recCabVta);
        //                 Commit;

        //                 Ship := true;
        //                 Invoice := true;
        //                 wPagoEncontrado := false;

        //                 if wFechaProceso <> 0D then
        //                     "Posting Date" := wFechaProceso;

        //                 rCliente.Get("Sell-to Customer No.");

        //                 //+#65232
        //                 /*
        //                 rPagos.RESET;
        //                 rPagos.SETRANGE("No. Borrador" , "No.");
        //                 wPagoEncontrado := rPagos.FINDFIRST;

        //                 IF wPagoEncontrado OR (rCliente."Permite venta a credito") THEN BEGIN
        //                 */
        //                 if not TienePago("No.", "Posting No.") and not rCliente."Permite venta a credito" then
        //                     CrearPagoBorrador(recCabVta);

        //                 if TienePago("No.", "Posting No.") or rCliente."Permite venta a credito" then begin
        //                     //-#65232

        //                     rTPV.Reset;
        //                     rTPV.Get(Tienda, TPV);
        //                     if not rTPV."Venta Movil" then begin
        //                         rTiendas.Reset;
        //                         if rTiendas.Get(Tienda) then
        //                             if ("Location Code" <> rTiendas."Cod. Almacen") and
        //                                (rTiendas."Cod. Almacen" <> '') then begin
        //                                 "Location Code" := rTiendas."Cod. Almacen";

        //                                 rLinVta.Reset;
        //                                 rLinVta.SetRange("Document No.", "No.");
        //                                 rLinVta.SetRange("Document Type", "Document Type");
        //                                 if rLinVta.FindSet then
        //                                     rLinVta.ModifyAll("Location Code", rTiendas."Cod. Almacen", false);
        //                             end;

        //                         Modify(false);
        //                         Commit;
        //                     end;


        //                     Ajustes_AntesDe_Registrar(recCabVta); //+#380380

        //                     Commit; //#325138

        //                     //+#514701
        //                     //IF CODEUNIT.RUN(CODEUNIT::"Ventas-Registrar DsPOS",recCabVta) THEN BEGIN
        //                     if CODEUNIT.Run(CODEUNIT::"Sales-Post", recCabVta) then begin
        //                         //-#514701

        //                         // #57166 : INI
        //                         ActualizarSeries(recCabVta."No. Series", recCabVta."No.");                       // Borrador
        //                         ActualizarSeries(recCabVta."Posting No. Series", recCabVta."Last Posting No.");          // Registradas
        //                         ActualizarSeries(recCabVta."No. Serie NCF Facturas", recCabVta."No. Comprobante Fiscal");    // NCF
        //                                                                                                                      // #57166 : FIN

        //                         //#44884:Inicio
        //                         marcarCupones(recCabVta);
        //                         //#44884:Fin

        //                         InsertarDetalle(recCabVta, 0, false, StrSubstNo(Text002, recCabVta."No. Fiscal TPV"));
        //                         Registro_Localizado(recCabVta);

        //                         if wPagoEncontrado then begin
        //                             rParametros.Reset;
        //                             rParametros.Accion := rParametros.Accion::LiquidarFactura;
        //                             rParametros.Documento := recCabVta."Last Posting No.";
        //                             rParametros.Manual := false;
        //                             Commit;

        //                         end;

        //                     end
        //                     else
        //                         InsertarDetalle(recCabVta, 0, true, StrSubstNo(Text003, GetLastErrorText));
        //                 end
        //                 //+#65232
        //                 else
        //                     if not rCliente."Permite venta a credito" then
        //                         InsertarDetalle(recCabVta, 0, true, StrSubstNo(Text010, rCliente."No.", rCliente.FieldCaption("Permite venta a credito")));
        //                 //-#65232

        //                 if GuiAllowed then begin
        //                     intProcesados += 1;
        //                     dlgProgreso.Update(1, Round(intProcesados / intTotal * 10000, 1));
        //                 end;

        //             end; //+#75918

        //         until Next = 0;

        //     end;

        //     Reset;
        //     SetRange("Document Type", "Document Type"::"Credit Memo");
        //     SetRange("Venta TPV", true);
        //     SetRange("Registrado TPV", true);
        //     SetRange("Posting Date", wFechaInicio, wFechaFin); //ATT.RRT.


        //     if FindSet then begin

        //         intTotal := Count;
        //         intProcesados := 0;

        //         repeat

        //             //+#201856
        //             //... Revisamos si están las líneas (y pagos¿?)
        //             //+#75918
        //             //IF TestRegistroViable(recCabVta) THEN BEGIN
        //             //-75918
        //             if TestRegistroViable(recCabVta) and TestIntegridad(recCabVta) then begin
        //                 //-#201856

        //                 ClearLastError;
        //                 AsignarDimensiones(recCabVta);
        //                 Commit;

        //                 Ship := true;
        //                 Invoice := true;
        //                 wPagoEncontrado := false;

        //                 rCliente.Get("Sell-to Customer No.");

        //                 if wFechaProceso <> 0D then
        //                     "Posting Date" := wFechaProceso;
        //                 //+999
        //                 //ELSE IF (USERID = 'SANTILLANA-NAV\DYNASOFT') AND ("Posting Date" < CALCDATE('<-CM>',WORKDATE)) THEN
        //                 //  "Posting Date" := WORKDATE;
        //                 //-999

        //                 //+#65232
        //                 /*
        //                 rPagos.RESET;
        //                 rPagos.SETRANGE("No. Borrador" , recCabVta."No.");
        //                 wPagoEncontrado := rPagos.FINDFIRST;

        //                 IF wPagoEncontrado OR rCliente."Permite venta a credito"  THEN BEGIN
        //                 */
        //                 if not TienePago("No.", "Posting No.") and not rCliente."Permite venta a credito" then
        //                     CrearPagoBorrador(recCabVta);

        //                 if TienePago("No.", "Posting No.") or rCliente."Permite venta a credito" then begin
        //                     //-#65232

        //                     rTPV.Reset;
        //                     rTPV.Get(Tienda, TPV);
        //                     if not rTPV."Venta Movil" then begin
        //                         rTiendas.Reset;
        //                         if rTiendas.Get(Tienda) then
        //                             if ("Location Code" <> rTiendas."Cod. Almacen") and
        //                                (rTiendas."Cod. Almacen" <> '') then begin
        //                                 "Location Code" := rTiendas."Cod. Almacen";

        //                                 rLinVta.Reset;
        //                                 rLinVta.SetRange("Document No.", "No.");
        //                                 rLinVta.SetRange("Document Type", "Document Type");
        //                                 if rLinVta.FindSet then
        //                                     rLinVta.ModifyAll("Location Code", rTiendas."Cod. Almacen", false);
        //                             end;

        //                         Modify(false);
        //                         Commit;
        //                     end;

        //                     //+#355717
        //                     Ajustes_NCR_Pais(recCabVta);
        //                     //-#355717

        //                     Ajustes_AntesDe_Registrar(recCabVta); //+#380380

        //                     Commit; //#325138

        //                     //+#514701
        //                     //IF CODEUNIT.RUN(CODEUNIT::"Ventas-Registrar DsPOS",recCabVta) THEN BEGIN
        //                     if CODEUNIT.Run(CODEUNIT::"Sales-Post", recCabVta) then begin
        //                         //-#514701

        //                         // #57166 : INI
        //                         ActualizarSeries(recCabVta."No. Series", recCabVta."No.");                       // Borrador
        //                         ActualizarSeries(recCabVta."Posting No. Series", recCabVta."Last Posting No.");          // Registradas
        //                         ActualizarSeries(recCabVta."No. Serie NCF Abonos", recCabVta."No. Comprobante Fiscal");    // NCF
        //                                                                                                                    // #57166 : FIN

        //                         //#44884:Inicio
        //                         marcarCupones(recCabVta);
        //                         //#44884:Fin

        //                         InsertarDetalle(recCabVta, 0, false, StrSubstNo(Text006, recCabVta."No. Fiscal TPV"));
        //                         Registro_Localizado(recCabVta);

        //                         if wPagoEncontrado then begin
        //                             rParametros.Reset;
        //                             rParametros.Accion := rParametros.Accion::LiquidarNotaCredito;
        //                             rParametros.Documento := recCabVta."Last Posting No.";
        //                             rParametros.Manual := false;

        //                             Commit;

        //                         end;

        //                     end
        //                     else
        //                         InsertarDetalle(recCabVta, 0, true, StrSubstNo(Text007, GetLastErrorText));
        //                 end
        //                 //+#65232
        //                 else
        //                     if not rCliente."Permite venta a credito" then
        //                         InsertarDetalle(recCabVta, 0, true, StrSubstNo(Text010, rCliente."No.", rCliente.FieldCaption("Permite venta a credito")));
        //                 //-#65232

        //                 if GuiAllowed then begin
        //                     intProcesados += 1;
        //                     dlgProgreso.Update(2, Round(intProcesados / intTotal * 10000, 1));
        //                 end;

        //             end; //+#75918

        //         until Next = 0;
        //     end;

        // end;

        if GuiAllowed then
            dlgProgreso.Close;

    end;


    procedure AsignarDimensiones(var recPrmCabVta: Record "Sales Header")
    var
        recLinVta: Record "Sales Line";
        recDimPOS: Record "Dimensiones POS";
        DimMgt: Codeunit DimensionManagement;
        recTmpDimEntry: Record "Dimension Set Entry" temporary;
        recDimVal: Record "Dimension Value";
    begin
        // with recPrmCabVta do begin

        //     SetHideValidationDialog(true);
        //     /*             CreateDim(
        //                     DATABASE::Customer, "Bill-to Customer No.",
        //                     DATABASE::"Salesperson/Purchaser", "Salesperson Code",
        //                     DATABASE::Campaign, "Campaign No.",
        //                     DATABASE::"Responsibility Center", "Responsibility Center",
        //                     DATABASE::"Customer Template", "Bill-to Customer Templ. Code"); */

        //     recLinVta.Reset;
        //     recLinVta.SetRange("Document Type", "Document Type");
        //     recLinVta.SetRange("Document No.", "No.");
        //     if recLinVta.FindSet then
        //         repeat
        //         /*          recLinVta.CreateDim(
        //                    DimMgt.TypeToTableID3(recLinVta.Type), recLinVta."No.",
        //                    DATABASE::Job, recLinVta."Job No.",
        //                    DATABASE::"Responsibility Center", recLinVta."Responsibility Center");
        //                  recLinVta.Modify; */
        //         until recLinVta.Next = 0;


        //     //<$001
        //     //Añadimos las dimensiones por defecto del POS a la cabecera
        //     recDimPOS.Reset;
        //     recDimPOS.SetFilter("Valor dimension", '<>%1', '');
        //     if recDimPOS.FindSet then begin
        //         repeat

        //             DimMgt.GetDimensionSet(recTmpDimEntry, "Dimension Set ID");

        //             if recTmpDimEntry.Get("Dimension Set ID", recDimPOS.Dimension) then begin
        //                 recTmpDimEntry."Dimension Value Code" := recDimPOS."Valor dimension";
        //                 recDimVal.Get(recTmpDimEntry."Dimension Code", recTmpDimEntry."Dimension Value Code");
        //                 recTmpDimEntry."Dimension Value ID" := recDimVal."Dimension Value ID";
        //                 recTmpDimEntry.Modify;
        //             end
        //             else begin
        //                 recTmpDimEntry.Init;
        //                 recTmpDimEntry."Dimension Code" := recDimPOS.Dimension;
        //                 recTmpDimEntry."Dimension Value Code" := recDimPOS."Valor dimension";
        //                 recDimVal.Get(recTmpDimEntry."Dimension Code", recTmpDimEntry."Dimension Value Code");
        //                 recTmpDimEntry."Dimension Value ID" := recDimVal."Dimension Value ID";
        //                 recTmpDimEntry.Insert;
        //             end;

        //         until recDimPOS.Next = 0;
        //         recPrmCabVta."Dimension Set ID" := DimMgt.GetDimensionSetID(recTmpDimEntry);
        //         recPrmCabVta.Modify;
        //     end;

        //     //Añadimos las dimensiones por defecto del POS a cada línea

        //     recLinVta.Reset;
        //     recLinVta.SetRange("Document Type", "Document Type");
        //     recLinVta.SetRange("Document No.", "No.");
        //     if recLinVta.FindSet then
        //         repeat
        //             recDimPOS.Reset;
        //             recDimPOS.SetFilter("Valor dimension", '<>%1', '');
        //             if recDimPOS.FindSet then begin
        //                 repeat

        //                     recTmpDimEntry.DeleteAll;
        //                     DimMgt.GetDimensionSet(recTmpDimEntry, recLinVta."Dimension Set ID");

        //                     if recTmpDimEntry.Get(recLinVta."Dimension Set ID", recDimPOS.Dimension) then begin
        //                         recTmpDimEntry."Dimension Value Code" := recDimPOS."Valor dimension";
        //                         recDimVal.Get(recTmpDimEntry."Dimension Code", recTmpDimEntry."Dimension Value Code");
        //                         recTmpDimEntry."Dimension Value ID" := recDimVal."Dimension Value ID";
        //                         recTmpDimEntry.Modify;
        //                     end
        //                     else begin
        //                         recTmpDimEntry.Init;
        //                         recTmpDimEntry."Dimension Code" := recDimPOS.Dimension;
        //                         recTmpDimEntry."Dimension Value Code" := recDimPOS."Valor dimension";
        //                         recDimVal.Get(recTmpDimEntry."Dimension Code", recTmpDimEntry."Dimension Value Code");
        //                         recTmpDimEntry."Dimension Value ID" := recDimVal."Dimension Value ID";
        //                         recTmpDimEntry.Insert;
        //                     end;

        //                 until recDimPOS.Next = 0;
        //                 recLinVta."Dimension Set ID" := DimMgt.GetDimensionSetID(recTmpDimEntry);
        //                 recLinVta.Modify;
        //             end;

        //         until recLinVta.Next = 0;

        //     //$001>

        // end;
    end;


    procedure BorrarDocumentosDuplicados()
    var
        rec36: Record "Sales Header";
        rec37: Record "Sales Line";
        rec112: Record "Sales Invoice Header";
        rec114: Record "Sales Cr.Memo Header";
    begin

        rec36.Reset;
        rec36.SetRange("Document Type", rec36."Document Type"::Invoice);
        rec36.SetRange("Venta TPV", true);
        rec36.SetRange("Registrado TPV", true);
        if rec36.FindSet then begin
            repeat
                //+#65232
                //if rec112.GET(rec36."Posting No.") THEN BEGIN
                rec112.SetRange("No.", rec36."Posting No.");
                rec112.SetRange("No. Fiscal TPV", rec36."No. Fiscal TPV");
                rec112.SetRange(TPV, rec36.TPV);
                rec112.SetRange(Tienda, rec36.Tienda);
                rec112.SetRange("Hora creacion", rec36."Hora creacion");
                if rec112.FindFirst then begin
                    //-#65232
                    rec37.Reset;
                    rec37.SetRange("Document Type", rec36."Document Type");
                    rec37.SetRange("Document No.", rec36."No.");
                    rec37.DeleteAll;
                    rec36.Delete;
                end;
            until rec36.Next = 0;
        end;

        rec36.Reset;
        rec36.SetRange("Document Type", rec36."Document Type"::"Credit Memo");
        rec36.SetRange("Venta TPV", true);
        rec36.SetRange("Registrado TPV", true);
        if rec36.FindSet then begin
            repeat
                //+#65232
                //IF rec114.GET(rec36."Posting No.") THEN BEGIN
                rec114.SetRange("No.", rec36."Posting No.");
                rec114.SetRange("No. Fiscal TPV", rec36."No. Fiscal TPV");
                rec114.SetRange(TPV, rec36.TPV);
                rec114.SetRange(Tienda, rec36.Tienda);
                rec114.SetRange("Hora creacion", rec36."Hora creacion");
                if rec114.FindFirst then begin
                    //-#65232
                    rec37.Reset;
                    rec37.SetRange("Document Type", rec36."Document Type");
                    rec37.SetRange("Document No.", rec36."No.");
                    rec37.DeleteAll;
                    rec36.Delete;
                end;
            until rec36.Next = 0;
        end;
    end;


    procedure FormatTime(timEntrada: Time): Time
    var
        texHora: Text;
        timSalida: Time;
    begin

        texHora := Format(timEntrada);
        Evaluate(timSalida, texHora);
        exit(timSalida);
    end;


    procedure InsertarDetalle(prCab: Record "Sales Header"; pProceso: Option Registro,Liquidacion,Firma; pError: Boolean; pTexto: Text)
    var
        rLinLog: Record "Detalle Log Registro DsPOS";
    begin

        // with rLinLog do begin

        //     Init;

        //     "No. Log" := wNumLog;
        //     Error := pError;

        //     case prCab."Document Type" of
        //         prCab."Document Type"::Invoice:
        //             "Tipo Documento" := "Tipo Documento"::Factura;
        //         prCab."Document Type"::"Credit Memo":
        //             "Tipo Documento" := "Tipo Documento"::"Nota Credito";
        //     end;

        //     if not Error then begin
        //         case pProceso of
        //             pProceso::Registro:
        //                 Registrado := true;
        //             pProceso::Liquidacion:
        //                 Liquidado := true;

        //             //+#126073
        //             pProceso::Firma:
        //                 Firmado := true;
        //         //-#126073

        //         end;
        //     end;

        //     "No. Documento" := prCab."No. Fiscal TPV";

        //     //+#65232
        //     if "No. Documento" = '' then
        //         "No. Documento" := prCab."Posting No.";
        //     //-#65232

        //     //+#514701
        //     if "No. Documento" = '' then
        //         "No. Documento" := prCab."No.";
        //     //-#514701

        //     "Fecha Documento" := prCab."Posting Date";
        //     Tienda := prCab.Tienda;
        //     TPV := prCab.TPV;

        //     //+#126073
        //     //Texto             := pTexto;
        //     Texto := CopyStr(pTexto, 1, MaxStrLen(Texto));
        //     //-#126073

        //     "No. documento NAV" := prCab."Last Posting No.";
        //     Insert(true);

        // end;
    end;


    procedure LiquidarRegistrados()
    var
        recCabVta: Record "Sales Header";
        recCabFac: Record "Sales Invoice Header";
        recCabNC: Record "Sales Cr.Memo Header";
        rCliente: Record Customer;
        intProcesados: Integer;
        intTotal: Integer;

        Text001: Label 'Liquidando documentos DsPOS :\\Facturas @@@@@@@@@@@@@@@@@@@@1\Notas de crédito  @@@@@@@@@@@@@@@@@@@@2';
        rParametros: Record "Param. CDU DsPOS";
        Text004: Label 'Liquidada Correctamente.';
        Text005: Label 'Error Liquidar Fac: %1';
        Text008: Label 'Liquidada Correctamente.';
        Text009: Label 'Error Liquidación NC: %1';
        rPagos: Record "Pagos TPV";
        lFechaLimite: Date;
    begin

        if GuiAllowed then
            dlgProgreso.Open(Text001);

        //+#199415
        lFechaLimite := Today;
        if wFechaProceso > Today then
            lFechaLimite := wFechaProceso;
        //-#199415


        // with recCabFac do begin

        //     Reset;
        //     SetCurrentKey("Posting Date", Tienda, "Venta TPV");
        //     SetRange("Venta TPV", true);

        //     //+#199415
        //     //SETRANGE("Posting Date"   , TODAY -31 , TODAY);
        //     SetRange("Posting Date", Today - 31, lFechaLimite);
        //     //-#199415

        //     SetRange("Liquidado TPV", false);

        //     if FindSet then begin

        //         intTotal := Count;
        //         intProcesados := 0;

        //         repeat

        //             ClearLastError;

        //             //+#65232
        //             /*
        //             COMMIT;

        //             rPagos.RESET;
        //             rPagos.SETCURRENTKEY("No. Factura","Cod. divisa");
        //             rPagos.SETRANGE("No. Factura", "No.");
        //             IF rPagos.FINDFIRST THEN BEGIN
        //             */

        //             rCliente.Get("Sell-to Customer No.");
        //             if not TienePago("Pre-Assigned No.", "No.") and not rCliente."Permite venta a credito" then
        //                 CrearPagoFactura(recCabFac);

        //             if TienePago("Pre-Assigned No.", "No.") then begin
        //                 //-#65232

        //                 recCabVta.Init;
        //                 recCabVta."Document Type" := recCabVta."Document Type"::Invoice;
        //                 recCabVta."No. Fiscal TPV" := "No. Fiscal TPV";

        //                 //+#350950
        //                 if recCabVta."No. Fiscal TPV" = '' then
        //                     recCabVta."No. Fiscal TPV" := "No.";
        //                 //-#350950

        //                 recCabVta."Posting Date" := "Posting Date";
        //                 recCabVta.Tienda := Tienda;
        //                 recCabVta.TPV := TPV;

        //                 rParametros.Reset;
        //                 rParametros.Accion := rParametros.Accion::LiquidarFactura;
        //                 rParametros.Documento := "No.";
        //                 rParametros.Manual := false;
        //                 Commit;



        //             end;

        //             if GuiAllowed then begin
        //                 intProcesados += 1;
        //                 dlgProgreso.Update(1, Round(intProcesados / intTotal * 10000, 1));
        //             end;

        //         until Next = 0;

        //     end;
        // end;

        // with recCabNC do begin

        //     Reset;
        //     SetCurrentKey("Posting Date", Tienda, "Venta TPV");
        //     SetRange("Venta TPV", true);
        //     //+#199415
        //     //SETRANGE("Posting Date"   , TODAY -31 , TODAY);
        //     SetRange("Posting Date", Today - 31, lFechaLimite);
        //     //-#199415

        //     SetRange("Liquidado TPV", false);

        //     if FindSet then begin

        //         intTotal := Count;
        //         intProcesados := 0;

        //         repeat

        //             ClearLastError;

        //             //+#65232
        //             /*
        //             COMMIT;

        //             rPagos.RESET;
        //             rPagos.SETCURRENTKEY("No. Nota Credito");
        //             rPagos.SETRANGE("No. Nota Credito", "No.");
        //             IF rPagos.FINDFIRST THEN BEGIN
        //               COMMIT;
        //             */
        //             rCliente.Get("Sell-to Customer No.");
        //             if not TienePago("Pre-Assigned No.", "No.") and not rCliente."Permite venta a credito" then
        //                 CrearPagoNotaCr(recCabNC);

        //             if TienePago("Pre-Assigned No.", "No.") then begin
        //                 //-#65232

        //                 recCabVta.Init;
        //                 recCabVta."Document Type" := recCabVta."Document Type"::"Credit Memo";
        //                 recCabVta."No. Fiscal TPV" := "No. Fiscal TPV";

        //                 //+#350950
        //                 if recCabVta."No. Fiscal TPV" = '' then
        //                     recCabVta."No. Fiscal TPV" := "No.";
        //                 //-#350950

        //                 recCabVta."Posting Date" := "Posting Date";
        //                 recCabVta.Tienda := Tienda;
        //                 recCabVta.TPV := TPV;

        //                 rParametros.Reset;
        //                 rParametros.Accion := rParametros.Accion::LiquidarNotaCredito;
        //                 rParametros.Documento := "No.";
        //                 rParametros.Manual := false;
        //                 Commit;

        //             end;

        //             if GuiAllowed then begin
        //                 intProcesados += 1;
        //                 dlgProgreso.Update(2, Round(intProcesados / intTotal * 10000, 1));
        //             end;

        //         until Next = 0;
        //     end;

        // end;

        if GuiAllowed then
            dlgProgreso.Close;

    end;


    procedure Registro_Localizado(pSalesH: Record "Sales Header")
    var

    begin

    end;


    procedure marcarCupones(pSalesHeader: Record "Sales Header")
    var
        lrSalesInvoiceHeader: Record "Sales Invoice Header";
        lrCabeceraCupon: Record "Cab. Cupon.";
        lrSalesInvoiceLine: Record "Sales Invoice Line";
        lrSalesCrMemoLine: Record "Sales Cr.Memo Line";
    begin
        //#44884:Inicio
        case pSalesHeader."Document Type" of
            pSalesHeader."Document Type"::Invoice:
                begin
                    lrSalesInvoiceHeader.Get(pSalesHeader."Last Posting No.");

                    if lrSalesInvoiceHeader."Cod. Cupon" <> '' then begin
                        //buscar el cupon
                        lrCabeceraCupon.Get(lrSalesInvoiceHeader."Cod. Cupon");
                        lrCabeceraCupon.Pendiente := false;
                        lrCabeceraCupon.Modify(false);
                    end
                    else begin
                        //buscar los cupones asignados a las lineas de la factura
                        lrSalesInvoiceLine.Reset;
                        lrSalesInvoiceLine.SetRange(lrSalesInvoiceLine."Document No.", lrSalesInvoiceHeader."No.");
                        if lrSalesInvoiceLine.FindSet() then
                            repeat
                                if lrSalesInvoiceLine."Cod. Cupon" <> '' then begin
                                    //buscar el cupon
                                    lrCabeceraCupon.Get(lrSalesInvoiceLine."Cod. Cupon");
                                    lrCabeceraCupon.Pendiente := false;
                                    lrCabeceraCupon.Modify(false);
                                end;
                            until lrSalesInvoiceLine.Next = 0;
                    end;
                end;
            pSalesHeader."Document Type"::"Credit Memo":
                begin
                    lrSalesCrMemoLine.SetRange(lrSalesCrMemoLine."Document No.", pSalesHeader."Last Posting No.");
                    if lrSalesCrMemoLine.FindSet() then
                        repeat
                            if lrSalesCrMemoLine."Cod. Cupon" <> '' then begin
                                //lrCabeceraCupon.GET(lrSalesInvoiceLine."Cod. Cupon"); //-#65232
                                lrCabeceraCupon.Get(lrSalesCrMemoLine."Cod. Cupon"); //+#65232
                                lrCabeceraCupon.Pendiente := true;
                                lrCabeceraCupon.Modify(false);
                            end;
                        until lrSalesCrMemoLine.Next = 0;
                end;
        end;
        //#44884:Fin
    end;


    procedure TienePago(NoBorrador: Code[20]; NoRegistrado: Code[20]): Boolean
    var
        rPagos: Record "Pagos TPV";
        rTransCaja: Record "Transacciones Caja TPV";
    begin
        //+#65232: nueva función

        rPagos.Reset;
        rPagos.SetRange("No. Borrador", NoBorrador);
        if not rPagos.IsEmpty then
            exit(true);

        rTransCaja.Reset;
        rTransCaja.SetCurrentKey("No. Registrado", rTransCaja."Cod. divisa");
        rTransCaja.SetRange("No. Registrado", NoRegistrado);
        exit(not rTransCaja.IsEmpty);
    end;


    procedure CrearPago(NoBorrador: Code[20]; NoRegistrado: Code[20]; Importe: Decimal; EsAbono: Boolean; CodTienda: Code[20]; CodTPV: Code[20]; Fecha: Date; Hora: Time; IdCajero: Code[50])
    var
        rPagos: Record "Pagos TPV";
        rTransCaja: Record "Transacciones Caja TPV";
        rTipoPago: Record "Formas de Pago";
        SigTransaccion: Integer;
    begin
        //+#65232: nueva función

        rTipoPago.SetRange("Efectivo Local", true);
        rTipoPago.FindFirst;

        rPagos.Init;
        rPagos."No. Borrador" := NoBorrador;
        rPagos."Forma pago TPV" := rTipoPago."ID Pago";
        rPagos.Cambio := false;
        rPagos.Tienda := CodTienda;
        rPagos.TPV := CodTPV;
        rPagos."Cod. divisa" := '';
        rPagos."Importe (DL)" := Importe;
        rPagos.Importe := Importe;
        rPagos.Fecha := Fecha;
        rPagos.Hora := Hora;
        if EsAbono then
            rPagos."No. Nota Credito" := NoRegistrado
        else
            rPagos."No. Factura" := NoRegistrado;
        rPagos."Factor divisa" := 1;
        rPagos.Insert;

        rTransCaja.Reset;
        rTransCaja.SetRange("Cod. tienda", CodTienda);
        rTransCaja.SetRange("Cod. TPV", CodTPV);
        rTransCaja.SetRange(Fecha, Fecha);
        rTransCaja.SetRange("No. turno", 999);
        if rTransCaja.FindLast then
            SigTransaccion := rTransCaja."No. transaccion" + 1
        else
            SigTransaccion := 1;

        rTransCaja.Init;
        rTransCaja."Cod. tienda" := CodTienda;
        rTransCaja."Cod. TPV" := CodTPV;
        rTransCaja.Fecha := Fecha;
        rTransCaja."No. turno" := 999;
        rTransCaja."No. transaccion" := SigTransaccion;
        rTransCaja."Tipo transaccion" := rTransCaja."Tipo transaccion"::"Cobro TPV";
        rTransCaja."Id. cajero" := IdCajero;
        rTransCaja.Hora := Hora;
        rTransCaja."Forma de pago" := rPagos."Forma pago TPV";
        rTransCaja.Importe := rPagos.Importe;
        rTransCaja."Importe (DL)" := rPagos."Importe (DL)";
        rTransCaja."Cod. divisa" := rPagos."Cod. divisa";
        rTransCaja."Factor divisa" := rPagos."Factor divisa";
        rTransCaja."No. Registrado" := NoRegistrado;
        rTransCaja.Cambio := rPagos.Cambio;
        rTransCaja.Insert;
    end;


    procedure CrearPagoBorrador(recCabVta: Record "Sales Header")
    begin
        //+#65232: nueva función

        // with recCabVta do begin
        //     CalcFields("Amount Including VAT");

        //     if "Document Type" = "Document Type"::Invoice then
        //         CrearPago("No.", "Posting No.", "Amount Including VAT", false, Tienda, TPV, "Posting Date", "Hora creacion", "ID Cajero")
        //     else
        //         CrearPago("No.", "Posting No.", -"Amount Including VAT", true, Tienda, TPV, "Posting Date", "Hora creacion", "ID Cajero");
        // end;
    end;


    procedure CrearPagoFactura(recCabVta: Record "Sales Invoice Header")
    var
        recMovCliente: Record "Cust. Ledger Entry";
        optPrmTipoDoc: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
    begin
        //+#65232: nueva función

        // with recCabVta do begin
        //     if GetMovClientePendiente(recMovCliente, recCabVta."Sell-to Customer No.", optPrmTipoDoc::Invoice, recCabVta."No.") then begin
        //         recMovCliente.CalcFields("Remaining Amt. (LCY)");

        //         CrearPago(recCabVta."Pre-Assigned No.", "No.", recMovCliente."Remaining Amt. (LCY)", false, Tienda, TPV, "Posting Date", "Hora creacion", "ID Cajero")
        //     end;
        // end;
    end;


    procedure CrearPagoNotaCr(recCabVta: Record "Sales Cr.Memo Header")
    var
        recMovCliente: Record "Cust. Ledger Entry";
        optPrmTipoDoc: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
    begin
        //+#65232: nueva función

        // with recCabVta do begin
        //     if GetMovClientePendiente(recMovCliente, recCabVta."Sell-to Customer No.", optPrmTipoDoc::Invoice, recCabVta."No.") then begin
        //         recMovCliente.CalcFields("Remaining Amt. (LCY)");

        //         CrearPago(recCabVta."Pre-Assigned No.", "No.", recMovCliente."Remaining Amt. (LCY)", true, Tienda, TPV, "Posting Date", "Hora creacion", "ID Cajero")
        //     end;
        // end;
    end;


    procedure GetMovClientePendiente(var recMovCliente: Record "Cust. Ledger Entry"; codPrmCliente: Code[20]; optPrmTipoDoc: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund; codPrmDoc: Code[20]): Boolean
    begin
        //+#65232: nueva función

        recMovCliente.Reset;
        recMovCliente.SetCurrentKey("Document No.", "Document Type", "Customer No.");
        recMovCliente.SetRange("Document Type", optPrmTipoDoc);
        recMovCliente.SetRange("Document No.", codPrmDoc);
        recMovCliente.SetRange("Customer No.", codPrmCliente);
        recMovCliente.SetRange(Open, true);
        exit(recMovCliente.FindFirst);
    end;


    procedure Final_Localizado()
    var

    begin
        //+76946

    end;


    procedure TestRegistroViable(lrCV: Record "Sales Header"): Boolean
    var
        lResult: Boolean;
        lcBolivia: Codeunit "Funciones DsPOS - Bolivia";
    begin
        //+#75918
        lResult := true;



        exit(lResult);
    end;


    procedure ActualizarSeries(SeriesCode: Code[10]; LastNoSerieUsed: Code[20])
    var
        SeriesLine: Record "No. Series Line";
        lrConf: Record "Configuracion General DsPOS";
    begin
        //+#116510
        //... Esta funcionalidad sólo se ejecuta para Honduras.
        if lrConf.FindFirst then
            if lrConf.Pais <> lrConf.Pais::Honduras then
                exit;


        //+#57166
        SeriesLine.Init;
        SeriesLine.SetRange(SeriesLine."Series Code", SeriesCode);

        if (SeriesLine.FindFirst) and (LastNoSerieUsed <> '') then begin

            SeriesLine."Last No. Used" := LastNoSerieUsed;
            SeriesLine."Last Date Used" := Today;

            SeriesLine.Modify(false);

        end;
    end;


    procedure Parametros(pNumLog: Integer)
    begin
        //+#126073
        wNumLog := pNumLog;
    end;


    procedure TestIntegridad(lrSH: Record "Sales Header"): Boolean
    var
        lrSL: Record "Sales Line";
        lrPagos: Record "Pagos TPV";
        lrTransCaja: Record "Transacciones Caja TPV";
        TextL001: Label 'No se han encontrado pagos TPV asociados';
        TextL002: Label 'No se han encontrado transacciones caja TPV';
        lrTransCajaAux: Record "Transacciones Caja TPV";
        TextL003: Label 'Presuntas transacciones diferentes con el mismo num. registro';
        TextL004: Label 'Diferencia entre el importe total del documento y el total de liquidación';
        lImporteLiquidacion: Decimal;
        lPais: Integer;
        lImportePagos: Decimal;
    begin
        //+#201856



        lrSL.Reset;
        lrSL.SetRange("Document Type", lrSH."Document Type");
        lrSL.SetRange("Document No.", lrSH."No.");
        if not lrSL.FindFirst then
            exit(false);

        //... Si se trata de El Salvador, salimos de la función. No realizamos comprobación.
        if lPais = 6 then
            exit(true);


        //+#438130
        TestImporteCero(lrSH);
        //-#438130

        if (lPais = 4) or (lPais = 7) or (lPais = 9) then begin  //Ecuador, Honduras y Costa Rica
            lrPagos.Reset;
            lrPagos.SetRange("No. Borrador", lrSH."No.");
            if not lrPagos.FindFirst then begin
                InsertarDetalle(lrSH, 0, true, TextL001);
                exit(false);
            end;

            //+#305288
            lrPagos.CalcSums(Importe);
            lImportePagos := lrPagos.Importe;
            //-#305288

        end;

        //IF lPais <> 7 THEN BEGIN  //... De momento, no lo aplicamos en Honduras.
        lrTransCaja.Reset;
        lrTransCaja.SetCurrentKey("No. Registrado");
        lrTransCaja.SetRange("No. Registrado", lrSH."Posting No.");
        if not lrTransCaja.FindFirst then begin
            InsertarDetalle(lrSH, 0, true, TextL002);
            exit(false);
        end;
        //#-246745

        //#+257334
        //... Si los datos comprarados difieren podemos pensar que se han mezclado transacciones.
        lrTransCajaAux := lrTransCaja;
        repeat
            if (lrTransCajaAux.Fecha <> lrTransCaja.Fecha) or
               (lrTransCajaAux.Hora <> lrTransCaja.Hora) or
               (lrTransCajaAux."Cod. tienda" <> lrTransCaja."Cod. tienda") or
               (lrTransCajaAux."Cod. TPV" <> lrTransCaja."Cod. TPV") then begin

                InsertarDetalle(lrSH, 0, true, TextL003);
                exit(false);
            end;

        until lrTransCaja.Next = 0;
        //#-246745
        //END;


        //#+291272
        if (lPais = 4) or (lPais = 7) or (lPais = 9) then begin  //Ecuador, Honduras y Costa Rica.
            lrSH.CalcFields("Amount Including VAT");
            lrTransCaja.Reset;
            lrTransCaja.SetCurrentKey("No. Registrado");
            lrTransCaja.SetRange("No. Registrado", lrSH."Posting No.");
            lrTransCaja.CalcSums(Importe);
            lImporteLiquidacion := lrTransCaja.Importe;

            //+#305288
            if lImporteLiquidacion = 0 then
                lImporteLiquidacion := lImportePagos;
            //-#305288

            if lrSH."Document Type" = lrSH."Document Type"::"Credit Memo" then
                lImporteLiquidacion := -1 * lImporteLiquidacion;

            if lrSH."Amount Including VAT" <> lImporteLiquidacion then begin
                InsertarDetalle(lrSH, 0, true, TextL004);
                exit(false);
            end;
        end;
        //#-291272

        exit(true);
    end;


    procedure Ajustes_NCR_Pais(var lrCV: Record "Sales Header")
    var
        lrCfgSales: Record "Sales & Receivables Setup";

        lTest: Boolean;
    begin
        //+#355717
        lTest := false;

        if lrCfgSales.FindFirst then
            if lrCfgSales."Exact Cost Reversing Mandatory" then
                lTest := true;

        if lTest then begin

        end;
    end;


    procedure Ajustes_AntesDe_Registrar(var lrCV: Record "Sales Header")
    var
        lPais: Integer;

    begin
        //+#380380


    end;


    procedure TestImporteCero(lrSH: Record "Sales Header")
    var
        lrPagos: Record "Pagos TPV";
        lrTransCaja: Record "Transacciones Caja TPV";
    begin
        //+#438130
        lrSH.CalcFields("Amount Including VAT");
        if lrSH."Amount Including VAT" = 0 then begin
            //... Sino se ha generado el cobro, al ser CERO el importe total, lo generamos en este punto, siempre y cuando no haya definido ningun registro de pagos, ni de
            //... transacciones.
            lrPagos.Reset;
            lrPagos.SetRange("No. Borrador", lrSH."No.");
            if not lrPagos.FindFirst then begin
                lrTransCaja.Reset;
                lrTransCaja.SetCurrentKey("No. Registrado");
                lrTransCaja.SetRange("No. Registrado", lrSH."Posting No.");
                if not lrTransCaja.FindFirst then
                    CrearPagoBorrador(lrSH);
            end;

        end;
    end;
}

