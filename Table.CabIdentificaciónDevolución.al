table 56015 "Cab. Identificación Devolución"
{
    DrillDownPageID = "Captura Cantidad";
    LookupPageID = "Captura Cantidad";

    fields
    {
        field(1; "No. Ident. Devolucion"; Code[20])
        {
            Caption = 'Return Identifier No.';

            trigger OnValidate()
            begin
                SalesSetup.Get;
                NoSeriesMgt.TestManual(SalesSetup."No. Serie Ident. Devolucion");
            end;
        }
        field(2; "Id. Usuario"; Code[50])
        {
            Caption = 'User ID';
        }
        field(3; "Cod. Cliente"; Code[20])
        {
            Caption = 'Customer Code';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                if Cust.Get("Cod. Cliente") then
                    "Nombre Cliente" := Cust.Name
                else
                    "Nombre Cliente" := '';
            end;
        }
        field(4; "Nombre Cliente"; Text[100])
        {
            Caption = 'Customer Name';
            Description = '#56924';
        }
        field(5; "Cantidad de Bultos"; Integer)
        {
            Caption = 'Number of Packages';

            trigger OnValidate()
            begin
                LID.Reset;
                LID.SetRange("No. Ident. Devolucion", "No. Ident. Devolucion");
                if LID.FindFirst then
                    Error(txt001);
            end;
        }
        field(6; Comentarios; Text[250])
        {
            Caption = 'Comments';
        }
        field(7; "Fecha Recepcion"; Date)
        {
            Caption = 'Receipt Date';
        }
        field(8; "Fecha Registro"; Date)
        {
            Caption = 'Posting Date';
        }
        field(9; "Agencia Transporte"; Text[100])
        {
            Caption = 'Transportation Agency';
        }
        field(10; "Tipo de Producto"; Option)
        {
            Caption = 'Product Type';
            OptionCaption = ' ,Text,Not Text,Mixed';
            OptionMembers = " ",Texto,"No Texto",Mixta;
        }
        field(11; Ubicacion; Text[250])
        {
            Caption = 'Place';
        }
        field(12; Almacen; Code[20])
        {
            Caption = 'Location';
            TableRelation = Location;
        }
    }

    keys
    {
        key(Key1; "No. Ident. Devolucion")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        LID.Reset;
        LID.SetRange("No. Ident. Devolucion", "No. Ident. Devolucion");
        LID.DeleteAll;
    end;

    trigger OnInsert()
    begin
        WE.Reset;
        WE.SetRange("User ID", UserId);
        WE.SetRange(Default, true);
        if WE.FindFirst then
            Almacen := WE."Location Code";

        "Fecha Recepcion" := WorkDate;
        "Fecha Registro" := WorkDate;
        "Id. Usuario" := UserId;
        if "No. Ident. Devolucion" = '' then begin
            SalesSetup.Get;
            TestNoSeries;
            /*NoSeriesMgt.InitSeries(GetNoSeriesCode, "No. Ident. Devolucion", "Fecha Registro", "No. Ident. Devolucion",
                                    SalesSetup."No. Serie Ident. Devolucion");*/
            if NoSeriesMgt.AreRelated(GetNoSeriesCode, Rec."No. Ident. Devolucion") then
                SalesSetup."No. Serie Ident. Devolucion" := Rec."No. Ident. Devolucion";
            Rec."No. Ident. Devolucion" := NoSeriesMgt.GetNextNo(SalesSetup."No. Serie Ident. Devolucion");
        end;
    end;

    var
        NoSeriesMgt: Codeunit "No. Series";
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
        LID: Record "Lin. Identificación Devolución";
        txt001: Label 'You can not change the amount of packages you have created lines';
        WE: Record "Warehouse Employee";


    procedure TestNoSeries()
    begin
        SalesSetup.TestField("No. Serie Ident. Devolucion");
        SalesSetup.TestField(SalesSetup."No. Serie Ident. Dev. Reg.");
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        exit(SalesSetup."No. Serie Ident. Devolucion");
    end;
}

