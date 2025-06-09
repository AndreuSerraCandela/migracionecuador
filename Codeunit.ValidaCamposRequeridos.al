codeunit 76078 "Valida Campos Requeridos"
{

    trigger OnRun()
    begin
    end;

    var
        LCR: Record "Lin. Campos Req. Maestros";
        Error001: Label '%1 of table %2 Can not be blank';
        I: Integer;
        Error002: Label 'The Dimension %1 is required for the %2 with the Posting Value %3 for the record %4';
        CCR: Record "Cab. Campos Requeridos";
        CDR: Record "Cab. Dimensiones Requeridas";
        Error003: Label 'The Dimension %1 is required for the %2, for the record %3';
        Error004: Label '%1 of table %2 Can not be unmarked.';


    procedure Maestros(TableNo: Integer; Codigo: Code[20])
    var
        RecRef: RecordRef;
        MyRecordRef: RecordRef;
        MyFieldRef: FieldRef;
        FieldRef: array[200] of FieldRef;
        RecID: RecordID;
    begin
        CCR.Reset;
        CCR.SetRange("No. Tabla", TableNo);
        CCR.SetRange(Activo, true);
        if CCR.FindFirst then begin
            LCR.Reset;
            LCR.SetRange(LCR."No. Tabla", TableNo);
            if LCR.FindSet then begin
                MyRecordRef.Open(TableNo);
                MyRecordRef.Reset;
                repeat
                    I += 1;
                    Clear(MyFieldRef);
                    if I = 1 then begin
                        MyFieldRef := MyRecordRef.Field(1);
                        MyFieldRef.Value := Codigo;
                    end
                    else
                        MyFieldRef := MyRecordRef.Field(LCR."No. Campo");
                    if MyRecordRef.Find('=') then begin
                        FieldRef[I] := MyRecordRef.Field(LCR."No. Campo");
                        if (Format(FieldRef[I].Value) = '') then
                            Error(Error001, Format(FieldRef[I].Caption), Format(MyRecordRef.Caption));
                        //IF (FORMAT(FieldRef[I].TYPE) = 'Boolean' ) AND (FORMAT(FieldRef[I].VALUE) = FORMAT(FALSE)) THEN //jpg campo boolean
                        //  ERROR(Error004,FORMAT(FieldRef[I].CAPTION),FORMAT(MyRecordRef.CAPTION));
                    end;
                until LCR.Next = 0;
                MyRecordRef.Close;
            end;
        end;
    end;


    procedure Dimensiones(TableID: Integer; Codigo: Code[20]; TipoTabla: Option Maestro,Documento; TipoDocumento: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order")
    var
        DefDim: Record "Default Dimension";
        DimReq: Record "Lin. Dimensiones Req.";
        Tabla: RecordRef;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        DimSetEntry: Record "Dimension Set Entry";
        DimSetID: Integer;
    begin
        CDR.Reset;
        CDR.SetRange("No. Tabla", TableID);
        CDR.SetRange(Activo, true);
        if CDR.FindFirst then begin
            Tabla.Open(TableID);
            if TipoTabla = TipoTabla::Maestro then begin
                DimReq.Reset;
                DimReq.SetRange("No. Tabla", TableID);
                if DimReq.FindSet then
                    repeat
                        DefDim.Reset;
                        DefDim.SetRange("Table ID", TableID);
                        DefDim.SetRange("No.", Codigo);
                        DefDim.SetRange("Dimension Code", DimReq."Cod. Dimension");
                        DefDim.SetRange("Value Posting", DimReq."Registro valor");
                        if not DefDim.FindFirst then
                            Error(Error002, DimReq."Cod. Dimension", Tabla.Caption, Format(DimReq."Registro valor"), Codigo);
                    until DimReq.Next = 0;
            end
            else begin
                Clear(DimSetID);
                if (TableID in [36, 37, 38, 39]) then begin
                    DimReq.Reset;
                    DimReq.SetRange("No. Tabla", TableID);
                    if DimReq.FindSet then begin
                        case TableID of
                            36:
                                begin
                                    SalesHeader.SetRange("Document Type", TipoDocumento);
                                    SalesHeader.SetRange("No.", Codigo);
                                    SalesHeader.FindFirst;
                                    DimSetID := SalesHeader."Dimension Set ID";
                                end;
                            37:
                                begin
                                    SalesLine.SetRange("Document Type", TipoDocumento);
                                    SalesLine.SetRange("Document No.", Codigo);
                                    SalesLine.FindFirst;
                                    DimSetID := SalesLine."Dimension Set ID";
                                end;
                            38:
                                begin
                                    PurchHeader.SetRange("Document Type", TipoDocumento);
                                    PurchHeader.SetRange("No.", Codigo);
                                    PurchHeader.FindFirst;
                                    DimSetID := PurchHeader."Dimension Set ID";
                                end;
                            39:
                                begin
                                    PurchLine.SetRange("Document Type", TipoDocumento);
                                    PurchLine.SetRange("Document No.", Codigo);
                                    PurchLine.FindFirst;
                                    DimSetID := PurchLine."Dimension Set ID";
                                end;
                        end;
                        if DimSetID = 0 then
                            Error(Error003, DimReq."Cod. Dimension", Tabla.Caption, Codigo);
                        repeat
                            if not DimSetEntry.Get(DimSetID, DimReq."Cod. Dimension") then
                                Error(Error003, DimReq."Cod. Dimension", Tabla.Caption, Codigo);
                        until DimReq.Next = 0;
                    end;
                end;
            end;
        end
    end;


    procedure Documento(TableNo: Integer; TipoDoc: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; NoDoc: Code[20])
    var
        RecRef: RecordRef;
        MyRecordRef: RecordRef;
        MyFieldRef: array[200] of FieldRef;
        FieldRef: array[200] of FieldRef;
        RecID: RecordID;
    begin
        CCR.Reset;
        CCR.SetRange("No. Tabla", TableNo);
        if CCR.FindFirst then begin
            LCR.Reset;
            LCR.SetRange(LCR."No. Tabla", TableNo);
            if LCR.FindSet then begin
                MyRecordRef.Open(TableNo);
                MyRecordRef.Reset;
                repeat
                    I += 1;
                    Clear(MyFieldRef);
                    if I = 1 then begin
                        MyFieldRef[I] := MyRecordRef.Field(1);
                        MyFieldRef[I + 1] := MyRecordRef.Field(3);
                        MyFieldRef[I].Value := TipoDoc;
                        MyFieldRef[I + 1].Value := NoDoc;
                    end
                    else
                        MyFieldRef[I] := MyRecordRef.Field(LCR."No. Campo");
                    if MyRecordRef.Find('=') then begin
                        FieldRef[I] := MyRecordRef.Field(LCR."No. Campo");
                        if Format(FieldRef[I].Value) = '' then
                            Error(Error001, Format(FieldRef[I].Caption), Format(MyRecordRef.Caption));
                    end;
                until LCR.Next = 0;
                MyRecordRef.Close;
            end;
        end;
    end;
}

