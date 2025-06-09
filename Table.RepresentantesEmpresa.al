table 76000 "Representantes Empresa"
{
    Caption = 'Company Representatives';

    fields
    {
        field(1; "Empresa cotización"; Code[10])
        {
            Caption = 'Company';
        }
        field(2; "No. Orden"; Integer)
        {
            Caption = 'Line no.';
        }
        field(3; Nombre; Text[30])
        {
            Caption = 'Name';
        }
        field(4; Address; Text[60])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;
        }
        field(5; "C.P."; Text[5])
        {
            Caption = 'Post code';
            TableRelation = "Post Code";

            trigger OnValidate()
            begin
                if CodPost.Get("C.P.") then begin
                    County := CodPost."Search City";
                end;
            end;
        }
        field(6; "Población"; Text[30])
        {
            Caption = 'Población';
        }
        field(7; County; Text[30])
        {
            Caption = 'State';
            DataClassification = ToBeClassified;
        }
        field(8; "Teléfono"; Text[20])
        {
            Caption = 'Phone no.';
        }
        field(9; "RNC/CED"; Text[15])
        {
            Caption = 'RNC/Cédula';

            trigger OnValidate()
            begin
                Emp.Reset;
                Emp.SetRange("Document ID", "RNC/CED");
                if Emp.FindFirst then begin
                    "Job Title" := Emp."Job Title";
                    Nombre := Emp."Full Name";
                    Address := Emp.Address;
                    "C.P." := Emp."Post Code";
                    Teléfono := Emp."Phone No.";
                    Población := Emp."Country/Region Code";
                    County := Emp.County;
                end;
            end;
        }
        field(10; "Job Title"; Text[60])
        {
            Caption = 'Job Title';
            DataClassification = ToBeClassified;
        }
        field(11; Figurar; Option)
        {
            Caption = 'Show';
            Description = 'Todo tipo documento,Contratos laborales,Mercantil,Responsable Informático';
            OptionCaption = 'All types of documents, Labor contracts, Letters, IT Manager';
            OptionMembers = "Todo tipo documento","Contratos laborales",Mercantil,"Responsable Informático";
        }
    }

    keys
    {
        key(Key1; "Empresa cotización", "No. Orden")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Emp: Record Employee;
        CodPost: Record "Post Code";


    procedure "Recoger representantes"(var "Repres.": Record "Representantes Empresa"; "Unidad cotizacion": Code[10]; "Centro de trabajo": Code[10]; Figurar: Integer)
    begin
        "Repres.".Reset;
        "Repres.".SetRange("Repres."."Empresa cotización", "Empresa cotización");
        //"Repres.".SETRANGE("Repres."."Centro de trabajo","Centro de trabajo");
        "Repres.".SetFilter(Nombre, '<>%1', '');  // 17/12/99
        "Repres.".SetRange("Repres.".Figurar, Figurar);
        if not "Repres.".Find('+') then begin
            "Repres.".Reset;
            "Repres.".SetRange("Repres."."Empresa cotización", "Empresa cotización");
            //  "Repres.".SETRANGE("Repres."."Centro de trabajo","Centro de trabajo");
            "Repres.".SetFilter(Nombre, '<>%1', '');  // 17/12/99
            "Repres.".SetRange("Repres.".Figurar, "Repres.".Figurar::"Todo tipo documento");
            if not "Repres.".Find('+') then begin
                "Repres.".Reset;
                "Repres.".SetRange("Repres."."Empresa cotización", "Empresa cotización");
                "Repres.".SetFilter(Nombre, '<>%1', '');  // 17/12/99
                "Repres.".SetRange("Repres.".Figurar, Figurar);
                if not "Repres.".Find('+') then begin
                    "Repres.".Reset;
                    "Repres.".SetRange("Repres."."Empresa cotización", "Empresa cotización");
                    "Repres.".SetFilter(Nombre, '<>%1', '');  // 17/12/99
                    "Repres.".SetRange("Repres.".Figurar, "Repres.".Figurar::"Todo tipo documento");
                    if not "Repres.".Find('+') then begin
                        "Repres.".Reset;
                        "Repres.".SetFilter(Nombre, '<>%1', '');  // 17/12/99
                        "Repres.".SetRange("Repres.".Figurar, Figurar);
                        if not "Repres.".Find('+') then begin
                            "Repres.".Reset;
                            "Repres.".SetFilter(Nombre, '<>%1', '');  // 17/12/99
                            "Repres.".SetRange("Repres.".Figurar, "Repres.".Figurar::"Todo tipo documento");
                            if not "Repres.".Find('+') then "Repres.".Init
                        end;
                    end;
                end;
            end;
        end;
    end;
}

