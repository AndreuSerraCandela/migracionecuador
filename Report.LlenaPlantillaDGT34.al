report 76064 "Llena Plantilla DGT3-4"
{
    // Tipo de novedad
    //   IN = Ingreso
    //   SA = Salida
    //   VC = Vacaciones 1
    //   LV = Licencia Voluntaria
    //   LM = Licencia x Maternidad
    //   LD = Licencia x Discapacidad.
    //   AD = Actualización de Datos del trabajador (Ej. Salario)

    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnPreDataItem()
            begin
                if Ano = 0 then
                    Error(Err002);
                if Mes = 0 then
                    Error(Err001)
                else
                    if Mes > 12 then
                        Error(Err004);

                /*if TipoPlantilla = 0 then //Comentado
                    FormatosLegales.RDDGT3(Mes, Ano)
                else
                    FormatosLegales.RDDGT4(Mes, Ano);*/
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
                field("Año"; Ano)
                {
                ApplicationArea = All;
                }
                field(Mes; Mes)
                {
                ApplicationArea = All;
                    MaxValue = 12;
                    MinValue = 1;
                }
                field(tipoplant; TipoPlantilla)
                {
                ApplicationArea = All;
                    Caption = 'Template type';
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if Ano = 0 then
                Ano := Date2DMY(Today, 3);
        end;
    }

    labels
    {
    }

    var
        Err001: Label 'Specify month to run';
        Err002: Label 'Specify year to run';
        Err003: Label 'Specify the payroll key';
        Err004: Label 'Month can not be greather than 12';
        Fecha: Record Date;
        //Comentado FormatosLegales: Codeunit "Genera formatos elect. legales";
        Mes: Integer;
        Ano: Integer;
        TipoPlantilla: Option DGT3,DGT4;
}

