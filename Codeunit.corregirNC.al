codeunit 56016 "corregir NC"
{
    Permissions = TableData "Purch. Cr. Memo Hdr." = rm;

    trigger OnRun()
    var
        rNC: Record "Purch. Cr. Memo Hdr.";
    begin
        rNC.SetRange("No.", 'CNCR-000555', 'CNCR-000556');
        if rNC.FindSet then
            repeat
                if rNC."Tipo de Comprobante" = '' then begin
                    rNC."Tipo de Comprobante" := '04';
                    rNC.Modify;
                end;
            until rNC.Next = 0;
        Message('finalizado');
    end;
}

