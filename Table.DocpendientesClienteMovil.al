table 56027 "Doc. pendientes Cliente Movil."
{

    fields
    {
        field(1; "Cod. Cliente"; Code[20])
        {
            Caption = 'Customer Code';
        }
        field(2; Nombre; Text[200])
        {
            Caption = 'Name';
        }
        field(3; "Tipo Documento"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(4; "No. Documento"; Code[20])
        {
            Caption = 'Document No.';
        }
        field(5; "Fecha Registro"; Date)
        {
            Caption = 'Posting Date';
        }
        field(6; "Fecha Vencimiento"; Date)
        {
            Caption = 'Due Date';
        }
        field(7; "Importe inicial"; Decimal)
        {
            Caption = 'Initial Amount';
        }
        field(8; "Importe Pendiente"; Decimal)
        {
            Caption = 'Remaining Amount';
        }
        field(9; "Cod. Divisa"; Code[20])
        {
            Caption = 'Currency Code';
        }
        field(10; "Fecha Ult. Actualizacion"; Date)
        {
            Caption = 'Last Update Date';
        }
        field(11; "No. Doc. Externo"; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(12; "Importe inicial ($)"; Decimal)
        {
            Caption = 'Initial Amount ($)';
        }
        field(13; "Importe Pendiente ($)"; Decimal)
        {
            Caption = 'Remaining Amount ($)';
        }
    }

    keys
    {
        key(Key1; "Cod. Cliente")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

