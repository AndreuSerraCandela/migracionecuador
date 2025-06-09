table 76406 "Descuento x forma de pago"
{
    // #373762, RRT, 09.04.2021: Creación de la tabla.


    fields
    {
        field(1; "ID Pago"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Formas de Pago"."ID Pago";
        }
        field(2; "No. Linea"; Integer)
        {
            Editable = false;
        }
        field(5; Activo; Boolean)
        {
        }
        field(6; "Fecha inicio"; Date)
        {
        }
        field(7; "Fecha final"; Date)
        {
        }
        field(10; Tienda; Code[20])
        {
            TableRelation = Tiendas;

            trigger OnValidate()
            var
                lrTPV: Record "Configuracion TPV";
            begin
                if Tienda = '' then begin
                    if TPV <> '' then
                        Validate(TPV, '');
                end
                else begin
                    if TPV <> '' then
                        if not lrTPV.Get(Tienda, TPV) then
                            Validate(TPV, '');
                end;
            end;
        }
        field(11; TPV; Code[20])
        {
            TableRelation = "Configuracion TPV"."Id TPV" WHERE(Tienda = FIELD(Tienda));
        }
        field(20; "% Descuento linea"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "ID Pago", "No. Linea")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        lrDtos: Record "Descuento x forma de pago";
    begin
        "No. Linea" := 1;

        lrDtos.Reset;
        lrDtos.SetRange("ID Pago", "ID Pago");
        if lrDtos.FindLast then
            "No. Linea" := lrDtos."No. Linea" + 1;

        TestSolape;
    end;

    trigger OnModify()
    var
        TextL001: Label 'La fecha de inicio no puede ser mayor que la fecha final.';
    begin
        if ("Fecha inicio" <> 0D) and ("Fecha final" <> 0D) then
            if ("Fecha final" < "Fecha inicio") then
                Error(TextL001);

        TestSolape;
    end;


    procedure TestSolape()
    var
        lrDtos: Record "Descuento x forma de pago";
        lFechaInicio: Date;
        lFechaFin: Date;
        lFechaInicioX: Date;
        lFechaFinX: Date;
        TextL001: Label 'Este registro solapa en fechas con la línea %1';
    begin
        IniciarVariableFecha(lFechaInicio, "Fecha inicio", 19000101D);
        IniciarVariableFecha(lFechaFin, "Fecha final", 19991231D);

        lrDtos.Reset;
        lrDtos.SetRange("ID Pago", "ID Pago");
        lrDtos.SetFilter("No. Linea", '<>%1', "No. Linea");
        lrDtos.SetRange(Tienda, Tienda);
        lrDtos.SetRange(TPV, TPV);

        if lrDtos.FindFirst then
            repeat

                IniciarVariableFecha(lFechaInicioX, lrDtos."Fecha inicio", 19000101D);
                IniciarVariableFecha(lFechaFinX, lrDtos."Fecha final", 19991231D);

                if ((lFechaInicio >= lFechaInicioX) and (lFechaInicio <= lFechaFinX)) or
                   ((lFechaFin >= lFechaInicioX) and (lFechaFin <= lFechaFinX)) then
                    Error(TextL001, lrDtos."No. Linea");

            until lrDtos.Next = 0;
    end;


    procedure IniciarVariableFecha(var vFecha: Date; pValorAsignacion: Date; pValorAlternativo: Date)
    begin
        vFecha := pValorAsignacion;
        if vFecha = 0D then
            vFecha := pValorAlternativo;
    end;
}

