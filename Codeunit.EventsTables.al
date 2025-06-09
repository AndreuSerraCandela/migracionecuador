codeunit 50001 "Events Tables"
{
    // .-.-.-.-.-.- Events for Contact Table .-.-.-.-.-.-.
    [EventSubscriber(ObjectType::Table, Database::Contact, OnShowCustVendBankOnBeforeRunPage, '', false, false)]
    local procedure OnShowCustVendBankOnBeforeRunPage(isHandled: Boolean; var ContBusRel: Record "Contact Business Relation")
    var
        Cust: Record Customer;
        Vend: Record Vendor;
        BankAcc: Record "Bank Account";
        Employee: Record Employee;
    begin
        if ContBusRel."No." = '' then begin
            PAGE.Run(PAGE::"Contact Business Relations", ContBusRel);
            exit;
        end;

        case ContBusRel."Link to Table" of
            ContBusRel."Link to Table"::Customer:
                begin
                    Cust.Get(ContBusRel."No.");
                    PAGE.Run(PAGE::"Customer Card", Cust);
                end;
            ContBusRel."Link to Table"::Vendor:
                begin
                    Vend.Get(ContBusRel."No.");
                    PAGE.Run(PAGE::"Vendor Card", Vend);
                end;
            ContBusRel."Link to Table"::"Bank Account":
                begin
                    BankAcc.Get(ContBusRel."No.");
                    PAGE.Run(PAGE::"Bank Account Card", BankAcc);
                end;
            ContBusRel."Link to Table"::Employee:
                begin
                    Employee.Get(ContBusRel."No.");
                    Page.Run(Page::"Employee Card", Employee);
                end;
        end;

        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnAfterInheritCompanyToPersonData', '', false, false)]
    local procedure OnAfterInheritCompanyToPersonData(var Contact: Record Contact; xContact: Record Contact)
    var
        RMSetup: Record "Marketing Setup";
    begin
        RMSetup.Get();
        if RMSetup."Inherit Communication Details" then
            UpdateFieldForNewCompany(Contact.FieldNo("Colegio Activo"), Contact, xContact);
    end;

    local procedure UpdateFieldForNewCompany(FieldNo: Integer; var Contact: Record Contact; xContact: Record Contact)
    var
        OldCompanyContact: Record Contact;
        NewCompanyContact: Record Contact;
        OldCompanyRecRef: RecordRef;
        NewCompanyRecRef: RecordRef;
        ContactRecRef: RecordRef;
        ContactFieldRef: FieldRef;
        OldCompanyFieldValue: Text;
        ContactFieldValue: Text;
        Stale: Boolean;
        IsHandled: Boolean;
    begin
        if IsHandled then
            exit;

        ContactRecRef.GetTable(Contact);
        ContactFieldRef := ContactRecRef.Field(FieldNo);
        ContactFieldValue := Format(ContactFieldRef.Value);

        if NewCompanyContact.Get(Contact."Company No.") then begin
            NewCompanyRecRef.GetTable(NewCompanyContact);
            if OldCompanyContact.Get(xContact."Company No.") then begin
                OldCompanyRecRef.GetTable(OldCompanyContact);
                OldCompanyFieldValue := Format(OldCompanyRecRef.Field(FieldNo).Value);
                Stale := ContactFieldValue = OldCompanyFieldValue;
            end;
            if Stale or (ContactFieldValue = '') then begin
                ContactFieldRef.Validate(NewCompanyRecRef.Field(FieldNo).Value);
                ContactRecRef.SetTable(Contact);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnBeforeProcessPersonNameChange', '', false, false)]
    local procedure OnBeforeProcessPersonNameChange(var IsHandled: Boolean; var Contact: Record Contact; var Customer: Record Customer; var Vendor: Record Vendor)
    var
        ContBusRel: Record "Contact Business Relation";
    begin
        ContBusRel.Reset();
        ContBusRel.SetCurrentKey("Link to Table", "Contact No.");
        ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Customer);
        ContBusRel.SetRange("Contact No.", Contact."Company No.");
        if ContBusRel.FindFirst() then
            if Customer.Get(ContBusRel."No.") then
                if Customer."Primary Contact No." = Contact."No." then begin
                    Customer.Contact := Contact.Name;
                    Customer.Modify();
                end;

        ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Vendor);
        if ContBusRel.FindFirst() then
            if Vendor.Get(ContBusRel."No.") then
                if Vendor."Primary Contact No." = Contact."No." then begin
                    Vendor.Contact := Contact.Name;
                    Vendor.Modify();
                end;

        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnBeforeVATRegistrationValidation', '', false, false)]
    local procedure OnBeforeVATRegistrationValidation(var IsHandled: Boolean; var Contact: Record Contact)
    var
        VATRegistrationNoFormat: Record "VAT Registration No. Format";
        VATRegistrationLog: Record "VAT Registration Log";
        VATRegNoSrvConfig: Record "VAT Reg. No. Srv Config";
        VATRegistrationLogMgt: Codeunit "VAT Registration Log Mgt.";
        ResultRecordRef: RecordRef;
        ApplicableCountryCode: Code[10];
    begin
        VATRegistrationLogMgt.LogContact(Contact);

        if (Contact."Country/Region Code" = '') and (VATRegistrationNoFormat."Country/Region Code" = '') then
            exit;
        ApplicableCountryCode := Contact."Country/Region Code";
        if ApplicableCountryCode = '' then
            ApplicableCountryCode := VATRegistrationNoFormat."Country/Region Code";

        if VATRegNoSrvConfig.VATRegNoSrvIsEnabled then begin
            VATRegistrationLogMgt.ValidateVATRegNoWithVIES(ResultRecordRef, Contact, Contact."No.",
              VATRegistrationLog."Account Type"::Contact.AsInteger(), ApplicableCountryCode);
            ResultRecordRef.SetTable(Contact);
        end;

        IsHandled := true;
    end;

    // .-.-.-.-.-.- Events for Cust. Ledger Entry Table .-.-.-.-.-.-.
    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnBeforeDrillDownOnOverdueEntries', '', false, false)]
    local procedure OnBeforeDrillDownOnOverdueEntries(var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        RMSetup: Record "Marketing Setup";
    begin
        CustLedgerEntry.SetFilter("Date Filter", '..%1', WorkDate);
        CustLedgerEntry.SetFilter("Due Date", '<%1', WorkDate);
    end;

    // .-.-.-.-.-.- Events for G/L Account Table .-.-.-.-.-.-.
    //Se llamaba desde "Customer Posting Group" pero se elimino el metodo 
    [EventSubscriber(ObjectType::Table, Database::"G/L Account", 'OnBeforeCheckGenProdPostingGroup', '', false, false)]
    local procedure OnBeforeCheckGenProdPostingGroup(var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    // .-.-.-.-.-.- Events for Customer Table .-.-.-.-.-.-.
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateContact', '', false, false)]
    local procedure OnBeforeValidateContact(var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterLookupPostCode', '', false, false)]
    local procedure OnAfterLookupPostCode(var Customer: Record Customer; var PostCodeRec: Record "Post Code")
    var
    begin
        //010+
        IF PostCodeRec.GET(Customer."Post Code", Customer.City) THEN
            Customer."Address 2" := PostCodeRec.Colonia;
        //010-
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidatePostCode', '', false, false)]
    local procedure OnBeforeValidatePostCode(var Customer: Record Customer; var PostCodeRec: Record "Post Code"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    var
    begin
        PostCodeRec.ValidatePostCode(Customer.City, Customer."Post Code", Customer.County, Customer."Country/Region Code", (CurrentFieldNo <> 0) and GuiAllowed);

        //005
        IF PostCodeRec.GET(Customer."Post Code", Customer.City) THEN
            Customer."Address 2" := PostCodeRec.Colonia;
        //005

        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterDeleteRelatedData', '', false, false)]
    local procedure OnAfterDeleteRelatedData(Customer: Record Customer)
    var
        ServContract: Record "Service Contract Header";
        ServHeader: Record "Service Header";
        Text007: Label 'You cannot delete %1 %2 because there is at least one not canceled Service Contract for this customer.';//ESM=No puede borrar %1 %2 porque hay al menos un Contrato de Servicio no cancelado para este cliente.;FRC=Vous ne pouvez pas supprimer %1 %2 puisqu''au moins un contrat de services n''est pas annulé pour ce client.;ENC=You cannot delete %1 %2 because there is at least one not cancelled Service Contract for this customer.';
        Text013: Label 'You cannot delete %1 %2 because there is at least one outstanding Service %3 for this customer.';//ESM=No puede eliminar %1 %2 porque hay al menos un servicio pendiente %3 para este cliente.;FRC=Vous ne pouvez pas supprimer %1 %2 car il existe encore au moins une %3 service en suspens pour ce client.;ENC=You cannot delete %1 %2 because there is at least one outstanding Service %3 for this customer.';
    begin
        ServContract.SETFILTER(Status, '%1', ServContract.Status::Cancelled);
        ServContract.SETRANGE("Customer No.", Customer."No.");
        IF NOT ServContract.ISEMPTY THEN
            ERROR(
              Text007,
              Customer.TABLECAPTION, Customer."No.");

        ServContract.SETRANGE(Status);
        ServContract.MODIFYALL("Customer No.", '');

        ServContract.SETFILTER(Status, '%1', ServContract.Status::Cancelled);
        ServContract.SETRANGE("Bill-to Customer No.", Customer."No.");
        IF NOT ServContract.ISEMPTY THEN
            ERROR(
              Text007,
              Customer.TABLECAPTION, Customer."No.");

        ServContract.SETRANGE(Status);
        ServContract.MODIFYALL("Bill-to Customer No.", '');

        ServHeader.SETCURRENTKEY("Customer No.", "Order Date");
        ServHeader.SETRANGE("Customer No.", Customer."No.");
        IF ServHeader.FINDFIRST THEN
            ERROR(
              Text013,
              Customer.TABLECAPTION, Customer."No.", ServHeader."Document Type");

        ServHeader.SETRANGE("Bill-to Customer No.");
        IF ServHeader.FINDFIRST THEN
            ERROR(
              Text013,
              Customer.TABLECAPTION, Customer."No.", ServHeader."Document Type");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CustCont-Update", 'OnBeforeOnDelete', '', false, false)]
    local procedure OnBeforeOnDelete(var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeInsert', '', false, false)]
    local procedure OnBeforeInsert(var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeIsContactUpdateNeeded', '', false, false)]
    local procedure OnBeforeIsContactUpdateNeeded(Customer: Record Customer; var UpdateNeeded: Boolean)
    begin
        if UpdateNeeded then begin
            Customer.Modify();
            if not Customer.Find() then begin
                Customer.Reset();
                if Customer.Find() then;
            end;

            UpdateNeeded := false;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeCalcOverdueBalance', '', false, false)]
    local procedure OnBeforeCalcOverdueBalance(var Customer: Record Customer; var OverdueBalance: Decimal; var IsHandled: Boolean)
    var
        [SecurityFiltering(SecurityFilter::Filtered)]
        CustLedgEntryRemainAmtQuery: Query "Cust. Ledg. Entry Remain. Amt.";
    begin
        CustLedgEntryRemainAmtQuery.SetRange(Customer_No, Customer."No.");
        CustLedgEntryRemainAmtQuery.SetRange(IsOpen, true);
        CustLedgEntryRemainAmtQuery.SetFilter(Due_Date, '<%1', WorkDate);
        CustLedgEntryRemainAmtQuery.Open();

        if CustLedgEntryRemainAmtQuery.Read() then
            OverDueBalance := CustLedgEntryRemainAmtQuery.Sum_Remaining_Amt_LCY;

        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeVATRegistrationValidation', '', false, false)]
    local procedure OnBeforeVATRegistrationValidation_Customer(var Customer: Record Customer; var IsHandled: Boolean)
    var
        VATRegistrationNoFormat: Record "VAT Registration No. Format";
        VATRegistrationLog: Record "VAT Registration Log";
        VATRegNoSrvConfig: Record "VAT Reg. No. Srv Config";
        VATRegistrationLogMgt: Codeunit "VAT Registration Log Mgt.";
        ResultRecordRef: RecordRef;
        ApplicableCountryCode: Code[10];
        LogNotVerified: Boolean;
    begin
        if VATRegistrationNoFormat.Test(Customer."VAT Registration No.", Customer."Country/Region Code", Customer."No.", DATABASE::Customer) then begin

            LogNotVerified := true;
            if (Customer."Country/Region Code" <> '') or (VATRegistrationNoFormat."Country/Region Code" <> '') then begin
                ApplicableCountryCode := Customer."Country/Region Code";
                if ApplicableCountryCode = '' then
                    ApplicableCountryCode := VATRegistrationNoFormat."Country/Region Code";
                if VATRegNoSrvConfig.VATRegNoSrvIsEnabled() then begin
                    LogNotVerified := false;
                    VATRegistrationLogMgt.ValidateVATRegNoWithVIES(
                        ResultRecordRef, Customer, Customer."No.", VATRegistrationLog."Account Type"::Customer.AsInteger(), ApplicableCountryCode);
                    ResultRecordRef.SetTable(Customer);
                end;

                if LogNotVerified then
                    VATRegistrationLogMgt.LogCustomer(Customer);
            end;

        end;

        IsHandled := true;
    end;

    // .-.-.-.-.-.- Events for Default Dimension Table .-.-.-.-.-.-.
    [EventSubscriber(ObjectType::Table, Database::"Default Dimension", 'OnBeforeOnDelete', '', false, false)]
    local procedure OnBeforeOnDelete_DefaulDimension(var DefaultDimension: Record "Default Dimension"; var DimensionManagement: Codeunit DimensionManagement; var IsHandled: Boolean)
    var
        DimValuePerAccount: Record "Dim. Value per Account";
        cFunMdm: Codeunit "Funciones MdM";
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get();
        if DefaultDimension."Dimension Code" = GLSetup."Global Dimension 1 Code" then
            DefaultDimension.UpdateGlobalDimCode(1, DefaultDimension."Table ID", DefaultDimension."No.", '');
        if DefaultDimension."Dimension Code" = GLSetup."Global Dimension 2 Code" then
            DefaultDimension.UpdateGlobalDimCode(2, DefaultDimension."Table ID", DefaultDimension."No.", '');
        DimensionManagement.DefaultDimOnDelete(DefaultDimension);

        cFunMdm.GetDimEditable(DefaultDimension, true); // MdM

        DimValuePerAccount.SetRange("Table ID", DefaultDimension."Table ID");
        DimValuePerAccount.SetRange("No.", DefaultDimension."No.");
        DimValuePerAccount.SetRange("Dimension Code", DefaultDimension."Dimension Code");
        DimValuePerAccount.DeleteAll(true);

        IsHandled := true;
    end;

    // .-.-.-.-.-.- Events for Employee Table .-.-.-.-.-.-.
    [EventSubscriber(ObjectType::Table, Database::Employee, 'OnBeforeOnInsert', '', false, false)]
    local procedure OnBeforeOnInsert(var Employee: Record Employee; var xEmployee: Record Employee; var IsHandled: Boolean)
    var
        ResourcesSetup: Record "Resources Setup";
        Resource: Record Resource;
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        DimMgt: Codeunit DimensionManagement;
        RecNoSerieMgt: Record "No. Series";
        Employee2: Record Employee;
        ConfNominas: Record "Configuracion nominas";
        Numeradorescomunes: Record "Numeradores globales";
    begin
        Employee."Last Modified Date Time" := CurrentDateTime;
        HumanResSetup.Get();

        //Para cuando el numerador de empleados es comun a las empresas
        ConfNominas.Get();
        if (ConfNominas."Habilitar numeradores globales") and (Employee."No." = '') then begin
            Numeradorescomunes.FindFirst;
            Numeradorescomunes.TestField("No. serie empleados");
            Employee."No." := IncStr(Numeradorescomunes."No. serie empleados");
            Numeradorescomunes."No. serie empleados" := Employee."No.";
            Numeradorescomunes.Modify;
        end
        else
            if Employee."No." = '' then begin
                HumanResSetup.TestField("Employee Nos.");
                if NoSeriesMgt.AreRelated(HumanResSetup."Employee Nos.", xEmployee."No. Series") then
                    Employee."No. Series" := xEmployee."No. Series"
                else
                    Employee."No. Series" := HumanResSetup."Employee Nos.";
                Employee."No." := NoSeriesMgt.GetNextNo(Employee."No. Series");
                Employee.ReadIsolation(IsolationLevel::ReadUncommitted);
                Employee.SetLoadFields("No.");
                while Employee2.Get(Employee."No.") do
                    Employee."No." := NoSeriesMgt.GetNextNo(Employee."No. Series");
            end;

        if HumanResSetup."Automatically Create Resource" then begin
            ResourcesSetup.Get();
            Resource.Init();
            RecNoSerieMgt.Get(ResourcesSetup."Resource Nos.");
            if RecNoSerieMgt."Manual Nos." then begin
                //if NoSeriesMgt.ManualNoAllowed(ResourcesSetup."Resource Nos.") then begin
                Resource."No." := Employee."No.";
                Resource.Insert(true);
            end else
                Resource.Insert(true);
            Employee."Resource No." := Resource."No.";
        end;

        DimMgt.UpdateDefaultDim(
          DATABASE::Employee, Employee."No.",
          Employee."Global Dimension 1 Code", Employee."Global Dimension 2 Code");
        UpdateSearchName(Employee, xEmployee);

        if ConfNominas."Integracion ponche activa" then begin
            ConfNominas.TestField("CU Procesa datos ponchador");
            CODEUNIT.Run(ConfNominas."CU Procesa datos ponchador", Employee);
        end;

        IsHandled := true;
    end;

    local procedure UpdateSearchName(var Employee: Record Employee; var xEmployee: Record Employee)
    var
        PrevSearchName: Code[250];
    begin
        PrevSearchName := xEmployee.FullName() + ' ' + xEmployee.Initials;
        if (((Employee."First Name" <> xEmployee."First Name") or (Employee."Middle Name" <> xEmployee."Middle Name") or (Employee."Last Name" <> xEmployee."Last Name") or
             (Employee.Initials <> xEmployee.Initials)) and (Employee."Search Name" = PrevSearchName))
        then
            Employee."Search Name" := SetSearchNameToFullnameAndInitials(Employee);
    end;

    local procedure SetSearchNameToFullnameAndInitials(var Employee: Record Employee): Code[250]
    begin
        exit(Employee.FullName() + ' ' + Employee.Initials);
    end;

    // .-.-.-.-.-.- Events for Purchase Header Table .-.-.-.-.-.-.
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterCopyBuyFromVendorFieldsFromVendor', '', false, false)]
    local procedure OnAfterCopyBuyFromVendorFieldsFromVendor(Vendor: Record Vendor; var PurchaseHeader: Record "Purchase Header")
    begin
        //DSLoc1.01 To Default Vendor's Name in the Posting Description
        PurchaseHeader."Posting Description" := Vendor.Name;
        PurchaseHeader."Cod. Clasificacion Gasto" := Vendor."Cod. Clasificacion Gasto";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnValidatePostingDateOnBeforeCheckNeedUpdateCurrencyFactor', '', false, false)]
    local procedure OnValidatePostingDateOnBeforeCheckNeedUpdateCurrencyFactor(PurchaseHeader: Record "Purchase Header")
    begin
        PurchaseHeader.SetCalledFromWhseDoc(false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeShouldSearchForVendorByName', '', false, false)]
    local procedure OnBeforeShouldSearchForVendorByName(var Result: Boolean; var IsHandled: Boolean)
    begin
        IsHandled := true;
        Result := false;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnRecreatePurchLinesOnAfterValidateType', '', false, false)]
    local procedure OnRecreatePurchLinesOnAfterValidateType(TempPurchaseLine: Record "Purchase Line" temporary; var PurchaseLine: Record "Purchase Line")
    begin
        if TempPurchaseLine."No." = '' then begin
            PurchaseLine.Validate(Description, TempPurchaseLine.Description);
            PurchaseLine.Validate("Description 2", TempPurchaseLine."Description 2");
        end;
    end;
}