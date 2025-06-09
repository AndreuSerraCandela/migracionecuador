table 56033 "Cab. Packing Registrado"
{
    Caption = 'Posted Packing Header';
    LookupPageID = "Seguimientos Peds. Transfer.";

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "Cod. Empleado"; Code[50])
        {
            Caption = 'Employee Code';

            trigger OnLookup()
            begin
                ValidateEmployeeCode("Cod. Empleado");
            end;

            trigger OnValidate()
            begin
                ValidateEmployeeCode("Cod. Empleado");
            end;
        }
        field(3; "No. Mesa"; Code[20])
        {
            Caption = 'Table No.';
        }
        field(4; "Picking No."; Code[20])
        {
            Caption = 'No. Picking';
            TableRelation = "Registered Whse. Activity Hdr."."No." WHERE(Type = FILTER(Pick));

            trigger OnValidate()
            begin
                CCP.Reset;
                CCP.SetRange("No. Packing", "No.");
                if CCP.FindFirst then
                    Error(txt001);

                LinPack.Reset;
                LinPack.SetRange("No.", "No.");
                if LinPack.FindSet then
                    repeat
                        LinPack.Validate("No. Picking", "Picking No.");
                        LinPack.Modify(true);
                    until LinPack.Next = 0;
            end;
        }
        field(5; "Fecha Apertura"; Date)
        {
            Caption = 'Opening Date';
        }
        field(6; "Fecha Registro"; Date)
        {
        }
        field(7; "No. Packing Origen"; Code[20])
        {
            Caption = 'Packing No. Origin';
        }
        field(8; "Total de Productos"; Decimal)
        {
            CalcFormula = Sum("Contenido Cajas Packing Reg.".Cantidad WHERE("No. Packing" = FIELD("No.")));
            Caption = 'Items Total';
            FieldClass = FlowField;
        }
        field(9; "Hora Finalizacion"; Time)
        {
            Caption = 'End Time';
        }
        field(10; "Cantidad de Bultos"; Integer)
        {
            CalcFormula = Count("Lin. Packing Registrada" WHERE("No." = FIELD("No."),
                                                                 "No. Picking" = FIELD("Picking No.")));
            Caption = 'Packages Qty.';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        LinPack.Reset;
        LinPack.SetRange("No.", "No.");
        LinPack.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        "Fecha Apertura" := WorkDate;
        "Cod. Empleado" := UserId;

        if "No." = '' then begin
            ConfSant.Get;
            ConfSant.TestField("No. Serie Packing");
            /*NoSeriesMgt.InitSeries(ConfSant."No. Serie Packing", "No.", "Fecha Apertura", "No.",
                                    ConfSant."No. Serie Packing");*/
            if NoSeriesMgt.AreRelated(ConfSant."No. Serie Packing", Rec."No.") then
                ConfSant."No. Serie Packing" := Rec."No.";
            Rec."No." := NoSeriesMgt.GetNextNo(ConfSant."No. Serie Packing");
        end;
    end;

    var
        NoSeriesMgt: Codeunit "No. Series";
        ConfSant: Record "Config. Empresa";
        LinPack: Record "Lin. Packing";
        LoginMgt: Codeunit "User Management";
        CCP: Record "Contenido Cajas Packing";
        txt001: Label 'Picking No. cannot be changed while exists boxes with content in the current Packing';

    local procedure ValidateEmployeeCode(UserID: Code[50])
    var
        UserRec: Record User;
    begin
        if UserID = '' then
            exit;

        if not UserRec.Get(UserID) then
            Error('Employee code %1 does not exist.', UserID);
    end;
}

