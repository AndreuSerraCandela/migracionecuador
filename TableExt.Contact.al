tableextension 50089 tableextension50089 extends Contact
{
    fields
    {
        modify(Name)
        {
            Description = '#56924';
        }
        modify("Search Name")
        {
            Description = '#56924';
        }
        modify(City)
        {
            Caption = 'City';
        }



        modify("No. of Business Relations")
        {
            Caption = 'No. of Business Relations';
        }

        //Pendiente En lugar del campo Pager (ocultar el campo y hacer visible el nuevo campo)
        field(50000; "Colegio Activo"; Option)
        {
            Caption = 'Active School';
            OptionMembers = "Yes","No";
            OptionCaption = 'Yes,No';
        }

        //Pendiente Se agrega la copia del campo para eliminar el onvalidate debe cambiarse en la pagina y metodos desde donde se ingrese información
        field(50001; "Phone No. 2"; Text[50])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }

        //Pendiente Se agrega la copia del campo para eliminar el onvalidate debe cambiarse en la pagina y metodos desde donde se ingrese información
        field(50002; "Mobile Phone No. 2"; Text[30])
        {
            Caption = 'Mobile Phone No.';
            ExtendedDatatype = PhoneNo;
        }

        field(50009; "Cod. Almacen"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'DS-POS';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(50013; Departamento; Text[30])
        {
            Caption = 'District';
            DataClassification = ToBeClassified;
            Description = 'Peru';
            Enabled = false;
        }
        field(50014; Distritos; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Peru';
            Enabled = false;
        }
        field(50015; Provincia; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Peru';
            Enabled = false;
        }
        field(50016; Pais; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Peru';
            Enabled = false;
        }
        field(50017; "Nombre Región"; Text[50])
        {
            CalcFormula = Lookup("Dimension Value".Name WHERE("Dimension Code" = CONST('REGION'),
                                                               "Dimension Value Type" = CONST(Standard),
                                                               Code = FIELD("Región")));
            FieldClass = FlowField;
        }
        field(51000; "Canal de compra"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(51001; "Nombre canal"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(51002; Microempresario; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Micro empresario";
        }
        field(51003; Comisionista; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Comisionistas;
        }
        field(51004; "Orden religiosa"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST("Orden religiosa"));
        }
        field(51005; "Asociacion Educativa"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST("Asociacion educativa"));
        }
        field(53000; "% Descuento Cupon"; Decimal)
        {
            Caption = 'Coupon Discount %';
            DataClassification = ToBeClassified;
        }
        field(53500; "Codigo Modular"; Code[20])
        {
            Caption = 'Modular Code';
            DataClassification = ToBeClassified;
            Description = 'Perú';
        }
        field(53501; "Colegio SIC"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'ITPV';
            Editable = false;
        }
        field(76012; "Tipo de colegio"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST("Tipos de colegios"));

            trigger OnLookup()
            begin
                DA.Reset;
                DA.SetRange("Tipo registro", DA."Tipo registro"::"Tipos de colegios");
                Tipocol.SetTableView(DA);
                Tipocol.SetRecord(DA);
                Tipocol.LookupMode(true);
                if Tipocol.RunModal = ACTION::LookupOK then begin
                    Tipocol.GetRecord(DA);
                    "Tipo de colegio" := DA.Codigo;
                end;

                Clear(Tipocol);
            end;
        }
        field(76034; "Tipo educacion"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST("Tipo de educacion"));
        }
        field(76014; "Fecha decision"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
        }
        field(76422; Periodo; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
        }
        field(76127; Bilingue; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
        }
        field(76357; Ruta; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
        }
        field(76230; Grupo; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
        }
        field(76101; Cargo; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST("Puestos de trabajo"));
        }
        field(76379; "Descripcion Cargo"; Text[100])
        {
            CalcFormula = Lookup("Datos auxiliares".Descripcion WHERE("Tipo registro" = CONST("Puestos de trabajo"),
                                                                       Codigo = FIELD(Cargo)));
            Description = 'APS';
            FieldClass = FlowField;
        }
        field(76380; Facebook; Text[150])
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
        }
        field(76417; "Fecha Aniversario"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
        }
        field(76291; "Pension INI"; Boolean)
        {
            Caption = 'Pensión Inicial';
            DataClassification = ToBeClassified;
            Description = 'APS';
        }
        field(76226; "Pension PRI"; Boolean)
        {
            Caption = 'Pensión Primaria';
            DataClassification = ToBeClassified;
            Description = 'APS';
        }
        field(76321; "Pension SEC"; Boolean)
        {
            Caption = 'Pensión Secundaria';
            DataClassification = ToBeClassified;
            Description = 'APS';
        }
        field(76322; "Pension BA"; Boolean)
        {
            Caption = 'Pensión Bachillerato';
            DataClassification = ToBeClassified;
            Description = 'APS';
        }
        field(76359; "Importe Pension INI"; Decimal)
        {
            Caption = 'Importe Pensión Inicial';
            DataClassification = ToBeClassified;
            Description = 'APS';
        }
        field(76106; "Importe Pension PRI"; Decimal)
        {
            Caption = 'Importe Pensión Primaria';
            DataClassification = ToBeClassified;
            Description = 'APS';
        }
        field(76225; "Importe Pension SEC"; Decimal)
        {
            Caption = 'Importe Pensión Secundaria';
            DataClassification = ToBeClassified;
            Description = 'APS';
        }
        field(76096; "Importe Pension BA"; Decimal)
        {
            Caption = 'Importe Bachillerato';
            DataClassification = ToBeClassified;
            Description = 'APS';
        }
        field(76097; "Región"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
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
                    Región := DimVal.Code;
                end;

                Clear(DimForm);
            end;
        }
        field(76086; Zona; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
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
                    Zona := DimVal.Code;
                end;

                Clear(DimForm);
            end;
        }
        field(76209; "Codigo Postal"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'APS';

            trigger OnValidate()
            begin
                //"Codigo Postal" := County + "Post Code" + City;
                "Tipo de colegio" := "Post Code";
            end;
        }
        field(76426; "Samples Location Code"; Code[20])
        {
            Caption = 'Location Code Samples';
            DataClassification = ToBeClassified;
            Description = 'APS';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
    }

    trigger OnBeforeInsert() //Validar que inserte el valor tambien puede agregarse en event suscriber OnBeforeOnInsert de esta tabla
    var
        myInt: Integer;
    begin
        ConfiSantillana.Get;
        if "Colegio SIC" = '' then begin
            "Colegio SIC" := NoSeriesManagement.GetNextNo(ConfiSantillana."Serie Colegio SIC", WorkDate, true);
        end;
    end;

    //[EventSubscriber(ObjectType::Table, Database::Contact, 'OnModifyOnBeforeInheritCommunicationDetails', '', false, false)] llevarlo a un Codeunit
    local procedure OnModifyOnBeforeInheritCommunicationDetails(RMSetup: Record "Marketing Setup"; Cont: Record Contact; var ContChanged: Boolean)
    begin
        if RMSetup."Inherit Communication Details" then
            if (xRec."Colegio Activo" <> "Colegio Activo") and (xRec."Colegio Activo" = Cont."Colegio Activo") then begin
                Cont."Colegio Activo" := "Colegio Activo";
                ContChanged := true;
            end;
    end;

    var
        DA: Record "Datos auxiliares";
        Tipocol: Page "Tipos de Colegios";
        ConfAPS: Record "Commercial Setup";
        DimVal: Record "Dimension Value";
        DimForm: Page "Dimension Value List";
        NoSeriesManagement: Codeunit "No. Series";
        ConfiSantillana: Record "Config. Empresa";
}

