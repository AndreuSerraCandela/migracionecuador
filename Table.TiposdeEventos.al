table 76417 "Tipos de Eventos"
{
    DrillDownPageID = "Tipos de Eventos";
    LookupPageID = "Tipos de Eventos";

    fields
    {
        field(1; Codigo; Code[20])
        {
        }
        field(2; Descripcion; Text[100])
        {
        }
        field(3; Cantidad; Integer)
        {
        }
        field(4; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(5; "Ingresar grados"; Boolean)
        {
        }
        field(6; "Ingresar libros a presentar"; Boolean)
        {
        }
        field(7; Seleccionar; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; Codigo)
        {
            Clustered = true;
        }
        key(Key2; Descripcion)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Codigo, Descripcion)
        {
        }
    }

    var
        DimMgt: Codeunit DimensionManagement;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        //DimMgt.SaveDefaultDim(DATABASE::Customer,"No.",FieldNumber,ShortcutDimCode);
        //MODIFY;
    end;
}

