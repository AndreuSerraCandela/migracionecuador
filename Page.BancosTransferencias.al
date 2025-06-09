page 76113 "Bancos Transferencias"
{
    ApplicationArea = all;
    Caption = 'Transfer Banks';
    PageType = List;
    SourceTable = "Bancos ACH Nomina";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Banco"; rec."Cod. Banco")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Cod. Institucion Financiera"; rec."Cod. Institucion Financiera")
                {
                }
                field("ACH Reservas"; rec."ACH Reservas")
                {
                }
                field("Digito Chequeo"; rec."Digito Chequeo")
                {
                }
            }
        }
    }

    actions
    {
    }
}

