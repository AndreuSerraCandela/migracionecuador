page 76271 "Lista Cab Impuestos"
{
    ApplicationArea = all;
    CardPageID = "Histórico Cab. Impuestos";
    Editable = false;
    PageType = List;
    SourceTable = "Cab. Aportes Empresas";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Tipo de nomina"; rec."Tipo de nomina")
                {
                }
                field("Tipo Nomina"; rec."Tipo Nomina")
                {
                    Visible = false;
                }
                field("No. Documento"; rec."No. Documento")
                {
                }
                field("Unidad cotización"; rec."Unidad cotización")
                {
                }
                field("Período"; rec.Período)
                {
                }
                field("No. Contabilización"; rec."No. Contabilización")
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

