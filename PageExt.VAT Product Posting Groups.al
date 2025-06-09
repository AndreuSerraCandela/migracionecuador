pageextension 50068 pageextension50068 extends "VAT Product Posting Groups"
{
    Caption = 'VAT Product Posting Groups';

    //Unsupported feature: Property Insertion (SourceTableView) on ""VAT Product Posting Groups"(Page 471)".

    layout
    {
        addafter(Description)
        {
            field(Propina; rec.Propina)
            {
                ApplicationArea = All;

            }
            field("Tipo de bien-servicio"; rec."Tipo de bien-servicio")
            {
                ApplicationArea = All;


            }
        }
    }
}

