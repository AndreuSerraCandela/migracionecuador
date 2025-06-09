page 76320 "Log Registro Ventas DsPOS"
{
    ApplicationArea = all;
    Caption = 'Log Registro Ventas DsPOS';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Cabecera Log Registro POS";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No. Log"; rec."No. Log")
                {
                    Editable = false;
                }
                field(Fecha; rec.Fecha)
                {
                    Editable = false;
                }
                field("Hora Inicio"; rec."Hora Inicio")
                {
                    Editable = false;
                }
                field("Fecha Fin"; rec."Fecha Fin")
                {
                    Editable = false;
                }
                field("Hora Fin"; rec."Hora Fin")
                {
                    Editable = false;
                }
                field(Errores; rec.Errores)
                {
                    Editable = false;
                }
                field("No. Facturas Registradas"; rec."No. Facturas Registradas")
                {
                    Editable = false;
                }
                field("No. Facturas Liquidadas"; rec."No. Facturas Liquidadas")
                {
                    Editable = false;
                }
                field("No. NC Registradas"; rec."No. NC Registradas")
                {
                    Editable = false;
                }
                field("No. NC Liquidadas"; rec."No. NC Liquidadas")
                {
                    Editable = false;
                }
            }
            part(Control1000000012; "Lineas Registro Ventas DsPoS")
            {
                SubPageLink = "No. Log" = FIELD ("No. Log");
            }
        }
    }

    actions
    {
    }
}

