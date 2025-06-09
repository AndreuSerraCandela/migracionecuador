table 76174 "Distrib. Control de asis. Proy"
{
    // Cod. Empleado,Fecha registro,Hora registro,No. Linea

    Caption = 'Job time distribution';

    fields
    {
        field(1; "Cod. Empleado"; Code[20])
        {
            TableRelation = Employee WHERE (Status = CONST (Active));
        }
        field(2; "Fecha registro"; Date)
        {
        }
        field(3; "Hora registro"; Time)
        {
        }
        field(4; "No. Linea"; Integer)
        {
            Caption = 'Line no.';
        }
        field(5; "Job Title"; Text[60])
        {
            CalcFormula = Lookup (Employee."Job Title" WHERE ("No." = FIELD ("Cod. Empleado")));
            Caption = 'Job Title';
            FieldClass = FlowField;
        }
        field(6; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;

            trigger OnValidate()
            var
                Job: Record Job;
                Cust: Record Customer;
            begin
                if "Job No." = '' then begin
                    Validate("Job Task No.", '');
                end;

                Job.Get("Job No.");
                Job.TestBlocked;
                Job.TestField("Bill-to Customer No.");
                Cust.Get(Job."Bill-to Customer No.");
                Validate("Job Task No.", '');
            end;
        }
        field(7; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." WHERE ("Job No." = FIELD ("Job No."));

            trigger OnValidate()
            var
                JobTask: Record "Job Task";
            begin
                TestField("Job No.");
                if "Job Task No." <> '' then begin
                    JobTask.Get("Job No.", "Job Task No.");
                    JobTask.TestField("Job Task Type", JobTask."Job Task Type"::Posting);
                end;

                DCA.Reset;
                DCA.SetRange("Cod. Empleado", "Cod. Empleado");
                DCA.SetRange("Fecha registro", "Fecha registro");
                DCA.SetRange("Hora registro", "Hora registro");
                DCA.SetRange("Job No.", "Job No.");
                DCA.SetRange("Job Task No.", "Job Task No.");
                DCA.SetFilter("No. Linea", '<>%1', "No. Linea");
                if DCA.FindFirst then
                    Error(StrSubstNo(Err002, FieldCaption("Cod. Empleado"), "Cod. Empleado", FieldCaption("Job No."), "Job No.", FieldCaption("Job Task No."), "Job Task No."));
            end;
        }
        field(8; "Horas laboradas"; Decimal)
        {
            Editable = false;
        }
        field(9; "Horas regulares"; Decimal)
        {

            trigger OnValidate()
            begin
                CalcularHorasLab;
            end;
        }
        field(10; "Horas extras al 35"; Decimal)
        {

            trigger OnValidate()
            begin
                CalcularHorasLab;
            end;
        }
        field(11; "Horas extras al 100"; Decimal)
        {

            trigger OnValidate()
            begin
                CalcularHorasLab;
            end;
        }
        field(12; "Horas nocturnas"; Decimal)
        {

            trigger OnValidate()
            begin
                CalcularHorasLab;
            end;
        }
        field(13; "Horas feriadas"; Decimal)
        {

            trigger OnValidate()
            begin
                CalcularHorasLab;
            end;
        }
        field(14; "Nombre completo"; Text[60])
        {
            CalcFormula = Lookup (Employee."Full Name" WHERE ("No." = FIELD ("Cod. Empleado")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Total Horas imputadas"; Duration)
        {
            CalcFormula = Lookup ("Control de asistencia"."Total Horas" WHERE ("Cod. Empleado" = FIELD ("Cod. Empleado"),
                                                                              "Fecha registro" = FIELD ("Fecha registro")));
            Caption = 'Total Input hours';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Horas Extras Nocturnas"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Cod. Empleado", "Fecha registro", "Hora registro", "No. Linea")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        /*
        DCA.RESET;
        DCA.SETRANGE("Cod. Empleado","Cod. Empleado");
        dca.SETRANGE("Fecha registro","Fecha registro");
        DCA.SETRANGE("Hora registro","Hora registro");
        */

    end;

    var
        Err001: Label '%1 can not be greather than the total of hours for the %2 %3 and %4 %5';
        DCA: Record "Distrib. Control de asis. Proy";
        Err002: Label 'There is already a record for %1 %2 %3 %4 %5 %6';
        Err003: Label 'The amount of %1 exceeds the daily limit of the working day';
        Err004: Label 'You can not have %1 if %2 does not have full day';
        Err005: Label 'You can not have %1 and %2 for the same day, please correct the data';

    local procedure CalcularHorasLab()
    var
        CA: Record "Control de asistencia";
        DCP: Record "Distrib. Control de asis. Proy";
        Fecha: Record Date;
        TotHoras: Decimal;
        DurHoras: Duration;
    begin
        TestField("Job No.");
        TestField("Job Task No.");

        Fecha.Reset;
        Fecha.SetRange("Period Type", Fecha."Period Type"::Date);
        Fecha.SetRange("Period Start", "Fecha registro");
        Fecha.FindFirst;
        if Fecha."Period No." <> 6 then begin
            if "Horas regulares" > 8 then
                Error(StrSubstNo(Err003, FieldCaption("Horas regulares")));
            if "Horas extras al 35" > 12 then
                Error(StrSubstNo(Err003, FieldCaption("Horas extras al 35")));
            if "Horas nocturnas" > 8 then
                Error(StrSubstNo(Err003, FieldCaption("Horas nocturnas")));
            if "Horas Extras Nocturnas" > 12 then
                Error(StrSubstNo(Err003, FieldCaption("Horas Extras Nocturnas")));

            /*Validar despues
                 IF ("Horas extras al 35" <> 0) AND ("Horas regulares" = 0) THEN
                    ERROR(STRSUBSTNO(Err004,FIELDCAPTION("Horas extras al 35"),FIELDCAPTION("Horas regulares")))
                 ELSE
                 IF ("Horas extras al 35" <> 0) AND ("Horas regulares" < 8) THEN
                    ERROR(STRSUBSTNO(Err004,FIELDCAPTION("Horas extras al 35"),FIELDCAPTION("Horas regulares")));
            */
            if ("Horas regulares" <> 0) and ("Horas nocturnas" <> 0) then
                Error(StrSubstNo(Err005, FieldCaption("Horas regulares"), FieldCaption("Horas nocturnas")));
        end
        else
            if Fecha."Period No." = 7 then begin
                //Controlar que no se digiten horas regulares ni al 35
                //   "Horas extras" := "Horas laboradas"
            end
            else
                if Fecha."Period No." = 6 then begin
                    if "Horas regulares" > 4 then
                        Error(StrSubstNo(Err003, FieldCaption("Horas regulares")));
                    if "Horas extras al 35" > 0 then
                        Error(StrSubstNo(Err003, FieldCaption("Horas extras al 35")));
                end;

        "Horas laboradas" := "Horas regulares" + "Horas extras al 35" + "Horas extras al 100" + "Horas feriadas" + "Horas nocturnas" + "Horas Extras Nocturnas";
        Evaluate(DurHoras, Format("Horas regulares"));

        CA.Reset;
        CA.SetRange("Cod. Empleado", "Cod. Empleado");
        CA.SetRange("Fecha registro", "Fecha registro");
        CA.SetRange("Hora registro", "Hora registro");
        CA.FindFirst;
        /*IF DurHoras > CA."Horas laboradas" THEN
           ERROR(STRSUBSTNO(Err001,FIELDCAPTION("Horas laboradas"),FIELDCAPTION("fecha registro"),"fecha registro",
                            FIELDCAPTION("Hora registro"),"Hora registro"));
        */

        TotHoras := 0;
        DCP.Reset;
        DCP.SetRange("Cod. Empleado", "Cod. Empleado");
        DCP.SetRange("Fecha registro", "Fecha registro");
        DCP.SetRange("Hora registro", "Hora registro");
        DCP.SetFilter("No. Linea", '<>%1', "No. Linea");
        if DCP.FindSet then
            repeat
                TotHoras += DCP."Horas laboradas";
            until DCP.Next = 0;


        TotHoras += "Horas laboradas";
        Evaluate(DurHoras, Format(TotHoras));
        //MESSAGE('%1 %2 %3',TotHoras,DurHoras,CA."Horas laboradas");
        if DurHoras > CA."Horas laboradas" then
            Error(StrSubstNo(Err001, FieldCaption("Horas laboradas"), FieldCaption("Fecha registro"), "Fecha registro",
                             FieldCaption("Hora registro"), "Hora registro"));

    end;
}

