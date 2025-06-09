table 76413 "TMP Reportes APS"
{

    fields
    {
        field(1; "No. Movimiento"; Integer)
        {
        }
        field(2; "Cod. Editorial"; Code[20])
        {
            NotBlank = true;
            TableRelation = Editoras;
        }
        field(3; "Cod. Colegio"; Code[20])
        {
            NotBlank = true;
            TableRelation = Contact WHERE (Type = CONST (Company));
        }
        field(4; "Cod. Local"; Code[20])
        {
            TableRelation = "Contact Alt. Address".Code WHERE ("Contact No." = FIELD ("Cod. Colegio"));
        }
        field(5; "Cod. Nivel"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Colegio - Nivel"."Cod. Nivel" WHERE ("Cod. Colegio" = FIELD ("Cod. Colegio"));
        }
        field(6; "Cod. Grado"; Code[20])
        {
            NotBlank = true;
        }
        field(7; "Cod. Turno"; Code[20])
        {
        }
        field(8; "Cod. Promotor"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser" WHERE (Tipo = CONST (Vendedor));
        }
        field(9; "Cod. Producto"; Code[20])
        {
            NotBlank = true;
            TableRelation = Item;
        }
        field(10; "Grupo de negocio"; Code[20])
        {
        }
        field(11; "Linea de negocio"; Code[20])
        {
        }
        field(12; Familia; Code[20])
        {
        }
        field(13; "Sub Familia"; Code[20])
        {
        }
        field(14; Serie; Code[20])
        {
        }
        field(15; "Cantidad Alumnos"; Decimal)
        {
            Caption = '2INI';
            DecimalPlaces = 0 : 0;
        }
        field(16; Adopcion; Option)
        {
            Caption = '2INI';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(17; "Cant. Presupuestada"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "No. Movimiento")
        {
            Clustered = true;
        }
        key(Key2; "Cod. Colegio", "Grupo de negocio", "Cod. Grado", "Cod. Turno", "Cod. Promotor", "Cod. Producto")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Promotor: Record "Salesperson/Purchaser";
        date: Record Date;
        fFechas: Page Fechas;
}

