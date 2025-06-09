tableextension 50107 tableextension50107 extends "Fixed Asset"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Description 2"(Field 4)".

        modify("Global Dimension 1 Code")
        {
            Caption = 'Global Dimension 1 Code';
        }
        modify("Global Dimension 2 Code")
        {
            Caption = 'Global Dimension 2 Code';
        }
        modify("Serial No.")
        {
            Description = '#61943';
            //Unsupported feature: Code Insertion on ""Serial No."(Field 17)".
            trigger OnBeforeValidate()
            var
                FixedAsset: Record "Fixed Asset";
            begin
                //#61943
                FixedAsset.Reset;
                FixedAsset.SetRange("Serial No.", "Serial No.");
                if FixedAsset.FindFirst then
                    Error(Error001, FixedAsset.FieldCaption("Serial No."), "Serial No.");
            end;
        }

        //Unsupported feature: Code Insertion on ""Responsible Employee"(Field 16)".
        modify("Responsible Employee")
        {
            trigger OnBeforeValidate()
            begin
                if "Responsible Employee" <> '' then begin
                    Empl.Get("Responsible Employee");
                    "Nombre Responsable" := Empl."Full Name";
                end;
            end;
        }

        //Unsupported feature: Code Insertion on "Blocked(Field 21)".
        modify(Blocked)
        {
            trigger OnBeforeValidate()
            var
                myInt: Integer;
            begin
                //004
                if UserSetUp.Get(UserId) then begin
                    if not UserSetUp."Desbloquea Activos Fijos" then
                        Error(Text016);
                    if Blocked = true then begin
                        ValidaCampos.Maestros(5600, "No.");
                        ValidaCampos.Dimensiones(5600, "No.", 0, 0);
                    end;
                end
                else
                    Error(Text016);
                //004
            end;
        }


        //Unsupported feature: Code Insertion on "Inactive(Field 26)".
        modify(Inactive)
        {
            trigger OnBeforeValidate()
            var
                UserSetup: Record "User Setup";
                lErrorPermisos: Label 'No dispone de los permisos necesarios para Activar/Desactivar el activo.';
            begin
                //+001
                if not (UserSetup.Get(UserId) and UserSetup."Activa/Inactiva Maestros") then
                    Error(lErrorPermisos);

                if Inactive then begin
                    FADeprBook.SetCurrentKey("FA No.");
                    FADeprBook.SetRange("FA No.", "No.");
                    FADeprBook.SetRange("Disposal Date", 0D);
                    if FADeprBook.FindFirst then
                        Error(Text50000, FADeprBook.TableCaption);
                end;
                //-001
            end;
        }

        //Unsupported feature: Deletion (FieldCollection) on ""Vehicle Licence Plate"(Field 10001)".

        //Unsupported feature: Deletion (FieldCollection) on ""Vehicle Year"(Field 10002)".

        //Unsupported feature: Deletion (FieldCollection) on ""SAT Federal Autotransport"(Field 10004)".

        //Unsupported feature: Deletion (FieldCollection) on ""SAT Trailer Type"(Field 10005)".

        field(50000; Producto; Code[20])
        {
            Caption = 'Item';
            DataClassification = ToBeClassified;
            TableRelation = Item;
        }
        field(50001; "No. Placa"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Total Costo"; Decimal)
        {
            CalcFormula = Sum("FA Ledger Entry".Amount WHERE("FA No." = FIELD("No."),
                                                              "FA Posting Type" = CONST("Acquisition Cost"),
                                                              "FA Posting Date" = FIELD("FA Posting Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "Total Amortizacion"; Decimal)
        {
            CalcFormula = Sum("FA Ledger Entry".Amount WHERE("FA No." = FIELD("No."),
                                                              "FA Posting Type" = CONST(Depreciation),
                                                              "FA Posting Date" = FIELD("FA Posting Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "Cod. Barras"; Code[22])
        {
            Caption = 'Cross reference no.';
            DataClassification = ToBeClassified;
            Description = '#61943';

            trigger OnValidate()
            var
                FixedAsset: Record "Fixed Asset";
            begin
                //#61943
                FixedAsset.Reset;
                FixedAsset.SetRange("Cod. Barras", "Cod. Barras");
                if FixedAsset.FindFirst then
                    Error(Error001, FixedAsset.FieldCaption("Cod. Barras"), "Cod. Barras");
            end;
        }
        field(50005; "Nombre Responsable"; Text[60])
        {
            Caption = 'Responsible Name';
            DataClassification = ToBeClassified;
        }
    }


    //Unsupported feature: Code Modification on "OnInsert".
    trigger OnAfterInsert()
    var
        myInt: Integer;
    begin
        //001
        ConfEmpresa.Get();
        if ConfEmpresa."Activos Fijos Nuevos Bloqueado" then
            Blocked := true;
        //001
    end;

    var
        FADeprBook: Record "FA Depreciation Book";

    var
        UserSetUp: Record "User Setup";
        ConfEmpresa: Record "Config. Empresa";
        ValidaCampos: Codeunit "Valida Campos Requeridos";
        Empl: Record Employee;
        Text016: Label 'User cannot unlock Fixed Assent';
        Error001: Label 'El %1 "%2", ya se usa para otro Activo Fijo';
        Text50000: Label 'No se puede inactivar hasta que todos los "%1" del activo estén de baja o vendidos.';
}

