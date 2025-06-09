tableextension 50024 tableextension50024 extends Customer
{
    fields
    {
        field(50000; "City 2"; Text[60])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;
        }
        field(50001; "Balance 2"; Decimal)
        {
            Caption = 'Balance';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Cust. Ledg. Entry".Amount where("Customer No." = field("No."),
                                                                         "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
                                                                         "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
                                                                         "Currency Code" = field("Currency Filter"),
                                                                         "Posting Date" = field("Date Filter")));
        }
        field(50012; "Balance (LCY) 2"; Decimal)
        {
            Caption = 'Balance (LCY)';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" where("Customer No." = field("No."),
                                                                         "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
                                                                         "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
                                                                         "Currency Code" = field("Currency Filter"),
                                                                         "Posting Date" = field("Date Filter")));
        }
        field(50013; "Vat Registration No. 2"; Code[30])
        {
            Caption = 'Vat Registration No.';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                CPG: Record "Customer Posting Group";
                //RNCDGII: Record 34003024;
                TextDSLoc001: Label '%1 does not exist in DGII DB, do you wish to continue?';//ESP=%1 no existe en la base de datos de la DGII, desea continuar?;ESM=%1 no existe en la base de datos de la DGII, desea continuar?';
                TextDSLoc002: Label 'Process canceled by user';//ESP=Proceso cancelado por el usuario;ESM=Proceso cancelado por el usuario';
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
                "VAT Registration No. 2" := UPPERCASE("VAT Registration No.");
                IF "VAT Registration No." <> xRec."VAT Registration No." THEN
                    VATRegistrationValidation;

                /*
                //Funcionalidad no aplica a Santillana Ecuador //fes mig
                //DSLoc0.01 Para buscar el nombre comercial de la empresa.
                CPG.GET("Customer Posting Group");

                IF ("VAT Registration No."  '') AND (CPG."Permite emitir NCF") AND NOT( CPG.Internacional) THEN
                   BEGIN
                    IF RNCDGII.GET("VAT Registration No.") THEN // jpg validar rnc desde nueva tabla dgii ++
                    BEGIN
                        IF "Name 2" = '' THEN BEGIN
                            Name := RNCDGII.Name;
                            IF RNCDGII."Search Name"  '' THEN
                               IF "Search Name" = '' THEN
                                "Search Name" := RNCDGII."Search Name";
                        END;
                    END
                    ELSE BEGIN
                        IF NOT CONFIRM(STRSUBSTNO(TextDSLoc001, TABLECAPTION)) THEN
                            ERROR(TextDSLoc002);
                    END;
                END;
                */

                IF "Tipo Documento" <> "Tipo Documento"::Pasaporte THEN
                    TESTFIELD("Tipo Ruc/Cedula");
                VATRegNoFormat.Test_Santillana("VAT Registration No.", "Country/Region Code", "No.", DATABASE::Customer);
            end;
        }
        modify(Name)
        {
            Description = '#56924';
        }
        modify("Search Name")
        {
            Description = '#56924';
        }
        modify("Address 2")
        {
            Caption = 'Address 2';
        }
        modify(City)
        {
            Caption = 'City';
        }
        modify("Territory Code")
        {
            Caption = 'Territory Code';
        }
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
            trigger OnBeforeValidate()
            var
                myInt: Integer;
            begin
                //009++
                if UserSetup.Get(UserId) then begin
                    if Blocked <> Blocked::All then
                        if not UserSetup."Desbloquea Clientes" then
                            Error(Text100)
                        else begin
                            ValidaCampReq.Maestros(18, "No.");
                            ValidaCampReq.Dimensiones(18, "No.", 0, 0);
                        end;
                end
                else
                    Error(Text100);
                //009--
            end;
        }
        modify("VAT Registration No.")
        {
            Caption = 'VAT Registration No.';

            trigger OnAfterValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
                IF "Tipo Documento" <> "Tipo Documento"::Pasaporte THEN
                    TESTFIELD("Tipo Ruc/Cedula");
                VATRegNoFormat.Test_Santillana("VAT Registration No.", "Country/Region Code", "No.", DATABASE::Customer);
            end;
        }
        modify("Gen. Bus. Posting Group")
        {
            Caption = 'Gen. Bus. Posting Group';
        }
        modify("Post Code")
        {
            Caption = 'ZIP Code';
        }
        modify(County)
        {
            Caption = 'State';
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'VAT Bus. Posting Group';
        }
        modify("No. of Pstd. Credit Memos")
        {
            Caption = 'No. of Pstd. Credit Memos';
        }
        modify("Validate EU Vat Reg. No.")
        {
            Caption = 'Validate EU Tax Reg. No.';
        }
        modify(Contact)
        {
            trigger OnBeforeValidate()
            var
                RMSetup: Record "Marketing Setup";
            begin
                if RMSetup.Get() then
                    if RMSetup."Bus. Rel. Code for Customers" <> '' then
                        if (xRec.Contact = '') and (xRec."Primary Contact No." = '') and (Contact <> '') then begin
                            Modify();
                        end
            end;
        }
        modify("Primary Contact No.")
        {
            trigger OnBeforeValidate()
            var
                Cont: Record Contact;
            begin
                Contact := '';
                if "Primary Contact No." <> '' then begin
                    Cont.Get("Primary Contact No.");

                    CheckCustomerContactRelation(Cont);

                    if Cont.Type = Cont.Type::Person then begin
                        Contact := Cont.Name;
                        //exit; validar que quitando el exit se guarde la info posterior
                    end;

                    if Cont.Image.HasValue() then
                        CopyContactPicture(Cont);

                    if Cont."Phone No." <> '' then
                        "Phone No." := Cont."Phone No.";
                    if Cont."E-Mail" <> '' then
                        "E-Mail" := Cont."E-Mail";
                    if Cont."Mobile Phone No." <> '' then
                        "Mobile Phone No." := Cont."Mobile Phone No.";

                end else
                    if Image.HasValue() then
                        Clear(Image);
            end;
        }
        field(50002; "Balance en Consignacion"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry"."Importe Cons. Neto Inicial" WHERE("Location Code" = FIELD("Cod. Almacen Consignacion"),
                                                                                      "Posting Date" = FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(50003; "Inventario en Consignacion"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Location Code" = FIELD("Cod. Almacen Consignacion"),
                                                                  "Posting Date" = FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(50004; "Cod. Almacen Consignacion"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;

            trigger OnValidate()
            begin
                //001
                TestField("Cod. Almacen Consignacion", "No.");
            end;
        }
        field(50005; "Prioridad entrega consignacion"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Low,Medium,High';
            OptionMembers = Baja,Media,Alta;
        }
        field(50006; "Precios en Conduce de envio"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Balance en Consignacion Act."; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry"."Importe Cons. Neto Act." WHERE("Location Code" = FIELD("Cod. Almacen Consignacion"),
                                                                                   Open = FILTER(true),
                                                                                   "Posting Date" = FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(50008; "Inventario en Consignacion Act"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry"."Remaining Quantity" WHERE("Location Code" = FIELD("Cod. Almacen Consignacion"),
                                                                              Open = FILTER(true)));
            Caption = 'Consignment Inventory Act';
            FieldClass = FlowField;
        }
        field(50010; "Tipo de Venta"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Factura,Consignacion," ";
        }
        field(50011; "Admite Pendientes en Pedidos"; Boolean)
        {
            Caption = 'Permit Remaining Qty. in Sales Orders';
            DataClassification = ToBeClassified;
            Description = 'BO';
        }
        field(50014; "PO Box address"; Text[50])
        {
            Caption = 'PO Box address';
            DataClassification = ToBeClassified;
        }
        field(50100; "No_ Cliente SIC"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'SIC-JERM';
            Editable = false;
        }
        field(52000; GIRO; Text[50])
        {
            Caption = 'GIRO';
            DataClassification = ToBeClassified;
        }
        field(52001; NRC; Code[10])
        {
            Caption = 'NRC';
            DataClassification = ToBeClassified;
        }
        field(53001; "Enviado no fact. en Consig."; Decimal)
        {
            CalcFormula = Sum("Transfer Line"."Qty. in Transit" WHERE("Transfer-to Code" = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(55000; "No. Telefono Envio"; Code[30])
        {
            Caption = 'Shipment Phone No.';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55001; "Tipo Documento"; Option)
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
            OptionCaption = 'VAT,ID,Passport';
            OptionMembers = RUC,Cedula,Pasaporte;

            trigger OnValidate()
            begin
                if Confirm(txt001, false) then begin
                    "VAT Registration No." := '';
                    "Tipo Ruc/Cedula" := 0;
                    if "Tipo Documento" = "Tipo Documento"::Cedula then
                        "Tipo Ruc/Cedula" := 4;
                end
                else
                    "Tipo Documento" := xRec."Tipo Documento";
            end;
        }
        field(55005; "Tipo Ruc/Cedula"; Option)
        {
            Caption = 'RUC/ID Type';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
            OptionCaption = ' ,R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA,R.U.C. PUBLICOS,RUC PERSONA NATURAL,ID';
            OptionMembers = " ","R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA","R.U.C. PUBLICOS","RUC PERSONA NATURAL",CEDULA;

            trigger OnValidate()
            begin
                if Confirm(txt002, false) then begin
                    Validate("VAT Registration No.", '');
                    if "Tipo Ruc/Cedula" = "Tipo Ruc/Cedula"::CEDULA then
                        "Tipo Documento" := "Tipo Documento"::Cedula;

                    if ("Tipo Ruc/Cedula" <> "Tipo Ruc/Cedula"::CEDULA) and ("Tipo Ruc/Cedula" <> "Tipo Ruc/Cedula"::" ") then
                        "Tipo Documento" := "Tipo Documento"::RUC;
                end
                else
                    "Tipo Ruc/Cedula" := xRec."Tipo Ruc/Cedula";
            end;
        }
        field(55006; Sexo; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Ecuador,#6780';
            OptionMembers = " ",Masculino,Femenino;
        }
        field(55007; "Estado Civil"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Ecuador,#6780';
            OptionMembers = " ",Soltero,Casado,Divorciado,"Unión Libre",Viudo;
        }
        field(55008; "Origen Ingresos"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Ecuador,#6780';
            OptionMembers = " ","Empleado Público","Empleado Privado",Independiente,"Ama de Casa o Estudiante",Rentista,Jubilado,"Remesas del Exterior";
        }
        field(55009; "Parte Relacionada"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'SRI';
        }
        field(56000; "Collector Code"; Code[10])
        {
            Caption = 'Collector code';
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser" WHERE(Tipo = FILTER(Cobrador));
        }
        field(56001; "Permite Refacturar"; Boolean)
        {
            Caption = 'Allow re invoice';
            DataClassification = ToBeClassified;
        }
        field(56002; "Packing requerido"; Option)
        {
            Caption = 'Packing Required';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Not Verifiable,Always Verifiable,Verifiable';
            OptionMembers = " ","No Verificable","Verificable Siempre",Verificable;
        }
        field(56003; APS; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(56004; Inactivo; Boolean)
        {
            Caption = 'Inactivo';
            DataClassification = ToBeClassified;
            Description = '#7314';

            trigger OnValidate()
            var
                lErrorPermiso: Label 'No dispone de los permisos necesarios para Activar/Desactivar el cliente.';
                lErrorSaldo: Label 'No es posible inactivar el cliente puesto que el saldo no es 0.';
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
        field(56007; "Cod. Colegio"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Contact;
        }
        field(56026; "Exento Provision"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '#144';
        }
        field(56027; "Saldo provision"; Decimal)
        {
            CalcFormula = - Sum("G/L Entry".Amount WHERE("Source Type" = CONST(Customer),
                                                         "Source No." = FIELD("No."),
                                                         "Posting Date" = FIELD("Date Filter"),
                                                         "No. Mov. cliente provisionado" = FILTER(> 0)));
            Description = '#144';
            FieldClass = FlowField;
        }
        field(56028; "Fecha inicio relacion"; Date)
        {
            Caption = 'Fecha inicio relación';
            DataClassification = ToBeClassified;
        }
        field(56029; "Calificacion de cliente"; Option)
        {
            Caption = 'Calificación de cliente';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,A,B,C,D';
            OptionMembers = " ",A,B,C,D;
        }
        field(56030; "Bloqueo de Facturar Desde"; Date)
        {
            Caption = 'Bloqueo de Facturar Desde';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-1641';

            trigger OnValidate()
            var
                UserSetUp: Record "User Setup";
                Error01: Label 'El usuario no tiene permiso para desbloquear clientes.';
            begin
                // ++ 008-YFC
                UserSetUp.Get(UserId);
                if not UserSetUp."Fecha de Bloqueo Cliente" then
                    Error(Error01);
                // -- 008-YFC
            end;
        }
        field(76046; "Permite venta a credito"; Boolean)
        {
            Caption = 'Credit Sales Allowed';
            DataClassification = ToBeClassified;
            Description = 'DSPOS Standar';
        }
        field(76029; "Colegio por defecto POS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'DSPOS Standar';
            TableRelation = Contact;
        }
    }

    local procedure CheckCustomerContactRelation(Cont: Record Contact)
    var
        ContBusRel: Record "Contact Business Relation";
        Text003: Label 'Contact %1 %2 is not related to customer %3 %4.';
    begin
        ContBusRel.FindOrRestoreContactBusinessRelation(Cont, Rec, ContBusRel."Link to Table"::Customer);

        if Cont."Company No." <> ContBusRel."Contact No." then
            Error(Text003, Cont."No.", Cont.Name, "No.", Name);
    end;

    local procedure CopyContactPicture(var Cont: Record Contact)
    var
        ConfirmManagement: Codeunit "Confirm Management";
        OverrideImageQst: Label 'Override Image?';
        InStr: InStream;
        OutStr: OutStream;
        TempBlob: Codeunit "Temp Blob";
    begin
        if Image.HasValue() then
            if not ConfirmManagement.GetResponseOrDefault(OverrideImageQst, true) then
                exit;

        if Cont.Image.HasValue then begin
            Cont.CalcFields(Image);
            TempBlob.CreateOutStream(OutStr);
            Cont.Image.ExportStream(OutStr);
            TempBlob.CreateInStream(InStr);
            Clear(Image);
            Image.ImportStream(InStr, Name);
            Modify(false);
        end;
    end;

    trigger OnBeforeInsert()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit "No. Series";
        DimMgt: Codeunit DimensionManagement;
    begin
        if "No." = '' then begin
            SalesSetup.Get();
            SalesSetup.TestField("Customer Nos.");
            //NoSeriesMgt.InitSeries(SalesSetup."Customer Nos.", xRec."No. Series", 0D, "No.", "No. Series");
            Rec."No. series" := SalesSetup."Customer Nos.";
            if NoSeriesMgt.AreRelated(SalesSetup."Customer Nos.", xRec."No. Series") then
                Rec."No. Series" := xRec."No. Series";
            Rec."No." := NoSeriesMgt.GetNextNo(Rec."No. Series", 0D, true);
        end;

        //009++
        ConfSantillana.Get;//011+-
        if "No_ Cliente SIC" = '' then begin
            "No_ Cliente SIC" := NoSeriesManagement.GetNextNo(ConfSantillana."Serie Cliente SIC", WorkDate, true);//011+
        end;
        //009-

        if "Invoice Disc. Code" = '' then
            "Invoice Disc. Code" := "No.";

        //002
        ConfEmpresa.Get();
        if ConfEmpresa."Clientes Nuevos Bloqueados" then
            Blocked := Blocked::All;
        //002

        if "Salesperson Code" = '' then
            SetDefaultSalesperson();

        DimMgt.UpdateDefaultDim(
          DATABASE::Customer, "No.",
          "Global Dimension 1 Code", "Global Dimension 2 Code");

        UpdateReferencedIds();
        SetLastModifiedDateTime();
    end;


    //Unsupported feature: Code Modification on "ShowContact(PROCEDURE 1)".
    //Se comento todo el proceso buscar oculatar botones que lo llaman en Customer Card, Customer List
    //Customer Order Status, Customer List - Collections, Customer List - Credit Mgmt, Customer List - Order Status

    var
        UserSetup: Record "User Setup";
        ValidaCampReq: Codeunit "Valida Campos Requeridos";
        Text100: Label 'Usuario No tiene Permiso para Desbloquear Clientes';
        ConfEmpresa: Record "Config. Empresa";
        txt001: Label 'If modify Document Type it will delete the RUC/Cedula No. Vat Reg. No., Confirm that you want to proceed';
        txt002: Label 'Si modifica el Tipo RUC/Cédula No. de RUC/Cédula, Confirma que desea proceder';
        NoSeriesManagement: Codeunit "No. Series";
        ConfSantillana: Record "Config. Empresa";
}

