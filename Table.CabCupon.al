table 56048 "Cab. Cupon."
{
    Caption = 'Coupon Header';
    LookupPageID = "Lista Cupones";

    fields
    {
        field(1; "No. Cupon"; Code[20])
        {
            Caption = 'Coupon No.';
        }
        field(2; "Cod. Cliente"; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                rCliente.Get("Cod. Cliente");
                "Nombre Cliente" := rCliente.Name;
            end;
        }
        field(3; "Nombre Cliente"; Text[100])
        {
            Caption = 'Customer Name';
            Description = '#56924';
        }
        field(4; "Cod. Promotor"; Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(5; "Valido Desde"; Date)
        {
            Caption = 'Date From';
        }
        field(6; "Valido Hasta"; Date)
        {
            Caption = 'Valid Until';
        }
        field(7; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(8; Impreso; Boolean)
        {
            Caption = 'Printed';
        }
        field(9; "Cod. Colegio"; Code[20])
        {
            Caption = 'School Code';
            TableRelation = Contact;

            trigger OnValidate()
            begin
                if rContacto.Get("Cod. Colegio") then begin
                    "Nombre Colegio" := rContacto.Name;
                    Validate("Cod. Promotor", rContacto."Salesperson Code");
                    Validate("Descuento a Colegio", rContacto."% Descuento Cupon");
                end;
            end;
        }
        field(10; "Nombre Colegio"; Text[100])
        {
            Caption = 'School Name';
        }
        field(11; "Cod. Nivel"; Code[20])
        {
            Caption = 'Student Grade';
        }
        field(12; "Descuento a Colegio"; Decimal)
        {
            Caption = 'School Discount';
        }
        field(13; "Descuento a Padres de Familia"; Decimal)
        {
            Caption = 'Family Discount';

            trigger OnValidate()
            begin
                if rUserSetup.Get(UserId) then begin
                    if not rUserSetup."Permite modificar Cupon" then
                        TestField(Impreso, false)
                    else begin
                        rLinCupon.Reset;
                        rLinCupon.SetRange("No. Cupon", "No. Cupon");
                        if rLinCupon.FindSet then
                            repeat
                                rLinCupon.Validate("% Descuento", "Descuento a Padres de Familia");
                                rLinCupon.Modify;
                            until rLinCupon.Next = 0;
                    end;
                end
                else
                    TestField(Impreso, false);
            end;
        }
        field(14; "Campaña"; Code[20])
        {
            Caption = 'Campaing';
            TableRelation = Campaign;

            trigger OnValidate()
            begin
                rAnoEscolar.Get(Campaña);
                rAnoEscolar.TestField("Fecha Desde");
                rAnoEscolar.TestField("Fecha Hasta");
                Validate("Valido Desde", rAnoEscolar."Fecha Desde");
                Validate("Valido Hasta", rAnoEscolar."Fecha Hasta");
            end;
        }
        field(15; Pendiente; Boolean)
        {
            CalcFormula = Exist("Lin. Cupon." WHERE("No. Cupon" = FIELD("No. Cupon"),
                                                     "Cantidad Pendiente" = FILTER(<> 0)));
            Caption = 'Open';
            FieldClass = FlowField;
        }
        field(16; "No. Lote"; Integer)
        {
            Caption = 'Lot No.';
        }
        field(17; Descripcion; Text[250])
        {
            Caption = 'Description';
        }
        field(18; "Razon Anulacion"; Text[250])
        {
            Caption = 'Void Reason';
        }
        field(19; Anulado; Boolean)
        {
            Caption = 'Void';
        }
        field(20; "Fecha Creacion"; Date)
        {
            Caption = 'Creation Date';
        }
        field(21; "Hora Creacion"; Time)
        {
            Caption = 'Creation Time';
        }
        field(22; "Creado por Usuario"; Code[20])
        {
            Caption = 'Created By User';
        }
        field(23; "Cod. Grado"; Code[20])
        {
            Caption = 'Grade Code';
        }
        field(24; "Descripcion Grado"; Text[50])
        {
            Caption = 'Grade Description';
        }
        field(76228; "Source Counter POS"; Integer)
        {
            Caption = 'Source Counter POS';
            Description = 'DsPOS Standard';
        }
    }

    keys
    {
        key(Key1; "No. Cupon")
        {
            Clustered = true;
        }
        key(Key2; "No. Lote")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestField(Impreso, false);
        rLinCupon.Reset;
        rLinCupon.SetRange("No. Cupon", "No. Cupon");
        rLinCupon.DeleteAll;
    end;

    trigger OnInsert()
    begin
        if "No. Cupon" = '' then begin
            rConfEmpresa.Get;
            rConfEmpresa.TestField("No. serie Cupon");
            //NoSeriesMgt.InitSeries(rConfEmpresa."No. serie Cupon", xRec."No. Series", 0D, "No. Cupon", "No. Series");
            Rec."No. serieS" := rConfEmpresa."No. serie Cupon";
            if NoSeriesMgt.AreRelated(rConfEmpresa."No. serie Cupon", xRec."No. Series") then
                Rec."No. Series" := xRec."No. Series";
            Rec."No. cupon" := NoSeriesMgt.GetNextNo(Rec."No. Series");
        end;

        "Source Counter POS" := 1;
    end;

    trigger OnModify()
    begin
        if rUserSetup.Get(UserId) then begin
            if not rUserSetup."Permite modificar Cupon" then
                TestField(Impreso, false);
        end
        else
            TestField(Impreso, false);

        "Source Counter POS" := 1;
    end;

    trigger OnRename()
    begin
        TestField(Impreso, false);
    end;

    var
        rConfEmpresa: Record "Config. Empresa";
        NoSeriesMgt: Codeunit "No. Series";
        rCliente: Record Customer;
        rContacto: Record Contact;
        rAnoEscolar: Record "Año Escolar.";
        rLinCupon: Record "Lin. Cupon.";
        rUserSetup: Record "User Setup";


    procedure AssistEdit(OldCabCupon: Record "Cab. Cupon."): Boolean
    var
        rCabCupon: Record "Cab. Cupon.";
    begin
        rCabCupon := Rec;
        rConfEmpresa.Get;
        rConfEmpresa.TestField("No. serie Cupon");
        if NoSeriesMgt.LookupRelatedNoSeries(rConfEmpresa."No. serie Cupon", OldCabCupon."No. Series", "No. Series") then begin
            NoSeriesMgt.GetNextNo("No. Cupon");
            Rec := rCabCupon;
            exit(true);
        end;
    end;
}

