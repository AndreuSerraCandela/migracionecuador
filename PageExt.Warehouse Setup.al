pageextension 50111 pageextension50111 extends "Warehouse Setup"
{
    layout
    {
        addafter(Numbering)
        {
            group(Others)
            {
                Caption = 'Others';
                field("Metodo clasificacion defecto"; rec."Metodo clasificacion defecto")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
}

