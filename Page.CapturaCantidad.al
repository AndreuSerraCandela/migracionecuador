page 56038 "Captura Cantidad"
{
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            field(wCant; wCant)
            {
                ShowCaption = false;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        wCant := 1;
    end;

    var
        wCant: Decimal;


    procedure GetCantidad(): Decimal
    begin
        exit(wCant);
    end;
}

