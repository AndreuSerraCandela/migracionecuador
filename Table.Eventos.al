table 76291 Eventos
{
    DrillDownPageID = "Lista Eventos";
    LookupPageID = "Lista Eventos";

    fields
    {
        field(1; "Tipo de Evento"; Code[20])
        {
            TableRelation = "Tipos de Eventos";

            trigger OnValidate()
            begin
                if TipoEvento.Get("Tipo de Evento") then
                    "Descripcion Tipo Evento" := TipoEvento.Descripcion;
            end;
        }
        field(2; "No."; Code[20])
        {
        }
        field(3; Descripcion; Text[100])
        {
        }
        field(4; Delegacion; Code[20])
        {
            Caption = 'Responsibility Center';

            trigger OnLookup()
            begin
                ConfAPS.Get();
                ConfAPS.TestField(ConfAPS."Cod. Dimension Delegacion");

                DimVal.Reset;
                DimVal.SetRange("Dimension Code", ConfAPS."Cod. Dimension Delegacion");
                DimVal.SetRange("Dimension Value Type", DimVal."Dimension Value Type"::Standard);
                DimForm.SetTableView(DimVal);
                DimForm.SetRecord(DimVal);
                DimForm.LookupMode(true);
                if DimForm.RunModal = ACTION::LookupOK then begin
                    DimForm.GetRecord(DimVal);
                    Validate(Delegacion, DimVal.Code);
                end;

                Clear(DimForm);
            end;

            trigger OnValidate()
            begin
                ConfAPS.Get();
                ConfAPS.TestField(ConfAPS."Cod. Dimension Delegacion");

                if Delegacion <> '' then begin
                    DimVal.Reset;
                    DimVal.SetRange("Dimension Code", ConfAPS."Cod. Dimension Delegacion");
                    DimVal.SetRange("Dimension Value Type", DimVal."Dimension Value Type"::Standard);
                    DimVal.SetRange(Code, Delegacion);
                    DimVal.FindFirst;
                    "Descripcion Delegacion" := DimVal.Name;
                end;
            end;
        }
        field(5; Categoria; Code[20])
        {
            Enabled = false;
        }
        field(6; "Cod. Nivel"; Code[20])
        {
            TableRelation = "Nivel Educativo APS";
        }
        field(7; Expositores; Integer)
        {
            Enabled = false;
            TableRelation = "Expositores APS";
        }
        field(8; Sala; Code[10])
        {
            Enabled = false;
        }
        field(9; "Fecha creacion"; Date)
        {
            Caption = 'Creation Date';
        }
        field(10; "Horas programadas"; Decimal)
        {
        }
        field(11; "Capacidad de vacantes"; Integer)
        {
        }
        field(12; "Eventos programados"; Integer)
        {
            Enabled = false;
        }
        field(13; "Importe Gasto Expositor"; Decimal)
        {
            Enabled = false;
        }
        field(14; "Importe Gasto mensajeria"; Decimal)
        {
            Enabled = false;
        }
        field(15; "ImporteGastos Impresion"; Decimal)
        {
            Enabled = false;
        }
        field(16; "Importe Utiles"; Decimal)
        {
            Enabled = false;
        }
        field(17; "Importe Atenciones"; Decimal)
        {
            Enabled = false;
        }
        field(18; "Otros Importes"; Decimal)
        {
            Enabled = false;
        }
        field(19; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(20; "Descripcion Delegacion"; Text[60])
        {
            Caption = 'Descripción Delegación';
        }
        field(21; "Descripcion Tipo Evento"; Text[60])
        {
            Caption = 'Descripción Tipo Evento';
        }
    }

    keys
    {
        key(Key1; "Tipo de Evento", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Tipo de Evento", "No.", Descripcion, Expositores)
        {
        }
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            ConfAPS.Get;
            ConfAPS.TestField("No. Serie Eventos");
            //NoSeriesMgt.InitSeries(ConfAPS."No. Serie Eventos", xRec."No. Series", 0D, "No.", "No. Series");
            Rec."No. series" := ConfAPS."No. Serie Eventos";
            if NoSeriesMgt.AreRelated(ConfAPS."No. Serie Eventos", xRec."No. Series") then
                Rec."No. Series" := xRec."No. Series";
            Rec."No." := NoSeriesMgt.GetNextNo(Rec."No. Series");
        end;

        "Fecha creacion" := Today;
    end;

    var
        Evento: Record Eventos;
        TipoEvento: Record "Tipos de Eventos";
        NoSeriesMgt: Codeunit "No. Series";
        DA: Record "Datos auxiliares";
        ConfAPS: Record "Commercial Setup";
        DimVal: Record "Dimension Value";
        DimForm: Page "Dimension Value List";


    procedure AssistEdit(OldEvent: Record Eventos): Boolean
    var
        WorkShop: Record Talleres;
    begin
        Evento := Rec;
        ConfAPS.Get;
        ConfAPS.TestField("No. Serie Profesores");
        if NoSeriesMgt.LookupRelatedNoSeries(ConfAPS."No. Serie Eventos", OldEvent."No. Series", Evento."No. Series") then begin
            ConfAPS.Get;
            ConfAPS.TestField("No. Serie Eventos");
            NoSeriesMgt.GetNextNo(Evento."No.");
            Rec := Evento;
            exit(true);
        end;
    end;
}

