table 76426 "Nivel Educativo APS"
{
    DrillDownPageID = "Nivel Educativo APS";
    LookupPageID = "Nivel Educativo APS";

    fields
    {
        field(1; "Código"; Code[20])
        {
        }
        field(2; "Descripción"; Text[100])
        {
        }
        field(3; "Verificación cruzada"; Boolean)
        {
        }
        field(4; "Filtros Combinaciones Niveles"; Code[30])
        {
        }
        field(5; "Grupo de Negocio"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST ("Grupo de Negocio"));
        }
    }

    keys
    {
        key(Key1; "Código")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Código", "Descripción")
        {
        }
    }
}

