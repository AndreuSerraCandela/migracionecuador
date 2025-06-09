page 55025 "SRI Comprobantes anulados"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "ATS Comprobantes Anulados";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Tipo Comprobante anulado"; rec."Tipo Comprobante anulado")
                {
                }
                field(Establecimiento; rec.Establecimiento)
                {
                }
                field("Punto Emision"; rec."Punto Emision")
                {
                }
                field("No. secuencial - Desde"; rec."No. secuencial - Desde")
                {
                    Caption = 'No. secuencial';
                }
                field("No. secuencial - Hasta"; rec."No. secuencial - Hasta")
                {
                    Visible = false;
                }
                field("No. autorización"; rec."No. autorización")
                {
                }
            }
        }
    }

    actions
    {
    }
}

