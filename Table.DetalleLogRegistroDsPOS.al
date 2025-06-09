table 76023 "Detalle Log Registro DsPOS"
{
    // #126073, RRT, 22.04.2018: También se auditará la firma (generación del certificado digital).
    // #348662 25.11.2020  RRT: Actualizar DS-POS para ajustar a version 43c. Redenominar tambien campos con caracteres conflictivos.


    fields
    {
        field(1; "No. Log"; Integer)
        {
        }
        field(2; "No. Linea"; Integer)
        {
        }
        field(3; Texto; Text[250])
        {
        }
        field(4; Error; Boolean)
        {
        }
        field(5; "Tipo Documento"; Option)
        {
            OptionMembers = ,Factura,"Nota Credito";
        }
        field(6; Registrado; Boolean)
        {
        }
        field(7; Liquidado; Boolean)
        {
        }
        field(8; "No. Documento"; Code[40])
        {
            Description = 'Por las facturas Fiscales de LATAM';
        }
        field(9; "Fecha Documento"; Date)
        {
        }
        field(10; Tienda; Code[20])
        {
            TableRelation = Tiendas;
        }
        field(11; TPV; Code[20])
        {
            TableRelation = "Configuracion TPV"."Id TPV";
        }
        field(12; Firmado; Boolean)
        {
            Description = '#126073';
        }
        field(20; "No. documento NAV"; Code[20])
        {
            Caption = 'Nº documento Navision';
        }
    }

    keys
    {
        key(Key1; "No. Log", "No. Linea")
        {
            Clustered = true;
        }
        key(Key2; "Fecha Documento", Tienda, TPV, "No. Documento", "No. Linea")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        rLin: Record "Detalle Log Registro DsPOS";
    begin

        rLin.Reset;
        rLin.SetRange("No. Log", "No. Log");
        if rLin.FindLast then
            "No. Linea" := rLin."No. Linea" + 1
        else
            "No. Linea" := 1;
    end;
}

