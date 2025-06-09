report 76068 "Listado Novedades TSS"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ListadoNovedadesTSS.rdlc';

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";
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
            column(Employee__No__; "No.")
            {
            }
            column(Employee__Full_Name_; "Full Name")
            {
            }
            column(Employee__Document_ID_; "Document ID")
            {
            }
            column(TipoDoc; TipoDoc)
            {
            }
            column(Employee_Gender; Gender)
            {
            }
            column(Employee__Birth_Date_; "Birth Date")
            {
            }
            column(SalCot; SalCot)
            {
            }
            column(TSS_Update_s_ReportCaption; TSS_Update_s_ReportCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Employee__No__Caption; FieldCaption("No."))
            {
            }
            column(Employee__Full_Name_Caption; FieldCaption("Full Name"))
            {
            }
            column(Employee__Document_ID_Caption; FieldCaption("Document ID"))
            {
            }
            column(TipoDocCaption; TipoDocCaptionLbl)
            {
            }
            column(Employee_GenderCaption; Employee_GenderCaptionLbl)
            {
            }
            column(Employee__Birth_Date_Caption; FieldCaption("Birth Date"))
            {
            }
            column(SalCotCaption; SalCotCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Texto := 'D';
                Texto += '001';
                Evaluate(iMes, Mestxt);
                Evaluate(iAno, Ano);
                wDate := WorkDate;
                TestField("Employment Date");
                if (Date2DMY("Employment Date", 2) = iMes) and
                   (Date2DMY("Employment Date", 3) = iAno) then
                    Texto += 'IN'
                else
                    if (Date2DMY("Employment Date", 2) >= iMes) and
                       (Date2DMY("Employment Date", 3) <= iAno) then begin
                        //Comentado CalFecha.CalculoEntreFechas("Employment Date", wDate, iAno, iMes, iDia);
                        if iAno > 0 then begin
                            if (iAno >= 1) and (iAno < 5) then
                                DiasVacaciones := 14
                            else
                                if iAno >= 5 then
                                    DiasVacaciones := 18;
                        end
                        else
                            if Meses > 4 then
                                case Meses of
                                    5:
                                        DiasVacaciones := 6;
                                    6:
                                        DiasVacaciones := 7;
                                    7:
                                        DiasVacaciones := 8;
                                    8:
                                        DiasVacaciones := 9;
                                    9:
                                        DiasVacaciones := 10;
                                    10:
                                        DiasVacaciones := 11;
                                    else
                                        DiasVacaciones := 12;
                                end;

                        if iAno <> 0 then
                            Texto += 'VC'
                    end;

                if "Fecha salida empresa" <> 0D then
                    if (Date2DMY("Fecha salida empresa", 2) >= iMes) and
                       (Date2DMY("Fecha salida empresa", 3) >= iAno) then
                        Texto += 'SA';

                Texto += Format(Format(iDia) + Mestxt + Ano);
                if GenerarArchivo then
                    /*       Archivo.Write(Texto); */
                Clear(Texto);
            end;

            trigger OnPostDataItem()
            begin
                /*            if GenerarArchivo then */
                /*            Archivo.Close; */
            end;

            trigger OnPreDataItem()
            begin
                rCompany.Get();
                if GenerarArchivo then begin
                    /*                     Archivo.WriteMode := true;
                                        Archivo.TextMode := true;
                                        Archivo.Create(Path) */
                    ;
                end;
                rCompany."VAT Registration No." := DelChr(rCompany."VAT Registration No.", '=', '-');
                Texto := 'E';
                Texto += 'NV';
                Texto += Format(rCompany."VAT Registration No.", 11 - StrLen(rCompany."VAT Registration No."), '<Filler Character, >') +
                         rCompany."VAT Registration No.";
                case Mes of
                    0:
                        Mestxt := '01';
                    1:
                        Mestxt := '02';
                    2:
                        Mestxt := '03';
                    3:
                        Mestxt := '04';
                    4:
                        Mestxt := '05';
                    5:
                        Mestxt := '06';
                    6:
                        Mestxt := '07';
                    7:
                        Mestxt := '08';
                    8:
                        Mestxt := '09';
                    9:
                        Mestxt := '10';
                    10:
                        Mestxt := '11';
                    11:
                        Mestxt := '12';
                end;
                Texto += Format(Mestxt + Ano);
                if GenerarArchivo then
                    /*      Archivo.Write(Texto); */
                Clear(Texto);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Mes; Mes)
                {
                ApplicationArea = All;
                }
                field("Año"; Ano)
                {
                ApplicationArea = All;
                }
                field("Ruta archivo"; Path)
                {
                ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        //Path := CommonDialogMgt.OpenFile(Text002,Path,2,'',0);
                    end;
                }
                field("Genera archivo"; GenerarArchivo)
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

    trigger OnInitReport()
    begin
        if Ano = '' then
            Ano := Format(WorkDate, 0, '<Year4>');
    end;

    var
        rCompany: Record "Company Information";
        //Comentado CalFecha: Codeunit "Funciones Nomina";
        TipoDoc: Code[2];
        SalCot: Decimal;
        Archivo: File;
        Path: Text[250];
        Text001: Label 'Text (*.txt)|*.txt|CSV(Comma delimited) *.csv';
        GenerarArchivo: Boolean;
        Texto: Text[500];
        Mes: Option Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre;
        Ano: Code[4];
        Mestxt: Code[2];
        Num: Integer;
        iAno: Integer;
        iMes: Integer;
        iDia: Integer;
        wDate: Date;
        DiasVacaciones: Integer;
        Meses: Integer;
        Text002: Label 'Update Workbook';
        TSS_Update_s_ReportCaptionLbl: Label 'TSS Update''s Report';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        TipoDocCaptionLbl: Label 'Document Type';
        Employee_GenderCaptionLbl: Label 'Document Type';
        SalCotCaptionLbl: Label 'Taxable Salary';
}

