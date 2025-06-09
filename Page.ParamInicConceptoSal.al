page 76005 "Param. Inic. Concepto Sal."
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Param. Inic. Conceptos Sal.";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(Codigo; rec.Codigo)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Tipo concepto"; rec."Tipo concepto")
                {
                }
                field("Inicializa Cantidad"; rec."Inicializa Cantidad")
                {
                }
                field("Inicializa Importe"; rec."Inicializa Importe")
                {
                }
            }
        }
    }

    actions
    {
    }
}

