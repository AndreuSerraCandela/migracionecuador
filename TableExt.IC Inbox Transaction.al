tableextension 50077 tableextension50077 extends "IC Inbox Transaction"
{
    fields
    {
        modify("IC Account No.")
        {
            Caption = 'IC Account No.';
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

    //Unsupported feature: Variable Insertion (Variable: Text002) (VariableCollection) on "InboxCheckAccept(PROCEDURE 40)".



    //Unsupported feature: Code Modification on "InboxCheckAccept(PROCEDURE 40)".
    //[EventSubscriber(ObjectType::Table, Database::"IC Inbox Transaction", 'OnBeforeInboxCheckAccept', '', false, false)] llevarlo a un Codeunit
    local procedure OnBeforeInboxCheckAccept(var ICInboxTransaction: Record "IC Inbox Transaction"; var IsHandled: Boolean; xICInboxTransaction: Record "IC Inbox Transaction")
    var
        ICInboxTransaction2: Record "IC Inbox Transaction";
        HandledICInboxTrans: Record "Handled IC Inbox Trans.";
        ICInboxPurchHeader: Record "IC Inbox Purchase Header";
        PurchHeader: Record "Purchase Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        ConfirmManagement: Codeunit "Confirm Management";

        TransactionAlreadyExistsInInboxHandledQst: Label '%1 %2 has already been received from intercompany partner %3. Accepting it again will create a duplicate %1. Do you want to accept the %1?', Comment = '%1 - Document Type, %2 - Document No, %3 - IC parthner code';
        Text001: Label 'Transaction No. %2 is a copy of Transaction No. %1, which has already been set to Accept.\Do you also want to accept Transaction No. %2?';
        Text002: Label 'A copy of Transaction No. %1 has already been accepted and is now in the Handled IC Inbox Transactions window.\Do you also want to accept Transaction No. %1?';
        Text003: Label 'A purchase order already exists for transaction %1. If you accept and post this document, you should delete the original purchase order %2 to avoid duplicate postings.';
        Text004: Label 'Purchase invoice %1 has already been posted for transaction %2. If you accept and post this document, you will have duplicate postings.\Are you sure you want to accept the transaction?';
    begin
        HandledICInboxTrans.SetRange("IC Partner Code", "IC Partner Code");
        HandledICInboxTrans.SetRange("Document Type", "Document Type");
        HandledICInboxTrans.SetRange("Source Type", "Source Type");
        HandledICInboxTrans.SetRange("Document No.", "Document No.");
        if HandledICInboxTrans.FindFirst() then
            //if not ConfirmManagement.ConfirmProcess(StrSubstNo(Text002,"Transaction No."),true) then Cambio el metodo
            if not ConfirmManagement.GetResponseOrDefault(StrSubstNo(Text002, "Transaction No."), true) then
                Error('');

        ICInboxTransaction2.SetRange("IC Partner Code", "IC Partner Code");
        ICInboxTransaction2.SetRange("Document Type", "Document Type");
        ICInboxTransaction2.SetRange("Source Type", "Source Type");
        ICInboxTransaction2.SetRange("Document No.", "Document No.");
        ICInboxTransaction2.SetFilter("Transaction No.", '<>%1', "Transaction No.");
        ICInboxTransaction2.SetRange("IC Account No.", "IC Account No.");
        ICInboxTransaction2.SetRange("IC Account Type", "IC Account Type");
        ICInboxTransaction2.SetRange("IC Account No.", "IC Account No.");
        ICInboxTransaction2.SetRange("Source Line No.", "Source Line No.");
        ICInboxTransaction2.SetRange("Line Action", "Line Action"::Accept);
        if ICInboxTransaction2.FindFirst() then
            if not ConfirmManagement.GetResponseOrDefault(
                 StrSubstNo(Text001, ICInboxTransaction2."Transaction No.", "Transaction No."), true)
            then
                Error('');
        if ("Source Type" = "Source Type"::"Purchase Document") and
           ("Document Type" in ["Document Type"::Invoice, "Document Type"::"Credit Memo"])
        then begin
            ICInboxPurchHeader.Get("Transaction No.", "IC Partner Code", "Transaction Source");
            if ICInboxPurchHeader."Your Reference" <> '' then begin
                PurchHeader.SetRange("Your Reference", ICInboxPurchHeader."Your Reference");
                if not PurchHeader.IsEmpty() then
                    Message(Text003, ICInboxPurchHeader."IC Transaction No.", ICInboxPurchHeader."Your Reference")
                else begin
                    PurchInvHeader.SetRange("Your Reference", ICInboxPurchHeader."Your Reference");
                    if PurchInvHeader.FindFirst() then
                        if not ConfirmManagement.GetResponseOrDefault(
                             StrSubstNo(
                               Text004, ICInboxPurchHeader."Your Reference",
                               ICInboxPurchHeader."IC Transaction No."), true)
                        then
                            "Line Action" := xRec."Line Action";
                end;
            end;
        end;

        IsHandled := true;
    end;
}

