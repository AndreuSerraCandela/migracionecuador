tableextension 50032 tableextension50032 extends Vendor
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Address 2"(Field 6)".


        //Unsupported feature: Property Modification (Data type) on "City(Field 7)".


        //Unsupported feature: Property Modification (Data type) on ""Phone No."(Field 9)".


        //Unsupported feature: Property Modification (Data type) on ""Telex No."(Field 10)".

        modify("Global Dimension 1 Code")
        {
            Caption = 'Global Dimension 1 Code';
        }
        modify("Global Dimension 2 Code")
        {
            Caption = 'Global Dimension 2 Code';
        }
        modify("Fin. Charge Terms Code")
        {
            Caption = 'Fin. Charge Terms Code';
        }
        modify(Blocked)
        {
            Description = 'CampReq1.01';
        }
        modify("VAT Registration No.")
        {

            //Unsupported feature: Property Modification (Data type) on ""VAT Registration No."(Field 86)".

            Caption = 'Tax Registration No.';
        }
        modify("Gen. Bus. Posting Group")
        {
            Caption = 'Gen. Bus. Posting Group';
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'VAT Bus. Posting Group';
        }

        //Unsupported feature: Property Insertion (Enabled) on ""No. of Pstd. Return Shipments"(Field 7179)".

        modify("No. of Pstd. Credit Memos")
        {
            Caption = 'No. of Pstd. Credit Memos';
        }
        modify("Pay-to No. of Blanket Orders")
        {
            Caption = 'Pay-to No. of Blanket Orders';
        }
        modify("Validate EU Vat Reg. No.")
        {
            Caption = 'Validate EU Tax Reg. No.';
        }

        //Unsupported feature: Code Insertion (VariableCollection) on "Blocked(Field 39).OnValidate".

        //trigger (Variable: UserSetup)()
        //Parameters and return type have not been exported.
        //begin
        /*
        */
        //end;


        //Unsupported feature: Code Modification on "Blocked(Field 39).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if (Blocked <> Blocked::All) and "Privacy Blocked" then
          if GuiAllowed then
            if Confirm(ConfirmBlockedPrivacyBlockedQst) then
              "Privacy Blocked" := false
            else
              Error('')
          else
            Error(CanNotChangeBlockedDueToPrivacyBlockedErr);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..8

        //001
        if UserSetup.Get(UserId) then
          begin
            if not UserSetup."Desbloquea Proveedores" then
              Error(Error001);
            if Blocked = Blocked::" " then
              begin
                ValidaCampos.Maestros(23,"No.");
                ValidaCampos.Dimensiones(23,"No.",0,0);
              end;

            if not "Proveedor Ocasional" then
              begin
                VBA.Reset;
                VBA.SetRange("Vendor No.","No.");
                if not VBA.FindFirst then
                  Error(Error002);
              end;
          end
        else
          Error(Error001);
        //001
        */
        //end;


        //Unsupported feature: Code Insertion (VariableCollection) on ""VAT Registration No."(Field 86).OnValidate".

        //trigger (Variable: ConsultaRNC)()
        //Parameters and return type have not been exported.
        //begin
        /*
        */
        //end;


        //Unsupported feature: Code Modification on ""VAT Registration No."(Field 86).OnValidate".

        //trigger "(Field 86)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        "VAT Registration No." := UpperCase("VAT Registration No.");
        if "VAT Registration No." <> xRec."VAT Registration No." then
          VATRegistrationValidation;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*

        //+#22846
        if  "VAT Registration No." <> '' then begin
          rVendor.SetRange("VAT Registration No.","VAT Registration No.");
          rVendor.SetFilter("No.",'<>%1',"No.");
          if rVendor.FindSet then
            Error(StrSubstNo(Err001,rVendor."No."));
        end;
        //-#22846

        if "Tipo Ruc/Cedula" = "Tipo Ruc/Cedula"::PASAPORTE then
          exit;

        //VATRegNoFormat.Test_Santillana("VAT Registration No.","Country/Region Code","No.",DATABASE::Vendor);  //#16454
        //VATRegNoFormat.Test("VAT Registration No.","Country/Region Code","No.",DATABASE::Vendor);

        if "Tipo Ruc/Cedula" <> "Tipo Ruc/Cedula"::"R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA" then
          VATRegNoFormat.Test_Santillana("VAT Registration No.","Country/Region Code","No.",DATABASE::Vendor);  //#16454

        {
        "VAT Registration No." := UPPERCASE("VAT Registration No.");
        IF "VAT Registration No." <> xRec."VAT Registration No." THEN
          VATRegistrationValidation;

        //DSLoc0.01 Para buscar el nombre comercial de la empresa.
        VPG.GET("Vendor Posting Group");

        IF ("VAT Registration No." <> '') AND ((VPG."NCF Obligatorio") OR (VPG."Permite Emitir NCF")) THEN
           BEGIN
             IF RNCDGII.GET("VAT Registration No.") THEN // jpg validar rnc desde nueva tabla dgii ++
               BEGIN
                  Name := RNCDGII.Name;
                 IF RNCDGII."Search Name" <> '' THEN
                  "Search Name" := RNCDGII."Search Name";
               END
              ELSE // jpg validar rnc desde nueva tabla dgii --
                BEGIN
                 ConsultaRNC.BuscarRNC("VAT Registration No.",Datos);
                 IF Datos[2] <> '' THEN
                    Name := COPYSTR(Datos[2],1,MAXSTRLEN(Name));
                 IF Datos[3] <> '' THEN
                    "Search Name" := COPYSTR(Datos[3],1,MAXSTRLEN("Search Name"));
                END;
           END; //}
        */
        //end;

        //Unsupported feature: Deletion (FieldCollection) on ""EORI Number"(Field 93)".



        //Unsupported feature: Code Modification on ""Primary Contact No."(Field 5049).OnValidate".

        //trigger "(Field 5049)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        Contact := '';
        if "Primary Contact No." <> '' then begin
          Cont.Get("Primary Contact No.");
        #4..6
          if Cont."Company No." <> ContBusRel."Contact No." then
            Error(Text004,Cont."No.",Cont.Name,"No.",Name);

          if Cont.Type = Cont.Type::Person then begin
            Contact := Cont.Name;
            exit;
          end;

          if Cont."Phone No." <> '' then
            "Phone No." := Cont."Phone No.";
          if Cont."E-Mail" <> '' then
            "E-Mail" := Cont."E-Mail";
        end;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..9
          if Cont.Type = Cont.Type::Person then
            Contact := Cont.Name;
        #14..19
        */
        //end;
        field(55000; "Proveedor Ocasional"; Boolean)
        {
            Caption = 'Occasional supplier';
            DataClassification = ToBeClassified;
        }
        field(55001; "Tipo Contribuyente"; Code[20])
        {
            Caption = 'Contributor Type';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
            TableRelation = "SRI - Tabla Parametros".Code WHERE("Tipo Registro" = CONST("TIPOS AGENTE DE RETENCION"));

            trigger OnValidate()
            begin

                if Confirm(txt001, false) then begin
                    //003
                    ProvRet.Reset;
                    ProvRet.SetRange(ProvRet."Cód. Proveedor", "No.");
                    ProvRet.SetFilter("Tipo Contribuyente", '<>%1', "Tipo Contribuyente");
                    if ProvRet.FindFirst then
                        Error(Error003, ProvRet.TableCaption);
                    //003


                    //005
                    SRIParam.Reset;
                    SRIParam.SetRange("Tipo Registro", SRIParam."Tipo Registro"::"TIPOS AGENTE DE RETENCION");
                    SRIParam.SetRange(SRIParam.Code, "Tipo Contribuyente");
                    if SRIParam.FindFirst then begin
                        Validate("Tipo Documento", SRIParam."Tipo Documento");
                        Validate("Tipo Ruc/Cedula", SRIParam."Tipo Ruc/Cedula");
                    end;
                    //005
                end
                else
                    "Tipo Contribuyente" := xRec."Tipo Contribuyente";
            end;
        }
        field(55002; "Tipo Ruc/Cedula"; Option)
        {
            Caption = 'RUC/ID Type';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
            OptionCaption = ' ,R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA,R.U.C. PUBLICOS,RUC PERSONA NATURAL,ID';
            OptionMembers = " ","R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA","R.U.C. PUBLICOS","RUC PERSONA NATURAL",CEDULA,PASAPORTE;
        }
        field(55003; "Tipo Documento"; Option)
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
            OptionCaption = 'VAT,ID,Passport';
            OptionMembers = RUC,Cedula,Pasaporte;

            trigger OnValidate()
            begin
                Validate("VAT Registration No.", '');
            end;
        }
        field(55004; "Desc. Tipo Contribuyente"; Text[170])
        {
            CalcFormula = Lookup("SRI - Tabla Parametros".Description WHERE("Tipo Registro" = FILTER("TIPOS AGENTE DE RETENCION"),
                                                                             Code = FIELD("Tipo Contribuyente")));
            Caption = 'Contributor Type Descr.';
            Description = 'Ecuador';
            FieldClass = FlowField;
        }
        field(55005; "Desc. Tipo Ruc/Cedula"; Text[150])
        {
            Caption = 'RUC Type';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55006; "Parte Relacionada"; Boolean)
        {
            Caption = 'Parte Relacionada';
            DataClassification = ToBeClassified;
            Description = '#14564 Ecuador';
        }
        field(55007; "Excluir Informe ATS"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '#14564 Ecuador';
        }
        field(55008; "Tipo Contrib. Extranjero"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Persona Natural,Sociedad';
            OptionMembers = " ","Persona Natural",Sociedad;
        }
        field(56000; Inactivo; Boolean)
        {
            Caption = 'Inactivo';
            DataClassification = ToBeClassified;
            Description = '#7314';

            trigger OnValidate()
            var
                lErrorPermiso: Label 'No dispone de los permisos necesario para Activar/Desactivar el Vendedor';
                lErrorSaldo: Label 'No es posible Inactivar el vendedor, puesto que su saldo es diferente de 0.';
                UserSetup: Record "User Setup";
            begin
                //#7314:Inicio
                if not (UserSetup.Get(UserId) and UserSetup."Activa/Inactiva Maestros") then
                    Error(lErrorPermiso);

                //Verificar que el saldo es 0
                CalcFields("Balance (LCY)");
                if "Balance (LCY)" <> 0 then
                    Error(lErrorSaldo);
                //#7314:Fin
            end;
        }
        field(76058; "Cod. Clasificacion Gasto"; Code[2])
        {
            Caption = 'Expense Class Code';
            DataClassification = ToBeClassified;
            TableRelation = "Clasificacion Gastos";
        }
    }


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    if "No." = '' then begin
      PurchSetup.Get;
      PurchSetup.TestField("Vendor Nos.");
    #4..16
      DATABASE::Vendor,"No.",
      "Global Dimension 1 Code","Global Dimension 2 Code");

    UpdateReferencedIds;
    SetLastModifiedDateTime;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..19
    //001
    ConfSant.Get;
    if ConfSant."Proveedor Bloqueado al crear" then
      Blocked := Blocked::All;
    //001

    //ATS
    ValidaTipoContribExt;

    UpdateReferencedIds;
    SetLastModifiedDateTime;
    */
    //end;


    //Unsupported feature: Code Modification on "OnModify".

    //trigger OnModify()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    UpdateReferencedIds;
    SetLastModifiedDateTime;

    if IsContactUpdateNeeded then begin
      Modify;
      UpdateContFromVend.OnModify(Rec);
      if not Find then begin
        Reset;
        if Find then;
      end;
    end;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3
    //ATS
    ValidaTipoContribExt;

    #4..11
    */
    //end;


    //Unsupported feature: Code Modification on "VATRegistrationValidation(PROCEDURE 14)".

    //procedure VATRegistrationValidation();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IsHandled := false;
    OnBeforeVATRegistrationValidation(Rec,IsHandled);
    if IsHandled then
      exit;

    if not VATRegistrationNoFormat.Test("VAT Registration No.","Country/Region Code","No.",DATABASE::Vendor) then
      exit;

    LogNotVerified := true;
    if ("Country/Region Code" <> '') or (VATRegistrationNoFormat."Country/Region Code" <> '') then begin
      ApplicableCountryCode := "Country/Region Code";
      if ApplicableCountryCode = '' then
        ApplicableCountryCode := VATRegistrationNoFormat."Country/Region Code";
      if VATRegNoSrvConfig.VATRegNoSrvIsEnabled then begin
        LogNotVerified := false;
        VATRegistrationLogMgt.ValidateVATRegNoWithVIES(
          ResultRecordRef,Rec,"No.",VATRegistrationLog."Account Type"::Vendor,ApplicableCountryCode);
        ResultRecordRef.SetTable(Rec);
      end;
    end;

    if LogNotVerified then
      VATRegistrationLogMgt.LogVendor(Rec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..8
    VATRegistrationLogMgt.LogVendor(Rec);

    if ("Country/Region Code" = '') and (VATRegistrationNoFormat."Country/Region Code" = '') then
      exit;
    ApplicableCountryCode := "Country/Region Code";
    if ApplicableCountryCode = '' then
      ApplicableCountryCode := VATRegistrationNoFormat."Country/Region Code";
    if VATRegNoSrvConfig.VATRegNoSrvIsEnabled then begin
      VATRegistrationLogMgt.ValidateVATRegNoWithVIES(ResultRecordRef,Rec,"No.",
        VATRegistrationLog."Account Type"::Vendor,ApplicableCountryCode);
      ResultRecordRef.SetTable(Rec);
    end;
    */
    //end;

    procedure ValidaTipoContribExt()
    var
        Text001: Label 'En los contribuyentes extranjeros es obligatorio ingresar un valor en el campo Tipo de Contrib. extranjero.';
    begin
        //ATS
        //IF (("Tipo Contribuyente" = 'EX') OR ("Tipo Contribuyente" = 'EX RUC')) AND ("Tipo Contrib. Extranjero" = "Tipo Contrib. Extranjero"::" ")THEN
        //  ERROR(Text001);

        //#30564
        if ("Tipo Contribuyente" = 'EX') and ("Tipo Contrib. Extranjero" = "Tipo Contrib. Extranjero"::" ") then
            Error(Text001);
    end;

    //Unsupported feature: Property Modification (Fields) on "DropDown(FieldGroup 1)".


    //Unsupported feature: Deletion (VariableCollection) on "VATRegistrationValidation(PROCEDURE 14).LogNotVerified(Variable 1007)".


    var
        // UserSetup: Record "User Setup";
        ValidaCampReq: Codeunit "Valida Campos Requeridos";
        Text100: Label 'No tiene permiso para desbloquear proveedores';

    var
        ConsultaRNC: Codeunit "Validaciones Loc. Guatemala";
        Datos: array[6] of Text;
        VPG: Record "Vendor Posting Group";
        RNCDGII: Record "RNC DGII";
        rVendor: Record Vendor;
        Err001: Label 'El valor ingresado ya existe en el proveedor %1.';
        VATRegNoFormat: Record "VAT Registration No. Format";

    var
        ConfSant: Record "Config. Empresa";
        UserSetUp: Record "User Setup";
        ValidaCampos: Codeunit "Valida Campos Requeridos";
        VBA: Record "Vendor Bank Account";
        ProvRet: Record "Proveedor - Retencion";
        SRIParam: Record "SRI - Tabla Parametros";
        Error001: Label 'User cannot unlock Vendors';
        Error002: Label 'Occasional Vendor must have at least one Bank created';
        Error003: Label 'Records in the table %1 must be deleted for this Vendor before change the Retention Type';
        txt001: Label 'If modify Contributor Type it will delete Vat Reg. No., Confirm that you want to proceed';
}

