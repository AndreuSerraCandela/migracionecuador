tableextension 50009 tableextension50009 extends "Sales Cr.Memo Header"
{
    fields
    {
        modify("Your Reference")
        {
            Caption = 'Customer PO No.';
        }
        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        modify("Gen. Bus. Posting Group")
        {
            Caption = 'Gen. Bus. Posting Group';
        }
        modify("Area")
        {
            Caption = 'Area';
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'VAT Bus. Posting Group';
        }
        modify("Cust. Ledger Entry No.")
        {
            Caption = 'Cust. Ledger Entry No.';
        }
        // modify("No. of E-Documents Sent")
        // {
        //     Caption = 'No. of E-Documents Sent';
        // }
        // modify("PAC Web Service Name")
        // {
        //     Caption = 'PAC Web Service Name';
        // }
        // modify("Fiscal Invoice Number PAC")
        // {
        //     Caption = 'Fiscal Invoice Number PAC';
        // }
        // modify("Date/Time First Req. Sent")
        // {
        //     Caption = 'Date/Time First Req. Sent';
        // }

        //Unsupported feature: Deletion (FieldCollection) on ""CFDI Cancellation Reason Code"(Field 27002)".


        //Unsupported feature: Deletion (FieldCollection) on ""Substitution Document No."(Field 27003)".


        //Unsupported feature: Deletion (FieldCollection) on ""CFDI Export Code"(Field 27004)".

        field(50010; "Tipo de Venta"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Invoice,Consignation,Sample,Donations';
            OptionMembers = Factura,Consignacion,Muestras,Donaciones;
        }
        field(50110; "No. Documento SIC"; Code[40])
        {
            DataClassification = ToBeClassified;
            Description = 'SIC-JERM';
        }
        field(55000; "Sell-to Phone"; Code[30])
        {
            Caption = 'Venta a Teléfono';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55001; "Ship-to Phone"; Code[30])
        {
            Caption = 'Ship-to Phone';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55002; "No. Correlativo Rem. a Anular"; Code[20])
        {
            Caption = 'Remision Correlative No. to Void';
            DataClassification = ToBeClassified;
        }
        field(55003; "No. Correlativo Rem. Anulado"; Code[20])
        {
            Caption = 'Remision Correlative No. Voided';
            DataClassification = ToBeClassified;
        }
        field(55004; "No. documento Rem. a Anular"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sales Shipment Header"."No." WHERE("Remision Anulada" = FILTER(false));
        }
        field(55005; "No. Correlativo Fact. a Anular"; Code[20])
        {
            Caption = 'Invoice Correlative No. to Void';
            DataClassification = ToBeClassified;
        }
        field(55006; "No. Factura a Anular"; Code[20])
        {
            Caption = 'Invoice No. To Void';
            DataClassification = ToBeClassified;
            TableRelation = "Sales Invoice Header"."No." WHERE("Factura Anulada" = FILTER(false));
        }
        field(55007; "Siguiente No. Remision"; Code[20])
        {
            Caption = 'Next remission No.';
            DataClassification = ToBeClassified;
        }
        field(55008; "No. Nota Credito a Anular"; Code[20])
        {
            Caption = 'Credit Memo to Void';
            DataClassification = ToBeClassified;
            TableRelation = "Sales Cr.Memo Header";
        }
        field(55009; "Correlativo NCR a Anular"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(55010; "No. Autorizacion Comprobante"; Code[49])
        {
            Caption = 'Authorization Voucher No.';
            DataClassification = ToBeClassified;
            Description = 'SRI';
        }
        field(55011; "ID Retencion Venta"; Code[30])
        {
            Caption = 'Sales Retention ID';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55012; "Tipo de Comprobante"; Code[2])
        {
            Caption = 'Voucher Type';
            DataClassification = ToBeClassified;
            Description = 'SRI';
            TableRelation = "SRI - Tabla Parametros".Code WHERE("Tipo Registro" = FILTER("TIPOS COMPROBANTES AUTORIZADOS"));

            trigger OnValidate()
            begin
                Clear("No. Comprobante Fiscal");//001
            end;
        }
        field(55013; "Establecimiento Factura"; Code[3])
        {
            Caption = 'Invoice Location';
            DataClassification = ToBeClassified;
            Description = 'SRI';
        }
        field(55014; "Punto de Emision Factura"; Code[3])
        {
            Caption = 'Invoice Issue Point';
            DataClassification = ToBeClassified;
            Description = 'SRI';
        }
        field(55015; "Establecimiento Remision"; Code[3])
        {
            Caption = 'Shipment Location';
            DataClassification = ToBeClassified;
            Description = 'SRI';
        }
        field(55016; "Punto de Emision Remision"; Code[3])
        {
            Caption = 'Shipment Issue Point';
            DataClassification = ToBeClassified;
            Description = 'SRI';
        }
        field(55017; "No. Autorizacion Remision"; Code[49])
        {
            Caption = 'Remission Auth. No.';
            DataClassification = ToBeClassified;
            Description = 'SRI';
        }
        field(55018; "Tipo Comprobante Remision"; Code[2])
        {
            Caption = 'Remission Voucher Type';
            DataClassification = ToBeClassified;
            Description = 'SRI';
            TableRelation = "SRI - Tabla Parametros".Code WHERE("Tipo Registro" = FILTER("TIPOS COMPROBANTES AUTORIZADOS"));
        }
        field(55021; "No. Telefono"; Code[13])
        {
            Caption = 'Phone';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55022; "Tipo Ruc/Cedula"; Option)
        {
            Caption = 'RUC/ID Type';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
            OptionCaption = ' ,R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA,R.U.C. PUBLICOS,RUC PERSONA NATURAL,ID';
            OptionMembers = " ","R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA","R.U.C. PUBLICOS","RUC PERSONA NATURAL",CEDULA;

            trigger OnValidate()
            begin
                Clear("VAT Registration No.");//016
            end;
        }
        field(55023; "No. Validar Comprobante Rel."; Boolean)
        {
            Caption = 'Not validate Rel. Fiscal Document ';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55024; "Nombre Vendedor"; Text[50])
        {
            CalcFormula = Lookup("Salesperson/Purchaser".Name WHERE(Code = FIELD("Salesperson Code")));
            Caption = 'Salesperson Name';
            Description = 'Ecuador';
            FieldClass = FlowField;
        }
        field(55025; "Fecha Caducidad Comprobante"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55026; "Con Refrendo"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ATS';
        }
        field(55027; "Valor FOB"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ATS';
        }
        field(55028; "Nº Documento Transporte"; Text[17])
        {
            DataClassification = ToBeClassified;
            Description = 'ATS';
        }
        field(55029; "Fecha embarque"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(55030; "Cliente Existente"; Boolean)
        {
            CalcFormula = Exist(Customer WHERE("VAT Registration No." = FIELD("VAT Registration No.")));
            Description = 'Ecuador. Campo para utilziarlo en la generacion del reporte ATS';
            FieldClass = FlowField;
        }
        field(55034; "Exportación"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(55035; "No. refrendo - distrito adua."; Code[3])
        {
            DataClassification = ToBeClassified;
            Description = '#45090';
        }
        field(55036; "No. refrendo - Año"; Code[4])
        {
            DataClassification = ToBeClassified;
        }
        field(55037; "No. refrendo - regimen"; Code[2])
        {
            DataClassification = ToBeClassified;
        }
        field(55038; "No. refrendo - Correlativo"; Code[8])
        {
            DataClassification = ToBeClassified;
        }
        field(55039; "Valor FOB Comprobante Local"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(55040; "Establecimiento Fact. Rel"; Code[3])
        {
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55041; "Punto de Emision Fact. Rel."; Code[3])
        {
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55042; "Tipo Exportacion"; Option)
        {
            DataClassification = ToBeClassified;
            Description = '#34853';
            OptionCaption = ' ,01,02,03';
            OptionMembers = " ","01","02","03";
        }
        field(55047; "Tipo Documento"; Option)
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
            Description = 'SRI-SANTINAV-1392';
            OptionCaption = 'VAT,ID,Passport';
            OptionMembers = RUC,Cedula,Pasaporte;
        }
        field(55060; "Facturacion electronica"; Boolean)
        {
            CalcFormula = Lookup("No. Series"."Facturacion electronica" WHERE(Code = FIELD("No. Serie NCF Abonos")));
            Caption = 'Facturación electrónica';
            FieldClass = FlowField;
        }
        field(55061; "Estado envio FE"; Option)
        {
            CalcFormula = Lookup("Documento FE"."Estado envio" WHERE("No. documento" = FIELD("No.")));
            Caption = 'Estado envío FE';
            Description = 'CompElec';
            FieldClass = FlowField;
            OptionCaption = 'Pendiente,Enviado,Rechazado';
            OptionMembers = Pendiente,Enviado,Rechazado;
        }
        field(55062; "Estado autorizacion FE"; Option)
        {
            CalcFormula = Lookup("Documento FE"."Estado envio" WHERE("No. documento" = FIELD("No.")));
            Description = 'CompElec';
            FieldClass = FlowField;
            OptionCaption = 'Pendiente,Autorizado,No autorizado';
            OptionMembers = Pendiente,Autorizado,"No autorizado";
        }
        field(56000; "Pedido Consignacion"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(56001; "Collector Code"; Code[10])
        {
            Caption = 'Collector code';
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Tipo WHERE(Tipo = FILTER(Cobrador));
        }
        field(56002; "Pre pedido"; Boolean)
        {
            Caption = 'Pre Order';
            DataClassification = ToBeClassified;
        }
        field(56003; "Devolucion Consignacion"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(56006; "Cod. Colegio"; Code[20])
        {
            Caption = 'School Code';
            DataClassification = ToBeClassified;
            TableRelation = Contact WHERE(Type = FILTER(Company));
        }
        field(56007; "Nombre Colegio"; Text[100])
        {
            Caption = 'School Name';
            DataClassification = ToBeClassified;
            Description = '001: Se amplía longitud de 60 a 100';
        }
        field(56008; "Re facturacion"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(56010; CAE; Text[160])
        {
            DataClassification = ToBeClassified;
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56011; "Respuesta CAE"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56012; pIdSat; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56013; "No. Resolucion"; Code[30])
        {
            Caption = 'Resolution No.';
            DataClassification = ToBeClassified;
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56014; "Fecha Resolucion"; Date)
        {
            Caption = 'Resolution Date';
            DataClassification = ToBeClassified;
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56015; "Serie Desde"; Code[20])
        {
            Caption = 'Series From';
            DataClassification = ToBeClassified;
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56016; "Serie hasta"; Code[20])
        {
            Caption = 'Serie To';
            DataClassification = ToBeClassified;
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56017; "Serie Resolucion"; Code[20])
        {
            Caption = 'Resolution Serie';
            DataClassification = ToBeClassified;
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56018; CAEC; Text[160])
        {
            DataClassification = ToBeClassified;
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56019; "Folio Anulado en Ifacere"; Boolean)
        {
            Caption = 'Folio voided at Ifacere';
            DataClassification = ToBeClassified;
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56020; "No aplica Derechos de Autor"; Boolean)
        {
            Caption = 'Apply Author Copyright';
            DataClassification = ToBeClassified;
        }
        field(56021; Promocion; Boolean)
        {
            Caption = 'Promotion';
            DataClassification = ToBeClassified;
        }
        field(56024; "Hora Creacion Imp. Fiscal"; Time)
        {
            Caption = 'Fiscal Printer Creation Time';
            DataClassification = ToBeClassified;
            Description = 'Santillana Panama';
            Enabled = false;
        }
        field(56032; "Fecha Recepcion"; Date)
        {
            Caption = 'Reception Date';
            DataClassification = ToBeClassified;
        }
        field(56033; "Siguiente No. Nota. Cr."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(56042; "Creado por usuario"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = User;
        }
        field(56062; "Cantidad de Bultos"; Integer)
        {
            Caption = 'Packages Qty.';
            DataClassification = ToBeClassified;
        }
        field(56070; "No. Envio de Almacen"; Code[20])
        {
            Caption = 'Warehouse Shipment No.';
            DataClassification = ToBeClassified;
            TableRelation = "Warehouse Shipment Header";
        }
        field(56071; "No. Picking"; Code[20])
        {
            Caption = 'Pciking No.';
            DataClassification = ToBeClassified;
            TableRelation = "Warehouse Activity Header";
        }
        field(56072; "No. Picking Reg."; Code[20])
        {
            Caption = 'Posted Picking No.';
            DataClassification = ToBeClassified;
            TableRelation = "Registered Whse. Activity Hdr."."No.";
        }
        field(56073; "No. Packing"; Code[20])
        {
            Caption = 'Packing No.';
            DataClassification = ToBeClassified;
            TableRelation = "Cab. Packing";
        }
        field(56074; "No. Packing Reg."; Code[20])
        {
            Caption = 'Posted Packing No.';
            DataClassification = ToBeClassified;
            TableRelation = "Cab. Packing Registrado"."No.";
        }
        field(56075; "No. Factura"; Code[20])
        {
            Caption = 'Invoice No.';
            DataClassification = ToBeClassified;
            TableRelation = "Sales Invoice Header";
        }
        field(56076; "No. Envio"; Code[20])
        {
            Caption = 'Shippment No.';
            DataClassification = ToBeClassified;
            TableRelation = "Sales Shipment Header"."No.";
        }
        field(56078; "Fecha Lanzado"; Date)
        {
            Caption = 'Released Date';
            DataClassification = ToBeClassified;
        }
        field(56079; "Hora Lanzado"; Time)
        {
            Caption = 'Released Time';
            DataClassification = ToBeClassified;
        }
        field(56098; "En Hoja de Ruta"; Boolean)
        {
            Caption = 'In Route Sheet';
            DataClassification = ToBeClassified;
        }
        field(76046; "ID Cajero"; Code[20])
        {
            Caption = 'Cashier ID';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
            TableRelation = Cajeros.ID WHERE(Tienda = FIELD(Tienda));
        }
        field(76029; "Hora creacion"; Time)
        {
            Caption = 'Creation time';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76011; "Venta TPV"; Boolean)
        {
            Caption = 'POS Sales';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76016; TPV; Code[20])
        {
            Caption = 'POS';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
            TableRelation = "Configuracion TPV"."Id TPV" WHERE(Tienda = FIELD(Tienda));
        }
        field(76018; Tienda; Code[20])
        {
            Caption = 'Shop';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
            TableRelation = Tiendas."Cod. Tienda";
        }
        field(76017; "No. Fiscal TPV"; Code[40])
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76021; Turno; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76295; "Anula a Documento"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76227; Devolucion; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76313; "No.  Telefono"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
            Enabled = false;
        }
        field(76315; "E-Mail"; Text[80])
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76009; "Liquidado TPV"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76041; "No. Serie NCF Abonos2"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(76079; "No. Comprobante Fiscal"; Code[19])
        {
            Caption = 'Fiscal Document No.';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
        }
        field(76080; "No. Comprobante Fiscal Rel."; Code[19])
        {
            Caption = 'Related NCF Document';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
        }
        field(76056; "Razon anulacion NCF"; Code[20])
        {
            Caption = 'NCF Void Reason';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
        }
        field(76057; "No. Serie NCF Abonos"; Code[20])
        {
            Caption = 'Credit Memo NCF No. Series';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
            TableRelation = "No. Series";
        }
        field(76058; "Ultimo. No. NCF"; Code[19])
        {
            DataClassification = ToBeClassified;
        }
        field(76007; "Tipo de ingreso"; Code[2])
        {
            Caption = 'Income type';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
            TableRelation = "Tipos de ingresos";
        }
        field(76003; "Fecha vencimiento NCF"; Date)
        {
            Caption = 'NCF Due date';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
            TableRelation = "Tipos de ingresos";
        }
        field(76006; "No. Serie NCF Remision"; Code[10])
        {
            Caption = 'Remission Series No.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(76088; "No. Comprobante Fisc. Remision"; Code[20])
        {
            Caption = 'Remission NCF';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1; "No. Comprobante Fiscal")
        {
        }
        /*         key(Key2; "Applies-to Doc. Type", "Applies-to Doc. No.")
                {
                } */
        key(Key3; "No. Comprobante Fiscal Rel.")
        {
        }
        /*         key(Key4; "Posting Date", "VAT Registration No.")
                {
                } */
        key(Key5; "Venta TPV")
        {
        }
        /*         key(Key6; "Posting Date", Tienda, "Venta TPV")
                {
                }
                key(Key7; "Pre-Assigned No.", "No. Documento SIC")
                {
                } */
        key(Key8; "No. Documento SIC")
        {
        }
    }


    //Unsupported feature: Code Modification on "PrintRecords(PROCEDURE 1)".

    //procedure PrintRecords();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IsHandled := false;
    OnBeforePrintRecords(DummyReportSelections,Rec,ShowRequestPage,IsHandled);
    if IsHandled then
      exit;

    EInvoiceMgt.EDocPrintValidation(0,"No.");
    DocumentSendingProfile.TrySendToPrinter(
      DummyReportSelections.Usage::"S.Cr.Memo",Rec,FieldNo("Bill-to Customer No."),ShowRequestPage);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..5
    //DSLoc1.01 *** Inicio ***
    ConfSantillana.Get;
    Localizacion.Get(ConfSantillana.Country);
    if Localizacion."Formato Doc. Vtas. por cliente" then
        begin
        GpoContableCte.Get(Rec."Customer Posting Group");
        GpoContableCte.TestField("Credit Memo Report ID");
        REPORT.RunModal(GpoContableCte."Credit Memo Report ID",ShowRequestPage,false,Rec);
        end
    else //DSLoc1.01 *** Fin ***
      begin
        EInvoiceMgt.EDocPrintValidation(0,"No.");
        DocumentSendingProfile.TrySendToPrinter(
          DummyReportSelections.Usage::"S.Cr.Memo",Rec,FieldNo("Bill-to Customer No."),ShowRequestPage);
      end;
    */
    //end;

    var
        ConfSantillana: Record "Config. Empresa";
        Localizacion: Record "Parametros Loc. x País";
        GpoContableCte: Record "Customer Posting Group";
}

