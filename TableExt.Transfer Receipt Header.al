tableextension 50116 tableextension50116 extends "Transfer Receipt Header"
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

        field(50000; Devolucion; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Importe Consignacion"; Decimal)
        {
            CalcFormula = Sum("Transfer Receipt Line"."Importe Consignacion" WHERE("Document No." = FIELD("No.")));
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
        field(55010; "No. Autorizacion Comprobante"; Code[37])
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
        field(56000; "Hora Finalizacion"; Time)
        {
            Caption = 'End Time';
            DataClassification = ToBeClassified;
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
        field(56004; "Fecha Vencimiento"; Date)
        {
            Caption = 'Due Date';
            DataClassification = ToBeClassified;
        }
        field(56005; "Siguiente No. NCF Rem."; Code[20])
        {
            CalcFormula = Lookup("No. Series Line"."Last No. Used" WHERE("Series Code" = FIELD("No. Serie Comprobante Fiscal"),
                                                                          Open = FILTER(true)));
            FieldClass = FlowField;
        }
        field(56008; "Cod. Terminos de Pago"; Code[20])
        {
            Caption = 'Payment Terms Code';
            DataClassification = ToBeClassified;
            TableRelation = "Payment Terms";
        }
        field(56009; "Cod. Contacto"; Code[20])
        {
            Caption = 'Contact Code';
            DataClassification = ToBeClassified;
            TableRelation = Contact;
        }
        field(56010; "Nombre Contacto"; Text[200])
        {
            Caption = 'Contact Name';
            DataClassification = ToBeClassified;
            Editable = false;
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

    end;
}

