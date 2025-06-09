page 76081 "Acumulado Salarios"
{
    ApplicationArea = all;
    DataCaptionFields = "No. empleado", "Filtro Fecha";
    Editable = false;
    PageType = List;
    SourceTable = "Perfil Salarial";

    layout
    {
        area(content)
        {
            repeater(Control1100000)
            {
                ShowCaption = false;
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

