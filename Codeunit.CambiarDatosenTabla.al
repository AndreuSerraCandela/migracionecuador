codeunit 56008 "Cambiar Datos en Tabla"
{
    // #20677               FAA
    // #57239  19/09/2016   JMB   Añadimos el campo descripción a la factura de compra

    Permissions = TableData "G/L Entry" = rm,
                  TableData "Vendor Ledger Entry" = rm,
                  TableData "Purch. Inv. Header" = rm,
                  TableData "VAT Entry" = rm,
                  TableData "FA Ledger Entry" = rm;

    trigger OnRun()
    begin
        ActualizarFactura('CFR-027808');
        ActualizarFactura('CFR-027809');
        ActualizarFactura('CFR-027810');
        ActualizarFactura('CFR-027811');
        ActualizarFactura('CFR-027812');
        ActualizarFactura('CFR-027813');
        ActualizarFactura('CFR-027814');
    end;


    procedure ActualizarFactura(No: Code[20])
    var
        FacturaCompra: Record "Purch. Inv. Header";
    begin
        // #57239
        FacturaCompra.Init;
        FacturaCompra.SetRange("No.", No);
        if FacturaCompra.FindFirst then begin
            FacturaCompra."Buy-from Address" := 'FRANCISCO DE PAULA ICAZA # 200';
            FacturaCompra.Modify;
        end;
        Message('OK');
    end;


    procedure CambiarDatos()
    var
        vrProveedorMov: Record "Vendor Ledger Entry";
        vrGLEntry: Record "G/L Entry";
        vrPInvHeader: Record "Purch. Inv. Header";
        vrVEntry: Record "VAT Entry";
        vrFaLEntry: Record "FA Ledger Entry";
    begin
        // #20677

        //Tabla 122
        vrPInvHeader.Reset;
        vrPInvHeader.SetRange(vrPInvHeader."Buy-from Vendor No.", '007446');
        vrPInvHeader.SetRange(vrPInvHeader."No.", 'CFR-018397');
        if vrPInvHeader.FindSet then begin
            vrPInvHeader."No. Comprobante Fiscal" := '4133';
            vrPInvHeader."Vendor Invoice No." := '4133';
            vrPInvHeader.Modify;
        end;

        //Tabla 17
        vrGLEntry.Reset;
        vrGLEntry.SetRange(vrGLEntry."Document No.", 'CFR-018397');
        if vrGLEntry.FindSet then begin
            repeat
                if vrGLEntry."External Document No." = '4133.1' then
                    vrGLEntry."External Document No." := '4133';

                if vrGLEntry."No. Comprobante Fiscal" = '4133.1' then
                    vrGLEntry."No. Comprobante Fiscal" := '4133';

                vrGLEntry.Modify;

            until vrGLEntry.Next = 0;
        end;

        //Tabla 25
        vrProveedorMov.Reset;
        vrProveedorMov.SetRange(vrProveedorMov."Document No.", 'CFR-018397');
        if vrProveedorMov.FindSet then begin
            repeat
                if vrProveedorMov."External Document No." = '4133.1' then
                    vrProveedorMov."External Document No." := '4133';

                if vrProveedorMov."No. Comprobante Fiscal" = '4133.1' then
                    vrProveedorMov."No. Comprobante Fiscal" := '4133';

                vrProveedorMov.Modify;

            until vrProveedorMov.Next = 0;
        end;

        //Tabla 254
        vrVEntry.Reset;
        vrVEntry.SetRange(vrVEntry."Document No.", 'CFR-018397');
        if vrVEntry.FindSet then begin
            repeat
                if vrVEntry."External Document No." = '4133.1' then
                    vrVEntry."External Document No." := '4133';

                vrVEntry.Modify;
            until vrVEntry.Next = 0;
        end;

        //Tabla 5601
        vrFaLEntry.Reset;
        vrFaLEntry.SetRange(vrFaLEntry."Document No.", 'CFR-018397');
        if vrFaLEntry.FindSet then begin
            repeat
                if vrFaLEntry."External Document No." = '4133.1' then
                    vrFaLEntry."External Document No." := '4133';

                vrFaLEntry.Modify;
            until vrFaLEntry.Next = 0;
        end;
    end;
}

