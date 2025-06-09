page 76114 "Beneficios puestos laborales"
{
    ApplicationArea = all;
    Caption = 'Benefits list';
    PageType = List;
    SourceTable = "Beneficios laborales";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Tipo Beneficio"; rec."Tipo Beneficio")
                {
                }
                field(Codigo; rec.Codigo)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
            }
        }
    }

    actions
    {
    }
}

