report 76150 "Cambia tipo nomina a conceptos"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                if Concepto = '' then
                    Error(Err001);

                PerfilSal.Reset;
                PerfilSal.SetRange("Concepto salarial", Concepto);
                PerfilSal.FindSet();
                repeat
                    PerfilSal."Tipo de nomina" := TipoNom;
                    PerfilSal.Modify;
                until PerfilSal.Next = 0;
            end;

            trigger OnPostDataItem()
            begin
                Message(Text001);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field(concep; Concepto)
                {
                ApplicationArea = All;
                    Caption = 'Wage';
                    TableRelation = "Conceptos salariales";
                }
                field(Nvotiponom; TipoNom)
                {
                ApplicationArea = All;
                    Caption = 'New payroll type';
                    //OptionCaption = 'Regular,Christmas,Bonus,Tip,Rent';
                    ValuesAllowed = 'Regular,Christmas,Bonus,Tip,Rent';
                    TableRelation = "Tipos de nominas";
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        PerfilSal: Record "Perfil Salarial";
        Text001: Label 'Update already done, please check the changes';
        TipoNom: Code[20];
        Concepto: Code[20];
        Err001: Label 'Select a wage concept';
}

