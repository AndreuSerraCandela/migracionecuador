page 76415 "Tipos de documentos personales"
{
    ApplicationArea = all;

    Caption = 'Types of personal documents';
    PageType = Card;
    SourceTable = "Tipos de documentos personales";
    UsageCategory = Administration;

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
                field("Tipo Factura"; rec."Tipo Factura")
                {
                }
                field("Tax Identification Type"; rec."Tax Identification Type")
                {
                }
            }
        }
    }

    actions
    {
    }
}

