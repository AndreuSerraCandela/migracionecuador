page 76008 "Conf. ventas y cobros TPV"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Sales & Receivables Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Credit Memo Nos."; rec."Credit Memo Nos.")
                {
                }
                field("Posted Credit Memo Nos."; rec."Posted Credit Memo Nos.")
                {
                }
                field("Posted Shipment Nos."; rec."Posted Shipment Nos.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

