codeunit 56302 ActualizarCampoFiscalRel
{
    Permissions = TableData "Cust. Ledger Entry" = rm;

    trigger OnRun()
    begin



        recMovClientes.SetCurrentKey("Document No.", "Document Type", "Customer No.");
        recMovClientes.SetRange(recMovClientes."Document Type", recMovClientes."Document Type"::"Credit Memo");

        if recHistNotaCreditos.FindSet then
            repeat
                recMovClientes.SetRange(recMovClientes."Document No.", recHistNotaCreditos."No.");
                if recMovClientes.FindSet then begin
                    repeat
                        recMovClientes."No. Comprobante Fiscal Rel." := recHistNotaCreditos."No. Comprobante Fiscal Rel.";
                        recMovClientes.Modify;
                    until recMovClientes.Next = 0;
                end;
            until recHistNotaCreditos.Next = 0;
    end;

    var
        recHistNotaCreditos: Record "Sales Cr.Memo Header";
        recMovClientes: Record "Cust. Ledger Entry";
        ldgVentana: Dialog;
        vContador: Integer;
        vContadorT: Integer;
}

