page 55018 "Log comprobantes electronicos"
{
    ApplicationArea = all;

    Caption = 'Movs. comprobantes electronicos';
    Editable = false;
    PageType = List;
    SourceTable = "Log comprobantes electronicos";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No. mov."; rec."No. mov.")
                {
                    Visible = false;
                }
                field("Fecha hora mov."; rec."Fecha hora mov.")
                {
                }
                field(Usuario; rec.Usuario)
                {
                    DrillDown = false;
                }
                field(Ambiente; rec.Ambiente)
                {
                }
                field("Tipo documento"; rec."Tipo documento")
                {
                    DrillDown = false;
                }
                field("No. documento"; rec."No. documento")
                {
                }
                field("Fichero XML"; rec."Fichero XML")
                {
                    Lookup = false;
                }
                field(Estado; rec.Estado)
                {
                }
                field("Respuesta SRI"; rec."Respuesta SRI")
                {
                }
                field("Info adicional"; rec."Info adicional")
                {
                }
            }
        }
    }

    actions
    {
    }
}

