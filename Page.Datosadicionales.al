#pragma implicitwith disable
page 76043 "Datos adicionales"
{
    ApplicationArea = all;
    DataCaptionFields = "Tipo registro";
    PageType = List;
    SourceTable = "Datos adicionales RRHH";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code"; rec.Code)
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

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
        CurrPage.Caption := Format(Rec."Tipo registro");
    end;
}

#pragma implicitwith restore

