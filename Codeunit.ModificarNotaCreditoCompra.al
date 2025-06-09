codeunit 56310 ModificarNotaCreditoCompra
{
    Permissions = TableData "Purch. Cr. Memo Hdr." = rm;

    trigger OnRun()
    var
        recNotaCreCompra: Record "Purch. Cr. Memo Hdr.";
    begin

        recNotaCreCompra.Reset;
        recNotaCreCompra.SetRange(recNotaCreCompra."No.", 'CNCR-000546');

        if recNotaCreCompra.FindSet then begin
            recNotaCreCompra."Tipo de Comprobante" := '04';
            recNotaCreCompra.Modify;
        end;
    end;
}

