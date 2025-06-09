report 76112 "Carta de desahucio"
{
    RDLCLayout = './Cartadedesahucio.rdlc';
    WordLayout = './Cartadedesahucio.docx';
    Caption = 'Eviction letter';
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
            column(Salario; Employee.Salario)
            {
            }
            column(Job_Title; Employee."Job Title")
            {
            }
            column(Dia; Format(Today, 0, '<Day,2>'))
            {
            }
            column(Nombre_Dia; NombreDia)
            {
            }
            column(Nombre_Mes; NombreMes)
            {
            }
            column(Importe_Texto; ImporteTexto[1])
            {
            }
            column(Fecha_Fin; Format(Employee."Fin contrato", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(Nombre_Dia_Sal; NombreDiaSal)
            {
            }
            column(Dia_Sal; Format(Employee."Fin contrato", 0, '<Day,2>'))
            {
            }
            column(Nombre_Mes_Sal; NombreMesSal)
            {
            }
            column(Ano_Sal; Format(Employee."Fin contrato", 0, '<Year4>'))
            {
            }
            column(CompanyInformation_name; CompanyInformation.Name)
            {
            }
            column(Fecha_Ent_txt; FechaEnttxt)
            {
            }
            column(Importe_Liq_Txt; ImporteLiqTxt)
            {
            }
            column(Importe_Liq; ImporteLiq)
            {
            }
            column(Fecha_Fin_txt; FechaFintxt)
            {
            }
            column(Nombre_Rep; Representante.Nombre)
            {
            }
            column(Cargo_Rep; Representante."Job Title")
            {
            }

            trigger OnAfterGetRecord()
            begin
                ImporteLiq := 0;
                HLN.Reset;
                HLN.SetRange("No. empleado", "No.");
                HLN.SetRange("Tipo de nomina", TiposNom.Codigo);
                if HLN.FindSet then
                    repeat
                        ImporteLiq += HLN.Total;
                    until HLN.Next = 0;

                ChkTransMgt.FormatNoText(ImporteTexto, ImporteLiq, 2058, '');
                ImporteLiqTxt := ImporteTexto[1];
                case Format(Today, 0, '<Month,2>') of
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

                case Format(Employee."Fin contrato", 0, '<Month,2>') of
                    '01':
                        NombreMesSal := 'Enero';
                    '02':
                        NombreMesSal := 'Febrero';
                    '03':
                        NombreMesSal := 'Marzo';
                    '04':
                        NombreMesSal := 'Abril';
                    '05':
                        NombreMesSal := 'Mayo';
                    '06':
                        NombreMesSal := 'Junio';
                    '07':
                        NombreMesSal := 'Julio';
                    '08':
                        NombreMesSal := 'Agosto';
                    '09':
                        NombreMesSal := 'Septiembre';
                    '10':
                        NombreMesSal := 'Octubre';
                    '11':
                        NombreMesSal := 'Noviembre';
                    else
                        NombreMesSal := 'Diciembre';
                end;
                ChkTransMgt.FormatNoText(ImporteTexto, Salario, 2058, '');

                /*FechaEnttxt := FuncionesNom.FechaCorta(Employee."Employment Date"); //Nomina
                FechaFintxt := FuncionesNom.FechaCorta(Employee."Termination Date");
                NombreDia := FuncionesNom.FechaLarga(Today);

                NombreDiaSal := FuncionesNom.NombreDia(Employee."Fin contrato");*/
            end;

            trigger OnPreDataItem()
            begin
                TiposNom.Reset;
                TiposNom.SetRange("Tipo de nomina", TiposNom."Tipo de nomina"::Prestaciones);
                TiposNom.FindFirst;

                Representante.Reset;
                Representante.FindFirst;
                CompanyInformation.Get();
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
        CompanyInformation: Record "Company Information";
        ChkTransMgt: Report "Check Translation Manag. DS.";
        HLN: Record "Historico Lin. nomina";
        TiposNom: Record "Tipos de nominas";
        Representante: Record "Representantes Empresa";
        //Nomina FuncionesNom: Codeunit "Funciones Nomina";
        NombreDia: Text[60];
        NombreMes: Text[60];
        ImporteTexto: array[2] of Text[1024];
        ImporteTexto2: Text[1024];
        NombreDiaSal: Text[60];
        NombreMesSal: Text[60];
        iDia: Integer;
        FechaEnttxt: Text[60];
        FechaFintxt: Text[60];
        ImporteLiq: Decimal;
        ImporteLiqTxt: Text[1024];
}

