table 76175 "Bancos ACH Nomina"
{
    DataPerCompany = false;
    DrillDownPageID = "Bancos Transferencias";
    LookupPageID = "Bancos Transferencias";

    fields
    {
        field(1; "Cod. Banco"; Code[20])
        {
        }
        field(2; Descripcion; Text[30])
        {
        }
        field(3; "Cod. Institucion Financiera"; Code[4])
        {
            Caption = 'Financial Institution Code';
        }
        field(4; "ACH Reservas"; Code[10])
        {
        }
        field(5; "Digito Chequeo"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Cod. Banco")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Cod. Banco", Descripcion, "Cod. Institucion Financiera")
        {
        }
    }
}

