table 76440 "Rel. Empleados Evaluacion"
{
    Caption = 'Employee Relation';
    DrillDownPageID = "Employee List";

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            Caption = 'Contact No.';
            NotBlank = true;
            TableRelation = Contact WHERE(Type = CONST(Company));

            trigger OnValidate()
            begin
                /*IF "Contact No." <> '' THEN
                  VALIDATE("Business Relation Code");
                  */

            end;
        }
        field(2; "Business Relation Code"; Code[10])
        {
            Caption = 'Business Relation Code';
            NotBlank = true;
            TableRelation = "Relacion Evaluacion";

            trigger OnValidate()
            var
                RMSetup: Record "Marketing Setup";
                Cust: Record Customer;
                Vend: Record Vendor;
                BankAcc: Record "Bank Account";
            begin
                /*IF ("No." = '') AND
                   ("Contact No." <> '') AND
                   ("Business Relation Code" <> '') AND
                   (CurrFieldNo <> 0)
                THEN BEGIN
                  RMSetup.GET;
                  IF "Business Relation Code" = RMSetup."Bus. Rel. Code for Customers" THEN
                    ERROR(Text001,
                      FIELDCAPTION("Business Relation Code"),"Business Relation Code",
                      Cont.TABLECAPTION,Cust.TABLECAPTION);
                  IF "Business Relation Code" = RMSetup."Bus. Rel. Code for Vendors" THEN
                    ERROR(Text001,
                      FIELDCAPTION("Business Relation Code"),"Business Relation Code",
                      Cont.TABLECAPTION,Vend.TABLECAPTION);
                  IF "Business Relation Code" = RMSetup."Bus. Rel. Code for Bank Accs." THEN
                    ERROR(Text001,
                      FIELDCAPTION("Business Relation Code"),"Business Relation Code",
                      Cont.TABLECAPTION,BankAcc.TABLECAPTION);
                END;
                */

            end;
        }
        field(3; "Link to Table"; Option)
        {
            Caption = 'Link to Table';
            OptionCaption = ' ,Customer,Vendor,Bank Account';
            OptionMembers = " ",Customer,Vendor,"Bank Account";
        }
        field(4; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF ("Link to Table" = CONST(Customer)) Customer
            ELSE
            IF ("Link to Table" = CONST(Vendor)) Vendor
            ELSE
            IF ("Link to Table" = CONST("Bank Account")) "Bank Account";
        }
        field(5; "Business Relation Description"; Text[50])
        {
            CalcFormula = Lookup("Relacion Evaluacion".Description WHERE(Code = FIELD("Business Relation Code")));
            Caption = 'Business Relation Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Contact Name"; Text[50])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE("No." = FIELD("Employee No.")));
            Caption = 'Contact Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Business Relation Code")
        {
            Clustered = true;
        }
        key(Key2; "Link to Table", "No.")
        {
        }
        key(Key3; "Link to Table", "Employee No.")
        {
        }
        key(Key4; "Business Relation Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        ContBusRel: Record "Rel. Empleados Evaluacion";
        Cont: Record Contact;
    begin
        /*
        IF "No." <> '' THEN BEGIN
          IF ContBusRel.FindByContact("Link to Table","Contact No.") THEN
            ERROR(
              Text000,
              Cont.TABLECAPTION,"Contact No.",TABLECAPTION,"Link to Table",ContBusRel."No.");
        
          IF ContBusRel.FindByRelation("Link to Table","No.") THEN
            IF GetContactBusinessRelation(ContBusRel) THEN
              ERROR(
                Text000,
                "Link to Table","No.",TABLECAPTION,Cont.TABLECAPTION,ContBusRel."Contact No.");
        
          ContBusRel.RESET;
          ContBusRel.SETRANGE("Contact No.","Contact No.");
          ContBusRel.SETRANGE("Business Relation Code","Business Relation Code");
          ContBusRel.SETRANGE("No.",'');
          ContBusRel.DELETEALL;
        END;
        */

    end;

    var
        Text000: Label '%1 %2 already has a %3 with %4 %5.';
        Text001: Label '%1 %2 is used when a %3 is linked with a %4.';
        Cont: Record Contact;

    local procedure GetContactBusinessRelation(ContactBusinessRelation: Record "Rel. Empleados Evaluacion"): Boolean
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        BankAccount: Record "Bank Account";
    begin
        case ContactBusinessRelation."Link to Table" of
            ContactBusinessRelation."Link to Table"::"Bank Account":
                exit(BankAccount.Get(ContactBusinessRelation."No."));
            ContactBusinessRelation."Link to Table"::Customer:
                exit(Customer.Get(ContactBusinessRelation."No."));
            ContactBusinessRelation."Link to Table"::Vendor:
                exit(Vendor.Get(ContactBusinessRelation."No."));
        end;
    end;


    procedure FindByContact(LinkType: Option; ContactNo: Code[20]): Boolean
    begin
        /*RESET;
        SETCURRENTKEY("Link to Table","Contact No.");
        SETRANGE("Link to Table",LinkType);
        SETRANGE("Contact No.",ContactNo);
        EXIT(FINDFIRST);
        */

    end;


    procedure FindByRelation(LinkType: Option; LinkNo: Code[20]): Boolean
    begin
        Reset;
        SetCurrentKey("Link to Table", "No.");
        SetRange("Link to Table", LinkType);
        SetRange("No.", LinkNo);
        exit(FindFirst);
    end;


    procedure GetContactNo(LinkType: Option; LinkNo: Code[20]): Code[20]
    begin
        /*IF FindByRelation(LinkType,LinkNo) THEN
          EXIT("Contact No.");
        EXIT('');
        */

    end;
}

