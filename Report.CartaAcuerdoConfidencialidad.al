report 76418 "Carta Acuerdo Confidencialidad"
{
    RDLCLayout = './CartaAcuerdoConfidencialidad.rdlc';
    WordLayout = './CartaAcuerdoConfidencialidad.docx';
    Caption = 'Letter Agreement Confidentiality';
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
            column(Ano_Contrato; Format(Employee."Employment Date", 0, '<Year4>'))
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
            column(Tipo_Salario; TipoContrato)
            {
            }
            column(Razon_Social; RazonSocial)
            {
            }
            column(Nombre_Corto; NombreCorto)
            {
            }
            column(RNC_; RNC)
            {
            }
            column(Dir_Empresa; EmpresaCot.Direccion)
            {
            }
            column(No_Empresa; EmpresaCot.Numero)
            {
            }
            column(Provincia_Empresa; EmpresaCot.Provincia)
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
                RazonSocial := EmpresaCot."Nombre Empresa cotizacinn";
                NombreCorto := EmpresaCot."Empresa cotizacion";
                RNC := EmpresaCot."RNC/CED";

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
            end;

            trigger OnPreDataItem()
            begin
                EmpresaCot.FindFirst;
                Representante.Reset;
                Representante.SetRange("Empresa cotización", EmpresaCot."Empresa cotizacion");
                Representante.FindFirst;
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
        EmpresaCot: Record "Empresas Cotizacion";
        Representante: Record "Representantes Empresa";
        NombreDia: Text[60];
        NombreMes: Text[60];
        ImporteTexto: array[2] of Text[1024];
        TipoContrato: Text[60];
        RazonSocial: Text;
        NombreCorto: Text;
        RNC: Text;
}

