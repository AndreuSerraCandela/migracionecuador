pageextension 50057 pageextension50057 extends "Payment Methods"
{
    layout
    {
        // modify("SAT Method of Payment")
        // {
        //     Caption = 'Forma pago SRI';
        //     ApplicationArea = All;
        // }
        addafter("Pmt. Export Line Definition")
        {
            field("Forma de pago DGII"; rec."Forma de pago DGII")
            {
                ApplicationArea = All;
            }
        }
    }
}

