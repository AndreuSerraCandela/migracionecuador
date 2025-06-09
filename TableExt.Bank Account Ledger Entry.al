tableextension 50042 tableextension50042 extends "Bank Account Ledger Entry"
{
    fields
    {
        modify("Bank Acc. Posting Group")
        {
            Caption = 'Bank Acc. Posting Group';
        }
        modify("Global Dimension 1 Code")
        {
            Caption = 'Global Dimension 1 Code';
        }
        modify("Global Dimension 2 Code")
        {
            Caption = 'Global Dimension 2 Code';
        }
        modify("Closed by Entry No.")
        {
            Caption = 'Closed by Entry No.';
        }
        modify("Reversed by Entry No.")
        {
            Caption = 'Reversed by Entry No.';
        }
        field(50013; "Forma de Pago"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Method";
        }
        field(55000; "ID Retencion"; Code[20])
        {
            Caption = 'ID Retencion';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';

            trigger OnValidate()
            begin
                //001
                if UserSetUp.Get(UserId) then begin
                    if not UserSetUp."Modifica ID Retención Banco" then
                        Error(Error001, FieldCaption("ID Retencion"));
                end
                else
                    Error(Error001, FieldCaption("ID Retencion"));
                //001
            end;
        }
        field(55003; Agencia; Code[20])
        {
            Caption = 'Agency';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(76041; Beneficiario; Text[250])
        {
            Caption = 'Beneficiary';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.01';
            Editable = false;
        }
    }

    var
        UserSetUp: Record "User Setup";
        Error001: Label 'User is not allowed to modify %1';
}

