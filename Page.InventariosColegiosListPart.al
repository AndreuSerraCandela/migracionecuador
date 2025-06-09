page 76260 "Inventarios Colegios ListPart"
{
    ApplicationArea = all;
    Caption = 'Sample Inventory';
    PageType = CardPart;
    SourceTable = Contact;

    layout
    {
        area(content)
        {
            field("FuncAPS.ColCalcInvMuestras(""No."")"; FuncAPS.ColCalcInvMuestras(rec."No."))
            {
                Caption = 'Sample Inventory';

                trigger OnLookup(var Text: Text): Boolean
                var
                    BC: Record "Bin Content";
                    BCPage: Page "Bin Content";
                begin
                    BC.Reset;
                    BC.SetRange("Location Code", rec."Samples Location Code");
                    BC.SetRange("Bin Code", rec."No.");
                    if BC.FindSet then begin
                        BCPage.SetTableView(BC);
                        BCPage.RunModal;
                        Clear(BCPage);
                    end;
                end;
            }
        }
    }

    actions
    {
    }

    var
        FuncAPS: Codeunit "Funciones APS";
}

