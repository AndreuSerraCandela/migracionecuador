page 76348 "Petición de Fecha"
{
    ApplicationArea = all;
    PageType = ConfirmationDialog;

    layout
    {
        area(content)
        {
            field(Fecha; wFecha)
            {
            }
        }
    }

    actions
    {
    }

    var
        wFecha: Date;


    procedure DevolverFecha(): Date
    begin
        exit(wFecha);
    end;
}

