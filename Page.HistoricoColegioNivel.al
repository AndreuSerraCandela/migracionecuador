page 76243 "Historico Colegio - Nivel"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Historico Colegio - Nivel";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Cod. Local"; rec."Cod. Local")
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field(Turno; rec.Turno)
                {
                }
                field("Categoria colegio"; rec."Categoria colegio")
                {
                }
                field(Ruta; rec.Ruta)
                {
                }
                field("Dto. Ticket Colegio"; rec."Dto. Ticket Colegio")
                {
                }
                field("Dto. Ticket Padres"; rec."Dto. Ticket Padres")
                {
                }
                field("Dto. Feria Colegio"; rec."Dto. Feria Colegio")
                {
                }
                field("Dto. Feria Padres"; rec."Dto. Feria Padres")
                {
                }
                field(Adoptado; rec.Adoptado)
                {
                }
                field("Estatus observado"; rec."Estatus observado")
                {
                }
                field(City; rec.City)
                {
                }
                field("Post Code"; rec."Post Code")
                {
                }
                field(County; rec.County)
                {
                }
                field("Cod. Promotor"; rec."Cod. Promotor")
                {
                }
                field("Dto. Docente"; rec."Dto. Docente")
                {
                }
                field(Campana; rec.Campana)
                {
                }
                field("Distrito Code"; rec."Distrito Code")
                {
                }
                field(Departamento; rec.Departamento)
                {
                }
                field(Distritos; rec.Distritos)
                {
                }
                field(Provincia; rec.Provincia)
                {
                }
                field("Territory Code"; rec."Territory Code")
                {
                }
                field("Country/Region Code"; rec."Country/Region Code")
                {
                }
                field("Codigo Postal"; rec."Codigo Postal")
                {
                }
            }
        }
    }

    actions
    {
    }
}

