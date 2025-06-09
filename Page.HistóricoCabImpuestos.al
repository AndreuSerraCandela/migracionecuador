page 76251 "Histórico Cab. Impuestos"
{
    ApplicationArea = all;
    Caption = 'Histórico Cuotas Patronales';
    DeleteAllowed = false;
    Editable = false;
    PageType = Document;
    SourceTable = "Cab. Aportes Empresas";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = false;
                field("Tipo Nomina"; rec."Tipo Nomina")
                {
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
            part(HistLinNom; "Histórico Lin. Impuestos")
            {
                SubPageLink = "Período" = FIELD ("Período"),
                              "Tipo de nomina" = FIELD ("Tipo de nomina");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Cotizaciones")
            {
                Caption = '&Cotizaciones';
                action("&List")
                {
                    Caption = '&List';
                    RunObject = Page "Lista Cab Impuestos";
                    ShortCutKey = 'Shift+Ctrl+L';
                }
            }
        }
    }
}

