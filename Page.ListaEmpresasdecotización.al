page 76070 "Lista Empresas de cotización"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Empresas Cotizacion";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Empresa cotizacion"; rec."Empresa cotizacion")
                {
                }
                field("Nombre Empresa cotizacinn"; rec."Nombre Empresa cotizacinn")
                {
                }
                field("Esquema percepción"; rec."Esquema percepción")
                {
                }
                field(Fax; rec.Fax)
                {
                }
                field("E-Mail"; rec."E-Mail")
                {
                }
                field("ID RNL"; rec."ID RNL")
                {
                }
                field("ID TSS"; rec."ID TSS")
                {
                }
                field("Tipo Empresa de Trabajo"; rec."Tipo Empresa de Trabajo")
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
}

