page 76110 "Atenciones Colegios"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Colegio - Atenciones";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Atencion"; rec."Cod. Atencion")
                {
                    Visible = false;
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Cod. promotor"; rec."Cod. promotor")
                {
                }
                field("Cod. Delegacion"; rec."Cod. Delegacion")
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field("Cod. Turno"; rec."Cod. Turno")
                {
                }
                field("Description Atencion"; rec."Description Atencion")
                {
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                }
                field("Nombre Comercial"; rec."Nombre Comercial")
                {
                }
                field("Fecha Entrega"; rec."Fecha Entrega")
                {
                }
                field(Cantidad; rec.Cantidad)
                {
                }
            }
        }
    }

    actions
    {
    }
}

