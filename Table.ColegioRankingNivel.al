table 76275 "Colegio - Ranking - Nivel"
{
    DrillDownPageID = "Colegio - Nivel";
    LookupPageID = "Colegio - Nivel";

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
        field(3; "Cod. Nivel"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Nivel Educativo APS"."Código";
        }
        field(4; "Categoria colegio"; Code[4])
        {
            NotBlank = true;
        }
    }

    keys
    {
        key(Key1; "Cod. Colegio", "Grupo de Negocio", "Cod. Nivel")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        ConfAPS: Record "Commercial Setup";
        Col: Record Contact;
        PostCode: Record "Post Code";
        DA: Record "Datos auxiliares";
        "P-LC": Record "Promotor - Lista de Colegios";
        "P-Ruta": Record "Promotor - Rutas";
        RD: Record "Rutas - CP";
        Nivel: Record "Nivel Educativo";
        Turnos: Page Turnos;
        Rutas: Page "Rutas - Distribucion Geo.";
        Rutas2: Page Rutas;
}

