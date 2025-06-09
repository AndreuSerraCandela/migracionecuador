tableextension 50112 tableextension50112 extends "Transfer Header"
{
    fields
    {
        modify("No.")
        {
            trigger OnAfterValidate()

            begin
                // Modificación señalada
                //#27882:Inicio
                "Hora ingreso" := Time;
                //#27882:Fin
            end;
        }
        modify("Transfer-from Code")
        {
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false),
                                            Inactivo = CONST(false));
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                //005
                IF NOT "Pedido Consignacion" THEN BEGIN
                    rConfSantillana.GET;
                    IF rConfSantillana."Controla Transf. Alm. Consig." THEN
                        IF Cliente.GET("Transfer-from Code") THEN
                            ERROR(Error002);
                END;
                //005

                //011
                ValidaCampos.Maestros(14, "Transfer-from Code");
                ValidaCampos.Dimensiones(14, "Transfer-from Code", 0, 0);
                //011

                //001+
                IF "Devolucion Consignacion" THEN BEGIN
                    IF Cliente.GET("Transfer-from Code") THEN BEGIN
                        Cliente.CALCFIELDS(Balance);
                        Cliente.CALCFIELDS("Balance en Consignacion");
                        "Limite de credito cliente" := Cliente."Credit Limit (LCY)";
                        "Saldo Cliente" := Cliente.Balance + Cliente."Balance en Consignacion";
                        VALIDATE("Cod. Vendedor", Cliente."Salesperson Code");
                    END;
                END;
                //001-
            end;
        }
        modify("Transfer-to Code")
        {
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false),
                                            Inactivo = CONST(false));
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                //005
                IF NOT "Pedido Consignacion" THEN BEGIN
                    rConfSantillana.GET;
                    IF rConfSantillana."Controla Transf. Alm. Consig." THEN
                        IF Cliente.GET("Transfer-to Code") THEN
                            ERROR(Error002);

                    //006
                    IF Cliente.GET("Transfer-to Code") THEN
                        IF Cliente.Blocked <> Cliente.Blocked::" " THEN
                            ERROR(Error003, Cliente.Blocked);
                    //006
                END;
                //005

                //011
                ValidaCampos.Maestros(14, "Transfer-to Code");
                ValidaCampos.Dimensiones(14, "Transfer-to Code", 0, 0);
                //011

            end;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        modify("In-Transit Code")
        {
            TableRelation = Location WHERE("Use As In-Transit" = CONST(true),
                                            Inactivo = CONST(false));
            Description = '#34448';
        }
        modify("Area")
        {
            Caption = 'Area';
        }
        modify("Location Filter")
        {
            TableRelation = Location WHERE(Inactivo = CONST(false));
            Description = '#34448';
        }



        modify("Posting Date")
        {
            trigger OnAfterValidate()
            begin
                // Modificación señalada
                //#27882:Inicio
                "Hora registro" := Time;
                //#27882:Fin
            end;
        }


        modify("Shipment Date")
        {
            trigger OnAfterValidate()
            var
                Texto003: Label 'The receipt date must be greater or equal to the shipment date.';
            begin
                // Modificación señalada
                //#27882:Inicio
                IF ("Shipment Date" <> 0D) AND ("Receipt Date" <> 0D) AND ("Shipment Date" > "Receipt Date") THEN
                    ERROR(Texto003);
                //#27882:Fin
            end;
        }


        modify("Receipt Date")
        {
            trigger OnAfterValidate()

            var
                Texto003: Label 'The receipt date must be greater or equal to the shipment date.';
            begin
                IF ("Shipment Date" <> 0D) AND ("Receipt Date" <> 0D) AND ("Shipment Date" > "Receipt Date") THEN
                    ERROR(Texto003);

            end;
        }


        field(50000; Devolucion; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Importe Consignacion"; Decimal)
        {
            CalcFormula = Sum("Transfer Line"."Importe Consignacion" WHERE("Document No." = FIELD("No."),
                                                                            "Derived From Line No." = CONST(0)));
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
        field(55000; Despachado; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '#14637';
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

            trigger OnValidate()
            begin
                //007
                if PayTerms.Get("Cod. Terminos de Pago") then
                    "Fecha Vencimiento" := CalcDate(PayTerms."Due Date Calculation", "Posting Date");
                //007
            end;
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
        field(56012; "Cod. Direccion Envio"; Code[20])
        {
            Caption = 'Shipping Address Code';
            DataClassification = ToBeClassified;
            Description = 'Peru';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Transfer-to Code"));

            trigger OnValidate()
            begin
                //008
                if ShipToAddr.Get("Transfer-to Code", "Cod. Direccion Envio") then begin
                    Validate("Transfer-to Address", ShipToAddr.Address);
                    Validate("Transfer-to Post Code", ShipToAddr."Post Code");
                    Validate("Transfer-to City", ShipToAddr.City);
                    Validate("Transfer-to County", ShipToAddr.County);
                    Validate("Trsf.-to Country/Region Code", ShipToAddr."Country/Region Code");
                end;
                //008
            end;
        }
        field(56013; "Cod. Ubicacion Alm. Origen"; Code[20])
        {
            Caption = 'Bin code From Location';
            DataClassification = ToBeClassified;
            Description = 'APS';
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Transfer-from Code"));

            trigger OnValidate()
            begin
                if Bins.Get("Transfer-from Code", "Cod. Ubicacion Alm. Origen") then
                    "Desc. Ubic. Alm. Origen" := Bins.Description;
            end;
        }
        field(56014; "Cod. Ubicacion Alm. Destino"; Code[20])
        {
            Caption = 'Bin code To Location';
            DataClassification = ToBeClassified;
            Description = 'APS';
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Transfer-to Code"));

            trigger OnValidate()
            begin
                if Bins.Get("Transfer-to Code", "Cod. Ubicacion Alm. Destino") then
                    "Desc. Ubic. Alm. Destino" := Bins.Description;
            end;
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
        field(56018; "Pre pedido"; Boolean)
        {
            Caption = 'Pre Order';
            DataClassification = ToBeClassified;
        }
        field(56025; Correccion; Boolean)
        {
            Caption = 'Correction';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //009
                "No. Correlativo a Anular" := '';
                //009
            end;
        }
        field(56026; "No. Correlativo a Anular"; Code[20])
        {
            Caption = 'Correlative to Void';
            DataClassification = ToBeClassified;

            trigger OnLookup()
            begin
                //009
                TestField(Correccion);
                Clear(EnvTransf);
                TSH.Reset;
                TSH.SetRange("NCF Anulado", false);
                EnvTransf.SetRecord(TSH);
                EnvTransf.SetTableView(TSH);
                EnvTransf.LookupMode(true);
                if EnvTransf.RunModal = ACTION::LookupOK then begin
                    EnvTransf.GetRecord(TSH);
                    "No. Correlativo a Anular" := TSH."No. Comprobante Fiscal";
                    "No. Trans. Enviada a Anular" := TSH."No.";
                end;
                //009
            end;
        }
        field(56027; "No. Trans. Enviada a Anular"; Code[20])
        {
            Caption = 'Transfer Shippment Voided';
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
        field(56077; "% de aprobacion"; Decimal)
        {
            Caption = 'Approval %';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 2;

            trigger OnValidate()
            var
                TransferLineCant: Record "Transfer Line";
                CounterTotal: Integer;
                Counter: Integer;
                Window: Dialog;
                Text001: Label 'Updating  #1########## @2@@@@@@@@@@@@@';
            begin
                TransferLineCant.Reset;
                TransferLineCant.SetRange("Document No.", "No.");
                TransferLineCant.FindSet(true);
                CounterTotal := Count;
                Window.Open(Text001);
                repeat
                    Counter := Counter + 1;
                    Window.Update(1, TransferLineCant."Line No.");
                    Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
                    TransferLineCant.Validate("Porcentaje Cant. Aprobada", "% de aprobacion");
                    TransferLineCant.Modify;
                until TransferLineCant.Next = 0;

                "% de aprobacion" := 0; //012+-

                //MOI - 09/12/2014 (#7419):Inicio 1
                // <#71176  JPT 29/06/2017>  // Comentamos el código
                //IF xRec."% de aprobacion"<>"% de aprobacion" THEN
                //BEGIN
                //  "Fecha Aprobacion":=WORKDATE;
                //  "Hora Aprobacion":=TIME;
                //  "Usuario Aprobacion":=USERID;
                //END;
                // </#71176  JPT 29/06/2017>

                //MOI - 09/12/2014 (#7419):Fin 1
            end;
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
        field(56080; "Fecha Aprobacion"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(56081; "Hora Aprobacion"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(56082; "Usuario Aprobacion"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(56102; "Fecha Creacion Pedido"; DateTime)
        {
            AutoFormatExpression = '<Day,2>/<Month,2>/<Year4>  <Hours24,2>:<Minutes,2>';
            AutoFormatType = 0;
            DataClassification = ToBeClassified;
            Description = '#71176';
            Editable = false;
        }
        field(76012; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = ToBeClassified;
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
    trigger OnInsert()
    begin


        //#27882:Inicio
        "Hora ingreso" := Time;
        //#27882:Fin

        // <#71176  JPT 29/06/2017>
        if "Fecha Creacion Pedido" = 0DT then
            "Fecha Creacion Pedido" := RoundDateTime(CreateDateTime(WORKDATE, TIME), 1000000);
        // </#71176  JPT 29/06/2017>
    end;

    procedure ControlClasificacionDevolucion()
    var
        recDocClas: Record "Docs. clas. devoluciones";
    begin
        //$013
        recDocClas.Reset;
        recDocClas.SetRange("Tipo documento", recDocClas."Tipo documento"::Transferencia);
        recDocClas.SetRange("No. documento", "No.");
        if recDocClas.FindFirst then
            Error(Text56000, "No.");
    end;

    procedure FormatDT(pwDT: DateTime) wText: Text
    begin

        wText := Format(pwDT, 0, '<Day,2>/<Month,2>/<Year4>  <Hours24,2>:<Minutes,2>');
    end;

    //Unsupported feature: Deletion (VariableCollection) on "DeleteOneTransferOrder(PROCEDURE 4).EInvoiceMgt(Variable 1310000)".



    var
        Texto003: Label 'The receipt date must be greater or equal to the shipment date.';

    var
        SalesHeader: Record "Sales Header";
        Cliente: Record Customer;
        Almacen: Record Location;
        "**005**": Integer;
        rConfSantillana: Record "Config. Empresa";
        PayTerms: Record "Payment Terms";
        ShipToAddr: Record "Ship-to Address";
        Bins: Record Bin;
        "**008**": Integer;
        EnvTransf: Page "Posted Transfer Shipments";
        TSH: Record "Transfer Shipment Header";
        ValidaCampos: Codeunit "Valida Campos Requeridos";
        Error001: Label 'There''s a sales order type Consignation for Customer %1. You must finish the sales order before continue.';
        Error002: Label 'Cannot make standard transfer from Consig. Location';
        Error003: Label 'Cliente Bloqueado %1';
        Text56000: Label 'El documento %1 se generó automáticamente por clasificación de devoluciones. No es posible su modificación manual.';
}

