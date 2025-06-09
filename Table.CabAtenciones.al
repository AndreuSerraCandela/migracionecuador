table 76121 "Cab. Atenciones"
{
    Caption = 'Hospitality Header';

    fields
    {
        field(1; Codigo; Code[20])
        {
        }
        field(2; "Cod. Colegio"; Code[20])
        {
            NotBlank = true;
            TableRelation = Contact WHERE(Type = CONST(Company));

            trigger OnValidate()
            begin
                if Contact.Get("Cod. Colegio") then begin
                    "Nombre Colegio" := Contact.Name;
                    Address := Contact.Address;
                    "Address 2" := Contact."Address 2";
                    City := Contact.City;
                    "Territory Code" := Contact."Territory Code";
                    "Country/Region Code" := Contact."Country/Region Code";
                    "Post Code" := Contact."Post Code";
                    County := Contact.County;
                    //peru    Departamento              := Contact.Departamento;
                    //peru    Distritos                 := Contact.Distritos;
                    //peru    Provincia                 := Contact.Provincia;
                    //peru    Pais                      := Contact.Pais;
                    //peru    "Distribucion Geografica" := Contact."Distribucion Geografica";
                    //peru    "Codigo Postal"           := Contact."codigo postal";
                    "Cod. Nivel" := '';
                    Turno := '';
                end;
            end;
        }
        field(3; "Cod. Local"; Code[20])
        {
            TableRelation = "Contact Alt. Address".Code WHERE("Contact No." = FIELD("Cod. Colegio"));
        }
        field(4; "Cod. Nivel"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Colegio - Nivel"."Cod. Nivel" WHERE("Cod. Colegio" = FIELD("Cod. Colegio"));

            trigger OnValidate()
            begin
                /*Nivel.GET("Cod. Nivel");
                "Filtro Nivel" := Nivel."Filtros Combinaciones Niveles";
                 */

            end;
        }
        field(5; Turno; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST(Turnos));
        }
        field(6; "Fecha registro"; Date)
        {
            Caption = 'Posting date';
        }
        field(7; "Fecha de entrega"; Date)
        {
            Caption = 'Delivery date';
        }
        field(8; "Tipo documento"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST(Documentos));
        }
        field(9; "Document ID"; Text[20])
        {
            Caption = 'Document ID';

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
                /*IF "Document ID" <> '' THEN
                   BEGIN
                    Docente.RESET;
                    Docente.SETFILTER("No.",'<>%1',"No.");
                    Docente.SETRANGE("Tipo documento","Tipo documento");
                    Docente.SETRANGE("Document ID","Document ID");
                    IF Docente.FINDFIRST THEN
                       ERROR(Text034,FIELDCAPTION("Document ID"),"Document ID",TABLECAPTION,Docente."No.");
                   END;
                */

            end;
        }
        field(10; "Nombre Colegio"; Text[100])
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(11; Address; Text[100])
        {
            Caption = 'Address';
            Editable = false;
        }
        field(12; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
            Editable = false;
        }
        field(13; City; Text[30])
        {
            Caption = 'City';
            Editable = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(14; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            Editable = false;
            TableRelation = Territory;

            trigger OnValidate()
            var
                Territory: Record Territory;
            begin
            end;
        }
        field(15; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            Editable = false;
            TableRelation = "Country/Region";

            trigger OnValidate()
            var
                "Country/Region": Record "Country/Region";
            begin
                if Country.Get("Country/Region Code") then
                    Pais := Country.Name;
            end;
        }
        field(16; "Post Code"; Code[20])
        {
            Caption = 'ZIP Code';
            Editable = false;
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(17; County; Text[30])
        {
            Caption = 'State';
            Editable = false;

            trigger OnValidate()
            begin
                //IF territory.GET(County) THEN
                // Departamento :=territory.Name;
                if territory.Get(County) then
                    Departamento := territory.Name;

                Validate("Codigo Postal"); //APS
            end;
        }
        field(18; Departamento; Text[30])
        {
            Caption = 'District';
            Description = 'Peru';
            Editable = false;
            Enabled = false;
        }
        field(19; Distritos; Text[30])
        {
            Description = 'Peru';
            Editable = false;
            Enabled = false;
        }
        field(20; Provincia; Text[30])
        {
            Description = 'Peru';
            Editable = false;
            Enabled = false;
        }
        field(21; Pais; Text[30])
        {
            Description = 'Peru';
            Editable = false;
            Enabled = false;
        }
        field(22; Delegacion; Code[20])
        {
            TableRelation = "Dimension Value".Code;

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
                end;
            end;
        }
        field(23; "Distribucion Geografica"; Code[20])
        {
            Editable = false;
            TableRelation = "Dimension Value".Code;

            trigger OnLookup()
            begin
                ConfAPS.Get();
                ConfAPS.TestField(ConfAPS."Cod. Dimension Dist. Geo.");
                DimVal.Reset;
                DimVal.SetRange("Dimension Code", ConfAPS."Cod. Dimension Dist. Geo.");
                DimVal.SetRange("Dimension Value Type", DimVal."Dimension Value Type"::Standard);
                DimForm.SetTableView(DimVal);
                DimForm.SetRecord(DimVal);
                DimForm.LookupMode(true);
                if DimForm.RunModal = ACTION::LookupOK then begin
                    DimForm.GetRecord(DimVal);
                    "Distribucion Geografica" := DimVal.Code;
                end;

                Clear(DimForm);
            end;
        }
        field(24; "Codigo Postal"; Code[10])
        {
            Description = '//peru';
            Editable = false;

            trigger OnValidate()
            begin
                "Codigo Postal" := County + "Post Code" + City;
            end;
        }
        field(25; "Cod. Responsable"; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate()
            var
                rVendor: Record Vendor;
            begin
                if rVendor.Get("Cod. Responsable") then begin
                    "Nombre responsable" := rVendor.Name;
                end;
            end;
        }
        field(26; "Nombre responsable"; Text[60])
        {
        }
        field(27; "Tipo Evento"; Code[20])
        {
            Editable = false;
            TableRelation = "Tipos de Eventos";
        }
        field(28; "No. Solicitud"; Code[20])
        {
            TableRelation = "Solicitud de Taller - Evento"."No. Solicitud";

            trigger OnLookup()
            var
                rSol: Record "Solicitud de Taller - Evento";
                fSol: Page "Lista Solicitudes T&E";
            begin

                fSol.SetTableView(rSol);
                fSol.LookupMode(true);
                fSol.Editable(false);
                if fSol.RunModal = ACTION::LookupOK then begin
                    fSol.GetRecord(rSol);
                    "No. Solicitud" := rSol."No. Solicitud";
                    "Grupo de Negocio" := rSol."Grupo de Negocio";
                    "Tipo Evento" := rSol."Tipo de Evento";

                    Validate("Cod. Colegio", rSol."Cod. Colegio");
                    Validate("Cod. Responsable", rSol."Cod. promotor");
                end;
            end;

            trigger OnValidate()
            var
                rSol: Record "Solicitud de Taller - Evento";
            begin

                if rSol.Get("No. Solicitud") then begin
                    "No. Solicitud" := rSol."No. Solicitud";
                    "Grupo de Negocio" := rSol."Grupo de Negocio";
                    "Tipo Evento" := rSol."Tipo de Evento";

                    Validate("Cod. Colegio", rSol."Cod. Colegio");
                    Validate("Cod. Responsable", rSol."Cod. promotor");
                end;
            end;
        }
        field(29; Objetivo; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST(Objetivos));

            trigger OnValidate()
            var
                DA: Record "Datos auxiliares";
            begin


                if Objetivo <> '' then begin
                    DA.Reset;
                    DA.SetRange("Tipo registro", DA."Tipo registro"::Objetivos);
                    DA.SetRange(Codigo, Objetivo);
                    DA.FindFirst;
                    "Descripcion Objetivo" := DA.Descripcion;
                end;
            end;
        }
        field(30; "Area Responsable"; Option)
        {
            OptionCaption = 'Marketing,Ventas';
            OptionMembers = Marketing,Ventas;
        }
        field(31; "Grupo de Negocio"; Code[20])
        {
            Editable = false;
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST("Grupo de Negocio"));

            trigger OnLookup()
            var
                GpoNegocio: Page "Grupos de Negocio";
            begin
                DA.Reset;
                DA.SetRange("Tipo registro", DA."Tipo registro"::"Grupo de Negocio");
                GpoNegocio.SetTableView(DA);
                GpoNegocio.SetRecord(DA);
                GpoNegocio.LookupMode(true);
                if GpoNegocio.RunModal = ACTION::LookupOK then begin
                    GpoNegocio.GetRecord(DA);
                    Validate("Grupo de Negocio", DA.Codigo);
                end;
            end;
        }
        field(32; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(33; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(34; "No. Series"; Code[10])
        {
        }
        field(35; Estado; Option)
        {
            Editable = false;
            OptionCaption = 'Entregada,Realizada,Cancelada';
            OptionMembers = Entregada,Realizada,Cancelada;
        }
        field(36; "Id. Usuario"; Code[50])
        {
            Editable = false;
        }
        field(37; "Comentarios Entrega"; Text[250])
        {
        }
        field(38; "Comentarios Cancelación"; Text[250])
        {
        }
        field(39; Monto; Decimal)
        {
            CalcFormula = Sum("Detalle Atenciones"."Monto total" WHERE("Código Cab. Atención" = FIELD(Codigo)));
            FieldClass = FlowField;
        }
        field(40; Atenciones; Integer)
        {
            CalcFormula = Count("Detalle Atenciones" WHERE("Código Cab. Atención" = FIELD(Codigo)));
            FieldClass = FlowField;
        }
        field(41; "Fecha Recepción Documento"; Date)
        {
        }
        field(42; Documento; Code[20])
        {
        }
        field(43; "Descripcion Objetivo"; Text[100])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; Codigo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        error001: Label 'No se permite eliminar una atención realizada.';
        rDet: Record "Detalle Atenciones";
    begin
        if Estado = Estado::Realizada then
            Error(error001);

        rDet.SetRange("Código Cab. Atención", Codigo);
        rDet.DeleteAll;
    end;

    trigger OnInsert()
    var
        APSSetup: Record "Commercial Setup";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        if Codigo = '' then begin
            APSSetup.Get;
            APSSetup.TestField(APSSetup."No. Serie Atenciones");
            //NoSeriesMgt.InitSeries(APSSetup."No. Serie Atenciones", xRec."No. Series", 0D, Codigo, "No. Series");
            Rec."No. series" := APSSetup."No. Serie Atenciones";
            if NoSeriesMgt.AreRelated(APSSetup."No. Serie Atenciones", xRec."No. Series") then
                Rec."No. Series" := xRec."No. Series";
            Rec.Codigo := NoSeriesMgt.GetNextNo(Rec."No. Series");
        end;


        "Fecha registro" := Today;
        "Id. Usuario" := UserId;
    end;

    var
        ConfAPS: Record "Commercial Setup";
        Contact: Record Contact;
        territory: Record Territory;
        PostCode: Record "Post Code";
        Country: Record "Country/Region";
        DimVal: Record "Dimension Value";
        DA: Record "Datos auxiliares";
        PostCodeForm: Page "Post Codes";
        formTerritory: Page Territories;
        DimMgt: Codeunit DimensionManagement;
        DimForm: Page "Dimension Value List";


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        //DimMgt.SaveDefaultDim(DATABASE::Customer,"No.",FieldNumber,ShortcutDimCode);
        Modify;
    end;
}

