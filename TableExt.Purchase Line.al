tableextension 50073 tableextension50073 extends "Purchase Line"
{
    fields
    {
        modify("Buy-from Vendor No.")
        {
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
            IF (Type = CONST("Fixed Asset")) "Fixed Asset" WHERE(Inactive = CONST(false))
            ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge"
            ELSE
            IF (Type = CONST(Item),
                                                                                                                 "Document Type" = FILTER(<> "Credit Memo" & <> "Return Order")) Item WHERE(Blocked = CONST(false),
                                                                                                                                                                                       "Purchasing Blocked" = CONST(false),
                                                                                                                                                                                       Inactivo = CONST(false))
            ELSE
            IF (Type = CONST(Item),
                                                                                                                                                                                                "Document Type" = FILTER("Credit Memo" | "Return Order")) Item WHERE(Blocked = CONST(false),
                                                                                                                                                                                                                                                                  Inactivo = CONST(false));
            Description = '#34448, 003';

            trigger OnAfterValidate()
            begin

                // Actualizar ITBIS si aplica
                ActualizarITBIS; //004 jpg actualizar ITBIS COSTO
            end;
        }
        modify("Location Code")
        {
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false),
                                            Inactivo = CONST(false));
            Description = '#34448';
            trigger OnAfterValidate()
            var
                PurchSetup: Record "Purchases & Payables Setup";
                Location: Record Location;
                Item: Record Item;
                GLAccount: Record "G/L Account";
            begin

                // Obtener configuración de compras y validar el área fiscal del proveedor
                PurchSetup.Get;
                // if PurchSetup."Use Vendor's Tax Area Code" then
                //     ActualizarITBIS; //004 jpg actualizar ITBIS COSTO

            end;
        }
        modify(Description)
        {
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
                                                                                                                                                                                                   "Purchasing Blocked" = CONST(false))
            ELSE
            IF (Type = CONST(Item),
                                                                                                                                                                                                            "Document Type" = FILTER("Credit Memo" | "Return Order")) Item.Description WHERE(Blocked = CONST(false))
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset".Description
            ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge".Description;
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
        modify("Qty. Rcd. Not Invoiced")
        {
            Caption = 'Qty. Rcd. Not Invoiced';
        }
        modify("Pay-to Vendor No.")
        {
            TableRelation = Vendor WHERE(Inactivo = CONST(false));
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
            trigger OnAfterValidate()
            var
                VPPG: Record "VAT Product Posting Group";
            begin
                // Validar que el estado sea "Open"
                // Lógica adicional: Asignar valor a "Propina" basado en el grupo de publicación de IVA
                if VPPG.Get("VAT Prod. Posting Group") then
                    Propina := VPPG.Propina
                else
                    Propina := false;
            end;
        }
        modify("IC Partner Ref. Type")
        {
            Caption = 'IC Partner Ref. Type';
        }
        modify("Job Line Discount Amount")
        {
            Caption = 'Job Line Discount Amount';
        }
        modify("Job Unit Price (LCY)")
        {
            Caption = 'Job Unit Price ($)';
        }
        modify("Job Total Price (LCY)")
        {
            Caption = 'Job Total Price ($)';
        }
        modify("Job Line Amount (LCY)")
        {
            Caption = 'Job Line Amount ($)';
        }
        modify("Job Line Disc. Amount (LCY)")
        {
            Caption = 'Job Line Disc. Amount ($)';
        }
        modify("Job Planning Line No.")
        {
            Caption = 'Job Planning Line No.';
        }
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }
        modify("Depr. until FA Posting Date")
        {
            Caption = 'Depr. until FA Posting Date';
        }
        modify("Duplicate in Depreciation Book")
        {
            Caption = 'Duplicate in Depreciation Book';
        }
        modify("Whse. Outstanding Qty. (Base)")
        {
            Caption = 'Whse. Outstanding Qty. (Base)';
        }
        modify("Return Shipment Line No.")
        {
            Caption = 'Return Shipment Line No.';
        }





        modify("Indirect Cost %")
        {
            trigger OnAfterValidate()
            begin

                if Type = Type::"Charge (Item)" then
                    TestField("Indirect Cost %", 0);

                // Actualizar el costo unitario
                UpdateUnitCost;
            end;
        }


        modify("Blanket Order Line No.")
        {
            trigger OnAfterValidate()
            var
                PurchLine2: Record "Purchase Line";
            begin
                // Validar que la cantidad recibida sea 0
                TestField("Quantity Received", 0);

                // Si el número de línea de pedido abierto no es 0, realizar validaciones
                if "Blanket Order Line No." <> 0 then begin
                    PurchLine2.Get("Document Type"::"Blanket Order", "Blanket Order No.", "Blanket Order Line No.");
                    PurchLine2.TestField(Type, Type);
                    PurchLine2.TestField("No.", "No.");
                    PurchLine2.TestField("Pay-to Vendor No.", "Pay-to Vendor No.");
                    PurchLine2.TestField("Buy-from Vendor No.", "Buy-from Vendor No.");

                    // Validar campos adicionales si es un envío directo o pedido especial
                    if "Drop Shipment" or "Special Order" then begin
                        PurchLine2.TestField("Variant Code", "Variant Code");
                        PurchLine2.TestField("Location Code", "Location Code");
                        PurchLine2.TestField("Unit of Measure Code", "Unit of Measure Code");
                    end;

                    // Validar el costo directo y el descuento de línea
                    Validate("Direct Unit Cost", PurchLine2."Direct Unit Cost");
                    Validate("Line Discount %", PurchLine2."Line Discount %");
                end;
            end;
        }
        field(55001; "Punto de Emision Reembolso"; Code[3])
        {
            Caption = 'Punto de Emisión Reembolso';
            DataClassification = ToBeClassified;
            Description = '#14564';
        }
        field(55002; "Establecimiento Reembolso"; Code[3])
        {
            Caption = 'Establecimiento Reembolso';
            DataClassification = ToBeClassified;
            Description = '#14564';
        }
        field(55003; "No. Comprobante Reembolso"; Code[30])
        {
            Caption = 'Fiscal Document No.';
            DataClassification = ToBeClassified;
            Description = '#14564';
        }
        field(55004; "No. Autorizacion Reembolso"; Code[49])
        {
            Caption = 'Nº Autorización Reembolso';
            DataClassification = ToBeClassified;
            Description = '#14564';
        }
        field(55012; "Parte del IVA"; Boolean)
        {
            Caption = 'VAT part';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55013; Propina; Boolean)
        {
            Caption = 'Tips';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(76014; "Cod. Colegio"; Code[20])
        {
            Caption = 'School Code';
            DataClassification = ToBeClassified;
            Description = 'APS';
            TableRelation = Contact WHERE(Type = FILTER(Company));
        }
        field(76422; "Cod. Vendedor"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate()
            var
                DefDim: Record "Default Dimension";
                Vendedor: Record "Salesperson/Purchaser";
                TempDimSetEntry: Record "Dimension Set Entry" temporary;
                DimVal: Record "Dimension Value";
                DimMgt: Codeunit DimensionManagement;
            begin
                if "Cod. Vendedor" <> '' then begin
                    Vendedor.Get("Cod. Vendedor");
                    DefDim.Reset;
                    DefDim.SetRange("Table ID", 13);
                    DefDim.SetRange("No.", "Cod. Vendedor");
                    if DefDim.FindSet then begin
                        DimMgt.GetDimensionSet(TempDimSetEntry, "Dimension Set ID");
                        repeat
                            DimVal.Get(DefDim."Dimension Code", DefDim."Dimension Value Code");
                            if TempDimSetEntry.Get("Dimension Set ID", DefDim."Dimension Code") then
                                TempDimSetEntry.Delete;
                            TempDimSetEntry.Init;
                            TempDimSetEntry."Dimension Set ID" := "Dimension Set ID";
                            TempDimSetEntry."Dimension Code" := DefDim."Dimension Code";
                            TempDimSetEntry."Dimension Value Code" := DefDim."Dimension Value Code";
                            TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
                            TempDimSetEntry.Insert;
                        until DefDim.Next = 0;
                        "Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
                        Modify;
                    end;
                end;
            end;
        }
        field(76127; "Cod. Taller"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
            TableRelation = Talleres.Codigo;
        }
    }


    trigger OnDelete()
    var
        DeferralUtilities: Codeunit "Deferral Utilities";
    begin
        // Validar que el estado sea "Open"


        // Restablecer cantidades y montos relacionados
        Quantity := 0;
        "Quantity (Base)" := 0;
        "Qty. to Invoice" := 0;
        "Qty. to Invoice (Base)" := 0;
        "Line Discount Amount" := 0;
        "Inv. Discount Amount" := 0;
        "Inv. Disc. Amount to Invoice" := 0;


    end;

    trigger OnInsert()
    var
        Purchheader: Record "Purchase Header";
    begin
        // Validar que el estado sea "Open"
        TestStatusOpen;


        // Actualizar montos de diferimiento si aplica
        if ("Deferral Code" <> '') and (GetDeferralAmount <> 0) then
            UpdateDeferralAmounts;

        // Configurar el campo "IRS 1099 Liable" basado en el encabezado de compras
        //"IRS 1099 Liable" := (PurchHeader. "IRS 1099 Code" <> '');

        // Lógica adicional: Validar "Cod. Vendedor" si no está vacío
        if "Cod. Vendedor" <> '' then
            Validate("Cod. Vendedor");

        // Asignar "Cod. Colegio" si el encabezado tiene activado el rappel
        if PurchHeader.Rappel then
            "Cod. Colegio" := PurchHeader."Cod. Colegio";
    end;

    //Unsupported feature: Code Modification on "InitQtyToReceive(PROCEDURE 15)".

    //procedure InitQtyToReceive();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    GetPurchSetup;
    if (PurchSetup."Default Qty. to Receive" = PurchSetup."Default Qty. to Receive"::Remainder) or
       ("Document Type" = "Document Type"::Invoice)
    then begin
      "Qty. to Receive" := "Outstanding Quantity";
      "Qty. to Receive (Base)" := "Outstanding Qty. (Base)";
    end else
      if "Qty. to Receive" <> 0 then
        "Qty. to Receive (Base)" := MaxQtyToReceiveBase(CalcBaseQty("Qty. to Receive"));

    OnAfterInitQtyToReceive(Rec,CurrFieldNo);

    InitQtyToInvoice;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..8
        "Qty. to Receive (Base)" := CalcBaseQty("Qty. to Receive");
    #10..13
    */
    //end;


    //Unsupported feature: Code Modification on "CopyFromItemCharge(PROCEDURE 107)".

    //procedure CopyFromItemCharge();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ItemCharge.Get("No.");
    Description := ItemCharge.Description;
    "Gen. Prod. Posting Group" := ItemCharge."Gen. Prod. Posting Group";
    #4..6
    "Allow Item Charge Assignment" := false;
    "Indirect Cost %" := 0;
    "Overhead Rate" := 0;
    OnAfterAssignItemChargeValues(Rec,ItemCharge);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..9

    "Parte del IVA" := ItemCharge."Parte del IVA";//001

    OnAfterAssignItemChargeValues(Rec,ItemCharge);
    */
    //end;


    //Unsupported feature: Code Modification on "UpdateVATAmounts(PROCEDURE 38)".

    //procedure UpdateVATAmounts();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    OnBeforeUpdateVATAmounts(Rec);

    GetPurchHeader;
    #4..33
        PurchLine2.SetFilter("VAT %",'<>0');
        if not PurchLine2.IsEmpty then begin
          PurchLine2.CalcSums(
            "Line Amount","Inv. Discount Amount",Amount,"Amount Including VAT","Quantity (Base)","VAT Difference",
            "Tax To Be Expensed");
          TotalLineAmount := PurchLine2."Line Amount";
          TotalInvDiscAmount := PurchLine2."Inv. Discount Amount";
          TotalAmount := PurchLine2.Amount;
          TotalAmountInclVAT := PurchLine2."Amount Including VAT";
          TotalVATDifference := PurchLine2."VAT Difference";
          TotalQuantityBase := PurchLine2."Quantity (Base)";
          TotalExpenseTax := PurchLine2."Tax To Be Expensed";
          OnAfterUpdateTotalAmounts(Rec,PurchLine2,TotalAmount,TotalAmountInclVAT,TotalLineAmount,TotalInvDiscAmount);
    #47..111
                Round(
                  (TotalAmount + Amount) * (1 - PurchHeader."VAT Base Discount %" / 100) * "VAT %" / 100,
                  Currency."Amount Rounding Precision",Currency.VATRoundingDirection) -
                TotalAmountInclVAT + TotalVATDifference;
            end;
          "VAT Calculation Type"::"Full VAT":
            begin
    #119..150
    end;

    OnAfterUpdateVATAmounts(Rec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..36
            "Line Amount","Inv. Discount Amount",Amount,"Amount Including VAT","Quantity (Base)","Tax To Be Expensed");
    #39..42
    #44..114
                TotalAmountInclVAT;
    #116..153
    */
    //end;


    //Unsupported feature: Code Modification on "UpdateVATOnLines(PROCEDURE 32)".

    //procedure UpdateVATOnLines();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    LineWasModified := false;
    if QtyType = QtyType::Shipping then
      exit;
    #4..13
      LockTable;
      if FindSet then
        repeat
          if not ZeroAmountLine(QtyType) and
             ((PurchHeader."Document Type" <> PurchHeader."Document Type"::Invoice) or ("Prepmt. Amt. Inv." = 0))
          then begin
            DeferralAmount := GetDeferralAmount;
            VATAmountLine.Get("VAT Identifier","VAT Calculation Type","Tax Group Code","Tax Area Code","Use Tax","Line Amount" >= 0);
            if VATAmountLine.Modified then begin
    #23..142
    end;

    OnAfterUpdateVATOnLines(PurchHeader,PurchLine,VATAmountLine,QtyType);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..16
          if not ZeroAmountLine(QtyType) then begin
    #20..145
    */
    //end;


    //Unsupported feature: Code Modification on "UpdateBaseAmounts(PROCEDURE 173)".

    //procedure UpdateBaseAmounts();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    Amount := NewAmount;
    "Amount Including VAT" := NewAmountIncludingVAT;
    "VAT Base Amount" := NewVATBaseAmount;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3
    if not PurchHeader."Prices Including VAT" and (Amount > 0) and (Amount < "Prepmt. Line Amount") then
      "Prepmt. Line Amount" := Amount;
    if PurchHeader."Prices Including VAT" and ("Amount Including VAT" > 0) and ("Amount Including VAT" < "Prepmt. Line Amount") then
      "Prepmt. Line Amount" := "Amount Including VAT";
    */
    //end;


    //Unsupported feature: Code Modification on "UpdatePrepmtAmounts(PROCEDURE 206)".

    //procedure UpdatePrepmtAmounts();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    if "Prepayment %" <> 0 then begin
      if Quantity < 0 then
        FieldError(Quantity,StrSubstNo(Text043,FieldCaption("Prepayment %")));
      if "Direct Unit Cost" < 0 then
        FieldError("Direct Unit Cost",StrSubstNo(Text043,FieldCaption("Prepayment %")));
    end;
    if PurchHeader."Document Type" <> PurchHeader."Document Type"::Invoice then begin
      "Prepayment VAT Difference" := 0;
      if not PrePaymentLineAmountEntered then begin
        "Prepmt. Line Amount" := Round("Line Amount" * "Prepayment %" / 100,Currency."Amount Rounding Precision");
        if Abs("Inv. Discount Amount" + "Prepmt. Line Amount") > Abs("Line Amount") then
          "Prepmt. Line Amount" := "Line Amount" - "Inv. Discount Amount";
      end;
      if "Prepmt. Line Amount" < "Prepmt. Amt. Inv." then begin
        if IsServiceCharge then
          Error(CannotChangePrepaidServiceChargeErr);
    #17..30
          FieldError("Line Amount",StrSubstNo(Text038,xRec."Line Amount"));
        FieldError("Line Amount",StrSubstNo(Text039,xRec."Line Amount"));
      end;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..8
      if not PrePaymentLineAmountEntered then
        "Prepmt. Line Amount" := Round("Line Amount" * "Prepayment %" / 100,Currency."Amount Rounding Precision");
    #14..33
    */
    //end;

    procedure ActualizarITBIS()
    var
        Item: Record Item;
        GLAccount: Record "G/L Account";
        GLSetup: Record "General Ledger Setup";
        PurchHeader: Record "Purchase Header";
        Location: Record Location;
    begin

        // 002 JPG  config. de ITBIS Activa y cambiar el Gpo. Contable ++

        GLSetup.Get;
        if not GLSetup."ITBIS al costo activo" then
            exit;

        PurchHeader.Get("Document Type", "Document No.");

        if (PurchHeader."Tipo ITBIS" = PurchHeader."Tipo ITBIS"::"ITBIS Adelantado") and
           ("No." <> '') and ("Location Code" <> '') and (Type = Type::Item) then //Item
           begin
            Location.Get("Location Code");
            Location.TestField("VAT Prod. Posting Group");
            if "VAT Prod. Posting Group" <> Location."VAT Prod. Posting Group" then begin
                Validate("VAT Prod. Posting Group", Location."VAT Prod. Posting Group");
            end;
        end
        else
            if (Type = Type::Item) and ("No." <> '') then begin
                Item.Get("No.");
                if "VAT Prod. Posting Group" <> Item."VAT Prod. Posting Group" then begin
                    Validate("VAT Prod. Posting Group", Item."VAT Prod. Posting Group");
                end;
            end;

        if (PurchHeader."Tipo ITBIS" = PurchHeader."Tipo ITBIS"::"ITBIS al costo") //"G/L Account"
           and (Type = Type::"G/L Account") and ("No." <> '') then begin
            GLAccount.Get("No.");
            GLAccount.TestField("VAT Prod. Posting G. TipoITBIS");
            if "VAT Prod. Posting Group" <> GLAccount."VAT Prod. Posting G. TipoITBIS" then begin
                Validate("VAT Prod. Posting Group", GLAccount."VAT Prod. Posting G. TipoITBIS");
            end
        end
        else
            if (Type = Type::"G/L Account") and ("No." <> '') then begin
                GLAccount.Get("No.");
                GLAccount.TestField("VAT Prod. Posting Group");
                if "VAT Prod. Posting Group" <> GLAccount."VAT Prod. Posting Group" then begin
                    Validate("VAT Prod. Posting Group", GLAccount."VAT Prod. Posting Group");
                end
            end;

        //004 JPG  config. de ITBIS Activa y cambiar el Gpo. Contable --

    end;

    //Unsupported feature: Deletion (VariableCollection) on "UpdateVATAmounts(PROCEDURE 38).TotalVATDifference(Variable 1006)".


    var
        ICPartner: Record "IC Partner";
        ItemCrossReference: Record "Item Reference";


    var
        ItemChar: Record "Item Charge";
        VPPG: Record "VAT Product Posting Group";
}

