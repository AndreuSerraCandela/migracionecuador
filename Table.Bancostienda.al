table 76018 "Bancos tienda"
{
    Caption = 'Stores';
    LookupPageID = "Ficha Tienda";

    fields
    {
        field(10; "Cod. Tienda"; Code[20])
        {
            Caption = 'Store Code';
            Description = 'DsPOS Standar';
            NotBlank = true;
            TableRelation = Tiendas;
        }
        field(20; "Cod. Divisa"; Code[10])
        {
            Description = 'DsPOS Standar';
            NotBlank = false;
            TableRelation = Currency;
        }
        field(30; "Cod. Banco"; Code[20])
        {
            Caption = 'Bank Account';
            Description = 'DsPOS Standar';
            NotBlank = true;
            TableRelation = "Bank Account";

            trigger OnValidate()
            var
                rBanco: Record "Bank Account";
            begin

                if "Cod. Banco" <> '' then begin
                    rBanco.Get("Cod. Banco");
                    rBanco.TestField("Currency Code", "Cod. Divisa");
                end;
            end;
        }
        field(40; "Nombre Banco"; Text[100])
        {
            CalcFormula = Lookup ("Bank Account".Name WHERE ("No." = FIELD ("Cod. Banco")));
            Caption = 'Bank Name';
            Description = 'DsPOS Standar';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Cod. Tienda", "Cod. Divisa")
        {
            Clustered = true;
        }
    }

/*     fieldgroups
    {
        fieldgroup(DropDown; Field34002500, Field34002501)
        {
        }
    } */

    trigger OnDelete()
    var
        rConfTPV: Record "Configuracion TPV";
    begin
    end;

    var
        text001: Label 'La tienda %1 tiene TPV''s configurados, si continua se BORRARAN todos ¿Continuar?';
        Error001: Label 'Proceso Cancelado a petición del usuario';
        //Error002: ;
}

