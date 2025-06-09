tableextension 50005 tableextension50005 extends "Sales Shipment Header"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Bill-to City"(Field 9)".

        modify("Your Reference")
        {
            Caption = 'Customer PO No.';
        }

        //Unsupported feature: Property Modification (Data type) on ""Ship-to City"(Field 17)".

        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'Shortcut Dimension 2 Code';
        }

        //Unsupported feature: Property Modification (Data type) on ""VAT Registration No."(Field 70)".

        modify("Gen. Bus. Posting Group")
        {
            Caption = 'Gen. Bus. Posting Group';
        }

        //Unsupported feature: Property Modification (Data type) on ""Sell-to City"(Field 83)".

        modify("Area")
        {
            Caption = 'Area';
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'VAT Bus. Posting Group';
        }

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


        //Unsupported feature: Deletion (FieldCollection) on ""Transit-to Location"(Field 10055)".


        //Unsupported feature: Deletion (FieldCollection) on ""Medical Insurer Name"(Field 10056)".


        //Unsupported feature: Deletion (FieldCollection) on ""Medical Ins. Policy Number"(Field 10057)".


        //Unsupported feature: Deletion (FieldCollection) on ""SAT Weight Unit Of Measure"(Field 10058)".


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
        field(50111; "Source counter"; BigInteger)
        {
            DataClassification = ToBeClassified;
            Description = 'SIC-JERM';

            trigger OnValidate()
            var
                Item: Record Item;
                "Min": Duration;
                Hora: Time;
            begin
            end;
        }
        field(50112; "Cod. Cajero"; Code[50])
        {
            DataClassification = ToBeClassified;
            Description = 'SIC-JERM';
        }
        field(50113; "Cod. Supervisor"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'SIC-JERM';
        }
        field(50114; "Error Registro"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'SIC-JERM';
        }
        field(53008; Tienda; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bancos tienda";
        }
        field(53009; "Factura en Historico"; Boolean)
        {
            Caption = 'Invoice Posted';
            DataClassification = ToBeClassified;
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
            TableRelation = "Sales Shipment Header"."No." WHERE ("Remision Anulada" = FILTER (false));
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
            TableRelation = "Sales Invoice Header"."No." WHERE ("Factura Anulada" = FILTER (false));
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
        field(55012; "Tipo de Comprobante"; Code[10])
        {
            Caption = 'Voucher Type';
            DataClassification = ToBeClassified;
            Description = 'SRI';
            TableRelation = "SRI - Tabla Parametros".Code WHERE ("Tipo Registro" = FILTER ("TIPOS COMPROBANTES AUTORIZADOS"));
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
            TableRelation = "SRI - Tabla Parametros".Code WHERE ("Tipo Registro" = FILTER ("TIPOS COMPROBANTES AUTORIZADOS"));
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
            CalcFormula = Lookup ("Salesperson/Purchaser".Name WHERE (Code = FIELD ("Salesperson Code")));
            Caption = 'Salesperson Name';
            Description = 'Ecuador';
            FieldClass = FlowField;
        }
        field(55025; "Fecha Caducidad Comprobante"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55045; "Fecha inicio trans."; Date)
        {
            Caption = 'Fecha inicio transporte';
            DataClassification = ToBeClassified;
            Description = 'SRI';
        }
        field(55046; "Fecha fin trans."; Date)
        {
            Caption = 'Fecha fin transporte';
            DataClassification = ToBeClassified;
            Description = 'SRI';
        }
        field(55051; "Remision Anulada"; Boolean)
        {
            Caption = 'Remision Voided';
            DataClassification = ToBeClassified;
        }
        field(55060; "Facturacion electronica"; Boolean)
        {
            CalcFormula = Lookup ("No. Series"."Facturacion electronica" WHERE (Code = FIELD ("No. Serie NCF Remision")));
            Caption = 'Facturación electrónica';
            FieldClass = FlowField;
        }
        field(55061; "Estado envio FE"; Option)
        {
            CalcFormula = Lookup ("Documento FE"."Estado envio" WHERE ("No. documento" = FIELD ("No.")));
            Caption = 'Estado envío FE';
            Description = 'CompElec';
            FieldClass = FlowField;
            OptionCaption = 'Pendiente,Enviado,Rechazado';
            OptionMembers = Pendiente,Enviado,Rechazado;
        }
        field(55062; "Estado autorizacion FE"; Option)
        {
            CalcFormula = Lookup ("Documento FE"."Estado envio" WHERE ("No. documento" = FIELD ("No.")));
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
            TableRelation = "Salesperson/Purchaser".Tipo WHERE (Tipo = FILTER (Cobrador));
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
            TableRelation = Contact WHERE (Type = FILTER (Company));
        }
        field(56007; "Nombre Colegio"; Text[120])
        {
            Caption = 'School Name';
            DataClassification = ToBeClassified;
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
            CalcFormula = Exist ("Lin. Hoja de Ruta Reg." WHERE ("No. Conduce" = FIELD ("No.")));
            Caption = 'In Route Sheet';
            FieldClass = FlowField;
        }
        field(56100; "Fecha Aprobacion"; Date)
        {
            DataClassification = ToBeClassified;
            Description = '#71176';
            Editable = false;
        }
        field(56101; "Hora Aprobacion"; Time)
        {
            DataClassification = ToBeClassified;
            Description = '#71176';
            Editable = false;
        }
        field(56102; "Fecha Creacion Pedido"; DateTime)
        {
            DataClassification = ToBeClassified;
            Description = '#71176';
            Editable = false;
        }
        field(56305; "Grupo de Negocio"; Code[20])
        {
            Caption = 'Business Group';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-2524';
            TableRelation = "Datos auxiliares".Codigo;
        }
        field(76079; "No. Comprobante Fiscal Factura"; Code[19])
        {
            Caption = 'Fiscal Document No.';
            DataClassification = ToBeClassified;
        }
        field(76058; "Ultimo. No. NCF"; Code[19])
        {
            DataClassification = ToBeClassified;
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
        key(Key1; "No. Comprobante Fiscal Factura")
        {
        }
    }
}

