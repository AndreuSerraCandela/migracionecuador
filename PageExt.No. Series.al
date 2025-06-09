pageextension 50064 pageextension50064 extends "No. Series"
{
    layout
    {
        addafter(Description)
        {
            field("Descripcion NCF"; rec."Descripcion NCF")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(StartDate)
        {
            field("Tipo Documento"; rec."Tipo Documento")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Cod. Almacen"; rec."Cod. Almacen")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Centro de Responsabilidad"; rec."Centro de Responsabilidad")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Date Order")
        {
            field("Facturacion electronica"; rec."Facturacion electronica")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}

