page 50002 "Mov GLE"
{
    ApplicationArea = all;
    PageType = List;
    Permissions = TableData "G/L Entry" = rm;
    SourceTable = "G/L Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; rec."Entry No.")
                {
                }
                field("G/L Account No."; rec."G/L Account No.")
                {
                }
                field("Posting Date"; rec."Posting Date")
                {
                }
                field("Document Type"; rec."Document Type")
                {
                }
                field("Document No."; rec."Document No.")
                {
                }
                field(Description; rec.Description)
                {
                }
                field("Bal. Account No."; rec."Bal. Account No.")
                {
                }
                field(Amount; rec.Amount)
                {
                }
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
                {
                }
                field("User ID"; rec."User ID")
                {
                }
                field("Source Code"; rec."Source Code")
                {
                }
                field("System-Created Entry"; rec."System-Created Entry")
                {
                }
                field("Prior-Year Entry"; rec."Prior-Year Entry")
                {
                }
                field("Job No."; rec."Job No.")
                {
                }
                field(Quantity; rec.Quantity)
                {
                }
                field("VAT Amount"; rec."VAT Amount")
                {
                }
                field("Business Unit Code"; rec."Business Unit Code")
                {
                }
                field("Journal Batch Name"; rec."Journal Batch Name")
                {
                }
                field("Reason Code"; rec."Reason Code")
                {
                }
                field("Gen. Posting Type"; rec."Gen. Posting Type")
                {
                }
                field("Gen. Bus. Posting Group"; rec."Gen. Bus. Posting Group")
                {
                }
                field("Gen. Prod. Posting Group"; rec."Gen. Prod. Posting Group")
                {
                }
                field("Bal. Account Type"; rec."Bal. Account Type")
                {
                }
                field("Transaction No."; rec."Transaction No.")
                {
                }
                field("Debit Amount"; rec."Debit Amount")
                {
                }
                field("Credit Amount"; rec."Credit Amount")
                {
                }
                field("Document Date"; rec."Document Date")
                {
                }
                field("External Document No."; rec."External Document No.")
                {
                }
                field("Source Type"; rec."Source Type")
                {
                }
                field("Source No."; rec."Source No.")
                {
                }
                field("No. Series"; rec."No. Series")
                {
                }
                field("Tax Area Code"; rec."Tax Area Code")
                {
                }
                field("Tax Liable"; rec."Tax Liable")
                {
                }
                field("Tax Group Code"; rec."Tax Group Code")
                {
                }
                field("Use Tax"; rec."Use Tax")
                {
                }
                field("VAT Bus. Posting Group"; rec."VAT Bus. Posting Group")
                {
                }
                field("VAT Prod. Posting Group"; rec."VAT Prod. Posting Group")
                {
                }
                field("Additional-Currency Amount"; rec."Additional-Currency Amount")
                {
                }
                field("Add.-Currency Debit Amount"; rec."Add.-Currency Debit Amount")
                {
                }
                field("Add.-Currency Credit Amount"; rec."Add.-Currency Credit Amount")
                {
                }
                field("Close Income Statement Dim. ID"; rec."Close Income Statement Dim. ID")
                {
                }
                field("IC Partner Code"; rec."IC Partner Code")
                {
                }
                field(Reversed; rec.Reversed)
                {
                }
                field("Reversed by Entry No."; rec."Reversed by Entry No.")
                {
                }
                field("Reversed Entry No."; rec."Reversed Entry No.")
                {
                }
                field("G/L Account Name"; rec."G/L Account Name")
                {
                }
                field("Dimension Set ID"; rec."Dimension Set ID")
                {
                }
                field("Prod. Order No."; rec."Prod. Order No.")
                {
                }
                field("FA Entry Type"; rec."FA Entry Type")
                {
                }
                field("FA Entry No."; rec."FA Entry No.")
                {
                }
                // field("STE Transaction ID"; rec."STE Transaction ID")
                // {
                // }
                // field("GST/HST"; rec."GST/HST")
                // {
                // }
                field("RUC/Cedula"; rec."RUC/Cedula")
                {
                }
                field("Tipo de Comprobante"; rec."Tipo de Comprobante")
                {
                }
                field("Sustento del Comprobante"; rec."Sustento del Comprobante")
                {
                }
                field("No. Autorizacion Comprobante"; rec."No. Autorizacion Comprobante")
                {
                }
                field(Establecimiento; rec.Establecimiento)
                {
                }
                field("Punto de Emision"; rec."Punto de Emision")
                {
                }
                field("Fecha Caducidad"; rec."Fecha Caducidad")
                {
                }
                field("Cod. Retencion"; rec."Cod. Retencion")
                {
                }
                field("Caja Chica"; rec."Caja Chica")
                {
                }
                field("Excluir Informe ATS"; rec."Excluir Informe ATS")
                {
                }
                field("Tipo de Identificador"; rec."Tipo de Identificador")
                {
                }
                field("Pago a"; rec."Pago a")
                {
                }
                field("No. Cuenta Original"; rec."No. Cuenta Original")
                {
                }
                field("ID Retencion"; rec."ID Retencion")
                {
                }
                field(Beneficiario; rec.Beneficiario)
                {
                }
                field("No. Mov. cliente provisionado"; rec."No. Mov. cliente provisionado")
                {
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Cod. Vendedor"; rec."Cod. Vendedor")
                {
                }
                field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
                {
                }
                field("Cod. Clasificacion Gasto"; rec."Cod. Clasificacion Gasto")
                {
                }
            }
        }
    }

    actions
    {
    }
}

