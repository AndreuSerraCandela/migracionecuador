table 56022 "Cab. Hoja de Ruta Reg."
{
    Caption = 'Posted Route Sheet Header';
    DrillDownPageID = "Grupos de almacenes";
    LookupPageID = "Grupos de almacenes";

    fields
    {
        field(1; "No. Hoja Ruta"; Code[20])
        {
            Caption = 'Route Sheet No.';
        }
        field(2; "Cod. Transportista"; Code[20])
        {
            Caption = 'Carrier Code';
            TableRelation = "Shipping Agent";
        }
        field(3; "Fecha Planificacion Transporte"; Date)
        {
            Caption = 'Transportation Planning Date';
        }
        field(4; Comentario; Text[250])
        {
            Caption = 'Comment';
        }
        field(5; Hora; Time)
        {
            Caption = 'Time';
        }
        field(6; "Fecha Registro"; Date)
        {
            Caption = 'Posting date';
        }
        field(7; "No. Hoja Ruta Origen"; Code[20])
        {
            Caption = 'Route Sheet No. From';
        }
        field(8; Anulada; Boolean)
        {
            Caption = 'Voided';
        }
        field(9; "Nombre Transportista"; Text[100])
        {
            Caption = 'Transport Agent Name';
        }
        field(10; Chofer; Code[20])
        {
            TableRelation = "Choferes por Transportista"."Cod. Chofer" WHERE("Cod. Transportista" = FIELD("Cod. Transportista"));
        }
        field(11; "Nombre Chofer"; Text[100])
        {
        }
        field(12; Ayudantes; Text[100])
        {
            Caption = 'Ayudantes';
            Description = '#32014';
        }
        field(13; Zona; Code[20])
        {
            Caption = 'Zona';
            Description = '#32014';
        }
        field(15; "Cantidad de cajas"; Integer)
        {
            BlankZero = true;
            Description = '#51496';
            MinValue = 1;
            NotBlank = true;
        }
    }

    keys
    {
        key(Key1; "No. Hoja Ruta")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        SalesSetup.Get;
        "Fecha Planificacion Transporte" := WorkDate;
        if "No. Hoja Ruta" = '' then begin
            SalesSetup.Get;
            TestNoSeries;
            /*NoSeriesMgt.InitSeries(GetNoSeriesCode, "No. Hoja Ruta", WorkDate, "No. Hoja Ruta",
                                    SalesSetup."No. Serie Hoja de Ruta");*/
            if NoSeriesMgt.AreRelated(GetNoSeriesCode, Rec."No. Hoja Ruta") then
                SalesSetup."No. Serie Hoja de Ruta" := Rec."No. Hoja Ruta";
            Rec."No. Hoja Ruta" := NoSeriesMgt.GetNextNo(SalesSetup."No. Serie Hoja de Ruta");
        end;
    end;

    var
        NoSeriesMgt: Codeunit "No. Series";
        SalesSetup: Record "Sales & Receivables Setup";


    procedure TestNoSeries()
    begin
        SalesSetup.TestField("No. Serie Hoja de Ruta");
        SalesSetup.TestField("No. Serie Hoja de Ruta Reg.");
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        exit(SalesSetup."No. Serie Hoja de Ruta");
    end;
}

