page 76330 "Niveles puestos laborales"
{
    ApplicationArea = all;
    Caption = 'Job type levels';
    DataCaptionFields = "Cod. Nivel", Descripcion;
    PageType = List;
    SourceTable = "Nivel Cargo";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Importe mínimo"; rec."Importe mínimo")
                {
                }
                field("Importe Medio"; rec."Importe Medio")
                {
                }
                field("Importe máximo"; rec."Importe máximo")
                {
                }
            }
        }
    }

    actions
    {
    }
}

