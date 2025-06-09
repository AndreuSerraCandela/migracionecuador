tableextension 50069 tableextension50069 extends "Sales Line"
{
    fields
    {
        // modify("Document Type")
        // {
        //     //OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Pre Order';

        //     //Unsupported feature: Property Modification (OptionString) on ""Document Type"(Field 1)".

        // }
        modify("Sell-to Customer No.")
        {
            TableRelation = Customer WHERE(Inactivo = CONST(false));
            Description = '#34448';
        }
        modify("No.")
        {
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST("G/L Account"),
                                     "System-Created Entry" = CONST(false)) "G/L Account" WHERE("Direct Posting" = CONST(true),
                                                                                               "Account Type" = CONST(Posting),
                                                                                               Blocked = CONST(false))
            ELSE
            IF (Type = CONST("G/L Account"),
                                                                                                        "System-Created Entry" = CONST(true)) "G/L Account"
            ELSE
            IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset" WHERE(Inactive = CONST(false))
            ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge"
            ELSE
            IF (Type = CONST(Item),
                                                                                                                 "Document Type" = FILTER(<> "Credit Memo" & <> "Return Order")) Item WHERE(Blocked = CONST(false),
                                                                                                                                                                                       "Sales Blocked" = CONST(false),
                                                                                                                                                                                       Inactivo = CONST(false))
            ELSE
            IF (Type = CONST(Item),
                                                                                                                                                                                                "Document Type" = FILTER("Credit Memo" | "Return Order")) Item WHERE(Blocked = CONST(false),
                                                                                                                                                                                                                                                                  Inactivo = CONST(false));
            Description = '#34448, 018';
            trigger OnAfterValidate()
            var
                SalesLine2: Record "Sales Line";
                Salesheader: Record "Sales Header";
            begin
                // Validar campos maestros y dimensiones según el tipo
                if Type = Type::Item then begin
                    ValidaCampos.Maestros(27, "No.");
                    ValidaCampos.Dimensiones(15, "No.", 0, 0);
                end;

                if Type = Type::"G/L Account" then begin
                    ValidaCampos.Maestros(15, "No.");
                    ValidaCampos.Dimensiones(15, "No.", 0, 0);
                end;

                // Validar precios para clientes internos


                SH.Get("Document Type", "Document No.");
                if ("Document Type" = "Document Type"::Order) then begin
                    if not Temporal then begin
                        SalesLine2.Reset;
                        SalesLine2.SetRange("Document Type", SalesLine2."Document Type"::Order);
                        SalesLine2.SetRange("Sell-to Customer No.", "Sell-to Customer No.");
                        SalesLine2.SetRange(Type, Type);
                        SalesLine2.SetRange("No.", "No.");
                        if SalesLine2.FindFirst then
                            if not HideValidationDialog then
                                if not Confirm(txt003, false, SalesLine2."Document No.") then
                                    Validate("No.", '');
                    end;
                end;

                // Lógica específica para "Return Order"
                if Type = Type::Item then begin
                    if ("Document Type" = "Document Type"::"Return Order") and
                       (SalesHeader."Establecimiento Fact. Rel" <> '') and
                       (SalesHeader."Punto de Emision Fact. Rel." <> '') and
                       (SalesHeader."No. Comprobante Fiscal Rel." <> '') then begin
                        "Unit Price" := getPrecioFactura(SalesHeader."Establecimiento Fact. Rel", SalesHeader."Punto de Emision Fact. Rel.", SalesHeader."No. Comprobante Fiscal Rel.", "No.");
                        "Line Discount %" := getDescuentoFactura(SalesHeader."Establecimiento Fact. Rel", SalesHeader."Punto de Emision Fact. Rel.", SalesHeader."No. Comprobante Fiscal Rel.", "No.");
                    end;
                end;
            end;
        }
        modify("Location Code")
        {
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false),
                                            Inactivo = CONST(false));
            Description = '#34448';
            trigger OnAfterValidate()
            begin
                // Validar líneas de planificación de trabajo
                TestJobPlanningLine;

                // Validar que el estado sea "Open"
                TestStatusOpen;

                // Verificar órdenes de compra asociadas
                CheckAssocPurchOrder(FieldCaption("Location Code"));

                // Validar el motivo de devolución si el tipo de documento es "Return Order"
                if "Document Type" = "Document Type"::"Return Order" then
                    ValidateReturnReasonCode(FieldNo("Location Code"));

                // Validar campos maestros y dimensiones
                ValidaCampos.Maestros(14, "Location Code"); //011
                ValidaCampos.Dimensiones(14, "Location Code", 0, 0); //011

                // Actualizar información de adopción
                ActualizaInfoAdopcion; //016
            end;
        }
        modify(Description)
        {

            //Unsupported feature: Property Modification (Data type) on "Description(Field 11)".

            TableRelation = IF (Type = CONST("G/L Account"),
                                "System-Created Entry" = CONST(false)) "G/L Account".Name WHERE("Direct Posting" = CONST(true),
                                                                                               "Account Type" = CONST(Posting),
                                                                                               Blocked = CONST(false))
            ELSE
            IF (Type = CONST("G/L Account"),
                                                                                                        "System-Created Entry" = CONST(true)) "G/L Account".Name
            ELSE
            IF (Type = CONST(Item),
                                                                                                                 "Document Type" = FILTER(<> "Credit Memo" & <> "Return Order")) Item.Description WHERE(Blocked = CONST(false),
                                                                                                                                                                                                   "Sales Blocked" = CONST(false))
            ELSE
            IF (Type = CONST(Item),
                                                                                                                                                                                                            "Document Type" = FILTER("Credit Memo" | "Return Order")) Item.Description WHERE(Blocked = CONST(false))
            ELSE
            IF (Type = CONST(Resource)) Resource.Name
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset".Description
            ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge".Description;
            trigger OnAfterValidate()
            begin
                // Si el tipo es "Item", realizar validaciones específicas
                if Type = Type::Item then begin
                    if Users.Get(UserId) then begin
                        // Verificar si el usuario tiene permiso para modificar la descripción
                        if not Users."Modifica Desc. prod. Lin. Vta." then
                            if "Document Type" in ["Document Type"::Order, "Document Type"::Invoice] then
                                Error(Err001, FieldCaption(Description));
                    end else
                        // Lanzar error si el usuario no tiene permisos
                        Error(Err001, FieldCaption(Description));
                end;
            end;
        }

        //Unsupported feature: Property Modification (Data type) on ""Description 2"(Field 12)".

        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        modify("Bill-to Customer No.")
        {
            TableRelation = Customer WHERE(Inactivo = CONST(false));
            Description = '#34448';
        }
        modify("Gen. Bus. Posting Group")
        {
            Caption = 'Gen. Bus. Posting Group';
        }
        modify("Gen. Prod. Posting Group")
        {
            Caption = 'Gen. Prod. Posting Group';
        }
        modify("Attached to Line No.")
        {
            Caption = 'Attached to Line No.';
        }
        modify("Area")
        {
            Caption = 'Area';
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'VAT Bus. Posting Group';
        }
        modify("VAT Prod. Posting Group")
        {
            Caption = 'VAT Prod. Posting Group';
        }
        modify("IC Partner Ref. Type")
        {
            Caption = 'IC Partner Ref. Type';
        }
        modify("Job Contract Entry No.")
        {
            Caption = 'Job Contract Entry No.';
        }
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }

        //Unsupported feature: Property Insertion (Editable) on ""Qty. to Invoice (Base)"(Field 5417)".

        modify("Depr. until FA Posting Date")
        {
            Caption = 'Depr. until FA Posting Date';
        }
        modify("Duplicate in Depreciation Book")
        {
            Caption = 'Duplicate in Depreciation Book';
        }
        modify("Originally Ordered No.")
        {
            TableRelation = IF (Type = CONST(Item)) Item WHERE(Inactivo = CONST(false));
            Description = '#34448';
        }
        modify("BOM Item No.")
        {
            TableRelation = Item WHERE(Inactivo = CONST(false));
            Description = '#34448';
        }
        modify(Subtype)
        {
            OptionCaption = ' ,Item - Inventory,Item - Service,Comment';
        }





        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                // Validar líneas de planificación de trabajo
                TestJobPlanningLine;

                // Validar que el estado sea "Open"
                TestStatusOpen;

                // Validar el campo "Cod. Cupon"
                Validate("Cod. Cupon", ''); //003


                // Aplicar lógica de precios según el tipo de venta
                PreciosTipoVenta; //006

                // Actualizar información de adopción
                ActualizaInfoAdopcion; //016
            end;
        }


        modify("Unit Price")
        {
            trigger OnAfterValidate()
            var
                text1020001: Label 'must be %1 when the Prepayment Invoice has already been posted.';
            begin
                // Validar si hay un monto de prepago facturado y el precio unitario ha cambiado
                if ("Prepmt. Amt. Inv." <> 0) and
                   ("Unit Price" <> xRec."Unit Price") and not IsServiceCharge then
                    FieldError("Unit Price", StrSubstNo(Text1020001, xRec."Unit Price"));

                // Validar el descuento de línea
                Validate("Line Discount %");

                // Asignar la cantidad solicitada y validarla
                CantidadSol := "Cantidad Solicitada"; //013
                Validate("Cantidad Solicitada", CantidadSol); //013
            end;
        }


        modify("Line Discount %")
        {
            trigger OnAfterValidate()
            begin
                // Validar el porcentaje de descuento de línea
                ValidateLineDiscountPercent(true);

                // Si se realiza una asignación manual, reiniciar el descuento por forma de pago
                if "% Dto por forma de pago" <> 0 then
                    if "Line Discount %" <> xRec."Line Discount %" then
                        "% Dto por forma de pago" := 0;
            end;
        }

        modify("Blanket Order Line No.")
        {
            trigger OnAfterValidate()
            var
                SalesLine2: Record "Sales Line";
            begin
                // Validar que la cantidad enviada sea 0
                TestField("Quantity Shipped", 0);

                // Si el número de línea de pedido abierto no es 0, realizar validaciones
                if "Blanket Order Line No." <> 0 then begin
                    SalesLine2.Get("Document Type"::"Blanket Order", "Blanket Order No.", "Blanket Order Line No.");
                    SalesLine2.TestField(Type, Type);
                    SalesLine2.TestField("No.", "No.");
                    SalesLine2.TestField("Bill-to Customer No.", "Bill-to Customer No.");
                    SalesLine2.TestField("Sell-to Customer No.", "Sell-to Customer No.");

                    // Validar campos adicionales si es un envío directo o pedido especial
                    if "Drop Shipment" or "Special Order" then begin
                        SalesLine2.TestField("Variant Code", "Variant Code");
                        SalesLine2.TestField("Location Code", "Location Code");
                        SalesLine2.TestField("Unit of Measure Code", "Unit of Measure Code");
                    end;

                    // Validar el precio unitario y el descuento de línea
                    Validate("Unit Price", SalesLine2."Unit Price");
                    Validate("Line Discount %", SalesLine2."Line Discount %");
                end;
            end;
        }
        //Unsupported feature: Deletion (FieldCollection) on ""Retention Attached to Line No."(Field 10001)".


        //Unsupported feature: Deletion (FieldCollection) on ""Retention VAT %"(Field 10002)".


        //Unsupported feature: Deletion (FieldCollection) on ""Custom Transit Number"(Field 10003)".

        field(50000; "Cod. Procedencia"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Procedencia;
        }
        field(50001; "Cod. Edicion"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Edicion.Codigo;
        }
        field(50002; Areas; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Areas de interes padres";
        }
        field(50003; "No. Paginas"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; ISBN; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Componentes Prod."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Componentes Prod.";
        }
        field(50006; "Nivel Educativo"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Nivel Educativo APS";
        }
        field(50007; Cursos; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Cursos;
        }
        field(50008; "Cantidad Inv. en Consignacion"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Cantidad Consignacion Devuelta"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //001
                Validate("Qty. to Ship", (Quantity - "Cantidad Consignacion Devuelta"));
            end;
        }
        field(50010; "No. Pedido Consignacion"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "No. Linea Pedido Consignacion"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "No. Mov. Prod. Cosg. a Liq."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "No. Estante"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Cod. Cupon"; Code[20])
        {
            Caption = 'Coupon Code';
            DataClassification = ToBeClassified;
        }
        field(50015; "No. Linea Cupon"; Integer)
        {
            Caption = 'Coupon Line No.';
            DataClassification = ToBeClassified;
        }
        field(50016; "Cantidad Aprobada"; Decimal)
        {
            Caption = 'Approved Qty.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
            begin
                //008
                ConfSant.Get;
                if ConfSant."Cantidades sin Decimales" then begin
                    if Quantity mod 1 <> 0 then
                        Error(Error003);
                end;
                //008


                //007
                if Users.Get(UserId) then begin
                    if not Users."Aprueba Cantidades" then
                        Error(Error001);
                    Validate(Quantity, 0);
                    UpdateUnitPrice(FieldNo("Cantidad Aprobada"));
                    PreciosTipoVenta;//006
                    Modify;
                    Commit;

                    "Cantidad pendiente BO" := 0;
                    "Cantidad a Anular" := 0;
                    CantDisp := CalcAvailability_BackOrder(Rec);
                    if CantDisp >= "Cantidad Aprobada" then begin
                        Validate(Quantity, "Cantidad Aprobada");
                        UpdateUnitPrice(FieldNo("Cantidad Aprobada"));
                        PreciosTipoVenta;
                    end
                    else begin
                        Cust.Get("Sell-to Customer No.");
                        if CantDisp > 0 then begin
                            Validate(Quantity, CantDisp);
                            UpdateUnitPrice(FieldNo("Cantidad Aprobada"));
                            PreciosTipoVenta;
                        end;
                        if Cust."Admite Pendientes en Pedidos" then begin
                            if CantDisp >= 0 then
                                //VALIDATE("Cantidad pendiente BO","Cantidad Aprobada" - CantDisp) //-$019
                                Validate("Cantidad pendiente BO", "Cantidad Aprobada" - CantDisp - "Cantidad Anulada") //+$019
                            else begin
                                //VALIDATE("Cantidad pendiente BO","Cantidad Solicitada"); //-$019
                                Validate("Cantidad pendiente BO", "Cantidad Solicitada" - "Cantidad Anulada"); //+$019
                                Validate(Quantity, 0);
                            end;
                        end
                        //+$019
                        //ELSE
                        //  VALIDATE("Cantidad a Anular","Cantidad Aprobada" - CantDisp);
                        //-$019
                    end;
                    PreciosTipoVenta;
                end
                else
                    Error(Error001);
                //007
            end;
        }
        field(50017; "Cantidad pendiente BO"; Decimal)
        {
            Caption = 'BO Pending Qty.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //"Cantidad a Anular" := "Cantidad pendiente BO";//005 //-$019
            end;
        }
        field(50018; "Cantidad a Anular"; Decimal)
        {
            Caption = 'Qty. to Void';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //+$017
                if "Cantidad a Anular" > "Cantidad pendiente BO" then
                    Error(Error002, FieldCaption("Cantidad a Anular"));

                if "Cantidad a Anular" < 0 then
                    Error(Error004, FieldCaption("Cantidad a Anular"));
                //-$017
            end;
        }
        field(50019; "Cantidad Solicitada"; Decimal)
        {
            Caption = 'Requested Qty.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //008
                ConfSant.Get;
                if ConfSant."Cantidades sin Decimales" then begin
                    if Quantity mod 1 <> 0 then
                        Error(Error003);
                end;
                //008

                //007
                if Type <> Type::Item then
                    Validate(Quantity, "Cantidad Solicitada");
                //007
            end;
        }
        field(50020; Temporal; Boolean)
        {
            Caption = 'Temp';
            DataClassification = ToBeClassified;
        }
        field(50022; "Cantidad Anulada"; Decimal)
        {
            Caption = 'Qty. Canceled';
            DataClassification = ToBeClassified;
        }
        field(50040; "Cantidad a Ajustar"; Decimal)
        {
            Caption = 'Qty. To Adjust';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //007
                if "Cantidad a Ajustar" > "Cantidad pendiente BO" then
                    //ERROR(Error002); //-$017
                    Error(Error002, FieldCaption("Cantidad a Ajustar")); //+$017

                if "Cantidad a Ajustar" < 0 then
                    //ERROR(Error004); //-$017
                    Error(Error004, FieldCaption("Cantidad a Ajustar")); //+$017
                //007
            end;
        }
        field(50041; "Porcentaje Cant. Aprobada"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Error_L001: Label 'Porcentage must be between 0 and 100';
            begin
                //007
                if Type = Type::Item then begin
                    if ("Porcentaje Cant. Aprobada" > 100) or (("Porcentaje Cant. Aprobada" < 0)) then
                        Error(Error_L001);
                    Users.Get(UserId);
                    begin
                        if not Users."Aprueba Cantidades" then
                            Error(Error001);

                        Cantidad := (("Cantidad Solicitada" * "Porcentaje Cant. Aprobada") div 100);
                        CantDisp := CalcAvailability_BackOrder(Rec);
                        begin
                            Validate("Cantidad Aprobada", Cantidad);
                            Validate(Quantity, Cantidad);
                            UpdateUnitPrice(FieldNo("Porcentaje Cant. Aprobada"));
                            PreciosTipoVenta;//006
                        end;
                    end;
                end;
            end;
        }
        field(50046; "Cantidad Devuelta"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ClasDev';
        }
        field(50047; "Clas Dev"; Boolean)
        {
            Caption = 'Clas Dev';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-936 ClasDev';
        }
        field(50110; "No. Documento SIC"; Code[40])
        {
            DataClassification = ToBeClassified;
            Description = 'SIC-JERM';
        }
        field(55012; "Parte del IVA"; Boolean)
        {
            Caption = 'VAT part';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(56001; "Disponible BackOrder"; Boolean)
        {
            Caption = 'Available';
            DataClassification = ToBeClassified;
            Description = 'Gestion BackOrder';
        }
        field(56002; "Cod. Oferta"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(76046; "Anulada en TPV"; Boolean)
        {
            Caption = 'POS Void';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76029; "Precio anulacion TPV"; Decimal)
        {
            Caption = 'Void POS Price';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76011; "Cantidad anulacion TPV"; Decimal)
        {
            Caption = 'Void POS Qty.';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76016; "Cantidad agregada"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76018; "Cod. Vendedor"; Code[10])
        {
            Caption = 'Salesperson Code';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
            TableRelation = Vendedores.Codigo;
        }
        field(76015; Devuelto; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76026; "Devuelto en Documento"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76020; "Devuelto en Linea Documento"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76022; "Devuelve a Documento"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76027; "Devuelve a Linea Documento"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
        field(76017; "Registrado TPV"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard,#305288';
        }
        field(76021; "Posting No."; Code[20])
        {
            CalcFormula = Lookup("Sales Header"."Posting No." WHERE("Document Type" = FIELD("Document Type"),
                                                                     "No." = FIELD("Document No.")));
            Description = 'DsPOS Standard,#355717';
            FieldClass = FlowField;
        }
        field(76030; "Cantidad devuelta TPV"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard,#355717';
        }
        field(76295; "Cantidad dev. TPV (calc)"; Decimal)
        {
            CalcFormula = Sum("Sales Line".Quantity WHERE("Document Type" = FILTER("Credit Memo"),
                                                           "Devuelve a Documento" = FIELD("Posting No."),
                                                           "Devuelve a Linea Documento" = FIELD("Line No."),
                                                           "Registrado TPV" = FILTER(true)));
            Description = 'DsPOS Standard,#355717';
            FieldClass = FlowField;
        }
        field(76227; "% Dto por forma de pago"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard,#373762';
        }
        field(76012; "Cantidad Alumnos"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
            Description = 'APS';
            Editable = false;
        }
        field(76034; Adopcion; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
            Editable = false;
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(76014; "Cod. Colegio"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
            Editable = false;
            TableRelation = Contact;

            trigger OnValidate()
            var
                ColAdop: Record "Colegio - Log - Adopciones";
            begin
                //018
                if ("Cod. Colegio" <> '') and (Presupuesto = 0) then begin
                    ColAdop.Reset;
                    ColAdop.SetRange("Cod. Colegio", "Cod. Colegio");
                    ColAdop.SetRange("Cod. Producto", "No.");
                    if ColAdop.FindFirst then begin
                        Adopcion := ColAdop.Adopcion;
                        Presupuesto := ColAdop."Adopcion Real";
                    end;
                end;
            end;
        }
        field(76422; Presupuesto; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
            Editable = false;
        }
    }
    keys
    {

        key(Key4; "Disponible BackOrder")
        {
        }
        key(Key5; Devuelto, "Devuelve a Documento")
        {
        }
        key(KeyReports; "Item Category Code")
        {
        }
    }

    trigger OnDelete()
    var
        lrCV: Record "Sales Header";
        lNumLog: Integer;
        /*        lcPos: Codeunit "Funciones DsPOS - Comunes"; */
        TextL001: Label '<Nº Linea: %1, Item: %2, Cantidad: %3>';
        DocumentType: Enum "Sales Document Type";
        SalesHeader: Record "Sales Header";
    begin
        // Validar que el estado sea "Open"
        TestStatusOpen;

        // Lógica específica para documentos del TPV


        // Lógica adicional para "Return Order"
        if "Document Type" = "Document Type"::"Return Order" then
            SalesHeader.ControlClasificacionDevolucion(true);
    end;

    trigger OnInsert()
    var
        SL: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        TextL001: Label '<Nº Linea: %1, Item: %2, Cantidad: %3>';
    begin

        // Registrar información en el log si aplica
        if SalesHeader."Venta TPV" then
            Message(TextL001, "Line No.", "No.", Quantity);

        // Lógica adicional según sea necesario
        // ...
    end;

    //Unsupported feature: Code Modification on "OnModify".

    trigger OnModify()
    var
        SalesHeader: Record "Sales Header";
        SalesLine2: Record "Sales Line";
        Item: Record Item;
        TempSalesLine: Record "Sales Line" temporary;
        CantidadSol: Decimal;
        CantDisp: Decimal;
    begin
        // Lógica adicional para "Return Order"
        if "Document Type" = "Document Type"::"Return Order" then
            SalesHeader.ControlClasificacionDevolucion(false); // 020

        // Obtener el encabezado de ventas
        GetSalesHeader; // $015

    end;




    local procedure CalcAvailability_BackOrder(var SalesLine: Record "Sales Line"): Decimal
    var
        Item: Record Item;
    begin
        // Obtener el registro del artículo relacionado con la línea de venta


        // Reiniciar los filtros del registro de artículo
        Item.Reset;

        // Configurar los filtros necesarios
        Item.SetRange("Variant Filter", SalesLine."Variant Code");
        Item.SetRange("Location Filter", SalesLine."Location Code");
        Item.SetRange("Drop Shipment Filter", false);

        // Calcular los campos necesarios
        Item.CalcFields(
            "Qty. on Component Lines",
            "Planning Issues (Qty.)",
            "Qty. on Sales Order",
            "Qty. on Assembly Order",
            "Res. Qty. on Assembly Order",
            "Qty. on Service Order",
            Inventory,
            "Reserved Qty. on Inventory",
            "Qty. on Pre Sales Order", // Localización Guatemala
            "Trans. Ord. Shipment (Qty.)"
        );

        // Calcular la disponibilidad y devolver el resultado
        exit(
            Item.Inventory -
            Item."Qty. on Sales Order" -
            Item."Qty. on Assembly Order" -
            Item."Res. Qty. on Assembly Order" -
            Item."Qty. on Service Order" -
            Item."Reserved Qty. on Inventory" -
            Item."Qty. on Pre Sales Order" -
            Item."Trans. Ord. Shipment (Qty.)"
        );
    end;

    procedure PreciosTipoVenta()
    var
        SantSetup: Record "Config. Empresa";
        Item: Record Item;
        salesHeader: Record "Sales Header";
    begin
        //006
        SantSetup.Get;
        SalesHeader.Get("Document Type", "Document No.");

        if SalesHeader."Tipo de Venta" = SalesHeader."Tipo de Venta"::Muestras then begin
            if Item.Get("No.") then begin
                if SantSetup."Precio de Venta Muestras" = SantSetup."Precio de Venta Muestras"::Costo then
                    Validate("Unit Price", Item."Unit Cost")
                else
                    Validate("Unit Price", 0);
            end;
        end;

        if SalesHeader."Tipo de Venta" = SalesHeader."Tipo de Venta"::Donaciones then begin
            if Item.Get("No.") then begin
                if SantSetup."Precio de Venta Donaciones" = SantSetup."Precio de Venta Donaciones"::Costo then
                    Validate("Unit Price", Item."Unit Cost")
                else
                    Validate("Unit Price", 0);
            end;
        end;
    end;

    procedure ActualizaInfoAdopcion()
    var
        AdopcionesDetalle: Record "Colegio - Adopciones Detalle";
        ColNivel: Record "Colegio - Nivel";
        PromotorRuta: Record "Promotor - Rutas";
        TempSalesLine: Record "Sales Line" temporary;
        salesHeader: Record "Sales Header";
    begin

        TempSalesLine := Rec;

        if ("Cod. Colegio" <> '') and ("Cantidad Alumnos" <> 0) then
            exit;
        //016 Se buscan las adopciones, si existe, se llenan los datos
        if SalesHeader."Salesperson Code" = '' then
            SalesHeader."Salesperson Code" := TempSalesLine."Cod. Vendedor";
        if SalesHeader."Salesperson Code" <> '' then begin
            //Se busca la Ruta del Promotor para tener el Nivel
            PromotorRuta.Reset;
            PromotorRuta.SetRange("Cod. Promotor", SalesHeader."Salesperson Code");
            if PromotorRuta.FindFirst then begin
                //Se buscar el Nivel de ese Colegio para esa Ruta
                ColNivel.Reset;
                ColNivel.SetRange("Cod. Colegio", SalesHeader."Bill-to Contact No.");
                ColNivel.SetRange(Ruta, PromotorRuta."Cod. Ruta");
                if ColNivel.FindFirst then;

                AdopcionesDetalle.Reset;
                AdopcionesDetalle.SetCurrentKey("Cod. Colegio", "Cod. Promotor", "Cod. Producto");
                AdopcionesDetalle.SetRange("Cod. Colegio", SalesHeader."Bill-to Contact No.");
                AdopcionesDetalle.SetRange("Cod. Promotor", SalesHeader."Salesperson Code");
                AdopcionesDetalle.SetRange("Cod. Nivel", ColNivel."Cod. Nivel");
                AdopcionesDetalle.SetRange("Cod. Producto", "No.");
                if AdopcionesDetalle.FindFirst then begin
                    Adopcion := AdopcionesDetalle.Adopcion;
                    "Cod. Vendedor" := SalesHeader."Salesperson Code";
                    "Cantidad Alumnos" := AdopcionesDetalle."Cantidad Alumnos";
                    "Cod. Colegio" := AdopcionesDetalle."Cod. Colegio";
                end;
            end;
        end;
    end;

    local procedure IsServiceCharge(): Boolean
    var
        CustomerPostingGroup: Record "Customer Posting Group";

        salesHeader: Record "Sales Header";
    begin
        // Verificar si el tipo es diferente de "G/L Account"
        if Type <> Type::"G/L Account" then
            exit(false);

        // Obtener el encabezado de ventas
        GetSalesHeader;

        // Obtener el grupo de contabilización del cliente
        CustomerPostingGroup.Get(SalesHeader."Customer Posting Group");

        // Verificar si la cuenta de cargo por servicio coincide con el número actual
        exit(CustomerPostingGroup."Service Charge Acc." = "No.");
    end;

    procedure ActLinBO()
    SalesHeader: Record "Sales Header";
    begin
        //+$017
        SalesHeader.Get("Document Type", "Document No.");
        SalesHeader.TestField(Status, 0);
        if "Cantidad a Ajustar" > "Cantidad pendiente BO" then
            Error(Error002, FieldCaption("Cantidad a Ajustar"));

        if "Cantidad a Ajustar" > 0 then begin //+$019
            if CalcAvailability_BackOrder(Rec) >= "Cantidad a Ajustar" then begin
                Quantity += "Cantidad a Ajustar";
                Validate(Quantity);
                //+$019
                //VALIDATE("Cantidad pendiente BO","Cantidad Aprobada" - Quantity);
                "Cantidad pendiente BO" := "Cantidad Aprobada" - Quantity - "Cantidad Anulada";
                if "Cantidad a Anular" > "Cantidad pendiente BO" then
                    "Cantidad a Anular" := "Cantidad pendiente BO";
                //-$019
                "Cantidad a Ajustar" := 0;
            end
            else
                Error(Error006, FieldCaption("Cantidad a Ajustar"));

            //+$019
        end;
        if "Cantidad a Anular" > 0 then begin
            if "Cantidad a Anular" <= "Cantidad pendiente BO" then begin
                "Cantidad pendiente BO" -= "Cantidad a Anular";
                "Cantidad Anulada" += "Cantidad a Anular";
                "Cantidad a Anular" := 0;
            end
            else
                Error(Error006, FieldCaption("Cantidad a Anular"));
        end;
        //-$019
    end;

    procedure getPrecioFactura(pEstablecimiento: Code[3]; pEmision: Code[3]; pNCF: Code[19]; pNo: Code[20]): Decimal
    var
        lrSalesInvoiceHeader: Record "Sales Invoice Header";
        lrSalesInvoiceLine: Record "Sales Invoice Line";
    begin
        //#24140:Inicio
        lrSalesInvoiceHeader.Reset;
        lrSalesInvoiceLine.Reset;

        lrSalesInvoiceHeader.SetCurrentKey("No. Comprobante Fiscal");
        lrSalesInvoiceHeader.SetRange("No. Comprobante Fiscal", pNCF);
        lrSalesInvoiceHeader.SetRange("Establecimiento Factura", pEstablecimiento);
        lrSalesInvoiceHeader.SetRange("Punto de Emision Factura", pEmision);
        if lrSalesInvoiceHeader.FindFirst then begin
            lrSalesInvoiceLine.SetRange("Document No.", lrSalesInvoiceHeader."No.");
            lrSalesInvoiceLine.SetRange("No.", pNo);
            if lrSalesInvoiceLine.FindFirst then
                exit(lrSalesInvoiceLine."Unit Price");
        end;
        //#24140:Fin
    end;

    procedure getDescuentoFactura(pEstablecimiento: Code[3]; pEmision: Code[3]; pNCF: Code[19]; pNo: Code[20]): Decimal
    var
        lrSalesInvoiceHeader: Record "Sales Invoice Header";
        lrSalesInvoiceLine: Record "Sales Invoice Line";
    begin
        //#24140:Inicio
        lrSalesInvoiceHeader.Reset;
        lrSalesInvoiceLine.Reset;

        lrSalesInvoiceHeader.SetCurrentKey("No. Comprobante Fiscal");
        lrSalesInvoiceHeader.SetRange("No. Comprobante Fiscal", pNCF);
        lrSalesInvoiceHeader.SetRange("Establecimiento Factura", pEstablecimiento);
        lrSalesInvoiceHeader.SetRange("Punto de Emision Factura", pEmision);
        if lrSalesInvoiceHeader.FindFirst then begin
            lrSalesInvoiceLine.SetRange("Document No.", lrSalesInvoiceHeader."No.");
            lrSalesInvoiceLine.SetRange("No.", pNo);
            if lrSalesInvoiceLine.FindFirst then
                exit(lrSalesInvoiceLine."Line Discount %");
        end;
        //#24140:Fin
    end;

    //Unsupported feature: Deletion (VariableCollection) on "UpdateVATAmounts(PROCEDURE 38).TotalVATDifference(Variable 1006)".


    var
        AdopcionesDetalle: Record "Colegio - Adopciones Detalle";
        ColNivel: Record "Colegio - Nivel";
        PromotorRuta: Record "Promotor - Rutas";

    var
        lrCV: Record "Sales Header";
        lNumLog: Integer;
        /*         lcPos: Codeunit "Funciones DsPOS - Comunes"; */
        TextL001: Label '<Nº Linea: %1, Item: %2, Cantidad: %3>';

    var
        SL: Record "Sales Line";

    var
        "*** Santillana ***": Integer;
        CustPostGr: Record "Customer Posting Group";
        "*** DSPos ***": Integer;
        cManejaParametros: Codeunit "Lanzador DsPOS";
        Users: Record "User Setup";
        ConfSant: Record "Config. Empresa";
        CantDisp: Decimal;
        Cust: Record Customer;
        Cantidad: Decimal;
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
        ValidaCampos: Codeunit "Valida Campos Requeridos";
        CantidadSol: Decimal;
        SH: Record "Sales Header";
        Text50000: Label 'You''d reached the limit of sales lines allowed for a sales document.';
        Err001: Label 'This user is not allowed to modify %1';
        txt001: Label 'Este código de producto ya ha sido introducido previamente';
        txt002: Label 'This product is back ordered on request %1 for this same customer';
        txt003: Label 'Product is pending to serve the order %1 for this same customer. Please confirm if you want to continue';
        Error003: Label 'The current setup does not permit decimals quantities';
        Error001: Label 'User does not have permision to approve quantities in sales orders';
        Error002: Label 'Quantity to adjust cannot be grater than Remaining Qty. in BO';
        Error005: Label 'You have reached the limit of allowed lines for an TPV order %1';
        Error004: Label 'Qty. to Adjust cannot be lower than 0';
        Error006: Label '%1 no puede ser mayor a la Disponibilidad';
        SH_: Record "Sales Header";
}

