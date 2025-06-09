pageextension 50080 pageextension50080 extends "Employee Card"
{
    layout
    {
        modify(Gender)
        {
            ToolTip = 'Specifies the employee''s gender.';
        }
        modify(City)
        {
            ToolTip = 'Specifies the city of the address.';
        }
        modify(County)
        {
            ToolTip = 'Specifies the State of the employee.';
        }
        modify("Post Code")
        {
            ToolTip = 'Specifies the ZIP Code.';
        }
        modify("Alt. Address Start Date")
        {
            ToolTip = 'Specifies the starting date when the alternate address is valid.';
        }
        modify("Application Method")
        {
            ToolTip = 'Specifies how to apply payments to entries for this employee.';
        }
        modify("Bank Account No.")
        {
            ToolTip = 'Specifies the number used by the bank for the bank account.';
        }
        // modify("Electronic Document")
        // {
        //     Visible = false;
        // }
        // modify("RFC No.")
        // {
        //     Visible = false;
        // }
        // modify("License No.")
        // {
        //     Visible = false;
        // }
        addafter(Personal)
        {
            group("Bank/Affiliations")
            {
                Caption = 'Bank/Affiliations';
                group(Banco)
                {
                    Caption = 'Banco';
                    field("Forma de Cobro"; rec."Forma de Cobro")
                    {
                        ApplicationArea = All;
                    }
                    field("Disponible 1"; rec."Disponible 1")
                    {
                        ApplicationArea = All;
                    }
                    field("Disponible 2"; rec."Disponible 2")
                    {
                        ApplicationArea = All;
                    }
                    field(Cuenta; rec.Cuenta)
                    {
                        ApplicationArea = All;
                    }
                }
                group("Social Security")
                {
                    Caption = 'Social Security';
                    field("Dia nacimiento"; rec."Dia nacimiento")
                    {
                        ApplicationArea = All;
                    }
                    field("Cod. AFP"; rec."Cod. AFP")
                    {
                        ApplicationArea = All;
                    }
                    field("Cod. ARS"; rec."Cod. ARS")
                    {
                        ApplicationArea = All;
                    }
                    field("Excluído Cotización TSS"; rec."Excluído Cotización TSS")
                    {
                        ApplicationArea = All;
                    }
                    field("Excluído Cotización ISR"; rec."Excluído Cotización ISR")
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
        addafter("Attached Documents List")
        {
            part("Informacion del empleado"; "Informacion del empleado")
            {
                Caption = 'Informacion del empleado';
                applicationArea = Basic, Suite;
            }
            part("Informacion de nominas"; "Informacion de nominas")
            {
                Caption = 'Informacion de nominas';
                applicationArea = Basic, Suite;
            }
        }
    }
}

