tableextension 50052 tableextension50052 extends "Finance Charge Memo Header"
{
    fields
    {
        modify(Name)
        {
            Description = '#56924';
        }
        modify("Your Reference")
        {
            Caption = 'Customer PO No.';
        }
        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        modify("Gen. Bus. Posting Group")
        {
            Caption = 'Gen. Bus. Posting Group';
        }
        modify("Fin. Charge Terms Code")
        {
            Caption = 'Fin. Charge Terms Code';
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'VAT Bus. Posting Group';
        }
        field(76041; "No. Serie NCF Facturas"; Code[20])
        {
            Caption = 'NCF Invoice Series No.';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
            TableRelation = "No. Series" WHERE("Descripcion NCF" = FILTER(<> ''));
        }
        field(76079; "No. Comprobante Fiscal"; Code[19])
        {
            Caption = 'Fiscal Document No.';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
        }
        field(76058; "Fecha vencimiento NCF"; Date)
        {
            Caption = 'NCF Due date';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
        }
        field(76007; "Tipo de ingreso"; Code[2])
        {
            Caption = 'Income type';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
            InitValue = '01';
            TableRelation = "Tipos de ingresos";
        }
    }

    //Unsupported feature: Code Modification on ""Customer No."(Field 2).OnValidate".
    //[EventSubscriber(ObjectType::Table, Database::"Finance Charge Memo Header", 'OnValidateCustomerNoOnAfterAssignCustomerValues', '', false, false)] llevarlo a un Codeunit
    local procedure OnValidateCustomerNoOnAfterAssignCustomerValues(var FinanceChargeMemoHeader: Record "Finance Charge Memo Header")
    var
        CustPostingGr: Record "Customer Posting Group";
    begin
        //jpg NCF ++ DSLoc1.04
        CustPostingGr.Get(FinanceChargeMemoHeader."Customer Posting Group");
        FinanceChargeMemoHeader."No. Serie NCF Facturas" := CustPostingGr."No. Serie NCF Factura Venta";
        //jpg NCF -- DSLoc1.04
    end;
}

