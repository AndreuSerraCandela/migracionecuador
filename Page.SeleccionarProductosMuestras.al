page 76388 "Seleccionar Productos Muestras"
{
    ApplicationArea = all;
    // Esto va en OnAfterNextRecord
    // 
    // BC.RESET;
    // BC.SETRANGE("Location Code",TH."Transfer-from Code");
    // BC.SETRANGE("Bin Code",TH."Cod. Ubicacion Alm. Origen");
    // BC.SETRANGE("Item No.","Cod. Producto");
    // IF BC.FINDFIRST THEN
    //    BEGIN
    //     BC.CALCFIELDS("Quantity (Base)");
    //     IF BC."Quantity (Base)" = 0 THEN
    //        NEXT;
    //    END;

    PageType = ListPlus;
    SourceTable = "Bin Content";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(Seleccionar; Seleccionar)
                {
                    Caption = 'Select';

                    trigger OnValidate()
                    begin
                        rec.Mark(Seleccionar);
                    end;
                }
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
        Area(Processing)
        {
            group(Action1000000004)
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

    trigger OnAfterGetRecord()
    begin
        Seleccionar := false;
        //IF "Cantidad seleccionada" <> 0 THEN
        /*IF Quantity <> 0 THEN
           BEGIN
            Seleccionar := TRUE;
            MARK(Seleccionar);
           END;
        */

    end;

    trigger OnOpenPage()
    begin
        TH.Get(NoDocumento);
        rec.SetRange("Location Code", TH."Transfer-from Code");
        rec.SetRange("Bin Code", TH."Cod. Ubicacion Alm. Origen");
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction in [ACTION::OK, ACTION::LookupOK] then
            OKOnPush;
    end;

    var
        BC: Record "Bin Content";
        TH: Record "Transfer Header";
        TL: Record "Transfer Line";
        TransLine2: Record "Transfer Line";
        PPM: Record "Promotor - Ppto Muestras";
        Seleccionar: Boolean;
        NoDocumento: Code[20];


    procedure RecibeParametros(DocNo: Code[20]; CodPromotor: Code[20])
    begin
        NoDocumento := DocNo;
    end;

    local procedure OKOnPush()
    begin

        TH.Get(NoDocumento);
        rec.SetRange("Location Code", TH."Transfer-from Code");
        rec.SetRange("Bin Code", TH."Cod. Ubicacion Alm. Origen");

        rec.MarkedOnly(true);
        if rec.FindSet then
            repeat
                TL.Init;

                TransLine2.Reset;
                TransLine2.SetRange("Document No.", TH."No.");
                if TransLine2.FindLast then
                    TL."Line No." := TransLine2."Line No." + 10000
                else
                    TL."Line No." := 10000;

                TL."Document No." := TH."No.";
                TL."Transfer-from Code" := TH."Transfer-from Code";
                TL."Transfer-to Code" := TH."Transfer-to Code";

                TL.Validate("Transfer-from Code", TH."Transfer-from Code");
                TL.Validate("Transfer-to Code", TH."Transfer-to Code");
                TL.Validate("Item No.", rec."Item No.");
                //     TL.VALIDATE(Quantity,1);
                if TH."Cod. Ubicacion Alm. Origen" <> '' then
                    TL.Validate("Transfer-from Bin Code", TH."Cod. Ubicacion Alm. Origen");
                if TH."Cod. Ubicacion Alm. Destino" <> '' then
                    TL.Validate("Transfer-To Bin Code", TH."Cod. Ubicacion Alm. Destino");

                if not TL.Insert(true) then
                    TL.Modify(true);
            until rec.Next = 0;
    end;
}

