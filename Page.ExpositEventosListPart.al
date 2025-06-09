page 76208 "Exposit. - Eventos  ListPart"
{
    ApplicationArea = all;
    Caption = 'Expositors - Events';
    PageType = ListPart;
    SourceTable = "Expositores - Eventos";

    layout
    {
        area(content)
        {
            repeater(Control1000000004)
            {
                ShowCaption = false;
                field("Cod. Evento"; rec."Cod. Evento")
                {
                    Visible = false;
                }
                field("Cod. Expositor"; rec."Cod. Expositor")
                {
                }
                field("Tipo de Expositor"; rec."Tipo de Expositor")
                {
                }
                field("Nombre Expositor"; rec."Nombre Expositor")
                {
                }
                field(Delegacion; rec.Delegacion)
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        gCodDocente: Code[20];


    procedure RecibeParametro(CodDocente: Code[20])
    begin
        gCodDocente := CodDocente;
    end;
}

