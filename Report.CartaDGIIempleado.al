report 76338 "Carta DGII empleado"
{
    RDLCLayout = './CartaDGIIempleado.rdlc';
    WordLayout = './CartaDGIIempleado.docx';
    Caption = 'Carta declaración DGII';
    DefaultLayout = Word;

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";
            column(No_; Employee."No.")
            {
            }
            column(Full_Name; Employee."Full Name")
            {
            }
            column(Document_Type; Employee."Document Type")
            {
            }
            column(Document_ID; Employee."Document ID")
            {
            }
            column(Employment_Date; Employee."Employment Date")
            {
            }
            column(Ano; Format(Today, 0, '<Year4>'))
            {
            }
            column(Dia; Format(Today, 0, '<Day,2>'))
            {
            }
            column(AnoCarta; Format(FechaFin, 0, '<Year4>'))
            {
            }
            column(Nombre_Dia; NombreDia)
            {
            }
            column(Nombre_Mes; NombreMes)
            {
            }
            column(Estado_Civil; Employee."Estado civil")
            {
            }
            column(Address_; Employee.Address)
            {
            }
            column(City_; Employee.City)
            {
            }
            column(Job_Title; Employee."Job Title")
            {
            }
            column(Importe_Texto; ImporteTexto[1])
            {
            }
            column(Salario; Ingresosalario)
            {
            }
            column(Tss; DescTSS)
            {
            }
            column(Isr; DescISR)
            {
            }
            column(Exentos; IngresosEx)
            {
            }
            column(Tipo_Salario; TipoContrato)
            {
            }
            column(Nombre_Rep; Representante.Nombre)
            {
            }
            column(Cargo_Rep; Representante."Job Title")
            {
            }
            column(NombreEmpresa; EmpresasCotización."Nombre Empresa cotizacinn")
            {
            }

            trigger OnAfterGetRecord()
            begin
                case Format(Employee."Employment Date", 0, '<Month,2>') of
                    '01':
                        NombreMes := 'Enero';
                    '02':
                        NombreMes := 'Febrero';
                    '03':
                        NombreMes := 'Marzo';
                    '04':
                        NombreMes := 'Abril';
                    '05':
                        NombreMes := 'Mayo';
                    '06':
                        NombreMes := 'Junio';
                    '07':
                        NombreMes := 'Julio';
                    '08':
                        NombreMes := 'Agosto';
                    '09':
                        NombreMes := 'Septiembre';
                    '10':
                        NombreMes := 'Octubre';
                    '11':
                        NombreMes := 'Noviembre';
                    else
                        NombreMes := 'Diciembre';
                end;

                ChkTransMgt.FormatNoText(ImporteTexto, Salario, 2058, '');
                ImporteTexto[1] := DelChr(ImporteTexto[1], '=', '*');


                //Nomina NombreDia := FuncionesNom.FechaLarga(Today);

                Contrato.Reset;
                Contrato.SetRange("Cód. contrato", "Emplymt. Contract Code");
                Contrato.SetRange("No. empleado", "No.");//
                //Contrato.SETRANGE(Activo,TRUE);
                Contrato.FindLast;

                if (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal) or
                  (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Mensual) then
                    TipoContrato := 'salario fijo mensual'
                else
                    TipoContrato := 'salario por hora';

                //Salarios
                HistoricoLinNom.Reset;
                HistoricoLinNom.SetRange("No. empleado", "No.");
                if (TN."Dia inicio 1ra" > 1) and (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal) then begin
                    FechaFin := CalcDate('+14D', DMY2Date(TN."Dia inicio 2da", 12, Date2DMY(Fecha, 3)));
                    HistoricoLinNom.SetRange(Período, DMY2Date(TN."Dia inicio 1ra", Date2DMY(CalcDate('-1M', DMY2Date(1, 1, Date2DMY(Fecha, 3))), 2), Date2DMY(CalcDate(CFecha, DMY2Date(1, 1, Date2DMY(Fecha, 3))), 3)), FechaFin);
                end
                else
                    HistoricoLinNom.SetRange(Período, DMY2Date(1, 1, Date2DMY(Fecha, 3)), DMY2Date(31, 12, Date2DMY(Fecha, 3)));

                HistoricoLinNom.SetRange("Salario Base", true);
                HistoricoLinNom.SetRange("Tipo concepto", HistoricoLinNom."Tipo concepto"::Ingresos);
                if HistoricoLinNom.FindSet then
                    repeat
                        Ingresosalario += HistoricoLinNom.Total;

                    until HistoricoLinNom.Next = 0;

                //TSS
                HistoricoLinNom.Reset;
                HistoricoLinNom.SetRange("No. empleado", "No.");
                if (TN."Dia inicio 1ra" > 1) and (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal) then begin
                    FechaFin := CalcDate('+14D', DMY2Date(TN."Dia inicio 2da", 12, Date2DMY(Fecha, 3)));
                    HistoricoLinNom.SetRange(Período, DMY2Date(TN."Dia inicio 1ra", Date2DMY(CalcDate('-1M', DMY2Date(1, 1, Date2DMY(Fecha, 3))), 2), Date2DMY(CalcDate(CFecha, DMY2Date(1, 1, Date2DMY(Fecha, 3))), 3)), FechaFin);
                end
                else
                    HistoricoLinNom.SetRange(Período, DMY2Date(1, 1, Date2DMY(Fecha, 3)), DMY2Date(31, 12, Date2DMY(Fecha, 3)));

                HistoricoLinNom.SetFilter("Concepto salarial", '%1|%2', ConfNominas."Concepto AFP", ConfNominas."Concepto SFS");
                if HistoricoLinNom.FindSet then
                    repeat
                        DescTSS += Abs(HistoricoLinNom.Total);
                    until HistoricoLinNom.Next = 0;

                //ISR
                HistoricoLinNom.Reset;
                HistoricoLinNom.SetRange("No. empleado", "No.");
                if (TN."Dia inicio 1ra" > 1) and (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal) then begin
                    FechaFin := CalcDate('+14D', DMY2Date(TN."Dia inicio 2da", 12, Date2DMY(Fecha, 3)));
                    HistoricoLinNom.SetRange(Período, DMY2Date(TN."Dia inicio 1ra", Date2DMY(CalcDate('-1M', DMY2Date(1, 1, Date2DMY(Fecha, 3))), 2), Date2DMY(CalcDate(CFecha, DMY2Date(1, 1, Date2DMY(Fecha, 3))), 3)), FechaFin);
                end
                else
                    HistoricoLinNom.SetRange(Período, DMY2Date(1, 1, Date2DMY(Fecha, 3)), DMY2Date(31, 12, Date2DMY(Fecha, 3)));

                HistoricoLinNom.SetRange("Concepto salarial", ConfNominas."Concepto ISR");
                if HistoricoLinNom.FindSet then
                    repeat
                        DescISR += Abs(HistoricoLinNom.Total);
                    until HistoricoLinNom.Next = 0;

                //Ingresos exentos
                HistoricoLinNom.Reset;
                HistoricoLinNom.SetRange("No. empleado", "No.");
                if (TN."Dia inicio 1ra" > 1) and (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal) then begin
                    FechaFin := CalcDate('+14D', DMY2Date(TN."Dia inicio 2da", 12, Date2DMY(Fecha, 3)));
                    HistoricoLinNom.SetRange(Período, DMY2Date(TN."Dia inicio 1ra", Date2DMY(CalcDate('-1M', DMY2Date(1, 1, Date2DMY(Fecha, 3))), 2), Date2DMY(CalcDate(CFecha, DMY2Date(1, 1, Date2DMY(Fecha, 3))), 3)), FechaFin);
                end
                else
                    HistoricoLinNom.SetRange(Período, DMY2Date(1, 1, Date2DMY(Fecha, 3)), DMY2Date(31, 12, Date2DMY(Fecha, 3)));

                HistoricoLinNom.SetRange("Cotiza ISR", false);
                HistoricoLinNom.SetRange("Tipo concepto", HistoricoLinNom."Tipo concepto"::Ingresos);
                if HistoricoLinNom.FindSet then
                    repeat
                        IngresosEx += HistoricoLinNom.Total;
                    until HistoricoLinNom.Next = 0;
            end;

            trigger OnPreDataItem()
            begin
                ConfNominas.Get();
                TN.Reset;
                TN.SetRange("Tipo de nomina", TN."Tipo de nomina"::Regular);
                TN.FindFirst;

                Representante.Reset;
                //Representante.SETRANGE("Empresa cotización",Company);
                Representante.FindFirst;

                EmpresasCotización.Get(Representante."Empresa cotización");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Fecha; Fecha)
                {
                ApplicationArea = All;
                    Caption = 'Document date';
                    TableRelation = "Bank Account";
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
        Fecha := Today;
    end;

    var
        ConfNominas: Record "Configuracion nominas";
        //Nomina FuncionesNom: Codeunit "Funciones Nomina";
        ChkTransMgt: Report "Check Translation Manag. DS.";
        Contrato: Record Contratos;
        HistoricoLinNom: Record "Historico Lin. nomina";
        TN: Record "Tipos de nominas";
        Representante: Record "Representantes Empresa";
        "EmpresasCotización": Record "Empresas Cotizacion";
        NombreDia: Text[60];
        NombreMes: Text[60];
        ImporteTexto: array[2] of Text[1024];
        TipoContrato: Text[60];
        Fecha: Date;
        FechaFin: Date;
        Ingresosalario: Decimal;
        DescTSS: Decimal;
        DescISR: Decimal;
        IngresosEx: Decimal;
        CFecha: Label '''-1Y''';
}

