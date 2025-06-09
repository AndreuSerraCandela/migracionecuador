page 76381 "Saldos a favor ISR"
{
    ApplicationArea = all;
    AdditionalSearchTerms = 'Income tax balances';
    //ApplicationArea = Basic, Suite, BasicHR;
    Caption = 'Income tax balances';
    PageType = List;
    SourceTable = "Saldos a favor ISR";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Control1100000)
            {
                ShowCaption = false;
                field("Cód. Empleado"; rec."Cód. Empleado")
                {
                }
                field("Full Name"; rec."Full Name")
                {
                }
                field(Ano; rec.Ano)
                {
                }
                field("Saldo a favor"; rec."Saldo a favor")
                {
                }
                field("Importe Pendiente"; rec."Importe Pendiente")
                {
                }
            }
        }
    }

    actions
    {
    }
}

