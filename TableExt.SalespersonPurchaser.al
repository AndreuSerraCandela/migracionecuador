tableextension 50018 tableextension50018 extends "Salesperson/Purchaser"
{
    fields
    {
        modify("Global Dimension 1 Code")
        {
            Caption = 'Global Dimension 1 Code';
        }
        modify("Global Dimension 2 Code")
        {
            Caption = 'Global Dimension 2 Code';
        }

        //Unsupported feature: Code Modification on ""E-Mail"(Field 5052).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if ("Search E-Mail" = UpperCase(xRec."E-Mail")) or ("Search E-Mail" = '') then
          "Search E-Mail" := "E-Mail";
        MailManagement.ValidateEmailAddressField("E-Mail");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        if ("Search E-Mail" = UpperCase(xRec."E-Mail")) or ("Search E-Mail" = '') then
          "Search E-Mail" := "E-Mail";

        //+
        if "E-Mail" <> xRec."E-Mail" then
          "E-Mail 2" := "E-Mail";
        //-

        MailManagement.ValidateEmailAddressField("E-Mail");
        */
        //end;
        field(50000; "No. serie Talonario"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50001; "No vendedor SIC"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'SIC-JERM';
        }
        field(50002; Collector; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'SIC-JERM';
        }
        field(62000; "Home Page"; Text[150])
        {
            Caption = 'Home page';
            DataClassification = ToBeClassified;
            Description = 'APS';
            ExtendedDatatype = URL;
        }
        field(62001; Twitter; Text[30])
        {
            Caption = 'Twitter';
            DataClassification = ToBeClassified;
            Description = 'APS';
            ExtendedDatatype = URL;
        }
        field(62002; Facebook; Text[150])
        {
            Caption = 'Facebook';
            DataClassification = ToBeClassified;
            Description = 'APS';
            ExtendedDatatype = URL;
        }
        field(62003; "BB Pin"; Code[10])
        {
            Caption = 'BB Pin';
            DataClassification = ToBeClassified;
            Description = 'APS';
        }
        field(62004; Vehicle; Code[20])
        {
            Caption = 'Vehicle';
            DataClassification = ToBeClassified;
            Description = 'APS';
        }
        field(62005; Tipo; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
            OptionCaption = 'Sales Person,Collector,Superviser';
            OptionMembers = Vendedor,Cobrador,Supervisor;
        }
        field(62006; Ruta; Code[20])
        {
            CalcFormula = Lookup("Promotor - Rutas"."Cod. Ruta" WHERE("Cod. Promotor" = FIELD(Code)));
            FieldClass = FlowField;
        }
        field(76012; "Sample Location code"; Code[20])
        {
            Caption = 'Sample Location Code';
            DataClassification = ToBeClassified;
            Description = 'APS';
            TableRelation = Location;
        }
        field(76034; Status; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
            OptionCaption = ' ,Inactive';
            OptionMembers = " ","Inactivo ";

            trigger OnValidate()
            begin
                if Status = 1 then
                    CheckTrans;
            end;
        }
    }


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    Validate(Code);
    DimMgt.UpdateDefaultDim(
      DATABASE::"Salesperson/Purchaser",Code,
      "Global Dimension 1 Code","Global Dimension 2 Code");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..4

    //001+
    ConfSantillana.Get;
    if "No vendedor SIC" = '' then begin
      "No vendedor SIC":=NoSeriesManagement.GetNextNo(ConfSantillana."Serie Vendedor SIC",WorkDate,true);
    end;
    //001-
    */
    //end;

    procedure CheckTrans()
    var
        PptoVtas: Record "Promotor - Ppto Vtas";
        PptoMuestras: Record "Promotor - Ppto Muestras";
        Adopciones: Record "Colegio - Adopciones Detalle";
    begin
        PptoVtas.Reset;
        PptoVtas.SetRange("Cod. Promotor", Code);
        if PptoVtas.FindFirst then
            Error(Err001);

        PptoMuestras.Reset;
        PptoMuestras.SetRange("Cod. Promotor", Code);
        if PptoMuestras.FindFirst then
            Error(Err001);

        Adopciones.Reset;
        Adopciones.SetRange("Cod. Promotor", Code);
        if Adopciones.FindFirst then
            Error(Err002);
    end;

    //>>>> MODIFIED VALUE:
    //CannotDeleteBecauseActiveOpportunitiesErr : @@@="%1 = Salesperson/Purchaser code.";ENU=You cannot delete the salesperson/purchaser with code %1 because it has open opportunities.;ESM=No se puede eliminar el comercial o el comprador con el código %1, ya que tiene oportunidades pendientes.;FRC=Vous ne pouvez pas supprimer le représentant/l'acheteur portant le code %1, car il a des opportunités ouvertes.;ENC=You cannot delete the salesperson/purchaser with code %1 because it has open opportunities.;
    //Variable type has not been exported.

    var
        Err001: Label 'You cannot delete or inactivate this salesperson because there are Budgets associated with he/she';
        Err002: Label 'You cannot delete or inactivate this salesperson because there are Adoptions associated with he/she';
        ConfSantillana: Record "Config. Empresa";
}

