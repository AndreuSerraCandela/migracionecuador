table 56034 "Lin. Packing Registrada"
{
    // #842 CAT 07/02/14 Nuevos campos:
    //               9  No. Palet
    //              10  Cod. seguimiento

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
            CalcFormula = Sum("Contenido Cajas Packing Reg.".Cantidad WHERE("No. Packing" = FIELD("No."),
                                                                             "No. Caja" = FIELD("No. Caja")));
            Caption = 'Item total';
            FieldClass = FlowField;
        }
        field(9; "No. Palet"; Code[20])
        {
            Description = '#842';
        }
        field(10; "Cod. seguimiento"; Code[20])
        {
            Description = '#842';
        }
        field(11; "No. Pedido"; Code[20])
        {
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST(Order));
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

    var
        CPR: Record "Contenido Cajas Packing Reg.";
        ContCaja: Page "Contenido Cajas";


    procedure ContenidoCaja()
    begin
        CPR.Reset;
        CPR.SetRange(CPR."No. Packing", "No.");
        CPR.SetRange(CPR."No. Caja", "No. Caja");
        CPR.SetRange(CPR."No. Picking", "No. Picking");
        ContCaja.SetTableView(CPR);
        ContCaja.RunModal;
        Clear(ContCaja);
    end;
}

