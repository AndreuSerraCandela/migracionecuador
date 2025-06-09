table 76004 "Pagos TPV"
{
    // #70132  19.06.2018 RRT  Creación de los campos "NCR regis. de compensación"
    // #184407 10.04.2018, RRT: Al igual que en Bolivia, se crea el campo "Registrado TPV".
    // 
    // RRT, 05.07.17: Por indicacion de PLB, no se debe testear el num de factura introducido. Esto ya se realizaba en las notad de credito.
    // #348662 25.11.2020  RRT: Actualizar DS-POS para ajustar a version 43c. Redenominar tambien campos con caracteres conflictivos.

    Caption = 'Tender POS';

    fields
    {
        field(76046; Tienda; Code[20])
        {
            Caption = 'Store';
            Description = 'DsPOS Standar';
            TableRelation = Tiendas."Cod. Tienda";
        }
        field(76029; TPV; Code[20])
        {
            Caption = 'POS';
            Description = 'DsPOS Standar';
            TableRelation = "Configuracion TPV"."Id TPV" WHERE (Tienda = FIELD (Tienda));
        }
        field(76016; "Forma pago TPV"; Code[20])
        {
            Caption = 'Tender Type POS';
            Description = 'DsPOS Standar';
            TableRelation = IF ("Tipo Tarjeta" = CONST ('')) "Formas de Pago"
            ELSE
            IF ("Tipo Tarjeta" = FILTER (<> '')) "Tipos de Tarjeta";

            trigger OnValidate()
            var
                recFormaPago: Record "Formas de Pago";
            begin
                if recFormaPago.Get("Forma pago TPV") then
                    Validate("Cod. divisa", recFormaPago."Cod. divisa");
            end;
        }
        field(76018; "No. Borrador"; Code[20])
        {
            Caption = 'Sales No.';
            Description = 'DsPOS Standar';
        }
        field(76015; "Cod. divisa"; Code[10])
        {
            Caption = 'Currency code';
            Description = 'DsPOS Standar';

            trigger OnValidate()
            var
                recDivisa: Record Currency;
            begin
                if "Cod. divisa" <> '' then begin
                    recDivisa.Get("Cod. divisa");
                    "Factor divisa" := recCurrExchRate.ExchangeRate(Fecha, "Cod. divisa");
                end;
            end;
        }
        field(76026; "Importe (DL)"; Decimal)
        {
            Caption = 'Amount';
            Description = 'DsPOS Standar';

            trigger OnValidate()
            var
                recDivisa: Record Currency;
            begin
                if "Cod. divisa" = '' then begin
                    Importe := "Importe (DL)";
                end else begin
                    recDivisa.Get("Cod. divisa");
                    recDivisa.TestField("Amount Rounding Precision");
                    Importe := Round(recCurrExchRate.ExchangeAmtLCYToFCY(Fecha, "Cod. divisa", "Importe (DL)", "Factor divisa"), recDivisa."Amount Rounding Precision")
                end;
            end;
        }
        field(76020; Importe; Decimal)
        {
            Caption = 'Importe';
            Description = 'DsPOS Standar';

            trigger OnValidate()
            begin
                if "Cod. divisa" = '' then
                    "Importe (DL)" := Importe
                else
                    "Importe (DL)" := Round(recCurrExchRate.ExchangeAmtFCYToLCY(Fecha, "Cod. divisa", Importe, "Factor divisa"));
            end;
        }
        field(76022; Cajero; Code[20])
        {
            Caption = 'Cashier';
            Description = 'DsPOS Standar';
            TableRelation = Cajeros.ID WHERE (Tienda = FIELD (Tienda));
        }
        field(76027; Fecha; Date)
        {
            Caption = 'Date';
            Description = 'DsPOS Standar';
        }
        field(76025; Hora; Time)
        {
            Caption = 'Time';
            Description = 'DsPOS Standar';
        }
        field(76017; "No. Factura"; Code[20])
        {
            Caption = 'Nº Factura';
            Description = 'DsPOS Standar';
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(76030; "Tipo Tarjeta"; Code[10])
        {
            Caption = 'Tipo Tarjeta';
            Description = 'DsPOS Standar';
            TableRelation = "Tipos de Tarjeta".Codigo;
        }
        field(76295; "No. Tarjeta"; Text[50])
        {
            Caption = 'Nº Tarjeta';
            Description = 'DsPOS Standar';
        }
        field(76227; "No. Cheque"; Text[30])
        {
            Caption = 'Nº Cheque';
            Description = 'DsPOS Standar';
        }
        field(76313; "Banco Cheque"; Code[20])
        {
            Caption = 'Banco Cheque';
            Description = 'DsPOS Standar';
            TableRelation = "Bank Account";
        }
        field(76228; "No. Nota Credito"; Code[20])
        {
            Caption = 'Return Invoice No.';
            Description = 'DsPOS Standar';
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(76009; "Importe Total divisa"; Decimal)
        {
            CalcFormula = Sum ("Pagos TPV".Importe WHERE ("No. Borrador" = FIELD ("No. Borrador"),
                                                         "Cod. divisa" = FIELD ("Cod. divisa")));
            Caption = 'Importe Total divisa';
            Description = 'DsPOS Standar';
            FieldClass = FlowField;
        }
        field(76076; Cambio; Boolean)
        {
            Caption = 'Cambio';
            Description = 'DsPOS Standar';
        }
        field(76169; "Factor divisa"; Decimal)
        {
            Caption = 'Factor divisa';
            DecimalPlaces = 0 : 5;
            Description = 'DsPOS Standar';
        }
        field(76170; "No. Documento Exencion"; Text[50])
        {
            Caption = 'No. Documento Exención';
            Description = 'DsPOS Standar';
        }
        field(76211; "Registrado TPV"; Boolean)
        {
            Description = 'DsPOS Standard - #211509';
            Editable = false;
            FieldClass = Normal;
        }
        field(76074; "NCR regis. de compensacion"; Code[20])
        {
            Description = '#70132';
            TableRelation = "Sales Cr.Memo Header";
        }
    }

    keys
    {
        key(Key1; "No. Borrador", "Forma pago TPV", Cambio)
        {
            Clustered = true;
        }
        key(Key2; "No. Factura", "Cod. divisa")
        {
            SumIndexFields = Importe;
        }
        key(Key3; "Forma pago TPV", "No. Borrador")
        {
        }
        key(Key4; "No. Nota Credito")
        {
        }
        key(Key5; "No. Nota Credito", "Cod. divisa")
        {
        }
        key(Key6; "No. Borrador", "Cod. divisa")
        {
            SumIndexFields = Importe;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Error(Error001);
    end;

    trigger OnModify()
    begin
        Error(Error001);
    end;

    trigger OnRename()
    begin
        Error(Error001);
    end;

    var
        Error001: Label 'Imposible Borrar, renombrar ó modificar';
        recCurrExchRate: Record "Currency Exchange Rate";
}

