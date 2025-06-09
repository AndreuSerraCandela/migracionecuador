codeunit 76013 "Funciones cooperativa"
{
    // Si en A1 pones Tasa (tipo de interes del periodo)
    // en B1 el nPer (número de Periodos)
    // en C1 el Va (Capital inicial)
    // Esta fórmula:
    // 
    // (A1*(1+A1)^B1)*C1/(((1+A1)^B1)-1)


    trigger OnRun()
    begin
    end;

    var
        ConfNominas: Record "Configuracion nominas";
        CabPrestamoscoop: Record "Cab. Prestamos cooperativa";
        LinPrestamoscooperativa: Record "Lin. Prestamos cooperativa";
        Miembroscooperativa: Record "Miembros cooperativa";
        HistCabPrestcooperativa: Record "Hist. Cab. Prest. cooperativa";
        PerfilSal: Record "Perfil Salarial";
        NoSeriesMgt: Codeunit "No. Series";
        Msg001: Label 'Successful employee activation';
        Msg002: Label 'Successful employee inactivation';
        Msg003: Label 'Successful employee retirement';
        Msg004: Label 'Employee %1 has an accumulated savings amount of %2 and a debt of %3, do you want to request a refund payment of this amount?';
        Err001: Label '%1 %2 already have an open loan associated to %3 %4. Please check and/or change the %5.';
        Err002: Label 'Employee %1 does not have enought time as member to opt for a loan';
        Err003: Label 'Loan cannot be approved because total outstanding loan amounts exceed 50% of accumulated savings for employee %1';
        Err004: Label 'Employee %1 exceeds the number of consecutive and outstanding loans issued for the quarter';
        Err005: Label '%1 is less than %2. Payment request is not possible';
        Text001: Label 'Retirement of accumulated savings withdrawal';


    procedure CrearCuotasCoop(CPCoop: Record "Cab. Prestamos cooperativa")
    var
        HistCabPrestcooperativa: Record "Hist. Cab. Prest. cooperativa";
        Cuota: Integer;
        MontoCuota: Decimal;
        Capital: Decimal;
        PorcInteres: Decimal;
        ImpInteres: Decimal;
        FechaFin: Date;
        Dividendo: Decimal;
        Divisor: Decimal;
        SaldoIni: Decimal;
    begin
        ConfNominas.Get();

        //Si es reingreso, controles para prestamos
        ConfNominas.TestField("Tiempo minimo prest. coop.");
        Miembroscooperativa.Get(CPCoop."Employee No.");
        if (Miembroscooperativa."Fecha reingreso" > CalcDate('-' + Format(ConfNominas."Tiempo minimo prest. coop."), Today)) and
           (Miembroscooperativa."Fecha reingreso" <> 0D) then
            Error(StrSubstNo(Err002, Miembroscooperativa."Full name"));

        //Validar cantidad de prestamos consecutivos
        HistCabPrestcooperativa.Reset;
        HistCabPrestcooperativa.SetCurrentKey("Employee No.", "Fecha Inicio Deduccion");
        HistCabPrestcooperativa.SetRange("Employee No.", CPCoop."Employee No.");
        HistCabPrestcooperativa.SetRange(Pendiente, true);
        HistCabPrestcooperativa.SetRange("Fecha Inicio Deduccion", CalcDate('-3M', Today), Today);
        if HistCabPrestcooperativa.FindSet then
            if HistCabPrestcooperativa.Count >= 3 then
                Error(StrSubstNo(Err004, Miembroscooperativa."Full name"));

        /*
        //Validar que importe no sea mayor a 50% de acumulado
        Miembroscooperativa.CALCFIELDS("Importe pendiente","Ahorro acumulado");
        IF Miembroscooperativa."Ahorro acumulado" /2 < Miembroscooperativa."Importe pendiente" + CPCoop.Importe THEN
           ERROR(STRSUBSTNO(Err003,Miembroscooperativa."Full name"));
        */
        CabPrestamoscoop.Get(CPCoop."No. Prestamo");
        CabPrestamoscoop.TestField("Employee No.");
        CabPrestamoscoop.TestField("Tipo prestamo");
        CabPrestamoscoop.TestField(Importe);
        CabPrestamoscoop.TestField("Cantidad de Cuotas");
        CabPrestamoscoop.TestField("Concepto Salarial");
        CabPrestamoscoop.CalcFields("Full name");

        MontoCuota := 0;
        Capital := 0;
        SaldoIni := 0;
        ImpInteres := 0;
        PorcInteres := 0;
        Dividendo := 0;
        Divisor := 0;

        HistCabPrestcooperativa.Reset;
        HistCabPrestcooperativa.SetRange("Employee No.", CabPrestamoscoop."Employee No.");
        HistCabPrestcooperativa.SetRange("Concepto Salarial", CabPrestamoscoop."Concepto Salarial");
        HistCabPrestcooperativa.SetRange(Pendiente, true);
        if HistCabPrestcooperativa.FindFirst then
            Error(StrSubstNo(Err001, CabPrestamoscoop.FieldCaption("Employee No."), CabPrestamoscoop."Employee No." + ', ' +
                  CabPrestamoscoop."Full name", CabPrestamoscoop.FieldCaption("Concepto Salarial"),
                  CabPrestamoscoop."Concepto Salarial", CabPrestamoscoop.FieldCaption("Concepto Salarial")));

        LinPrestamoscooperativa.Reset;
        LinPrestamoscooperativa.SetRange("No. Prestamo", CabPrestamoscoop."No. Prestamo");
        if LinPrestamoscooperativa.FindSet then
            LinPrestamoscooperativa.DeleteAll;

        LinPrestamoscooperativa.Reset;
        LinPrestamoscooperativa.Init;

        if CabPrestamoscoop."% Interes" <> 0 then begin
            //Esta es la formula financiera para cuando es cuota fija
            //(A1*(1+A1)^B1)*C1/(((1+A1)^B1)-1)
            //P = ((220000 * (0.0475/12)) / (1 - ((1 + (0.0475/12))^(-1 * 30 * 12))))
            PorcInteres := CabPrestamoscoop."% Interes" / 100;
            Dividendo := 1 + PorcInteres;
            Dividendo := Power(Dividendo, CabPrestamoscoop."Cantidad de Cuotas");
            Dividendo := PorcInteres * Dividendo;

            Divisor := 1 + PorcInteres;
            Divisor := Power(Divisor, CabPrestamoscoop."Cantidad de Cuotas");
            Divisor := Divisor - 1;

            MontoCuota := Dividendo / Divisor * CabPrestamoscoop.Importe;
        end
        else
            MontoCuota := CabPrestamoscoop.Importe / CabPrestamoscoop."Cantidad de Cuotas";

        Cuota := 1;
        while Cuota <= CabPrestamoscoop."Cantidad de Cuotas" do begin
            if LinPrestamoscooperativa."Saldo inicial" = 0 then begin
                Capital := CabPrestamoscoop.Importe;
                SaldoIni := Capital;
            end;


            ImpInteres := SaldoIni * PorcInteres;

            LinPrestamoscooperativa.Init;
            LinPrestamoscooperativa."No. Prestamo" := CabPrestamoscoop."No. Prestamo";
            LinPrestamoscooperativa."No. Cuota" := Cuota;
            LinPrestamoscooperativa."Tipo prestamo" := LinPrestamoscooperativa."Tipo prestamo";
            LinPrestamoscooperativa."Fecha Transaccion" := Today;
            LinPrestamoscooperativa."Código Empleado" := CabPrestamoscoop."Employee No.";
            LinPrestamoscooperativa."Saldo inicial" := SaldoIni;

            LinPrestamoscooperativa.Interes := ImpInteres;
            LinPrestamoscooperativa."Importe cuota" := MontoCuota;
            LinPrestamoscooperativa.Capital := MontoCuota - ImpInteres;

            LinPrestamoscooperativa.Saldo := LinPrestamoscooperativa."Saldo inicial" + ImpInteres - MontoCuota;
            SaldoIni := LinPrestamoscooperativa.Saldo;
            LinPrestamoscooperativa.Insert(true);
            Cuota += 1;
        end;

    end;


    procedure RegistrarPrestCoop(CPCoop: Record "Cab. Prestamos cooperativa")
    var
        HistLinPrestcooperativa: Record "Hist. Lin. Prest. cooperativa";
        Movcooperativa: Record "Mov. cooperativa";
        Movcooperativa2: Record "Mov. cooperativa";
    begin
        ConfNominas.Get();
        ConfNominas.TestField("No. serie Hist. Prest. Coop.");

        CabPrestamoscoop.Get(CPCoop."No. Prestamo");
        CabPrestamoscoop.TestField("Employee No.");
        CabPrestamoscoop.TestField("Tipo prestamo");
        CabPrestamoscoop.TestField(Importe);
        CabPrestamoscoop.TestField("Cantidad de Cuotas");
        CabPrestamoscoop.TestField("Fecha Inicio Deduccion");
        CabPrestamoscoop.TestField("Concepto Salarial");

        HistCabPrestcooperativa.Init;
        HistCabPrestcooperativa.TransferFields(CabPrestamoscoop);
        HistCabPrestcooperativa."No. Prestamo" := NoSeriesMgt.GetNextNo(ConfNominas."No. serie Hist. Prest. Coop.", WorkDate, true);
        HistCabPrestcooperativa.TestField("No. Prestamo");
        HistCabPrestcooperativa."No. Solicitud prestamo" := CabPrestamoscoop."No. Prestamo";
        HistCabPrestcooperativa.Pendiente := true;
        HistCabPrestcooperativa.Insert;

        LinPrestamoscooperativa.Reset;
        LinPrestamoscooperativa.SetRange("No. Prestamo", CabPrestamoscoop."No. Prestamo");
        LinPrestamoscooperativa.FindSet;
        repeat
            HistLinPrestcooperativa.Init;
            HistLinPrestcooperativa.TransferFields(LinPrestamoscooperativa);
            HistLinPrestcooperativa."No. Prestamo" := HistCabPrestcooperativa."No. Prestamo";
            HistLinPrestcooperativa.Insert(true);
        until LinPrestamoscooperativa.Next = 0;

        PerfilSal.Reset;
        PerfilSal.SetRange("No. empleado", CabPrestamoscoop."Employee No.");
        PerfilSal.SetRange("Concepto salarial", CabPrestamoscoop."Concepto Salarial");
        PerfilSal.FindFirst;
        PerfilSal.TestField("Tipo concepto", PerfilSal."Tipo concepto"::Deducciones);
        PerfilSal.Cantidad := 1;
        PerfilSal.Importe := HistLinPrestcooperativa."Importe cuota";
        PerfilSal.Modify;

        if not Movcooperativa2.FindLast then
            Movcooperativa2.Init;

        //Inserto el movimiento
        Movcooperativa.Init;
        Movcooperativa."No. Movimiento" := Movcooperativa2."No. Movimiento" + 1;
        Movcooperativa."Tipo miembro" := HistCabPrestcooperativa."Tipo de miembro";
        Movcooperativa."Employee No." := HistCabPrestcooperativa."Employee No.";
        Movcooperativa."Fecha registro" := CabPrestamoscoop."Fecha Inicio Deduccion";
        Movcooperativa."No. documento" := HistCabPrestcooperativa."No. Prestamo";
        Movcooperativa."Tipo transaccion" := Movcooperativa."Tipo transaccion"::"Préstamo";
        Movcooperativa.Importe := HistCabPrestcooperativa.Importe;
        Movcooperativa."Concepto salarial" := HistCabPrestcooperativa."Concepto Salarial";
        Movcooperativa.Insert(true);

        //Elimino tablas borrador
        LinPrestamoscooperativa.Reset;
        LinPrestamoscooperativa.SetRange("No. Prestamo", CabPrestamoscoop."No. Prestamo");
        LinPrestamoscooperativa.FindSet;
        LinPrestamoscooperativa.DeleteAll;
        CabPrestamoscoop.Delete;
    end;


    procedure ActivarMiembro(var Miembroscoop: Record "Miembros cooperativa")
    var
        Miembroscooperativa: Record "Miembros cooperativa";
    begin
        Miembroscooperativa.Copy(Miembroscoop);

        //Para identificarlo como re ingreso
        if Miembroscooperativa.Status = Miembroscooperativa.Status::Retirado then
            Miembroscooperativa."Fecha reingreso" := Today;

        ConfNominas.Get();
        ConfNominas.TestField("Concepto Cuota cooperativa");
        Miembroscooperativa.Status := 1;

        PerfilSal.Reset;
        PerfilSal.SetRange("No. empleado", Miembroscooperativa."Employee No.");
        PerfilSal.SetRange("Concepto salarial", ConfNominas."Concepto Cuota cooperativa");
        if not PerfilSal.FindFirst then begin
            PerfilSal.Init;
            PerfilSal.Validate("No. empleado", Miembroscooperativa."Employee No.");
            PerfilSal.Validate("Concepto salarial", ConfNominas."Concepto Cuota cooperativa");
            PerfilSal.Insert(true);
        end;
        Commit;
        case Miembroscooperativa."Tipo de aporte" of
            Miembroscooperativa."Tipo de aporte"::Fijo:
                begin
                    Miembroscooperativa.TestField(Importe);
                    PerfilSal.Cantidad := 1;
                    PerfilSal.Importe := Miembroscooperativa.Importe;
                end
            else begin
                Miembroscooperativa.TestField(Importe);
                PerfilSal.Cantidad := 1;
                PerfilSal."Formula calculo" := ConfNominas."Concepto Sal. Base" + '*' + Format(Miembroscooperativa.Importe / 100);
                PerfilSal.Validate("Formula calculo");
            end;
        end;
        PerfilSal."1ra Quincena" := Miembroscooperativa."1ra Quincena";
        PerfilSal."2da Quincena" := Miembroscooperativa."2da Quincena";
        PerfilSal.Modify(true);
        Miembroscooperativa.Modify(true);
        Message(Msg001);
    end;


    procedure InActivarMiembro(var Miembroscoop: Record "Miembros cooperativa")
    var
        Miembroscooperativa: Record "Miembros cooperativa";
    begin
        Miembroscooperativa.Copy(Miembroscoop);

        ConfNominas.Get();
        ConfNominas.TestField("Concepto Cuota cooperativa");
        Miembroscooperativa.Status := 2;
        Miembroscooperativa."Fecha inactivacion" := Today;

        PerfilSal.Reset;
        PerfilSal.SetRange("No. empleado", Miembroscooperativa."Employee No.");
        PerfilSal.SetRange("Concepto salarial", ConfNominas."Concepto Cuota cooperativa");
        PerfilSal.FindFirst;
        PerfilSal.Cantidad := 0;
        PerfilSal.Modify(true);

        Miembroscooperativa.Modify(true);
        Message(Msg002);
    end;


    procedure RetirarMiembro(var Miembroscoop: Record "Miembros cooperativa")
    var
        Miembroscooperativa: Record "Miembros cooperativa";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
    begin
        Miembroscooperativa.Copy(Miembroscoop);

        ConfNominas.Get();
        Miembroscooperativa.Status := 3;

        PerfilSal.Reset;
        PerfilSal.SetRange("No. empleado", Miembroscooperativa."Employee No.");
        PerfilSal.SetRange("Concepto salarial", ConfNominas."Concepto Cuota cooperativa");
        PerfilSal.FindFirst;
        PerfilSal.Cantidad := 0;
        PerfilSal.Modify(true);

        Miembroscooperativa.Modify(true);

        Miembroscooperativa.CalcFields("Ahorro acumulado", "Importe pendiente", "Full name");

        if Miembroscooperativa."Ahorro acumulado" <> 0 then begin
            if Confirm(StrSubstNo(Msg004, Miembroscooperativa."Full name", Format(Miembroscooperativa."Ahorro acumulado", 0, '<Integer thousand><Decimals,3>'), Format(Miembroscooperativa."Importe pendiente", 0, '<Integer thousand><Decimals,3>')), false) then begin
                if Miembroscooperativa."Ahorro acumulado" < Miembroscooperativa."Importe pendiente" then
                    Error(StrSubstNo(Err005, Miembroscooperativa.FieldCaption("Ahorro acumulado"), Miembroscooperativa.FieldCaption("Importe pendiente")));
                ConfNominas.TestField("Journal Template Name CK");
                ConfNominas.TestField("Journal Batch Name CK");
                ConfNominas.TestField("Cta. Nominas Otros Pagos");
                GenJnlLine2.Reset;
                GenJnlLine2.SetRange("Journal Template Name", ConfNominas."Journal Template Name CK");
                GenJnlLine2.SetRange("Journal Batch Name", ConfNominas."Journal Batch Name CK");
                if not GenJnlLine2.FindLast then
                    GenJnlLine2.Init;

                GenJnlLine.Init;
                GenJnlLine.Validate("Journal Template Name", ConfNominas."Journal Template Name CK");
                GenJnlLine.Validate("Journal Batch Name", ConfNominas."Journal Batch Name CK");
                GenJnlLine."Line No." := GenJnlLine2."Line No." + 1000;
                GenJnlLine.Validate("Posting Date", WorkDate);
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No." := 'LIQ-A-COOP-' + Miembroscooperativa."Employee No.";
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                //GenJnlLine.VALIDATE("Account No."
                GenJnlLine.Description := Text001;
                GenJnlLine.Validate(Amount, Round(Miembroscooperativa."Ahorro acumulado" - Miembroscooperativa."Importe pendiente", 0.01));
                case ConfNominas."Tipo Cta. Otros Pagos" of
                    0: //Cuenta
                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                    1: //Banco
                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
                    2: //Proveedor
                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Vendor;
                end;
                GenJnlLine.Validate("Bal. Account No.", ConfNominas."Cta. Nominas Otros Pagos");
                GenJnlLine.Insert(true);
            end;
        end;
        Message(Msg003);
    end;


    procedure RevisarStatus()
    begin
        Miembroscooperativa.Find('-');
        repeat
            if Miembroscooperativa.Status = Miembroscooperativa.Status::Inactivo then begin
                if CalcDate('+30D', Miembroscooperativa."Fecha inactivacion") > Today then begin
                    Miembroscooperativa."Fecha inactivacion" := 0D;
                    Miembroscooperativa.Status := Miembroscooperativa.Status::Activo;
                    Miembroscooperativa.Modify;
                end;
            end;
        until Miembroscooperativa.Next = 0;
    end;
}

