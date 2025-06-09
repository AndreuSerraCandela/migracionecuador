codeunit 55555 DynES
{
    Permissions = TableData "Purch. Inv. Header" = rimd;

    trigger OnRun()
    var
        rCab: Record "Purch. Inv. Header";
    begin

        /*
        
        CambiarIVA();
        
        rCab.GET('CFR-024523');
        rCab."No. Comprobante Fiscal" :='10336';
        rCab.MODIFY(FALSE);
        
        rCab.GET('CFR-023865');
        rCab."No. Comprobante Fiscal" :='10179';
        rCab.MODIFY(FALSE);
        
        rCab.GET('CFR-024598');
        rCab."No. Comprobante Fiscal" :='10334';
        rCab.MODIFY(FALSE);
        
        MESSAGE('CFR-024598');
         */

    end;


    procedure CambiarIVA()
    var
        SCRML: Record "Sales Cr.Memo Line";
    begin
        // Document No.,Line No.
        if SCRML.Get('VNR-031651', 60000) then
            Message('%1', SCRML."VAT %");
    end;


    procedure ActualizarFactura()
    var
        FacturaCompra: Record "Sales Invoice Header";
    begin

        FacturaCompra.Init;
        FacturaCompra.SetRange("No.", 'CFR-027807');
        if FacturaCompra.FindFirst then begin
            FacturaCompra."Bill-to Address" := 'FRANCISCO DE PAULA ICAZA # 200';
            FacturaCompra.Modify;
        end;
        Message('OK');
    end;
}

