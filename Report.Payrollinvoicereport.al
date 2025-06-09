report 76062 "Payroll invoice report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Payrollinvoicereport.rdlc';
    Caption = 'Payroll invoice report';

    dataset
    {
        dataitem("Historico Cab. nomina"; "Historico Cab. nomina")
        {
            DataItemTableView = SORTING ("No. empleado", Ano, "Período", "Tipo Nomina");
            RequestFilterFields = "No. empleado", Ano, "Período", "Tipo Nomina";
            column(Empl__No__; Empl."No.")
            {
            }
            column(Empl__Document_ID_; Empl."Document ID")
            {
            }
            column(Empl__Full_Name_; Empl."Full Name")
            {
            }
            column("PuestoTrab_Descripción"; PuestoTrab.Descripcion)
            {
            }
            column("Histórico_Cab__nómina__Fecha_Entrada_"; "Fecha Entrada")
            {
            }
            column(EmpresaCot_Imagen; EmpresaCot.Imagen)
            {
            }
            column(UPPERCASE_txtPeriodo_; UpperCase(txtPeriodo))
            {
            }
            column(EmpresaCot_Municipio; EmpresaCot.Municipio)
            {
            }
            column("EmpresaCot_Dirección"; EmpresaCot.Direccion)
            {
            }
            column(EmpresaCot__RNC_CED_; EmpresaCot."RNC/CED")
            {
            }
            column(Document_ID_Caption; Document_ID_CaptionLbl)
            {
            }
            column(EMPLOYEECaption; EMPLOYEECaptionLbl)
            {
            }
            column(CargoCaption; CargoCaptionLbl)
            {
            }
            column("Histórico_Cab__nómina__Fecha_Entrada_Caption"; Histórico_Cab__nómina__Fecha_Entrada_CaptionLbl)
            {
            }
            column(DESCRIPTIONCaption; DESCRIPTIONCaptionLbl)
            {
            }
            column(QUANTITYCaption; QUANTITYCaptionLbl)
            {
            }
            column(AMOUNTCaption; AMOUNTCaptionLbl)
            {
            }
            column(YTDCaption; YTDCaptionLbl)
            {
            }
            column(Historico_Cab__nomina_No__empleado; "No. empleado")
            {
            }
            column(Historico_Cab__nomina_Ano; Ano)
            {
            }
            column(Historico_Cab__nomina_Per_odo; Período)
            {
            }
            column(Historico_Cab__nomina_Tipo_Nomina; "Tipo Nomina")
            {
            }
            column(Historico_Cab__nomina_No__Documento; "No. Documento")
            {
            }
            dataitem(Ingresos; "Historico Lin. nomina")
            {
                DataItemLink = "No. Documento" = FIELD ("No. Documento"), "No. empleado" = FIELD ("No. empleado"), "Tipo Nómina" = FIELD ("Tipo Nomina");
                DataItemTableView = SORTING ("No. empleado", "Tipo Nómina", "Período", "Tipo concepto", "Concepto salarial") WHERE ("Texto Informativo" = CONST (false));
                column("Ingresos_Descripción"; Descripción)
                {
                }
                column(Ingresos_Cantidad; Cantidad)
                {
                }
                column(Ingresos_Total; Total)
                {
                }
                column(Acumulado_Total; Acumulado.Total)
                {
                }
                column(Ingresos_Total_Control1000000041; Total)
                {
                }
                column(Text001___FORMAT__Tipo_concepto__; Text001 + Format("Tipo concepto"))
                {
                }
                column(Ingresos_Total_Control1000000042; Total)
                {
                }
                column(I__EARNINGSCaption; I__EARNINGSCaptionLbl)
                {
                }
                column(II__DEDUCTIONSCaption; II__DEDUCTIONSCaptionLbl)
                {
                }
                column(NET_AMOUNTCaption; NET_AMOUNTCaptionLbl)
                {
                }
                column(Ingresos_No__empleado; "No. empleado")
                {
                }
                column("Ingresos_Tipo_Nómina"; "Tipo Nómina")
                {
                }
                column("Ingresos_Período"; Período)
                {
                }
                column(Ingresos_No__Orden; "No. Orden")
                {
                }
                column(Ingresos_Tipo_concepto; "Tipo concepto")
                {
                }
                column(Ingresos_No__Documento; "No. Documento")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Acumulado.Reset;
                    Acumulado.SetCurrentKey("No. empleado", "Tipo concepto", Período, "Concepto salarial");
                    Acumulado.SetRange("No. empleado", "No. empleado");
                    Acumulado.SetRange("Concepto salarial", "Concepto salarial");
                    Acumulado.SetRange(Período, DMY2Date(1, 1, Ano), Período);
                    Acumulado.CalcSums(Total);

                    if Cantidad = 1 then
                        Cantidad := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if Date2DMY(Inicio, 1) = 1 then
                    txtPeriodo := StrSubstNo(Text002, FieldCaption("Tipo Nomina") + ' ' + Format("Tipo Nomina"),
                                  Text003 + ', ' + Format(Inicio, 0, '<Month text>, <Year4>'))
                else
                    txtPeriodo := StrSubstNo(Text002, FieldCaption("Tipo Nomina") + ' ' + Format("Tipo Nomina"),
                                  Text004 + ', ' + Format(Inicio, 0, '<Month text>, <Year4>'));

                Empl.Get("No. empleado");
                PuestoTrab.Get(Empl."Job Type Code");
            end;

            trigger OnPreDataItem()
            begin
                EmpresaCot.FindFirst;
                EmpresaCot.CalcFields(Imagen);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        EmpresaCot: Record "Empresas Cotizacion";
        Empl: Record Employee;
        Banco: Record Bancos;
        PuestoTrab: Record "Puestos laborales";
        Acumulado: Record "Historico Lin. nomina";
        txtPeriodo: Text[150];
        Text001: Label 'Total for ';
        Text002: Label 'Receipt for payment of %1 period %2';
        Text003: Label '1st Half month';
        Text004: Label '2nd Half month';
        Document_ID_CaptionLbl: Label 'Document ID:';
        EMPLOYEECaptionLbl: Label 'EMPLOYEE';
        CargoCaptionLbl: Label 'Cargo';
        "Histórico_Cab__nómina__Fecha_Entrada_CaptionLbl": Label 'Fecha Entrada';
        DESCRIPTIONCaptionLbl: Label 'DESCRIPTION';
        QUANTITYCaptionLbl: Label 'QUANTITY';
        AMOUNTCaptionLbl: Label 'AMOUNT';
        YTDCaptionLbl: Label 'YTD';
        I__EARNINGSCaptionLbl: Label 'I. EARNINGS';
        II__DEDUCTIONSCaptionLbl: Label 'II. DEDUCTIONS';
        NET_AMOUNTCaptionLbl: Label 'NET AMOUNT';
}

