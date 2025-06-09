page 76169 "Dialogo fondo de caja"
{
    ApplicationArea = all;
    PageType = ConfirmationDialog;

    layout
    {
        area(content)
        {
            field("Fondo de caja"; decFondo)
            {
            }
        }
    }

    actions
    {
    }

    var
        decFondo: Decimal;


    procedure TraerFondo(): Decimal
    begin
        exit(decFondo);
    end;
}

