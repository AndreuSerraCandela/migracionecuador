report 76063 "Listado de Cheques Nominas"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ListadodeChequesNominas.rdlc';
    Caption = 'Listado de Cheques Nominas';

    dataset
    {
        dataitem("Historico Cab. nomina"; "Historico Cab. nomina")
        {
            CalcFields = "Total Ingresos", "Total deducciones";
            DataItemTableView = SORTING("No. empleado", Ano, "Período", "Tipo Nomina");
            RequestFilterFields = "Tipo de nomina", "No. empleado", "Período";
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
            column(GETFILTERS; GetFilters)
            {
            }
            column("Histórico_Cab__nómina__No__empleado_"; "No. empleado")
            {
            }
            column("Histórico_Cab__nómina_Nombre"; "Full name")
            {
            }
            column("Histórico_Cab__nómina__Tipo_operac__"; "Tipo de nomina")
            {
            }
            column("Histórico_Cab__nómina_Período"; Período)
            {
            }
            column("Histórico_Cab__nómina__Shortcut_Dimension_1_Code_"; "Shortcut Dimension 1 Code")
            {
            }
            column("Histórico_Cab__nómina__Shortcut_Dimension_2_Code_"; "Shortcut Dimension 2 Code")
            {
            }
            column("Histórico_Cab__nómina_Cargo"; Cargo)
            {
            }
            column("Histórico_Cab__nómina__Total_Ingresos_"; "Total Ingresos")
            {
            }
            column("Histórico_Cab__nómina__Total_deducciones_"; "Total deducciones")
            {
            }
            column(Total_Ingresos_____Total_deducciones_; "Total Ingresos" + "Total deducciones")
            {
            }
            column(Total_Ingresos_____Total_deducciones__Control1000000007; "Total Ingresos" + "Total deducciones")
            {
            }
            column("Histórico_Cab__nómina__Total_Ingresos__Control1000000010"; "Total Ingresos")
            {
            }
            column("Histórico_Cab__nómina__Total_deducciones__Control1000000013"; "Total deducciones")
            {
            }
            column(Report_of_payment_with_check_to_employeeCaption; Report_of_payment_with_check_to_employeeCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column("Histórico_Cab__nómina__No__empleado_Caption"; FieldCaption("No. empleado"))
            {
            }
            column("Histórico_Cab__nómina_NombreCaption"; FieldCaption("Full name"))
            {
            }
            column("Histórico_Cab__nómina__Tipo_operac__Caption"; FieldCaption("Tipo de nomina"))
            {
            }
            column("Histórico_Cab__nómina_PeríodoCaption"; FieldCaption(Período))
            {
            }
            column("Histórico_Cab__nómina__Shortcut_Dimension_1_Code_Caption"; FieldCaption("Shortcut Dimension 1 Code"))
            {
            }
            column("Histórico_Cab__nómina__Shortcut_Dimension_2_Code_Caption"; FieldCaption("Shortcut Dimension 2 Code"))
            {
            }
            column("Histórico_Cab__nómina_CargoCaption"; FieldCaption(Cargo))
            {
            }
            column("Histórico_Cab__nómina__Total_Ingresos_Caption"; FieldCaption("Total Ingresos"))
            {
            }
            column("Histórico_Cab__nómina__Total_deducciones_Caption"; FieldCaption("Total deducciones"))
            {
            }
            column(Total_Ingresos_____Total_deducciones_Caption; Total_Ingresos_____Total_deducciones_CaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column("Histórico_Cab__nómina_Ano"; Ano)
            {
            }
            column("Histórico_Cab__nómina_Tipo_Nomina"; "Tipo Nomina")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if GenerarCK then begin
                    GenJnlLine.Init;
                    GenJnlLine.Validate("Journal Template Name", ConfNom."Journal Template Name CK");
                    GenJnlLine.Validate("Journal Batch Name", ConfNom."Journal Batch Name CK");
                    GenJnlLine.Validate("Posting Date", Fin);
                    GenJnlLine."Line No." := NoLin;
                    GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.Validate("Account No.", ConfNom."Cta. Nominas Otros Pagos");
                    GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment);
                    GenJnlLine.Validate("Document No.", "No. Documento");
                    GenJnlLine.Validate(Amount, "Total Ingresos" + "Total deducciones");
                    GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
                    GenJnlLine.Validate("Bal. Account No.", EmpresasCot.Banco);
                    GenJnlLine.Validate("Bank Payment Type", 1);
                    if Tiposdenominas."Tipo de nomina" = Tiposdenominas."Tipo de nomina"::Prestaciones then
                        GenJnlLine.Validate(Description, Text002)
                    else
                        GenJnlLine.Validate(Description, StrSubstNo(Text001, "Tipo de nomina", Inicio, Fin));
                    GenJnlLine.Beneficiario := "Full name";
                    NoLin += 1000;
                    GenJnlLine.Insert;
                end;
            end;

            trigger OnPreDataItem()
            begin
                ConfNom.Get();
                ConfNom.TestField("Journal Template Name CK");
                ConfNom.TestField("Journal Batch Name CK");
                EmpresasCot.FindFirst;
                EmpresasCot.TestField(Banco);
                GenJnlLine.Reset;
                GenJnlLine.SetRange("Journal Template Name", ConfNom."Journal Template Name CK");
                GenJnlLine.SetRange("Journal Batch Name", ConfNom."Journal Batch Name CK");
                if GenJnlLine.FindLast then
                    NoLin := GenJnlLine."Line No."
                else
                    NoLin := 1000;

                NoLin += 1000;
                Tiposdenominas.Get("Historico Cab. nomina".GetRangeMax("Tipo de nomina"));
                if Tiposdenominas."Tipo de nomina" <> Tiposdenominas."Tipo de nomina"::Prestaciones then
                    SetRange("Forma de Cobro", "Forma de Cobro"::Cheque);
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
                field(Mes; GenerarCK)
                {
                ApplicationArea = All;
                    Caption = 'Request Check';
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
        ConfNom: Record "Configuracion nominas";
        EmpresasCot: Record "Empresas Cotizacion";
        GenJnlLine: Record "Gen. Journal Line";
        Tiposdenominas: Record "Tipos de nominas";
        GenerarCK: Boolean;
        NoLin: Integer;
        Text001: Label 'Payment of %1 for period %2 - %3';
        Report_of_payment_with_check_to_employeeCaptionLbl: Label 'Report of payment with check to employee';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
        Total_Ingresos_____Total_deducciones_CaptionLbl: Label 'Net Amount';
        TotalCaptionLbl: Label 'Total';
        Text002: Label 'Payment of end of labor contract';
}

