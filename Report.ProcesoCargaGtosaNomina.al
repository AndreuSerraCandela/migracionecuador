report 76279 "Proceso Carga Gtos. a Nomina"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = SORTING ("G/L Account No.", "Posting Date");
            RequestFilterFields = "G/L Account No.", "Posting Date";

            trigger OnAfterGetRecord()
            begin
                Counter := Counter + 1;
                Window.Update(1, "Entry No.");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                DSE.Reset;
                DSE.SetRange("Dimension Set ID", "Dimension Set ID");
                DSE.SetRange("Dimension Code", ConfNomina."Dimension Empleado");
                if DSE.FindFirst then begin
                    DSE2.Reset;
                    DSE2.SetRange("Dimension Set ID", "Dimension Set ID");
                    DSE2.SetRange("Dimension Code", CodDimension);
                    if CodValorDim <> '' then
                        DSE2.SetRange("Dimension Value Code", CodValorDim)
                    else
                        DSE2.SetRange("Dimension Value Code", DSE."Dimension Value Code");
                    if not DSE2.FindFirst then
                        CurrReport.Skip;
                end
                else
                    CurrReport.Skip;

                PF.Reset;
                PF.SetRange("No. empleado", DSE2."Dimension Value Code");
                PF.SetRange("Concepto salarial", ConceptoSalarial);
                if PF.FindFirst then begin
                    PF.Cantidad := 1;
                    PF.Importe := Abs(Amount);
                    PF.Modify;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
            end;

            trigger OnPreDataItem()
            begin
                ConfNomina.Get();
                ConfNomina.TestField("Dimension Empleado");
                Window.Open(Text001);
                CounterTotal := Count;
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
                group(Control1000000001)
                {
                    ShowCaption = false;
                    field(Dimension; CodDimension)
                    {
                    ApplicationArea = All;
                        Caption = 'Dimension Code';
                        TableRelation = Dimension;
                    }
                    field("Valor Dimension"; CodValorDim)
                    {
                    ApplicationArea = All;
                        Caption = 'Dimension Value code';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            dimval: Record "Dimension Value";
                            fDimVal: Page "Dimension Value List";
                        begin
                            dimval.Reset;
                            dimval.SetRange("Dimension Code", CodDimension);
                            fDimVal.SetTableView(dimval);
                            fDimVal.SetRecord(dimval);
                            fDimVal.LookupMode(true);
                            if fDimVal.RunModal = ACTION::LookupOK then begin
                                fDimVal.GetRecord(dimval);
                                CodValorDim := dimval.Code;
                            end;
                            Clear(fDimVal);
                        end;

                        trigger OnValidate()
                        var
                            dimval: Record "Dimension Value";
                        begin
                            if CodValorDim <> '' then begin
                                dimval.Reset;
                                dimval.SetRange("Dimension Code", CodDimension);
                                dimval.SetRange(Code, CodValorDim);
                                dimval.FindFirst;
                            end;
                        end;
                    }
                    field("Concepto Salarial"; ConceptoSalarial)
                    {
                    ApplicationArea = All;
                        Caption = 'Payroll concept';
                        TableRelation = "Conceptos salariales";
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
        ConfNomina: Record "Configuracion nominas";
        GLE: Record "G/L Entry";
        PF: Record "Perfil Salarial";
        DSE: Record "Dimension Set Entry";
        DSE2: Record "Dimension Set Entry";
        CodDimension: Code[20];
        CodValorDim: Code[20];
        ConceptoSalarial: Code[20];
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        Text001: Label 'Processing  #1########## @2@@@@@@@@@@@@@';
        Text002: Label 'Transfer of ';
}

