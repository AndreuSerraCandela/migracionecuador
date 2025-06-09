#pragma implicitwith disable
page 76046 "Configuracion General DSPoS"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Configuracion General DsPOS";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Nombre libro diario"; rec."Nombre libro diario")
                {
                }
                field("Nombre seccion diario"; rec."Nombre seccion diario")
                {
                }
                field(Pais; rec.Pais)
                {
                    BlankZero = true;
                }
                field("Nombre Divisa Local"; rec."Nombre Divisa Local")
                {
                }
            }
            part("Config. Caja Electronica"; "Config. Caja Electronica")
            {
            }
            part("Config. Serie Fiscal SIC"; "Config. Serie Fiscal SIC")
            {
            }
            part("Conf. Medios de pagos"; "Conf. Medios de pagos")
            {
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    var

    begin


    end;

    trigger OnOpenPage()
    begin
        if not Rec.Get then
            Rec.Insert;
    end;

    var
        error001: Label 'Función Sólo Disponible en Servidor Central';
}

#pragma implicitwith restore

