page 76028 "Lista Lin.nominas"
{
    ApplicationArea = all;
    Editable = false;
    PageType = List;
    SourceTable = "Historico Lin. nomina";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Tipo Nómina"; rec."Tipo Nómina")
                {
                }
                field("Concepto salarial"; rec."Concepto salarial")
                {
                }
                field("Descripción"; rec.Descripción)
                {
                }
                field("Período"; rec.Período)
                {
                }
                field(Cantidad; rec.Cantidad)
                {
                }
                field("Importe Base"; rec."Importe Base")
                {
                }
                field(Total; rec.Total)
                {
                }
            }
        }
    }

    actions
    {
    }
}

