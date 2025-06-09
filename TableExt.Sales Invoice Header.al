tableextension 50007 tableextension50007 extends "Sales Invoice Header"
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
        modify("Direct Debit Mandate ID")
        {
            Caption = 'Direct Debit Mandate ID';
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
            Caption = 'Tipo de Venta';
            DataClassification = ToBeClassified;
            OptionCaption = 'Invoice,Consignation,Sample,Donations';
            OptionMembers = Factura,Consignacion,Muestras,Donaciones;
        }
        field(50110; "No. Documento SIC"; Code[40])
        {
            DataClassification = ToBeClassified;
            Description = 'SIC-JERM';
        }
        field(50115; "Error Factura"; Text[250])
        {
            Caption = 'Error Factura';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(55000; "Sell-to Phone"; Code[30])
        {
            Caption = 'Sell-to Address';
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
            Description = 'Ecuador';
        }
        field(55003; "No. Correlativo Rem. Anulado"; Code[20])
        {
            Caption = 'Remision Correlative No. Voided';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55004; "No. documento Rem. a Anular"; Code[20])
        {
            Caption = 'No. documento Rem. a Anular';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
            TableRelation = "Sales Shipment Header"."No." WHERE("Remision Anulada" = FILTER(false));
        }
        field(55005; "No. Correlativo Fact. a Anular"; Code[20])
        {
            Caption = 'Invoice Correlative No. to Void';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55006; "No. Factura a Anular"; Code[20])
        {
            Caption = 'Invoice No. To Void';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
            TableRelation = "Sales Invoice Header"."No." WHERE("Factura Anulada" = FILTER(false));
        }
        field(55007; "Siguiente No. Remision"; Code[20])
        {
            Caption = 'Next remission No.';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55008; "No. Nota Credito a Anular"; Code[20])
        {
            Caption = 'Credit Memo to Void';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
            TableRelation = "Sales Cr.Memo Header";
        }
        field(55009; "Correlativo NCR a Anular"; Code[30])
        {
            Caption = 'Correlativo NCR a Anular';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
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
        field(55019; "ID Retencion Venta"; Code[30])
        {
            Caption = 'Sales Retention ID';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55020; "Importe Retencion Venta"; Decimal)
        {
            Caption = 'Sales Retention Amount';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
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
            Caption = 'Fecha Caducidad Comprobante';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55026; "Con Refrendo"; Boolean)
        {
            Caption = 'Con Refrendo';
            DataClassification = ToBeClassified;
            Description = 'ATS';
        }
        field(55027; "Valor FOB"; Decimal)
        {
            Caption = 'Valor FOB';
            DataClassification = ToBeClassified;
            Description = 'ATS';
        }
        field(55028; "Nº Documento Transporte"; Text[17])
        {
            Caption = 'Nº Documento Transporte';
            DataClassification = ToBeClassified;
            Description = 'ATS';
        }
        field(55029; "Fecha embarque"; Date)
        {
            Caption = 'Fecha embarque';
            DataClassification = ToBeClassified;
        }
        field(55030; "Cliente Existente"; Boolean)
        {
            CalcFormula = Exist(Customer WHERE("VAT Registration No." = FIELD("VAT Registration No.")));
            Caption = 'Cliente Existente';
            Description = 'Ecuador. Campo para utilziarlo en la generacion del reporte ATS';
            FieldClass = FlowField;
        }
        field(55031; "Order Time"; Time)
        {
            Caption = 'Order Time';
            DataClassification = ToBeClassified;
            Description = '#13586';
        }
        field(55032; "Posting Time"; Time)
        {
            Caption = 'Posting Time';
            DataClassification = ToBeClassified;
            Description = '#13586';
        }
        field(55033; "Shipment Time"; Time)
        {
            Caption = 'Shipment Time';
            DataClassification = ToBeClassified;
            Description = '#13586';
        }
        field(55034; "Exportación"; Boolean)
        {
            Caption = 'Exportación';
            DataClassification = ToBeClassified;
        }
        field(55035; "No. refrendo - distrito adua."; Code[3])
        {
            Caption = 'No. refrendo - distrito adua.';
            DataClassification = ToBeClassified;
            Description = '#45090';
        }
        field(55036; "No. refrendo - Año"; Code[4])
        {
            Caption = 'No. refrendo - Año';
            DataClassification = ToBeClassified;
        }
        field(55037; "No. refrendo - regimen"; Code[2])
        {
            Caption = 'No. refrendo - regimen';
            DataClassification = ToBeClassified;
        }
        field(55038; "No. refrendo - Correlativo"; Code[8])
        {
            Caption = 'No. refrendo - Correlativo';
            DataClassification = ToBeClassified;
        }
        field(55039; "Valor FOB Comprobante Local"; Decimal)
        {
            Caption = 'Valor FOB Comprobante Local';
            DataClassification = ToBeClassified;
        }
        field(55040; "Forma de Pago TPV"; Code[20])
        {
            Caption = 'Forma de Pago TPV';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55042; "Tipo Exportacion"; Option)
        {
            Caption = 'Tipo Exportacion';
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
        field(55048; "Numero Guia"; Code[20])
        {
            Caption = 'Número de Guía';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-1401';
        }
        field(55049; "Nombre Guia"; Code[20])
        {
            Caption = 'Nombre de Guía';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-1401';
        }
        field(55051; "Factura Anulada"; Boolean)
        {
            Caption = 'Voided Invoice';
            DataClassification = ToBeClassified;
        }
        field(55060; "Facturacion electronica"; Boolean)
        {
            CalcFormula = Lookup("No. Series"."Facturacion electronica" WHERE(Code = FIELD("No. Serie NCF Facturas")));
            Caption = 'Facturación electrónica';
            Description = 'CompElec';
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
            Caption = 'Estado autorizacion FE';
            Description = 'CompElec';
            FieldClass = FlowField;
            OptionCaption = 'Pendiente,Autorizado,No autorizado';
            OptionMembers = Pendiente,Autorizado,"No autorizado";
        }
        field(55090; "RNC Corregido"; Code[30])
        {
            Caption = 'RNC Corregido';
            DataClassification = ToBeClassified;
            Description = 'Temporal para corregir RNC''s cargados erroneamente';
        }
        field(56000; "Pedido Consignacion"; Boolean)
        {
            Caption = 'Pedido Consignacion';
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
            Caption = 'Devolucion Consignacion';
            DataClassification = ToBeClassified;
        }
        field(56004; "Cod. Cupon"; Code[10])
        {
            Caption = 'Coupon Code';
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
            Description = '002-SIC-JERM: Se amplía longitud de 60 a 100';
        }
        field(56008; Refacturar; Boolean)
        {
            Caption = 'Refacturar';
            DataClassification = ToBeClassified;
        }
        field(56010; CAE; Text[160])
        {
            Caption = 'CAE';
            DataClassification = ToBeClassified;
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56011; "Respuesta CAE/CAEC"; Text[100])
        {
            Caption = 'Respuesta CAE/CAEC';
            DataClassification = ToBeClassified;
            Description = 'FEG_1.0';
            Enabled = false;
        }
        field(56012; pIdSat; Text[50])
        {
            Caption = 'pIdSat';
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
            Caption = 'CAEC';
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
            Description = 'DerAut 1.0';
        }
        field(56021; Promocion; Boolean)
        {
            Caption = 'Promotion';
            DataClassification = ToBeClassified;
        }
        field(56022; "Fecha entrega requerida"; Date)
        {
            Caption = 'Requested Delivery Date';
            DataClassification = ToBeClassified;
        }
        field(56023; "Fecha Recepcion Documento"; Date)
        {
            Caption = 'Reception Document Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //001
                if UserSetUp.Get(UserId) then begin
                    if not UserSetUp."Mod. Fecha Recep. Fact. Vta." then
                        Error(Error001, FieldCaption("Fecha Recepcion Documento"));
                end
                else
                    Error(Error001, FieldCaption("Fecha Recepcion Documento"));
                //001
            end;
        }
        field(56024; "Hora Creacion Imp. Fiscal"; Time)
        {
            Caption = 'Fiscal Printer Creation Time';
            DataClassification = ToBeClassified;
            Description = 'Santillana Panama';
        }
        field(56032; "Fecha Recepcion"; Date)
        {
            Caption = 'Reception Date';
            DataClassification = ToBeClassified;
        }
        field(56033; "Siguiente No. Nota. Cr."; Code[20])
        {
            Caption = 'Siguiente No. Nota. Cr.';
            DataClassification = ToBeClassified;
        }
        field(56042; "Creado por usuario"; Code[20])
        {
            Caption = 'Creado por usuario';
            DataClassification = ToBeClassified;
            TableRelation = User;
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
        field(56100; "Fecha Aprobacion"; Date)
        {
            Caption = 'Fecha Aprobacion';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(56101; "Hora Aprobacion"; Time)
        {
            Caption = 'Hora Aprobacion';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(56102; "Fecha Creacion Pedido"; DateTime)
        {
            Caption = 'Fecha Creacion Pedido';
            DataClassification = ToBeClassified;
            Description = '#71176';
            Editable = false;
        }
        field(56303; "Procesar EAN-Picking Masivo"; Boolean)
        {
            Caption = 'Procesar EAN-Picking Masivo';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-1410';
        }
        field(56304; "Estatus EAN-Picking Masivo"; Option)
        {
            Caption = 'Estatus EAN-Picking Masivo';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-2115';
            OptionCaption = ' ,Procesado';
            OptionMembers = " ",Procesado;
        }
        field(56305; "Grupo de Negocio"; Code[20])
        {
            Caption = 'Business Group';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-2524';
            TableRelation = "Datos auxiliares".Codigo;
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
        field(76015; "Venta a credito"; Boolean)
        {
            Caption = 'Credit Sales';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76027; "Registrado TPV"; Boolean)
        {
            Caption = 'TPV Registered';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76025; "Anulado TPV"; Boolean)
        {
            Caption = 'TPV Canceled';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76017; "No. Fiscal TPV"; Code[38])
        {
            Caption = 'TPV Fiscal No.';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76021; Turno; Integer)
        {
            Caption = 'Turn';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76030; "Anulado por Documento"; Code[20])
        {
            Caption = 'Canceled by document';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76313; "No. Telefono (POS)"; Text[30])
        {
            Caption = 'Phone No.';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76315; "E-Mail"; Text[49])
        {
            Caption = 'Email';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76009; "Liquidado TPV"; Boolean)
        {
            Caption = 'TPV Liquidated';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76041; "No. Serie NCF Facturas"; Code[20])
        {
            Caption = 'Invoice NCF Series No.';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
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
            Caption = 'Related Fiscal Document No.';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
        }
        field(76056; "Razon anulacion NCF"; Code[20])
        {
            Caption = 'NCF Void Reason';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
        }
        field(76058; "Ultimo. No. NCF"; Code[19])
        {
            Caption = 'NCF Last No.';
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
        field(76088; "No. Comprobante Fisc. Remision"; Code[20])
        {
            Caption = 'Remission NCF';
            DataClassification = ToBeClassified;
            Description = 'tonimoll@dynasoftsolutions.es';
        }
    }
    keys
    {
        // Duplicate key definition removed
        key(Key30; "Posting Date", "VAT Registration No.")
        {
        }
        key(Key40; "Venta TPV")
        {
        }
        key(Key12; "No. Documento SIC")
        {
        }
        key(Key13; Tienda)
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
    if not IsHandled then begin
      EInvoiceMgt.EDocPrintValidation(0,"No.");
      DocumentSendingProfile.TrySendToPrinter(
        DummyReportSelections.Usage::"S.Invoice",Rec,FieldNo("Bill-to Customer No."),ShowRequestPage);
    end;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3

      //DSLoc1.01 *** Inicio ***
      ConfSantillana.Get();
      Localizacion.Get(ConfSantillana.Country);
      if Localizacion."Formato Doc. Vtas. por cliente" then
         begin
          GpoContableCte.Get(Rec."Customer Posting Group");
          GpoContableCte.TestField("Invoice Report ID");
          REPORT.RunModal(GpoContableCte."Invoice Report ID",ShowRequestPage,false,Rec);
         end
      else //DSLoc1.01 *** Fin ***
         begin
    #4..6
        end;
    end;
    */
    //end;

    //Unsupported feature: Property Modification (Fields) on "DropDown(FieldGroup 1)".

    var
        ConfSantillana: Record "Config. Empresa";
        Localizacion: Record "Parametros Loc. x País";
        GpoContableCte: Record "Customer Posting Group";
        UserSetUp: Record "User Setup";

    var
        Error001: Label 'User cannot modify %1';
}

