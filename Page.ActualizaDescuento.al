page 56053 "Actualiza Descuento"
{
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            field(PorcDesc; PorcDesc)
            {
                Caption = 'Discount %';
            }
        }
    }

    actions
    {
    }

    trigger OnClosePage()
    begin
        Window.Open(Text004);
        LCF.Reset;
        LCF.SetCurrentKey("Document Type", "Document No.", "ID Usuario", "Line No.");
        LCF.SetRange("Document Type", 1);
        LCF.SetRange("Document No.", NoPedido);
        LCF.SetRange("ID Usuario", UserId);
        CounterTotal := LCF.Count;
        if LCF.FindSet then
            repeat
                Counter := Counter + 1;
                Window.Update(1, LCF."No.");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
                LCF."Line Discount %" := PorcDesc;
                LCF.Modify;
            until LCF.Next = 0;
        Window.Close;
    end;

    var
        NoPedido: Code[20];
        PorcDesc: Decimal;
        LCF: Record "Lin. Consignacion a Facturar";
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        Text004: Label 'Reading  #1########## @2@@@@@@@@@@@@@';


    procedure RecibeNoPedido(NoPed_Loc: Code[20])
    begin
        NoPedido := NoPed_Loc;
    end;
}

