table 76200 "Empresas Cotizacion"
{
    Caption = 'Company';
    DrillDownPageID = "Lista Empresas de cotización";
    LookupPageID = "Lista Empresas de cotización";

    fields
    {
        field(1; "Empresa cotizacion"; Code[10])
        {
            Caption = 'Company';
            NotBlank = true;
        }
        field(2; "Nombre Empresa cotizacinn"; Text[50])
        {
            Caption = 'Company name';
        }
        field(3; Direccion; Text[100])
        {
            Caption = 'Address';
            InitValue = 'CL';
        }
        field(4; Numero; Text[4])
        {
            Caption = 'Number';
        }
        field(5; "Codigo Postal"; Code[20])
        {
            Caption = 'Post code';
            TableRelation = "Post Code";

            trigger OnValidate()
            begin
                if Cpostal.Get("Codigo Postal") then begin
                    //GRN  Municipio := Cpostal."County Code";
                    Provincia := Cpostal."Search City";
                end;
            end;
        }
        field(6; Municipio; Text[50])
        {
            Caption = 'City';
        }
        field(7; Provincia; Text[30])
        {
        }
        field(8; "Teléfono"; Text[30])
        {
        }
        field(9; "Domicilio fiscal"; Boolean)
        {
            Description = 'Indica si el domicilio de la unidad de cotización es, a su vez, el domicilio a efectos de presentación de documentos fiscales';
        }
        field(10; Imagen; BLOB)
        {
            SubType = Bitmap;
        }
        field(11; "Cód. país"; Code[10])
        {
            Description = 'Código de país para personas físicas extranjeras';
            TableRelation = "Country/Region";
        }
        field(12; "Tipo de documento"; Option)
        {
            Description = 'RNC,Cédula,Pasaporte,Otro';
            OptionMembers = "Cédula",Pasaporte;
        }
        field(13; "RNC/CED"; Text[15])
        {
            Caption = 'Document ID';
        }
        field(14; "Grupo contable"; Code[10])
        {
            TableRelation = "Distribucion Importes TSS";
        }
        field(15; "Esquema percepción"; Code[10])
        {
            TableRelation = "Tipos de acciones personal";
        }
        field(16; Banco; Code[20])
        {
            TableRelation = Bancos;
        }
        field(17; Cuenta; Text[20])
        {
            CharAllowed = '09';
        }
        field(18; "Forma de Pago"; Option)
        {
            Description = '  ,Efectivo,Cheque,Transferencia Banco';
            OptionMembers = "  ",Efectivo,Cheque,"Transferencia Banc.";
        }
        field(19; "ID  Volante Pago"; Integer)
        {
            Caption = 'Payslip ID';
            Description = 'Oficial,Oficial abrev.,Factura,Matriz';
            /*         TableRelation = Object.ID WHERE(Type = CONST(Report)); */
        }
        field(20; Comentario; Boolean)
        {
            CalcFormula = Exist("Comentarios nómina" WHERE(Tipo = CONST("Empresa cotización"),
                                                            Codigo = FIELD("Empresa cotizacion")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(22; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(23; "Ult. No. Contabilización"; Code[10])
        {
        }
        field(24; Fax; Text[30])
        {
        }
        field(25; "E-Mail"; Text[60])
        {
        }
        field(26; "ID RNL"; Text[16])
        {
        }
        field(27; "ID TSS"; Code[16])
        {
        }
        field(28; "Tipo Empresa de Trabajo"; Option)
        {
            Description = 'General,Hotel,Zona Franca,Agrícola';
            OptionMembers = General,Hotel,"Zona Franca";
        }
        field(29; "Tipo Pago Nomina"; Option)
        {
            Caption = 'Payroll payment type';
            OptionCaption = 'Daily,Weekly,Bi-Weekly,Half Month,Monthly,Yearly';
            OptionMembers = Diaria,Semanal,"Bi-Semanal",Quincenal,Mensual,Anual;
        }
        field(30; "Tasa de Riesgo (%)"; Decimal)
        {
        }
        field(31; "Salario Mínimo TSS"; Decimal)
        {
            Caption = 'Minimun Salary TSS';
        }
        field(32; "Employer Identification Number"; Code[9])
        {
            Description = 'Para Puerto Rico';
        }
        field(33; "Identificador Empresa"; Code[5])
        {
        }
        field(34; "Path archivo Nomina"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Empresa cotizacion")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        /*
        ConfigEmpresa.SETRANGE(Descripción,COMPANYNAME);
        IF ConfigEmpresa.FIND('-') THEN
           BEGIN
            "ID TSS" := ConfigEmpresa."RNC/CED";
            "Nombre Empresa cotización" := ConfigEmpresa.Descripción;
           END
        ELSE
          ERROR('Antes debe haber configurado la empresa');
        */
        CentroTrab.Init;
        CentroTrab."Empresa cotización" := "Empresa cotizacion";
        CentroTrab."Centro de trabajo" := '001';
        ok := CentroTrab.Insert;

    end;

    trigger OnModify()
    begin
        if not Confirm(Text001) then
            Rec := xRec;
    end;

    var
        ok: Boolean;
        Cpostal: Record "Post Code";
        numafiliac: Code[10];
        dcafiliac: Code[2];
        numero: Decimal;
        result: Decimal;
        CentroTrab: Record "Centros de Trabajo";
        DimMgt: Codeunit DimensionManagement;
        Text001: Label 'Do you wish to save changes?';


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::"Empresas Cotizacion", "Empresa cotizacion", FieldNumber, ShortcutDimCode);
        Modify;
    end;


    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::"Empresas Cotizacion", "Empresa cotizacion", FieldNumber, ShortcutDimCode);
    end;


    procedure SpecialRelation("Nº de campo": Integer)
    begin
    end;


    procedure Domicilio() DomicilioUdad: Text[50]
    begin
        if Direccion <> '' then
            DomicilioUdad := CopyStr(StrSubstNo('%1 ', Direccion) + Format(Numero), 1, 50);
        if "Codigo Postal" <> '' then
            DomicilioUdad := CopyStr(DomicilioUdad + ', ' + "Codigo Postal", 1, 50);
        if Municipio <> '' then
            DomicilioUdad := CopyStr(DomicilioUdad + ' Esc. ' + Municipio, 1, 50);
        if Provincia <> '' then
            DomicilioUdad := CopyStr(DomicilioUdad + ' ' + Provincia + 'º', 1, 50);
        if Teléfono <> '' then
            DomicilioUdad := CopyStr(DomicilioUdad + ' ' + Teléfono + 'ª', 1, 50);
    end;
}

