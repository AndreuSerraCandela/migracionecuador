tableextension 50075 tableextension50075 extends "IC Outbox Transaction"
{
    fields
    {
        modify("IC Account No.")
        {
            Caption = 'IC Account No.'; //IC Partner G/L Acc. No.
        }
        field(55012; "Tipo de Comprobante"; Code[10])
        {
            Caption = 'Voucher Type';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-5893';
            TableRelation = "SRI - Tabla Parametros".Code WHERE("Tipo Registro" = FILTER("TIPOS COMPROBANTES AUTORIZADOS"));

            trigger OnValidate()
            var
                Err001: Label 'Se requiere eliminar las lineas de reembolso.';
                recFactRespaldo: Record "Facturas de reembolso";
            begin
            end;
        }
        field(55013; "Establecimiento Factura"; Code[3])
        {
            Caption = 'Invoice Location';
            DataClassification = ToBeClassified;
            Description = 'SRI';

            trigger OnValidate()
            begin
                /*
                TESTFIELD("No. Serie NCF Facturas");
                NoSeriesLine.RESET;
                NoSeriesLine.SETRANGE("Series Code","No. Serie NCF Facturas");
                NoSeriesLine.SETRANGE(Establecimiento,"Establecimiento Factura");
                NoSeriesLine.FINDFIRST;
                */

            end;
        }
        field(55014; "Punto de Emision Factura"; Code[3])
        {
            Caption = 'Invoice Issue Point';
            DataClassification = ToBeClassified;
            Description = 'SRI';

            trigger OnValidate()
            begin
                /*
                //017
                TESTFIELD("No. Serie NCF Facturas");
                TESTFIELD("Establecimiento Factura");
                NoSeriesLine.RESET;
                NoSeriesLine.SETRANGE("Series Code","No. Serie NCF Facturas");
                NoSeriesLine.SETRANGE(Establecimiento,"Establecimiento Factura");
                NoSeriesLine.SETRANGE("Punto de Emision","Punto de Emision Factura");
                NoSeriesLine.FINDFIRST;
                //017
                */

            end;
        }
        field(56009; "Factura eletrónica"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-5893';
        }
        field(76079; "No. Comprobante Fiscal"; Code[19])
        {
            Caption = 'Fiscal Document No.';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.02';
        }
        field(76080; "No. Comprobante Fiscal Rel."; Code[19])
        {
            Caption = 'Related Fiscal Document No.';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-5893';
        }
    }

    //Unsupported feature: Variable Insertion (Variable: Text002) (VariableCollection) on "OutboxCheckSend(PROCEDURE 36)".

    //Unsupported feature: Code Modification on "OutboxCheckSend(PROCEDURE 36)".
    //[EventSubscriber(ObjectType::Table, Database::"IC Outbox Transaction", 'OnBeforeOutboxCheckSend', '', false, false)] llevarlo a un Codeunit
    local procedure OnBeforeOutboxCheckSend(var ICOutboxTransaction: Record "IC Outbox Transaction"; var IsHandled: Boolean)
    var
        HandledICOutboxTrans: Record "Handled IC Outbox Trans.";
        ICOutboxTransaction2: Record "IC Outbox Transaction";
        ConfirmManagement: Codeunit "Confirm Management";
        Text001: Label 'Transaction No. %2 is a copy of Transaction No. %1, which has already been set to Send to IC Partner.\Do you also want to send Transaction No. %2?';
        Text002: Label 'A copy of Transaction No. %1 has already been sent to IC Partner and is now in the Handled IC Outbox Transactions window.\Do you also want to send Transaction No. %1?;';
        TransactionAlreadyExistsInOutboxHandledQst: Label '%1 %2 has already been sent to intercompany partner %3. Resending it will create a duplicate %1 for them. Do you want to send it again?', Comment = '%1 - Document Type, %2 - Document No, %3 - IC parthner code';
        SalesInvoicePreviouslySentAsOrderMsg: Label 'A sales order for this invoice has already been sent to intercompany partner %1. Resending it can lead to duplicate information. Do you want to send it?', Comment = '%1 - Intercompany Partner Code';
    begin
        HandledICOutboxTrans.SetRange("Source Type", "IC Source Type");
        HandledICOutboxTrans.SetRange("Document Type", "Document Type");
        HandledICOutboxTrans.SetRange("Document No.", "Document No.");
        if HandledICOutboxTrans.FindFirst() then
            //if not ConfirmManagement.ConfirmProcess(StrSubstNo(Text002, "Transaction No."), true) then
            if not ConfirmManagement.GetResponseOrDefault(StrSubstNo(Text002, "Transaction No."), true) then
                Error('');

        ICOutboxTransaction2.SetRange("IC Source Type", "IC Source Type");
        ICOutboxTransaction2.SetRange("Document Type", "Document Type");
        ICOutboxTransaction2.SetRange("Document No.", "Document No.");
        ICOutboxTransaction2.SetFilter("Transaction No.", '<>%1', "Transaction No.");
        ICOutboxTransaction2.SetRange("IC Account No.", "IC Account No.");
        ICOutboxTransaction2.SetRange("IC Account Type", "IC Account Type");
        ICOutboxTransaction2.SetRange("IC Account No.", "IC Account No.");
        ICOutboxTransaction2.SetRange("Source Line No.", "Source Line No.");
        ICOutboxTransaction2.SetRange("Line Action", "Line Action"::"Send to IC Partner");
        if ICOutboxTransaction2.FindFirst() then
            if not ConfirmManagement.GetResponseOrDefault(
                 StrSubstNo(Text001, ICOutboxTransaction2."Transaction No.", "Transaction No."), true)
            then
                Error('');

        if SalesInvoicePreviouslySentAsOrder() then
            if not ConfirmManagement.GetResponseOrDefault(
                 StrSubstNo(SalesInvoicePreviouslySentAsOrderMsg, Rec."IC Partner Code"), true)
            then
                Error('');
    end;

    local procedure SalesInvoicePreviouslySentAsOrder(): Boolean
    var
        ICOutboxSalesHeader: Record "IC Outbox Sales Header";
        HandledICOutboxTrans: Record "Handled IC Outbox Trans.";
    begin
        if Rec."Document Type" <> Rec."Document Type"::Invoice then
            exit(false);
        if Rec."IC Source Type" <> Rec."IC Source Type"::"Sales Document" then
            exit(false);
        if Rec."Transaction Source" <> Rec."Transaction Source"::"Created by Current Company" then
            exit(false);
        if not ICOutboxSalesHeader.Get(Rec."Transaction No.", Rec."IC Partner Code", Rec."Transaction Source") then
            exit(false);
        HandledICOutboxTrans.SetRange("IC Partner Code", Rec."IC Partner Code");
        HandledICOutboxTrans.SetRange("Transaction Source", Rec."Transaction Source");
        HandledICOutboxTrans.SetRange("Document No.", ICOutboxSalesHeader."Order No.");
        HandledICOutboxTrans.SetRange("Source Type", Rec."IC Source Type");
        HandledICOutboxTrans.SetRange("Document Type", HandledICOutboxTrans."Document Type"::Order);
        exit(not HandledICOutboxTrans.IsEmpty());
    end;
}

