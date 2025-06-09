report 76131 "Asigna Formula a Conceptos Sal"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Conceptos salariales"; "Conceptos salariales")
        {
            DataItemTableView = SORTING(Codigo);

            trigger OnAfterGetRecord()
            begin
                if ("Tipo sueldo" = 1) and (StrPos(txtFormula, '/') <> 0) then
                    Error(StrSubstNo(Err003, "Tipo sueldo", txtFormula));


                PerfSal.Reset;
                PerfSal.SetRange("Concepto salarial", Codigo);
                PerfSal.FindSet();
                repeat
                    Emp.Get(PerfSal."No. empleado");
                    if Emp."Tipo pago" = "Tipo sueldo" then begin
                        PerfSal.Validate("Formula calculo", txtFormula);
                        PerfSal.Modify;
                    end;
                    "Formula calculo" := txtFormula;
                    Modify;
                until PerfSal.Next = 0;
            end;

            trigger OnPreDataItem()
            begin
                if ConceptoSal = '' then
                    Error(Err001);

                /*IF Formula = '' THEN
                   ERROR(Err002);
                   */
                SetRange(Codigo, ConceptoSal);

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
                group(Control1000000002)
                {
                    ShowCaption = false;
                    field(ConceptoSal; ConceptoSal)
                    {
                    ApplicationArea = All;
                        Caption = 'Wedge';
                        TableRelation = "Conceptos salariales";
                    }
                    field(Formula; txtFormula)
                    {
                    ApplicationArea = All;
                        Caption = 'Formula';
                    }
                    field("Tipo sueldo"; "Tipo sueldo")
                    {
                    ApplicationArea = All;
                        Caption = 'Income type';
                        OptionCaption = 'Fix,Hour';
                    }
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
        Emp: Record Employee;
        PerfSal: Record "Perfil Salarial";
        PerfPuesto: Record "Perfil Salario x Cargo";
        txtFormula: Text[80];
        Err001: Label 'Specify Wedge';
        ConceptoSal: Code[20];
        Err002: Label 'Specify formula to be applied';
        "Tipo sueldo": Option Fijo,"Por hora";
        Err003: Label 'For Salaty type %1 the %2 can not be divided';
}

