tableextension 50113 tableextension50113 extends "Transfer Line"
{
    fields
    {
        modify("Item No.")
        {
            TableRelation = Item WHERE(Type = CONST(Inventory),
                                        Inactivo = CONST(false));
            trigger OnBeforeValidate()
            var
                rItem: Record Item;
                rCliente: Record Customer;
                rVPS: Record "VAT Posting Setup";
                PromotorRuta: Record "Promotor - Rutas";
                ColNivel: Record "Colegio - Nivel";
                AdopcionesDetalle: Record "Colegio - Adopciones Detalle";
                TempTransferLine: Record "Transfer Line";
                TransHeader: Record "Transfer Header";
                cFuncionesSantillana: Codeunit "Funciones Santillana";
                ValidaCampos: Codeunit "Valida Campos Requeridos";
                DimMgt: Codeunit DimensionManagement;
                DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
                DimSourceEntry: Dictionary of [Integer, Code[20]];
            begin
                TestField("Quantity Shipped", 0);
                if CurrFieldNo <> 0 then
                    TestStatusOpen;

                rItem.Get("Item No.");
                ValidaCampos.Maestros(27, "Item No.");
                ValidaCampos.Dimensiones(15, "Item No.", 0, 0);

                TransHeader.Get("Document No.");
                if TransHeader."Pedido Consignacion" then begin
                    if not TransHeader."Devolucion Consignacion" then begin
                        if rItem."Unit Price" = 0 then
                            "Precio Venta Consignacion" := cFuncionesSantillana.CalcrPrecio("Item No.", "Transfer-to Code", "Unit of Measure Code", TransHeader."Posting Date")
                        else
                            "Precio Venta Consignacion" := rItem."Unit Price";

                        "Descuento % Consignacion" := cFuncionesSantillana.CalcDesc("Item No.", "Transfer-to Code", "Unit of Measure Code", TransHeader."Posting Date");
                    end else begin
                        if rItem."Unit Price" = 0 then
                            "Precio Venta Consignacion" := cFuncionesSantillana.CalcrPrecio("Item No.", "Transfer-from Code", "Unit of Measure Code", TransHeader."Posting Date")
                        else
                            "Precio Venta Consignacion" := rItem."Unit Price";

                        "Descuento % Consignacion" := cFuncionesSantillana.CalcDesc("Item No.", "Transfer-from Code", "Unit of Measure Code", TransHeader."Posting Date");
                    end;
                end;

                if TransHeader."Pedido Consignacion" then begin
                    if rCliente.Get("Transfer-to Code") then begin
                        Validate("Grupo registro IVA prod.", rItem."VAT Prod. Posting Group");
                        Validate("Grupo registro IVA neg.", rCliente."VAT Bus. Posting Group");
                        if rVPS.Get("Grupo registro IVA neg.", "Grupo registro IVA prod.") then
                            Validate("% IVA", rVPS."VAT %");
                    end;
                end;

                if TransHeader."Cod. Vendedor" = '' then
                    TransHeader."Cod. Vendedor" := TempTransferLine."Cod. Vendedor";

                if TransHeader."Cod. Vendedor" <> '' then begin
                    PromotorRuta.Reset;
                    PromotorRuta.SetRange("Cod. Promotor", TransHeader."Cod. Vendedor");
                    if PromotorRuta.FindFirst then begin
                        ColNivel.Reset;
                        ColNivel.SetRange("Cod. Colegio", TransHeader."Cod. Contacto");
                        ColNivel.SetRange(Ruta, PromotorRuta."Cod. Ruta");
                        if ColNivel.FindFirst then;

                        AdopcionesDetalle.Reset;
                        AdopcionesDetalle.SetCurrentKey("Cod. Colegio", "Cod. Promotor", "Cod. Producto");
                        AdopcionesDetalle.SetRange("Cod. Colegio", TransHeader."Cod. Contacto");
                        AdopcionesDetalle.SetRange("Cod. Promotor", TransHeader."Cod. Vendedor");
                        AdopcionesDetalle.SetRange("Cod. Nivel", ColNivel."Cod. Nivel");
                        AdopcionesDetalle.SetRange("Cod. Producto", "Item No.");
                        if AdopcionesDetalle.FindFirst then begin
                            Adopcion := AdopcionesDetalle.Adopcion;
                            "Cod. Vendedor" := TransHeader."Cod. Vendedor";
                            "Cantidad Alumnos" := AdopcionesDetalle."Cantidad Alumnos";
                            "Cod. Colegio" := AdopcionesDetalle."Cod. Colegio";
                        end;
                    end;
                end;
                /* DimSourceEntry.Add(DATABASE::Item, "Item No.");
                DefaultDimSource.Add(DimSourceEntry);
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code"); */
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

        //Unsupported feature: Property Modification (Data type) on "Description(Field 13)".

        modify("Gen. Prod. Posting Group")
        {
            Caption = 'Gen. Prod. Posting Group';
        }
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }

        //Unsupported feature: Property Modification (Data type) on ""Description 2"(Field 32)".

        modify("In-Transit Code")
        {
            TableRelation = Location WHERE("Use As In-Transit" = CONST(true),
                                            Inactivo = CONST(false));
        }
        modify("Transfer-from Code")
        {

            //Unsupported feature: Property Modification (Data type) on ""Transfer-from Code"(Field 36)".

            TableRelation = Location WHERE(Inactivo = CONST(false));
        }
        modify("Reserved Qty. Outbnd. (Base)")
        {
            Caption = 'Reserved Qty. Outbnd. (Base)';
        }

        modify("Quantity")
        {
            trigger OnAfterValidate()
            var
                TransHeader: Record "Transfer Header";
                cFuncionesSantillana: Codeunit "Funciones Santillana";
                wImporteDescuento: Decimal;
                item: Record Item;
            begin
                // Validación inicial
                if Quantity < 0 then
                    Error(Error004); // Error: La cantidad no puede ser negativa.

                // Obtener el encabezado de transferencia
                TransHeader.Get("Document No.");
                if TransHeader."Pedido Consignacion" then begin
                    if not TransHeader."Devolucion Consignacion" then begin
                        if Item."Unit Price" = 0 then
                            "Precio Venta Consignacion" := cFuncionesSantillana.CalcrPrecio("Item No.", "Transfer-to Code", "Unit of Measure Code", TransHeader."Posting Date")
                        else
                            "Precio Venta Consignacion" := Item."Unit Price";

                        "Descuento % Consignacion" := cFuncionesSantillana.CalcDesc("Item No.", "Transfer-to Code", "Unit of Measure Code", TransHeader."Posting Date");
                    end else begin
                        if Item."Unit Price" = 0 then
                            "Precio Venta Consignacion" := cFuncionesSantillana.CalcrPrecio("Item No.", "Transfer-from Code", "Unit of Measure Code", TransHeader."Posting Date")
                        else
                            "Precio Venta Consignacion" := Item."Unit Price";

                        "Descuento % Consignacion" := cFuncionesSantillana.CalcDesc("Item No.", "Transfer-from Code", "Unit of Measure Code", TransHeader."Posting Date");
                    end;

                    // Calcular importes de consignación e IVA
                    wImporteDescuento := ((Quantity * "Precio Venta Consignacion") * "Descuento % Consignacion") / 100;
                    "Importe Consignacion Original" := (Quantity * "Precio Venta Consignacion") - wImporteDescuento;
                    "Importe IVA" := "Importe Consignacion Original" * "% IVA" / 100;
                end;

                // Actualizar la cantidad pendiente de BackOrder
                if "Cantidad Aprobada" > Quantity then
                    "Cantidad pendiente BO" := "Cantidad Aprobada" - Quantity - "Cantidad Anulada" // Ajuste para considerar la cantidad anulada
                else
                    "Cantidad pendiente BO" := 0;
            end;
        }

        field(50000; "Precio Venta Consignacion"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Descuento % Consignacion"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Importe Consignacion"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Importe Consignacion Original"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; ISBN; Text[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item.ISBN;
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
        field(50014; "Cantidad Devuelta"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "Grupo registro IVA prod."; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "VAT Product Posting Group";
        }
        field(50016; "Grupo registro IVA neg."; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "VAT Business Posting Group";
        }
        field(50017; "% IVA"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50018; "Importe IVA"; Decimal)
        {
            Caption = 'VAT Amount';
            DataClassification = ToBeClassified;
        }
        field(50020; "Cantidad Aprobada"; Decimal)
        {
            Caption = 'Approved Qty.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Transheader: Record "Transfer Header";
            begin
                //005
                confSant.Get;
                if confSant."Cantidades sin Decimales" then begin
                    if "Cantidad Aprobada" mod 1 <> 0 then
                        Error(Error003);
                end;

                if Users.Get(UserId) then begin
                    if not Users."Aprueba Cantidades Transf." then
                        Error(Error001);
                    Validate(Quantity, 0);
                    Modify;

                    "Cantidad pendiente BO" := 0;
                    "Cantidad a Anular" := 0;
                    CantDisp := rec.CalcAvailabilityTL_BackOrder(Rec);
                    if CantDisp >= "Cantidad Aprobada" then begin
                        Validate(Quantity, "Cantidad Aprobada");
                    end
                    else begin
                        if TransHeader.Get("Document No.") then
                            if TransHeader."Pedido Consignacion" then
                                if Cust.Get(TransHeader."Transfer-to Code") then;

                        if CantDisp >= 0 then
                            Validate(Quantity, CantDisp);
                        if Cust."Admite Pendientes en Pedidos" then
                            //+$011
                            // VALIDATE("Cantidad pendiente BO","Cantidad Aprobada" - CantDisp)
                            //ELSE
                            //  VALIDATE("Cantidad a Anular","Cantidad Aprobada" - CantDisp);
                            Validate("Cantidad pendiente BO", "Cantidad Aprobada" - CantDisp - "Cantidad Anulada")
                        //-$011
                    end;
                end
                else
                    Error(Error001);
                //005
            end;
        }
        field(50021; "Cantidad pendiente BO"; Decimal)
        {
            Caption = 'BO Pending Qty.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //"Cantidad a Anular" := "Cantidad pendiente BO";//005 //-$011
            end;
        }
        field(50022; "Cantidad a Anular"; Decimal)
        {
            Caption = 'Qty. to Void';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //+$010
                if "Cantidad a Anular" > "Cantidad pendiente BO" then
                    Error(Error002, FieldCaption("Cantidad a Anular"));

                if "Cantidad a Anular" < 0 then
                    Error(Error004, FieldCaption("Cantidad a Anular"));
                //-$010
            end;
        }
        field(50023; "Cantidad Solicitada"; Decimal)
        {
            Caption = 'Requested Qty.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //005
                confSant.Get;
                if confSant."Cantidades sin Decimales" then begin
                    if "Cantidad Solicitada" mod 1 <> 0 then
                        Error(Error003);
                end;
                //005
            end;
        }
        field(50024; "Cantidad a Ajustar"; Decimal)
        {
            Caption = 'Qty. To Adjust';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //005
                if "Cantidad a Ajustar" > "Cantidad pendiente BO" then
                    //ERROR(Error002); //-$010
                    Error(Error002, FieldCaption("Cantidad a Ajustar")); //+$010

                //+$010
                if "Cantidad a Ajustar" < 0 then
                    Error(Error004, FieldCaption("Cantidad a Ajustar"));
                //-$010
            end;
        }
        field(50025; "Porcentaje Cant. Aprobada"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Error_L001: Label 'Porcentage must be between 0 and 100';
            begin
                //005
                if ("Porcentaje Cant. Aprobada" > 100) or (("Porcentaje Cant. Aprobada" < 0)) then
                    Error(Error_L001);
                if Users.Get(UserId) then begin
                    if not Users."Aprueba Cantidades Transf." then
                        Error(Error001);

                    Cantidad := (("Cantidad Solicitada" * "Porcentaje Cant. Aprobada") div 100);
                    CantDisp := rec.CalcAvailabilityTransLine(Rec);
                    //fes mig IF CantDisp >= 0 THEN
                    Validate("Cantidad Aprobada", Cantidad);
                    Validate(Quantity, Cantidad);
                end
                else
                    Error(Error001);
                //005
            end;
        }
        field(50026; "Cod. Vendedor"; Code[20])
        {
            Caption = 'Salesperson code';
            DataClassification = ToBeClassified;
        }
        field(50029; "Cantidad Anulada"; Decimal)
        {
            Caption = 'Qty. Canceled';
            DataClassification = ToBeClassified;
        }
        field(56028; "Disponible BackOrder"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(56076; "Tipo Transferencia"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Sales,Promotion';
            OptionMembers = Venta,Promocion;
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
        }
    }
    keys
    {
        /*  key(Key7; "Document No.", "Derived From Line No.")
         {
             // Removed SumIndexFields as "Importe Consignacion" is not from the same table.
         } */
        key(Key8; "Transfer-to Code")
        {
            SumIndexFields = "Qty. in Transit";
        }
        key(Key9; Description, "Item No.")
        {
        }
        key(Key10; "Disponible BackOrder")
        {
        }
        key(KeyReports; "Item Category Code")
        {
        }
    }


    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    TestStatusOpen;

    TestField("Quantity Shipped","Quantity Received");
    TestField("Qty. Shipped (Base)","Qty. Received (Base)");
    #5..14
    ItemChargeAssgntPurch.SetRange("Applies-to Doc. No.","Document No.");
    ItemChargeAssgntPurch.SetRange("Applies-to Doc. Line No.","Line No.");
    ItemChargeAssgntPurch.DeleteAll(true);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    TestStatusOpen;

    //006 Parar APS
    TransHeader.Get("Document No.");
    TransHeader.TestField(Blocked,false);
    //006 Fin
    #2..17
    */
    //end;


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    TestStatusOpen;
    TransLine2.Reset;
    TransLine2.SetFilter("Document No.",TransHeader."No.");
    if TransLine2.FindLast then
      "Line No." := TransLine2."Line No." + 10000;
    ReserveTransferLine.VerifyQuantity(Rec,xRec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    TestStatusOpen;

    //006 Parar APS
    TransHeader.Get("Document No.");
    TransHeader.TestField(Blocked,false);
    //006 Fin

    if not TransHeader."Consignacion Muestras" then
       begin
        ContUbicDesdeLineas;//008
        ContUbicHastaLineas;//009
       end;

    #2..6
    */
    //end;


    //Unsupported feature: Code Modification on "OnModify".

    //trigger OnModify()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    if ItemExists(xRec."Item No.") then
      ReserveTransferLine.VerifyChange(Rec,xRec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*

    //006 Parar APS
    ConfAPS.Get();
    if ConfAPS."Movilidad Activada" then
       begin
        TransHeader.Get("Document No.");
        TransHeader.TestField(Blocked,false);
       end;
    //006 Fin

    //$009
    if not blnAutoModify then begin
      GetTransHeader;
      TransHeader.ControlClasificacionDevolucion;
    end;
    //$009

    if ItemExists(xRec."Item No.") then
      ReserveTransferLine.VerifyChange(Rec,xRec);
    */
    //end;

    procedure SetAutoModify(blnPrmAutoModify: Boolean)
    begin
        //$009
        //sb_mig blnAutoModify := blnPrmAutoModify;
    end;

    procedure ItemAvailability(AvailabilityType: Option Date,Variant,Location)
    var
        ItemAvailByDate: Page "Item Availability by Periods";
        ItemAvailByVar: Page "Item Availability by Variant";
        ItemAvailByLoc: Page "Item Availability by Location";
        item: Record Item;
    begin
        TestField("Item No.");
        Item.Reset;
        Item.Get("Item No.");
        Item.SetRange("No.", "Item No.");
        Item.SetRange("Date Filter", 0D, "Shipment Date");

        case AvailabilityType of
            AvailabilityType::Date:
                begin
                    Item.SetRange("Variant Filter", "Variant Code");
                    Item.SetRange("Location Filter", "Transfer-from Code");
                    Clear(ItemAvailByDate);
                    ItemAvailByDate.LookupMode(false);
                    ItemAvailByDate.SetRecord(Item);
                    ItemAvailByDate.SetTableView(Item);
                    if ItemAvailByDate.RunModal = ACTION::LookupOK then
                        if "Shipment Date" <> ItemAvailByDate.GetLastDate then
                            if Confirm(
                                 Text010, true, FieldCaption("Shipment Date"), "Shipment Date",
                                 ItemAvailByDate.GetLastDate)
                            then
                                Validate("Shipment Date", ItemAvailByDate.GetLastDate);
                end;
            AvailabilityType::Variant:
                begin
                    Item.SetRange("Location Filter", "Transfer-from Code");
                    Clear(ItemAvailByVar);
                    ItemAvailByVar.LookupMode(false);
                    ItemAvailByVar.SetRecord(Item);
                    ItemAvailByVar.SetTableView(Item);
                    if ItemAvailByVar.RunModal = ACTION::LookupOK then
                        if "Variant Code" <> ItemAvailByVar.GetLastVariant then
                            if Confirm(
                                 Text010, true, FieldCaption("Variant Code"), "Variant Code",
                                 ItemAvailByVar.GetLastVariant)
                            then
                                Validate("Variant Code", ItemAvailByVar.GetLastVariant);
                end;
            AvailabilityType::Location:
                begin
                    Item.SetRange("Variant Filter", "Variant Code");
                    Clear(ItemAvailByLoc);
                    ItemAvailByLoc.LookupMode(false);
                    ItemAvailByLoc.SetRecord(Item);
                    ItemAvailByLoc.SetTableView(Item);
                    if ItemAvailByLoc.RunModal = ACTION::LookupOK then
                        if "Transfer-from Code" <> ItemAvailByLoc.GetLastLocation then
                            if Confirm(
                                 Text010, true, FieldCaption("Transfer-from Code"), "Transfer-from Code",
                                 ItemAvailByLoc.GetLastLocation)
                            then
                                Validate("Transfer-from Code", ItemAvailByLoc.GetLastLocation);
                end;
        end;
    end;

    procedure ContUbicDesdeLineas()
    var
        BinContent: Record "Bin Content";
        transHeader: Record "Transfer Header";
        Location: Record Location;
    begin
        //008
        Clear("Transfer-from Bin Code");
        if (TransHeader."Cod. Ubicacion Alm. Origen" <> '') then begin
            if Location.Get("Transfer-from Code") then begin
                if (Location."Bin Mandatory") and (Location."Require Put-away" = false) and (Location."Require Pick" = false)
                and (Location."Require Receive" = false) and (Location."Require Shipment" = false)
                and (Location."Use Put-away Worksheet" = false) and (Location."Directed Put-away and Pick" = false) then begin
                    BinContent.Reset;
                    BinContent.SetRange("Location Code", "Transfer-from Code");
                    BinContent.SetRange("Bin Code", TransHeader."Cod. Ubicacion Alm. Origen");
                    BinContent.SetRange("Item No.", "Item No.");
                    BinContent.SetRange("Unit of Measure Code", "Unit of Measure Code");
                    if BinContent.FindFirst then
                        Validate("Transfer-from Bin Code", TransHeader."Cod. Ubicacion Alm. Origen");
                end;
            end;
        end;
    end;

    procedure ContUbicHastaLineas()
    var
        BinContent: Record "Bin Content";
        TransHeader: Record "Transfer Header";
        Location: Record Location;
    begin
        //008
        Clear("Transfer-To Bin Code");
        if (TransHeader."Cod. Ubicacion Alm. Destino" <> '') then begin
            if Location.Get("Transfer-to Code") then begin
                if (Location."Bin Mandatory") and (Location."Require Put-away" = false) and (Location."Require Pick" = false)
                and (Location."Require Receive" = false) and (Location."Require Shipment" = false)
                and (Location."Use Put-away Worksheet" = false) and (Location."Directed Put-away and Pick" = false) then begin
                    BinContent.Reset;
                    BinContent.SetRange("Location Code", "Transfer-to Code");
                    BinContent.SetRange("Bin Code", TransHeader."Cod. Ubicacion Alm. Destino");
                    BinContent.SetRange("Item No.", "Item No.");
                    BinContent.SetRange("Unit of Measure Code", "Unit of Measure Code");
                    if BinContent.FindFirst then
                        Validate("Transfer-To Bin Code", TransHeader."Cod. Ubicacion Alm. Destino");
                end;
            end;
        end;
    end;

    procedure ActLinBO()
    var
        TransHeader: Record "Transfer Header";
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
    begin
        //+$010
        TransHeader.Get("Document No.");
        TransHeader.TestField(Status, 0);
        if "Cantidad a Ajustar" > 0 then begin //+$011
            if "Cantidad a Ajustar" > "Cantidad pendiente BO" then
                Error(Error002, FieldCaption("Cantidad a Ajustar"));
            if rec.CalcAvailabilityTL_BackOrder(Rec) >= "Cantidad a Ajustar" then begin
                Quantity += "Cantidad a Ajustar";
                Validate(Quantity);
                //+$011
                //VALIDATE("Cantidad pendiente BO","Cantidad Aprobada" - Quantity);
                "Cantidad pendiente BO" := "Cantidad Aprobada" - Quantity - "Cantidad Anulada";
                if "Cantidad a Anular" > "Cantidad pendiente BO" then
                    "Cantidad a Anular" := "Cantidad pendiente BO";
                //-$011
                "Cantidad a Ajustar" := 0;
            end
            else
                Error(Error006, FieldCaption("Cantidad a Ajustar"));

            //+$011
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
        //-$011
    end;

    local procedure GetItemTransLine(var TransferLine: Record "Transfer Line"): Boolean
    var
        Item: Record Item;
    begin
        //001
        if (TransferLine."Item No." = '') then
            exit(false);

        if TransferLine."Item No." <> Item."No." then
            Item.Get(TransferLine."Item No.");
        exit(true);
    end;

    procedure CalcAvailabilityTL_BackOrder(var TransferLine: Record "Transfer Line"): Decimal
    var
        Item: Record Item;
    begin
        //001
        if GetItemTransLine(TransferLine) then begin
            Item.Reset;
            //Item.SetRange("Date Filter", 0D, AvailabilityDate); // Comentado según el código original
            Item.SetRange("Variant Filter", TransferLine."Variant Code");
            Item.SetRange("Location Filter", TransferLine."Transfer-from Code");
            Item.SetRange("Drop Shipment Filter", false);
            //Item.SetRange("Build Kit Filter", false); // Comentado según el código original

            Item.CalcFields(
                "Qty. on Component Lines",
                "Planning Issues (Qty.)",
                "Qty. on Sales Order",
                "Qty. on Assembly Order",
                "Res. Qty. on Assembly Order",
                "Qty. on Service Order",
                Inventory,
                "Reserved Qty. on Inventory",
                //"Qty. on Pre Sales Order", // Comentado según el código original
                "Trans. Ord. Shipment (Qty.)"
            );

            exit(
                Item.Inventory - Item."Qty. on Sales Order" - Item."Qty. on Assembly Order" -
                Item."Res. Qty. on Assembly Order" - Item."Qty. on Service Order" - Item."Reserved Qty. on Inventory" -
                //Item."Qty. on Pre Sales Order" - // Comentado según el código original
                Item."Trans. Ord. Shipment (Qty.)"
            );
        end;
    end;

    procedure CalcAvailabilityTransLine(var TransferLine: Record "Transfer Line"): Decimal
    var
        AvailabilityDate: Date;
        GrossRequirement: Decimal;
        ScheduledReceipt: Decimal;
        PeriodType: Enum "Analysis Period Type";
        LookaheadDateformula: DateFormula;
        ITEM: Record Item;
        AvailableToPromise: Codeunit "Available to Promise";
    begin
        //001
        if GetItemTransLine(TransferLine) then begin
            if TransferLine."Shipment Date" <> 0D then
                AvailabilityDate := TransferLine."Shipment Date"
            else
                AvailabilityDate := WORKDATE;

            Item.Reset;
            Item.SetRange("Date Filter", 0D, AvailabilityDate);
            Item.SetRange("Variant Filter", TransferLine."Variant Code");
            Item.SetRange("Location Filter", TransferLine."Transfer-from Code");
            Item.SetRange("Drop Shipment Filter", false);

            exit(
                AvailableToPromise.CalcQtyAvailableToPromise(
                    Item,
                    GrossRequirement,
                    ScheduledReceipt,
                    AvailabilityDate,
                    PeriodType,
                    LookaheadDateformula));
        end;
    end;

    var
        AdopcionesDetalle: Record "Colegio - Adopciones Detalle";
        ColNivel: Record "Colegio - Nivel";
        PromotorRuta: Record "Promotor - Rutas";

    var
        "*** Santillana ***": Integer;
        cFuncionesSantillana: Codeunit "Funciones Santillana";
        wImporteDescuento: Decimal;
        NoLinea: Integer;
        rItem: Record Item;
        "**003**": Integer;
        rVPS: Record "VAT Posting Setup";
        rCliente: Record Customer;
        Users: Record "User Setup";
        CantDisp: Decimal;
        Cantidad: Decimal;
        Cust: Record Customer;
        blnAutoModify: Boolean;
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
        confSant: Record "Config. Empresa";
        ValidaCampos: Codeunit "Valida Campos Requeridos";
        ConfAPS: Record "Commercial Setup";
        Cliente: Boolean;
        Error001: Label 'User does not have permision to approve quantities in sales orders';
        Error003: Label 'The current setup does not permit decimals quantities';
        Error002: Label 'Quantity to adjust cannot be grater than Remaining Qty. in BO';
        Error004: Label 'Qty. cannot be negative';
        Text010: Label 'Change %1 from %2 to %3?';
        Error005: Label 'Qty. to Adjust cannot be lower than 0';
        Error006: Label '%1 no puede ser mayor a la Disponibilidad';
}

