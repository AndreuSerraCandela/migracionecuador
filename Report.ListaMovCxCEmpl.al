report 76065 "Lista Mov. CxC Empl."
{
    DefaultLayout = RDLC;
    RDLCLayout = './ListaMovCxCEmpl.rdlc';

    dataset
    {
        dataitem("Histórico Cab. Préstamo"; "Histórico Cab. Préstamo")
        {
            CalcFields = "Importe Original", "Importe Pendiente";
            DataItemTableView = SORTING("Employee No.", "No. Préstamo") WHERE("No. Documento" = FILTER(<> '0'));
            RequestFilterFields = "No. Préstamo", "Employee No.";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            /*column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }*/
            column(USERID; UserId)
            {
            }
            column(TIME; Time)
            {
            }
            column(Hist_rico_Cab__Pr_stamo__No__Pr_stamo_; "No. Préstamo")
            {
            }
            column(Hist_rico_Cab__Pr_stamo__C_digo_Empleado_; "Employee No.")
            {
            }
            column(Hist_rico_Cab__Pr_stamo__Fecha_Registro_CxC_; "Fecha Registro CxC")
            {
            }
            column(Hist_rico_Cab__Pr_stamo__Importe_Cuota_; "Importe Cuota")
            {
            }
            column(Hist_rico_Cab__Pr_stamo__No__Documento_; "No. Documento")
            {
            }
            column(Hist_rico_Cab__Pr_stamo__Importe_Original_; "Importe Original")
            {
            }
            column(Hist_rico_Cab__Pr_stamo__Importe_Pendiente_; "Importe Pendiente")
            {
            }
            column(Emp__Full_Name_; Emp."Full Name")
            {
            }
            column(Detallado; Detallado)
            {
            }
            column(Hist_rico_Cab__Pr_stamo__Hist_rico_Cab__Pr_stamo___Importe_Pendiente_; "Histórico Cab. Préstamo"."Importe Pendiente")
            {
            }
            column(Hist_rico_Cab__Pr_stamo__Hist_rico_Cab__Pr_stamo___Importe_Original_; "Histórico Cab. Préstamo"."Importe Original")
            {
            }
            column(Movs__CxC_EmpleadosCaption; Movs__CxC_EmpleadosCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Hist_rico_Cab__Pr_stamo__No__Pr_stamo_Caption; FieldCaption("No. Préstamo"))
            {
            }
            column(Hist_rico_Cab__Pr_stamo__C_digo_Empleado_Caption; FieldCaption("Employee No."))
            {
            }
            column(Hist_rico_Cab__Pr_stamo__Fecha_Registro_CxC_Caption; FieldCaption("Fecha Registro CxC"))
            {
            }
            column(Hist_rico_Cab__Pr_stamo__Importe_Cuota_Caption; FieldCaption("Importe Cuota"))
            {
            }
            column(Hist_rico_Cab__Pr_stamo__No__Documento_Caption; FieldCaption("No. Documento"))
            {
            }
            column(Hist_rico_Cab__Pr_stamo__Importe_Original_Caption; FieldCaption("Importe Original"))
            {
            }
            column(Hist_rico_Cab__Pr_stamo__Importe_Pendiente_Caption; Hist_rico_Cab__Pr_stamo__Importe_Pendiente_CaptionLbl)
            {
            }
            column(Hist_rico_L_n__Pr_stamo_ImporteCaption; "Histórico Lín. Préstamo".FieldCaption(Importe))
            {
            }
            column(Hist_rico_L_n__Pr_stamo__D_bito_Caption; "Histórico Lín. Préstamo".FieldCaption(Débito))
            {
            }
            column(Hist_rico_L_n__Pr_stamo__Cr_dito_Caption; "Histórico Lín. Préstamo".FieldCaption(Crédito))
            {
            }
            column(Hist_rico_L_n__Pr_stamo__Fecha_Transacci_n_Caption; "Histórico Lín. Préstamo".FieldCaption("Fecha Transacción"))
            {
            }
            column(Hist_rico_L_n__Pr_stamo__No__Cuota_Caption; "Histórico Lín. Préstamo".FieldCaption("No. Cuota"))
            {
            }
            column(Emp__Full_Name_Caption; Emp__Full_Name_CaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            dataitem("Histórico Lín. Préstamo"; "Histórico Lín. Préstamo")
            {
                DataItemLink = "No. Préstamo" = FIELD("No. Préstamo"), "Código Empleado" = FIELD("Employee No.");
                DataItemTableView = SORTING("No. Préstamo", "No. Línea");
                column(Hist_rico_L_n__Pr_stamo_Importe; Importe)
                {
                }
                column(Hist_rico_L_n__Pr_stamo__D_bito_; Débito)
                {
                }
                column(Hist_rico_L_n__Pr_stamo__Cr_dito_; Crédito)
                {
                }
                column(Hist_rico_L_n__Pr_stamo__No__Cuota_; "No. Cuota")
                {
                }
                column(Hist_rico_L_n__Pr_stamo__Fecha_Transacci_n_; "Fecha Transacción")
                {
                }
                column("Histórico_Lín__Préstamo_No__Préstamo"; "No. Préstamo")
                {
                }
                column("Histórico_Lín__Préstamo_No__Línea"; "No. Línea")
                {
                }
                column("Histórico_Lín__Préstamo_Código_Empleado"; "Código Empleado")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                rMovCxC.SetRange("No. Préstamo", "No. Préstamo");
                rMovCxC.SetRange("No. Documento", "No. Documento");
                rMovCxC.FindFirst;
                Pendiente := true;

                Emp.Get("Employee No.");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Detallado; Detallado)
                {
                ApplicationArea = All;
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
        rMovCxC: Record "Histórico Cab. Préstamo";
        TotalFor: Label 'Total para ';
        Emp: Record Employee;
        Detallado: Boolean;
        Pendiente: Boolean;
        Movs__CxC_EmpleadosCaptionLbl: Label 'Movs. CxC Empleados';
        CurrReport_PAGENOCaptionLbl: Label 'página';
        Hist_rico_Cab__Pr_stamo__Importe_Pendiente_CaptionLbl: Label 'Importe pendiente';
        Emp__Full_Name_CaptionLbl: Label 'Full name';
        TotalCaptionLbl: Label 'Total';
}

