table 50112 "Cab. Ventas SIC"
{
    // Proyecto: Implementacion Business Central
    // 
    // LDP: Luis Jose De La Cruz Paredes
    // ------------------------------------------------------------------------
    // No.      Fecha        Firma     Descripcion
    // ------------------------------------------------------------------------
    // 001      16/01/2024   LDP       SANTINAV-4730: Realizar notas de crédito desde cualquier caja DS-POS
    //                                     Se crean campos.
    // 002      24/01/2024   LDP       SANTINAV-4730: Se envía el documento sic de la factura relacionada.
    // 
    // 003      10/01/2025   LDP       SANTINAV-6949: Ramón colocó el dato correo en el campo observación.

    DrillDownPageID = "List Cab Vtas SIC";
    LookupPageID = "List Cab Vtas SIC";

    fields
    {
        field(1; "Tipo documento"; Integer)
        {
        }
        field(2; "No. documento"; Code[40])
        {
        }
        field(3; "Cod. Cliente"; Code[20])
        {
        }
        field(4; Fecha; Date)
        {
        }
        field(5; "Cod. Almacen"; Code[40])
        {
        }
        field(6; "Cod. Moneda"; Code[10])
        {
        }
        field(7; RNC; Code[15])
        {
        }
        field(8; "Nombre Cliente"; Text[200])
        {
        }
        field(9; "No. comprobante"; Code[40])
        {
        }
        field(10; "Fecha Venc. NCF"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "NCF Afectado"; Code[40])
        {
        }
        field(12; "Cod. Cajero"; Code[50])
        {
        }
        field(13; "Tasa de cambio"; Decimal)
        {
        }
        field(14; "Nombre asegurado"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "No. poliza"; Code[50])
        {
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-4730';
        }
        field(16; "No. orden"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(17; Aseguradora; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "RNC Aseguradora"; Code[15])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Cod. supervisor"; Text[60])
        {
            DataClassification = ToBeClassified;
        }
        field(20; Turno; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Source Counter"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(22; Transferido; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(23; Errores; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(24; ErroresLineas; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(25; Monto; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(26; ITBIS; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(27; SubTotal; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(28; Descuento; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(29; Observacion; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-6949';
        }
        field(30; Origen; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Punto de Venta,From Hotel';
            OptionMembers = " ","Punto de Venta","From Hotel";
        }
        field(31; Hora; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(32; Clave; Text[60])
        {
            DataClassification = ToBeClassified;
        }
        field(33; Consecutivo; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(34; Colegio; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(35; Caja; Code[5])
        {
            DataClassification = ToBeClassified;
        }
        field(36; Tienda; Code[200])
        {
            DataClassification = ToBeClassified;
        }
        field(37; "No. documento SIC"; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(38; Establecimiento; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(39; PuntoEmision; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Cod. Banco"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-4730';
        }
        field(41; "Serie Documento"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-4730';
        }
        field(42; "Id. TPV"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-4730';
        }
        field(43; "PuntoEmision Rel"; Code[5])
        {
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-4730';
            Enabled = false;
        }
        field(44; "Establecimiento Rel"; Code[5])
        {
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-4730';
            Enabled = false;
        }
    }

    keys
    {
        key(Key1; "Tipo documento", "No. documento", Caja, "No. documento SIC")
        {
            Clustered = true;
        }
        key(Key2; "No. orden")
        {
        }
        key(Key3; "No. poliza")
        {
        }
        key(Key4; "Fecha Venc. NCF")
        {
        }
        key(Key5; "No. documento", "Cod. supervisor")
        {
        }
        key(Key6; Transferido, Fecha)
        {
        }
    }

    fieldgroups
    {
    }
}

