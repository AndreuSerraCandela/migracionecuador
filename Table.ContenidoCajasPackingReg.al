table 56035 "Contenido Cajas Packing Reg."
{
    Caption = 'Packing Box Content';

    fields
    {
        field(1; "No. Packing"; Code[20])
        {
        }
        field(2; "No. Caja"; Code[20])
        {
            Caption = 'Box No.';
        }
        field(3; "No. Producto"; Code[20])
        {
            Caption = 'Item No.';
        }
        field(4; Descripcion; Text[200])
        {
            Caption = 'Description';
        }
        field(5; "No. Linea"; Integer)
        {
            Caption = 'Line No.';
        }
        field(6; "Cod. Barras"; Code[30])
        {
            Caption = 'Barcode';
        }
        field(7; "Cod. Unidad de Medida"; Code[20])
        {
            Caption = 'Unit Of Measure Code';
            Editable = false;
            TableRelation = "Item Unit of Measure".Code WHERE ("Item No." = FIELD ("No. Producto"));
        }
        field(8; Cantidad; Decimal)
        {
            Caption = 'Quantity';
        }
        field(9; "No. Picking"; Code[20])
        {
            Caption = 'Picking No';
        }
        field(10; "No. Linea Picking"; Integer)
        {
            Caption = 'Picking Line No.';
            NotBlank = true;
            TableRelation = "Registered Whse. Activity Line"."Line No." WHERE ("Activity Type" = FILTER (Pick),
                                                                               "No." = FIELD ("No. Picking"),
                                                                               "No. Packing" = FILTER (''),
                                                                               "No. Caja" = FILTER (''),
                                                                               "No. Linea Packing" = FILTER (0));

            trigger OnValidate()
            begin
                if RWAL.Get(RWAL."Activity Type"::Pick, "No. Picking", "No. Linea Picking") then begin
                    "No. Producto" := RWAL."Item No.";
                    Cantidad := RWAL.Quantity;
                    "Cod. Unidad de Medida" := RWAL."Unit of Measure Code";
                    Descripcion := RWAL.Description;
                    RWAL.Validate("No. Packing", "No. Packing");
                    RWAL.Validate("No. Caja", "No. Caja");
                    RWAL.Validate("No. Linea Packing", "No. Linea");
                    RWAL.Modify(true);
                end;
            end;
        }
        field(11; "Peso Calculado"; Decimal)
        {
            Caption = 'Calculated weight';
        }
        field(12; "Peso de la Caja"; Decimal)
        {
            Caption = 'Calculated weight';
        }
        field(13; "Peso real"; Decimal)
        {
            Caption = 'Real weight';
        }
        field(14; Diferencia; Decimal)
        {
            Caption = 'Diference';
        }
        field(15; "Serie de etiquetas"; Code[20])
        {
            Caption = 'Tag Series';
        }
    }

    keys
    {
        key(Key1; "No. Packing", "No. Caja", "No. Picking", "No. Producto", "No. Linea")
        {
            Clustered = true;
        }
        key(Key2; "No. Producto", "No. Picking")
        {
            SumIndexFields = Cantidad;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if LinPack.Get("No. Packing", "No. Caja") then
            LinPack.TestField("Estado Caja", LinPack."Estado Caja"::Abierta);


        if RWAL.Get(RWAL."Activity Type"::Pick, "No. Picking", "No. Linea Picking") then begin
            RWAL.Validate("No. Packing", '');
            RWAL.Validate("No. Caja", '');
            RWAL.Validate("No. Linea Packing", 0);
            RWAL.Modify(true);
        end;
    end;

    trigger OnInsert()
    begin
        if LinPack.Get("No. Packing", "No. Caja") then
            LinPack.TestField("Estado Caja", LinPack."Estado Caja"::Abierta);
    end;

    trigger OnModify()
    begin
        if LinPack.Get("No. Packing", "No. Caja") then
            LinPack.TestField("Estado Caja", LinPack."Estado Caja"::Abierta);
    end;

    var
        Prod: Record Item;
        LinPack: Record "Lin. Packing";
        RWAL: Record "Registered Whse. Activity Line";
}

