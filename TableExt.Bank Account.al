tableextension 50040 tableextension50040 extends "Bank Account"
{
    fields
    {
        modify("Global Dimension 1 Code")
        {
            Caption = 'Global Dimension 1 Code';
        }
        modify("Global Dimension 2 Code")
        {
            Caption = 'Global Dimension 2 Code';
        }
        modify("Bank Acc. Posting Group")
        {
            Caption = 'Bank Acc. Posting Group';
        }
        modify("Check Report ID")
        {
            Caption = 'Check Report ID';
        }
        modify("Check Report Name")
        {
            Caption = 'Check Report Name';
        }
        field(76042; "Identificador Empresa"; Code[5])
        {
            Caption = 'Company indentificator';
            DataClassification = ToBeClassified;
            Description = 'PAGELEC1.0';
        }
        field(76041; Formato; Text[30])
        {
            Caption = 'Format';
            DataClassification = ToBeClassified;
            Description = 'PAGELEC1.0';
        }
        field(76079; Secuencia; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'PAGELEC1.0';
        }
        field(76080; "Tipo Cuenta"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'PAGELEC1.0';
            OptionCaption = 'CC= Cuenta Corriente,CA=Cuenta de Ahorro,TJ= Tarjeta,PR= Préstamo';
            OptionMembers = "CC= Cuenta Corriente","CA=Cuenta de Ahorro","TJ= Tarjeta","PR= Préstamo";
        }
    }
}

