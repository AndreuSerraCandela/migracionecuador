table 76135 "Ranking CVM Colegio"
{
    Caption = 'Estadistica Ranking Colegio';
    DrillDownPageID = "Niveles de desicion";
    LookupPageID = "Niveles de desicion";

    fields
    {
        field(1; "Cod. Colegio"; Code[20])
        {
            NotBlank = true;
            TableRelation = Contact WHERE (Type = CONST (Company));
        }
        field(2; "Grupo de Negocio"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST ("Grupo de Negocio"));
        }
        field(3; "CVM GN"; Code[3])
        {
        }
        field(4; INI; Code[3])
        {
        }
        field(5; PRI; Code[3])
        {
        }
        field(6; SEC; Code[3])
        {
        }
        field(7; "% Compra"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Cod. Colegio", "Grupo de Negocio", "CVM GN")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

