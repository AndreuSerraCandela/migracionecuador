table 56020 "Cab. Hoja de Ruta"
{
    Caption = 'Route Sheet';
    DrillDownPageID = "BackOrders Sin Disp. Transfer.";
    LookupPageID = "BackOrders Sin Disp. Transfer.";

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

            trigger OnValidate()
            var
                recTransportista: Record "Shipping Agent";
            begin
                if recTransportista.Get("Cod. Transportista") then
                    "Nombre Chofer" := recTransportista.Name;
            end;
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

            trigger OnValidate()
            begin
                /*IF Cho.GET(Chofer) THEN
                  "Nombre Chofer" := Cho.Nombre
                ELSE
                  "Nombre Chofer" := '';   */

            end;
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
        field(14; Almacen; Option)
        {
            Caption = 'Almacen';
            Description = '#34387';
            OptionMembers = " ",Guayaquil,Quito;
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

    trigger OnDelete()
    begin
        LHR.Reset;
        LHR.SetRange("No. Hoja Ruta", "No. Hoja Ruta");
        LHR.DeleteAll;
    end;

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
        LHR: Record "Lin. Hoja de Ruta";
        ShipAg: Record "Shipping Agent";
        Cho: Record Choferes;


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

