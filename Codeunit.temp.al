codeunit 56011 temp
{
    Permissions = TableData "Purch. Cr. Memo Hdr." = rm;

    trigger OnRun()
    begin
        sil.Reset;
        sil.SetRange("Document No.", 'VFR-101555');
        sil.FindSet;
        Message('%1', sil.Count);


        sil.Reset;
        sil.SetRange("Document No.", 'VFR-101555');
        sil.FindSet;
        repeat
            cont += 1;
        until sil.Next = 0;

        Message('%1', cont);

        //RenombrarPedTransf;
        Message('Finalizado');
    end;

    var
        sil: Record "Sales Invoice Line";
        cont: Integer;
        Capex: Record "Colegio - Adopciones Detalle";


    procedure CambNoAutorComp()
    var
        rPCMH: Record "Purch. Cr. Memo Hdr.";
    begin
        rPCMH.SetRange(rPCMH."No. Comprobante Fiscal", '83828');
        if rPCMH.FindSet then
            if rPCMH."No. Autorizacion Comprobante" = '0904201509435817912512370014360878710' then begin
                rPCMH."No. Autorizacion Comprobante" := '0904201509435817912512370014360933703';
                rPCMH.Modify;
            end;
    end;


    procedure RenombrarPedTransf()
    var
        TransferHeader: Record "Transfer Header";
        TransferHeader2: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        TransferLine2: Record "Transfer Line";
        TransferNo: Code[20];
        NewTransferNo: Code[20];
    begin
        TransferNo := 'PT-009119-1';
        NewTransferNo := 'PT-009119';

        TransferHeader.Get(TransferNo);
        TransferHeader2 := TransferHeader;
        TransferHeader2."No." := NewTransferNo;
        TransferHeader2.Insert;
        TransferHeader.Delete;

        TransferLine.SetRange("Document No.", TransferNo);
        if TransferLine.FindSet then
            repeat
                TransferLine2 := TransferLine;
                TransferLine2."Document No." := NewTransferNo;
                TransferLine2.Insert;
            until TransferLine.Next = 0;

        TransferLine.DeleteAll;
    end;
}

