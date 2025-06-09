table 76380 "Rutas - CP"
{
    DrillDownPageID = "Rutas - Distribucion Geo.";
    LookupPageID = "Rutas - Distribucion Geo.";

    fields
    {
        field(1; "Cod. Ruta"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST(Rutas));

            trigger OnValidate()
            begin
                DA.Reset;
                DA.SetRange("Tipo registro", DA."Tipo registro"::Rutas);
                DA.SetRange(Codigo, "Cod. Ruta");
                DA.FindFirst;

                "Name of route" := DA.Descripcion;
            end;
        }
        field(3; Description; Text[100])
        {
            Editable = false;
            Enabled = false;
        }
        field(4; "Name of route"; Text[100])
        {
            Caption = 'Name of Route';
        }
        field(5; "Cod. Dim. Delegacion"; Code[20])
        {
            Enabled = false;

            trigger OnValidate()
            var
                PostCode: Record "Post Code";
            begin
            end;
        }
        field(6; City; Text[30])
        {
            Caption = 'City';

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(7; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            Enabled = false;
            TableRelation = Territory;

            trigger OnValidate()
            var
                Territory: Record Territory;
            begin
            end;
        }
        field(8; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";

            trigger OnValidate()
            var
                "Country/Region": Record "Country/Region";
            begin
            end;
        }
        field(9; "Post Code"; Code[20])
        {
            Caption = 'ZIP Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(10; County; Text[30])
        {
            Caption = 'State';
        }
    }

    keys
    {
        key(Key1; "Cod. Ruta", "Post Code")
        {
            Clustered = true;
        }
        key(Key2; "Post Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Cod. Ruta", "Name of route")
        {
        }
    }

    trigger OnInsert()
    begin
        ConfAPS.Get();
        ConfAPS.TestField(ConfAPS."Cod. Dimension Delegacion");
        DimVal."Dimension Code" := ConfAPS."Cod. Dimension Delegacion";
    end;

    var
        DA: Record "Datos auxiliares";
        PostCodeRec: Record "Post Code";
        Colegio: Record Contact;
        PromRutas: Record "Promotor - Rutas";
        PLC: Record "Promotor - Lista de Colegios";
        Rutas: Page Rutas;
        ConfAPS: Record "Commercial Setup";
        DimVal: Record "Dimension Value";
        DimForm: Page "Dimension Value List";
        PostCodeForm: Page "Post Codes";
        formTerritory: Page Territories;
        RECcOUNTRY: Record "Country/Region";
        territory: Record Territory;
        PostCode: Record "Post Code";


    procedure AsignarColegios()
    begin
        //Asigno los Colegios que pertenecen al Codigo Postal
        Colegio.Reset;
        Colegio.SetCurrentKey("Post Code");
        Colegio.SetRange("Post Code", "Post Code");
        if Colegio.FindSet then
            repeat
                PromRutas.Reset;
                PromRutas.SetRange("Cod. Ruta", "Cod. Ruta");
                if PromRutas.FindSet then
                    repeat
                        PLC.Init;
                        PLC.Validate("Cod. Promotor", PromRutas."Cod. Promotor");
                        PLC.Validate("Cod. Ruta", "Cod. Ruta");
                        PLC.Validate("Cod. Colegio", Colegio."No.");
                        if PLC.Insert(true) then;
                    until PromRutas.Next = 0;
            until Colegio.Next = 0;
    end;
}

