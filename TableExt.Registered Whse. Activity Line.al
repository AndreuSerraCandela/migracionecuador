tableextension 50122 tableextension50122 extends "Registered Whse. Activity Line"
{
    fields
    {
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }

        //Unsupported feature: Property Modification (Data type) on "Description(Field 18)".


        //Unsupported feature: Property Modification (Data type) on ""Description 2"(Field 19)".

        field(50000; "No. Packing"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "No. Caja"; Code[20])
        {
            Caption = 'Box No.';
            DataClassification = ToBeClassified;
        }
        field(50002; "No. Linea Packing"; Integer)
        {
            Caption = 'Packing Line No.';
            DataClassification = ToBeClassified;
        }
        field(50003; "No. Packing Registrado"; Code[20])
        {
            Caption = 'Posted Packing No.';
            DataClassification = ToBeClassified;
        }
        field(50004; "Packing Completado"; Boolean)
        {
            Caption = 'Packing Completed';
            DataClassification = ToBeClassified;
        }
        field(50005; "Cantidad Empacada"; Decimal)
        {
            CalcFormula = Sum("Contenido Cajas Packing Reg.".Cantidad WHERE("No. Producto" = FIELD("Item No."),
                                                                             "No. Picking" = FIELD("No.")));
            Caption = 'Qty. Packed';
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(Key6; "No. Packing")
        {
        }
        key(Key7; "Source Document", "Source No.")
        {
        }
        key(Key8; "No.", "Source Document", "Source No.")
        {
        }
    }
}

