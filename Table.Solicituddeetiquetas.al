table 76051 "Solicitud de etiquetas"
{
    Caption = 'Labels request';
    DrillDownPageID = "Subform Bancos tiendas";
    LookupPageID = "Subform Bancos tiendas";

    fields
    {
        field(76046; "ID Reporte"; Integer)
        {
            Caption = 'Report ID';
            Description = 'DsPOS Standar';
            /*           TableRelation = Object.ID WHERE (Type = CONST (Report)); */
        }
        field(76029; Usuario; Code[20])
        {
            Caption = 'User';
            Description = 'DsPOS Standar';
        }
        field(76011; "No. Linea"; Integer)
        {
            Caption = 'Line no.';
            Description = 'DsPOS Standar';
        }
        field(76016; "Nombre reporte"; Text[200])
        {
            Caption = 'Report name';
            Description = 'DsPOS Standar';
        }
        field(76018; Cantidad; Integer)
        {
            Caption = 'Quantity';
            Description = 'DsPOS Standar';
        }
        field(76015; "Fecha solicitud"; Date)
        {
            Caption = 'Date';
            Description = 'DsPOS Standar';
        }
        field(76026; "Cod. barra"; Code[30])
        {
            Caption = 'Barcode';
            Description = 'DsPOS Standar';

            trigger OnValidate()
            var
                rItemCrossRef: Record "Item Reference";
                rItem: Record Item;
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
        field(76020; "No. producto"; Code[20])
        {
            Caption = 'Item no.';
            Description = 'DsPOS Standar';
            TableRelation = Item;

            trigger OnValidate()
            var
                rItem: Record Item;
            begin
                if rItem.Get("No. producto") then
                    "Descripcion producto" := rItem.Description;
            end;
        }
        field(76022; "Descripcion producto"; Text[200])
        {
            Caption = 'Item description';
            Description = 'DsPOS Standar';
        }
        field(76027; Confirmada; Boolean)
        {
            Caption = 'Confirmed';
            Description = 'DsPOS Standar';
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
}

