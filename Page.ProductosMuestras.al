page 76358 "Productos Muestras"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPlus;
    SourceTable = "Bin Content";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Item No."; rec."Item No.")
                {
                }
                field("Item Description"; rec."Item Description")
                {
                }
                field(Quantity; rec.Quantity)
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group("Action1000000004")
            {
                action(Action1000000005)
                {

                    trigger OnAction()
                    begin
                        /*
                        TH.GET(NoDocumento);
                        SETRANGE("Location Code",TH."Transfer-from Code");
                        SETRANGE("Bin Code",TH."Cod. Ubicacion Alm. Origen");
                        
                        MARKEDONLY(TRUE);
                        IF FINDSET THEN
                            REPEAT
                             NoLin += 1000;
                             TL.INIT;
                             TL."Document No." := TH."No.";
                             TL."Line No."     := NoLin;
                             TL.VALIDATE("Transfer-from Code",TH."Transfer-from Code");
                             TL.VALIDATE("Transfer-to Code",TH."Transfer-to Code");
                             TL.VALIDATE("Item No.","Item No.");
                        //     TL.VALIDATE(Quantity,1);
                             IF TH."Cod. Ubicacion Alm. Origen" <> '' THEN
                                TL.VALIDATE("Transfer-from Bin Code",TH."Cod. Ubicacion Alm. Origen");
                             IF TH."Cod. Ubicacion Alm. Destino" <> '' THEN
                                TL.VALIDATE("Transfer-To Bin Code",TH."Cod. Ubicacion Alm. Destino");
                             IF NOT TL.INSERT(TRUE) THEN
                                TL.MODIFY(TRUE);
                            UNTIL NEXT = 0;
                        */

                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        recPromotor: Record "Salesperson/Purchaser";
    begin
        if gPromotor = '' then
            exit;

        recPromotor.Get(gPromotor);
        rec.SetRange("Location Code", recPromotor."Sample Location code");
        rec.SetRange("Bin Code", gPromotor);
    end;

    var
        gPromotor: Code[20];


    procedure RecibeParametros(CodPromotor: Code[20])
    begin
        gPromotor := CodPromotor;
    end;
}

