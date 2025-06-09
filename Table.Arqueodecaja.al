table 76045 "Arqueo de caja"
{
    // #348662 25.11.2020  RRT: Actualizar DS-POS para ajustar a version 43c. Redenominar tambien campos con caracteres conflictivos.

    Caption = 'Arqueo de caja';

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
            TableRelation = "Configuracion TPV"."Id TPV";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
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
            TableRelation = "Formas de Pago"."ID Pago";
            ValidateTableRelation = true;
        }
        field(50; "Cod. divisa"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(60; Tipo; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Coin,Note,Roll';
            OptionMembers = Moneda,Billete;
        }
        field(70; Importe; Decimal)
        {
            Caption = 'Amount';
        }
        field(90; Cantidad; Integer)
        {
            Caption = 'Qty.';

            trigger OnValidate()
            begin
                Total := Cantidad * Importe;
            end;
        }
        field(100; Total; Decimal)
        {
            Caption = 'Total';
        }
        field(76315; "Id Replicacion"; Code[20])
        {
            Description = 'DsPOS Standard';
        }
    }

    keys
    {
        key(Key1; "Cod. tienda", "Cod. TPV", Fecha, "No. turno", "Forma de pago", "Cod. divisa", Tipo, Importe)
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

    trigger OnInsert()
    begin

        "Id Replicacion" := StrSubstNo('%1', Date2DMY(Fecha, 1)) + StrSubstNo('%1', Date2DMY(Fecha, 2)) + StrSubstNo('%1', Date2DMY(Fecha, 3));
    end;


    procedure TraerDescripcion(): Text[30]
    var
        recCfgConta: Record "General Ledger Setup";
        recDivisa: Record Currency;
    begin
        if "Cod. divisa" = '' then begin
            recCfgConta.Get;
            if recCfgConta."LCY Code" <> '' then begin
                if recDivisa.Get(recCfgConta."LCY Code") then
                    exit(recDivisa.Description)
                else
                    exit(recCfgConta."LCY Code")
            end;
        end
        else
            if recDivisa.Get("Cod. divisa") then
                exit(recDivisa.Description)
    end;
}

