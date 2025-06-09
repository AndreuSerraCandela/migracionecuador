tableextension 50149 tableextension50149 extends "Posted Whse. Receipt Line"
{
    fields
    {
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }

        //Unsupported feature: Property Modification (Data type) on "Description(Field 32)".


        //Unsupported feature: Property Modification (Data type) on ""Description 2"(Field 33)".

        field(50001; "Nº Documento Proveedor"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '#967 - Ecuador';
        }
        field(50002; "Nº Proveedor"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '#967 - Ecuador';
            TableRelation = Vendor;
        }
    }
    keys
    {
        key(KeyReports; "Nº Documento Proveedor", "Nº Proveedor")
        {
        }
    }
}

