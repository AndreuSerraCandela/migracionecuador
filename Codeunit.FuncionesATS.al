codeunit 56010 "Funciones ATS"
{
    // #16511  FAA   10/04/2015    Se ha creado esta Codeunit para sacar todo el codigio de la Page
    //                             y agregar nuevas modificaciones..
    // 
    // #34860  CAT   11/11/2015  gestionar el No. de establecimientos
    // 
    // #37019  CAT   19/11/2015   Los documentos borrados de compra  quedan excluimos del ATS.
    // #34829  CAT   18/11/2015    Cambios en el formato de la información del ATS de compras
    // 
    // #34822  CAT   04/12/2015   Calculo Importe Retencion Ventas (Renta e IVA)
    // 
    // #42986  CAT   21/01/2016   Documentos anulados
    // 
    // #43088  CAT   26/01/2016   Compras a partir de $1000 debe traer la forma de pago.
    //                            En el detalle de ventas del periodo, se trae la información de "Parte relacionada".
    //                            Las facturas que se ingresan por caja chica, se trae la informe de "tipo de identificador" y "Pago a"
    //                            Los campos "Tiene convenio", "Sujeto Retencion" y "Reg. Fiscal Preferente" solo se traen si no son residentes


    trigger OnRun()
    begin

        PruebaXML();
    end;

    var
        FechaDesde: Date;
        FechaHasta: Date;
        PIH: Record "Purch. Inv. Header";
        HR: Record "Historico Retencion Prov.";
        VE: Record "VAT Entry";
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        DetATS: Record "ATS Compras/Ventas";
        Vendor: Record Vendor;
        NoSeriesLine: Record "No. Series Line";
        MovCont: Record "G/L Entry";
        I: Integer;
        DetalleATSPage: Page "Detalle Datos ATS";
        DetalleATSPageVtas: Page "Detalle Datos ATS Vtas.";
        TipoTrans: Option Compra,Venta;
        SIH: Record "Sales Invoice Header";
        Cust: Record Customer;
        SCMH: Record "Sales Cr.Memo Header";
        VLE: Record "Vendor Ledger Entry";
        VLE1: Record "Vendor Ledger Entry";
        PCMH: Record "Purch. Cr. Memo Hdr.";
        Corregida: Boolean;
        CLE: Record "Cust. Ledger Entry";
        CLE1: Record "Cust. Ledger Entry";
        Text001: Label 'Reading  #1########## @2@@@@@@@@@@@@@';
        Error001: Label 'Debe indicar Fecha Desde y Fecha Hasta';
        Text002: Label 'Reading  #1########## @2@@@@@@@@@@@@@';
        Err002: Label 'El Campo Tipo Contribuyente del Proveedor %1 , debe ser Persona Natural o Sociedad';
        Err003: Label 'El Campo Tipo Contribuyente del Proveedor %1, no puede estar en blanco.';
        rProveedor: Record Vendor;
        recLinFac: Record "Purch. Inv. Line";
        recLinNC: Record "Purch. Cr. Memo Line";
        Text003: Label 'Compras...\';
        Text004: Label 'Ventas...\';
        Text005: Label 'Comprobantes Anulados...\';
        Text006: Label 'Reading  #1########## @2@@@@@@@@@@@@@';
        Text007: Label 'Exportaciones...\';


    procedure ReporteATSCompra(FechaDesde: Date; FechaHasta: Date)
    var
        rPIH: Record "Purch. Inv. Header";
        rFactCompra: Record "Purch. Inv. Header";
        rPIL: Record "Purch. Inv. Line";
        bIVAIMP: Boolean;
        rGLEntry: Record "G/L Entry";
        rVATPS: Record "VAT Posting Setup";
    begin
        Counter := 0;
        PIH.Reset;
        PIH.SetCurrentKey("Posting Date");
        PIH.SetRange("Posting Date", FechaDesde, FechaHasta);
        PIH.SetRange(Correction, false);
        if PIH.FindSet then begin
            CounterTotal := PIH.Count;
            Window.Open(Text003 + Text001);
            repeat

                rProveedor.Get(PIH."Buy-from Vendor No.");
                //IF (NOT rProveedor."Excluir Informe ATS") THEN BEGIN
                //+#37019
                //IF (NOT rProveedor."Excluir Informe ATS") AND (PIH."Tipo de Comprobante" <> '00') AND (PIH."Tipo de Comprobante" <> '17')  THEN BEGIN //ATS
                if (not rProveedor."Excluir Informe ATS") and (PIH."Tipo de Comprobante" <> '00') and (PIH."Tipo de Comprobante" <> '17') and (not DocCompraBorrado(0, PIH."No.")) then begin
                    //-#37019
                    Corregida := false;
                    //Revisar si la factura fue liquidada con una nota de credito por correccion
                    VLE.Reset;
                    VLE.SetCurrentKey("Document Type", "Vendor No.", "Posting Date", "Currency Code");
                    VLE.SetRange("Document Type", VLE."Document Type"::Invoice);
                    VLE.SetRange("Vendor No.", PIH."Pay-to Vendor No.");
                    VLE.SetRange("Posting Date", PIH."Posting Date");
                    VLE.SetRange("Document No.", PIH."No.");
                    if VLE.FindFirst then begin
                        //Si la factura esta cerrada
                        if VLE."Closed by Entry No." <> 0 then begin
                            VLE1.Get(VLE."Closed by Entry No.");
                            if VLE1."Document Type" = VLE1."Document Type"::"Credit Memo" then begin
                                PCMH.Get(VLE1."Document No.");
                                if PCMH.Correction then
                                    Corregida := true
                            end;
                        end
                        else begin
                            VLE1.Reset;
                            VLE1.SetCurrentKey("Closed by Entry No.");
                            VLE1.SetRange("Closed by Entry No.", VLE."Entry No.");
                            VLE1.SetRange("Document Type", VLE1."Document Type"::"Credit Memo");
                            if VLE1.FindFirst then begin
                                PCMH.Get(VLE1."Document No.");
                                if PCMH.Correction then
                                    Corregida := true
                            end;
                        end;
                    end;
                    if (not Corregida) and (not VLE."Excluir Informe ATS") then begin
                        Counter := Counter + 1;
                        Window.Update(1, PIH."No.");
                        Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                        //14564++++
                        /*
                        IF (rProveedor."Tipo Documento" = rProveedor."Tipo Documento"::Pasaporte) AND
                           (rProveedor."Tipo Contribuyente" = '') THEN
                             ERROR(Err003, rProveedor."No.");

                        IF (rProveedor."Tipo Documento" = rProveedor."Tipo Documento"::Pasaporte) AND
                          NOT (rProveedor."Tipo Contribuyente" IN ['PN','SO'])  THEN
                            ERROR(Err002, rProveedor."No.");*/
                        //14564----

                        DetATS.Init;
                        DetATS."Mes - Periodo" := Date2DMY(FechaDesde, 2);
                        DetATS."Año - Periodo" := Date2DMY(FechaDesde, 3);
                        DetATS."Cod. Retencion 1" := '';
                        DetATS."Tipo Retencion" := '';
                        DetATS."Tipo Documento" := DetATS."Tipo Documento"::Invoice;
                        DetATS."No. Documento" := PIH."No.";
                        DetATS.Tipo := DetATS.Tipo::Compra;
                        DetATS.Descripcion := PIH."Posting Description";
                        DetATS."Fecha Registro" := PIH."Posting Date";
                        DetATS."Fecha Emicion Doc" := PIH."Document Date";         //#16511
                        DetATS."Numero Comprobante Fiscal" := PIH."No. Comprobante Fiscal";
                        PIH.CalcFields(Amount);
                        PIH.CalcFields("Amount Including VAT");
                        DetATS.Importe := PIH.Amount;
                        DetATS."Importe IVA" := PIH."Amount Including VAT" - PIH.Amount;
                        DetATS."Importe IVA Incl." := PIH."Amount Including VAT";
                        DetATS."Source Type" := DetATS."Source Type"::Vendor;
                        DetATS."Source No." := PIH."Pay-to Vendor No.";
                        //DetATS."Parte Relacionada"            := rProveedor."Parte Relacionada";//#14564

                        DetATS."Nombre Proveedor" := PIH."Buy-from Vendor Name";
                        //#14564+++
                        ProveedorLocaloExtranjero(rProveedor."Country/Region Code");
                        //#34829 DetATS."Sujeto a Retencion"   := PIH."Aplica Retención";

                        //DetATS."Fecha Emision Retencion"      := PIH."Posting Date";
                        DetATS."Forma de Pago" := FormaDePagoCompra(PIH."Buy-from Vendor No.", PIH."Amount Including VAT", PIH."Payment Method Code");

                        if rProveedor."Tipo Documento" = rProveedor."Tipo Documento"::Pasaporte then begin
                            //CASE rProveedor."Tipo Contribuyente" OF
                            //  'PN': DetATS."Tipo Contribuyente" := '01';
                            //  'SO': DetATS."Tipo Contribuyente" := '02';
                            //END;
                            case rProveedor."Tipo Contrib. Extranjero" of
                                rProveedor."Tipo Contrib. Extranjero"::"Persona Natural":
                                    DetATS."Tipo Contribuyente" := '01';
                                rProveedor."Tipo Contrib. Extranjero"::Sociedad:
                                    DetATS."Tipo Contribuyente" := '02';
                            end;


                        end;
                        DetATS."Parte Relacionada" := rProveedor."Parte Relacionada";

                        //#14564---

                        //#16511+++
                        case rProveedor."Tipo Documento" of
                            rProveedor."Tipo Documento"::RUC:
                                DetATS.Validate("Tipo de Identificador", 'R');
                            rProveedor."Tipo Documento"::Cedula:
                                DetATS.Validate("Tipo de Identificador", 'C');
                            rProveedor."Tipo Documento"::Pasaporte:
                                DetATS.Validate("Tipo de Identificador", 'P');
                        end;
                        //#16511---

                        DetATS."RUC/Cedula" := PIH."VAT Registration No.";
                        DetATS.Validate("Sustento del Comprobante", PIH."Sustento del Comprobante");
                        DetATS."Sustento del Comprobante" := CodSustentoSin0(DetATS."Sustento del Comprobante");
                        HR.Reset;
                        HR.SetRange("No. documento", PIH."No.");
                        HR.SetRange(Anulada, false);
                        //RellenarImporteRetenciones(PIH."No.", 0, PIH."Tipo de Comprobante"); //#16511


                        DetATS."No. Autorizacion Documento" := PIH."No. Autorizacion Comprobante";
                        if DetATS."No. Autorizacion Documento" = '' then
                            DetATS."No. Autorizacion Documento" := TraerAutorizacionLiquidacion(PIH."No.");

                        DetATS."Punto Emision Documento" := PIH."Punto de Emision";
                        DetATS."Establecimiento Documento" := PIH.Establecimiento;
                        DetATS."No. Pedido" := PIH."Order No.";


                        VE.Reset;
                        VE.SetRange("Document Type", VE."Document Type"::Invoice);
                        VE.SetRange("Document No.", PIH."No.");
                        VE.SetRange("Posting Date", PIH."Posting Date");
                        VE.SetRange(Type, VE.Type::Purchase);
                        VE.SetRange(VE."VAT Prod. Posting Group", '_EXENTO');
                        if VE.FindSet then
                            repeat
                                DetATS._EXENTO += VE.Amount;
                            until VE.Next = 0;

                        VE.Reset;
                        VE.SetRange("Document Type", VE."Document Type"::Invoice);
                        VE.SetRange("Document No.", PIH."No.");
                        VE.SetRange("Posting Date", PIH."Posting Date");
                        VE.SetRange(Type, VE.Type::Purchase);
                        VE.SetRange(VE."VAT Prod. Posting Group", '_GR_12');
                        if VE.FindSet then
                            repeat
                                DetATS._GR_12 += VE.Amount;
                            until VE.Next = 0;

                        VE.Reset;
                        VE.SetRange("Document Type", VE."Document Type"::Invoice);
                        VE.SetRange("Document No.", PIH."No.");
                        VE.SetRange("Posting Date", PIH."Posting Date");
                        VE.SetRange(Type, VE.Type::Purchase);
                        VE.SetRange(VE."VAT Prod. Posting Group", '_GR_0');
                        if VE.FindSet then
                            repeat
                                DetATS._GR_0 += VE.Amount;
                            until VE.Next = 0;

                        VE.Reset;
                        VE.SetRange("Document Type", VE."Document Type"::Invoice);
                        VE.SetRange("Document No.", PIH."No.");
                        VE.SetRange("Posting Date", PIH."Posting Date");
                        VE.SetRange(Type, VE.Type::Purchase);
                        VE.SetRange(VE."VAT Prod. Posting Group", '10_SERVIC');
                        if VE.FindSet then
                            repeat
                                DetATS."10_SERVIC" += VE.Amount;
                            until VE.Next = 0;


                        //IVA DE IMPORTACIONES
                        rPIL.SetRange("Document No.", PIH."No.");
                        rPIL.SetRange(Type, rPIL.Type::"Charge (Item)");
                        rPIL.SetRange("No.", 'IVAIMPORT');
                        if rPIL.FindSet then begin
                            repeat
                                DetATS._GR_12 += rPIL."Amount Including VAT";
                                DetATS.Importe -= rPIL."Amount Including VAT";
                            until rPIL.Next = 0;
                            DetATS."Importe IVA" := PIH."Amount Including VAT" - DetATS.Importe;
                        end;


                        RellenarImporteRetenciones(PIH."No.", 0, PIH."Tipo de Comprobante"); //#16511

                        DetATS."Fecha Caducidad" := PIH."Fecha Caducidad";
                        DetATS."Tipo Comprobante" := CodigoTC(PIH."Tipo de Comprobante");

                        //#14564++++
                        if PIH."Tipo de Comprobante" in ['08', '09', '11', '19', '20'] then
                            RellenaCampoPorTipoComprobante;
                        //#14564---

                        bIVAIMP := false;
                        recLinFac.Reset;
                        recLinFac.SetRange("Document No.", PIH."No.");
                        if recLinFac.FindSet then
                            repeat
                                if recLinFac."No." <> 'IVAIMPORT' then begin
                                    case recLinFac."VAT %" of
                                        0:
                                            DetATS."Base 0%" += recLinFac.Amount;
                                        12:
                                            DetATS."Base 12%" += recLinFac.Amount;
                                    end;
                                end
                                else
                                    bIVAIMP := true;
                            until recLinFac.Next = 0;
                        //#14564----

                        if bIVAIMP then begin
                            DetATS."Base 12%" := DetATS."Base 0%";
                            DetATS."Base 0%" := 0;
                        end;

                        DetATS.Insert;
                    end;
                end;

            until PIH.Next = 0;
            Window.Close;
        end;
        //Nota de Credito Compra
        CounterTotal := 0;
        PCMH.Reset;
        PCMH.SetCurrentKey("Posting Date");
        PCMH.SetRange("Posting Date", FechaDesde, FechaHasta);
        PCMH.SetRange(Correction, false);
        if PCMH.FindSet then begin
            CounterTotal := PCMH.Count;
            Window.Open(Text003 + Text002);
            repeat
                Corregida := false;
                //Revisar si la factura fue liquidada con una Factura por correccion
                VLE.Reset;
                VLE.SetCurrentKey("Document Type", "Vendor No.", "Posting Date", "Currency Code");
                VLE.SetRange("Document Type", VLE."Document Type"::"Credit Memo");
                VLE.SetRange("Vendor No.", PCMH."Pay-to Vendor No.");
                VLE.SetRange("Posting Date", PCMH."Posting Date");
                VLE.SetRange("Document No.", PCMH."No.");
                if VLE.FindFirst then begin
                    //Si la NCR esta cerrada
                    if VLE."Closed by Entry No." <> 0 then begin
                        VLE1.Get(VLE."Closed by Entry No.");
                        if VLE1."Document Type" = VLE1."Document Type"::Invoice then begin
                            PIH.Get(VLE1."Document No.");
                            if PIH.Correction then
                                Corregida := true
                        end;
                    end
                    else begin
                        VLE1.Reset;
                        VLE1.SetCurrentKey("Closed by Entry No.");
                        VLE1.SetRange("Closed by Entry No.", VLE."Entry No.");
                        VLE1.SetRange("Document Type", VLE1."Document Type"::Invoice);
                        if VLE1.FindFirst then begin
                            PIH.Get(VLE1."Document No.");
                            if PIH.Correction then
                                Corregida := true
                        end;
                    end;
                end;

                if not Corregida then begin
                    rFactCompra.Reset;
                    rFactCompra.SetRange(rFactCompra."Applies-to Doc. Type", rFactCompra."Applies-to Doc. Type"::"Credit Memo");
                    rFactCompra.SetRange(rFactCompra."Applies-to Doc. No.", SCMH."No.");
                    if rFactCompra.FindSet then
                        if rFactCompra.Correction then
                            Corregida := true;
                end;

                //+#37019
                //IF (NOT Corregida) AND (NOT VLE."Excluir Informe ATS") THEN
                if (not Corregida) and (not VLE."Excluir Informe ATS") and (not DocCompraBorrado(1, SCMH."No.")) then //-#37019
                  begin
                    Counter := Counter + 1;
                    Window.Update(1, PCMH."No.");
                    Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                    //#14564++
                    rProveedor.Get(PCMH."Pay-to Vendor No.");

                    /*IF (rProveedor."Tipo Documento" = rProveedor."Tipo Documento"::Pasaporte) AND
                       (rProveedor."Tipo Contribuyente" = '') THEN
                        ERROR(Err003, rProveedor."No.");

                    IF (rProveedor."Tipo Documento" = rProveedor."Tipo Documento"::Pasaporte) AND
                       NOT (rProveedor."Tipo Contribuyente" IN ['PN','SO'])  THEN
                        ERROR(Err002, rProveedor."No.");  */
                    //14564--

                    DetATS.Init;
                    DetATS."Mes - Periodo" := Date2DMY(FechaDesde, 2);
                    DetATS."Año - Periodo" := Date2DMY(FechaDesde, 3);
                    DetATS."Cod. Retencion 1" := '';
                    DetATS."Tipo Retencion" := '';
                    DetATS."Tipo Documento" := DetATS."Tipo Documento"::"Credit Memo";
                    DetATS."No. Documento" := PCMH."No.";
                    DetATS.Tipo := DetATS.Tipo::Compra;
                    DetATS.Descripcion := PCMH."Posting Description";
                    DetATS."Fecha Registro" := PCMH."Posting Date";
                    DetATS."Fecha Emicion Doc" := PCMH."Document Date";         //#ATS
                    DetATS."Numero Comprobante Fiscal" := PCMH."No. Comprobante Fiscal";
                    PCMH.CalcFields(Amount);
                    PCMH.CalcFields("Amount Including VAT");
                    DetATS.Importe := PCMH.Amount;
                    DetATS."Importe IVA" := PCMH."Amount Including VAT" - PCMH.Amount;
                    DetATS."Importe IVA Incl." := PCMH."Amount Including VAT";
                    DetATS."Source Type" := DetATS."Source Type"::Vendor;
                    DetATS."Source No." := PCMH."Pay-to Vendor No.";
                    //DetATS."Parte Relacionada"            := rProveedor."Parte Relacionada";//#14564
                    DetATS."Nombre Proveedor" := PCMH."Buy-from Vendor Name";
                    //#14564+++
                    ProveedorLocaloExtranjero(rProveedor."Country/Region Code");
                    //#34829 DetATS."Sujeto a Retencion"   := PCMH."Aplica Retención";

                    //DetATS."Fecha Emision Retencion"      := PCMH."Posting Date";
                    //DetATS."Forma de Pago" := FormaDePagoCompra(PCMH."Buy-from Vendor No.",PCMH."Amount Including VAT");

                    if rProveedor."Tipo Documento" = rProveedor."Tipo Documento"::Pasaporte then begin
                        //CASE rProveedor."Tipo Contribuyente" OF
                        //  'PN': DetATS."Tipo Contribuyente" := '01';
                        //  'SO': DetATS."Tipo Contribuyente" := '02';
                        //END;
                        case rProveedor."Tipo Contrib. Extranjero" of
                            rProveedor."Tipo Contrib. Extranjero"::"Persona Natural":
                                DetATS."Tipo Contribuyente" := '01';
                            rProveedor."Tipo Contrib. Extranjero"::Sociedad:
                                DetATS."Tipo Contribuyente" := '02';
                        end;


                    end;
                    DetATS."Parte Relacionada" := rProveedor."Parte Relacionada";
                    //#14564---

                    //#16511+++
                    case rProveedor."Tipo Documento" of
                        rProveedor."Tipo Documento"::RUC:
                            DetATS.Validate("Tipo de Identificador", 'R');
                        rProveedor."Tipo Documento"::Cedula:
                            DetATS.Validate("Tipo de Identificador", 'C');
                        rProveedor."Tipo Documento"::Pasaporte:
                            DetATS.Validate("Tipo de Identificador", 'P');
                    end;

                    //DetATS."No. Comprobante Fiscal Rel." := PCMH."No. Comprobante Fiscal Rel."; //#16511
                    //#16511---

                    //+#ATS
                    if PCMH."No. Comprobante Fiscal Rel." <> '' then begin
                        DetATS."No. Comprobante Fiscal Rel." := PCMH."No. Comprobante Fiscal Rel."; //#16511
                        rPIH.Reset;
                        rPIH.SetRange("No. Comprobante Fiscal", PCMH."No. Comprobante Fiscal Rel.");
                        rPIH.SetRange("Buy-from Vendor No.", PCMH."Buy-from Vendor No.");
                        if rPIH.FindFirst then begin
                            DetATS."No.Autorizacion Factura Rel." := rPIH."No. Autorizacion Comprobante";
                            DetATS."Punto Emision Factura Rel." := rPIH."Punto de Emision";
                            DetATS."Establecimiento Factura Rel." := rPIH.Establecimiento;
                            DetATS."Tipo Comprobante Factura Rel." := CodigoTC(rPIH."Tipo de Comprobante");
                        end;
                    end
                    else begin
                        if (PCMH."Applies-to Doc. Type" = PCMH."Applies-to Doc. Type"::Invoice) and (PCMH."Applies-to Doc. No." <> '') then
                            rPIH.Reset;
                        rPIH.SetRange("No.", PCMH."Applies-to Doc. No.");
                        rPIH.SetRange("Buy-from Vendor No.", PCMH."Buy-from Vendor No.");
                        if rPIH.FindFirst then begin
                            DetATS."No. Comprobante Fiscal Rel." := rPIH."No. Comprobante Fiscal";
                            DetATS."No.Autorizacion Factura Rel." := rPIH."No. Autorizacion Comprobante";
                            DetATS."Punto Emision Factura Rel." := rPIH."Punto de Emision";
                            DetATS."Establecimiento Factura Rel." := rPIH.Establecimiento;
                            DetATS."Tipo Comprobante Factura Rel." := CodigoTC(rPIH."Tipo de Comprobante");
                        end;
                    end;
                    //-#ATS

                    DetATS."RUC/Cedula" := PCMH."VAT Registration No.";
                    DetATS.Validate("Sustento del Comprobante", PCMH."Sustento del Comprobante");
                    DetATS."Sustento del Comprobante" := CodSustentoSin0(DetATS."Sustento del Comprobante");

                    HR.Reset;
                    HR.SetRange("No. documento", PCMH."No.");
                    HR.SetRange(Anulada, false);
                    //#ATS
                    //RellenarImporteRetenciones(PCMH."No.", 1);//#16511

                    DetATS."No. Autorizacion Documento" := PCMH."No. Autorizacion Comprobante";
                    if DetATS."No. Autorizacion Documento" = '' then
                        DetATS."No. Autorizacion Documento" := TraerAutorizacionLiquidacion(PCMH."No.");

                    DetATS."Punto Emision Documento" := PCMH."Punto de Emision";
                    DetATS."Establecimiento Documento" := PCMH.Establecimiento;
                    DetATS."No. Pedido" := PCMH."Pre-Assigned No.";
                    VE.Reset;
                    VE.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                    VE.SetRange("Document No.", PCMH."No.");
                    VE.SetRange("Posting Date", PCMH."Posting Date");
                    VE.SetRange(Type, VE.Type::Purchase);
                    VE.SetRange(VE."VAT Prod. Posting Group", '_EXENTO');
                    if VE.FindSet then
                        repeat
                            DetATS._EXENTO += VE.Amount;
                        until VE.Next = 0;

                    VE.Reset;
                    VE.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                    VE.SetRange("Document No.", PCMH."No.");
                    VE.SetRange("Posting Date", PCMH."Posting Date");
                    VE.SetRange(Type, VE.Type::Purchase);
                    VE.SetRange(VE."VAT Prod. Posting Group", '_GR_12');
                    if VE.FindSet then
                        repeat
                            DetATS._GR_12 += VE.Amount;
                        until VE.Next = 0;

                    VE.Reset;
                    VE.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                    VE.SetRange("Document No.", PCMH."No.");
                    VE.SetRange("Posting Date", PCMH."Posting Date");
                    VE.SetRange(Type, VE.Type::Purchase);
                    VE.SetRange(VE."VAT Prod. Posting Group", '_GR_0');
                    if VE.FindSet then
                        repeat
                            DetATS._GR_0 += VE.Amount;
                        until VE.Next = 0;

                    VE.Reset;
                    VE.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                    VE.SetRange("Document No.", PCMH."No.");
                    VE.SetRange("Posting Date", PCMH."Posting Date");
                    VE.SetRange(Type, VE.Type::Purchase);
                    VE.SetRange(VE."VAT Prod. Posting Group", '10_SERVIC');
                    if VE.FindSet then
                        repeat
                            DetATS."10_SERVIC" += VE.Amount;
                        until VE.Next = 0;

                    DetATS."Fecha Caducidad" := PCMH."Fecha Caducidad";
                    DetATS."Tipo Comprobante" := CodigoTC(PCMH."Tipo de Comprobante");

                    //#14564++++
                    if PCMH."Tipo de Comprobante" in ['08', '09', '11', '19', '20'] then
                        RellenaCampoPorTipoComprobante;

                    recLinNC.Reset;
                    recLinNC.SetRange("Document No.", PCMH."No.");
                    if recLinNC.FindSet then
                        repeat
                            case recLinNC."VAT %" of
                                0:
                                    DetATS."Base 0%" += recLinNC.Amount;
                                12:
                                    DetATS."Base 12%" += recLinNC.Amount;
                            end;
                        until recLinNC.Next = 0;
                    //#14564----

                    DetATS.Insert;
                end;
            until PCMH.Next = 0;
            Window.Close;
        end;

        //***********COMPRAS DESDE CAJAS CHICAS
        rGLEntry.SetCurrentKey("Caja Chica", "Posting Date");
        rGLEntry.SetRange("Posting Date", FechaDesde, FechaHasta);
        rGLEntry.SetRange("Caja Chica", true);
        rGLEntry.SetRange("Gen. Posting Type", rGLEntry."Gen. Posting Type"::Purchase);
        if rGLEntry.FindSet then
            repeat
                if not rGLEntry."Excluir Informe ATS" then begin
                    //**
                    DetATS.Init;
                    DetATS."Mes - Periodo" := Date2DMY(FechaDesde, 2);
                    DetATS."Año - Periodo" := Date2DMY(FechaDesde, 3);
                    DetATS."Cod. Retencion 1" := '';
                    DetATS."Tipo Retencion" := '';
                    DetATS."Caja Chica" := true;
                    DetATS."Tipo Documento" := DetATS."Tipo Documento"::Invoice;
                    DetATS."No. Documento" := rGLEntry."Document No." + ' - ' + Format(rGLEntry."Entry No.");
                    DetATS.Tipo := DetATS.Tipo::Compra;
                    DetATS.Descripcion := rGLEntry.Description;
                    DetATS."Fecha Registro" := rGLEntry."Posting Date";
                    DetATS."Fecha Emicion Doc" := rGLEntry."Document Date";
                    DetATS."Numero Comprobante Fiscal" := rGLEntry."No. Comprobante Fiscal";
                    DetATS.Importe := rGLEntry.Amount;
                    DetATS."Importe IVA" := rGLEntry."VAT Amount";
                    DetATS."Importe IVA Incl." := rGLEntry.Amount + rGLEntry."VAT Amount";

                    //+#43088
                    case rGLEntry."Tipo de Identificador" of
                        rGLEntry."Tipo de Identificador"::RUC:
                            DetATS.Validate("Tipo de Identificador", 'R');
                        rGLEntry."Tipo de Identificador"::Cedula:
                            DetATS.Validate("Tipo de Identificador", 'C');
                        rGLEntry."Tipo de Identificador"::Pasaporte:
                            DetATS.Validate("Tipo de Identificador", 'P');
                    end;

                    case rGLEntry."Pago a" of
                        rGLEntry."Pago a"::Residente:
                            DetATS."Pago a residente" := '01';
                        rGLEntry."Pago a"::"No Residente":
                            DetATS."Pago a residente" := '02';
                    end;
                    //-#43088

                    //#14564+++
                    //ProveedorLocaloExtranjero(rProveedor."Country/Region Code");
                    //DetATS."Sujeto a Retencion"   := PIH."Aplica Retención";

                    //DetATS."Fecha Emision Retencion"      := PIH."Posting Date";
                    //DetATS."Forma de Pago" := FormaDePagoCompra(PIH."Buy-from Vendor No.",PIH."Amount Including VAT",PIH."Payment Method Code");

                    //IF rProveedor."Tipo Documento" = rProveedor."Tipo Documento"::Pasaporte THEN BEGIN
                    //  CASE rProveedor."Tipo Contrib. Extranjero" OF
                    //    rProveedor."Tipo Contrib. Extranjero"::"Persona Natural" : DetATS."Tipo Contribuyente" := '01';
                    //    rProveedor."Tipo Contrib. Extranjero"::Sociedad        : DetATS."Tipo Contribuyente" := '02';
                    //  END;
                    //END;
                    //DetATS."Parte Relacionada"            := rProveedor."Parte Relacionada";

                    //#14564---

                    //#16511+++
                    //CASE rProveedor."Tipo Documento" OF
                    //  rProveedor."Tipo Documento"::RUC          :DetATS.VALIDATE("Tipo de Identificador",'R');
                    //  rProveedor."Tipo Documento"::Cedula       :DetATS.VALIDATE("Tipo de Identificador",'C');
                    //  rProveedor."Tipo Documento"::Pasaporte    :DetATS.VALIDATE("Tipo de Identificador",'P');
                    //END;
                    //#16511---

                    DetATS."RUC/Cedula" := rGLEntry."RUC/Cedula";
                    DetATS.Validate("Sustento del Comprobante", rGLEntry."Sustento del Comprobante");
                    DetATS."Sustento del Comprobante" := CodSustentoSin0(DetATS."Sustento del Comprobante");
                    DetATS."No. Autorizacion Documento" := rGLEntry."No. Autorizacion Comprobante";
                    DetATS."Punto Emision Documento" := rGLEntry."Punto de Emision";
                    DetATS."Establecimiento Documento" := rGLEntry.Establecimiento;
                    //DetATS."No. Pedido"                      := PIH."Order No.";

                    case rGLEntry."VAT Prod. Posting Group" of
                        '_EXENTO':
                            begin
                                DetATS._EXENTO := rGLEntry."VAT Amount";
                                DetATS."Base 0%" := rGLEntry.Amount;
                            end;
                        '_GR_12':
                            begin
                                DetATS._GR_12 := rGLEntry."VAT Amount";
                                DetATS."Base 12%" := rGLEntry.Amount;
                            end;
                        '_GR_0':
                            begin
                                DetATS._GR_0 := rGLEntry."VAT Amount";
                                DetATS."Base 0%" := rGLEntry.Amount;
                            end;
                        '10_SERVIC':
                            begin
                                DetATS."10_SERVIC" := rGLEntry."VAT Amount";
                            end;
                        else begin
                            rVATPS.Get(rGLEntry."VAT Bus. Posting Group", rGLEntry."VAT Prod. Posting Group");
                            case rVATPS."VAT %" of
                                12:
                                    begin
                                        DetATS._GR_12 := rGLEntry."VAT Amount";
                                        DetATS."Base 12%" := rGLEntry.Amount;
                                    end;
                                0:
                                    begin
                                        DetATS._GR_0 := rGLEntry."VAT Amount";
                                        DetATS."Base 0%" := rGLEntry.Amount;
                                    end;
                            end;
                        end;
                    end;

                    //***retenciones
                    if rGLEntry."Cod. Retencion" <> '' then begin
                        DetATS."Cod. Retencion 1" := rGLEntry."Cod. Retencion";
                        DetATS."Base Retencion 1" := DetATS.Importe;
                    end;

                    DetATS."Fecha Caducidad" := rGLEntry."Fecha Caducidad";
                    DetATS."Tipo Comprobante" := CodigoTC(rGLEntry."Tipo de Comprobante");

                    //#14564++++
                    if rGLEntry."Tipo de Comprobante" in ['08', '09', '11', '19', '20'] then
                        RellenaCampoPorTipoComprobante;
                    //#14564---

                    DetATS.Insert;
                    //**

                end;

            until rGLEntry.Next = 0;

        //COMMIT;
        //CLEAR(DetalleATSPage);
        //DetalleATSPage.RUNMODAL;

    end;


    procedure ReporteATSVentaDetallado(FechaDesde: Date; FechaHasta: Date)
    var
        rFactVenta: Record "Sales Invoice Header";
        Cust: Record Customer;
    begin


        SIH.Reset;
        SIH.SetCurrentKey("Posting Date");
        SIH.SetRange("Posting Date", FechaDesde, FechaHasta);
        SIH.SetRange(Correction, false);
        if SIH.FindSet then begin
            CounterTotal := SIH.Count;
            Window.Open(Text004 + Text001);
            repeat
                Counter := Counter + 1;
                Window.Update(1, SIH."No.");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                Corregida := false;
                //Revisar si la factura fue liquidada con una nota de credito por correccion
                CLE.Reset;
                CLE.SetCurrentKey("Document Type", "Customer No.", "Posting Date", "Currency Code");
                CLE.SetRange("Document Type", CLE."Document Type"::Invoice);
                CLE.SetRange("Customer No.", SIH."Bill-to Customer No.");
                CLE.SetRange("Posting Date", SIH."Posting Date");
                CLE.SetRange("Document No.", SIH."No.");
                if CLE.FindFirst then begin
                    //Si la factura esta cerrada
                    if CLE."Closed by Entry No." <> 0 then begin
                        CLE1.Get(CLE."Closed by Entry No.");
                        if CLE1."Document Type" = CLE1."Document Type"::"Credit Memo" then begin
                            SCMH.Get(CLE1."Document No.");
                            if SCMH.Correction then
                                Corregida := true;
                        end;
                    end
                    else begin
                        CLE1.Reset;
                        CLE1.SetCurrentKey("Closed by Entry No.");
                        CLE1.SetRange("Closed by Entry No.", CLE."Entry No.");
                        CLE1.SetRange("Document Type", CLE1."Document Type"::"Credit Memo");
                        if CLE1.FindFirst then begin
                            SCMH.Get(CLE1."Document No.");
                            if SCMH.Correction then
                                Corregida := true
                        end;
                    end;
                end;
                if not Corregida then begin
                    DetATS.Init;
                    DetATS."Mes - Periodo" := Date2DMY(FechaDesde, 2);
                    DetATS."Año - Periodo" := Date2DMY(FechaDesde, 3);
                    DetATS."Cod. Retencion 1" := '';
                    DetATS."Tipo Retencion" := '';
                    DetATS."Tipo Documento" := DetATS."Tipo Documento"::Invoice;
                    DetATS."No. Documento" := SIH."No.";
                    DetATS.Tipo := DetATS.Tipo::Venta;
                    DetATS.Descripcion := SIH."Posting Description";
                    DetATS."Fecha Registro" := SIH."Posting Date";
                    DetATS."Fecha Emicion Doc" := SIH."Document Date";         //#ATS
                    DetATS."Numero Comprobante Fiscal" := SIH."No. Comprobante Fiscal";
                    SIH.CalcFields(Amount);
                    SIH.CalcFields("Amount Including VAT");
                    DetATS.Importe := SIH.Amount;
                    DetATS."Importe IVA" := SIH."Amount Including VAT" - SIH.Amount;
                    DetATS."Importe IVA Incl." := SIH."Amount Including VAT";
                    DetATS."Source Type" := DetATS."Source Type"::Customer;
                    DetATS."Source No." := SIH."Bill-to Customer No.";
                    DetATS."RUC/Cedula" := SIH."VAT Registration No.";
                    DetATS."No. Autorizacion Documento" := SIH."No. Autorizacion Comprobante";
                    DetATS."Punto Emision Documento" := SIH."Punto de Emision Factura";
                    DetATS."Establecimiento Documento" := SIH."Establecimiento Factura";

                    //+#43088
                    Cust.Get(SIH."Bill-to Customer No.");
                    DetATS."Parte Relacionada" := Cust."Parte Relacionada";
                    //-#43088

                    DeExportacionOno(SIH."Gen. Bus. Posting Group"); //14564
                                                                     //ATS VENTAS
                                                                     //DetATS."Con Refrendo"             := DetATS."Con Refrendo";
                                                                     //DetATS."Nº Refrendo"              := DetATS."Nº Refrendo";
                                                                     //DetATS."Nº Documento Transporte"  := DetATS."Nº Documento Transporte";
                                                                     //DetATS."Fecha embarque"           := DetATS."Fecha embarque";

                    /*       if SIH."Venta TPV" = SIH."Venta TPV"::"1" then
                              DetATS."Tipo Comprobante" := '1'
                          else
                              DetATS."Tipo Comprobante" := CodigoTC(SIH."Tipo de Comprobante"); */

                    if SIH."Fecha Caducidad Comprobante" = 0D then begin
                        NoSeriesLine.Reset;
                        NoSeriesLine.SetRange("Series Code", SIH."No. Serie NCF Facturas");
                        NoSeriesLine.SetFilter("Starting No.", '<=%1', SIH."No. Comprobante Fiscal");
                        NoSeriesLine.SetFilter("Ending No.", '>=%1', SIH."No. Comprobante Fiscal");
                        NoSeriesLine.SetRange(Establecimiento, SIH."Establecimiento Factura");
                        NoSeriesLine.SetRange("Punto de Emision", SIH."Punto de Emision Factura");
                        if NoSeriesLine.FindFirst then
                            DetATS."Fecha Caducidad" := NoSeriesLine."Fecha Caducidad";
                    end
                    else
                        DetATS."Fecha Caducidad" := SIH."Fecha Caducidad Comprobante";

                    //#14564++++   hice un cambio
                    if SIH."Tipo de Comprobante" in ['08', '09', '11', '19', '20'] then
                        RellenaCampoPorTipoComprobante;
                    //#14564---

                    DetATS."No. Pedido" := SIH."Order No.";
                    VE.Reset;
                    VE.SetRange("Document Type", VE."Document Type"::Invoice);
                    VE.SetRange("Document No.", SIH."No.");
                    VE.SetRange("Posting Date", SIH."Posting Date");
                    VE.SetRange(Type, VE.Type::Sale);
                    VE.SetRange("VAT Prod. Posting Group", '_EXENTO');
                    if VE.FindSet then
                        repeat
                            DetATS._EXENTO += VE.Amount;
                        until VE.Next = 0;

                    VE.Reset;
                    VE.SetRange("Document Type", VE."Document Type"::Invoice);
                    VE.SetRange("Document No.", SIH."No.");
                    VE.SetRange("Posting Date", SIH."Posting Date");
                    VE.SetRange(Type, VE.Type::Sale);
                    VE.SetRange("VAT Prod. Posting Group", '12% IVA');
                    if VE.FindSet then
                        repeat
                            DetATS."12% IVA" += VE.Amount;
                        until VE.Next = 0;

                    VE.Reset;
                    VE.SetRange("Document Type", VE."Document Type"::Invoice);
                    VE.SetRange("Document No.", SIH."No.");
                    VE.SetRange("Posting Date", SIH."Posting Date");
                    VE.SetRange(Type, VE.Type::Sale);
                    VE.SetRange("VAT Prod. Posting Group", '_GR_0');
                    if VE.FindSet then
                        repeat
                            DetATS._GR_0 += VE.Amount;
                        until VE.Next = 0;

                    VE.Reset;
                    VE.SetRange("Document Type", VE."Document Type"::Invoice);
                    VE.SetRange("Document No.", SIH."No.");
                    VE.SetRange("Posting Date", SIH."Posting Date");
                    VE.SetRange(Type, VE.Type::Sale);
                    VE.SetRange("VAT Prod. Posting Group", '_GR_12');
                    if VE.FindSet then
                        repeat
                            DetATS._GR_12 += VE.Amount;
                        until VE.Next = 0;

                    VE.Reset;
                    VE.SetRange("Document Type", VE."Document Type"::Invoice);
                    VE.SetRange("Document No.", SIH."No.");
                    VE.SetRange("Posting Date", SIH."Posting Date");
                    VE.SetRange(Type, VE.Type::Sale);
                    VE.SetRange("VAT Prod. Posting Group", '10_SERVIC');
                    if VE.FindSet then
                        repeat
                            DetATS."10_SERVIC" += VE.Amount;
                        until VE.Next = 0;
                    DetATS.Insert;
                end;
            until SIH.Next = 0;
            Window.Close;
        end;

        SCMH.Reset;
        SCMH.SetCurrentKey("Posting Date");
        SCMH.SetRange("Posting Date", FechaDesde, FechaHasta);
        SCMH.SetRange(Correction, false);
        if SCMH.FindSet then begin
            CounterTotal := SCMH.Count;
            Window.Open(Text004 + Text002);
            repeat
                Counter := Counter + 1;
                Window.Update(1, SCMH."No.");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                Corregida := false;
                rFactVenta.Reset;
                rFactVenta.SetRange("No. Nota Credito a Anular", SCMH."No.");
                if rFactVenta.FindSet then
                    if rFactVenta.Correction then
                        Corregida := true;

                if not Corregida then begin

                    DetATS.Init;
                    DetATS."Mes - Periodo" := Date2DMY(FechaDesde, 2);
                    DetATS."Año - Periodo" := Date2DMY(FechaDesde, 3);
                    DetATS."Cod. Retencion 1" := '';
                    DetATS."Tipo Retencion" := '';
                    DetATS."Tipo Documento" := DetATS."Tipo Documento"::"Credit Memo";
                    DetATS."No. Documento" := SCMH."No.";
                    DetATS.Tipo := DetATS.Tipo::Venta;
                    DetATS.Descripcion := SCMH."Posting Description";
                    DetATS."Fecha Registro" := SCMH."Posting Date";
                    DetATS."Fecha Emicion Doc" := SCMH."Document Date";         //#ATS
                    DetATS."Numero Comprobante Fiscal" := SCMH."No. Comprobante Fiscal";
                    SCMH.CalcFields(Amount);
                    SCMH.CalcFields("Amount Including VAT");
                    DetATS.Importe := SCMH.Amount;
                    DetATS."Importe IVA" := SCMH."Amount Including VAT" - SCMH.Amount;
                    DetATS."Importe IVA Incl." := SCMH."Amount Including VAT";
                    DetATS."Source Type" := DetATS."Source Type"::Customer;
                    DetATS."Source No." := SCMH."Bill-to Customer No.";
                    DetATS."RUC/Cedula" := SCMH."VAT Registration No.";
                    DetATS."No. Autorizacion Documento" := SCMH."No. Autorizacion Comprobante";
                    DetATS."Punto Emision Documento" := SCMH."Punto de Emision Factura";
                    DetATS."Establecimiento Documento" := SCMH."Establecimiento Factura";
                    DetATS."Tipo Comprobante" := CodigoTC(SCMH."Tipo de Comprobante");


                    //+#43088
                    Cust.Get(SCMH."Bill-to Customer No.");
                    DetATS."Parte Relacionada" := Cust."Parte Relacionada";
                    //-#43088

                    DeExportacionOno(SCMH."Gen. Bus. Posting Group"); //14564

                    if SCMH."Fecha Caducidad Comprobante" = 0D then begin
                        NoSeriesLine.Reset;
                        NoSeriesLine.SetRange("Series Code", SCMH."No. Serie NCF Abonos");
                        NoSeriesLine.SetFilter("Starting No.", '<=%1', SCMH."No. Comprobante Fiscal");
                        NoSeriesLine.SetFilter("Ending No.", '>=%1', SCMH."No. Comprobante Fiscal");
                        NoSeriesLine.SetRange(Establecimiento, SCMH."Establecimiento Factura");
                        NoSeriesLine.SetRange("Punto de Emision", SCMH."Punto de Emision Factura");
                        if NoSeriesLine.FindFirst then
                            DetATS."Fecha Caducidad" := NoSeriesLine."Fecha Caducidad";
                    end
                    else
                        DetATS."Fecha Caducidad" := SCMH."Fecha Caducidad Comprobante";

                    VE.Reset;
                    VE.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                    VE.SetRange("Document No.", SCMH."No.");
                    VE.SetRange("Posting Date", SCMH."Posting Date");
                    VE.SetRange(Type, VE.Type::Sale);
                    VE.SetRange("VAT Prod. Posting Group", '_EXENTO');
                    if VE.FindSet then
                        repeat
                            DetATS._EXENTO += VE.Amount;
                        until VE.Next = 0;

                    VE.Reset;
                    VE.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                    VE.SetRange("Document No.", SCMH."No.");
                    VE.SetRange("Posting Date", SCMH."Posting Date");
                    VE.SetRange(Type, VE.Type::Sale);
                    VE.SetRange("VAT Prod. Posting Group", '12% IVA');
                    if VE.FindSet then
                        repeat
                            DetATS."12% IVA" += VE.Amount;
                        until VE.Next = 0;

                    VE.Reset;
                    VE.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                    VE.SetRange("Document No.", SCMH."No.");
                    VE.SetRange("Posting Date", SCMH."Posting Date");
                    VE.SetRange(Type, VE.Type::Sale);
                    VE.SetRange("VAT Prod. Posting Group", '_GR_0');
                    if VE.FindSet then
                        repeat
                            DetATS._GR_0 += VE.Amount;
                        until VE.Next = 0;

                    VE.Reset;
                    VE.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                    VE.SetRange("Document No.", SCMH."No.");
                    VE.SetRange("Posting Date", SCMH."Posting Date");
                    VE.SetRange(Type, VE.Type::Sale);
                    VE.SetRange("VAT Prod. Posting Group", '_GR_12');
                    if VE.FindSet then
                        repeat
                            DetATS._GR_12 += VE.Amount;
                        until VE.Next = 0;

                    VE.Reset;
                    VE.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                    VE.SetRange("Document No.", SCMH."No.");
                    VE.SetRange("Posting Date", SCMH."Posting Date");
                    VE.SetRange(Type, VE.Type::Sale);
                    VE.SetRange("VAT Prod. Posting Group", '10_SERVIC');
                    if VE.FindSet then
                        repeat
                            DetATS."10_SERVIC" += VE.Amount;
                        until VE.Next = 0;
                    DetATS.Insert;
                end;
            until SCMH.Next = 0;
            Window.Close;
        end;

        //COMMIT;
        //CLEAR(DetalleATSPageVtas);
        //DetalleATSPageVtas.RUNMODAL;
    end;


    procedure FormaDePagoCompra(prmProv: Code[20]; prmImp: Decimal; prmFormaPago: Code[10]) rtnValue: Code[2]
    var
        recSIHeader: Record "Sales Invoice Header";
        recPayMethod: Record "Payment Method";
        recCRHeader: Record "Sales Cr.Memo Header";
        recVendor: Record Vendor;
    begin
        Clear(rtnValue);

        //+#43088
        //IF prmImp <= 1000 THEN
        //  EXIT;
        if prmImp < 1000 then
            exit;
        //-#43088

        //IF prmFormaPago <> '' THEN BEGIN
        //  recPayMethod.SETRANGE(recPayMethod.Code, prmFormaPago);
        //  IF recPayMethod.FINDSET THEN
        //    rtnValue := (recPayMethod."Cod. SRI");
        //END
        //ELSE BEGIN
        recVendor.Get(prmProv);
        recPayMethod.SetRange(recPayMethod.Code, recVendor."Payment Method Code");
        if recPayMethod.FindSet then
            rtnValue := (recPayMethod."Cod. SRI");
        //END;
    end;


    procedure ProveedorLocaloExtranjero(vCodePais: Code[10])
    var
        recCountry: Record "Country/Region";
    begin
        //14564
        if vCodePais <> 'EC' then
            DetATS."Pago a residente" := '02'
        else
            DetATS."Pago a residente" := '01';


        recCountry.SetRange(Code, vCodePais);

        if recCountry.FindSet then begin
            //+#43088
            //DetATS."Tiene Convenio"       := recCountry."Tiene Convenio";
            //-#43088

            //DetATS."Sujeto a Retencion"   := recCountry."Sujeto a Retencion";
            //+#34829
            //IF vCodePais <> 'EC' THEN
            //  DetATS."Codigo de Pais"       := recCountry."Codigo Pais ATS";
            //   DetATS."Reg. Fiscal preferente/Paraiso"    :=  PaisParaiso(vCodePais);
            if DetATS."Pago a residente" = '02' then begin

                //+#43088
                if recCountry."Tiene Convenio" then
                    DetATS."Tiene Convenio" := DetATS."Tiene Convenio"::"Sí"
                else
                    DetATS."Tiene Convenio" := DetATS."Tiene Convenio"::No;
                //-#43088

                DetATS."Codigo de Pais" := recCountry."Codigo Pais ATS";

                //+#43088
                //DetATS."Reg. Fiscal preferente/Paraiso"    :=  PaisParaiso(vCodePais);

                //IF NOT recCountry."Tiene Convenio" THEN
                //  DetATS."Sujeto a Retencion"   := recCountry."Sujeto a Retencion";
                if PaisParaiso(vCodePais) then
                    DetATS."Reg. Fiscal preferente/Paraiso" := DetATS."Reg. Fiscal preferente/Paraiso"::"Sí"
                else
                    DetATS."Reg. Fiscal preferente/Paraiso" := DetATS."Reg. Fiscal preferente/Paraiso"::No;

                if not recCountry."Tiene Convenio" then begin
                    if recCountry."Sujeto a Retencion" then
                        DetATS."Sujeto a Retencion" := DetATS."Sujeto a Retencion"::"Sí"
                    else
                        DetATS."Sujeto a Retencion" := DetATS."Sujeto a Retencion"::No;
                end;
                //+#43088
            end;
            //-#34829
        end;
    end;


    procedure DeExportacionOno(vCode: Code[10])
    begin
        //14564
        if vCode = 'EXP_IMP' then
            DetATS.Exportacion := true
        else
            DetATS.Exportacion := false;
    end;


    procedure RellenaCampoPorTipoComprobante()
    begin
        //#16511
        DetATS."Establecimiento Documento" := '999';
        DetATS."Punto Emision Documento" := '999';
        DetATS."No. Autorizacion Documento" := '9999999999';
    end;


    procedure RellenarImporteRetenciones(vCodeNo: Code[20]; vTipoDoc: Option Factura," Nota de Credito"; vTipoComprobante: Code[2])
    var
        rPIH: Record "Purch. Inv. Header";
        TieneRetFuente: Boolean;
    begin
        //#16511
        I := 0;
        TieneRetFuente := false;
        if HR.FindSet then begin
            rPIH.Get(vCodeNo);

            repeat
                HR.CalcFields("Retencion IVA");
                case HR."Retencion IVA" of
                    false:
                        begin
                            DetATS."Cod. Retencion 1" := HR."Código Retención";
                            DetATS."Importe Retencion 1" := HR."Importe Retenido";
                            DetATS."Base Retencion 1" := HR."Importe Base Retencion";
                            DetATS."Porcentaje Retencion 1" := HR."Importe Retención";
                            DetATS."No. Comprobante Retencion 1" := HR.NCF;
                            DetATS."No. Autorizacion Retencion 1" := HR."No. autorizacion NCF";
                            DetATS."Punto Emision Retencion 1" := HR."Punto Emision";
                            DetATS."Establecimiento Retencion 1" := HR.Establecimiento;
                            NoSeriesLine.Reset;
                            NoSeriesLine.SetRange("No. Autorizacion", HR."No. autorizacion NCF");
                            NoSeriesLine.SetRange(Establecimiento, HR.Establecimiento);
                            NoSeriesLine.SetRange("Punto de Emision", HR."Punto Emision");
                            if NoSeriesLine.FindFirst then
                                DetATS."Fecha Caducidad Retencion 1" := NoSeriesLine."Fecha Caducidad";
                            DetATS."Fecha Emision Retencion" := PIH."Posting Date";
                            TieneRetFuente := true;
                        end;

                    true:
                        begin
                            DetATS."Cod. Retencion 2" := HR."Código Retención";
                            DetATS."Importe Retencion 2" := HR."Importe Retenido";
                            DetATS."Base Retencion 2" := HR."Importe Base Retencion";
                            DetATS."Porcentaje Retencion 2" := HR."Importe Retención";
                            DetATS."No. Comprobante Retencion 2" := HR.NCF;
                            DetATS."No. Autorizacion Retencion 2" := HR."No. autorizacion NCF";
                            DetATS."Punto Emision Retencion 2" := HR."Punto Emision";
                            DetATS."Establecimiento Retencion 2" := HR.Establecimiento;
                            NoSeriesLine.Reset;
                            NoSeriesLine.SetRange("No. Autorizacion", HR."No. autorizacion NCF");
                            NoSeriesLine.SetRange(Establecimiento, HR.Establecimiento);
                            NoSeriesLine.SetRange("Punto de Emision", HR."Punto Emision");
                            if NoSeriesLine.FindFirst then
                                DetATS."Fecha Caducidad Retencion 2" := NoSeriesLine."Fecha Caducidad";
                            DetATS."Fecha Emision Retencion" := PIH."Posting Date";
                        end;
                end;
                I += 1;
            until (HR.Next = 0) or (I = 2);
        end;

        if not TieneRetFuente then begin
            if vTipoDoc = 0 then begin //+#ATS
                if vTipoComprobante in ['01', '02', '11', '19', '20'] then begin
                    DetATS."Cod. Retencion 1" := '332';
                    rPIH.Get(vCodeNo);
                    //DetATS."Fecha Emision Retencion"      := PIH."Posting Date";
                    rPIH.CalcFields(Amount);
                    //DetATS."Base Retencion 1"              := rPIH.Amount;
                    DetATS."Base Retencion 1" := DetATS.Importe;

                end;
            end
        end;
    end;


    procedure CodigoTC(prmTipoComprobante: Code[10]) rtnValue: Code[2]
    begin

        rtnValue := prmTipoComprobante;

        if prmTipoComprobante in ['01', '02', '03', '04'] then
            rtnValue := CopyStr(prmTipoComprobante, 2);
    end;


    procedure CodSustentoSin0(prmSustento: Code[10]) rtnValue: Code[2]
    begin

        rtnValue := prmSustento;

        if prmSustento in ['02', '04', '07'] then
            rtnValue := CopyStr(prmSustento, 2);
    end;


    procedure ReporteATSVentas(FechaDesde: Date; FechaHasta: Date)
    var
        rFactVenta: Record "Sales Invoice Header";
        DatosVxC: Record "ATS Ventas x Cliente";
        Cust: Record Customer;
        VatEntry: Record "VAT Entry";
        DetalleATSPageVtas: Page "Detalle Datos ATS Vtas.";
        DatosVxE: Record "ATS Ventas x Establecimiento";
        BaseFactura: Decimal;
        BaseImpuestos: Decimal;
        NoEstablec: Integer;
        EnvATS: Record "Envios ATS";
    begin

        NoEstablec := 0;
        SIH.Reset;
        SIH.SetCurrentKey("Posting Date");
        SIH.SetRange("Posting Date", FechaDesde, FechaHasta);
        //SIH.SETFILTER(SIH."Bill-to Country/Region Code",'%1|%2','EC','');
        SIH.SetRange(Exportación, false);
        //SIH.SETRANGE("Bill-to Customer No.",'G21269');//PRUEBAS
        SIH.SetRange(Correction, false);
        if SIH.FindSet then begin
            CounterTotal := SIH.Count;
            Window.Open(Text004 + Text001);
            repeat
                Counter := Counter + 1;
                Window.Update(1, SIH."No.");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                Corregida := false;
                //Revisar si la factura fue liquidada con una nota de credito por correccion
                CLE.Reset;
                CLE.SetCurrentKey("Document Type", "Customer No.", "Posting Date", "Currency Code");
                CLE.SetRange("Document Type", CLE."Document Type"::Invoice);
                CLE.SetRange("Customer No.", SIH."Bill-to Customer No.");
                CLE.SetRange("Posting Date", SIH."Posting Date");
                CLE.SetRange("Document No.", SIH."No.");
                if CLE.FindFirst then begin
                    //Si la factura esta cerrada
                    if CLE."Closed by Entry No." <> 0 then begin
                        CLE1.Get(CLE."Closed by Entry No.");
                        if CLE1."Document Type" = CLE1."Document Type"::"Credit Memo" then begin
                            SCMH.Get(CLE1."Document No.");
                            if SCMH.Correction then
                                Corregida := true;
                        end;
                    end
                    else begin
                        CLE1.Reset;
                        CLE1.SetCurrentKey("Closed by Entry No.");
                        CLE1.SetRange("Closed by Entry No.", CLE."Entry No.");
                        CLE1.SetRange("Document Type", CLE1."Document Type"::"Credit Memo");
                        if CLE1.FindFirst then begin
                            SCMH.Get(CLE1."Document No.");
                            if SCMH.Correction then
                                Corregida := true
                        end;
                    end;
                end;
                if not Corregida then begin
                    //BaseFactura := 0;
                    //BaseImpuestos := 0;

                    if not DatosVxE.Get(SIH."Establecimiento Factura") then begin
                        DatosVxE.Init;
                        DatosVxE."Mes -  Periodo" := Date2DMY(FechaDesde, 2);
                        DatosVxE."Año - Periodo" := Date2DMY(FechaDesde, 3);
                        DatosVxE."Cod.Establecimiento" := SIH."Establecimiento Factura";
                        DatosVxE.Insert;
                        NoEstablec += 1;
                    end;
                    SIH.CalcFields(Amount);
                    DatosVxE."Ventas Establecimiento" += SIH.Amount;
                    DatosVxE.Modify;
                    //BaseFactura := SIH.Amount;

                    if not DatosVxC.Get(SIH."Bill-to Customer No.", '18') then begin
                        DatosVxC.Init;
                        DatosVxC."Mes -  Periodo" := Date2DMY(FechaDesde, 2);
                        DatosVxC."Año - Periodo" := Date2DMY(FechaDesde, 3);
                        Cust.Get(SIH."Bill-to Customer No.");
                        DatosVxC."Cod.Cliente" := SIH."Bill-to Customer No.";
                        DatosVxC."Nombre Cliente" := SIH."Bill-to Name";
                        DatosVxC."Parte Relacionada" := Cust."Parte Relacionada";
                        case Cust."Tipo Documento" of
                            Cust."Tipo Documento"::RUC:
                                DatosVxC."Tipo Identificacion Cliente" := '04';
                            Cust."Tipo Documento"::Cedula:
                                DatosVxC."Tipo Identificacion Cliente" := '05';
                            Cust."Tipo Documento"::Pasaporte:
                                DatosVxC."Tipo Identificacion Cliente" := '06';
                        end;
                        DatosVxC."No. Identificación Cliente" := SIH."VAT Registration No.";
                        DatosVxC."Codigo Tipo Comprobante" := '18';
                        RetencionVentas(FechaDesde, FechaHasta, DatosVxC."Cod.Cliente", DatosVxC."Valor IVA retenido", DatosVxC."Valor Renta retenido");
                        DatosVxC.Insert;
                    end;
                    DatosVxC."No. de Comprobantes" += 1;
                    DatosVxC."Valor Renta retenido" += SIH."Importe Retencion Venta";

                    VatEntry.Reset;
                    VatEntry.SetRange("Document Type", VE."Document Type"::Invoice);
                    VatEntry.SetRange("Document No.", SIH."No.");
                    VatEntry.SetRange("Posting Date", SIH."Posting Date");
                    VatEntry.SetRange(Type, VE.Type::Sale);
                    VatEntry.SetRange("VAT Prod. Posting Group", '_EXENTO');
                    if VatEntry.FindSet then
                        repeat
                            DatosVxC."Base Imponible No objeto IVA" += -VatEntry.Base;
                        //BaseImpuestos += -VatEntry.Base;
                        until VatEntry.Next = 0;
                    VatEntry.Reset;
                    VatEntry.SetRange("Document Type", VE."Document Type"::Invoice);
                    VatEntry.SetRange("Document No.", SIH."No.");
                    VatEntry.SetRange("Posting Date", SIH."Posting Date");
                    VatEntry.SetRange(Type, VE.Type::Sale);
                    VatEntry.SetRange("VAT Prod. Posting Group", '_GR_12');
                    if VatEntry.FindSet then
                        repeat
                            DatosVxC."Base Imposible 12% IVA" += -VatEntry.Base;
                            DatosVxC."Monto IVA" += -VatEntry.Amount;
                        //BaseImpuestos += -VatEntry.Base;
                        until VatEntry.Next = 0;
                    VatEntry.Reset;
                    VatEntry.SetRange("Document Type", VE."Document Type"::Invoice);
                    VatEntry.SetRange("Document No.", SIH."No.");
                    VatEntry.SetRange("Posting Date", SIH."Posting Date");
                    VatEntry.SetRange(Type, VE.Type::Sale);
                    VatEntry.SetRange("VAT Prod. Posting Group", '_GR_0');
                    if VatEntry.FindSet then
                        repeat
                            DatosVxC."Base Imponible 0% IVA" += -VatEntry.Base;
                        //BaseImpuestos += -VatEntry.Base;
                        until VatEntry.Next = 0;

                    VatEntry.Reset;
                    VatEntry.SetRange("Document Type", VE."Document Type"::Invoice);
                    VatEntry.SetRange("Document No.", SIH."No.");
                    VatEntry.SetRange("Posting Date", SIH."Posting Date");
                    VatEntry.SetRange(Type, VE.Type::Sale);
                    VatEntry.SetRange("VAT Prod. Posting Group", ' ');
                    if VatEntry.FindSet then
                        repeat
                            DatosVxC."Base Imponible 0% IVA" += -VatEntry.Base;
                        //BaseImpuestos += -VatEntry.Base;
                        until VatEntry.Next = 0;

                    DatosVxC.Modify;
                    //IF BaseFactura <> BaseImpuestos THEN
                    //  MESSAGE(SIH."No." + ' ' + FORMAT(BaseFactura) +  ' - ' + FORMAT(BaseImpuestos));
                end;
            until SIH.Next = 0;
            Window.Close;
        end;

        SCMH.Reset;
        SCMH.SetCurrentKey("Posting Date");
        SCMH.SetRange("Posting Date", FechaDesde, FechaHasta);
        //SCMH.SETFILTER("Bill-to Country/Region Code",'%1|%2','EC','');
        SCMH.SetRange(Exportación, false);
        //SCMH.SETRANGE("Bill-to Customer No.",'G21269');//PRUEBAS
        SCMH.SetRange(Correction, false);
        if SCMH.FindSet then begin
            CounterTotal := SCMH.Count;
            Window.Open(Text004 + Text002);
            repeat
                Counter := Counter + 1;
                Window.Update(1, SCMH."No.");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
                //BaseFactura := 0;
                //BaseImpuestos := 0;

                Corregida := false;
                rFactVenta.Reset;
                rFactVenta.SetRange("No. Nota Credito a Anular", SCMH."No.");
                if rFactVenta.FindSet then
                    if rFactVenta.Correction then
                        Corregida := true;

                if not Corregida then begin

                    //VENTAS POR ESTABLECIMIENTO
                    if not DatosVxE.Get(SCMH."Establecimiento Factura") then begin
                        DatosVxE.Init;
                        DatosVxE."Mes -  Periodo" := Date2DMY(FechaDesde, 2);
                        DatosVxE."Año - Periodo" := Date2DMY(FechaDesde, 3);
                        DatosVxE."Cod.Establecimiento" := SCMH."Establecimiento Factura";
                        DatosVxE.Insert;
                        NoEstablec += 1;
                    end;
                    SCMH.CalcFields(Amount);
                    DatosVxE."Ventas Establecimiento" -= SCMH.Amount;
                    DatosVxE.Modify;
                    //BaseFactura :=  -SCMH.Amount;

                    //VENTAS POR CLIENTE
                    if not DatosVxC.Get(SCMH."Bill-to Customer No.", '4') then begin
                        DatosVxC.Init;
                        DatosVxC."Mes -  Periodo" := Date2DMY(FechaDesde, 2);
                        DatosVxC."Año - Periodo" := Date2DMY(FechaDesde, 3);

                        Cust.Get(SCMH."Bill-to Customer No.");
                        DatosVxC."Cod.Cliente" := SCMH."Bill-to Customer No.";
                        DatosVxC."Nombre Cliente" := SCMH."Bill-to Name";
                        DatosVxC."Parte Relacionada" := Cust."Parte Relacionada";
                        case Cust."Tipo Documento" of
                            Cust."Tipo Documento"::RUC:
                                DatosVxC."Tipo Identificacion Cliente" := '04';
                            Cust."Tipo Documento"::Cedula:
                                DatosVxC."Tipo Identificacion Cliente" := '05';
                            Cust."Tipo Documento"::Pasaporte:
                                DatosVxC."Tipo Identificacion Cliente" := '06';
                        end;
                        DatosVxC."No. Identificación Cliente" := SCMH."VAT Registration No.";
                        DatosVxC."Codigo Tipo Comprobante" := '4';
                        //IF RetVentas.GET(DatosVxC."Mes -  Periodo",DatosVxC."Año - Periodo",DatosVxC."Cod.Cliente",DatosVxC."Codigo Tipo Comprobante") THEN BEGIN
                        //DatosVxC."Valor IVA retenido" :=   RetVentas."Valor IVA retenido";
                        //DatosVxC."Valor Renta retenido" := RetVentas."Valor Renta retenido";
                        //END;
                        DatosVxC.Insert;
                    end;
                    DatosVxC."No. de Comprobantes" += 1;

                    VatEntry.Reset;
                    VatEntry.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                    VatEntry.SetRange("Document No.", SCMH."No.");
                    VatEntry.SetRange("Posting Date", SCMH."Posting Date");
                    VatEntry.SetRange(Type, VE.Type::Sale);
                    VatEntry.SetRange("VAT Prod. Posting Group", '_EXENTO');
                    if VatEntry.FindSet then
                        repeat
                            DatosVxC."Base Imponible No objeto IVA" += -VatEntry.Base;
                        //BaseImpuestos += -VatEntry.Base;
                        until VatEntry.Next = 0;
                    VatEntry.Reset;
                    VatEntry.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                    VatEntry.SetRange("Document No.", SCMH."No.");
                    VatEntry.SetRange("Posting Date", SCMH."Posting Date");
                    VatEntry.SetRange(Type, VE.Type::Sale);
                    VatEntry.SetRange("VAT Prod. Posting Group", '_GR_12');
                    if VatEntry.FindSet then
                        repeat
                            DatosVxC."Base Imposible 12% IVA" += VatEntry.Base;
                            DatosVxC."Monto IVA" += VatEntry.Amount;
                        //BaseImpuestos += -VatEntry.Base;
                        until VatEntry.Next = 0;
                    VatEntry.Reset;
                    VatEntry.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                    VatEntry.SetRange("Document No.", SCMH."No.");
                    VatEntry.SetRange("Posting Date", SCMH."Posting Date");
                    VatEntry.SetRange(Type, VE.Type::Sale);
                    VatEntry.SetRange("VAT Prod. Posting Group", '_GR_0');
                    if VatEntry.FindSet then
                        repeat
                            DatosVxC."Base Imponible 0% IVA" += VatEntry.Base;
                        //BaseImpuestos += -VatEntry.Base;
                        until VatEntry.Next = 0;
                    VatEntry.Reset;
                    VatEntry.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                    VatEntry.SetRange("Document No.", SCMH."No.");
                    VatEntry.SetRange("Posting Date", SCMH."Posting Date");
                    VatEntry.SetRange(Type, VE.Type::Sale);
                    VatEntry.SetRange("VAT Prod. Posting Group", ' ');
                    if VatEntry.FindSet then
                        repeat
                            DatosVxC."Base Imponible 0% IVA" += VatEntry.Base;
                        //BaseImpuestos += -VatEntry.Base;
                        until VatEntry.Next = 0;

                    //IF BaseFactura <> BaseImpuestos THEN
                    //  MESSAGE(SCMH."No." + ' ' + FORMAT(BaseFactura) +  ' - ' + FORMAT(BaseImpuestos));

                    DatosVxC.Modify;
                end;
            until SCMH.Next = 0;
            Window.Close;
        end;

        EnvATS.SetRange(Mes, Date2DMY(FechaDesde, 2));
        EnvATS.SetRange(Año, Date2DMY(FechaDesde, 3));
        EnvATS.FindSet;
        EnvATS."No. Establecimientos" := NoEstablec;
        EnvATS.Modify;

        //COMMIT;
        //CLEAR(DetalleATSPageVtas);
        //DetalleATSPageVtas.RUNMODAL;
    end;


    procedure ReporteATSExportaciones(FechaDesde: Date; FechaHasta: Date)
    var
        rFactVenta: Record "Sales Invoice Header";
        Cust: Record Customer;
        VatEntry: Record "VAT Entry";
        DetalleATSPageExport: Page "SRI Exportaciones";
        DatosExp: Record "ATS Exportaciones";
    begin

        SIH.Reset;
        SIH.SetCurrentKey("Posting Date");
        SIH.SetRange("Posting Date", FechaDesde, FechaHasta);
        //SIH.SETFILTER(SIH."Bill-to Country/Region Code",'<>%1&<>%2','EC','');
        SIH.SetRange(Exportación, true);
        SIH.SetRange(Correction, false);
        if SIH.FindSet then begin
            CounterTotal := SIH.Count;
            Window.Open(Text007 + Text001);
            repeat
                Counter := Counter + 1;
                Window.Update(1, SIH."No.");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                Corregida := false;
                //Revisar si la factura fue liquidada con una nota de credito por correccion
                CLE.Reset;
                CLE.SetCurrentKey("Document Type", "Customer No.", "Posting Date", "Currency Code");
                CLE.SetRange("Document Type", CLE."Document Type"::Invoice);
                CLE.SetRange("Customer No.", SIH."Bill-to Customer No.");
                CLE.SetRange("Posting Date", SIH."Posting Date");
                CLE.SetRange("Document No.", SIH."No.");
                if CLE.FindFirst then begin
                    //Si la factura esta cerrada
                    if CLE."Closed by Entry No." <> 0 then begin
                        CLE1.Get(CLE."Closed by Entry No.");
                        if CLE1."Document Type" = CLE1."Document Type"::"Credit Memo" then begin
                            SCMH.Get(CLE1."Document No.");
                            if SCMH.Correction then
                                Corregida := true;
                        end;
                    end
                    else begin
                        CLE1.Reset;
                        CLE1.SetCurrentKey("Closed by Entry No.");
                        CLE1.SetRange("Closed by Entry No.", CLE."Entry No.");
                        CLE1.SetRange("Document Type", CLE1."Document Type"::"Credit Memo");
                        if CLE1.FindFirst then begin
                            SCMH.Get(CLE1."Document No.");
                            if SCMH.Correction then
                                Corregida := true
                        end;
                    end;
                end;
                if not Corregida then begin
                    DatosExp.Init;

                    Cust.Get(SIH."Bill-to Customer No.");
                    case Cust."Tipo Documento" of
                        Cust."Tipo Documento"::RUC:
                            DatosExp."Tipo Identificacion Cliente" := '04';
                        Cust."Tipo Documento"::Cedula:
                            DatosExp."Tipo Identificacion Cliente" := '05';
                        Cust."Tipo Documento"::Pasaporte:
                            DatosExp."Tipo Identificacion Cliente" := '06';
                    end;
                    DatosExp."No. Identificación Cliente" := SIH."VAT Registration No.";
                    DatosExp."Pais Exportación" := Cust."Country/Region Code";
                    DatosExp."Reg. fiscal preferente/paraiso" := PaisParaiso(Cust."Country/Region Code");
                    DatosExp."Parte Relacionada" := Cust."Parte Relacionada";
                    DatosExp."Tipo de Comprobante" := SIH."Tipo de Comprobante";
                    DatosExp."No. Documento" := SIH."No.";
                    //+#34853
                    //IF SIH."Con Refrendo" THEN BEGIN
                    //  DatosExp."Tipo Exportación"                 := '01';
                    //  DatosExp."No. refrendo - distrito adua."  :=  SIH."No. refrendo - distrito adua.";
                    //  DatosExp."No. refrendo - Año"             :=  SIH."No. refrendo - Año";
                    //  DatosExp."No. refrendo - regimen"         :=  SIH."No. refrendo - regimen";
                    //  DatosExp."No. refrendo - Correlativo"     :=  SIH."No. refrendo - Correlativo";
                    //END
                    //ELSE
                    //  DatosExp."Tipo Exportación"                 := '02';
                    case SIH."Tipo Exportacion" of
                        SIH."Tipo Exportacion"::"01":
                            DatosExp."Tipo Exportación" := '01';
                        SIH."Tipo Exportacion"::"02":
                            DatosExp."Tipo Exportación" := '02';
                        SIH."Tipo Exportacion"::"03":
                            DatosExp."Tipo Exportación" := '03';
                    end;
                    if DatosExp."Tipo Exportación" = '01' then begin
                        DatosExp."No. refrendo - distrito adua." := SIH."No. refrendo - distrito adua.";
                        DatosExp."No. refrendo - Año" := SIH."No. refrendo - Año";
                        DatosExp."No. refrendo - regimen" := SIH."No. refrendo - regimen";
                        DatosExp."No. refrendo - Correlativo" := SIH."No. refrendo - Correlativo";
                    end;
                    //-#34853
                    DatosExp."No. de documento de transporte" := SIH."Nº Documento Transporte";
                    DatosExp."Fecha de Embarque" := SIH."Fecha embarque";
                    DatosExp."Valor FOB" := SIH."Valor FOB";
                    DatosExp."Valor del comprobante local" := SIH."Valor FOB Comprobante Local";
                    DatosExp."Establecimiento comprobante" := SIH."Establecimiento Factura";
                    DatosExp."Punto emision comprobante" := SIH."Punto de Emision Factura";
                    DatosExp."No. Secuencial comprobante" := SIH."No. Comprobante Fiscal";
                    DatosExp."No. autorización comprobante" := SIH."No. Autorizacion Comprobante";
                    DatosExp."Fecha emision comprobante" := SIH."Posting Date";
                    DatosExp."Mes -  Periodo" := Date2DMY(FechaDesde, 2);
                    DatosExp."Año - Periodo" := Date2DMY(FechaDesde, 3);
                    DatosExp.Insert;
                end;
            until SIH.Next = 0;
            Window.Close;
        end;

        SCMH.Reset;
        SCMH.SetCurrentKey("Posting Date");
        SCMH.SetRange("Posting Date", FechaDesde, FechaHasta);
        //SCMH.SETFILTER("Bill-to Country/Region Code",'<>%1&<>%2','EC','');
        SCMH.SetRange(Exportación, true);
        SCMH.SetRange(Correction, false);
        if SCMH.FindSet then begin
            CounterTotal := SCMH.Count;
            Window.Open(Text007 + Text002);
            repeat
                Counter := Counter + 1;
                Window.Update(1, SCMH."No.");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                Corregida := false;
                rFactVenta.Reset;
                rFactVenta.SetRange("No. Nota Credito a Anular", SCMH."No.");
                if rFactVenta.FindSet then
                    if rFactVenta.Correction then
                        Corregida := true;

                if not Corregida then begin
                    DatosExp.Init;

                    Cust.Get(SIH."Bill-to Customer No.");
                    case Cust."Tipo Documento" of
                        Cust."Tipo Documento"::RUC:
                            DatosExp."Tipo Identificacion Cliente" := '04';
                        Cust."Tipo Documento"::Cedula:
                            DatosExp."Tipo Identificacion Cliente" := '05';
                        Cust."Tipo Documento"::Pasaporte:
                            DatosExp."Tipo Identificacion Cliente" := '06';
                    end;
                    DatosExp."No. Identificación Cliente" := SCMH."VAT Registration No.";
                    DatosExp."Pais Exportación" := Cust."Country/Region Code";
                    DatosExp."Reg. fiscal preferente/paraiso" := PaisParaiso(Cust."Country/Region Code");


                    DatosExp."Tipo de Comprobante" := SCMH."Tipo de Comprobante";
                    DatosExp."No. Documento" := SCMH."No.";
                    //+#34853
                    //IF SCMH."Con Refrendo" THEN BEGIN
                    //  DatosExp."Tipo Exportación"                 := '01';
                    //  DatosExp."No. refrendo - distrito adua."  :=  SCMH."No. refrendo - distrito adua.";
                    //  DatosExp."No. refrendo - Año"             :=  SCMH."No. refrendo - Año";
                    //  DatosExp."No. refrendo - regimen"         :=  SCMH."No. refrendo - regimen";
                    //  DatosExp."No. refrendo - Correlativo"     :=  SCMH."No. refrendo - Correlativo";
                    //END
                    //ELSE
                    //  DatosExp."Tipo Exportación"                 := '02';
                    case SCMH."Tipo Exportacion" of
                        SCMH."Tipo Exportacion"::"01":
                            DatosExp."Tipo Exportación" := '01';
                        SCMH."Tipo Exportacion"::"02":
                            DatosExp."Tipo Exportación" := '02';
                        SCMH."Tipo Exportacion"::"03":
                            DatosExp."Tipo Exportación" := '03';
                    end;
                    if DatosExp."Tipo Exportación" = '01' then begin
                        DatosExp."No. refrendo - distrito adua." := SCMH."No. refrendo - distrito adua.";
                        DatosExp."No. refrendo - Año" := SCMH."No. refrendo - Año";
                        DatosExp."No. refrendo - regimen" := SCMH."No. refrendo - regimen";
                        DatosExp."No. refrendo - Correlativo" := SCMH."No. refrendo - Correlativo";
                    end;
                    //-#34853
                    DatosExp."No. de documento de transporte" := SCMH."Nº Documento Transporte";
                    DatosExp."Fecha de Embarque" := SCMH."Fecha embarque";
                    DatosExp."Valor FOB" := SCMH."Valor FOB";
                    DatosExp."Valor del comprobante local" := SCMH."Valor FOB Comprobante Local";
                    DatosExp."Establecimiento comprobante" := SCMH."Establecimiento Factura";
                    DatosExp."Punto emision comprobante" := SCMH."Punto de Emision Factura";
                    DatosExp."No. Secuencial comprobante" := SCMH."No. Comprobante Fiscal";
                    DatosExp."No. autorización comprobante" := SCMH."No. Autorizacion Comprobante";
                    DatosExp."Fecha emision comprobante" := SCMH."Posting Date";
                    DatosExp."Mes -  Periodo" := Date2DMY(FechaDesde, 2);
                    DatosExp."Año - Periodo" := Date2DMY(FechaDesde, 3);
                    DatosExp.Insert;

                end;
            until SCMH.Next = 0;
            Window.Close;
        end;

        //COMMIT;
        //CLEAR(DetalleATSPageExport);
        //DetalleATSPageExport.RUNMODAL;
    end;


    procedure ReporteATSAnulados(FechaDesde: Date; FechaHasta: Date)
    var
        NCFanul: Record "NCF Anulados";
        ATSanul: Record "ATS Comprobantes Anulados";
        SalesIH: Record "Sales Invoice Header";
        SalesCRH: Record "Sales Cr.Memo Header";
        DetalleATSPageAnul: Page "SRI Comprobantes anulados";
        DocAnulados: Record "Documentos Anulados";
    begin

        //+#42986
        //INICIO CODIGO DESCONECTADO
        /*
        ReporteATSVentaAnulado(FechaDesde,FechaHasta);
        
        Counter := 0;
        NCFanul.RESET;
        NCFanul.SETRANGE("Fecha anulacion",FechaDesde,FechaHasta);
        //NCFanul.SETFILTER("Tipo Documento",'%1|%2|%3',NCFanul."Tipo Documento"::Invoice,NCFanul."Tipo Documento"::"Credit Memo",NCFanul."Tipo Documento"::Retencion);
        NCFanul.SETFILTER("Tipo Documento",'%1',NCFanul."Tipo Documento"::Retencion);
        IF NCFanul.FINDSET THEN BEGIN
          CounterTotal := NCFanul.COUNT;
          Window.OPEN(Text005 + Text006);
          REPEAT
            Counter := Counter + 1;
            Window.UPDATE(1,NCFanul."No. documento");
            Window.UPDATE(2,ROUND(Counter / CounterTotal * 10000,1));
            ATSanul.INIT;
            ATSanul."Mes -  Periodo" :=  DATE2DMY(FechaDesde,2);
            ATSanul."Año - Periodo"  :=  DATE2DMY(FechaDesde,3);
            CASE NCFanul."Tipo Documento" OF
              NCFanul."Tipo Documento"::Invoice      :
                BEGIN
                  SalesIH.GET(NCFanul."No. documento");
                  ATSanul."Tipo Comprobante anulado" :=  SalesIH."Tipo de Comprobante";
                END;
              NCFanul."Tipo Documento"::"Credit Memo" :
               BEGIN
                  SalesCRH.GET(NCFanul."No. documento");
                  ATSanul."Tipo Comprobante anulado" :=  SalesCRH."Tipo de Comprobante";
                END;
        
             NCFanul."Tipo Documento"::Retencion : ATSanul."Tipo Comprobante anulado" :=  '07';
        
            END;
        
            ATSanul.Establecimiento            :=  NCFanul.Establecimiento;
            ATSanul."Punto Emision"            :=  NCFanul."Punto Emision";
            ATSanul."No. secuencial - Desde"   :=  NCFanul."No. Comprobante Fiscal";
            ATSanul."No. secuencial - Hasta"   :=  NCFanul."No. Comprobante Fiscal";
            ATSanul."No. autorización"         :=  NCFanul."No. Autorizacion";
            IF ATSanul.INSERT THEN;
          UNTIL NCFanul.NEXT=0;
          Window.CLOSE;
        END;
        //COMMIT;
        //CLEAR(DetalleATSPageAnul);
        //DetalleATSPageAnul.RUNMODAL;
        */
        //FIN CODIGO DESCONECTADO

        //INICIO NUEVO CODIGO
        Counter := 0;
        DocAnulados.Reset;
        DocAnulados.SetRange("Fecha anulación", FechaDesde, FechaHasta);
        if DocAnulados.FindSet then begin
            CounterTotal := DocAnulados.Count;
            Window.Open(Text005 + Text006);
            repeat
                Counter := Counter + 1;
                Window.Update(1, DocAnulados."Número Establecimiento" + '-' + DocAnulados."Número Punto Emisión" + '-' + DocAnulados."Número Comprobante");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
                ATSanul.Init;
                ATSanul."Mes -  Periodo" := Date2DMY(FechaDesde, 2);
                ATSanul."Año - Periodo" := Date2DMY(FechaDesde, 3);
                ATSanul."Tipo Comprobante anulado" := DocAnulados."Codigo Documento";
                ATSanul.Establecimiento := DocAnulados."Número Establecimiento";
                ATSanul."Punto Emision" := DocAnulados."Número Punto Emisión";
                ATSanul."No. secuencial - Desde" := DocAnulados."Número Comprobante";
                ATSanul."No. secuencial - Hasta" := DocAnulados."Número Comprobante";
                ATSanul."No. autorización" := DocAnulados."Número Autorización";
                ATSanul.Insert;
            until DocAnulados.Next = 0;
            Window.Close;
        end;


        //FIN NUEVO CODIGO

        //-#42986

    end;


    procedure getRutaGenerados(): Text[255]
    var
        rConfATS: Record "Config. ATS";
    begin

        rConfATS.Get;
        rConfATS.TestField("Ruta ficheros XML");
        rConfATS.TestField(rConfATS."Subcarpeta generados");
        exit(rConfATS."Ruta ficheros XML" + '\' + rConfATS."Subcarpeta generados" + '\');
    end;


    procedure getNombreFichero(prmMes: Integer; "prmAño": Integer): Text[150]
    var
        Mes: Code[2];
        "Año": Code[4];
    begin

        Mes := Format(prmMes);
        if StrLen(Format(prmMes)) = 1 then
            Mes := '0' + Format(prmMes);
        Año := Format(prmAño);
        if StrLen(Format(prmAño)) = 2 then
            Año := '20' + Format(prmAño);

        exit('ATS' + Mes + Año);
    end;


    procedure GenerarXML(var texPrmFichero: Text[255]; prmMes: Integer; "prmAño": Integer): Boolean
    var
        /*         XMLDOMDocument: Automation;
                XMLNode: Automation;
                recTmpBlob: Record TempBlob; */
        OutStreamObj: OutStream;
        inStreamObj: InStream;
        texRutaDestino: Text[255];
        Error026: Label 'El usuario %1 no tiene permisos para acceder a la ruta %2';
        EnvATS: Record "Envios ATS";
    begin

        //#34860 CrearEnvio(prmMes,prmAño);
        /* 
                if IsClear(XMLDOMDocument) then begin
                    Create(XMLDOMDocument, true, true);
                    XMLDOMDocument.async := false;
                end; */


        /*  recTmpBlob.Blob.CreateOutStream(OutStreamObj);

         texPrmFichero := getNombreFichero(prmMes, prmAño) + '.XML';
         texRutaDestino := getRutaGenerados + texPrmFichero;

         EnvATS.SetRange(EnvATS.Mes, prmMes);
         EnvATS.SetRange(EnvATS.Año, prmAño);
         EnvATS.FindLast;

         XMLPORT.Export(XMLPORT::"Anexo Transaccional Simplific.", OutStreamObj, EnvATS);
         recTmpBlob.Blob.Export(texRutaDestino);


         //XMLDOMDocument.load('\\DESARROLLO\compartido\EC\XML\ATS\Generados\ATS012014.XML');
         if not XMLDOMDocument.load(texRutaDestino) then
             if not XMLDOMDocument.load(texRutaDestino) then
                 Error(Error026, UserId, texRutaDestino);


         XMLNode := XMLDOMDocument.documentElement;

         DeleteEmptyXMLNodes(XMLNode);

         XMLDOMDocument.save(texRutaDestino);
  */
        exit(true);
    end;


    procedure DeleteEmptyXMLNodes(XMLNode: text)
    var
        /*         XMLDomNodeList: Automation;
                XMLChildNode: Automation; */
        i: Integer;
    begin
        /*  if XMLNode.nodeTypeString = 'element' then begin
             if (XMLNode.hasChildNodes = false) then begin
                 if (XMLNode.xml = '<' + XMLNode.nodeName + '/>') then
                     XMLNode := XMLNode.parentNode.removeChild(XMLNode)
             end else begin
                 XMLDomNodeList := XMLNode.childNodes;
                 for i := 1 to XMLDomNodeList.length do begin
                     XMLChildNode := XMLDomNodeList.nextNode();
                     DeleteEmptyXMLNodes(XMLChildNode);
                 end;
             end;
         end; */
    end;


    procedure CrearEnvio(prmMes: Integer; "prmAño": Integer)
    var
        EnvATS: Record "Envios ATS";
    begin
        //#34860

        EnvATS.SetRange(Mes, prmMes);
        EnvATS.SetRange(Año, prmAño);
        if not EnvATS.FindSet then begin
            EnvATS.Init;
            EnvATS.Mes := prmMes;
            EnvATS.Año := prmAño;
            EnvATS.Insert(true);
        end;
        EnvATS."Fecha generación" := Today;
        EnvATS.Modify;
    end;


    procedure GenerarXMLDotNet(var texPrmFichero: Text[255]; prmMes: Integer; "prmAño": Integer): Boolean
    var
    /*   XMLDOMDocument: DotNet XmlDocument;
      XMLNode: DotNet XmlNode;
      recTmpBlob: Record TempBlob;
      OutStreamObj: OutStream;
      inStreamObj: InStream;
      texRutaDestino: Text[255];
      Error026: Label 'El usuario %1 no tiene permisos para acceder a la ruta %2';
      EnvATS: Record "Envios ATS";
      XMLDomNodeList: DotNet XmlNodeList;
      TotalNodos: Integer;
      XMLNodeParent: DotNet XmlNode; */
    begin
        //#34860 CrearEnvio(prmMes,prmAño);

        /*    XMLDOMDocument := XMLDOMDocument.XmlDocument;


           recTmpBlob.Blob.CreateOutStream(OutStreamObj);

           //texPrmFichero := ;
           texRutaDestino := getRutaGenerados + getNombreFichero(prmMes, prmAño) + '.XML';

           EnvATS.SetRange(EnvATS.Mes, prmMes);
           EnvATS.SetRange(EnvATS.Año, prmAño);
           EnvATS.FindLast;

           XMLPORT.Export(XMLPORT::"Anexo Transaccional Simplific.", OutStreamObj, EnvATS);
           recTmpBlob.Blob.Export(texRutaDestino);

           XMLDOMDocument.Load(texRutaDestino);
           XMLDomNodeList := XMLDOMDocument.SelectNodes('//*[count(child::node() | @*) = 0]');
           TotalNodos := XMLDomNodeList.Count;
           if TotalNodos > 0 then
               for I := 0 to TotalNodos - 1 do begin
                   XMLNode := XMLDomNodeList.Item(I);
                   XMLNodeParent := XMLNode.ParentNode;
                   if XMLNodeParent.HasChildNodes then
                       XMLNodeParent.RemoveChild(XMLNode);
               end;
           XMLDOMDocument.Save(texRutaDestino);


           texPrmFichero := texRutaDestino; */

        exit(true);
    end;


    procedure PruebaXML()
    var
    /*  XMLDOMDocument: DotNet XmlDocument;
     XMLNode: DotNet XmlNode;
     XMLDomNodeList: DotNet XmlNodeList;
     TotalNodos: Integer;
     XMLNodeParent: DotNet XmlNode; */
    begin
        /* 
                XMLDOMDocument := XMLDOMDocument.XmlDocument;

                XMLDOMDocument.Load('\\DESARROLLO\compartido\EC\XML\ATS\Generados\ATS022014.XML');

                XMLDomNodeList := XMLDOMDocument.SelectNodes('//*[count(child::node() | @*) = 0]');

                TotalNodos := XMLDomNodeList.Count;

                if TotalNodos > 0 then begin
                    for I := 0 to TotalNodos - 1 do begin
                        XMLNode := XMLDomNodeList.Item(I);
                        XMLNodeParent := XMLNode.ParentNode;
                        if XMLNodeParent.HasChildNodes then begin
                            XMLNodeParent.RemoveChild(XMLNode);
                        end
                    end;
                end;

                XMLDOMDocument.Save('\\DESARROLLO\compartido\EC\XML\ATS\Generados\ATS022014_FINAL.XML') */
        ;
    end;


    procedure ReporteATSVentaAnulado(FechaDesde: Date; FechaHasta: Date)
    var
        rFactVenta: Record "Sales Invoice Header";
        ATSanul: Record "ATS Comprobantes Anulados";
    begin


        SIH.Reset;
        SIH.SetCurrentKey("Posting Date");
        SIH.SetRange("Posting Date", FechaDesde, FechaHasta);
        //SIH.SETRANGE(Correction,FALSE);
        if SIH.FindSet then begin
            CounterTotal := SIH.Count;
            Window.Open(Text005 + Text001);
            repeat
                Counter := Counter + 1;
                Window.Update(1, SIH."No.");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                Corregida := false;
                //Revisar si la factura fue liquidada con una nota de credito por correccion
                CLE.Reset;
                CLE.SetCurrentKey("Document Type", "Customer No.", "Posting Date", "Currency Code");
                CLE.SetRange("Document Type", CLE."Document Type"::Invoice);
                CLE.SetRange("Customer No.", SIH."Bill-to Customer No.");
                CLE.SetRange("Posting Date", SIH."Posting Date");
                CLE.SetRange("Document No.", SIH."No.");
                if CLE.FindFirst then begin
                    //Si la factura esta cerrada
                    if CLE."Closed by Entry No." <> 0 then begin
                        CLE1.Get(CLE."Closed by Entry No.");
                        if CLE1."Document Type" = CLE1."Document Type"::"Credit Memo" then begin
                            SCMH.Get(CLE1."Document No.");
                            if SCMH.Correction then
                                Corregida := true;
                        end;
                    end
                    else begin
                        CLE1.Reset;
                        CLE1.SetCurrentKey("Closed by Entry No.");
                        CLE1.SetRange("Closed by Entry No.", CLE."Entry No.");
                        CLE1.SetRange("Document Type", CLE1."Document Type"::"Credit Memo");
                        if CLE1.FindFirst then begin
                            SCMH.Get(CLE1."Document No.");
                            if SCMH.Correction then
                                Corregida := true
                        end;
                    end;
                end;
                if Corregida then begin
                    ATSanul.Init;
                    ATSanul."Mes -  Periodo" := Date2DMY(FechaDesde, 2);
                    ATSanul."Año - Periodo" := Date2DMY(FechaDesde, 3);
                    ATSanul."Tipo Comprobante anulado" := SIH."Tipo de Comprobante";
                    ATSanul.Establecimiento := SIH."Establecimiento Factura";
                    ATSanul."Punto Emision" := SIH."Punto de Emision Factura";
                    ATSanul."No. secuencial - Desde" := SIH."No. Comprobante Fiscal";
                    ATSanul."No. secuencial - Hasta" := SIH."No. Comprobante Fiscal";
                    ATSanul."No. autorización" := SIH."No. Autorizacion Comprobante";
                    ATSanul.Insert;
                end;
            until SIH.Next = 0;
            Window.Close;
        end;

        SCMH.Reset;
        SCMH.SetCurrentKey("Posting Date");
        SCMH.SetRange("Posting Date", FechaDesde, FechaHasta);
        //SCMH.SETRANGE(Correction,FALSE);
        if SCMH.FindSet then begin
            CounterTotal := SCMH.Count;
            Window.Open(Text005 + Text002);
            repeat
                Counter := Counter + 1;
                Window.Update(1, SCMH."No.");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                Corregida := false;
                rFactVenta.Reset;
                rFactVenta.SetRange("No. Nota Credito a Anular", SCMH."No.");
                if rFactVenta.FindSet then
                    if rFactVenta.Correction then
                        Corregida := true;

                if Corregida then begin
                    ATSanul.Init;
                    ATSanul."Mes -  Periodo" := Date2DMY(FechaDesde, 2);
                    ATSanul."Año - Periodo" := Date2DMY(FechaDesde, 3);
                    ATSanul."Tipo Comprobante anulado" := SCMH."Tipo de Comprobante";
                    ATSanul.Establecimiento := SCMH."Establecimiento Factura";
                    ATSanul."Punto Emision" := SCMH."Punto de Emision Factura";
                    ATSanul."No. secuencial - Desde" := SCMH."No. Comprobante Fiscal";
                    ATSanul."No. secuencial - Hasta" := SCMH."No. Comprobante Fiscal";
                    ATSanul."No. autorización" := SCMH."No. Autorizacion Comprobante";
                    ATSanul.Insert;
                end;
            until SCMH.Next = 0;
            Window.Close;
        end;
    end;


    procedure PaisParaiso(pCodPais: Code[20]): Boolean
    var
        rCountry: Record "Country/Region";
    begin
        if pCodPais = '' then
            exit(false);
        rCountry.Get(pCodPais);
        exit(rCountry."Reg. fiscal preferente/paraiso");
    end;


    procedure RetencionVentas(prmFechaDesde: Date; prmFechaHasta: Date; prmCodCli: Code[20]; var prmRetIVA: Decimal; var prmRetRenta: Decimal)
    var
        RetVentas: Record "Histórico Retenciones Clientes";
    begin

        //+#34822
        prmRetIVA := 0;
        prmRetRenta := 0;

        RetVentas.Reset;
        RetVentas.SetCurrentKey("Fecha Registro", "Cód. Cliente");
        RetVentas.SetRange("Cód. Cliente", prmCodCli);
        RetVentas.SetRange("Fecha Registro", prmFechaDesde, prmFechaHasta);
        if RetVentas.FindSet then
            repeat
                case RetVentas."Tipo Retención" of
                    RetVentas."Tipo Retención"::Renta:
                        prmRetRenta += RetVentas."Importe Retenido";
                    RetVentas."Tipo Retención"::IVA:
                        prmRetIVA += RetVentas."Importe Retenido";
                end;
            until RetVentas.Next = 0;

        //-#34822
    end;


    procedure DesactConRefrendo()
    var
        SalesHeader: Record "Sales Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCMHeader: Record "Sales Cr.Memo Header";
    begin

        //#34853

        SalesHeader.SetRange(Exportación, true);
        if SalesHeader.FindSet then
            repeat
                if SalesHeader."Con Refrendo" then
                    SalesHeader."Tipo Exportacion" := SalesHeader."Tipo Exportacion"::"01"
                else
                    SalesHeader."Tipo Exportacion" := SalesHeader."Tipo Exportacion"::"02";
                SalesHeader."Con Refrendo" := false;
                SalesHeader.Modify;
            until SalesHeader.Next = 0;

        SalesInvHeader.SetRange(Exportación, true);
        if SalesInvHeader.FindSet then
            repeat
                if SalesInvHeader."Con Refrendo" then
                    SalesInvHeader."Tipo Exportacion" := SalesInvHeader."Tipo Exportacion"::"01"
                else
                    SalesInvHeader."Tipo Exportacion" := SalesInvHeader."Tipo Exportacion"::"02";
                SalesInvHeader."Con Refrendo" := false;
                SalesInvHeader.Modify;
            until SalesInvHeader.Next = 0;


        SalesCMHeader.SetRange(Exportación, true);
        if SalesCMHeader.FindSet then
            repeat
                if SalesCMHeader."Con Refrendo" then
                    SalesCMHeader."Tipo Exportacion" := SalesCMHeader."Tipo Exportacion"::"01"
                else
                    SalesCMHeader."Tipo Exportacion" := SalesCMHeader."Tipo Exportacion"::"02";
                SalesCMHeader."Con Refrendo" := false;
                SalesCMHeader.Modify;
            until SalesCMHeader.Next = 0;
    end;


    procedure DocCompraBorrado(pTipo: Option Factura,"Nota Credito"; pNum: Code[20]): Boolean
    var
        PurchInvLine: Record "Purch. Inv. Line";
        PurchCrLine: Record "Purch. Cr. Memo Line";
    begin

        //+#37019
        case pTipo of
            pTipo::Factura:
                begin
                    PurchInvLine.SetRange("Document No.", pNum);
                    PurchInvLine.SetRange(Description, 'Documento Borrado');
                    exit(PurchInvLine.FindFirst);
                end;
            pTipo::"Nota Credito":
                begin
                    PurchCrLine.SetRange("Document No.", pNum);
                    PurchCrLine.SetRange(Description, 'Documento Borrado');
                    exit(PurchCrLine.FindFirst);
                end;
        end;
        //-#37019
    end;


    procedure TraerAutorizacionLiquidacion(NoDoc: Code[20]): Text
    var
        DocumentoFE: Record "Documento FE";
    begin
        if DocumentoFE.Get(NoDoc + '-L') then
            exit(DocumentoFE."No. autorizacion");
    end;
}

