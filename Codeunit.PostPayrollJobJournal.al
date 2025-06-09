codeunit 76055 "Post Payroll - Job Journal"
{
    TableNo = "Payroll - Job Journal Line";

    trigger OnRun()
    var
        ResourcesSetup: Record "Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        NoEmp: Code[20];
    begin
        ConfNom.Get();
        ConfNom.Get();
        if MA.FindLast then
            NoMov := MA."Entry No."
        else
            NoMov := 0;

        Window.Open(Text001);

        ResourcesSetup.Get();

        DA.Reset;
        DA.SetCurrentKey("Journal Template Name", "Journal Batch Name", "No. empleado");
        DA.SetFilter("Journal Template Name", rec.GetFilter("Journal Template Name"));
        DA.SetFilter("Journal Batch Name", rec.GetFilter("Journal Batch Name"));
        DA.FindSet(true);
        CounterTotal := rec.Count;
        repeat
            Rec.TestField("Job No.");
            Rec.TestField("Resource No.");
            Rec.TestField("Job Task No.");
            Rec.TestField("Work Type Code");
            Rec.TestField("Unit of Measure Code");
            Rec.TestField(Quantity);
            Rec.TestField(Amount);
            DA.TestField("Gen. Bus. Posting Group");
            DA.TestField("Gen. Prod. Posting Group");


            NoMov += 1;
            Counter := Counter + 1;
            Window.Update(1, Rec."No. empleado");
            Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
            if NoEmp <> DA."No. empleado" then begin
                InicializaConceptos;
                NoEmp := DA."No. empleado";
            end;

            MA2.Reset;
            MA2.SetRange("No. empleado", DA."No. empleado");
            MA2.SetRange("Posting Date", DA."Posting Date");
            MA2.SetRange("Job No.", DA."Job No.");
            MA2.SetRange("Job Task No.", DA."Job Task No.");
            MA2.SetRange("Work Type Code", DA."Work Type Code");
            if MA2.FindFirst then
                Error(StrSubstNo(Err001, DA.FieldCaption("No. empleado"), DA.FieldCaption("Posting Date"), DA.FieldCaption("Job No."), DA.FieldCaption("Job Task No.")));

            MA.Init;
            MA."Entry No." := NoMov;
            MA."No. empleado" := DA."No. empleado";
            MA."Posting Date" := DA."Posting Date";
            MA."Puesto trabajo" := DA."Puesto trabajo";
            MA."Apellidos y Nombre" := DA."Apellidos y Nombre";
            MA."Job No." := DA."Job No.";
            MA."Job Task No." := DA."Job Task No.";
            MA."Resource No." := DA."Resource No.";
            MA."Unit of Measure Code" := DA."Unit of Measure Code";
            MA."Qty. per Unit of Measure" := DA."Qty. per Unit of Measure";
            MA."Job Task Name" := DA."Job Task Name";
            MA."Concepto salarial" := DA."Concepto salarial";
            MA."Tipo concepto" := DA."Tipo concepto";
            MA.Quantity := DA.Quantity;
            MA.Amount := DA.Amount;
            MA."Tipo Tarifa" := DA."Tipo Tarifa";
            MA."Precio Tarifa" := DA."Precio Costo";
            MA."Inicio Período" := DA."Inicio Período";
            MA."Fin Período" := DA."Fin Período";
            MA."Work Type Code" := DA."Work Type Code";
            MA."Document No." := DA."Document No.";
            MA."Gen. Bus. Posting Group" := DA."Gen. Bus. Posting Group";
            MA."Gen. Prod. Posting Group" := DA."Gen. Prod. Posting Group";
            MA."Document No." := DA."Document No.";
            if MA.Insert then;

            Res.Get(DA."Resource No.");

            if Res."Use Time Sheet" then begin
                Date.Reset;
                Date.SetRange(Date."Period Type", Date."Period Type"::Date);
                Date.SetRange(Date."Period Start", DA."Posting Date");
                Date.FindFirst;
                case Date."Period No." of
                    1:
                        begin
                            Date.Reset;
                            Date.SetRange("Period Type", Date."Period Type"::Week);
                            Date.SetRange("Period Start", DA."Posting Date");
                            Date.FindFirst;

                            TSH.Init;
                            TSH."No." := NoSeriesMgt.GetNextNo(ResourcesSetup."Time Sheet Nos.", Today, true);
                            TSH."Starting Date" := Date2."Period Start";
                            TSH."Ending Date" := NormalDate(Date2."Period End");
                            TSH.Validate("Resource No.", Rec."Resource No.");
                            if TSH.Insert then;
                        end;
                    else begin
                        Date2.Reset;
                        Date2.SetRange("Period Type", Date2."Period Type"::Week);
                        Date2.SetRange("Period Start", CalcDate('-' + Format(Date."Period No." - 1) + 'D', DA."Posting Date"));
                        Date2.FindFirst;

                        TSH.Reset;
                        TSH.SetRange("Starting Date", Date2."Period Start");
                        TSH.SetRange("Ending Date", NormalDate(Date2."Period End"));
                        TSH.SetRange("Resource No.", Rec."Resource No.");
                        if not TSH.FindFirst then begin
                            TSH.Init;
                            TSH."No." := NoSeriesMgt.GetNextNo(ResourcesSetup."Time Sheet Nos.", Today, true);
                            TSH."Starting Date" := Date2."Period Start";
                            TSH."Ending Date" := NormalDate(Date2."Period End");
                            TSH.Validate("Resource No.", Rec."Resource No.");
                            if TSH.Insert then;
                        end;

                        TSL.Init;
                        NoLin += 1000;
                        TSL.Validate("Time Sheet No.", TSH."No.");
                        TSL."Line No." := NoLin;
                        TSL.Validate("Time Sheet Starting Date", TSH."Starting Date");
                        TSL.Type := TSL.Type::Job;
                        TSL.Validate("Job No.", DA."Job No.");
                        TSL.Validate("Job Task No.", DA."Job Task No.");
                        TSL.Validate("Work Type Code", DA."Work Type Code");
                        //        TSL.validate("Total Quantity",DA.Quantity);
                        if TSL.Insert(true) then;

                        TSD.Init;
                        TSD.CopyFromTimeSheetLine(TSL);
                        TSD.Validate(Date, DA."Posting Date");
                        TSD.Quantity := DA.Quantity;
                        if TSD.Insert(true) then;

                    end;
                end;
            end
            else begin
                NoLin += 1000;
                JobJNL.Init;
                JobJNL.Validate("Journal Template Name", ConfNom."Job Journal Template Name");
                JobJNL.Validate("Journal Batch Name", ConfNom."Job Journal Batch Name");
                JobJNL."Line No." := NoLin;
                /*
                      CASE ConfIDC."Tipo Línea Diario Proyecto" OF
                       0:
                       JobJNL."Line Type"    := 1;
                      ELSE
                       JobJNL."Line Type"    := 2;
                      END;
                */
                JobJNL.Validate("Job No.", DA."Job No.");
                JobJNL.Validate("Job Task No.", DA."Job Task No.");
                JobJNL.Validate("Posting Date", DA."Posting Date");
                JobJNL.Type := JobJNL.Type::Resource;
                JobJNL.Validate("No.", DA."Resource No.");
                JobJNL.Validate("Work Type Code", DA."Work Type Code");
                JobJNL.Validate("Gen. Bus. Posting Group", DA."Gen. Bus. Posting Group");
                JobJNL.Validate("Gen. Prod. Posting Group", DA."Gen. Prod. Posting Group");
                JobJNL.Validate(Quantity, DA.Quantity);
                JobJNL."Document No." := DA."Document No.";
                //      JobJNL.VALIDATE("Direct Unit Cost (LCY)", DA."Precio Tarifa";
                if JobJNL.Insert(true) then;
            end;

        /*Se afecta el importe a pagar en Nomina en un proceso separado
            PS.RESET;
            PS.SETRANGE("No. empleado",DA."No. empleado");
            PS.SETRANGE("Concepto salarial",DA."Concepto salarial");
            PS.FINDFIRST;

            PS.Cantidad := 1;
            PS.Importe  += DA."Precio Tarifa";
            PS.MODIFY;
        */
        until DA.Next = 0;

        DA.DeleteAll;

        Window.Close;

        Message(Msg001);

    end;

    var
        ConfNom: Record "Configuracion nominas";
        DA: Record "Payroll - Job Journal Line";
        MA: Record "Mov. actividades OJO";
        MA2: Record "Mov. actividades OJO";
        PS: Record "Perfil Salarial";
        TSH: Record "Time Sheet Header";
        TSL: Record "Time Sheet Line";
        TSD: Record "Time Sheet Detail";
        JobJNL: Record "Job Journal Line";
        Res: Record Resource;
        Date: Record Date;
        Date2: Record Date;
        NoMov: Integer;
        NoLin: Integer;
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        ImpSalario: Decimal;
        FirstTime: Boolean;
        Text001: Label 'Processing journal  #1########## @2@@@@@@@@@@@@@';
        Msg001: Label 'Se han insertado las líneas en el Diario de Proyectos y/o Hoja de trabajo';
        Err001: Label 'There are data already for combination %1 %2 %3 %4';


    procedure InicializaConceptos()
    begin
        PS.Reset;
        PS.SetRange("No. empleado", DA."No. empleado");
        PS.FindSet(true);
        repeat
            PS.Cantidad := 0;
            PS.Importe := 0;
            PS.Modify;
        until PS.Next = 0;
    end;
}

