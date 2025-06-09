codeunit 56207 "Detecc. anomalias en contrato1"
{

    trigger OnRun()
    begin
        DeteccionAnomaliasEnContratos;
    end;


    procedure DeteccionAnomaliasEnContratos()
    var
        lrEmployee: Record Employee;
        lWindow: Dialog;
        TextL001: Label 'Revisando contratos del empleado ###########1';
        lExigirContinuidadContratos: Boolean;
        lRevisarContratoIndefinidoQueSeaUltimo: Boolean;
        lrAuditoria: Record "Log errores revision contrato1";
    begin
        //+#269159
        //... Se realizará un recorrido por empleados.

        lExigirContinuidadContratos := true;
        lRevisarContratoIndefinidoQueSeaUltimo := true;

        lrAuditoria.Reset;
        lrAuditoria.SetRange("Creado por proceso", true);
        lrAuditoria.DeleteAll;

        lWindow.Open(TextL001);
        lrEmployee.Reset;
        if lrEmployee.FindFirst then
            repeat
                lWindow.Update(1, lrEmployee."No.");
                RevisarContratosEmpleado(lrEmployee."No.", lExigirContinuidadContratos, lRevisarContratoIndefinidoQueSeaUltimo);
            until lrEmployee.Next = 0;
        lWindow.Close;
    end;


    procedure RevisarContratosEmpleado(pCodEmpleado: Code[15]; pExigirContinuidadContratos: Boolean; pRevisarContratoIndefinidoQueSeaUltimo: Boolean)
    var
        lrContrato: Record Contratos;
        lrAuditoria: Record "Log errores revision contrato1";
        lFechaFinalAnterior: Date;
        lModificar: Boolean;
        lFechaInicio: Date;
        lFechaFinal: Date;
    begin
        //+#269159
        //... Se realizará un recorrido por empleados.

        lrAuditoria.Init;
        lrAuditoria."No. empleado" := pCodEmpleado;
        lrAuditoria.Estado := lrAuditoria.Estado::Ok;
        lrAuditoria.Insert(true);

        lrContrato.Reset;
        lrContrato.SetCurrentKey("No. empleado", "No. Orden");
        lrContrato.SetRange("No. empleado", pCodEmpleado);

        lFechaFinalAnterior := 19000101D;

        if lrContrato.FindFirst then
            repeat

                lModificar := false;

                //... 1. Empezaremos revisando si la fecha de inicio NO tiene valor asignado.
                if lrContrato."Fecha inicio" = 0D then begin
                    lrAuditoria."Errores fecha inicio" := lrAuditoria."Errores fecha inicio" + 1;
                    lModificar := true;
                end;

                //Calculo de las fechas de inicio y final teorico.
                lFechaInicio := lrContrato."Fecha inicio";
                lFechaFinal := lrContrato."Fecha finalización";
                if lFechaInicio = 0D then
                    lFechaInicio := 19000101D;

                if lFechaFinal = 0D then
                    lFechaFinal := 99991231D;

                //... 2. Revisamos la continuidad de contratos.
                if pExigirContinuidadContratos then begin
                    if (lFechaInicio < lFechaFinalAnterior) or (lFechaInicio > lFechaFinal) then begin
                        lrAuditoria."Errores continuidad" := lrAuditoria."Errores continuidad" + 1;
                        lModificar := true;
                    end;
                end;

                //... 3. Permitiremos que la fecha final esté sin valor, sólo si y solo, se trata del último contrato ligado al empleado.
                if pRevisarContratoIndefinidoQueSeaUltimo then begin
                    if lrContrato."Fecha finalización" = 0D then begin
                        if not UltimoContrato(lrContrato) then begin
                            lrAuditoria."Errores por fecha final" := lrAuditoria."Errores por fecha final" + 1;
                            lModificar := true;
                        end;
                    end;
                end;

                if lModificar then begin
                    lrAuditoria.Estado := lrAuditoria.Estado::Errores;
                    lrAuditoria.Modify(true);
                end;

                lFechaFinalAnterior := lFechaFinal;

            until lrContrato.Next = 0;
    end;


    procedure UltimoContrato(lrContratoRef: Record Contratos): Boolean
    var
        lrContrato: Record Contratos;
    begin
        lrContrato.Reset;
        lrContrato.SetCurrentKey("No. empleado", "No. Orden");
        lrContrato.SetRange("No. empleado", lrContratoRef."No. empleado");
        lrContrato.SetFilter("No. Orden", '>%1', lrContratoRef."No. Orden");
        if lrContrato.FindFirst then
            exit(false);

        exit(true);
    end;
}

