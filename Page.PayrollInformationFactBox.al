page 76343 "Payroll Information FactBox"
{
    ApplicationArea = all;
    Caption = 'Payroll Information';
    PageType = CardPart;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            /*             field("STRSUBSTNO('(%1)',CUNomina.BuscaNominas(Rec))"; rec.StrSubstNo('(%1)', CUNomina.BuscaNominas(Rec)))
                        {
                            Caption = 'Payroll';
                            Editable = false;

                            trigger OnDrillDown()
                            begin

                            end;
                        }
                        field("STRSUBSTNO('(%1)',CUNomina.BuscaSaldoISRFavor(Rec))"; rec.StrSubstNo('(%1)', CUNomina.BuscaSaldoISRFavor(Rec)))
                        {
                            Caption = 'Tax balance';

                            trigger OnDrillDown()
                            begin

                            end;
                        } */
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin

    end;

    var

}

