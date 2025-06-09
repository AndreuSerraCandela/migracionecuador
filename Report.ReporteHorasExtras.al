report 76001 "Reporte Horas Extras"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReporteHorasExtras.rdlc';
    Caption = 'Template Over Time';

    dataset
    {
        dataitem(Departamentos; Departamentos)
        {
            DataItemTableView = SORTING (Codigo);
            column(COMPANYNAME; CompanyName)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(USERID; UserId)
            {
            }
            column(GETFILTERS; GetFilters)
            {
            }
            column(NombreReporte; NombreReporte)
            {
            }
            column(ImporteTotal; ImporteTotal)
            {
            }
            column(CantGral; CantGral)
            {
            }
            column(CantEmplGral; CantEmplGral)
            {
                DecimalPlaces = 0 : 0;
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Hist_rico_L_n__n_mina__No__empleado_Caption; "Historico Lin. nomina".FieldCaption("No. empleado"))
            {
            }
            column(Employee__Full_Name_Caption; Employee.FieldCaption("Full Name"))
            {
            }
            column(Hist_rico_L_n__n_mina__Importe_Base_Caption; Hist_rico_L_n__n_mina__Importe_Base_CaptionLbl)
            {
            }
            column(Hist_rico_L_n__n_mina_CantidadCaption; "Historico Lin. nomina".FieldCaption(Cantidad))
            {
            }
            column(Hist_rico_L_n__n_mina_TotalCaption; "Historico Lin. nomina".FieldCaption(Total))
            {
            }
            column(Grand_TotalCaption; Grand_TotalCaptionLbl)
            {
            }
            column(Departamentos_Codigo; Codigo)
            {
            }
            dataitem("Sub-Departamentos"; "Sub-Departamentos")
            {
                DataItemLink = "Cod. Departamento" = FIELD (Codigo);
                DataItemTableView = SORTING ("Cod. Departamento", Codigo);
                column(Sub_Departamentos_Cod__Departamento; "Cod. Departamento")
                {
                }
                column(Sub_Departamentos_Codigo; Codigo)
                {
                }
                dataitem(Employee; Employee)
                {
                    DataItemLink = Departamento = FIELD ("Cod. Departamento"), "Sub-Departamento" = FIELD (Codigo);
                    DataItemTableView = SORTING ("No.");
                    RequestFilterFields = "No.";
                    column(Employee_No_; "No.")
                    {
                    }
                    column(Employee_Departamento; Departamento)
                    {
                    }
                    column(Employee_Sub_Departamento; "Sub-Departamento")
                    {
                    }
                    dataitem("Historico Lin. nomina"; "Historico Lin. nomina")
                    {
                        DataItemLink = "No. empleado" = FIELD ("No."), Departamento = FIELD (Departamento), "Sub-Departamento" = FIELD ("Sub-Departamento");
                        DataItemTableView = SORTING (Departamento, "Sub-Departamento", "No. empleado", "Período") WHERE ("Fórmula" = FILTER (<> ''));
                        RequestFilterFields = "Período";
                        column(FIELDCAPTION_Departamento____________Departamento_________Departamentos_Descripcion; FieldCaption(Departamento) + ': ' + Departamento + ', ' + Departamentos.Descripcion)
                        {
                        }
                        column(FIELDCAPTION__Sub_Departamento_____________Sub_Departamento_____________Sub_Departamentos__Descripcion; FieldCaption("Sub-Departamento") + ': ' + "Sub-Departamento" + ', ' + "Sub-Departamentos".Descripcion)
                        {
                        }
                        column(Hist_rico_L_n__n_mina__Importe_Base_; "Importe Base")
                        {
                        }
                        column(Employee__Full_Name_; Employee."Full Name")
                        {
                        }
                        column(Hist_rico_L_n__n_mina__No__empleado_; "No. empleado")
                        {
                        }
                        column(Hist_rico_L_n__n_mina_Cantidad; Cantidad)
                        {
                        }
                        column(Hist_rico_L_n__n_mina_Total; Total)
                        {
                        }
                        column(Hist_rico_L_n__n_mina_Total_Control1000000016; Total)
                        {
                        }
                        column(Hist_rico_L_n__n_mina_Cantidad_Control1000000017; Cantidad)
                        {
                        }
                        column(Text002___FIELDCAPTION__Sub_Departamento______________Sub_Departamentos__Descripcion; Text002 + FieldCaption("Sub-Departamento") + ', ' + "Sub-Departamentos".Descripcion)
                        {
                        }
                        column(CantEmpl; CantEmpl)
                        {
                            DecimalPlaces = 0 : 0;
                        }
                        column(Hist_rico_L_n__n_mina_Total_Control1000000008; Total)
                        {
                        }
                        column(Hist_rico_L_n__n_mina_Cantidad_Control1000000009; Cantidad)
                        {
                        }
                        column(Text002___FIELDCAPTION_Departamento____________Departamentos_Descripcion; Text002 + FieldCaption(Departamento) + ', ' + Departamentos.Descripcion)
                        {
                        }
                        column(CantEmpl_Control1000000020; CantEmpl)
                        {
                            DecimalPlaces = 0 : 0;
                        }
                        column(V1Caption; V1CaptionLbl)
                        {
                        }
                        column("Historico_Lin__nomina_Tipo_Nómina"; "Tipo Nómina")
                        {
                        }
                        column("Historico_Lin__nomina_Período"; Período)
                        {
                        }
                        column(Historico_Lin__nomina_No__Orden; "No. Orden")
                        {
                        }
                        column(Historico_Lin__nomina_Departamento; Departamento)
                        {
                        }
                        column(Historico_Lin__nomina_Sub_Departamento; "Sub-Departamento")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            CantEmpl += 1;
                            CantEmplGral += 1;

                            CantGral += Cantidad;
                            ImporteTotal += Total;
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange("Concepto salarial", Concepto);
                            //CurrReport.CreateTotals(CantEmpl);
                        end;
                    }

                    trigger OnPreDataItem()
                    begin
                        //ConfNominas.GET();
                        //recConceptos.GET(ConfNominas."Dimension Conceptos Salariales",Concepto);
                    end;
                }
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Concepto salarial"; Concepto)
                {
                ApplicationArea = All;
                    TableRelation = "Conceptos salariales".Codigo;
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

    trigger OnPreReport()
    begin
        recConceptos.Get(Concepto);
        NombreReporte := Text001 + recConceptos.Descripcion;
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Text001: Label 'Report of  ';
        NombreReporte: Text[150];
        Concepto: Code[20];
        recConceptos: Record "Conceptos salariales";
        LinEsqPercep: Record "Perfil Salarial";
        _ConfNominas: Record "Configuracion nominas";
        CantEmpl: Decimal;
        CantEmplGral: Decimal;
        CantGral: Decimal;
        ImporteTotal: Decimal;
        Text002: Label 'Total for  ';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
        Hist_rico_L_n__n_mina__Importe_Base_CaptionLbl: Label 'Amount x Hour';
        Grand_TotalCaptionLbl: Label 'Grand Total';
        V1CaptionLbl: Label '1';
}

