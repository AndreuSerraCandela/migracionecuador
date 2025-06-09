table 76069 Contratos
{
    DataCaptionFields = "No. empleado";
    DrillDownPageID = Contratos;
    LookupPageID = Contratos;

    fields
    {
        field(1; "Empresa cotización"; Code[10])
        {
        }
        field(2; "No. empleado"; Code[15])
        {
            TableRelation = Employee;
        }
        field(3; "No. Orden"; Integer)
        {
        }
        field(4; "Cód. contrato"; Code[5])
        {
            NotBlank = true;
            TableRelation = "Employment Contract";

            trigger OnValidate()
            begin
                TipoContrato.Get("Cód. contrato");
                Indefinido := TipoContrato.Undefined;
                Descripción := TipoContrato.Description;
                Activo := true;

                Trabajad.Get("No. empleado");
                if Trabajad."Employment Date" <> 0D then
                    "Fecha inicio" := Trabajad."Employment Date";

                Cargo := Trabajad."Job Type Code";
                "Centro trabajo" := Trabajad."Working Center";
            end;
        }
        field(5; Disponible; Code[12])
        {
            Enabled = false;
        }
        field(6; "Descripción"; Text[50])
        {
        }
        field(7; "Fecha inicio"; Date)
        {

            trigger OnValidate()
            begin
                Trabajad.Get("No. empleado");
                if Trabajad."Alta contrato" = 0D then begin
                    Trabajad."Alta contrato" := "Fecha inicio";
                    Trabajad.Modify(true);
                end;

                if Rec."Fecha inicio" <> xRec."Fecha inicio" then begin
                    /*     "Cab.nómina".RESET;
                         "Cab.nómina".SETRANGE("No. empleado","No. empleado");
                         "Cab.nómina".SETRANGE(Período,"Fecha inicio","Fecha finalización");
                         IF "Cab.nómina".FINDFIRST THEN
                           ERROR (Err001);
                           */
                    Trabajad."Employment Date" := "Fecha inicio";
                    Trabajad."Alta contrato" := "Fecha inicio";
                    Trabajad.Modify;
                end;

            end;
        }
        field(8; Duracion; Text[30])
        {
            Caption = 'Duration';
            DateFormula = true;

            trigger OnValidate()
            begin
                if "Fecha inicio" = 0D then
                    Error(Err002);

                if Duracion <> '' then begin
                    TiempoDurac := CopyStr(Duracion + '-1D', 1, 30);
                    "Fecha finalización" := CalcDate(TiempoDurac, "Fecha inicio");
                end;

                Trabajad.Get("No. empleado");
                Trabajad."Fin contrato" := "Fecha finalización";
                Trabajad.Modify;

                TipoContrato.Get("Cód. contrato");
                //GRN 31/03/2011 IF CALCDATE(Duración,TODAY) < CALCDATE(TipoContrato.Period,TODAY)  THEN
                //  ERROR(Err003);
            end;
        }
        field(9; "Fecha finalización"; Date)
        {

            trigger OnValidate()
            begin
                Trabajad.Get("No. empleado");
                //IF Trabajad."Fin contrato" = 0D THEN
                begin
                    Trabajad."Fin contrato" := "Fecha finalización";
                    Trabajad."Termination Date" := "Fecha finalización";
                    if Trabajad."Fin contrato" = 0D then
                        Trabajad.Status := Trabajad.Status::Active;
                    Trabajad.Modify;
                end;
                /*
                IF Trabajad."Motivo baja" <> 0 THEN
                   "Motivo baja"          := Trabajad."Motivo baja"
                ELSE
                   Trabajad."Motivo baja" := "Motivo baja";
                
                IF (xRec."Motivo baja" = "Motivo baja") OR (xRec."Fecha finalización" = "Fecha finalización") THEN
                   Trabajad.MODIFY(TRUE);
                */

            end;
        }
        field(10; Cargo; Code[15])
        {
            TableRelation = "Puestos laborales";
        }
        field(11; "Centro trabajo"; Code[10])
        {
        }
        field(12; "Motivo baja"; Code[10])
        {
            TableRelation = "Grounds for Termination";

            trigger OnValidate()
            var
                MotivoBaja: Record "Grounds for Termination";
            begin
                if "Motivo baja" <> '' then begin
                    MotivoBaja.Get("Motivo baja");
                    "Causa de la Baja" := MotivoBaja.Description;
                end;
            end;
        }
        field(21; Finalizado; Boolean)
        {

            trigger OnValidate()
            begin
                if Finalizado then begin
                    Trabajad.Get("No. empleado");
                    Trabajad."Estado Contrato" := 2;
                    Trabajad.Status := Trabajad.Status::Terminated;
                    Trabajad."Calcular Nomina" := false;
                    Trabajad."Fecha salida empresa" := "Fecha finalización";
                    Trabajad.Modify;
                end;

                if Finalizado then
                    Activo := false;
            end;
        }
        field(22; "Días preaviso"; Text[30])
        {
            DateFormula = true;
            InitValue = '15D';
        }
        field(23; "Período prueba"; Text[30])
        {
            DateFormula = true;
        }
        field(33; Jornada; Text[20])
        {
        }
        field(34; "Frecuencia de pago"; Option)
        {
            Caption = 'Payment frequency';
            OptionCaption = 'Daily,Weekly,Bi-Weekly,Half Month,Monthly,Yearly';
            OptionMembers = Diaria,Semanal,"Bi-Semanal",Quincenal,Mensual,Anual;
        }
        field(39; "Días semana"; Decimal)
        {
            DecimalPlaces = 2 : 2;

            trigger OnValidate()
            begin
                if "Días semana" <> 0 then
                    "Horas semana" := "Horas dia" * "Días semana"
                else
                    "Días semana" := "Horas semana" / "Horas dia";
            end;
        }
        field(40; "Horas dia"; Decimal)
        {
            DecimalPlaces = 2 : 2;

            trigger OnValidate()
            begin
                if "Horas dia" <> 0 then
                    "Horas semana" := "Horas dia" * "Días semana"
                else
                    "Horas dia" := "Horas semana" / "Días semana";
            end;
        }
        field(41; "Horas semana"; Decimal)
        {
            DecimalPlaces = 2 : 2;

            trigger OnValidate()
            begin
                if "Horas semana" = 0 then
                    "Horas semana" := "Horas dia" * "Días semana"
                else
                    if "Días semana" = 0 then
                        "Días semana" := "Horas semana" / "Horas dia"
                    else
                        "Horas dia" := "Horas semana" / "Días semana";
            end;
        }
        field(50; "Causa de la Baja"; Text[30])
        {
        }
        field(61; Indefinido; Boolean)
        {

            trigger OnValidate()
            begin
                Trabajad.Get("No. empleado");

                if Indefinido then
                    Trabajad."Estado Contrato" := 1  /*estado indefinido   */
                else
                    Trabajad."Estado Contrato" := 3; /*estado no finalizado */

                Trabajad.Modify;

            end;
        }
        field(62; Activo; Boolean)
        {

            trigger OnValidate()
            begin
                if not Activo then begin
                    Trabajad.Get("No. empleado");
                    Trabajad.Status := Trabajad.Status::Terminated;
                    Trabajad."Estado Contrato" := Trabajad."Estado Contrato"::Finalizado;
                    Trabajad.Modify;
                end
                else begin
                    Trabajad.Get("No. empleado");
                    Trabajad.Status := Trabajad.Status::Active;
                    Trabajad."Estado Contrato" := Trabajad."Estado Contrato"::Indefinido;
                    Trabajad.Modify;
                end;

                if Activo then
                    Finalizado := false;
            end;
        }
        field(63; "Pagar preaviso"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(64; "Pagar cesantia"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(56000; "Grado ocupacion"; Decimal)
        {
            Caption = 'Grado ocupación';
            DataClassification = ToBeClassified;
            Description = 'MdE';
            MaxValue = 100;
            MinValue = 0;
        }
    }

    keys
    {
        key(Key1; "No. empleado", "No. Orden")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        Contratos: Record Contratos;
    begin
        //+MdE
        if not FromMdE then
            MdeMngt.Contrato_Delete(Rec);
        //-MdE

        "Cab.nómina".SetRange("No. empleado", "No. empleado");
        "Cab.nómina".SetRange(Período, "Fecha inicio", "Fecha finalización");
        if "Cab.nómina".FindFirst then
            Message(Err005);

        //+#001
        if EsUltimoContrato then begin
            Contratos.SetRange("No. empleado", "No. empleado");
            Contratos.SetFilter("No. Orden", '<%1', "No. Orden");
            if Contratos.FindLast then
                ActualizarEmpleado(Contratos);
        end;
        //-#001
    end;

    trigger OnInsert()
    begin
        //+MdE
        if not FromMdE then
            MdeMngt.Contrato_Insert(Rec);
        //-MdE

        //+#001
        /*
        Cont.RESET;
        Cont.SETRANGE("No. empleado","No. empleado");
        Cont.SETRANGE(Activo,TRUE);
        IF Cont.COUNT > 1 THEN
           ERROR(Err001);
        
        Trabajad.GET("No. empleado");
        TipoContrato.GET("Cód. contrato");
        Trabajad.TESTFIELD(Company);
        "Empresa cotización" := Trabajad.Company;
        Cargo                := Trabajad."Job Type Code";
        "Centro trabajo"     := Trabajad."Working Center";
        Descripción          := TipoContrato.Description;
        "Fecha inicio"       := Trabajad."Employment Date";
        Trabajad."Termination Date"  := "Fecha finalización";
        Trabajad."Fin contrato"      := "Fecha finalización";
        Trabajad."Fecha salida empresa" := "Fecha finalización";
        Trabajad."Alta contrato" := "Fecha inicio";
        Trabajad."Calcular Nomina" := TRUE;
        Trabajad.Status := Trabajad.Status::Active;
        Trabajad.MODIFY;
        */

        ActualizarContrato;
        if EsUltimoContrato then
            ActualizarEmpleado(Rec);
        //+#001

    end;

    trigger OnModify()
    begin
        //+MdE
        if not FromMdE then
            MdeMngt.Contrato_Modify(Rec, xRec);
        //-MdE

        TipoContrato.Get("Cód. contrato");
        if (TipoContrato.Undefined = false) and ("Fecha inicio" = 0D) then
            Error(Err004);

        //+#001
        /*
        Trabajad.GET("No. empleado");
        IF "Fecha finalización" <> Trabajad."Termination Date" THEN
           BEGIN
            Trabajad."Termination Date"  := "Fecha finalización";
            Trabajad."Fin contrato"      := "Fecha finalización";
           END;
        
        IF NOT TipoContrato.Undefined THEN
            Trabajad."Tipo Empleado" := 1
        ELSE
          Trabajad."Tipo Empleado" := 0;
        
        IF Activo THEN
           BEGIN
            Trabajad."Calcular Nomina" := TRUE;
            Trabajad.Status := Trabajad.Status::Active;
           END;
        Trabajad.MODIFY;
        
        //MESSAGE('%1 %2',TipoContrato.Indefinite,Trabajad."Tipo Empleado");
        //"Tipo Pago Nomina"   := Trabajad."Forma de Cobro";
        */

        ActualizarContrato;
        if EsUltimoContrato then
            ActualizarEmpleado(Rec);
        //-#001

    end;

    var
        Empresa: Record "Empresas Cotizacion";
        Trabajad: Record Employee;
        TipoContrato: Record "Employment Contract";
        "Cab.nómina": Record "Historico Cab. nomina";
        Cont: Record Contratos;
        TiempoDurac: Text[30];
        rCfgNom: Record "Configuracion nominas";
        rEmp: Record Employee;
        Err001: Label 'Can''t change starting date if there are posted payrolls';
        Err002: Label 'You must indicate starting date...';
        Err003: Label 'Length can''t be less than minimun time';
        Err004: Label 'When non undefined contract, you must indicate starting date...';
        Err005: Label 'You can''t delete a contract with posted payrolls';
        Err006: Label 'There can only be one active contract per employee';
        FromMdE: Boolean;
        MdeMngt: Codeunit "MdE Management";


    procedure SetFromMde(New_FromMdE: Boolean)
    begin
        FromMdE := New_FromMdE;
    end;


    procedure ActualizarEmpleado(Contratos: Record Contratos)
    var
        Empleado: Record Employee;
    begin
        //+#001
        Empleado.Get(Contratos."No. empleado");
        Empleado."Employment Date" := Contratos."Fecha inicio";
        Empleado."Alta contrato" := Contratos."Fecha inicio";
        Empleado."Termination Date" := Contratos."Fecha finalización";
        Empleado."Fin contrato" := Contratos."Fecha finalización";
        Empleado."Fecha salida empresa" := Contratos."Fecha finalización";
        Empleado.Company := Contratos."Empresa cotización";
        Empleado."Job Type Code" := Contratos.Cargo;
        Empleado."Working Center" := Contratos."Centro trabajo";
        Empleado."Emplymt. Contract Code" := Contratos."Cód. contrato";

        TipoContrato.Get(Contratos."Cód. contrato");
        if not TipoContrato.Undefined then
            Empleado."Tipo Empleado" := Empleado."Tipo Empleado"::Temporal;

        Empleado.Modify;
    end;


    procedure ActualizarContrato()
    var
        Empleado: Record Employee;
    begin
        //+#001
        Empleado.Get("No. empleado");

        if "Empresa cotización" = '' then
            "Empresa cotización" := Empleado.Company;

        if Cargo = '' then
            Cargo := Empleado."Job Type Code";

        if "Centro trabajo" = '' then
            "Centro trabajo" := Empleado."Working Center";

        if Descripción = '' then begin
            if TipoContrato.Get("Cód. contrato") then
                Descripción := TipoContrato.Description;
        end;

        if "Fecha inicio" = 0D then
            "Fecha inicio" := Empleado."Employment Date";

        if "Cód. contrato" = '' then
            "Cód. contrato" := Empleado."Emplymt. Contract Code";
    end;


    procedure EsUltimoContrato(): Boolean
    var
        Contratos: Record Contratos;
    begin
        //+#001
        Contratos.SetRange("No. empleado", "No. empleado");
        if not Contratos.FindLast then
            exit(true); // estamos creando el primer contrato

        exit("No. Orden" >= Contratos."No. Orden");
    end;
}

