/* pageextension 50099 pageextension50099 extends "No. Series"
{
    layout
    {
        addafter(Description)
        {
            field("Descripcion NCF"; "Descripcion NCF")
            {
            }
        }
        addafter("Date Order")
        {
            field("Facturacion electronica"; "Facturacion electronica")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
} */

