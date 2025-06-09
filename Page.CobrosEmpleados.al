page 76037 "Cobros Empleados"
{
    ApplicationArea = all;
    PageType = List;
    SaveValues = true;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            part(LinsCobrosTrab; "Líneas cobros empleado")
            {
            }
            field(TipoPeriodo; TipoPeriodo)
            {
                OptionCaption = 'Día,Semana,Mes,Trimestre,Año,Periodo';
                ToolTip = 'Día';

                trigger OnValidate()
                begin
                    if TipoPeriodo = TipoPeriodo::Periodo then
                        PeriodoTipoPeriodoOnValidate;
                    if TipoPeriodo = TipoPeriodo::"Año" then
                        A241oTipoPeriodoOnValidate;
                    if TipoPeriodo = TipoPeriodo::Trimestre then
                        TrimestreTipoPeriodoOnValidate;
                    if TipoPeriodo = TipoPeriodo::Mes then
                        MesTipoPeriodoOnValidate;
                    if TipoPeriodo = TipoPeriodo::Semana then
                        SemanaTipoPeriodoOnValidate;
                    if TipoPeriodo = TipoPeriodo::"Día" then
                        D237aTipoPeriodoOnValidate;
                end;
            }
            field(TipImporte; TipImporte)
            {
                OptionCaption = 'Saldo en el periodo,Saldo acumulado a la fecha';
                ToolTip = 'Saldo periodo';

                trigger OnValidate()
                begin
                    if TipImporte = TipImporte::"Saldo acumulado a la fecha" then
                        SaldoacumuladoaTipImporteOnVal;
                    if TipImporte = TipImporte::"Saldo en el periodo" then
                        SaldoenelperiodTipImporteOnVal;
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        ActuazSubForm;
    end;

    var
        TipoPeriodo: Option "Día",Semana,Mes,Trimestre,"Año",Periodo;
        TipImporte: Option "Saldo en el periodo","Saldo acumulado a la fecha";


    procedure ActuazSubForm()
    begin
        CurrPage.LinsCobrosTrab.PAGE.Def(Rec, TipoPeriodo, TipImporte);
    end;

    local procedure D237aTipoPeriodoOnPush()
    begin
        ActuazSubForm;
    end;

    local procedure SemanaTipoPeriodoOnPush()
    begin
        ActuazSubForm;
    end;

    local procedure MesTipoPeriodoOnPush()
    begin
        ActuazSubForm;
    end;

    local procedure TrimestreTipoPeriodoOnPush()
    begin
        ActuazSubForm;
    end;

    local procedure A241oTipoPeriodoOnPush()
    begin
        ActuazSubForm;
    end;

    local procedure PeriodoTipoPeriodoOnPush()
    begin
        ActuazSubForm;
    end;

    local procedure SaldoacumuladoaTipImportOnPush()
    begin
        ActuazSubForm;
    end;

    local procedure SaldoenelperiodTipImportOnPush()
    begin
        ActuazSubForm;
    end;

    local procedure D237aTipoPeriodoOnValidate()
    begin
        D237aTipoPeriodoOnPush;
    end;

    local procedure SemanaTipoPeriodoOnValidate()
    begin
        SemanaTipoPeriodoOnPush;
    end;

    local procedure MesTipoPeriodoOnValidate()
    begin
        MesTipoPeriodoOnPush;
    end;

    local procedure TrimestreTipoPeriodoOnValidate()
    begin
        TrimestreTipoPeriodoOnPush;
    end;

    local procedure A241oTipoPeriodoOnValidate()
    begin
        A241oTipoPeriodoOnPush;
    end;

    local procedure PeriodoTipoPeriodoOnValidate()
    begin
        PeriodoTipoPeriodoOnPush;
    end;

    local procedure SaldoenelperiodTipImporteOnVal()
    begin
        SaldoenelperiodTipImportOnPush;
    end;

    local procedure SaldoacumuladoaTipImporteOnVal()
    begin
        SaldoacumuladoaTipImportOnPush;
    end;
}

