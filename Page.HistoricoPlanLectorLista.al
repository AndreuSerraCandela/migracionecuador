page 76247 "Historico Plan Lector Lista"
{
    ApplicationArea = all;
    CardPageID = "Historico Plan Lector Ficha";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Historico Plan Lector Cab.";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Campaña"; rec.Campaña)
                {
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                }
                field("Cod. Local"; rec."Cod. Local")
                {
                }
                field("Descripcion Local"; rec."Descripcion Local")
                {
                }
                field("Cod. Turno"; rec."Cod. Turno")
                {
                }
                field("Descripcion Turno"; rec."Descripcion Turno")
                {
                }
                field(Distrito; rec.Distrito)
                {
                }
                field("Cod. Delegacion"; rec."Cod. Delegacion")
                {
                }
                field("Descripción Delegacion"; rec."Descripción Delegacion")
                {
                }
            }
        }
    }

    actions
    {
    }
}

