report 56187 "AF a Concil. Contable"
{
    // MOI - 26/02/2015(#11502): Se crea el report.
    DefaultLayout = RDLC;
    RDLCLayout = './AFaConcilContable.rdlc';


    dataset
    {
        dataitem(GrupoActivosFijos; "FA Posting Group")
        {
            DataItemTableView = SORTING(Code) ORDER(Ascending);
            column(C_TITULOREPORT; TextTituloReport)
            {
            }
            column(C_USUARIO; TextUsuario)
            {
            }
            column(C_PAGINA; TextPagina)
            {
            }
            column(C_FECHA; TextFecha)
            {
            }
            column(C_FILTROS; TextFiltros)
            {
            }
            column(C_GRUPOCONTABLE; TextGrupoContable)
            {
            }
            column(C_CUENTACOSTOS; TextCuentaCostos)
            {
            }
            column(C_COSTOAUXILIAR; TextCostoAuxFecha)
            {
            }
            column(C_SALDO; TextSaldoCuenta)
            {
            }
            column(C_DIFERENCIA; TextDiferiencia)
            {
            }
            column(C_CUENTAAMORTIZACION; TextCuentaAmort)
            {
            }
            column(C_AMORTIZACIONACUMULDA; TextAmortAuxFecha)
            {
            }
            column(filtro; gdtFechaConciliacion)
            {
            }
            column(grupo_contable; GrupoActivosFijos.Code)
            {
            }
            column(cuenta_costo; GrupoActivosFijos."Acquisition Cost Account")
            {
            }
            column(cuenta_amortizacion_acumulada; GrupoActivosFijos."Accum. Depreciation Account")
            {
            }
            column(Costo_auxiliar; gdCosto)
            {
            }
            column(Amort_Acum; gdAmortizacion)
            {
            }
            column(Saldo_Costo; gdSaldoCosto)
            {
            }
            column(Saldo_Amortizacion; gdSaldoAmortizacion)
            {
            }
            column(Diferencia_Costos; gdDiferenciaCosto)
            {
            }
            column(Diferencia_Amortizacion; gdDiferenciaAmortizacion)
            {
            }

            trigger OnAfterGetRecord()
            begin
                gdCosto := calcularCostos;
                gdAmortizacion := -calcularAmortizacion;
                gdSaldoCosto := calcularSaldoCostos;
                gdSaldoAmortizacion := -calcularSaldoAmortizacion;

                gdDiferenciaCosto := gdSaldoCosto - gdCosto;
                gdDiferenciaAmortizacion := gdSaldoAmortizacion - gdAmortizacion;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Fecha Conciliacion"; gdtFechaConciliacion)
                {
                ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if gdtFechaConciliacion = 0D then
                            Error('la fecha no puesde ser vacia...');
                    end;
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
        TextTituloReport: Label 'AF a Conciliacion Contable';
        TextUsuario: Label 'Usuario: ';
        TextPagina: Label 'Pagina: ';
        TextFecha: Label 'Fecha: ';
        TextFiltros: Label 'Filtros: ';
        gcGrupoContable: Code[10];
        TextGrupoContable: Label 'Grupo Contable';
        TextCuentaCostos: Label 'Cta. Costo';
        TextCostoAuxFecha: Label 'Costo auxiliar a fecha';
        TextSaldoCuenta: Label 'Saldo cta';
        TextDiferiencia: Label 'Diferencia';
        TextCuentaAmort: Label 'Cta. Amort. Acumulada';
        TextAmortAuxFecha: Label 'Amort. acum. auxiliar a fecha';
        gdtFechaConciliacion: Date;
        gdCosto: Decimal;
        gdAmortizacion: Decimal;
        gdSaldoCosto: Decimal;
        gdSaldoAmortizacion: Decimal;
        gdDiferenciaCosto: Decimal;
        gdDiferenciaAmortizacion: Decimal;


    procedure calcularCostos(): Decimal
    var
        lrMovActivosFijos: Record "FA Ledger Entry";
    begin
        lrMovActivosFijos.Reset;
        lrMovActivosFijos.SetCurrentKey("FA No.", "Depreciation Book Code", "FA Posting Category", "FA Posting Type", "FA Posting Date", "Part of Book Value", "Reclassification Entry");
        lrMovActivosFijos.SetRange("FA Posting Type", lrMovActivosFijos."FA Posting Type"::"Acquisition Cost");
        lrMovActivosFijos.SetRange("FA Posting Date", 0D, gdtFechaConciliacion);
        lrMovActivosFijos.SetRange("FA Posting Group", GrupoActivosFijos.Code);
        lrMovActivosFijos.CalcSums(Amount);
        exit(lrMovActivosFijos.Amount);
    end;


    procedure calcularAmortizacion(): Decimal
    var
        lrMovActivosFijos: Record "FA Ledger Entry";
    begin
        lrMovActivosFijos.Reset;
        lrMovActivosFijos.SetCurrentKey("FA No.", "Depreciation Book Code", "FA Posting Category", "FA Posting Type", "FA Posting Date", "Part of Book Value", "Reclassification Entry");
        lrMovActivosFijos.SetRange("FA Posting Type", lrMovActivosFijos."FA Posting Type"::Depreciation);
        lrMovActivosFijos.SetRange("FA Posting Date", 0D, gdtFechaConciliacion);
        lrMovActivosFijos.SetRange("FA Posting Group", GrupoActivosFijos.Code);
        lrMovActivosFijos.CalcSums(Amount);
        exit(lrMovActivosFijos.Amount);
    end;


    procedure calcularSaldoCostos(): Decimal
    var
        lrMovContabilidad: Record "G/L Entry";
    begin
        lrMovContabilidad.Reset;
        lrMovContabilidad.SetCurrentKey("G/L Account No.", "Posting Date");
        lrMovContabilidad.SetRange("G/L Account No.", GrupoActivosFijos."Acquisition Cost Account");
        lrMovContabilidad.SetRange(lrMovContabilidad."Posting Date", 0D, gdtFechaConciliacion);
        lrMovContabilidad.CalcSums(Amount);
        exit(lrMovContabilidad.Amount);
    end;


    procedure calcularSaldoAmortizacion(): Decimal
    var
        lrMovContabilidad: Record "G/L Entry";
    begin
        lrMovContabilidad.Reset;
        lrMovContabilidad.SetCurrentKey("G/L Account No.", "Posting Date");
        lrMovContabilidad.SetRange("G/L Account No.", GrupoActivosFijos."Accum. Depreciation Account");
        lrMovContabilidad.SetRange(lrMovContabilidad."Posting Date", 0D, gdtFechaConciliacion);
        lrMovContabilidad.CalcSums(Amount);
        exit(lrMovContabilidad.Amount);
    end;
}

