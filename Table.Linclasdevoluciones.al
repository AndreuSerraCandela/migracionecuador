table 56026 "Lin. clas. devoluciones"
{
    // 001 #11460 CAT Permitir predevoluciones a todos los clientes

    Caption = 'Returns classification lines';

    fields
    {
        field(1; "No. Documento"; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Receiving date"; Date)
        {
            Caption = 'Receiving date';
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            NotBlank = true;
            TableRelation = Item WHERE(Inactivo = CONST(false));

            trigger OnValidate()
            begin
                Item.Get("Item No.");
                "Item Description" := Item.Description;
                "Unit of Measure Code" := Item."Base Unit of Measure";
            end;
        }
        field(5; "Item Description"; Text[60])
        {
            Caption = 'Item Description';
            Editable = false;
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            InitValue = 1;
            NotBlank = true;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
                if Quantity <= 0 then
                    Error(Err001);
            end;
        }
        field(7; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';

            trigger OnValidate()
            var
                UnitOfMeasureTranslation: Record "Unit of Measure Translation";
                ResUnitofMeasure: Record "Resource Unit of Measure";
            begin
            end;
        }
        field(8; "Cross-Reference No."; Code[20])
        {
            Caption = 'EAN';

            trigger OnLookup()
            begin
                CrossReferenceNoLookUp;
            end;

            trigger OnValidate()
            var
                ReturnedCrossRef: Record "Item Reference";
            begin
                ReturnedCrossRef.Init;
                if "Cross-Reference No." <> '' then begin
                    ReturnedCrossRef.SetRange("Reference No.", "Cross-Reference No.");
                    ReturnedCrossRef.FindFirst;
                    Validate("Item No.", ReturnedCrossRef."Item No.");
                    if ReturnedCrossRef."Unit of Measure" <> '' then
                        Validate("Unit of Measure Code", ReturnedCrossRef."Unit of Measure");

                    if ReturnedCrossRef."Variant Code" <> '' then
                        Validate("Variant Code", ReturnedCrossRef."Variant Code");
                end;
                /*
                IF ReturnedCrossRef."quantity" <> '' THEN
                   Quantity := ReturnedCrossRef."quantity";
                
                IF ReturnedCrossRef."item no." <> '' THEN
                  "Item No." := ReturnedCrossRef."item no.";
                */

            end;
        }
        field(9; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            NotBlank = true;
            TableRelation = Customer;

            trigger OnValidate()
            var
                Cust: Record Customer;
            begin
                Cust.Get("Customer No.");
                //+001
                //Cust.TESTFIELD("Cod. Almacen Consignacion");
                //-001
                "Customer name" := Cust.Name;
                "Cod. Almacen Consignacion" := Cust."Cod. Almacen Consignacion";
            end;
        }
        field(10; "Customer name"; Text[75])
        {
            Caption = 'Customer name';
            Description = '#56924';
            Editable = false;
        }
        field(11; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(12; Inventory; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                  "Variant Code" = FIELD("Variant Filter"),
                                                                  "Location Code" = FIELD("Location Filter")));
            Caption = 'Quantity on Hand';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Inventario en Consignacion"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                  "Location Code" = FIELD("Cod. Almacen Consignacion"),
                                                                  "Posting Date" = FIELD("Date Filter")));
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
        }
        field(14; "Cod. Almacen Consignacion"; Code[20])
        {
            TableRelation = Location;
        }
        field(15; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(16; "Location Filter"; Code[10])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(17; "Variant Filter"; Code[10])
        {
            Caption = 'Variant Filter';
            FieldClass = FlowFilter;
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(18; "Receiving Time"; Time)
        {
        }
        field(19; Processed; Boolean)
        {
            Caption = 'Processed';
        }
        field(21; "External Doc. Number"; Code[20])
        {
            Caption = 'External Doc. Number';
        }
        field(22; Comentario; Text[250])
        {
        }
        field(23; "Con defecto"; Boolean)
        {
        }
        field(24; Recuperable; Boolean)
        {
        }
        field(25; "Cod. auditoria dev."; Code[10])
        {
            Caption = 'Cód. auditoria dev.';
            Description = '#48474';
            TableRelation = "Return Reason";
        }
    }

    keys
    {
        key(Key1; "No. Documento", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Receiving date" := Today;
        "Receiving Time" := Time;
    end;

    trigger OnModify()
    begin
        //TESTFIELD("Cross-Reference No.");
    end;

    var
        Item: Record Item;
        Err001: Label 'The quanitty to return can not be equal or less than zero';


    procedure CrossReferenceNoLookUp()
    var
        ItemCrossReference: Record "Item Reference";
        ICGLAcc: Record "IC G/L Account";
    begin
        ItemCrossReference.Reset;
        ItemCrossReference.SetCurrentKey("Reference No.");
        ItemCrossReference.SetRange("Reference No.", "Cross-Reference No.");

        if PAGE.RunModal(PAGE::"Item References", ItemCrossReference) = ACTION::LookupOK then
            Validate("Cross-Reference No.", ItemCrossReference."Reference No.");
    end;
}

