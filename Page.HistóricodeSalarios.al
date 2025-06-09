#pragma implicitwith disable
page 76253 "Histórico de Salarios"
{
    ApplicationArea = all;
    Editable = false;
    PageType = List;
    SourceTable = "Acumulado Salarios";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                ShowCaption = false;
                field("Fecha Desde"; rec."Fecha Desde")
                {
                    Caption = 'Desde';
                }
                field("Fecha Hasta"; rec."Fecha Hasta")
                {
                    Caption = 'Hasta';
                }
                field(Importe; rec.Importe)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;


    procedure FiltraEmpleado(rEmpleado: Record Employee)
    begin
        Rec.SetRange("No. empleado", rEmpleado."No.");
    end;
}

#pragma implicitwith restore

