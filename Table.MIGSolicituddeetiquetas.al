table 82517 "MIG Solicitud de etiquetas"
{
    Caption = 'Labels request';
    DrillDownPageID = "Subform Bancos tiendas";
    LookupPageID = "Subform Bancos tiendas";

    fields
    {
        field(1; "ID Reporte"; Integer)
        {
            Caption = 'Report ID';
            /*      TableRelation = Object.ID WHERE (Type = CONST (Report)); */
        }
        field(2; "Nombre reporte"; Text[200])
        {
            Caption = 'Report name';
        }
        field(3; Cantidad; Integer)
        {
            Caption = 'Quantity';
        }
        field(4; Usuario; Code[10])
        {
            Caption = 'User';
        }
        field(5; "Fecha solicitud"; Date)
        {
            Caption = 'Date';
        }
        field(6; "Cod. barra"; Code[30])
        {
            Caption = 'Barcode';

            trigger OnValidate()
            begin
                rItemCrossRef.Reset;
                rItemCrossRef.SetCurrentKey(rItemCrossRef."Reference No.");
                rItemCrossRef.SetRange("Reference No.", "Cod. barra");
                if rItemCrossRef.Find('-') then begin
                    rItem.Get(rItemCrossRef."Item No.");
                    "No. producto" := rItemCrossRef."Item No.";
                    "Descripcion producto" := rItem.Description
                end;
            end;
        }
        field(7; "No. producto"; Code[20])
        {
            Caption = 'Item no.';
            TableRelation = Item;

            trigger OnValidate()
            begin
                if rItem.Get("No. producto") then
                    "Descripcion producto" := rItem.Description;
            end;
        }
        field(8; "Descripcion producto"; Text[200])
        {
            Caption = 'Item description';
        }
        field(9; Confirmada; Boolean)
        {
            Caption = 'Confirmed';
        }
        field(10; "No. Linea"; Integer)
        {
            Caption = 'Line no.';
        }
    }

    keys
    {
        key(Key1; "ID Reporte", Usuario, "No. Linea")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Usuario := UserId;
    end;

    var
        rItemCrossRef: Record "Item Reference";
        rItem: Record Item;
}

