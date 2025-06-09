table 51001 "Lista de Choferes"
{
/*     DrillDownPageID = 51001;
    LookupPageID = 51001; */

    fields
    {
        field(1; Codigo; Code[10])
        {
        }
        field(2; "Nombre Completo"; Text[100])
        {
        }
        field(3; "ID de la Empresa"; Code[10])
        {
        }
        field(4; "ID Documento"; Code[10])
        {
        }
        field(5; Telefono; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; Codigo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

