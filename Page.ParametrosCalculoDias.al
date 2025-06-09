page 76338 "Parametros Calculo Dias"
{
    ApplicationArea = all;
    Caption = 'Days Calculation Parameter';
    PageType = List;
    SourceTable = "Parametros Calculo Dias";

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
                field(Valor; rec.Valor)
                {
                }
            }
        }
    }

    actions
    {
    }
}

