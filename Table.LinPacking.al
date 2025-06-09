table 56031 "Lin. Packing"
{
    Caption = 'Packing Line';

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(3; "No. Caja"; Code[20])
        {
            Caption = 'Box No.';
        }
        field(4; "Fecha Apertura Caja"; Date)
        {
        }
        field(5; "Fecha Cierre Caja"; Date)
        {
        }
        field(6; "Estado Caja"; Option)
        {
            Caption = 'Box Status';
            OptionCaption = 'Close,Open';
            OptionMembers = Cerrada,Abierta;
        }
        field(7; "No. Picking"; Code[20])
        {
            Caption = 'Picking No.';
        }
        field(8; "Total de Productos"; Decimal)
        {
            CalcFormula = Sum("Contenido Cajas Packing".Cantidad WHERE("No. Packing" = FIELD("No."),
                                                                        "No. Caja" = FIELD("No. Caja")));
            Caption = 'Item total';
            FieldClass = FlowField;
        }
        field(9; "No. Palet"; Code[20])
        {
            Caption = 'Palet No.';
        }
    }

    keys
    {
        key(Key1; "No.", "No. Caja")
        {
            Clustered = true;
        }
        key(Key2; "No. Picking")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestField("Estado Caja", "Estado Caja"::Abierta);
        CP.Reset;
        CP.SetRange("No. Packing", "No.");
        CP.SetRange("No. Caja", "No. Caja");
        CP.DeleteAll(true);
    end;

    var
        CP: Record "Contenido Cajas Packing";
        FuncSant: Codeunit "Funciones Santillana";
        ContCaja: Page "Contenido Cajas";


    procedure ContenidoCaja()
    begin
        CP.SetRange("No. Packing", "No.");
        CP.SetRange("No. Caja", "No. Caja");
        CP.SetRange("No. Picking", "No. Picking");
        ContCaja.SetTableView(CP);
        ContCaja.RunModal;
        Clear(ContCaja);
    end;


    procedure AbrirCaja()
    begin
        FuncSant.ReabrirCajaPacking(Rec);
        /*
        CP.SETRANGE("No. Packing","No.");
        CP.SETRANGE("No. Caja","No. Caja");
        CP.SETRANGE("No. Picking","No. Picking");
        CP.DELETEALL(TRUE);
         */

    end;
}

