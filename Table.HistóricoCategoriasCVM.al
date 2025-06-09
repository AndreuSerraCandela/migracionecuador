table 76233 "Histórico Categorias CVM"
{

    fields
    {
        field(1; "Campaña"; Code[4])
        {
            Editable = false;
        }
        field(2; "Cod. Colegio"; Code[20])
        {
            Editable = false;
        }
        field(3; "Grupo Negocio"; Code[20])
        {
            Editable = false;
        }
        field(4; "Cod. Nivel"; Code[20])
        {
            Editable = false;
        }
        field(5; Categoria; Code[3])
        {
        }
        field(6; "Nombre Colegio"; Text[100])
        {
            Editable = false;
        }
        field(7; "Cod. Delegacion"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Campaña", "Cod. Colegio", "Grupo Negocio", "Cod. Nivel")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

