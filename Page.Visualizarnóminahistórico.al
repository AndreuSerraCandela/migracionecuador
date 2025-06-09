page 76038 "Visualizar nómina histórico"
{
    ApplicationArea = all;
    Editable = false;
    PageType = Card;
    SourceTable = "Historico Cab. nomina";

    layout
    {
        area(content)
        {
            group(Control1000000013)
            {
                ShowCaption = false;
                field("TotDeveng+TotDeducc"; TotDeveng + TotDeducc)
                {
                    BlankZero = true;
                    Caption = 'Net income';
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                group(Control1000000042)
                {
                    ShowCaption = false;
                    fixed(General)
                    {
                        Caption = 'General';
                        //The GridLayout property is only supported on controls of type Grid
                        //GridLayout = Columns;
                        group(Control1000000004)
                        {
                            ShowCaption = false;
                            field("Conceptos[1]"; Conceptos[1])
                            {
                            }
                            field("Conceptos[2]"; Conceptos[2])
                            {
                            }
                            field("Conceptos[3]"; Conceptos[3])
                            {
                            }
                            field("Conceptos[4]"; Conceptos[4])
                            {
                            }
                            field("Conceptos[5]"; Conceptos[5])
                            {
                            }
                            field("Conceptos[6]"; Conceptos[6])
                            {
                            }
                            field("Conceptos[7]"; Conceptos[7])
                            {
                            }
                            field("Conceptos[8]"; Conceptos[8])
                            {
                            }
                            field("Conceptos[9]"; Conceptos[9])
                            {
                            }
                            field("Conceptos[10]"; Conceptos[10])
                            {
                            }
                            field("Conceptos[11]"; Conceptos[11])
                            {
                            }
                            field("Conceptos[12]"; Conceptos[12])
                            {
                                Style = AttentionAccent;
                                StyleExpr = TRUE;
                            }
                        }
                        group(Control1000000010)
                        {
                            ShowCaption = false;
                            field("Importe[1]"; Importe[1])
                            {
                                BlankZero = true;
                            }
                            field("Importe[2]"; Importe[2])
                            {
                                BlankZero = true;
                            }
                            field("Importe[3]"; Importe[3])
                            {
                                BlankZero = true;
                            }
                            field(Control1000000005; Importe[3])
                            {
                                BlankZero = true;
                            }
                            field("Importe[4]"; Importe[4])
                            {
                                BlankZero = true;
                            }
                            field("Importe[5]"; Importe[5])
                            {
                                BlankZero = true;
                            }
                            field("Importe[6]"; Importe[6])
                            {
                                BlankZero = true;
                            }
                            field("Importe[7]"; Importe[7])
                            {
                                BlankZero = true;
                            }
                            field("Importe[8]"; Importe[8])
                            {
                                BlankZero = true;
                            }
                            field("Importe[9]"; Importe[9])
                            {
                                BlankZero = true;
                            }
                            field("Importe[10]"; Importe[10])
                            {
                                BlankZero = true;
                            }
                            field("Importe[11]"; Importe[11])
                            {
                                BlankZero = true;
                            }
                            field("Importe[12]"; Importe[12])
                            {
                                BlankZero = true;
                            }
                        }
                    }
                    field(TotDeveng; TotDeveng)
                    {
                        BlankZero = true;
                        Caption = 'Total Income';
                    }
                    label(" ")
                    {
                    }
                    fixed(Discounts)
                    {
                        Caption = 'Discounts';
                        //The GridLayout property is only supported on controls of type Grid
                        //GridLayout = Columns;
                        group(Control1000000028)
                        {
                            ShowCaption = false;
                            field("ConcepDed[1]"; ConcepDed[1])
                            {
                            }
                            field("ConcepDed[2]"; ConcepDed[2])
                            {
                            }
                            field("ConcepDed[3]"; ConcepDed[3])
                            {
                            }
                            field("ConcepDed[4]"; ConcepDed[4])
                            {
                            }
                            field("ConcepDed[5]"; ConcepDed[5])
                            {
                            }
                            field("ConcepDed[6]"; ConcepDed[6])
                            {
                            }
                            field("ConcepDed[7]"; ConcepDed[7])
                            {
                            }
                            field("ConcepDed[8]"; ConcepDed[8])
                            {
                            }
                            field("ConcepDed[9]"; ConcepDed[9])
                            {
                            }
                            field("ConcepDed[10]"; ConcepDed[10])
                            {
                            }
                        }
                        group(Control1000000038)
                        {
                            ShowCaption = false;
                            field("ImportDed[1]"; ImportDed[1])
                            {
                                BlankNumbers = BlankZero;
                                BlankZero = true;
                            }
                            field("ImportDed[2]"; ImportDed[2])
                            {
                                BlankZero = true;
                            }
                            field("ImportDed[3]"; ImportDed[3])
                            {
                                BlankZero = true;
                            }
                            field("ImportDed[4]"; ImportDed[4])
                            {
                                BlankZero = true;
                            }
                            field("ImportDed[5]"; ImportDed[5])
                            {
                                BlankZero = true;
                            }
                            field("ImportDed[6]"; ImportDed[6])
                            {
                                BlankNumbers = BlankZero;
                                BlankZero = true;
                            }
                            field("ImportDed[7]"; ImportDed[7])
                            {
                                BlankZero = true;
                            }
                            field("ImportDed[8]"; ImportDed[8])
                            {
                                BlankZero = true;
                            }
                            field("ImportDed[9]"; ImportDed[9])
                            {
                                BlankZero = true;
                            }
                            field("ImportDed[10]"; ImportDed[10])
                            {
                                BlankZero = true;
                            }
                        }
                    }
                    field(TotDeducc; TotDeducc)
                    {
                        BlankZero = true;
                        Caption = 'Total discounts';
                        Style = AttentionAccent;
                        StyleExpr = TRUE;
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        ClearAll;
        RegEmpr.Get(rec."Empresa cotización");
        RegTrab.Get(rec."No. empleado");
        "Lin.nóminas".SetRange("No. empleado", rec."No. empleado");
        "Lin.nóminas".SetRange("Tipo de nomina", rec."Tipo de nomina");
        "Lin.nóminas".SetRange(Período, rec.Período);
        if "Lin.nóminas".FindSet then begin
            repeat
                if "Lin.nóminas"."Tipo concepto" = 0 then begin
                    línea := línea + 1;
                    Conceptos[línea] := "Lin.nóminas".Descripción;
                    Importe[línea] := "Lin.nóminas".Total;
                    TotDeveng := TotDeveng + "Lin.nóminas".Total;
                end;
                if "Lin.nóminas"."Tipo concepto" = 1 then begin
                    lín := lín + 1;
                    ConcepDed[lín] := "Lin.nóminas".Descripción;
                    ImportDed[lín] := "Lin.nóminas".Total;
                    TotDeducc := TotDeducc + "Lin.nóminas".Total;
                end;
            until "Lin.nóminas".Next = 0;
        end;
    end;

    var
        "Lin.nóminas": Record "Historico Lin. nomina";
        RegTrab: Record Employee;
        RegEmpr: Record "Empresas Cotizacion";
        Conceptos: array[12] of Text[40];
        ConcepDed: array[10] of Text[40];
        Importe: array[12] of Decimal;
        ImportDed: array[10] of Decimal;
        "línea": Integer;
        "lín": Integer;
        TotDeveng: Decimal;
        TotDeducc: Decimal;
        Text19056425: Label 'Income';
        Text19063104: Label 'Total Devengado';
        Text19044097: Label 'Base';
        Text19001338: Label 'Deductions';
}

