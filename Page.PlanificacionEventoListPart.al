page 76350 "Planificacion Evento ListPart"
{
    ApplicationArea = all;
    Caption = 'Planned Events';
    PageType = CardPart;
    SourceTable = "Cab. Planif. Evento";

    layout
    {
        area(content)
        {
            field("Asistentes esperados"; rec."Asistentes esperados")
            {
            }
            field("Total registrados"; rec."Total registrados")
            {
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

