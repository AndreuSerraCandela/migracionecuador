table 76214 "Colegio - Work Flow visitas"
{

    fields
    {
        field(1; "Cod. Colegio"; Code[20])
        {
            TableRelation = "Contact Alt. Addr. Date Range";
        }
        field(2; Secuencia; Integer)
        {
        }
        field(3; Resultado; Boolean)
        {

            trigger OnValidate()
            var
                Texto001: Label 'No se permite eliminar la marca de %1.';
            begin
                if Paso then
                    if not Resultado then
                        Error(Texto001, FieldCaption(Resultado));
            end;
        }
        field(4; Programado; Boolean)
        {
        }
        field(5; Paso; Boolean)
        {
        }
        field(6; Detalle; Text[60])
        {
        }
        field(7; Mantenimiento; Boolean)
        {

            trigger OnValidate()
            var
                Texto001: Label 'No se permite eliminar la marca de %1.';
            begin
                if Area then
                    if not Mantenimiento then
                        Error(Texto001, FieldCaption(Mantenimiento));
            end;
        }
        field(8; Conquista; Boolean)
        {

            trigger OnValidate()
            var
                Texto001: Label 'No se permite eliminar la marca de %1.';
            begin
                if Area then
                    if not Conquista then
                        Error(Texto001, FieldCaption(Conquista));
            end;
        }
        field(9; "Area"; Boolean)
        {
        }
        field(10; "Cod. Promotor"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser" WHERE(Tipo = CONST(Vendedor));
        }
    }

    keys
    {
        key(Key1; "Cod. Promotor", "Cod. Colegio", Secuencia, Programado, Paso, "Area")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        Texto001: Label 'No se permite eliminar Pasos.';
        Texto002: Label 'No se permite eliminar Objetivos.';
    begin

        if Paso then
            Error(Texto001);

        if Area then
            Error(Texto002);
    end;

    trigger OnInsert()
    begin
        InsertLog;
    end;

    trigger OnModify()
    var
        CWF: Record "Colegio - Work Flow visitas";
    begin
        //IF Paso THEN
        //   BEGIN
        //    CWF.RESET;
        //    CWF.SETRANGE("Cod. Colegio","Cod. Colegio");
        //    CWF.SETRANGE(Paso,TRUE);
        //    CWF.SETFILTER(Detalle,'<>%1',Detalle);
        //    CWF.SETRANGE(Resultado,TRUE);
        //    IF CWF.FINDFIRST THEN
        //       BEGIN
        //        CWF.Resultado := FALSE;
        //        CWF.MODIFY;
        //       END;
        //   END;


        InsertLog;
    end;


    procedure InsertLog()
    var
        rLog: Record "Log Coleg. - Work Flow visitas";
    begin
        if not rLog.Get(Today, "Cod. Promotor", "Cod. Colegio", Secuencia) then begin
            rLog.Init;
            rLog.Fecha := Today;
            rLog."Cod. Promotor" := "Cod. Promotor";
            rLog."Cod. Colegio" := "Cod. Colegio";
            rLog.Secuencia := Secuencia;
            rLog.Resultado := Resultado;
            rLog.Programado := Programado;
            rLog.Paso := Paso;
            rLog.Detalle := Detalle;
            rLog.Mantenimiento := Mantenimiento;
            rLog.Conquista := Conquista;
            rLog.Area := Area;
            rLog.Insert;
        end
        else begin
            rLog.Resultado := Resultado;
            rLog.Programado := Programado;
            rLog.Paso := Paso;
            rLog.Detalle := Detalle;
            rLog.Mantenimiento := Mantenimiento;
            rLog.Conquista := Conquista;
            rLog.Area := Area;
            rLog.Modify;
        end;
    end;
}

