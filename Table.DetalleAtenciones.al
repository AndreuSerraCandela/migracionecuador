table 76210 "Detalle Atenciones"
{

    fields
    {
        field(1; "Código Cab. Atención"; Code[20])
        {
        }
        field(2; "No. Linea"; Integer)
        {
        }
        field(3; Codigo; Code[20])
        {

            trigger OnLookup()
            var
                pgAte: Page "Lista Atenciones";
                rAte: Record "Datos auxiliares";
                rCab: Record "Cab. Atenciones";
            begin
                if Tipo = Tipo::"Atención" then begin
                    rAte.FilterGroup(2);
                    rAte.SetRange("Tipo registro", rAte."Tipo registro"::Atenciones);
                    rAte.FilterGroup(0);
                    pgAte.SetTableView(rAte);
                    pgAte.Editable(false);
                    pgAte.LookupMode(true);
                    if pgAte.RunModal = ACTION::LookupOK then begin
                        pgAte.GetRecord(rAte);
                        Codigo := rAte.Codigo;
                        Descripción := rAte.Descripcion;
                        Cantidad := 1;
                        "Precio Unitario" := rAte."Costo Unitario";
                        "Monto total" := "Precio Unitario";
                        Insert(true);
                    end;
                end;
            end;
        }
        field(4; "Descripción"; Text[100])
        {
        }
        field(5; Cantidad; Decimal)
        {

            trigger OnValidate()
            begin
                "Monto total" := Cantidad * "Precio Unitario";
            end;
        }
        field(6; "Precio Unitario"; Decimal)
        {

            trigger OnValidate()
            begin
                "Monto total" := Cantidad * "Precio Unitario";
            end;
        }
        field(7; "Monto total"; Decimal)
        {
            Editable = false;
        }
        field(8; Tipo; Option)
        {
            OptionCaption = 'Atención,Pedido';
            OptionMembers = "Atención",Pedido;
        }
    }

    keys
    {
        key(Key1; "Código Cab. Atención", "No. Linea")
        {
            Clustered = true;
            SumIndexFields = "Monto total";
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        rDet: Record "Detalle Atenciones";
    begin

        rDet.SetRange("Código Cab. Atención", "Código Cab. Atención");
        if rDet.FindLast then
            "No. Linea" := rDet."No. Linea" + 1
        else
            "No. Linea" := 1;
    end;
}

