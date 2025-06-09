table 51014 "Vendedores por Colegio"
{
    Caption = 'School SalesPerson';
    DrillDownPageID = "Vendedores por Colegio";
    LookupPageID = "Vendedores por Colegio";

    fields
    {
        field(1; "Cod. Colegio"; Code[20])
        {
            Caption = 'School Code';
        }
        field(2; "Cod. Vendedor"; Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate()
            begin
                if rSalesPerson.Get("Cod. Vendedor") then
                    "Nombre Vendedor" := rSalesPerson.Name;
            end;
        }
        field(3; "Nombre Vendedor"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Cod. Colegio", "Cod. Vendedor")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        rSalesPerson: Record "Salesperson/Purchaser";
}

