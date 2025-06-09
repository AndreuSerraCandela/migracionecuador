table 76052 "Transacciones Caja TPV"
{
    // #70132 RRT, 09.07.2018: Añadir el campo  "NCR regis. de compensación"
    // #348662 25.11.2020  RRT: Actualizar DS-POS para ajustar a version 43c. Redenominar tambien campos con caracteres conflictivos.

    Caption = 'Transacción caja TPV';
    DrillDownPageID = "Lista trans. caja TPV";
    LookupPageID = "Lista trans. caja TPV";

    fields
    {
        field(10; "Cod. tienda"; Code[20])
        {
            Caption = 'Store No.';
            TableRelation = Tiendas;
        }
        field(20; "Cod. TPV"; Code[20])
        {
            Caption = 'POS Terminal No.';
            TableRelation = "Configuracion TPV"."Id TPV" WHERE(Tienda = FIELD("Cod. tienda"));
        }
        field(30; Fecha; Date)
        {
            Caption = 'Date';
        }
        field(40; "No. turno"; Integer)
        {
            Caption = 'Nº turno';
        }
        field(50; "No. transaccion"; Integer)
        {
            Caption = 'Transaction No.';
        }
        field(60; "Tipo transaccion"; Option)
        {
            Caption = 'Transaction Type';
            OptionCaption = 'Cobro TPV,Anulación,Entrada de caja,Salida de caja,Fondo de caja';
            OptionMembers = "Cobro TPV",Anulacion,Entrada,Salida,Fondo;
        }
        field(70; "Id. cajero"; Code[50])
        {
            Caption = 'Staff ID';
            TableRelation = Cajeros.ID WHERE(Tienda = FIELD("Cod. tienda"));
        }
        field(80; Hora; Time)
        {
            Caption = 'Time';
        }
        field(100; "Forma de pago"; Code[10])
        {
            Caption = 'Tender Type';
            TableRelation = "Formas de Pago";

            trigger OnValidate()
            var
                recTienda: Record Tiendas;
                recFormaPago: Record "Formas de Pago";
            begin
            end;
        }
        field(110; Importe; Decimal)
        {
            Caption = 'Net Amount';
            DecimalPlaces = 2 : 2;

            trigger OnValidate()
            var
                recCurrExchRate: Record "Currency Exchange Rate";
            begin
            end;
        }
        field(120; "Importe (DL)"; Decimal)
        {
            Caption = 'Net Amount';
            DecimalPlaces = 2 : 2;
        }
        field(130; "Cod. divisa"; Code[10])
        {
            Caption = 'Cód. divisa';
        }
        field(140; "Factor divisa"; Decimal)
        {
            Caption = 'Factor divisa';
            DecimalPlaces = 0 : 5;
        }
        field(145; "No. Registrado"; Code[20])
        {
            Caption = 'No. Registrado';
        }
        field(150; "Importe venta (DL)"; Decimal)
        {
            Caption = 'Importe venta (DL)';
        }
        field(160; "Total caja turno (DL)"; Decimal)
        {
            CalcFormula = Sum("Transacciones Caja TPV"."Importe (DL)" WHERE("Cod. tienda" = FIELD("Cod. tienda"),
                                                                             "Cod. TPV" = FIELD("Cod. TPV"),
                                                                             Fecha = FIELD(Fecha),
                                                                             "No. turno" = FIELD("No. turno")));
            Caption = 'Total caja turno (DL)';
            FieldClass = FlowField;
        }
        field(161; "Total cajadia (DL)"; Decimal)
        {
            CalcFormula = Sum("Transacciones Caja TPV"."Importe (DL)" WHERE("Cod. tienda" = FIELD("Cod. tienda"),
                                                                             "Cod. TPV" = FIELD("Cod. TPV"),
                                                                             Fecha = FIELD(Fecha)));
            Caption = 'Total caja dia (DL)';
            FieldClass = FlowField;
        }
        field(170; Cambio; Boolean)
        {
            Caption = 'Cambio';
        }
        field(76315; "Id Replicacion"; Code[20])
        {
            Description = 'DsPOS Standard';
        }
        field(76074; "NCR regis. de compensacion"; Code[20])
        {
            Description = 'DsPos Dominicana - #70132';
            TableRelation = "Sales Cr.Memo Header";
        }
    }

    keys
    {
        key(Key1; "Cod. tienda", "Cod. TPV", Fecha, "No. turno", "No. transaccion")
        {
            Clustered = true;
            SumIndexFields = Importe, "Importe (DL)", "Importe venta (DL)";
        }
        key(Key2; "Cod. tienda", "Cod. TPV", Fecha, "No. turno", "Forma de pago")
        {
            SumIndexFields = Importe, "Importe (DL)";
        }
        key(Key3; "Cod. tienda", "Cod. TPV", Fecha, "No. turno", "Tipo transaccion")
        {
        }
        key(Key4; "Cod. tienda", "Cod. TPV", Fecha, "No. turno", "Cod. divisa")
        {
        }
        key(Key5; "Id Replicacion")
        {
        }
        key(Key6; "No. Registrado", "Cod. divisa")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "No. turno" = 0 then
            AsignarTurno;

        "No. transaccion" := TraerUltimaTrans + 1;
        "Id Replicacion" := StrSubstNo('%1', Date2DMY(Fecha, 1)) + StrSubstNo('%1', Date2DMY(Fecha, 2)) + StrSubstNo('%1', Date2DMY(Fecha, 3));
    end;


    procedure TraerUltimaTrans(): Decimal
    var
        recTrans: Record "Transacciones Caja TPV";
    begin
        recTrans.Reset;
        recTrans.SetRange("Cod. tienda", "Cod. tienda");
        recTrans.SetRange("Cod. TPV", "Cod. TPV");
        recTrans.SetRange(Fecha, Fecha);
        recTrans.SetRange("No. turno", "No. turno");
        if recTrans.FindLast then
            exit(recTrans."No. transaccion");
    end;


    procedure AsignarTurno(): Integer
    var
    /*         cduControl: Codeunit "Control TPV"; */
    begin
        /*         "No. turno" := cduControl.TraerTurnoActual("Cod. tienda", "Cod. TPV", Fecha); */
    end;
}

