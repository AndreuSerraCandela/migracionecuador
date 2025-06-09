page 76205 "Estadistica Ingresos-Descuento"
{
    ApplicationArea = all;
    Editable = false;
    PageType = ListPart;
    SourceTable = "Perfil Salarial";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Concepto salarial"; rec."Concepto salarial")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Importe Acumulado"; rec."Importe Acumulado")
                {
                }
            }
        }
    }

    actions
    {
    }
}

