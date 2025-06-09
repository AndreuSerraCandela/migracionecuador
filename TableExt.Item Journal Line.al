tableextension 50166 tableextension50166 extends "Item Journal Line"
{
    fields
    {
        modify("Item No.")
        {
            TableRelation = Item WHERE(Blocked = CONST(false),
                                        Inactivo = CONST(false));
            Description = '#34448';
        }

        //Unsupported feature: Property Modification (Data type) on "Description(Field 8)".

        modify("Location Code")
        {
            TableRelation = Location WHERE(Inactivo = CONST(false));
            Description = '#34448';
        }
        modify("Item Shpt. Entry No.")
        {
            Caption = 'Item Shpt. Entry No.';
        }
        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        modify("New Location Code")
        {
            TableRelation = Location WHERE(Inactivo = CONST(false));
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
        modify("Area")
        {
            Caption = 'Area';
        }
        modify("Job Contract Entry No.")
        {
            Caption = 'Job Contract Entry No.';
        }
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }
        modify("Originally Ordered No.")
        {
            TableRelation = Item WHERE(Inactivo = CONST(false));
            Description = '#34448';
        }
        modify("Invoice-to Source No.")
        {
            TableRelation = IF ("Source Type" = CONST(Customer)) Customer WHERE(Inactivo = CONST(false))
            ELSE
            IF ("Source Type" = CONST(Vendor)) Vendor WHERE(Inactivo = CONST(false));
            Description = '#34448';
        }
        modify("Prod. Order Comp. Line No.")
        {
            TableRelation = IF ("Order Type" = CONST(Production)) "Prod. Order Component"."Line No." WHERE(Status = CONST(Released),
                                                                                                          "Prod. Order No." = FIELD("Order No."),
                                                                                                          "Prod. Order Line No." = FIELD("Order Line No."),
                                                                                                          "Item No." = FIELD("Item No."));
            Caption = 'Prod. Order Comp. Line No.';
        }
        modify("Work Center Group Code")
        {
            Caption = 'Work Center Group Code';
        }
        modify("New Item Expiration Date")
        {
            Caption = 'New Item Expiration Date';
        }

        //Unsupported feature: Code Modification on ""Item No."(Field 3).OnValidate".

        //trigger "(Field 3)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if "Item No." <> xRec."Item No." then begin
          "Variant Code" := '';
          "Bin Code" := '';
        #4..106
                "Unit of Measure Code" := Item."Base Unit of Measure";
            end;
          "Entry Type"::Consumption:
            if FindProdOrderComponent(ProdOrderComp) then
              CopyFromProdOrderComp(ProdOrderComp)
            else begin
              "Unit of Measure Code" := Item."Base Unit of Measure";
              Validate("Prod. Order Comp. Line No.",0);
            end;
        end;

        #118..136

        OnBeforeVerifyReservedQty(Rec,xRec,FieldNo("Item No."));
        ReserveItemJnlLine.VerifyChange(Rec,xRec);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..109
            begin
              ProdOrderComp.SetFilterByReleasedOrderNo("Order No.");
              ProdOrderComp.SetRange("Item No.","Item No.");
              if ProdOrderComp.Count = 1 then begin
                ProdOrderComp.FindFirst;
                CopyFromProdOrderComp(ProdOrderComp);
              end else begin
                "Unit of Measure Code" := Item."Base Unit of Measure";
                Validate("Prod. Order Comp. Line No.",0);
              end;
        #115..139
        */
        //end;


        //Unsupported feature: Code Insertion on ""Gen. Bus. Posting Group"(Field 57)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
        /*

        //001
        if GBPG.Get("Gen. Bus. Posting Group") then
          Promocion := GBPG.Promocion;
        //001
        */
        //end;


        //Unsupported feature: Code Modification on ""Prod. Order Comp. Line No."(Field 5884).OnValidate".

        //trigger  Order Comp()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if "Prod. Order Comp. Line No." <> xRec."Prod. Order Comp. Line No." then begin
          if ("Order Type" = "Order Type"::Production) and ("Prod. Order Comp. Line No." <> 0) then begin
            ProdOrderComponent.Get(
              ProdOrderComponent.Status::Released,"Order No.","Order Line No.","Prod. Order Comp. Line No.");
            if "Item No." <> ProdOrderComponent."Item No." then
              Validate("Item No.",ProdOrderComponent."Item No.");
          end;

          CreateProdDim;
        end;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        if "Prod. Order Comp. Line No." <> xRec."Prod. Order Comp. Line No." then
          CreateProdDim;
        */
        //end;
        field(50000; "No. Paginas"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Componentes Producto"; Text[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Componentes Prod.";
        }
        field(50002; ISBN; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Cod. Procedencia"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Procedencia;
        }
        field(50004; "Cod. Edición"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Edicion;
        }
        field(50005; Areas; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Nivel Educativo"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Nivel Educativo";
        }
        field(50007; Cursos; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Cursos;
        }
        field(50008; "Precio Unitario Cons. Inicial"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Descuento % Cons. Inicial"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Importe Cons. bruto Inicial"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Antes de descuento';
        }
        field(50011; "Importe Cons Neto Inicial"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Despues de descuento';
        }
        field(50012; "No. Mov. Prod. Cosg. a Liq."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Pedido Consignacion"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "Devolucion Consignacion"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50016; "Precio Unitario Cons. Act."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50017; "Descuento % Cons. Actualizado"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50018; "Importe Cons. bruto Act."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50019; "Importe Cons. Neto Actualizado"; Decimal)
        {
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
        field(56022; "Cod. Colegio"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
            TableRelation = Contact;
        }
        field(76046; Barcode; Code[22])
        {
            Caption = 'Barcode';
            DataClassification = ToBeClassified;
            Description = 'DSPOS1.01';

            trigger OnLookup()
            var
                ICR: Record "Item Reference";//"Item Cross Reference";
            begin
                ICR.Reset;
                TestField("Item No.");
                ICR.SetRange("Item No.", "Item No.");
                ICR.FindFirst;

                if PAGE.RunModal(PAGE::"Item References", ICR) = ACTION::LookupOK then begin //"Cross References"
                    Barcode := ICR."Reference No.";
                end;
            end;

            trigger OnValidate()
            var
                ICR: Record "Item Reference";//"Item Cross Reference";
            begin
                ICR.SetCurrentKey("Reference No."); //"Cross-Reference No."
                ICR.SetRange("Reference No.", Barcode);
                ICR.FindFirst;
                Validate("Item No.", ICR."Item No.");
                if ICR."Unit of Measure" <> '' then
                    Validate("Unit of Measure Code", ICR."Unit of Measure");

                if ICR."Variant Code" <> '' then
                    Validate("Variant Code", ICR."Variant Code");
            end;
        }
    }

    //Unsupported feature: Variable Insertion (Variable: ICR) (VariableCollection) on "GetItem(PROCEDURE 2)".



    //Unsupported feature: Code Modification on "GetItem(PROCEDURE 2)".

    //procedure GetItem();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    if Item."No." <> "Item No." then
      Item.Get("Item No.");

    OnAfterGetItemChange(Item,Rec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    if Item."No." <> "Item No." then
      //GRN  Item.GET("Item No."); Para buscar por Producto o Cod. Barras
      if not Item.Get("Item No.") then
         begin
          ICR.SetCurrentKey("Cross-Reference No.");
          ICR.SetRange("Cross-Reference No.","Item No.");
          if ICR.FindFirst then;
          Item.Get(ICR."Item No.")
         end;

    OnAfterGetItemChange(Item,Rec);
    */
    //end;

    //Unsupported feature: Variable Insertion (Variable: rSalesHeader) (VariableCollection) on "CopyFromSalesLine(PROCEDURE 12)".



    //Unsupported feature: Code Modification on "CopyFromSalesLine(PROCEDURE 12)".

    //procedure CopyFromSalesLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Item No." := SalesLine."No.";
    Description := SalesLine.Description;
    "Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
    "Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
    "Dimension Set ID" := SalesLine."Dimension Set ID";
    "Location Code" := SalesLine."Location Code";
    "Bin Code" := SalesLine."Bin Code";
    #8..36
    "Invoice-to Source No." := SalesLine."Bill-to Customer No.";

    OnAfterCopyItemJnlLineFromSalesLine(Rec,SalesLine);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..4

    //004
    rSalesHeader.Get(SalesLine."Document Type",SalesLine."Document No.");
    if rSalesHeader."Pedido Consignacion" then begin
      "Precio Unitario Cons. Inicial" := SalesLine."Unit Price";
      "Descuento % Cons. Inicial"     := SalesLine."Line Discount %";
      "Importe Cons. bruto Inicial"   := (SalesLine."Unit Price" * SalesLine."Qty. to Invoice");
      "Importe Cons Neto Inicial"    := ("Importe Cons. bruto Inicial" - SalesLine."Line Discount Amount")      ;
      "No. Mov. Prod. Cosg. a Liq."  := SalesLine."No. Mov. Prod. Cosg. a Liq.";
      "Pedido Consignacion"          := true;
    end;
    //004

    //014
    "No aplica Derechos de Autor" := rSalesHeader."No aplica Derechos de Autor";
    "Cod. Colegio" := rSalesHeader."Cod. Colegio";
    //014

    #5..39
    */
    //end;


    //Unsupported feature: Code Modification on "CopyFromServHeader(PROCEDURE 59)".

    //procedure CopyFromServHeader();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Document Date" := ServiceHeader."Document Date";
    "Order Date" := ServiceHeader."Order Date";
    "Source Posting Group" := ServiceHeader."Customer Posting Group";
    "Salespers./Purch. Code" := ServiceHeader."Salesperson Code";
    "Reason Code" := ServiceHeader."Reason Code";
    "Source Type" := "Source Type"::Customer;
    "Source No." := ServiceHeader."Customer No.";
    "Shpt. Method Code" := ServiceHeader."Shipment Method Code";

    if ServiceHeader.IsCreditDocType then
      "Country/Region Code" := ServiceHeader."Country/Region Code"
    else
      if ServiceHeader."Ship-to Country/Region Code" <> '' then
        "Country/Region Code" := ServiceHeader."Ship-to Country/Region Code"
      else
        "Country/Region Code" := ServiceHeader."Country/Region Code";

    OnAfterCopyItemJnlLineFromServHeader(Rec,ServiceHeader);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..4
    "Country/Region Code" := ServiceHeader."VAT Country/Region Code";
    #5..9
    OnAfterCopyItemJnlLineFromServHeader(Rec,ServiceHeader);
    */
    //end;

    var
        GBPG: Record "Gen. Business Posting Group";
}

