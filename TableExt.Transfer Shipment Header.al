tableextension 50114 tableextension50114 extends "Transfer Shipment Header"
{
    fields
    {
        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        modify("Area")
        {
            Caption = 'Area';
        }

        //Unsupported feature: Deletion (FieldCollection) on ""Partner VAT ID"(Field 49)".


        //Unsupported feature: Deletion (FieldCollection) on ""Original Document XML"(Field 10020)".


        //Unsupported feature: Deletion (FieldCollection) on ""Original String"(Field 10022)".


        //Unsupported feature: Deletion (FieldCollection) on ""Digital Stamp SAT"(Field 10023)".


        //Unsupported feature: Deletion (FieldCollection) on ""Certificate Serial No."(Field 10024)".


        //Unsupported feature: Deletion (FieldCollection) on ""Signed Document XML"(Field 10025)".


        //Unsupported feature: Deletion (FieldCollection) on ""Digital Stamp PAC"(Field 10026)".


        //Unsupported feature: Deletion (FieldCollection) on ""Electronic Document Status"(Field 10030)".


        //Unsupported feature: Deletion (FieldCollection) on ""Date/Time Stamped"(Field 10031)".


        //Unsupported feature: Deletion (FieldCollection) on ""Date/Time Canceled"(Field 10033)".


        //Unsupported feature: Deletion (FieldCollection) on ""Error Code"(Field 10035)".


        //Unsupported feature: Deletion (FieldCollection) on ""Error Description"(Field 10036)".


        //Unsupported feature: Deletion (FieldCollection) on ""PAC Web Service Name"(Field 10040)".


        //Unsupported feature: Deletion (FieldCollection) on ""QR Code"(Field 10041)".


        //Unsupported feature: Deletion (FieldCollection) on ""Fiscal Invoice Number PAC"(Field 10042)".


        //Unsupported feature: Deletion (FieldCollection) on ""Date/Time First Req. Sent"(Field 10043)".


        //Unsupported feature: Deletion (FieldCollection) on ""Transport Operators"(Field 10044)".


        //Unsupported feature: Deletion (FieldCollection) on ""Transit-from Date/Time"(Field 10045)".


        //Unsupported feature: Deletion (FieldCollection) on ""Transit Hours"(Field 10046)".


        //Unsupported feature: Deletion (FieldCollection) on ""Transit Distance"(Field 10047)".


        //Unsupported feature: Deletion (FieldCollection) on ""Insurer Name"(Field 10048)".


        //Unsupported feature: Deletion (FieldCollection) on ""Insurer Policy Number"(Field 10049)".


        //Unsupported feature: Deletion (FieldCollection) on ""Foreign Trade"(Field 10050)".


        //Unsupported feature: Deletion (FieldCollection) on ""Vehicle Code"(Field 10051)".


        //Unsupported feature: Deletion (FieldCollection) on ""Trailer 1"(Field 10052)".


        //Unsupported feature: Deletion (FieldCollection) on ""Trailer 2"(Field 10053)".


        //Unsupported feature: Deletion (FieldCollection) on ""Medical Insurer Name"(Field 10056)".


        //Unsupported feature: Deletion (FieldCollection) on ""Medical Ins. Policy Number"(Field 10057)".


        //Unsupported feature: Deletion (FieldCollection) on ""SAT Weight Unit Of Measure"(Field 10058)".


        //Unsupported feature: Deletion (FieldCollection) on ""CFDI Cancellation Reason Code"(Field 27002)".


        //Unsupported feature: Deletion (FieldCollection) on ""Substitution Document No."(Field 27003)".


        //Unsupported feature: Deletion (FieldCollection) on ""CFDI Export Code"(Field 27004)".

        field(50000; Devolucion; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Importe Consignacion"; Decimal)
        {
            CalcFormula = Sum("Transfer Shipment Line"."Importe Consignacion" WHERE("Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(50002; "Saldo Cliente"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Limite de credito cliente"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Prioridad entrega consignacion"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Low,Medium,High';
            OptionMembers = Baja,Media,Alta;
        }
        field(50005; "Importe Consignacion Orginal"; Decimal)
        {
            CalcFormula = Sum("Transfer Line"."Importe Consignacion Original" WHERE("Document No." = FIELD("No."),
                                                                   "Derived From Line No." = CONST(0)));
            FieldClass = FlowField;
        }
        field(50006; "Cod. Vendedor"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
        field(50007; "Estado distribucion"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Para Confirmar","Para empaque","Para despacho",Entregado;
        }
        field(50008; "No. Copias impresas"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "No. Copias imp. Recep."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(55008; "Hora ingreso"; Time)
        {
            DataClassification = ToBeClassified;
            Description = '#27882';
        }
        field(55009; "Hora registro"; Time)
        {
            DataClassification = ToBeClassified;
            Description = '#27882';
        }
        field(55010; "No. Autorizacion Comprobante"; Code[49])
        {
            Caption = 'Authorization Voucher No.';
            DataClassification = ToBeClassified;
            Description = 'SRI';
        }
        field(55012; "Tipo de Comprobante"; Code[2])
        {
            Caption = 'Voucher Type';
            DataClassification = ToBeClassified;
            Description = 'SRI';
            TableRelation = "SRI - Tabla Parametros".Code WHERE("Tipo Registro" = FILTER("TIPOS COMPROBANTES AUTORIZADOS"));
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
        field(55060; "Facturacion electronica"; Boolean)
        {
            CalcFormula = Lookup("No. Series"."Facturacion electronica" WHERE(Code = FIELD("No. Serie Comprobante Fiscal")));
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
        field(56001; "Pedido Consignacion"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(56002; "Devolucion Consignacion"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(56003; "No. Bultos"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(56005; "Siguiente No. NCF Rem."; Code[20])
        {
            CalcFormula = Lookup("No. Series Line"."Last No. Used" WHERE("Series Code" = FIELD("No. Serie Comprobante Fiscal"),
                                                                          Open = FILTER(true)));
            FieldClass = FlowField;
        }
        field(56013; "Cod. Ubicacion Alm. Origen"; Code[20])
        {
            Caption = 'Bin code From Location';
            DataClassification = ToBeClassified;
            Description = 'APS';
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Transfer-from Code"));
        }
        field(56014; "Cod. Ubicacion Alm. Destino"; Code[20])
        {
            Caption = 'Bin code To Location';
            DataClassification = ToBeClassified;
            Description = 'APS';
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Transfer-to Code"));
        }
        field(56015; "Desc. Ubic. Alm. Origen"; Text[60])
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
        }
        field(56016; "Desc. Ubic. Alm. Destino"; Text[60])
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
        }
        field(56017; "Consignacion Muestras"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
        }
        field(56025; Correccion; Boolean)
        {
            Caption = 'Correction';
            DataClassification = ToBeClassified;
        }
        field(56026; "No. Correlativo a Anular"; Code[20])
        {
            Caption = 'Correlative to Void';
            DataClassification = ToBeClassified;
        }
        field(56027; "No. Trans. Enviada a Anular"; Code[20])
        {
            Caption = 'Transfer Shippment Voided';
            DataClassification = ToBeClassified;
        }
        field(56028; "NCF Anulado"; Boolean)
        {
            Caption = 'NCF Voided';
            DataClassification = ToBeClassified;
        }
        field(56029; "No. NCF Anulado"; Code[30])
        {
            Caption = 'NCF Voided No.';
            DataClassification = ToBeClassified;
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
        field(76041; "No. Serie Comprobante Fiscal"; Code[10])
        {
            Caption = 'Invoice FDN Serial No.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(76079; "No. Comprobante Fiscal"; Code[19])
        {
            Caption = 'Fiscal Document No.';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key3; "Transfer Order No.")
        {
        }
        key(Key4; "No. Comprobante Fiscal")
        {
        }
    }




    local procedure CopyFromTransferHeader(TransHeader: Record "Transfer Header")
    begin
        "Transfer-from Code" := TransHeader."Transfer-from Code";
        "Transfer-from Name" := TransHeader."Transfer-from Name";
        "Transfer-from Name 2" := TransHeader."Transfer-from Name 2";
        "Transfer-from Address" := TransHeader."Transfer-from Address";
        "Transfer-from Address 2" := TransHeader."Transfer-from Address 2";
        "Transfer-from Post Code" := TransHeader."Transfer-from Post Code";
        "Transfer-from City" := TransHeader."Transfer-from City";
        "Transfer-from County" := TransHeader."Transfer-from County";
        "Trsf.-from Country/Region Code" := TransHeader."Trsf.-from Country/Region Code";
        "Transfer-from Contact" := TransHeader."Transfer-from Contact";
        "Transfer-to Code" := TransHeader."Transfer-to Code";
        "Transfer-to Name" := TransHeader."Transfer-to Name";
        "Transfer-to Name 2" := TransHeader."Transfer-to Name 2";
        "Transfer-to Address" := TransHeader."Transfer-to Address";
        "Transfer-to Address 2" := TransHeader."Transfer-to Address 2";
        "Transfer-to Post Code" := TransHeader."Transfer-to Post Code";
        "Transfer-to City" := TransHeader."Transfer-to City";
        "Transfer-to County" := TransHeader."Transfer-to County";
        "Trsf.-to Country/Region Code" := TransHeader."Trsf.-to Country/Region Code";
        "Transfer-to Contact" := TransHeader."Transfer-to Contact";
        "Transfer Order Date" := TransHeader."Posting Date";
        "Posting Date" := TransHeader."Posting Date";
        "Shipment Date" := TransHeader."Shipment Date";
        "Receipt Date" := TransHeader."Receipt Date";
        "Shortcut Dimension 1 Code" := TransHeader."Shortcut Dimension 1 Code";
        "Shortcut Dimension 2 Code" := TransHeader."Shortcut Dimension 2 Code";
        "Dimension Set ID" := TransHeader."Dimension Set ID";
        "Transfer Order No." := TransHeader."No.";
        "External Document No." := TransHeader."External Document No.";
        "In-Transit Code" := TransHeader."In-Transit Code";
        "Shipping Agent Code" := TransHeader."Shipping Agent Code";
        "Shipping Agent Service Code" := TransHeader."Shipping Agent Service Code";
        "Shipment Method Code" := TransHeader."Shipment Method Code";
        "Transaction Type" := TransHeader."Transaction Type";
        "Transport Method" := TransHeader."Transport Method";
        "Partner VAT ID" := TransHeader."Partner VAT ID";
        "Entry/Exit Point" := TransHeader."Entry/Exit Point";
        Area := TransHeader.Area;
        "Transaction Specification" := TransHeader."Transaction Specification";
        "Direct Transfer" := TransHeader."Direct Transfer";

        // "Transit-from Date/Time" := TransHeader."Transit-from Date/Time";
        // "Transit Hours" := TransHeader."Transit Hours";
        // "Transit Distance" := TransHeader."Transit Distance";
        // "Insurer Name" := TransHeader."Insurer Name";
        // "Insurer Policy Number" := TransHeader."Insurer Policy Number";
        // "Foreign Trade" := TransHeader."Foreign Trade";
        // "Vehicle Code" := TransHeader."Vehicle Code";
        // "Trailer 1" := TransHeader."Trailer 1";
        // "Trailer 2" := TransHeader."Trailer 2";
        // "Medical Insurer Name" := TransHeader."Medical Insurer Name";
        // "Medical Ins. Policy Number" := TransHeader."Medical Ins. Policy Number";
        // "SAT Weight Unit Of Measure" := TransHeader."SAT Weight Unit Of Measure";
        // "CFDI Export Code" := TransHeader."CFDI Export Code";

        // Modificación señalada
        "Cantidad de Bultos" := TransHeader."Cantidad de Bultos";


    end;
    //Unsupported feature: Property Modification (Fields) on "DropDown(FieldGroup 1)".

}

