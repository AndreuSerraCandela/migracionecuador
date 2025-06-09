page 76089 "NCF Anulados"
{
    ApplicationArea = all;
    Caption = 'Voided NCF';
    Editable = false;
    PageType = List;
    SourceTable = "NCF Anulados";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No. documento"; rec."No. documento")
                {
                }
                field("No. Serie NCF Facturas"; rec."No. Serie NCF Facturas")
                {
                }
                field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
                {
                }
                field("No. Serie NCF Abonos"; rec."No. Serie NCF Abonos")
                {
                }
                field("Fecha anulacion"; rec."Fecha anulacion")
                {
                }
                field("Tipo Documento"; rec."Tipo Documento")
                {
                }
            }
        }
    }

    actions
    {
    }
}

