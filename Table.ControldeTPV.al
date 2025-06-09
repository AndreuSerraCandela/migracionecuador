table 76008 "Control de TPV"
{
    // #348662 25.11.2020  RRT: Actualizar DS-POS para ajustar a version 43c. Redenominar tambien campos con caracteres conflictivos.

    Caption = 'Control de TPV';

    fields
    {
        field(10; "No. tienda"; Code[20])
        {
            Caption = 'Nº tienda';
            TableRelation = Tiendas;
        }
        field(20; "No. TPV"; Code[20])
        {
            Caption = 'Nº TPV';
            TableRelation = "Configuracion TPV"."Id TPV" WHERE (Tienda = FIELD ("No. tienda"));
        }
        field(30; Fecha; Date)
        {
            Caption = 'Fecha';
        }
        field(60; "Hora apertura"; Time)
        {
            Caption = 'Hora apertura';
        }
        field(70; "Usuario apertura"; Code[20])
        {
            Caption = 'Usuario apertura';
        }
        field(90; "Hora cierre"; Time)
        {
            Caption = 'Hora cierre';
        }
        field(100; "Usuario cierre"; Code[20])
        {
            Caption = 'Usuario cierre';
        }
        field(110; "Nombre tienda"; Text[200])
        {
            CalcFormula = Lookup (Tiendas.Descripcion WHERE ("Cod. Tienda" = FIELD ("No. tienda")));
            Caption = 'Nombre tienda';
            FieldClass = FlowField;
        }
        field(120; "Nombre TPV"; Text[200])
        {
            CalcFormula = Lookup ("Configuracion TPV"."Id TPV" WHERE (Tienda = FIELD ("No. tienda"),
                                                                     "Id TPV" = FIELD ("No. TPV")));
            Caption = 'Nombre TPV';
            FieldClass = FlowField;
        }
        field(130; Estado; Option)
        {
            Caption = 'Estado';
            OptionCaption = 'Cerrado,Abierto';
            OptionMembers = Cerrado,Abierto;
        }
        field(150; "Usuario reapertura"; Code[20])
        {
            Caption = 'Usuario reapertura';
        }
        field(160; "Hora reapertura"; Time)
        {
            Caption = 'Hora reapertura';
        }
        field(170; "Motivo reapertura"; Text[60])
        {
            Caption = 'Motivo reapertura';
        }
        field(180; "No. Reaperturas"; Integer)
        {
        }
        field(76228; "Replicado POS"; Boolean)
        {
            Caption = 'Replicado POS';
            Description = 'DsPOS Standard';
        }
        field(76315; "Id Replicacion"; Code[20])
        {
            Description = 'DsPOS Standard';
        }
    }

    keys
    {
        key(Key1; "No. tienda", "No. TPV", Fecha)
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

        "Id Replicacion" := StrSubstNo('%1', Date2DMY(Fecha, 1)) + StrSubstNo('%1', Date2DMY(Fecha, 2)) + StrSubstNo('%1', Date2DMY(Fecha, 3));
    end;
}

