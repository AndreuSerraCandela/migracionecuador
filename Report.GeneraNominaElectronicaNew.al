report 76050 "Genera Nomina Electronica-New"
{
    DefaultLayout = RDLC;
    RDLCLayout = './GeneraNominaElectronicaNew.rdlc';
    Caption = 'Generate Electronic Payroll';

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING("No.") WHERE("Forma de Cobro" = FILTER(Cheque | "Transferencia Banc."));
            column(Total; Total)
            {
                DecimalPlaces = 2 : 2;
            }
            column(Contador; Contador)
            {
                //Comentado DecimalPlaces = 2 : 2;
            }
            column(Total_EmpleadosCaption; Total_EmpleadosCaptionLbl)
            {
            }
            column(Employee_No_; "No.")
            {
            }
            dataitem("Historico Cab. nomina"; "Historico Cab. nomina")
            {
                DataItemLink = "No. empleado" = FIELD("No.");
                DataItemTableView = SORTING("No. empleado", Ano, "Período", "Tipo Nomina");
                RequestFilterFields = "Período", "Tipo de nomina";
                column(USERID; UserId)
                {
                }
                /*column(CurrReport_PAGENO; CurrReport.PageNo)
                {
                }*/
                column(COMPANYNAME; CompanyName)
                {
                }
                column(CURRENTDATETIME; CurrentDateTime)
                {
                }
                column(TODAY; Today)
                {
                }
                column(fechatrans; fechatrans)
                {
                }
                column("Empresa__Nombre_Empresa_cotización_"; Empresa."Nombre Empresa cotizacinn")
                {
                }
                column(Xbancos__Nombre_banco_; Xbancos."Nombre banco")
                {
                }
                column(Empresa__ID__Volante_Pago_; Empresa."ID  Volante Pago")
                {
                }
                column("Empresa_Dirección_________Empresa_Número"; Empresa.Direccion + ', ' + Empresa.Numero)
                {
                }
                column("Histórico_Cab__nómina_Fin"; Fin)
                {
                }
                column("Histórico_Cab__nómina_Inicio"; Inicio)
                {
                }
                column(Employee__Document_ID_; Employee."Document ID")
                {
                }
                column(Distrib__Ingreso_Pagos_Elect____Numero_Cuenta_; "Distrib. Ingreso Pagos Elect."."Numero Cuenta")
                {
                }
                column(Employee__Full_Name_; Employee."Full Name")
                {
                }
                column(Total_Ingresos___Total_deducciones_; "Total Ingresos" + "Total deducciones")
                {
                    DecimalPlaces = 2 : 2;
                }
                column(Employee__No__; Employee."No.")
                {
                }
                column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Bank_s_electronic_payroll_paymentCaption; Bank_s_electronic_payroll_paymentCaptionLbl)
                {
                }
                column("Fecha_de_envíoCaption"; Fecha_de_envíoCaptionLbl)
                {
                }
                column(Fecha_de_TransferenciaCaption; Fecha_de_TransferenciaCaptionLbl)
                {
                }
                column(EmpresaCaption; EmpresaCaptionLbl)
                {
                }
                column("Cédula___PasaporteCaption"; Cédula___PasaporteCaptionLbl)
                {
                }
                column(NombreCaption; NombreCaptionLbl)
                {
                }
                column(ImporteCaption; ImporteCaptionLbl)
                {
                }
                column(Al__Caption; Al__CaptionLbl)
                {
                }
                column("Periodo_de_nómina_del_Caption"; Periodo_de_nómina_del_CaptionLbl)
                {
                }
                column(CuentaCaption; CuentaCaptionLbl)
                {
                }
                column(Employee__No__Caption; Employee__No__CaptionLbl)
                {
                }
                column("Histórico_Cab__nómina_No__empleado"; "No. empleado")
                {
                }
                column("Histórico_Cab__nómina_Ano"; Ano)
                {
                }
                column("Histórico_Cab__nómina_Período"; Período)
                {
                }
                column("Histórico_Cab__nómina_Tipo_Nomina"; "Tipo Nomina")
                {
                }
                dataitem("Distrib. Ingreso Pagos Elect."; "Distrib. Ingreso Pagos Elect.")
                {
                    DataItemLink = "No. empleado" = FIELD("No. empleado");
                    DataItemTableView = SORTING("No. empleado", "Cod. Banco");
                }

                trigger OnAfterGetRecord()
                begin
                    CalcFields("Total Ingresos", "Total deducciones");
                    if "Total Ingresos" + "Total deducciones" < 1 then
                        CurrReport.Skip;

                    //Total += ROUND("Total Ingresos" + "Total deducciones",0.01);
                    recLinNom.Reset;
                    recLinNom.SetCurrentKey("No. empleado", "Tipo Nómina", Período, "No. Orden");
                    recLinNom.SetRange("No. empleado", "No. empleado");
                    recLinNom.SetRange("No. Documento", "No. Documento");
                    recLinNom.SetRange("Tipo Nómina", "Tipo Nomina");
                    recLinNom.SetRange(Período, Período);
                    recLinNom.SetRange("Excluir de listados", false);
                    if recLinNom.FindSet then
                        repeat
                            Total += Round(recLinNom.Total, 0.01);
                        until recLinNom.Next = 0;
                    Contador := Contador + 1;
                    "Distrib. Ingreso Pagos Elect.".Reset;
                    "Distrib. Ingreso Pagos Elect.".SetRange("No. empleado", "No. empleado");
                    "Distrib. Ingreso Pagos Elect.".FindFirst;
                end;

                trigger OnPreDataItem()
                begin
                    //IF TipoBanco  <> TipoBanco::Popular THEN
                    SetRange("Forma de Cobro", "Forma de Cobro"::"Transferencia Banc.");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if Empresa.Banco = '' then
                    Error(Err001);
            end;

            trigger OnPreDataItem()
            begin
                Empresa.FindFirst;
                Empresa.TestField("RNC/CED");
                RNC := DelChr(Empresa."RNC/CED", '=', '-');
                Xbancos.Get(Empresa.Banco);
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
                field(fechatrans; fechatrans)
                {
                ApplicationArea = All;
                    Caption = 'Efective Date';
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

    trigger OnPostReport()
    begin
        ConfNomina.Get();
        ConfNomina.TestField("Codeunit Archivos Electronicos");

        "Historico Cab. nomina"."Tipo Archivo" := 1;
        "Historico Cab. nomina"."Fecha Pago" := fechatrans;

        CODEUNIT.Run(ConfNomina."Codeunit Archivos Electronicos", "Historico Cab. nomina");
    end;

    var
        ConfNomina: Record "Configuracion nominas";
        Empresa: Record "Empresas Cotizacion";
        BancosACH: Record "Bancos ACH Nomina";
        recLinNom: Record "Historico Lin. nomina";
        Mes: Integer;
        Concepto: Text[36];
        Libre: Text[30];
        Total: Decimal;
        fechatrans: Date;
        Total1: Decimal;
        Xbancos: Record Bancos;
        transac: Integer;
        Lin_Header: Text[500];
        Lin_Body: Text[500];
        FicheroTemporal: File;
        Fichero: File;
        Contador: Integer;
        I: Integer;
        TipoBanco: Option Popular,Leon,Scotiabank,Reservas,BHD;
        dir: Text[30];
        fich: Text[250];
        "Path Documento": Text[250];
        Date: Date;
        Strin: Integer;
        NroBatch: Text[6];
        PageAnt: Integer;
        Blanco: Text[500];
        Err001: Label 'Missing Bank''s information from Company Setup';
        Err002: Label 'The process will be canceled \the bank account is missing for employee %1';
        Text001: Label 'Payroll period ';
        PathENV: Text[250];
        Secuencia: Text[30];
        Text002: Label 'Text documents (*.txt) |*.txt|Word Documents (*.doc*)|*.doc*|All files (*.*)|*.*';
        SecuenciaTrans: Code[7];
        txtHora: Text[30];
        RNC: Text[30];
        NombreArchivo: Text[30];
        Total_EmpleadosCaptionLbl: Label 'Total Employees';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Bank_s_electronic_payroll_paymentCaptionLbl: Label 'Bank''s electronic payroll payment';
        "Fecha_de_envíoCaptionLbl": Label 'Sent date';
        Fecha_de_TransferenciaCaptionLbl: Label 'Transfer date';
        EmpresaCaptionLbl: Label 'Company';
        "Cédula___PasaporteCaptionLbl": Label 'Document ID';
        NombreCaptionLbl: Label 'Name';
        ImporteCaptionLbl: Label 'Amount';
        Al__CaptionLbl: Label 'To :';
        "Periodo_de_nómina_del_CaptionLbl": Label 'Payroll period from :';
        CuentaCaptionLbl: Label 'Account';
        Employee__No__CaptionLbl: Label 'Employee no.';
}

