codeunit 56020 "Test JMB"
{
    Permissions = TableData "Sales Cr.Memo Line" = rimd;

    trigger OnRun()
    begin
        //CambiarIVA('VNR-097214');
    end;


    procedure CambiarIVA(Documento: Code[20])
    var
        SCRML: Record "Sales Cr.Memo Line";
        SCRMH: Record "Sales Cr.Memo Header";
        DFE: Record "Documento FE";
    begin
        /*SCRMH.RESET;
        SCRMH.SETCURRENTKEY("Return Order No.");
        SCRMH.SETFILTER("Return Order No.", Documento);
        IF SCRMH.FINDSET THEN BEGIN
        
          SCRML.RESET;
          SCRML.SETRANGE("Document No.", SCRMH."No.");
          SCRML.SETRANGE("VAT %", 14);
          SCRML.MODIFYALL("VAT %", 12);
        
          DFE.RESET;
          DFE.SETRANGE("No. documento", SCRMH."No.");
          DFE.MODIFYALL("Estado envio", DFE."Estado envio"::Pendiente);
        
        END;
        */
        SCRML.Reset;
        SCRML.SetRange("Document No.", Documento);
        SCRML.SetRange(SCRML."Line No.", 20000);
        if SCRML.FindFirst then begin
            SCRML."Appl.-from Item Entry" := 3714710;
            SCRML.Modify;
        end;

    end;
}

