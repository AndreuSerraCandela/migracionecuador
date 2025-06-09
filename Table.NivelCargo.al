table 76054 "Nivel Cargo"
{
    Caption = 'Job type levels';
    DataPerCompany = false;
    DrillDownPageID = "Niveles puestos laborales";
    LookupPageID = "Niveles puestos laborales";

    fields
    {
        field(2; "Cod. Nivel"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Descripcion; Text[30])
        {
        }
        field(4; "Importe mínimo"; Decimal)
        {
            Caption = 'Minimum amount';
        }
        field(5; "Importe máximo"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Importe Medio"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Cod. Nivel")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Cod. Nivel", Descripcion, "Importe mínimo", "Importe Medio", "Importe máximo")
        {
        }
    }
}

