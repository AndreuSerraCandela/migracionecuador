report 76005 "Carta de contrato de trabajo"
{
    RDLCLayout = './Cartadecontratodetrabajo.rdlc';
    WordLayout = './Cartadecontratodetrabajo.docx';
    Caption = 'Work contract lletter';
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
            column(Salario; SalarioEmp)
            {
            }
            column(Tipo_Salario; TipoContrato)
            {
            }
            column(Nombre_Rep; RepresentantesEmpresa.Nombre)
            {
            }
            column(Nombre_Empresa; EmpresasCot."Nombre Empresa cotizacinn")
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
                Contrato.SetRange("No. empleado", "No.");
                Contrato.SetRange(Activo, true);
                Contrato.FindFirst;

                if (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal) or
                  (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Mensual) then
                    TipoContrato := 'salario fijo mensual'
                else
                    TipoContrato := 'salario por hora';

                SalarioEmp := 0;
                PerfilSalario.Reset;
                PerfilSalario.SetRange("No. empleado", "No.");
                PerfilSalario.SetRange("Salario Base", true);
                PerfilSalario.FindSet;
                repeat
                    SalarioEmp += PerfilSalario.Importe;
                until PerfilSalario.Next = 0;
            end;

            trigger OnPreDataItem()
            begin
                EmpresasCot.FindFirst;
                RepresentantesEmpresa.Reset;
                RepresentantesEmpresa.SetRange("Empresa cotización", EmpresasCot."Empresa cotizacion");
                RepresentantesEmpresa.SetFilter(Figurar, '%1|%2', RepresentantesEmpresa.Figurar::"Contratos laborales", RepresentantesEmpresa.Figurar::"Todo tipo documento");
                RepresentantesEmpresa.FindFirst;
                RepresentantesEmpresa.TestField(Nombre);
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
        //Nomina FuncionesNom: Codeunit "Funciones Nomina";
        ChkTransMgt: Report "Check Translation Manag. DS.";
        Contrato: Record Contratos;
        RepresentantesEmpresa: Record "Representantes Empresa";
        EmpresasCot: Record "Empresas Cotizacion";
        PerfilSalario: Record "Perfil Salarial";
        NombreDia: Text[60];
        NombreMes: Text[60];
        ImporteTexto: array[2] of Text[1024];
        TipoContrato: Text[60];
        SalarioEmp: Decimal;
}

