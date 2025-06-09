table 76033 "Lin. declaracion caja"
{
    // #348662 25.11.2020  RRT: Actualizar DS-POS para ajustar a version 43c. Redenominar tambien campos con caracteres conflictivos.

    Caption = 'Lín. declaración de caja TPV';

    fields
    {
        field(10; "No. tienda"; Code[20])
        {
            Caption = 'Store No.';
            TableRelation = Tiendas;
        }
        field(20; "No. TPV"; Code[20])
        {
            Caption = 'POS Terminal No.';
            TableRelation = "Configuracion TPV"."Id TPV" WHERE(Tienda = FIELD("No. tienda"));
        }
        field(25; Fecha; Date)
        {
            Caption = 'Fecha';
        }
        field(30; "No. turno"; Integer)
        {
            Caption = 'Receipt No.';
        }
        field(40; "Forma de pago"; Code[10])
        {
            Caption = 'Tender Type';
            TableRelation = "Formas de Pago";

            trigger OnValidate()
            var
                recTienda: Record Tiendas;
                recFormaPago: Record "Formas de Pago";
            begin
                //Si se requiere arqueo se marca el campo "arqueo requerido" para copiar la configuración de arqueo.

                "Requiere recueto" := false;
                recTienda.Get("No. tienda");
                recFormaPago.Get("Forma de pago");
                Validate("Cod. divisa", recFormaPago."Cod. divisa");
                if recTienda."Arqueo de caja obligatorio" then
                    "Requiere recueto" := recFormaPago."Realizar recuento";
            end;
        }
        field(50; Descripcion; Text[250])
        {
            Caption = 'Description';
            TableRelation = "Formas de Pago".Descripcion WHERE("ID Pago" = FIELD("Forma de pago"));
        }
        field(60; "Cod. divisa"; Code[10])
        {
            Caption = 'Currency Code';

            trigger OnValidate()
            var
                recDivisa: Record Currency;
                recCurrExchRate: Record "Currency Exchange Rate";
            begin
                if "Cod. divisa" <> '' then begin
                    recDivisa.Get("Cod. divisa");
                    "Factor divisa" := recCurrExchRate.ExchangeRate(Fecha, "Cod. divisa");
                end;
            end;
        }
        field(70; "Factor divisa"; Decimal)
        {
            Caption = 'Real Exchange Rate';
            DecimalPlaces = 0 : 5;
        }
        field(80; "Importe calculado"; Decimal)
        {
            CalcFormula = Sum("Transacciones Caja TPV".Importe WHERE("Cod. tienda" = FIELD("No. tienda"),
                                                                      "Cod. TPV" = FIELD("No. TPV"),
                                                                      Fecha = FIELD(Fecha),
                                                                      "No. turno" = FIELD("No. turno"),
                                                                      "Forma de pago" = FIELD("Forma de pago")));
            Caption = 'Trans. Amount in LCY';
            FieldClass = FlowField;
        }
        field(90; "Importe calculado (DL)"; Decimal)
        {
            CalcFormula = Sum("Transacciones Caja TPV"."Importe (DL)" WHERE("Cod. tienda" = FIELD("No. tienda"),
                                                                             "Cod. TPV" = FIELD("No. TPV"),
                                                                             Fecha = FIELD(Fecha),
                                                                             "No. turno" = FIELD("No. turno"),
                                                                             "Forma de pago" = FIELD("Forma de pago")));
            Caption = 'Trans. Amount in LCY';
            FieldClass = FlowField;
        }
        field(100; "Importe contado"; Decimal)
        {
            Caption = 'Amount';
            MinValue = 0;

            trigger OnLookup()
            var
                recCurrExchRate: Record "Currency Exchange Rate";
            begin
                LookupArqueo;
            end;

            trigger OnValidate()
            var
                Error001: Label 'Se debe realizar el recuento para la forma de pago %1.';
                recCurrExchRate: Record "Currency Exchange Rate";
            begin
                if "Requiere recueto" then
                    Error(Error001, "Forma de pago");

                if "Cod. divisa" = '' then
                    "Importe contado (DL)" := "Importe contado"
                else
                    "Importe contado (DL)" := Round(recCurrExchRate.ExchangeAmtFCYToLCY(Fecha, "Cod. divisa", "Importe contado", "Factor divisa"));
            end;
        }
        field(110; "Importe contado (DL)"; Decimal)
        {
            Caption = 'Amount in LCY';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(140; "Requiere recueto"; Boolean)
        {
            Caption = 'Requiere recuento';
        }
        field(76315; "Id Replicacion"; Code[20])
        {
            Description = 'DsPOS Standard';
        }
    }

    keys
    {
        key(Key1; "No. tienda", "No. TPV", Fecha, "No. turno", "Forma de pago")
        {
            Clustered = true;
        }
        key(Key2; "Id Replicacion")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        recArqueo: Record "Arqueo de caja";
    begin
    end;

    trigger OnInsert()
    begin
        if "Requiere recueto" then
            InsertarCfgArqueo;

        "Id Replicacion" := StrSubstNo('%1', Date2DMY(Fecha, 1)) + StrSubstNo('%1', Date2DMY(Fecha, 2)) + StrSubstNo('%1', Date2DMY(Fecha, 3));
    end;

    trigger OnModify()
    begin
        ControlEstadoTPV;
    end;


    procedure ControlArqueoRequerido()
    var
        recTienda: Record Tiendas;
        Error001: Label 'Se debe realizar el arqueo de caja para la forma de pago %1.';
    begin
        recTienda.Get("No. tienda");
        if recTienda."Arqueo de caja obligatorio" then
            Error(Error001, "Forma de pago");
    end;


    procedure InsertarCfgArqueo()
    var
        recCfgArqueo: Record "Billetes y Monedas Divisa";
        recArqueo: Record "Arqueo de caja";
        Error001: Label 'Debe configurar el arqueo de caja para divisa %1';
    begin
        recCfgArqueo.Reset;
        recCfgArqueo.SetRange("Cod. divisa", "Cod. divisa");
        if recCfgArqueo.FindSet then begin
            repeat
                recArqueo.Init;
                recArqueo."Cod. tienda" := "No. tienda";
                recArqueo."Cod. TPV" := "No. TPV";
                recArqueo.Fecha := Fecha;
                recArqueo."No. turno" := "No. turno";
                recArqueo."Forma de pago" := "Forma de pago";
                recArqueo."Cod. divisa" := recCfgArqueo."Cod. divisa";
                recArqueo.Tipo := recCfgArqueo.Tipo;
                recArqueo.Importe := recCfgArqueo.Importe;
                recArqueo.Insert(true);
            until recCfgArqueo.Next = 0;
        end
        else
            Error(Error001, "Cod. divisa");
    end;


    procedure LookupArqueo()
    var
        recCurrExchRate: Record "Currency Exchange Rate";
        recArqueo: Record "Arqueo de caja";
        frmArqueo: Page "Arqueo de caja";
        Error001: Label 'La forma de pago %1 no requiere recuento.';
    begin
        if not "Requiere recueto" then
            Error(Error001, "Forma de pago");

        recArqueo.Reset;
        recArqueo.SetRange("Cod. tienda", "No. tienda");
        recArqueo.SetRange("Cod. TPV", "No. TPV");
        recArqueo.SetRange(Fecha, Fecha);
        recArqueo.SetRange("No. turno", "No. turno");
        recArqueo.SetRange("Forma de pago", "Forma de pago");
        Clear(frmArqueo);
        frmArqueo.LookupMode := true;
        frmArqueo.SetTableView(recArqueo);
        if frmArqueo.RunModal = ACTION::LookupOK then begin
            "Importe contado" := frmArqueo.TraerTotalContado;
            if "Cod. divisa" = '' then
                "Importe contado (DL)" := "Importe contado"
            else
                "Importe contado (DL)" := Round(recCurrExchRate.ExchangeAmtFCYToLCY(Fecha, "Cod. divisa", "Importe contado", "Factor divisa"));
            Modify;
        end;
    end;


    procedure TraerDiferencia(): Decimal
    begin
        if not "Requiere recueto" then
            exit(0);

        CalcFields("Importe calculado");
        exit("Importe contado" - "Importe calculado");
    end;


    procedure TraerDiferenciaDL(): Decimal
    begin
        if not "Requiere recueto" then
            exit(0);

        CalcFields("Importe calculado (DL)");
        exit("Importe contado (DL)" - "Importe calculado (DL)");
    end;


    procedure ControlEstadoTPV()
    var
        recControlTurno: Record "Turnos TPV";
        Error001: Label 'El turno está cerrado.';
    begin
        recControlTurno.Get("No. tienda", "No. TPV", Fecha, "No. turno");
        if recControlTurno.Estado = recControlTurno.Estado::Cerrado then
            Error(Error001);
    end;
}

