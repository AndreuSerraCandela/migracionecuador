codeunit 56015 "Corregir NCF"
{
    Permissions = TableData "G/L Entry" = rimd,
                  TableData "Vendor Ledger Entry" = rimd,
                  TableData "Purch. Inv. Header" = rimd;

    trigger OnRun()
    var
        PIH: Record "Purch. Inv. Header";
        rConta: Record "G/L Entry";
        cont: Integer;
        rMov: Record "Vendor Ledger Entry";
    begin
        PIH.Get('CFR-062424');
        if PIH."No. Comprobante Fiscal" = '' then begin
            PIH."No. Comprobante Fiscal" := '100159';
            PIH.Modify;
            cont += 1;
        end;

        cont := 0;
        rConta.SetRange("Document No.", 'CFR-062424');
        rConta.SetRange("Document Type", rConta."Document Type"::Invoice);
        if rConta.FindSet then
            repeat
                cont += 1;
                if rConta."No. Comprobante Fiscal" = '' then begin
                    rConta."No. Comprobante Fiscal" := '100159';
                    rConta.Modify;
                end;
            until rConta.Next = 0;
        //MESSAGE(FORMAT(cont) + ' PROCESO FINALIZADO');


        rMov.SetRange("Document No.", 'CFR-062424');
        rMov.SetRange("Document Type", rMov."Document Type"::Invoice);
        if rMov.FindSet then
            repeat
                cont += 1;
                if rMov."No. Comprobante Fiscal" = '' then begin
                    rMov."No. Comprobante Fiscal" := '100159';
                    rMov.Modify;
                end;
            until rMov.Next = 0;
        Message(Format(cont) + ' PROCESO FINALIZADO');
    end;
}

