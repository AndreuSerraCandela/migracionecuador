report 76043 "Procesar datos ponchador"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Distrib. Control de asis. Proy"; "Distrib. Control de asis. Proy")
        {
            DataItemTableView = SORTING("Cod. Empleado", "Fecha registro", "Hora registro", "No. Linea");
            RequestFilterFields = "Job No.", "Fecha registro";

            trigger OnAfterGetRecord()
            begin

                CurrReport.Break;
            end;

            trigger OnPreDataItem()
            begin
                FechaIni := GetRangeMin("Fecha registro");
                FechaFin := GetRangeMax("Fecha registro");
                //Comentado FuncNom.ProcesaControlAsistencia(FechaIni, FechaFin);
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

    trigger OnPreReport()
    begin
        //Buscamos la configuracion
        ConfNomina.Get();

        //Verificamos que los conceptos esten configurados
        //ConfNomina.TESTFIELD("Concepto Horas Ext. 100%");
        ConfNomina.TestField("Concepto Horas Ext. 35%");
        ConfNomina.TestField("Concepto Horas nocturnas");
        ConfNomina.TestField("Concepto Dias feriados");
        ConfNomina.TestField("Concepto Sal. Base");
    end;

    var
        ConfNomina: Record "Configuracion nominas";
        //Comentado FuncNom: Codeunit "Funciones Nomina";
        FechaIni: Date;
        FechaFin: Date;
}

