page 76039 "Líneas cobros empleado"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = Date;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                ShowCaption = false;
                field("Period Start"; rec."Period Start")
                {
                }
                field("Period Name"; rec."Period Name")
                {
                }
                field("Trab.""Total ingresos"""; Trab."Total ingresos")
                {
                    Caption = 'Total Income';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        MostrarIngresos;
                    end;
                }
                field("Trab.""Total deducciones"""; Trab."Total deducciones")
                {
                    Caption = 'Retenciones ISR';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        MostrarRetenciones;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        AsigFiltFecha;
        Trab.CalcFields("Total ingresos", "Total deducciones");
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        /*    exit(GestionFormPeriodo.FindDate(Which, Rec, LongPeriodoClie)); */
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        /*   exit(GestionFormPeriodo.NextDate(Steps, Rec, LongPeriodoClie)); */
    end;

    trigger OnOpenPage()
    begin
        rec.Reset;
    end;

    var
        Trab: Record Employee;
        LinsNom: Record "Historico Lin. nomina";

        LongPeriodoClie: Option "Día",Semana,Mes,Trimestre,"Año",Periodo;
        TipImporte: Option "Saldo en el periodo","Saldo acumulado a la fecha";


    procedure Def(var NueTrab: Record Employee; LongPeriodoNueClie: Integer; NuevTipImpor: Option "Saldo en el periodo","Saldo acumulado a la fecha")
    begin
        Trab.Copy(NueTrab);
        LongPeriodoClie := LongPeriodoNueClie;
        TipImporte := NuevTipImpor;
        CurrPage.Update(false);
    end;

    local procedure MostrarIngresos()
    begin
        AsigFiltFecha;
        LinsNom.Reset;
        LinsNom.SetCurrentKey("No. empleado", "Tipo Nómina", Período);
        LinsNom.SetRange("No. empleado", Trab."No.");
        LinsNom.SetRange("Tipo concepto", LinsNom."Tipo concepto"::Ingresos);
        //LinsNom.SETFILTER("Tipo Nómina",Trab.GETFILTER("Rango Tipo operacion"));
        LinsNom.SetFilter(Período, Trab.GetFilter(Trab."Date Filter"));
        PAGE.Run(0, LinsNom);
    end;

    local procedure MostrarRetenciones()
    var
        Clie: Record Customer;
        MovClie: Record "Cust. Ledger Entry";
    begin
        AsigFiltFecha;
        LinsNom.Reset;
        LinsNom.SetCurrentKey("No. empleado", "Tipo Nómina", Período);
        LinsNom.SetRange("No. empleado", Trab."No.");
        LinsNom.SetRange("Tipo concepto", LinsNom."Tipo concepto"::Deducciones);
        //LinsNom.SETFILTER("Tipo Nómina",Trab.GETFILTER("Rango Tipo operacion"));
        LinsNom.SetFilter(Período, Trab.GetFilter(Trab."Date Filter"));
        PAGE.Run(0, LinsNom);
    end;

    local procedure AsigFiltFecha()
    begin
        Trab.SetRange("Date Filter", rec."Period Start", rec."Period End")
    end;
}

